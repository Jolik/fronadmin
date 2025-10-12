unit LinkUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  LoggingUnit,
  EntityUnit,
  LinkSettingsUnit;

type
  // TLink �����������
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
    ///  ������� ������ ������� ��� ���� ��� ��������������
    function GetIdKey: string; override;
    ///  ����� ���������� ���������� ��� ������� Settings
    ///  ������� ������ �������������� ���, ������ ��� �� � ���� ������
    class function DataClassType: TDataClass; override;

  public
    function Assign(ASource: TFieldSet): boolean; override;

    // ��� ������� ������������� ����������� ���������� �������. �� ������ - �������
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    // ������������� �����
    property Lid: string read GetLid write SetLid;
    /// ��� �����
    property TypeStr: string read GetTypeStr;
    // Dir ����������� upload|download|duplex
    property Dir: string read FDir write FDir;
    // ������������� ������� � ������� �������� �����
    property Qid: string read FQid write FQid;
    // Status unknown|starting|stopping|stopped|running|error|halt|unavailable
    property Status: string read FStatus write FStatus;
    // Comsts disconnected|connecting|connected|unknown
    property Comsts: string read FComsts write FComsts;
    // LastActivityTime �������� ��� ����� ���� ���������� �����
    property LastActivityTime: int64 read FLastActivityTime write FLastActivityTime;

  end;

type
  ///  ������ �����
  TLinkList = class (TEntityList)
    ///  ����� ���������� ���������� ��� ������� �������� ������
    ///  ������� ������ �������������� ���, ������ ��� �� � ���� ������
    class function ItemClassType: TEntityClass; override;

  end;

type
  /// ����� Data ��� ������
  TLinkData = class(TData)
  private
    FAutostart: boolean;
    FDataSettings: TDataSettings;
    FLinkType: TLinkType;
    procedure SetLinkType(const Value: TLinkType);

  public
    constructor Create();
    destructor Destroy(); override;

    // ��� ������� ������������� ����������� ���������� �������. �� ������ - �������
    ///  � ������� const APropertyNames ���������� ����, ������� ���������� ������������
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    /// ���������� ��� ����� � ���� ������
    function LinkTypeStr: string;

    // ��� ���� autostart
    property Autostart: boolean read FAutostart write FAutostart;
    ///  ��� ���� Settings
    property DataSettings: TDataSettings read FDataSettings write FDataSettings;
    // TypeStr ��� ����� �������� SOCKET_SPECIAL
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
  ///  �������� ������ type
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

  ///  ����������� Data
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

///  ����� ���������� ������������ ����� �������������� ������� ������������
///  ��� ������ �������� (� ������� �� ����� ���� ����)
function TLink.GetIdKey: string;
begin
  ///  ��� ���� �������������� Lid
  Result := LidKey;
end;

procedure TLink.Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil);
begin
  ///  ������� ������ ���� ���� � � ���������� �� ���� ������� ������ ����� ��������
  ///  ������ ���� TypeStr
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

  ///  ������ ���� Dir
  Dir := GetValueStrDef(src, DirKey, '');
  ///  ������ ���� Qid
  Qid := GetValueStrDef(src, QidKey, '');
  ///  ������ ���� Status
  Status := GetValueStrDef(src, StatusKey, '');
  ///  ������ ���� Comsts
  Comsts := GetValueStrDef(src, ComstsKey, '');
  ///  ������ ���� LastActivityTime
///  LastActivityTime := GetValueStrDef(src, LastActivityTimeKey, '');
///
end;

procedure TLink.Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil);

begin
  inherited Serialize(dst);

  ///  ���������� ���� Dir
  dst.AddPair(TypeStrKey, (Data as TLinkData).LinkTypeStr);
  ///  ���������� ���� Dir
  dst.AddPair(DirKey, Dir);
  ///  ���������� ���� Dir
  dst.AddPair(QidKey, Qid);
  ///  ���������� ���� Dir
  dst.AddPair(StatusKey, Status);
  ///  ���������� ���� Dir
  dst.AddPair(ComstsKey, Comsts);
  ///  ���������� ���� Dir
  dst.AddPair(LastActivityTimeKey, LastActivityTime);

end;

{ TLinkData }

constructor TLinkData.Create;
begin
  inherited Create();

  ///  ������� ������ Settings
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

  ///  ������ ���� LatePeriod
  Autostart := GetValueBool(src, AutostartKey);

  ///  ��������� ���� Settings
  var dso := src.GetValue(SettingsKey) as TJSONObject;

  ///  �������� � DataSettings
  DataSettings.Parse(dso);

end;

procedure TLinkData.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

  with dst do
  begin
    AddPair(AutostartKey, Autostart);

    ///  ��������� ��������� settings � ������ data
    dst.AddPair(SettingsKey, DataSettings.Serialize());
  end;
end;

procedure TLinkData.SetLinkType(const Value: TLinkType);
begin
  //  �� ��������� ����������� ���
  FLinkType :=  ltUnknown;

  ///  � ����������� �� ���� ������������� ��������� ���������
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
      ltUnknown: FDataSettings := nil;  ///  ��� ������ ��� ������������ ����
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
