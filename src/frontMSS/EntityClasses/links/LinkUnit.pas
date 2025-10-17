unit LinkUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  LoggingUnit,
  EntityUnit,  
  LinkSettingsUnit;

type
  // TLink абстрактный
  TLink = class (TEntity)
  private
    FDir: string;
    FCompid: string;
    FDepid: string;
    FStatus: string;
    FComsts: string;
    FLastActivityTime: int64;
    FQid: string;
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
    // Идентификатор очереди к которой привязан Линкс
    property Qid: string read FQid write FQid;
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
  FuncUnit;

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

const
  ///  значения строки type
  OPENMCEP_type = 'OPENMCEP';
  SOCKETSPECIAL_type = 'SOCKET_SPECIAL';

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
  Compid := src.Compid;
  Depid := src.Depid;
  Status := src.Status;
  Comsts := src.Comsts;
  LastActivityTime := src.LastActivityTime;
  ///  присваиваем Data
  Data.Assign(src.Data);
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

  with (Data as TLinkData) do
  begin
    if SameText(ts, OPENMCEP_type) then
      LinkType := ltOpenMCEP
    else if SameText(ts, SOCKETSPECIAL_type) then
      LinkType := ltSocketSpecial
    else
      LinkType := ltUnknown;
  end;

  inherited Parse(src);

  ///  читаем поле Dir
  Dir := GetValueStrDef(src, DirKey, '');
  ///  читаем поле Qid
  Qid := GetValueStrDef(src, QidKey, '');
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
  ///  запсиываем поле Dir
  dst.AddPair(TypeStrKey, (Data as TLinkData).LinkTypeStr);
  ///  запсиываем поле Dir
  dst.AddPair(DirKey, Dir);
  ///  запсиываем поле Dir
  dst.AddPair(QidKey, Qid);
  ///  запсиываем поле Dir
  dst.AddPair(StatusKey, Status);
  ///  запсиываем поле Dir
  dst.AddPair(ComstsKey, Comsts);
  ///  запсиываем поле Dir
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
  case LinkType of
    ltUnknown: Result := 'UNKNOWN';
    ltOpenMCEP: Result := OPENMCEP_type;
    ltSocketSpecial: Result := SOCKETSPECIAL_type;
  end;
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
    ltOpenMCEP: FDataSettings := TOpenMCEPDataSettings.Create();
    ltSocketSpecial: FDataSettings := TSocketSpecialDataSettings.Create();
    else FLinkType :=  ltUnknown;
  end;
end;

{ TLinkList }

class function TLinkList.ItemClassType: TEntityClass;
begin
  Result := TLink;
end;

end.
