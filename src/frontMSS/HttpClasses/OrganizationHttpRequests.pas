unit OrganizationHttpRequests;

interface

uses
  System.SysUtils,
  EntityUnit,
  HttpClientUnit,
  BaseRequests,
  BaseResponses,
  OrganizationUnit;

type
  // Response for /organizations/list
  TOrganizationListResponse = class(TFieldSetListResponse)
  private
    function GetOrganizationList: TOrganizationList;
  public
    constructor Create; override;
    property OrganizationList: TOrganizationList read GetOrganizationList;
  end;

  // Response for /organizations/types/list or /orgTypes/list
  TOrgTypeListResponse = class(TFieldSetListResponse)
  private
    function GetOrgTypeList: TOrgTypeList;
  public
    constructor Create; override;
    property OrgTypeList: TOrgTypeList read GetOrgTypeList;
  end;

  // GET /organizations/list
  TOrganizationReqList = class(TReqList)
  private
    FOrgTypeFilter: string;
    procedure SetOrgTypeFilter(const Value: string);
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;

    // Comma separated ids for the orgtype query parameter
    property OrgTypeFilter: string read FOrgTypeFilter write SetOrgTypeFilter;
    procedure SetOrgTypeIds(const Values: array of Integer);
  end;

  // GET /organizations/types/list
  TOrganizationTypesReqList = class(TReqList)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

implementation

{ TOrganizationListResponse }

constructor TOrganizationListResponse.Create;
begin
  inherited Create(TOrganizationList, 'response', 'organizations');
end;

function TOrganizationListResponse.GetOrganizationList: TOrganizationList;
begin
  Result := FieldSetList as TOrganizationList;
end;

{ TOrgTypeListResponse }

constructor TOrgTypeListResponse.Create;
begin
  inherited Create(TOrgTypeList, 'response', 'orgTypes');
end;

function TOrgTypeListResponse.GetOrgTypeList: TOrgTypeList;
begin
  Result := FieldSetList as TOrgTypeList;
end;

{ TOrganizationReqList }

class function TOrganizationReqList.BodyClassType: TFieldSetClass;
begin
  Result := inherited;
end;

constructor TOrganizationReqList.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('organizations/list');
end;

procedure TOrganizationReqList.SetOrgTypeFilter(const Value: string);
begin
  FOrgTypeFilter := Value.Trim;
  if FOrgTypeFilter.IsEmpty then
    Params.Remove('orgtype')
  else
    Params.AddOrSetValue('orgtype', FOrgTypeFilter);
end;

procedure TOrganizationReqList.SetOrgTypeIds(const Values: array of Integer);
var
  Builder: TStringBuilder;
  I: Integer;
begin
  Builder := TStringBuilder.Create;
  try
    for I := Low(Values) to High(Values) do
    begin
      if Builder.Length > 0 then
        Builder.Append(',');
      Builder.Append(Values[I]);
    end;
    OrgTypeFilter := Builder.ToString;
  finally
    Builder.Free;
  end;
end;

{ TOrganizationTypesReqList }

class function TOrganizationTypesReqList.BodyClassType: TFieldSetClass;
begin
  Result := inherited;
end;

constructor TOrganizationTypesReqList.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('organizations/types/list');
end;

end.
