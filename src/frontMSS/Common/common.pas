unit Common;

interface

uses
  Classes,
  {$ifdef mswindows}
  Windows,
  {$else}
  BaseUnix,
  {$endif}
  StrUtils, DateUtils, SysUtils;
const
  // перевод строки независимо от ос
  CR = #13;
  LF = #10;
  CRLF = CR+LF;

function GenerateGuid: string;
procedure StringToStream(s: string; stream: TStream);
function IndexOfString(arr: TArray<string>; val: string): integer;
// DefinedGUID true если гуид не нулевой и не пустой
function DefinedGUID(guid: string): boolean;
// SeparateQuery вернёт строковый json массив из строки формата "abc,def" -> ["abc", "def"]
function DateTimeToUnix(ATime: TDateTime): int64;
function NowUTCUnix(): int64;
function NowUTC: TDateTime;
function NowUTCISO8601: string;
function LoadFromFile(path: string): string;
// WithTrailing добавить в конец строки символ(ы) если его там нету
function WithTrailing(s, ending: string): string;
// IsTempraryFile вернёт true еси имя фалйла похоже на временный
function  IsTempraryFile(name: string): boolean;
// SubstituteURLRegexp заменить подстроки типа {iday} на текущую дату
function SubstituteURLRegexp(field: string): string;
// последняя системная ошибка
function LastError: string;
// загрузить файл в строку
function  Load(FileName: string): string;
// сохранить строку в файл
procedure Save(Data, FileName: string);
// получить расширение файла без точки

// проверяет формат идентификатора источника
function ValidateSID(ASid: string):Boolean;
// проверяет формат типа uuid
function ValidateUUID(AUUID: string) : Boolean;
// проверяет формат заголовка WAREP
function ValidateAHD(ahd: string): boolean;

// получить размер файла
function  FileSize(FilePath: String): int64;

type

  TFile = class
  private
    FName: string;
    FPath: string;
    FSize: integer;
    FHash: string;
    FTime: Int64;
  protected
    function GetExt: string; virtual;
    function GetPathName: string; virtual;
    procedure SetExt(AValue: string); virtual;
    procedure SetPathName(AValue: string); virtual;
  public
    // можно сразу передать параметры. можно не передавать ).
    constructor Create(PathName: string = ''; Size: integer = 0; Hash: string = ''; Time: Int64 = 0); virtual;
    // загрузить все параметры из существующиего файла
    procedure  Load(PathName: string); virtual;
    // имя файла без пути
    property  Name: string read FName write FName;
    // только путь
    property  Path: string read FPath write FPath;
    // расширение c точкой
    property  Ext: string read GetExt write SetExt;
    // путь + имя
    property  PathName: string read GetPathName write SetPathName;
    // размер
    property  Size: integer read FSize write FSize;
    // MD5 хеш
    property  Hash: string read FHash write FHash;

    property Time: Int64 read FTime write FTime;

    // создаст и вернёт TFileStream на файл по PathName.
    // если файла нет то создаст пустой.
    // если не удалось эксепшн
    function  GetStream: TFileStream; virtual;
    // посчитать хеш. затем он доступен через Hash. файл должен существовать
    procedure CalculateHash; virtual;
    // получить тело, закодированное в бейс 64
    function  GetBodyBase64: string;
    // файл физически существует на диске?
    function  Exists: boolean; virtual;
    // создать копию
    function  Clone: TFile; virtual;
  end;

  // массив файлов

  { TFiles }

  TFiles = class(TList)
  protected
    function  Get(Index: Integer): TFile;
    procedure Put(Index: Integer; Item: TFile);
  public
    // в деструкторе уничтожаются все объекты!
    destructor Destroy; override;
    property  Items[Index: Integer]: TFile read Get write Put; default;
    // очистить список с уничстожением объектов
    procedure Clear; virtual;
    // последний
    function Last: TFile; virtual;
    // получить файлы из папки. CalculateHash - посчитать сразу MD5 хеш для каждого
    // вернёт сколько прочиталось
    function GetFilesList(Folder: string; CalculateHash: boolean = true; subfolders: boolean = false): integer;
    // сортирует файлы в списке по времени
    procedure SortByTime;
    // выдает список файлов как TStrings)
    function FillStrings(AStrings: TStrings): Integer;
  end;

implementation

uses
  uSynRegExpr, Math;


function ValidateSID( ASid : string):Boolean;
begin
  result := ExecRegExpr('^\w{4}-\w{6}-\d{4}$', ASid);
end;

function ValidateUUID(AUUID: string): Boolean;
begin
 result := ExecRegExpr('^[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}$', AUUID)
end;

{ TODO : сейчас только WMO}
function ValidateAHD( ahd :string):boolean;
begin
  result := ExecRegExpr('^[A-Z]{4}\d{2}\s[A-Z]{4}$', ahd);
end;


function IndexOfString(arr: TArray<string>; val: string): integer;
var
  i: integer;
