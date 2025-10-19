unit LinkUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  LoggingUnit,
  EntityUnit,
  LinkSettingsUnit;

type

  TLinkType = (
    ltUnknown,
    ltDirDown,
    ltDirUp,
    ltFtpClientDown,
    ltFtpClientUp,
    ltFtpServerDown,
    ltFtpServerUp,
    ltOpenMCEP,
    ltPop3ClientDown,
    ltSmtpCliUp,
    ltSmtpSrvDown,
    ltSocketSpecial,
    ltHttpClientDown,
    ltSebaSgsClientDown,
    ltSebaUsrCsdClientDown
    );

  // TLink абстрактный
  TLink = class (TEntity)
  private
    FDir: string;
    FStatus: string;
    FComsts: string;
    FLastActivityTime: int64;
    function GetLid: string;
    procedure SetLid(const Value: string);
    function GetTypeStr: string;
    function GetLinkType: TLinkType;

  protected
    ///  потомок должен вернуть имя поля для идентификатора
    function GetIdKey: string; override;
    ///  метод возвращает конкретный тип объекта Settings
    ///  потомки должны переопределить его, потому что он у всех разный
    class function DataClassType: TDataClass; override;

  public
    function Assign(ASource: TFieldSet): boolean; override;

    // эти требуют существующего правильного экземпляра объекта. на ошибки - эксешан
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    // идентификатор линка
    property Lid: string read GetLid write SetLid;
    /// тип линка
    property LinkType: TLinkType read GetLinkType;
    /// тип линка строкой
    property TypeStr: string read GetTypeStr;
    // Dir направление upload|download|duplex
    property Dir: string read FDir write FDir;
    // Status unknown|starting|stopping|stopped|running|error|halt|unavailable
    property Status: string read FStatus write FStatus;
    // Comsts disconnected|connecting|connected|unknown
    property Comsts: string read FComsts write FComsts;
    // LastActivityTime послений раз когда была активность линка
    property LastActivityTime: int64 read FLastActivityTime write FLastActivityTime;

  end;

type
  ///  список задач
  TLinkList = class (TEntityList)
    ///  метод возвращает конкретный тип объекта элемента списка
    ///  потомки должны переопределить его, потому что он у всех разный
    class function ItemClassType: TEntityClass; override;

  end;

type
  /// класс Data для Линков
  TLinkData = class(TData)
  private
    FAutostart: boolean;
    FDataSettings: TDataSettings;
    FLinkType: TLinkType;
    FSnapshot: string;
    procedure SetLinkType(const Value: TLinkType);

  public
    constructor Create(); override;
    destructor Destroy(); override;

    // эти требуют существующего правильного экземпляра объекта. на ошибки - эксешан
    ///  в массиве const APropertyNames передаются поля, которые необходимо использовать
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    /// возвращает тип линка в виде строки
    function LinkTypeStr: string;

    // для поля autostart
    property Autostart: boolean read FAutostart write FAutostart;
    // Snapshot рабочие данные линка хранящиеся в ядре. для фронта readonly
    property Snapshot: string read FSnapshot write FSnapshot;    
    ///  для поля Settings
    property DataSettings: TDataSettings read FDataSettings write FDataSettings;
    // TypeStr тип линка например SOCKET_SPECIAL
    property LinkType: TLinkType read FLinkType write SetLinkType;


  end;

implementation

uses
  System.SysUtils, 
  FuncUnit, KeyValUnit;

const
  LidKey = 'lid';
  TypeStrKey = 'type';
  DirKey = 'dir';
  QidKey = 'qid';
  StatusKey = 'status';
  ComstsKey = 'comsts';
  LastActivityTimeKey= 'last_activity_time';

  AutostartKey = 'autostart';
  SnapshotKey = 'snapshot';
  SettingsKey = 'settings';

var
  // LinkType2Str строка = TLinkType
  LinkType2Str: TKeyValue<TLinkType>;

{ TLink }

function TLink.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;
  if not inherited Assign(ASource) then
    exit;
  if not (ASource is TLink) then
    exit;
  var src := ASource as TLink;
  Dir := src.Dir;
  Status := src.Status;
  Comsts := src.Comsts;
  LastActivityTime := src.LastActivityTime;
  result := true;
end;

function TLink.GetLid: string;
begin
  Result := Id;
end;

function TLink.GetLinkType: TLinkType;
begin
  Result := (Data as TLinkData).LinkType;
end;

function TLink.GetTypeStr: string;
begin
  Result := (Data as TLinkData).LinkTypeStr();
end;

procedure TLink.SetLid(const Value: string);
begin
  Id := Value;
end;

class function TLink.DataClassType: TDataClass;
begin
  Result := TLinkData;
end;

///  метод возвращает наименование ключа идентификатора который используется
///  для данной сущности (у каждого он может быть свой)
function TLink.GetIdKey: string;
begin
  ///  имя поля идентификатора Lid
  Result := LidKey;
end;

