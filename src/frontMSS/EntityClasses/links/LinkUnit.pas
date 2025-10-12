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
    FLinkType: TLinkType;
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

  protected
    ///  потомок должен вернуть им€ пол€ дл€ идентификатора
    function GetIdKey: string; override;
    ///  метод возвращает конкретный тип объекта Settings
    ///  потомки должны переопределить его, потому что он у всех разный
    class function DataClassType: TDataClass; override;

  public
    function Assign(ASource: TFieldSet): boolean; override;

    // эти требуют существующего правильного экземпл€ра объекта. на ошибки - эксешан
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    // идентификатор линка
    property Lid: string read GetLid write SetLid;
    /// тип линка
    property TypeStr: string read GetTypeStr;
    // Dir направление upload|download|duplex
    property Dir: string read FDir write FDir;
    // »дентификатор очереди к которой прив€зан Ћинкс
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
  /// класс Data дл€ Ћинков
  TLinkData = class(TData)
  private
    FAutostart: boolean;
    FDataSettings: TDataSettings;
    FLinkType: TLinkType;
    procedure SetLinkType(const Value: TLinkType);

  public
    constructor Create();
    destructor Destroy(); override;

    // эти требуют существующего правильного экземпл€ра объекта. на ошибки - эксешан
    ///  в массиве const APropertyNames передаютс€ пол€, которые необходимо использовать
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    /// возвращает тип линка в виде строки
    function LinkTypeStr: string;

    // дл€ пол€ autostart
    property Autostart: boolean read FAutostart write FAutostart;
    ///  дл€ пол€ Settings
    property DataSettings: TDataSettings read FDataSettings write FDataSettings;
    // TypeStr тип линка например SOCKET_SPECIAL
    property LinkType: TLinkType read FLinkType write SetLinkType;


  end;

implementation

uses
  System.SysUtils,
  FuncUnit;

const
  LidKey = 'Lid';
  TypeStrKey = 'type';
  DirKey = 'dir';
  QidKey = 'Qid';
  StatusKey = 'status';
  ComstsKey = 'comsts';
  LastActivityTimeKey= 'last_activity_time';

  AutostartKey = 'autostart';
  SettingsKey = 'settings';

const
  ///  значени€ строки type
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

///  метод возвращает наименование ключа идентификатора который используетс€
///  дл€ данной сущности (у каждого он может быть свой)
function TLink.GetIdKey: string;
begin
  ///  им€ пол€ идентификатора Lid
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
///  LastActivityTime := GetValueStrDef(src, LastActivityTimeKey, '');
///
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

  try
    DataSettings.Free;
  except
    DataSettings := nil;
  end;

  inherited;
end;

function TLinkData.LinkTypeStr: string;
begin
  case LinkType of
    ltUnknown: Result := 'UNKNOWN';
    ltOpenMCEP: Result := 'OPENMCEP';
    ltSocketSpecial: Result := 'SOCKET_SPECIAL';
  end;
end;

procedure TLinkData.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

  ///  читаем поле LatePeriod
  Autostart := GetValueBool(src, AutostartKey);

  ///  добавл€ем пол€ Settings
  var dso := src.GetValue(SettingsKey) as TJSONObject;

  ///  передаем в DataSettings
  DataSettings.Parse(dso);

end;

procedure TLinkData.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

  with dst do
  begin
    AddPair(AutostartKey, Autostart);

    ///  добавл€ем настройки settings в объект data
    dst.AddPair(SettingsKey, DataSettings.Serialize());
  end;
end;

procedure TLinkData.SetLinkType(const Value: TLinkType);
begin
  //  по умолчанию неизвестный тип
  FLinkType :=  ltUnknown;

  ///  в зависимости от типа устанавливаем различные настройки
  if Assigned(DataSettings) then
  try
    FreeAndNil(DataSettings);

  except on e:exception do
    begin
      Log('TLinkData.SetLinkType '+ e.Message, lrtError);
    end;
  end;

  try
    case LinkType of
      ltUnknown: FDataSettings := nil;  ///  нет класса дл€ неизвсетногь типа
      ltOpenMCEP: FDataSettings := TOpenMCEPDataSettings.Create();
      ltSocketSpecial: FDataSettings := TSocketSpecialDataSettings.Create();
    end;

  except on e:exception do
    begin
      Log('TLinkData.SetLinkType '+ e.Message, lrtError);
      exit;
    end;
  end;

  LinkType := Value;

end;

{ TLinkList }

class function TLinkList.ItemClassType: TEntityClass;
begin
  Result := TLink;
end;

end.
