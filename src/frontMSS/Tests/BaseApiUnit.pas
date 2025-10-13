unit BaseApiUnit;

interface

uses
  SysUtils, Classes, IdHTTP;

const
  X_TICKET = 'ST-Test';

type
  // Базовый класс для различных микросервисов
  TBaseAPI = class (TObject)
  private
    FHttp: TIdHTTP;         // инди-движок запросов
    FBaseUrl: string;       // базовый путь (от протокола до версии апи) - задается в конструкторе
    FStream: TStringStream; // стрим для Зщые-запросов
  protected
    FApiVer: Integer;       // версия АПИ (задавать в наследнике)

    // рабочие методы для Get/Post-вызовов из потомков
    function ExecGet(AEndPoint: string): string;
    function ExecPost(AEndPoint, ABody: string): string;
  public
    constructor Create(ABaseUrl: string); virtual;
    destructor Destroy;
  end;

// конкатенация строки URL
procedure AppendURI(var URI: string; const param: string); overload;
procedure AppendURI(var URI: string; const params: array of const); overload;


implementation

function VarRecToStr(const AVarRec : TVarRec ) : string;
const
  Bool : array[Boolean] of string = ('0', '1');
begin
  case AVarRec.VType of
    vtInteger,
    vtInt64  :    Result := IntToStr(AVarRec.VInteger);
    vtBoolean:    Result := Bool[AVarRec.VBoolean];
    vtChar:       Result := AVarRec.VChar;
    vtExtended:   Result := FloatToStr(AVarRec.VExtended^);
    vtString:     Result := AVarRec.VString^;
    vtPChar:      Result := AVarRec.VPChar;
    vtObject:     Result := AVarRec.VObject.ClassName;
    vtClass:      Result := AVarRec.VClass.ClassName;

    vtAnsiString: Result := string(AVarRec.VAnsiString);
    vtCurrency:   Result := CurrToStr(AVarRec.VCurrency^);
    vtVariant:    Result := string(AVarRec.VVariant^);
    vtWideString: Result := string(AVarRec.VWideString);
    vtWideChar :  Result := AVarRec.VWideChar;

    vtUnicodeString: Result := UnicodeString(AVarRec.VUnicodeString);
  else
    Result := '';
  end;
end;


procedure AppendURI(var URI: string; const param: string); overload;
begin
  if (Pos('?', URI) > 0) then
  begin
    if URI[Length(URI)] = '=' then
      URI := URI + param
    else if (Pos('=',param) > 0) then
      URI := URI + '&' + param
    else
      URI := URI + '%2C' + param;
  end
  else
    URI := URI + '?' + param;
end;

procedure AppendURI(var URI: string; const params: array of const);
var
  i, len,h : integer;
  param: string;
begin
  len := Length(params);
  h := len-1;
  if (len < 1) then
    Exit;

  i := 0;
  if (len > 0) then
  repeat
    param := VarRecToStr(params[i]);
    if (i < h) then
    begin
      Inc(i);
      param := param + '=' + VarRecToStr(params[i]);
    end;
    AppendURI(URI,param);
    Inc(i);
  until (i > h);
end;



{ TBaseAPI }

constructor TBaseAPI.Create(ABaseUrl: string);
begin
  inherited Create;

  FApiVer := 0;
  FBaseUrl := ABaseUrl;
  FStream := TStringStream.Create;

  FHttp := TIdHTTP.Create(nil);
  FHTTP.Request.CustomHeaders.AddValue('X-Ticket', X_TICKET);
  FHTTP.Request.Accept := 'application/json';
  FHTTP.Request.ContentType := 'application/json';
  FHTTP.Request.ContentEncoding := 'utf-8';
  // FHTTP.ConnectTimeout := 5000;
  // FHTTP.ReadTimeout := 10000;
end;

destructor TBaseAPI.Destroy;
begin
  FreeAndNil(FStream);
  FreeAndNil(FHttp);
  inherited;
end;

function TBaseAPI.ExecGet(AEndPoint: string): string;
var
  mURI: string;
begin
  // формируем полный URL
  if FApiVer > 0 then
    mURI := Format('%s/api/v%d/%s', [FBaseUrl, FApiVer, AEndPoint])
  else
    mURI := Format('%s/%s', [FBaseUrl, AEndPoint]);

  // отправляем запрос
  Result := FHttp.Get(mURI);
end;

function TBaseAPI.ExecPost(AEndPoint, ABody: string): string;
var
  mURI: string;
begin
  // формируем полный URL
  if FApiVer > 0 then
    mURI := Format('%s/api/v%d/%s', [FBaseUrl, FApiVer, AEndPoint])
  else
    mURI := Format('%s/%s', [FBaseUrl, AEndPoint]);

  // тело запроса переписываем в стрим (если передавать строкой, инди считает, что это имя файла)
  FStream.Clear;
  FStream.WriteString(ABody);

  // отправляем запрос
  Result := FHttp.Post(mURI, FStream);
end;

end.