begin
  for i := 0 to length(arr)-1 do
    if arr[i] = val then
    begin
      result := i;
      exit;
    end;
  result := -1;
end;

{$IFDEF LINUX}

function FileSize(FilePath: String): int64;
var
  Info : TSearchRec;
begin
  Result := -1;
  if FindFirst(FilePath, faAnyFile-faDirectory, Info) = 0 then
  begin
    Result := Info.SIze;
    FindClose(Info);
  end;
end;

{$ELSE}

function FileSize(FilePath: String): int64;
var
  Fs: TFileStream;
begin
  Result := -1;
  if not FileExists(FilePath) then
    Exit;
  try
    Fs := TFileStream.Create(FilePath, fmOpenRead or fmShareDenyNone);
    try
      result := Fs.size;
    finally
      Fs.free;
    end;
  except
  end;
end;

{$ENDIF}

function  GenerateGuid: string;
var
  g: TGuid;
begin
  if CreateGUID(g) <> S_OK then
    raise Exception.Create('GenerateGuid failed');
  result := GUIDToString(g);
  Delete(result, 1, 1);
  Delete(result, Length(result), 1);
  result := LowerCase(result);
end;

procedure StringToStream(s: string; stream: TStream);
begin
  stream.WriteBuffer(s[1], length(s));
end;


function DefinedGUID(guid: string): boolean;
begin
  result := (length(guid) = 36) and (guid <> '00000000-0000-0000-0000-000000000000');
end;


function DateTimeToUnix(ATime: TDateTime): int64;
var
  i: int64;
begin
  i := Round((ATime - 25569) * 86400);
  if i < 0 then
    i := 0;
  Result := i;
end;

function NowUTCUnix: int64;
begin
  result := DateTimeToUnix(nowUTC);
end;

function NowUTC: TDateTime;
begin
  Result := TTimeZone.Local.ToUniversalTime(Now);
end;

function NowUTCISO8601: string;
begin
  Result := FormatDateTime('yyyy-mm-dd"T"hh:nn:ss.zzz"Z"', NowUTC);
end;

function LoadFromFile(path: string): string;
var
  str: TStringStream;
begin
  str := TStringStream.Create;
  try
    str.LoadFromFile(path);
    result := str.DataString;
  finally
    str.Free;
  end;
end;

function WithTrailing(s, ending: string): string;
begin
  result := s;
  if (length(s) < length(ending)) or
     (copy(s, length(s)-length(ending)+1, length(ending)) <> ending) then
     result := result + ending;
end;

function IsTempraryFile(name: string): boolean;
var
  ext: string;
begin
  result := true;
  name := ExtractFileName(LowerCase(name));
  if length(name) > 0 then
    if name[1] = '.' then
      exit;
  ext := ExtractFileExt(name);
  if ext = '.tmp' then
    exit;
  if ext = '.temp' then
    exit;
  if ext = '.part' then
    exit;
  result := false;
end;

function SubstituteURLRegexp(field: string): string;
var
  aNow, aYesterday: TDateTime;
  day, month, year: word;
  yDay, yMonth, yYear: word;
begin
  aNow := Now();
  aYesterday := IncDay(aNow , -1);
  day := DayOf(aNow);
  month := MonthOf(aNow);
  year := YearOf(aNow);
  yDay := DayOf(aYesterday);
  yMonth := MonthOf(aYesterday);
  yYear := YearOf(aYesterday);
  result := field;
  result := StringReplace(result, '{iday}', '(?:0?[1-9]|[12]\d|3[01])', [rfReplaceAll]);
  result := StringReplace(result, '{imonth}', '(?:0?[1-9]|1[012])', [rfReplaceAll]);
  result := StringReplace(result, '{iyear4}', '(?:19\d{2}|2\d{3})', [rfReplaceAll]);
  result := StringReplace(result, '{ciday}', format('(?:%.2d|%d)', [day, day]), [rfReplaceAll]);
  result := StringReplace(result, '{cimonth}', format('(?:%.2d|%d)', [month, month]), [rfReplaceAll]);
  result := StringReplace(result, '{ciyear4}', format('(?:%.4d)', [year]), [rfReplaceAll]);
  result := StringReplace(result, '{yiday}', format('(?:%.2d|%d)', [yDay, yDay]), [rfReplaceAll]);
  result := StringReplace(result, '{yimonth}', format('(?:%.2d|%d)', [yMonth, yMonth]), [rfReplaceAll]);
  result := StringReplace(result, '{yiyear4}', format('(?:%.4d)', [yYear]), [rfReplaceAll]);
end;

function LastError: string;
var
  i: dword;
begin
  {$ifdef mswindows}
  i := GetLastError;
  {$else}
  i := fpgeterrno;
  {$endif}
  if i <> 0 then
    result := Format('system error %d %s', [i, SysErrorMessage(i)])
  else
    result:='';
end;

function Load(FileName: string): string;
var
  Fs: TFileStream;
