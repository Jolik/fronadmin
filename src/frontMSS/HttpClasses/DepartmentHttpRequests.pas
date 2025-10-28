unit DepartmentHttpRequests;

interface

uses
  System.SysUtils, System.JSON,
  EntityUnit, HttpClientUnit, BaseRequests, BaseResponses,
  DepartmentUnit;

type
  TDepartmentListResponse = class(TListResponse)
  private
    function GetDepartmentList: TDepartmentList;
  protected
    procedure SetResponse(const Value: string); override;
  public
    constructor Create;
    property DepartmentList: TDepartmentList read GetDepartmentList;
  end;

  TDepartmentInfoResponse = class(TEntityResponse)
  private
    function GetDepartment: TDepartment;
  public
    constructor Create;
    property Department: TDepartment read GetDepartment;
  end;

  TDepartmentReqList = class(TReqList)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TDepartmentReqInfo = class(TReqInfo)
  public
    constructor Create; override;
    constructor CreateID(const AId: string);
  end;

  TDepartmentReqNew = class(TReqNew)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TDepartmentReqUpdate = class(TReqUpdate)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TDepartmentReqRemove = class(TReqRemove)
  public
    constructor Create; override;
  end;

implementation

{ TDepartmentListResponse }

constructor TDepartmentListResponse.Create;
begin
  inherited Create(TDepartmentList, 'response', 'departments');
end;

function TDepartmentListResponse.GetDepartmentList: TDepartmentList;
begin
  Result := EntityList as TDepartmentList;
end;

procedure TDepartmentListResponse.SetResponse(const Value: string);
var
  JSONResult: TJSONObject;
  RootObject: TJSONObject;
  DeptsValue: TJSONValue;
  ItemsArray: TJSONArray;
begin
  inherited SetResponse(Value);
  DepartmentList.Clear;

  if Value.Trim.IsEmpty then Exit;

  JSONResult := TJSONObject.ParseJSONValue(Value) as TJSONObject;
  try
    if not Assigned(JSONResult) then Exit;

    RootObject := JSONResult.GetValue('response') as TJSONObject;
    if not Assigned(RootObject) then Exit;

    DeptsValue := RootObject.GetValue('departments');
    ItemsArray := nil;

    if DeptsValue is TJSONArray then
      ItemsArray := TJSONArray(DeptsValue)
    else if DeptsValue is TJSONObject then
      ItemsArray := TJSONObject(DeptsValue).GetValue('items') as TJSONArray;

    if Assigned(ItemsArray) then
      DepartmentList.ParseList(ItemsArray);
  finally
    JSONResult.Free;
  end;
end;

{ TDepartmentInfoResponse }

constructor TDepartmentInfoResponse.Create;
begin
  inherited Create(TDepartment, 'response', 'department');
end;

function TDepartmentInfoResponse.GetDepartment: TDepartment;
begin
  Result := Entity as TDepartment;
end;

{ Requests }

class function TDepartmentReqList.BodyClassType: TFieldSetClass;
begin
  Result := TReqListBody;
end;

constructor TDepartmentReqList.Create;
begin
  inherited Create;
  SetEndpoint('departments/list');
end;

constructor TDepartmentReqInfo.Create;
begin
  inherited Create;
  SetEndpoint('departments');
end;

constructor TDepartmentReqInfo.CreateID(const AId: string);
begin
  Create;
  Id := AId;
end;

class function TDepartmentReqNew.BodyClassType: TFieldSetClass;
begin
  Result := TDepartment;
end;

constructor TDepartmentReqNew.Create;
begin
  inherited Create;
  SetEndpoint('departments/new');
end;

class function TDepartmentReqUpdate.BodyClassType: TFieldSetClass;
begin
  Result := TDepartment;
end;

constructor TDepartmentReqUpdate.Create;
begin
  inherited Create;
  SetEndpoint('departments');
end;

constructor TDepartmentReqRemove.Create;
begin
  inherited Create;
  SetEndpoint('departments');
end;

end.

