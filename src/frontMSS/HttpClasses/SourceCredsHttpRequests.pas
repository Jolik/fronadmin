unit SourceCredsHttpRequests;

interface

uses
  System.SysUtils, System.JSON,
  EntityUnit, HttpClientUnit, BaseRequests, BaseResponses,
  SourceCredsUnit;

type
  TSourceCredsListResponse = class(TListResponse)
  private
    function GetSourceCredsList: TSourceCredsList;
  protected
    procedure SetResponse(const Value: string); override;
  public
    constructor Create;
    property SourceCredsList: TSourceCredsList read GetSourceCredsList;
  end;

  TSourceCredsInfoResponse = class(TEntityResponse)
  private
    function GetSourceCreds: TSourceCreds;
  public
    constructor Create;
    property SourceCreds: TSourceCreds read GetSourceCreds;
  end;

  TSourceCredsReqList = class(TReqList)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TSourceCredsReqInfo = class(TReqInfo)
  public
    constructor Create; override;
    constructor CreateID(const AId: string);
  end;

  TSourceCredsReqNew = class(TReqNew)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TSourceCredsReqUpdate = class(TReqUpdate)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TSourceCredsReqRemove = class(TReqRemove)
  public
    constructor Create; override;
  end;

implementation

{ TSourceCredsListResponse }

constructor TSourceCredsListResponse.Create;
begin
  inherited Create(TSourceCredsList, 'response', 'credentials');
end;

function TSourceCredsListResponse.GetSourceCredsList: TSourceCredsList;
begin
  Result := EntityList as TSourceCredsList;
end;

procedure TSourceCredsListResponse.SetResponse(const Value: string);
var
  JSONResult: TJSONObject;
  RootObject: TJSONObject;
  CredsValue: TJSONValue;
  ItemsArray: TJSONArray;
begin
  inherited SetResponse(Value);
  SourceCredsList.Clear;

  if Value.Trim.IsEmpty then Exit;

  JSONResult := TJSONObject.ParseJSONValue(Value) as TJSONObject;
  try
    if not Assigned(JSONResult) then Exit;

    RootObject := JSONResult.GetValue('response') as TJSONObject;
    if not Assigned(RootObject) then Exit;

    CredsValue := RootObject.GetValue('credentials');
    ItemsArray := nil;

    if CredsValue is TJSONArray then
      ItemsArray := TJSONArray(CredsValue)
    else if CredsValue is TJSONObject then
      ItemsArray := TJSONObject(CredsValue).GetValue('items') as TJSONArray;

    if Assigned(ItemsArray) then
      SourceCredsList.ParseList(ItemsArray);
  finally
    JSONResult.Free;
  end;
end;

{ TSourceCredsInfoResponse }

constructor TSourceCredsInfoResponse.Create;
begin
  inherited Create(TSourceCreds, 'response', 'credential');
end;

function TSourceCredsInfoResponse.GetSourceCreds: TSourceCreds;
begin
  Result := Entity as TSourceCreds;
end;

{ Requests }

class function TSourceCredsReqList.BodyClassType: TFieldSetClass;
begin
  Result := TReqListBody;
end;

constructor TSourceCredsReqList.Create;
begin
  inherited Create;
  SetEndpoint('sources/contexts/creds/list');
end;

constructor TSourceCredsReqInfo.Create;
begin
  inherited Create;
  SetEndpoint('sources/contexts/creds');
end;

constructor TSourceCredsReqInfo.CreateID(const AId: string);
begin
  Create;
  Id := AId;
end;

class function TSourceCredsReqNew.BodyClassType: TFieldSetClass;
begin
  Result := TSourceCreds;
end;

constructor TSourceCredsReqNew.Create;
begin
  inherited Create;
  SetEndpoint('sources/contexts/creds/new');
end;

class function TSourceCredsReqUpdate.BodyClassType: TFieldSetClass;
begin
  Result := TSourceCreds;
end;

constructor TSourceCredsReqUpdate.Create;
begin
  inherited Create;
  SetEndpoint('sources/contexts/creds');
end;

constructor TSourceCredsReqRemove.Create;
begin
  inherited Create;
  SetEndpoint('sources/contexts/creds');
end;

end.

