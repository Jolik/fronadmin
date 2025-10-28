unit CompanyHttpRequests;

interface

uses
  System.SysUtils, System.JSON,
  EntityUnit, HttpClientUnit, BaseRequests, BaseResponses,
  CompanyUnit;

type
  TCompanyListResponse = class(TListResponse)
  private
    function GetCompanyList: TCompanyList;
  protected
    procedure SetResponse(const Value: string); override;
  public
    constructor Create;
    property CompanyList: TCompanyList read GetCompanyList;
  end;

  TCompanyInfoResponse = class(TEntityResponse)
  private
    function GetCompany: TCompany;
  public
    constructor Create;
    property Company: TCompany read GetCompany;
  end;

  TCompanyReqList = class(TReqList)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TCompanyReqInfo = class(TReqInfo)
  public
    constructor Create; override;
    constructor CreateID(const AId: string);
  end;

  TCompanyReqNew = class(TReqNew)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TCompanyReqUpdate = class(TReqUpdate)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TCompanyReqRemove = class(TReqRemove)
  public
    constructor Create; override;
  end;

implementation

{ TCompanyListResponse }

constructor TCompanyListResponse.Create;
begin
  inherited Create(TCompanyList, 'response', 'companies');
end;

function TCompanyListResponse.GetCompanyList: TCompanyList;
begin
  Result := EntityList as TCompanyList;
end;

procedure TCompanyListResponse.SetResponse(const Value: string);
var
  JSONResult: TJSONObject;
  RootObject: TJSONObject;
  CompaniesValue: TJSONValue;
  ItemsArray: TJSONArray;
begin
  inherited SetResponse(Value);
  CompanyList.Clear;

  if Value.Trim.IsEmpty then Exit;

  JSONResult := TJSONObject.ParseJSONValue(Value) as TJSONObject;
  try
    if not Assigned(JSONResult) then Exit;

    RootObject := JSONResult.GetValue('response') as TJSONObject;
    if not Assigned(RootObject) then Exit;

    CompaniesValue := RootObject.GetValue('companies');
    ItemsArray := nil;

    if CompaniesValue is TJSONArray then
      ItemsArray := TJSONArray(CompaniesValue)
    else if CompaniesValue is TJSONObject then
      ItemsArray := TJSONObject(CompaniesValue).GetValue('items') as TJSONArray;

    if Assigned(ItemsArray) then
      CompanyList.ParseList(ItemsArray);
  finally
    JSONResult.Free;
  end;
end;

{ TCompanyInfoResponse }

constructor TCompanyInfoResponse.Create;
begin
  inherited Create(TCompany, 'response', 'company');
end;

function TCompanyInfoResponse.GetCompany: TCompany;
begin
  Result := Entity as TCompany;
end;

{ Requests }

class function TCompanyReqList.BodyClassType: TFieldSetClass;
begin
  Result := TReqListBody;
end;

constructor TCompanyReqList.Create;
begin
  inherited Create;
  SetEndpoint('companies/list');
end;

constructor TCompanyReqInfo.Create;
begin
  inherited Create;
  SetEndpoint('companies');
end;

constructor TCompanyReqInfo.CreateID(const AId: string);
begin
  Create;
  Id := AId;
end;

class function TCompanyReqNew.BodyClassType: TFieldSetClass;
begin
  Result := TCompany;
end;

constructor TCompanyReqNew.Create;
begin
  inherited Create;
  SetEndpoint('companies/new');
end;

class function TCompanyReqUpdate.BodyClassType: TFieldSetClass;
begin
  Result := TCompany;
end;

constructor TCompanyReqUpdate.Create;
begin
  inherited Create;
  SetEndpoint('companies');
end;

constructor TCompanyReqRemove.Create;
begin
  inherited Create;
  SetEndpoint('companies');
end;

end.

