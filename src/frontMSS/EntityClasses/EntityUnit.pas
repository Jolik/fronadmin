unit EntityUnit;

interface

uses
  System.SysUtils, System.Generics.Collections, System.JSON, System.DateUtils,
  FuncUnit,
  LoggingUnit;

type
  ///  ����������� ����� - ����� �����
  ///  ��������� ������� ������� ��������� ������������������� ����
  ///  �� ������� ������ �� �������
  TFieldSet = class (TObject)
  private
  protected
    procedure RaiseInvalidObjects(o: TObject); overload;
    procedure RaiseInvalidObjects(o1, o2: TObject); overload;

  public
    ///  ������������� ���� � ������� �������
    function Assign(ASource: TFieldSet): boolean; virtual; abstract;

    // ��� ������� ������������� ����������� ���������� �������. �� ������ - �������
    ///  � ������� const APropertyNames ���������� ����, ������� ���������� ������������
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); virtual; abstract;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; virtual; abstract;
    function Serialize(const APropertyNames: TArray<string> = nil): TJSONObject; overload;
    function JSON(const APropertyNames: TArray<string> = nil): string; overload;

  end;

type
  // �����-������ �� ����� ������� TSettings
  TSettingsClass = class of TSettings;
  ///  ��������� ��� ���� ����� ����� �� �����
  TSettings = class (TFieldSet)
  public
    // ��� ������� ������������� ����������� ���������� �������. �� ������ - �������
    ///  � ������� const APropertyNames ���������� ����, ������� ���������� ������������
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

  end;

type
  // �����-������ �� ����� ������� TData
  TDataClass = class of TData;
  ///  TData ��� ���� ��������� � ���� ����� ����� �� �����
  TData = class (TFieldSet)
  public
    // ��� ������� ������������� ����������� ���������� �������. �� ������ - �������
    ///  � ������� const APropertyNames ���������� ����, ������� ���������� ������������
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

  end;

type
  // �����-������ �� ����� ������� TBody
  TBodyClass = class of TBody;
  ///  TBody ��� ���� ��������� � ��� ���� ����� ����� �� �����
  TBody = class (TFieldSet)
  public
    // ��� ������� ������������� ����������� ���������� �������. �� ������ - �������
    ///  � ������� const APropertyNames ���������� ����, ������� ���������� ������������
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

  end;


