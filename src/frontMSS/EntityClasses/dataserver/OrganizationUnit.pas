unit OrganizationUnit;

interface

uses
  System.SysUtils,
  System.JSON,
  EntityUnit,
  FuncUnit;

type
  // Entity describing organizations returned by /organizations endpoints
  TOrganization = class(TFieldSet)
  private
    FOrgId: Integer;
    FShortName: string;
    FName: string;
    FOrgTypeId: Integer;
    FOrgTypeName: string;
    FRegionId: string;
    FRegionName: string;
    FCountryId: string;
    FCountryName: string;
    FStatus: Boolean;
    FParentOrgId: Nullable<Integer>;
    FParentOrgStr: Nullable<string>;
  public
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property OrgId: Integer read FOrgId write FOrgId;
    property ShortName: string read FShortName write FShortName;
    property Name: string read FName write FName;
    property OrgTypeId: Integer read FOrgTypeId write FOrgTypeId;
    property OrgTypeName: string read FOrgTypeName write FOrgTypeName;
    property RegionId: string read FRegionId write FRegionId;
    property RegionName: string read FRegionName write FRegionName;
    property CountryId: string read FCountryId write FCountryId;
    property CountryName: string read FCountryName write FCountryName;
    property Status: Boolean read FStatus write FStatus;
    property ParentOrgId: Nullable<Integer> read FParentOrgId write FParentOrgId;
    property ParentOrgStr: Nullable<string> read FParentOrgStr write FParentOrgStr;
  end;

  TOrganizationList = class(TFieldSetList)
  public
    class function ItemClassType: TFieldSetClass; override;
  end;

  // Organization type dictionary entry
  TOrgType = class(TFieldSet)
  private
    FOrgTypeId: Integer;
    FAbbr: string;
    FShortName: string;
    FName: string;
  public
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property OrgTypeId: Integer read FOrgTypeId write FOrgTypeId;
    property Abbr: string read FAbbr write FAbbr;
    property ShortName: string read FShortName write FShortName;
    property Name: string read FName write FName;
  end;

  TOrgTypeList = class(TFieldSetList)
  public
    class function ItemClassType: TFieldSetClass; override;
  end;

implementation

{ TOrganization }

procedure TOrganization.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  FOrgId := GetValueIntDef(src, 'orgId', 0);
  FShortName := GetValueStrDef(src, 'shortName', '');
  FName := GetValueStrDef(src, 'name', '');
  FOrgTypeId := GetValueIntDef(src, 'orgTypeId', 0);
  FOrgTypeName := GetValueStrDef(src, 'orgTypeName', '');
  FRegionId := GetValueStrDef(src, 'regionId', '');
  FRegionName := GetValueStrDef(src, 'regionName', '');
  FCountryId := GetValueStrDef(src, 'countryId', '');
  FCountryName := GetValueStrDef(src, 'countryName', '');
  FStatus := GetValueBool(src, 'status');
  FParentOrgId := GetNullableInt(src, 'ParentOrgID');
  FParentOrgStr := GetNullableStr(src, 'ParentOrgStr');
end;

procedure TOrganization.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  dst.AddPair('orgId', TJSONNumber.Create(FOrgId));
  dst.AddPair('shortName', FShortName);
  dst.AddPair('name', FName);
  dst.AddPair('orgTypeId', TJSONNumber.Create(FOrgTypeId));
  dst.AddPair('orgTypeName', FOrgTypeName);
  dst.AddPair('regionId', FRegionId);
  dst.AddPair('regionName', FRegionName);
  dst.AddPair('countryId', FCountryId);
  dst.AddPair('countryName', FCountryName);
  dst.AddPair('status', TJSONBool.Create(FStatus));
  if FParentOrgId.HasValue then
    dst.AddPair('ParentOrgID', TJSONNumber.Create(FParentOrgId.Value))
  else
    dst.AddPair('ParentOrgID', TJSONNull.Create);
  if FParentOrgStr.HasValue then
    dst.AddPair('ParentOrgStr', FParentOrgStr.Value)
  else
    dst.AddPair('ParentOrgStr', TJSONNull.Create);
end;

{ TOrganizationList }

class function TOrganizationList.ItemClassType: TFieldSetClass;
begin
  Result := TOrganization;
end;

{ TOrgType }

procedure TOrgType.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  FOrgTypeId := GetValueIntDef(src, 'orgTypeId', 0);
  FAbbr := GetValueStrDef(src, 'abbr', '');
  FShortName := GetValueStrDef(src, 'shortName', '');
  FName := GetValueStrDef(src, 'name', '');
end;

procedure TOrgType.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  dst.AddPair('orgTypeId', TJSONNumber.Create(FOrgTypeId));
  dst.AddPair('abbr', FAbbr);
  dst.AddPair('shortName', FShortName);
  dst.AddPair('name', FName);
end;

{ TOrgTypeList }

class function TOrgTypeList.ItemClassType: TFieldSetClass;
begin
  Result := TOrgType;
end;

end.
