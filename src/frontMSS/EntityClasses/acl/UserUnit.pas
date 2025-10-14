unit UserUnit;

interface

uses
  System.SysUtils, System.JSON,
  EntityUnit, GUIDListUnit;

type
  ///  data   user
  TUserData = class(TData)
  private
    FDef: string;
  public
    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    property Def: string read FDef write FDef;
  end;

type
  ///  body   user
  TUserBody = class(TBody)
  private
    FRoles: TGUIDList;
    FDatasets: TGUIDList;
    FLevels: TGUIDList;
  public
    constructor Create; overload;
    destructor Destroy; override;
    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Roles: TGUIDList read FRoles;
    property Datasets: TGUIDList read FDatasets;
    property Levels: TGUIDList read FLevels;
  end;

type
  ///  TUser .
  TUser = class(TEntity)
  private
    FAllowComp: TGUIDList;
    FGid: string;
    FEmail: string;
    FCountry: string;
    FOrg: string;
    FGroupBody: TUserBody;
    function GetUsid: string;
    procedure SetUsid(const Value: string);
    function GetUserBody: TUserBody;
    function GetUserData: TUserData;
  protected
    function GetIdKey: string; override;
    class function DataClassType: TDataClass; override;
    class function BodyClassType: TBodyClass; override;
  public
    constructor Create; overload;
    constructor Create(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Usid: string read GetUsid write SetUsid;
    property AllowComp: TGUIDList read FAllowComp;
    property Gid: string read FGid write FGid;
    property Email: string read FEmail write FEmail;
    property Country: string read FCountry write FCountry;
    property Org: string read FOrg write FOrg;
    property UserData: TUserData read GetUserData;
    property UserBody: TUserBody read GetUserBody;
    property GroupBody: TUserBody read FGroupBody;
  end;

type
  ///
  TUserList = class(TEntityList)
    class function ItemClassType: TEntityClass; override;
  end;

implementation

uses
  FuncUnit;

function FindValueExact(AObject: TJSONObject; const AKey: string): TJSONValue;
begin
  Result := nil;

  if not Assigned(AObject) then
    Exit;

  for var Pair in AObject do
    if SameText(Pair.JsonString.Value, AKey) then
      Exit(Pair.JsonValue);
end;

const
  UsidKey = 'usid';
  GidKey = 'gid';
  EmailKey = 'email';
  CountryKey = 'country';
  OrgKey = 'org';
  AllowCompKey = 'allowcomp';
  GroupBodyKey = 'group.body';
  DataDefKey = 'def';
  RolesKey = 'roles';
  DatasetsKey = 'datasets';
  LevelsKey = 'levels';

{ TUserData }

function TUserData.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;

  if not Assigned(ASource) then
    Exit;

  if not (ASource is TUserData) then
    Exit;

  FDef := TUserData(ASource).Def;

  Result := true;
end;

procedure TUserData.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(src) then
    Exit;

  FDef := GetValueStrDef(src, DataDefKey, '');
end;

procedure TUserData.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then
    Exit;

  dst.AddPair(DataDefKey, FDef);
end;

{ TUserBody }

function TUserBody.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;

  if not Assigned(ASource) then
    Exit;

  if not (ASource is TUserBody) then
    Exit;

  FRoles.Assign(TUserBody(ASource).Roles);
  FDatasets.Assign(TUserBody(ASource).Datasets);
  FLevels.Assign(TUserBody(ASource).Levels);

  Result := true;
end;

constructor TUserBody.Create;
begin
  inherited Create;

  FRoles := TGUIDList.Create;
  FDatasets := TGUIDList.Create;
  FLevels := TGUIDList.Create;
end;

destructor TUserBody.Destroy;
begin
  FRoles.Free;
  FDatasets.Free;
  FLevels.Free;

  inherited;
end;

procedure TUserBody.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  Value: TJSONValue;
begin
  FRoles.Clear;
  FDatasets.Clear;
  FLevels.Clear;

  if not Assigned(src) then
    Exit;

  Value := src.FindValue(RolesKey);
  if Assigned(Value) and (Value is TJSONArray) then
    FRoles.Parse(Value as TJSONArray);

  Value := src.FindValue(DatasetsKey);
  if Assigned(Value) and (Value is TJSONArray) then
    FDatasets.Parse(Value as TJSONArray);

  Value := src.FindValue(LevelsKey);
  if Assigned(Value) and (Value is TJSONArray) then
    FLevels.Parse(Value as TJSONArray);
end;

procedure TUserBody.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then
    Exit;

  dst.AddPair(RolesKey, FRoles.SerializeList);
  dst.AddPair(DatasetsKey, FDatasets.SerializeList);
  dst.AddPair(LevelsKey, FLevels.SerializeList);
end;

{ TUser }

function TUser.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TUser) then
    Exit;

  FGid := TUser(ASource).Gid;
  FEmail := TUser(ASource).Email;
  FCountry := TUser(ASource).Country;
  FOrg := TUser(ASource).Org;

  FAllowComp.Assign(TUser(ASource).AllowComp);
  FGroupBody.Assign(TUser(ASource).GroupBody);

  Result := true;
end;

class function TUser.BodyClassType: TBodyClass;
begin
  Result := TUserBody;
end;

class function TUser.DataClassType: TDataClass;
begin
  Result := TUserData;
end;

constructor TUser.Create;
begin
  inherited Create;

  FAllowComp := TGUIDList.Create;
  FGroupBody := TUserBody.Create;
end;

constructor TUser.Create(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Create;

  Parse(src, APropertyNames);
end;

destructor TUser.Destroy;
begin
  FAllowComp.Free;
  FGroupBody.Free;

  inherited;
end;

function TUser.GetIdKey: string;
begin
  Result := UsidKey;
end;

function TUser.GetUserBody: TUserBody;
begin
  Result := Body as TUserBody;
end;

function TUser.GetUserData: TUserData;
begin
  Result := Data as TUserData;
end;

function TUser.GetUsid: string;
begin
  Result := Id;
end;

procedure TUser.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  Value: TJSONValue;
begin
  inherited Parse(src, APropertyNames);

  FGid := GetValueStrDef(src, GidKey, '');
  FEmail := GetValueStrDef(src, EmailKey, '');
  FCountry := GetValueStrDef(src, CountryKey, '');
  FOrg := GetValueStrDef(src, OrgKey, '');

  Value := FindValueExact(src, AllowCompKey);
  if Assigned(Value) and (Value is TJSONArray) then
    FAllowComp.Parse(Value as TJSONArray)
  else
    FAllowComp.Clear;

  Value := FindValueExact(src, GroupBodyKey);
  if Assigned(Value) and (Value is TJSONObject) then
    FGroupBody.Parse(Value as TJSONObject)
  else
    FGroupBody.Parse(nil);
end;

procedure TUser.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Serialize(dst, APropertyNames);

  dst.AddPair(GidKey, FGid);
  dst.AddPair(EmailKey, FEmail);
  dst.AddPair(CountryKey, FCountry);
  dst.AddPair(OrgKey, FOrg);
  dst.AddPair(AllowCompKey, FAllowComp.SerializeList);
  dst.AddPair(GroupBodyKey, FGroupBody.Serialize);
end;

procedure TUser.SetUsid(const Value: string);
begin
  Id := Value;
end;

{ TUserList }

class function TUserList.ItemClassType: TEntityClass;
begin
  Result := TUser;
end;

end.

