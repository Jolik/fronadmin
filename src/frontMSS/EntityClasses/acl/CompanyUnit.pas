unit CompanyUnit;

interface

uses
  System.SysUtils, System.JSON,
  EntityUnit, GUIDListUnit, StringUnit;

  ///  data   Company
type
  TCompanyData = class(TData)
  private
    FOrgId: Integer;
    FCountryName: string;
    FRegionName: string;
    FShortName: string;
    FOrgTypeStr: string;
    FStatus: Integer;
    FOrgTypeId: Integer;
    FCountryId: string;
    FName: string;
    FDeps: TJSONArray;
    FRegionId: string;
    FDef: string;
  public
    function Assign(ASource: TFieldSet): Boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property OrgId: Integer read FOrgId write FOrgId;
    property CountryName: string read FCountryName write FCountryName;
    property RegionName: string read FRegionName write FRegionName;
    property ShortName: string read FShortName write FShortName;
    property OrgTypeStr: string read FOrgTypeStr write FOrgTypeStr;
    property Status: Integer read FStatus write FStatus;
    property OrgTypeId: Integer read FOrgTypeId write FOrgTypeId;
    property CountryId: string read FCountryId write FCountryId;
    property Name: string read FName write FName;
    property Deps: TJSONArray read FDeps write FDeps;
    property RegionId: string read FRegionId write FRegionId;
    property Def: string read FDef write FDef;
  end;



type
  ///  TCompany .
  TCompany = class(TEntity)
  private
    FAllowComp: TGUIDList;
    FIndex: string;
    FDomain: string;
    function GetCompanyData: TCompanyData;
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

    property Index: string read FIndex write FIndex;
    property Domain: string read FDomain write FDomain;
    property CompanyData: TCompanyData read GetCompanyData;
  end;

type
  ///
  TCompanyList = class(TEntityList)
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
  DomainKey           = 'domain';
  IndexKey            = 'index';
  CompIdKey           = 'compid';
  DefDataKey          = 'def';
  OrgIdDataKey        = 'orgId';
  CountryNameDataKey  = 'countryName';
  RegionNameDataKey   = 'regionName';
  ShortNameDataKey    = 'shortName';
  OrgTypeStrDataKey   = 'orgTypeStr';
  StatusDataKey       = 'status';
  OrgTypeIdDataKey    = 'orgTypeId';
  CountryIdDataKey    = 'countryId';
  NameDataKey         = 'name';
  DepsDataKey         = 'deps';
  RegionIdDataKey     = 'regionId';

{ TCompanyData }

function TCompanyData.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;

  if not Assigned(ASource) then
    Exit;

  if not (ASource is TCompanyData) then
    Exit;

  FDef := TCompanyData(ASource).Def;

  Result := true;
end;

procedure TCompanyData.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(src) then
    Exit;

  FDef          := GetValueStrDef(src, DefDataKey, '');
  FOrgId        := GetValueIntDef(src, OrgIdDataKey, 0);
  FCountryName  := GetValueStrDef(src, CountryNameDataKey, '');
  FRegionName   := GetValueStrDef(src, RegionNameDataKey, '');
  FShortName    := GetValueStrDef(src, ShortNameDataKey, '');
  FOrgTypeStr   := GetValueStrDef(src, OrgTypeStrDataKey, '');
  FStatus       := GetValueIntDef(src, StatusDataKey, 0);
  FOrgTypeId    := GetValueIntDef(src, OrgTypeIdDataKey, 0);
  FCountryId    := GetValueStrDef(src, CountryIdDataKey, '');
  FName         := GetValueStrDef(src, NameDataKey, '');
  FRegionId     := GetValueStrDef(src, RegionIdDataKey, '');

//  if src.TryGetValue<TJSONArray>(DepsDataKey, FDeps) then
    ; // ћожно позже добавить обработку массива
end;

procedure TCompanyData.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then
    Exit;

  dst.AddPair(DefDataKey, FDef);
  dst.AddPair(OrgIdDataKey, TJSONNumber.Create(FOrgId));
  dst.AddPair(CountryNameDataKey, FCountryName);
  dst.AddPair(RegionNameDataKey, FRegionName);
  dst.AddPair(ShortNameDataKey, FShortName);
  dst.AddPair(OrgTypeStrDataKey, FOrgTypeStr);
  dst.AddPair(StatusDataKey, TJSONNumber.Create(FStatus));
  dst.AddPair(OrgTypeIdDataKey, TJSONNumber.Create(FOrgTypeId));
  dst.AddPair(CountryIdDataKey, FCountryId);
  dst.AddPair(NameDataKey, FName);
  dst.AddPair(RegionIdDataKey, FRegionId);

  if Assigned(FDeps) then
    dst.AddPair(DepsDataKey, FDeps)  // ссылка на существующий массив
  else
    dst.AddPair(DepsDataKey, TJSONArray.Create); // пустой массив
end;


{ TCompany }

function TCompany.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TCompany) then
    Exit;

  FIndex := TCompany(ASource).FIndex;
  FDomain := TCompany(ASource).Domain;

  Result := true;
end;

class function TCompany.DataClassType: TDataClass;
begin
  Result := TCompanyData;
end;

constructor TCompany.Create;
begin
  inherited Create;
end;

constructor TCompany.Create(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Create;

  Parse(src, APropertyNames);
end;

destructor TCompany.Destroy;
begin
  FAllowComp.Free;

  inherited;
end;

function TCompany.GetIdKey: string;
begin
  Result := CompIdKey
end;


function TCompany.GetCompanyData: TCompanyData;
begin
  Result := Data as TCompanyData;
end;


procedure TCompany.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  Value: TJSONValue;
begin
  inherited Parse(src, APropertyNames);

  FDomain:= GetValueStrDef(src, DomainKey, '');
  FIndex := GetValueStrDef(src, IndexKey, '');
end;

procedure TCompany.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Serialize(dst, APropertyNames);
  dst.AddPair(Domain, FDomain);
  dst.AddPair(Index, FIndex);
end;


{ TCompanyList }

class function TCompanyList.ItemClassType: TEntityClass;
begin
  Result := TCompany;
end;

end.

