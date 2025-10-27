unit AliasHttpRequests;

interface

uses
  System.SysUtils,
  System.JSON,
  EntityUnit,
  HttpClientUnit,
  StringListUnit,
  BaseRequests,
  BaseResponses,
  AliasUnit;

type
  // List request body (inherits base list paging/search model)
  // For aliases we must not send default ordering keys
  TAliasReqListBody = class(TReqListBody)
  protected
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
  end;

  // Response: list of aliases
  TAliasListResponse = class(TListResponse)
  private
    function GetAliasList: TAliasList;
  public
    constructor Create;
    property AliasList: TAliasList read GetAliasList;
  end;

  // Response: alias info
  TAliasInfoResponse = class(TEntityResponse)
  private
    function GetAlias: TAlias;
  public
    constructor Create;
    property Alias: TAlias read GetAlias;
  end;

  // Create: response for new alias (contains assigned alid)
  TAliasNewResult = class(TFieldSet)
  private
    FAlid: string;
  public
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    property Alid: string read FAlid write FAlid;
  end;

  TAliasNewResponse = class(TFieldSetResponse)
  private
    function GetAliasNewRes: TAliasNewResult;
  public
    constructor Create; virtual;
    property AliasNewRes: TAliasNewResult read GetAliasNewRes;
  end;

  // Requests
  TAliasReqList = class(TReqList)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    function Body: TAliasReqListBody;
  end;

  TAliasReqInfo = class(TReqInfo)
  public
    constructor Create; override;
    constructor CreateID(const AAliasId: string);
  end;

  TAliasReqNew = class(TReqNew)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TAliasReqUpdate = class(TReqUpdate)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    procedure SetAliasId(const Value: string);
  end;

  TAliasReqRemove = class(TReqRemove)
  public
    constructor Create; override;
    procedure SetAliasId(const Value: string);
  end;

implementation

uses
  APIConst;

{ TAliasReqListBody }

procedure TAliasReqListBody.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  P: TJSONPair;
begin
  inherited Serialize(dst, APropertyNames);
  // Drop default ordering for alias list requests
  P := dst.RemovePair('order');
  if Assigned(P) then P.Free;
  P := dst.RemovePair('orderDir');
  if Assigned(P) then P.Free;
end;

{ TAliasListResponse }

constructor TAliasListResponse.Create;
begin
  inherited Create(TAliasList, 'response', 'aliases');
end;

function TAliasListResponse.GetAliasList: TAliasList;
begin
  Result := EntityList as TAliasList;
end;

{ TAliasInfoResponse }

constructor TAliasInfoResponse.Create;
begin
  inherited Create(TAlias, 'response', 'alias');
end;

function TAliasInfoResponse.GetAlias: TAlias;
begin
  Result := Entity as TAlias;
end;

{ TAliasNewResult / TAliasNewResponse }

constructor TAliasNewResponse.Create;
begin
  inherited Create(TAliasNewResult, 'response', '');
end;

function TAliasNewResponse.GetAliasNewRes: TAliasNewResult;
begin
  if FieldSet is TAliasNewResult then
    Result := TAliasNewResult(FieldSet)
  else
    Result := nil;
end;

procedure TAliasNewResult.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  V: TJSONValue;
begin
  inherited Parse(src, APropertyNames);
  if not Assigned(src) then Exit;
  FAlid := '';
  V := src.Values['alid'];
  if V is TJSONString then
    FAlid := TJSONString(V).Value
  else if Assigned(V) then
    FAlid := V.ToString;
end;

procedure TAliasNewResult.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then Exit;
  inherited Serialize(dst, APropertyNames);
  dst.AddPair('alid', TJSONString.Create(FAlid));
end;

{ TAliasReqList }

class function TAliasReqList.BodyClassType: TFieldSetClass;
begin
  Result := TAliasReqListBody;
end;

constructor TAliasReqList.Create;
begin
  inherited Create;
  // router base path is added implicitly by endpoint path
  SetEndpoint('aliases/list');
end;

function TAliasReqList.Body: TAliasReqListBody;
begin
  if ReqBody is TAliasReqListBody then
    Result := TAliasReqListBody(ReqBody)
  else
    Result := nil;
end;

{ TAliasReqInfo }

constructor TAliasReqInfo.Create;
begin
  inherited Create;
  SetEndpoint('aliases');
end;

constructor TAliasReqInfo.CreateID(const AAliasId: string);
begin
  Create;
  Id := AAliasId;
end;

{ TAliasReqNew }

class function TAliasReqNew.BodyClassType: TFieldSetClass;
begin
  Result := TAlias; // send entity JSON as body
end;

constructor TAliasReqNew.Create;
begin
  inherited Create;
  SetEndpoint('aliases/new');
end;

{ TAliasReqUpdate }

class function TAliasReqUpdate.BodyClassType: TFieldSetClass;
begin
  Result := TAlias;
end;

constructor TAliasReqUpdate.Create;
begin
  inherited Create;
  SetEndpoint('aliases');
end;

procedure TAliasReqUpdate.SetAliasId(const Value: string);
begin
  Id := Value;
end;

{ TAliasReqRemove }

constructor TAliasReqRemove.Create;
begin
  inherited Create;
  SetEndpoint('aliases');
end;

procedure TAliasReqRemove.SetAliasId(const Value: string);
begin
  Id := Value;
end;

end.