type
  // �����-������ �� ����� ������ ��������� TEntity
  TListClass = class of TEntityList;

  // �����-������ �� ����� ������ ��������� TEntity
  TEntityClass = class of TEntity;

  ///  ����� �������� - ������� ���� ��������� �������
  TEntity = class (TFieldSet)
  private
    FId: String;
    FDepId: string;
    FName: String;
    FCompId: string;
    FCaption: String;
    FCreated: TDateTime;
    FUpdated: TDateTime;
    FEnabled: boolean;
    FDef: String;
    FSettings: TSettings;
    FBody: TBody;
    FData: TData;

  protected
    ///  ����� ���������� ���������� ��� ������� Settings
    ///  ������� ������ �������������� ���, ������ ��� �� � ���� ������
    class function SettingsClassType: TSettingsClass; virtual;
    ///  ����� ���������� ���������� ��� ������� Data
    ///  ������� ������ �������������� ���, ������ ��� �� � ���� ������
    class function DataClassType: TDataClass; virtual;
    ///  ����� ���������� ���������� ��� ������� Body
    ///  ������� ������ �������������� ���, ������ ��� �� � ���� ������
    class function BodyClassType: TBodyClass; virtual;

    ///  ����� ���������� ���������� ��� ������� TEntityList
    ///  ������� ������ �������������� ���, ������ ��� �� � ���� ������
    class function ListClassType: TListClass; virtual;

    ///  ������� ������ ������� ��� ���� ��� ��������������
    function GetIdKey: string; virtual;

  public
    constructor Create(); overload;
    ///  ����������� ����� �� JSON
    constructor Create(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload;

    destructor Destroy; override;

    ///  ������������� ���� � ������� �������
    function Assign(ASource: TFieldSet): boolean; override;

    // ��� ������� ������������� ����������� ���������� �������. �� ������ - �������
    ///  � const APropertyNames ���������� ������ ����� ������� ���������� ������������
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    ///  ������������� ��������
    property Id: String read FId write FId;
    ///  ������������� ��������
    property CompId: string read FCompId write FCompId;
    ///  ������������� ������������
    property DepId: string read FDepId write FDepId;
    ///  ������������ ��������
    property Name: String read FName write FName;
    ///  ��������� ��������
    property Caption: String read FCaption write FCaption;
    ///  �������� ��������
    property Def: String read FDef write FDef;
    ///  ����� �������� ��������
    property Enabled: boolean read FEnabled write FEnabled;
    ///  ���������
    property Settings: TSettings read FSettings write FSettings;
    ///  ������ ��������
    property Data: TData read FData write FData;
    ///  ���� ��������
    property Body: TBody read FBody write FBody;
    ///  ����� �������� ��������
    property Created: TDateTime read FCreated write FCreated;
    ///  ����� ���������� ��������
    property Updated: TDateTime read FUpdated write FUpdated;
  end;

  ///  ����� - ������ ���������
  TEntityList = class (TObjectList<TEntity>)
  private
  protected
    ///  ����� ���������� ���������� ��� ������� �������� ������
    ///  ������� ������ �������������� ���, ������ ��� �� � ���� ������
    class function ItemClassType: TEntityClass; virtual;

  public
    ///  ����������� ����� �� JSON
    constructor Create(src: TJSONArray; const APropertyNames: TArray<string> = nil); overload;

    ///  ������������� ���� � ������� �������
    function Assign(ASource: TEntityList): boolean; virtual;

    // ��� ������� ������������� ����������� ���������� ������. �� ������ - �������
    ///  � APropertyNames ���������� ������ ����� ������� ���������� ������������
    procedure ParseList(src: TJSONArray; const APropertyNames: TArray<string> = nil); overload; virtual;
    procedure AddList(src: TJSONArray; const APropertyNames: TArray<string> = nil); overload; virtual;
    procedure SerializeList(dst: TJSONArray; const APropertyNames: TArray<string> = nil); overload; virtual;
    function SerializeList(const APropertyNames: TArray<string> = nil): TJSONArray; overload; virtual;

  end;

implementation

{ TFieldSet }

function TFieldSet.JSON(const APropertyNames: TArray<string>): string;
begin
  Result := '{}';
  var j := TJSONObject.Create;
  try
    try
      Serialize(j);
      Result := j.ToJSON;
    except on e:exception do
      begin
        Log('TFieldSet.JSON '+ e.Message, lrtError);
      end;
    end;
  finally
    j.Free();
  end;
end;

procedure TFieldSet.RaiseInvalidObjects(o1, o2: TObject);
begin
  raise exception.CreateFmt('invalid objects input: %s %s', [ClassNameSafe(o1), ClassNameSafe(o2)]);
end;

function TFieldSet.Serialize(const APropertyNames: TArray<string>): TJSONObject;
begin
  result := TJSONObject.Create;
  try
    Serialize(result);
  except on e:exception do
    begin
      Log('TFieldSet.Serialize '+ e.Message, lrtError);
      FreeAndNil(result);
    end;
  end;
end;

procedure TFieldSet.RaiseInvalidObjects(o: TObject);
begin
  raise exception.CreateFmt('invalid object type: %s', [ClassNameSafe(o)]);
end;


{ TEntity }

///  ����� ���������� ���������� ��� ������� Settings
class function TEntity.SettingsClassType: TSettingsClass;
begin
  Result := TSettings;
end;

///  ����� ���������� ���������� ��� ������� Data
class function TEntity.DataClassType: TDataClass;
begin
  Result := TData;
end;

///  ����� ���������� ���������� ��� ������� Body
class function TEntity.BodyClassType: TBodyClass;
begin
  Result := TBody;
end;

function TEntity.Assign(ASource: TFieldSet) : boolean;
var
  LSource : TEntity;

begin
  Result := false;

  if not Assigned(ASource) then exit;

  if not inherited Assign(ASource) then
    exit;

  /// ��������� �� ������������� � ����� �����
  if ASource is TEntity then
    LSource := ASource as TEntity;

  try
    Self.Id := LSource.Id;
    Self.CompId := LSource.CompId;
    Self.DepId := LSource.DepId;
    Self.Name := LSource.Name;
    Self.Caption := LSource.Caption;
    Self.Def := LSource.Def;
    Self.Enabled := LSource.Enabled;
    if not Self.Settings.Assign(LSource.Settings) then exit;
    if not Self.Data.Assign(LSource.Data) then exit;
    if not Self.Body.Assign(LSource.Body) then exit;
    Self.Created := LSource.Created;
    Self.Updated := LSource.Updated;

    Result := true;
  finally

  end;

end;

function TEntity.GetIdKey: string;
begin
  ///  �� ��������� ���������� id
  Result := 'id';
end;

class function TEntity.ListClassType: TListClass;
begin
  Result := TEntityList;
end;

procedure TEntity.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Id := GetValueStrDef(src, GetIdKey, '');
  Name := GetValueStrDef(src, 'name', '');
  Caption := GetValueStrDef(src, 'caption', '');
  CompId := GetValueStrDef(src, 'compid', '');
  DepId := GetValueStrDef(src, 'depid', '');
  Def := GetValueStrDef(src, 'def', '');
  Enabled := GetValueBool(src, 'enabled');
  Created := UnixToDateTime(GetValueIntDef(src, 'created', 0));
  Updated := UnixToDateTime(GetValueIntDef(src, 'updated', 0));

  ///  �������� ������ �� JSON-������ settings
  var s := src.FindValue('settings');
  ///  ������ ������ ���� setting ���������� � ��� ������������� ������
  if Assigned(s) and (s is TJSONObject) then Settings.Parse(s as TJSONObject);

  ///  �������� ������ �� JSON-������ settings
  var d := src.FindValue('data');
  ///  ������ ������ ���� data ���������� � ��� ������������� ������
  if Assigned(d) and (d is TJSONObject) then Data.Parse(d as TJSONObject);

  ///  �������� ������ �� JSON-������ settings
  var b := src.FindValue('body');
  ///  ������ ������ ���� body ���������� � ��� ������������� ������
  if Assigned(b) and (b is TJSONObject) then Body.Parse(b as TJSONObject);
end;

procedure TEntity.Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil);
begin
  with dst do
  begin
    AddPair(GetIdKey, Id);
    AddPair('name', Name);
    AddPair('caption', Caption);
    AddPair('def', Def);
    AddPair('compid', CompId);
    AddPair('depid', DepId);
    AddPair('enabled', Enabled);
    AddPair('created', DateTimeToUnix(Created));
    AddPair('updated', DateTimeToUnix(Updated));
    ///  ��������� ���������, ���� � ������
    dst.AddPair('settings', Settings.Serialize());
    dst.AddPair('data', Data.Serialize());
    dst.AddPair('body', Body.Serialize());
  end;
