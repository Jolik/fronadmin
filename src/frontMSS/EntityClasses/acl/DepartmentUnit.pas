unit DepartmentUnit;

interface

uses
  System.SysUtils, System.JSON,
  EntityUnit, GUIDListUnit, StringUnit;

type
  ///  data Department
  TDepartmentData = class(TData)
  private
    FMaster: Boolean;
    FDNS: string;
    FContacts: string;
    FDeptId: string;
    FMid: string;
  public
    function Assign(ASource: TFieldSet): Boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Master: Boolean read FMaster write FMaster;
    property DNS: string read FDNS write FDNS;
    property Contacts: string read FContacts write FContacts;
    property DeptId: string read FDeptId write FDeptId;
    property Mid: string read FMid write FMid;
  end;


  ///  TDepartment entity
  TDepartment = class(TEntity)
  private
    FDepId: string;
    FCompId: string;
    FIndex: string;
    FName: string;
    FShortName: string;
    function GetDepartmentData: TDepartmentData;
  protected
    function GetIdKey: string; override;
    class function DataClassType: TDataClass; override;
  public
    constructor Create; overload; override;
    constructor Create(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property DepId: string read FDepId write FDepId;
    property CompId: string read FCompId write FCompId;
    property Index: string read FIndex write FIndex;
    property Name: string read FName write FName;
    property ShortName: string read FShortName write FShortName;
    property DepartmentData: TDepartmentData read GetDepartmentData;
  end;

  ///  Список отделов
  TDepartmentList = class(TEntityList)
    class function ItemClassType: TEntityClass; override;
  end;

implementation

uses
  FuncUnit;

const
  DepIdKey         = 'depid';
  CompIdKey        = 'compid';
  IndexKey         = 'index';
  NameKey          = 'name';
  ShortNameKey     = 'shortname';

  // Data keys
  MasterDataKey    = 'master';
  DNSDataKey       = 'DNS';
  ContactsDataKey  = 'contacts';
  DeptIdDataKey    = 'deptid';
  MidDataKey       = 'mid';

{ TDepartmentData }

function TDepartmentData.Assign(ASource: TFieldSet): Boolean;
begin
  Result := False;
  if not Assigned(ASource) or not (ASource is TDepartmentData) then
    Exit;

  FMaster   := TDepartmentData(ASource).Master;
  FDNS      := TDepartmentData(ASource).DNS;
  FContacts := TDepartmentData(ASource).Contacts;
  FDeptId   := TDepartmentData(ASource).DeptId;
  FMid      := TDepartmentData(ASource).Mid;

  Result := True;
end;

procedure TDepartmentData.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(src) then
    Exit;

  FMaster   := GetValueBool(src, MasterDataKey);
  FDNS      := GetValueStrDef(src, DNSDataKey, '');
  FContacts := GetValueStrDef(src, ContactsDataKey, '');
  FDeptId   := GetValueStrDef(src, DeptIdDataKey, '');
  FMid      := GetValueStrDef(src, MidDataKey, '');
end;

procedure TDepartmentData.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then
    Exit;

  dst.AddPair(MasterDataKey, TJSONBool.Create(FMaster));
  dst.AddPair(DNSDataKey, FDNS);
  dst.AddPair(ContactsDataKey, FContacts);
  dst.AddPair(DeptIdDataKey, FDeptId);
  dst.AddPair(MidDataKey, FMid);
end;

{ TDepartment }

function TDepartment.Assign(ASource: TFieldSet): boolean;
begin
  Result := False;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TDepartment) then
    Exit;

  FDepId     := TDepartment(ASource).DepId;
  FCompId    := TDepartment(ASource).CompId;
  FIndex     := TDepartment(ASource).Index;
  FName      := TDepartment(ASource).Name;
  FShortName := TDepartment(ASource).ShortName;

  Result := True;
end;

class function TDepartment.DataClassType: TDataClass;
begin
  Result := TDepartmentData;
end;

constructor TDepartment.Create;
begin
  inherited Create;
end;

constructor TDepartment.Create(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Create;
  Parse(src, APropertyNames);
end;

destructor TDepartment.Destroy;
begin
  inherited;
end;

function TDepartment.GetIdKey: string;
begin
  Result := DepIdKey;
end;

function TDepartment.GetDepartmentData: TDepartmentData;
begin
  Result := Data as TDepartmentData;
end;

procedure TDepartment.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Parse(src, APropertyNames);

  FDepId     := GetValueStrDef(src, DepIdKey, '');
  FCompId    := GetValueStrDef(src, CompIdKey, '');
  FIndex     := GetValueStrDef(src, IndexKey, '');
  FName      := GetValueStrDef(src, NameKey, '');
  FShortName := GetValueStrDef(src, ShortNameKey, '');
end;

procedure TDepartment.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Serialize(dst, APropertyNames);

  dst.AddPair(DepIdKey, FDepId);
  dst.AddPair(CompIdKey, FCompId);
  dst.AddPair(IndexKey, FIndex);
  dst.AddPair(NameKey, FName);
  dst.AddPair(ShortNameKey, FShortName);
end;

{ TDepartmentList }

class function TDepartmentList.ItemClassType: TEntityClass;
begin
  Result := TDepartment;
end;

end.