procedure TLink.Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil);
begin
  ///  санчала читаем поле типа и в зависимоти от него создаем нужный класс настроек
  ///  читаем поле TypeStr
  var ts := GetValueStrDef(src, TypeStrKey, '');

  (Data as TLinkData).LinkType := LinkType2Str.ValueByKey(ts, ltUnknown);

  inherited Parse(src);

  ///  читаем поле Dir
  Dir := GetValueStrDef(src, DirKey, '');
  ///  читаем поле Status
  Status := GetValueStrDef(src, StatusKey, '');
  ///  читаем поле Comsts
  Comsts := GetValueStrDef(src, ComstsKey, '');
  ///  читаем поле LastActivityTime
  LastActivityTime := GetValueIntDef(src, LastActivityTimeKey, 0);

end;

procedure TLink.Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil);
begin
  inherited Serialize(dst);
  dst.AddPair(TypeStrKey, (Data as TLinkData).LinkTypeStr);
  dst.AddPair(DirKey, Dir);
  dst.AddPair(StatusKey, Status);
  dst.AddPair(ComstsKey, Comsts);
  dst.AddPair(LastActivityTimeKey, LastActivityTime);
end;

{ TLinkData }

constructor TLinkData.Create;
begin
  inherited Create();
  ///  создаем секцию Settings
  FDataSettings := TDataSettings.Create();
end;

destructor TLinkData.Destroy;
begin
  FreeAndNil(DataSettings);
  inherited;
end;

function TLinkData.LinkTypeStr: string;
begin
  result := LinkType2Str.KeyByValue(LinkType, 'UNKNOWN');
end;

procedure TLinkData.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  Autostart := GetValueBool(src, AutostartKey);
  Snapshot := GetValueStrDef(src, SnapshotKey, '');
  var s := src.GetValue(SettingsKey);
  if not (s is TJSONObject) then
    exit;
  ///  добавляем поля Settings
  var dso := s as TJSONObject;
  ///  передаем в DataSettings
  if DataSettings <> nil then
    DataSettings.Parse(dso);
end;

procedure TLinkData.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  dst.AddPair(AutostartKey, Autostart);
  ///  добавляем настройки settings в объект data
  if DataSettings <> nil then
    dst.AddPair(SettingsKey, DataSettings.Serialize());
end;


procedure TLinkData.SetLinkType(const Value: TLinkType);
begin
  if Assigned(FDataSettings) then
    FreeAndNil(FDataSettings);
  FLinkType := Value;
  ///  в зависимости от типа устанавливаем различные настройки
  case Value of
    ltDirDown: FDataSettings := TDirDownDataSettings.Create();
    ltDirUp: FDataSettings := TDirUpDataSettings.Create();
    ltOpenMCEP: FDataSettings := TOpenMCEPDataSettings.Create();
    ltSocketSpecial: FDataSettings := TSocketSpecialDataSettings.Create();
    ltFtpClientDown: FDataSettings := TFtpCliDownDataSettings.Create();
    ltFtpClientUp: FDataSettings := TFtpCliUpDataSettings.Create();
    ltFtpServerDown: FDataSettings := TFtpSrvDownDataSettings.Create();
    ltFtpServerUp: FDataSettings := TFtpSrvUpDataSettings.Create();
    ltPop3ClientDown: FDataSettings := TPop3CliDownDataSettings.Create();
    ltSmtpCliUp: FDataSettings := TSmtpCliUpDataSettings.Create();
    ltSmtpSrvDown: FDataSettings := TSmtpSrvDownDataSettings.Create();
    ltHttpClientDown: FDataSettings := THttpCliDownDataSettings.Create();
    ltSebaSgsClientDown:  FDataSettings := TSebaSgsCliDownDataSettings.Create();
    ltSebaUsrCsdClientDown: FDataSettings := TSebaUsrCsdCliDownDataSettings.Create();
    else FLinkType :=  ltUnknown;
  end;
end;

{ TLinkList }

class function TLinkList.ItemClassType: TEntityClass;
begin
  Result := TLink;
end;


initialization
  LinkType2Str := TKeyValue<TLinkType>.Create;
  LinkType2Str.Add('DIR_DOWN', ltDirDown);
  LinkType2Str.Add('DIR_UP', ltDirUp);
  LinkType2Str.Add('FTP_CLIENT_DOWN', ltFtpClientDown);
  LinkType2Str.Add('FTP_CLIENT_UP', ltFtpClientUp);
  LinkType2Str.Add('FTP_SERVER_DOWN', ltFtpServerDown);
  LinkType2Str.Add('FTP_SERVER_UP', ltFtpServerUp);
  LinkType2Str.Add('OPENMCEP', ltOpenMCEP);
  LinkType2Str.Add('POP3_CLI_DOWN', ltPop3ClientDown);
  LinkType2Str.Add('SMTP_CLI_UP', ltSmtpCliUp);
  LinkType2Str.Add('SMTP_SRV_DOWN', ltSmtpSrvDown);
  LinkType2Str.Add('SOCKET_SPECIAL', ltSocketSpecial);
  LinkType2Str.Add('HTTP_CLIENT_DOWN', ltHttpClientDown);
  LinkType2Str.Add('SEBA_SGS_CLIENT_DOWN', ltSebaSgsClientDown);
  LinkType2Str.Add('SEBA_USR_CSD_CLIENT_DOWN', ltSebaUsrCsdClientDown);                      

finalization
  LinkType2Str.Free;

end.