end;

constructor TEntity.Create;
begin
  Settings := nil; Data := nil; Body := nil;

  inherited Create();

  ///  ������� ����� � ����������� �� ���� ��� ������� �������
  Settings := SettingsClassType.Create();

  ///  ������� ����� � ����������� �� ���� ��� ������� �������
  Data := DataClassType.Create();

  ///  ������� ����� � ����������� �� ���� ��� ������� �������
  Body := BodyClassType.Create();
end;

constructor TEntity.Create(src: TJSONObject; const APropertyNames: TArray<string> = nil);
begin
  Create();

  Parse(src, APropertyNames);
end;

destructor TEntity.Destroy;
begin

  try
    Settings.Free;
  except
    Settings := nil;
  end;

  try
    Data.Free;
  except
    Data := nil;
  end;

  try
    Body.Free;
  except
    Body := nil;
  end;

  inherited;
end;

{ TEntityList }

function TEntityList.Assign(ASource: TEntityList): boolean;
begin
  /// ������� ������ � �������� ������� ����������� �����
  ///  � ��������� �� � ������
  for var i := 0 to ASource.Count-1 do
  begin
    var es := TEntity.Create();
    es.Assign(ASource.Items[i]);
    Add(es);
  end;
end;

constructor TEntityList.Create(src: TJSONArray;
  const APropertyNames: TArray<string>);
begin
  inherited Create();

  ParseList(src, APropertyNames);
end;

class function TEntityList.ItemClassType: TEntityClass;
begin
  Result := TEntity;
end;

procedure TEntityList.ParseList(src: TJSONArray;
  const APropertyNames: TArray<string>);
begin
  Clear();

  ///  ��������� ������
  for var i in src do
  begin
    if i is TJSONObject then
    begin
      ///  ������� ������ ����� �� JSON
      var e:= ItemClassType.Create(i as TJSONObject);
      ///  ������� ��� � ������
      Add(e);
    end;
  end;

end;

procedure TEntityList.AddList(src: TJSONArray;
  const APropertyNames: TArray<string>);
begin
  ///  ��������� ������
  for var i in src do
  begin
    if i is TJSONObject then
    begin
      ///  ������� ������ ����� �� JSON
      var e:= ItemClassType.Create(i as TJSONObject);
      ///  ������� ��� � ������
      Add(e);
    end;
  end;
end;

procedure TEntityList.SerializeList(dst: TJSONArray;
  const APropertyNames: TArray<string>);
begin
  ///  ���� ���� ����� � �� ����� ��� - ������ �� ������
end;

function TEntityList.SerializeList(
  const APropertyNames: TArray<string>): TJSONArray;
begin
  result := TJSONArray.Create;

  try
    SerializeList(result);

  except on e:exception do
    begin
      Log('TEntityList.Serialize '+ e.Message, lrtError);
      FreeAndNil(result);
    end;
  end;
end;

{ TSettings }

procedure TSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  ///  � �������� ������ �����
end;

procedure TSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  ///  ������� ����� �� ������� ������
end;

{ TData }

procedure TData.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  ///  � �������� ������ �����
end;

procedure TData.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  ///  ������� ����� �� ������� ������
end;

{ TBody }

procedure TBody.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  ///  � �������� ������ �����
end;

procedure TBody.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  ///  ������� ����� �� ������� ������
end;

end.


