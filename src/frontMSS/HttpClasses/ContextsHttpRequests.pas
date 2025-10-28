unit ContextsHttpRequests;

interface

uses
  System.SysUtils, System.JSON,
  EntityUnit, HttpClientUnit, BaseRequests, BaseResponses,
  ContextUnit;

type
  TContextListResponse = class(TListResponse)
  private
    function GetContextList: TContextList;
  protected
    procedure SetResponse(const Value: string); override;
  public
    constructor Create;
    property ContextList: TContextList read GetContextList;
  end;

  TContextInfoResponse = class(TEntityResponse)
  private
    function GetContext: TContext;
  public
    constructor Create;
    property Context: TContext read GetContext;
  end;

  TContextReqList = class(TReqList)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TContextReqInfo = class(TReqInfo)
  public
    constructor Create; override;
    constructor CreateID(const AId: string);
  end;

  TContextReqNew = class(TReqNew)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TContextReqUpdate = class(TReqUpdate)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TContextReqRemove = class(TReqRemove)
  public
    constructor Create; override;
  end;

implementation

{ TContextListResponse }

constructor TContextListResponse.Create;
begin
  inherited Create(TContextList, 'response', 'contexts');
end;

function TContextListResponse.GetContextList: TContextList;
begin
  Result := EntityList as TContextList;
end;

procedure TContextListResponse.SetResponse(const Value: string);
var
  JSONResult: TJSONObject;
  RootObject: TJSONObject;
  ContextsValue: TJSONValue;
  ItemsArray: TJSONArray;
begin
  inherited SetResponse(Value);
  ContextList.Clear;

  if Value.Trim.IsEmpty then Exit;

  JSONResult := TJSONObject.ParseJSONValue(Value) as TJSONObject;
  try
    if not Assigned(JSONResult) then Exit;

    RootObject := JSONResult.GetValue('response') as TJSONObject;
    if not Assigned(RootObject) then Exit;

    ContextsValue := RootObject.GetValue('contexts');
    ItemsArray := nil;

    if ContextsValue is TJSONArray then
      ItemsArray := TJSONArray(ContextsValue)
    else if ContextsValue is TJSONObject then
      ItemsArray := TJSONObject(ContextsValue).GetValue('items') as TJSONArray;

    if Assigned(ItemsArray) then
      ContextList.ParseList(ItemsArray);
  finally
    JSONResult.Free;
  end;
end;

{ TContextInfoResponse }

constructor TContextInfoResponse.Create;
begin
  inherited Create(TContext, 'response', 'context');
end;

function TContextInfoResponse.GetContext: TContext;
begin
  Result := Entity as TContext;
end;

{ Requests }

class function TContextReqList.BodyClassType: TFieldSetClass;
begin
  Result := TReqListBody;
end;

constructor TContextReqList.Create;
begin
  inherited Create;
  SetEndpoint('sources/contexts/list');
end;

constructor TContextReqInfo.Create;
begin
  inherited Create;
  SetEndpoint('sources/contexts');
end;

constructor TContextReqInfo.CreateID(const AId: string);
begin
  Create;
  Id := AId;
end;

class function TContextReqNew.BodyClassType: TFieldSetClass;
begin
  Result := TContext;
end;

constructor TContextReqNew.Create;
begin
  inherited Create;
  SetEndpoint('sources/contexts/new');
end;

class function TContextReqUpdate.BodyClassType: TFieldSetClass;
begin
  Result := TContext;
end;

constructor TContextReqUpdate.Create;
begin
  inherited Create;
  SetEndpoint('sources/contexts');
end;

constructor TContextReqRemove.Create;
begin
  inherited Create;
  SetEndpoint('sources/contexts');
end;

end.