begin
  Fs := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  try
    SetLength(Result, Fs.Size);
    if Length(Result) = 0 then
      exit;
    Fs.Read(Result[1], Fs.Size);
  finally
    FreeAndNil(Fs);
  end;
end;

procedure Save(Data, FileName: string);
var
  Fs: TFileStream;
begin
  if (FileName = '') then
    exit;
  Fs := TFileStream.Create(FileName, fmCreate or fmShareExclusive);
  try
    if Data <> '' then
      Fs.Write(Data[1], Length(Data));
  finally
    FreeAndNil(Fs);
  end;
end;


{ TFile }


constructor TFile.Create(PathName: string; Size: integer; Hash: string; Time: Int64);
begin
  if PathName <> '' then
    SetPathName(PathName);
  FSize := Size;
  FHash := Hash;
  FTime := Time;
end;



function TFile.GetPathName: string;
begin
  result := FPath + FName;
end;

function TFile.GetExt: string;
begin
  result := ExtractFileExt(FName);
end;

procedure TFile.SetExt(AValue: string);
var
  OldExt: string;
begin
  OldExt := Ext;
  if OldExt = AValue then
    exit;
  if OldExt <> '' then
    Delete(FName, Length(FName) - Length(OldExt) +1, Length(FName));
  if AValue <> '' then
  begin
    if AValue[1] <> '.' then
      AValue := '.' + AValue;
    FName := FName + AValue;
  end;
end;

procedure TFile.SetPathName(AValue: string);
begin
  FName := ExtractFileName(AValue);
  FPath := ExtractFilePath(AValue);
end;


procedure TFile.Load(PathName: string);
var
  fs: TFileStream;
begin
  SetPathName(PathName);
  CalculateHash;
  fs := GetStream;
  try
    FSize := fs.Size;
  finally
    fs.Free;
  end;
end;


function TFile.GetStream: TFileStream;
begin
  try
    result := TFileStream.Create(PathName, fmOpenWrite or fmShareExclusive);
  except
    result := TFileStream.Create(PathName, fmCreate or fmShareExclusive);
  end;
end;


procedure TFile.CalculateHash;
begin
{$IFDEF FPC}
  FHash := MDPrint( MD5File(PathName) );
{$ENDIF}
end;



function TFile.GetBodyBase64: string;
{$IFDEF FPC}
var
  Encoder: TBase64EncodingStream;
  Outstream: TStringStream;
  Fs: TFileStream;
{$ENDIF}
begin
{$IFDEF FPC}
  Outstream := TStringStream.Create('');
  Encoder := TBase64EncodingStream.Create(Outstream);
  Fs := GetStream;
  try
    Encoder.CopyFrom(Fs, Fs.Size);
    result := Outstream.DataString;
  finally
    Outstream.free;
    Encoder.Free;
    Fs.Free;
  end;
{$ENDIF}
end;

function TFile.Exists: boolean;
begin
  result := FileExists(PathName);
end;

function TFile.Clone: TFile;
begin
  result := TFile.Create(FPath + FName, FSize, FHash);
end;

{ TFiles }



destructor TFiles.Destroy;
begin
  Clear;
  inherited Destroy;
end;



function TFiles.Get(Index: Integer): TFile;
begin
  result := TFile( inherited Get(Index) );
end;

procedure TFiles.Put(Index: Integer; Item: TFile);
begin
  inherited Put(Index, Item);
end;


procedure TFiles.Clear;
var
  i: integer;
begin
  for i := 0 to Count-1 do
    Items[i].Free;
  inherited Clear;
end;


function TFiles.Last: TFile;
begin
  result := TFile(inherited Last);
end;

function TFiles.GetFilesList(Folder: string; CalculateHash: boolean;
  subfolders: boolean): integer;
var
  sr: TSearchRec;
begin
  result := 0;
  if Folder = '' then
    exit;
  Folder := IncludeTrailingPathDelimiter(Folder);
  if Findfirst(Folder + '*', faAnyFile, sr) = 0 then
  try
    repeat
      if (sr.name <> '..') and (sr.name <> '.') and (sr.name <> '') then
      begin
        if (sr.Attr and faDirectory <> faDirectory) then
        begin
          Add( TFile.Create(Folder + sr.name, sr.Size, '', sr.Time));
          if CalculateHash then
            Last.CalculateHash;
          inc(result);
        end
        else if subfolders then
          GetFilesList(Folder + sr.name, CalculateHash, True);

      end;
    until Findnext(sr)<>0;
  finally
    Findclose(sr);
  end;
end;

function ASortFilesByTime(Item1, Item2: Pointer): Integer;
begin
  Result := CompareValue(TFile(Item1).Time, TFile(Item2).Time);
end;

procedure TFiles.SortByTime;
begin
  Self.Sort(@ASortFilesByTime);
end;

function TFiles.FillStrings(AStrings: TStrings): Integer;
var
  I: Integer;
begin
  for I := 0 to Count-1 do
    AStrings.Append(Items[I].GetPathName);
end;



end.

