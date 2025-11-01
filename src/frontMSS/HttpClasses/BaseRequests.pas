unit BaseRequests;

interface

uses
  System.SysUtils,
  System.JSON,
  EntityUnit,
  HttpClientUnit,
  StringListUnit;

type
  // Base router-aware HTTP request with a configurable base path and endpoint helper
  TBaseServiceRequest = class(THttpRequest)
  private
    FBasePath: string;
    FEndpoint: string;
    function CombinePaths(const BasePath, Endpoint: string): string;
    procedure SetBasePath(const Value: string);
  public
    constructor Create; override;
    procedure SetEndpoint(const Endpoint: string);
    property BasePath: string read FBasePath write SetBasePath;
    property Endpoint: string read FEndpoint write SetEndpoint;
  end;

  // Base request body with pagination parameters
  TPageReqBody = class(THttpReqBody)
  private
    FPage: Integer;
    FPageSize: Integer;
  protected
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
  public
    constructor Create; override;
    property Page: Integer read FPage write FPage;
    property PageSize: Integer read FPageSize write FPageSize;
  end;

  // Generic body for list requests (search, ordering and scope filters), inherits pagination
  TReqListBody = class(TPageReqBody)
  private
    FSearchBy: string;
    FSearchStr: string;
    FOrder: string;
    FOrderDir: string;
    FDeptIds: TStringArray;
    FCompIds: TStringArray;
  protected
    procedure UpdateRawContent;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    property SearchBy: string read FSearchBy write FSearchBy;
    property SearchStr: string read FSearchStr write FSearchStr;
    property Order: string read FOrder write FOrder;
    property OrderDir: string read FOrderDir write FOrderDir;
    property DeptIds: TStringArray read FDeptIds;
    property CompIds: TStringArray read FCompIds;
  end;

  // Base list request
  TReqList = class(TBaseServiceRequest)
  protected
    class function BodyClassType: TFieldSetClass; override;
    function GetReqBodyContent: string;override;
  public
    constructor Create; override;
    function Body: TReqListBody;
  end;

  // Base info request by identifier
  TReqInfo = class(TBaseServiceRequest)
  private
    FId: string;
    procedure SetId(const Value: string);
  protected
    // Builds URL AddPath for the current Id. Descendants may override
    // to append custom suffixes (e.g., '/info').
    function BuildAddPath(const Id: string): string; virtual;
  public
    constructor Create; override;
    constructor CreateID(const AId: string); reintroduce; overload;
    property Id: string read FId write SetId;
  end;

  // Base create request (POST with entity body)
  TReqNew = class(TBaseServiceRequest)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    // Copies fields from an entity into the request body when possible.
    // Default implementation assigns TFieldSet contents if both sides are field sets.
    procedure ApplyBody(AEntity: TFieldSet); virtual;
    class function NewBody:TFieldSet;
  end;

  // Base update request by identifier (POST/PUT with entity body)
  TReqUpdate = class(TBaseServiceRequest)
  private
    FId: string;
    procedure SetId(const Value: string);
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    // Copies fields from an entity into the request body when possible.
    // Default implementation assigns TFieldSet contents if both sides are field sets.
    procedure ApplyFromEntity(AEntity: TEntity); virtual;
    property Id: string read FId write SetId;
  end;

  // Base remove request by identifier
  TReqRemove = class(TBaseServiceRequest)
  private
    FId: string;
    procedure SetId(const Value: string);
  public
    constructor Create; override;
    constructor CreateID(const AId: string); reintroduce; overload;
    property Id: string read FId write SetId;
  end;

implementation

uses
  APIConst;

{ TBaseRouterRequest }

function TBaseServiceRequest.CombinePaths(const BasePath, Endpoint: string): string;
var
  B, E: string;
begin
  B := BasePath.Trim;
  E := Endpoint.Trim;
  while (B <> '') and B.EndsWith('/') do
    B := B.Substring(0, B.Length - 1);
  while (E <> '') and E.StartsWith('/') do
    E := E.Substring(1);

  if B.IsEmpty then
    Result := '/' + E
  else if E.IsEmpty then
    Result := B
  else
    Result := B + '/' + E;
end;

constructor TBaseServiceRequest.Create;
begin
  inherited Create;
  Headers.AddOrSetValue('Content-Type', 'application/json');
  Headers.AddOrSetValue('Accept', 'application/json');
  // Descendants must set BasePath and call SetEndpoint
end;

procedure TBaseServiceRequest.SetEndpoint(const Endpoint: string);
begin
  FEndpoint := Endpoint.Trim;
  while (FEndpoint <> '') and (FEndpoint.Chars[0] = '/') do
    FEndpoint := FEndpoint.Substring(1);
  URL := CombinePaths(FBasePath, FEndpoint);
end;

procedure TBaseServiceRequest.SetBasePath(const Value: string);
begin
  FBasePath := Value.Trim;
  URL := CombinePaths(FBasePath, FEndpoint);
end;

{ TReqListBody }

{ TPageReqBody }

constructor TPageReqBody.Create;
begin
  inherited Create;
  FPage := 1;
  FPageSize := 200;
end;

procedure TPageReqBody.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Parse(src, APropertyNames);
end;

procedure TPageReqBody.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Serialize(dst, APropertyNames);
  dst.AddPair('page', FPage);
  dst.AddPair('pagesize', FPageSize);
end;

{ TReqListBody }

constructor TReqListBody.Create;
begin
  inherited Create;
  FDeptIds := TStringArray.Create;
  FCompIds := TStringArray.Create;
  // Do not set default ordering globally; entities can add it explicitly
  FOrder := '';
  FOrderDir := '';
  UpdateRawContent;
end;

destructor TReqListBody.Destroy;
begin
  FDeptIds.Free;
  FCompIds.Free;
  inherited;
end;

procedure TReqListBody.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Parse(src, APropertyNames);
  // Keep base implementation minimal; entity-specific logic belongs in descendants
end;

procedure TReqListBody.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  Arr: TJSONArray;
  S: string;
begin
  inherited Serialize(dst, APropertyNames);
  if not FSearchBy.IsEmpty then dst.AddPair('searchBy', FSearchBy);
  if not FSearchStr.IsEmpty then dst.AddPair('searchStr', FSearchStr);
  if not FOrder.IsEmpty then
  begin
    Arr := TJSONArray.Create;
    Arr.Add(FOrder);
    dst.AddPair('order', Arr);
  end;
  if not FOrderDir.IsEmpty then dst.AddPair('orderDir', FOrderDir);

  if Assigned(FDeptIds) and (FDeptIds.Count > 0) then
  begin
    Arr := TJSONArray.Create;
    for S in FDeptIds.ToArray do
      Arr.Add(S);
    dst.AddPair('deptid', Arr);
  end;

  if Assigned(FCompIds) and (FCompIds.Count > 0) then
  begin
    Arr := TJSONArray.Create;
    for S in FCompIds.ToArray do
      Arr.Add(S);
    dst.AddPair('compid', Arr);
  end;
end;

procedure TReqListBody.UpdateRawContent;
var
  Obj: TJSONObject;
begin
  Obj := TJSONObject.Create;
  try
    Serialize(Obj);
    RawContent := Obj.ToJSON;
  finally
    Obj.Free;
  end;
end;

{ TReqList }

class function TReqList.BodyClassType: TFieldSetClass;
begin
  Result := TReqListBody;
end;

constructor TReqList.Create;
begin
  inherited Create;
  Method := mPOST;
end;

function TReqList.GetReqBodyContent: string;
var
  LBody: TReqListBody;
begin
  LBody := Body;

  if Method = mGET then
  begin
    if Assigned(LBody) then
    begin
      Params.AddOrSetValue('page', IntToStr(LBody.Page));
      Params.AddOrSetValue('pagesize', IntToStr(LBody.PageSize));
    end
    else
    begin
      Params.Remove('page');
      Params.Remove('pagesize');
    end;
    Exit('');
  end;

  if Assigned(Params) then
  begin
    Params.Remove('page');
    Params.Remove('pagesize');
  end;

  if Assigned(LBody) then
  begin
    Result := LBody.JSON;
    LBody.RawContent := Result;
  end
  else
    Result := inherited GetReqBodyContent;
end;

function TReqList.Body: TReqListBody;
begin
  if ReqBody is TReqListBody then
    Result := TReqListBody(ReqBody)
  else
    Result := nil;
end;

{ TReqInfo }

constructor TReqInfo.Create;
begin
  inherited Create;
  Method := mGET;
  FId := '';
  AddPath := '';
end;

constructor TReqInfo.CreateID(const AId: string);
begin
  Create;
  Id := AId;
end;

procedure TReqInfo.SetId(const Value: string);
var
  Normalized: string;
begin
  Normalized := Value.Trim;
  if FId = Normalized then Exit;
  FId := Normalized;
  AddPath := BuildAddPath(FId);
end;

function TReqInfo.BuildAddPath(const Id: string): string;
begin
  if Id.IsEmpty then
    Result := ''
  else
    Result := Id;
end;

{ TReqNew }

class function TReqNew.BodyClassType: TFieldSetClass;
begin
  // By default request body is plain JSON blob, descendants can override with specific entity class
  Result := nil;
end;

constructor TReqNew.Create;
begin
  inherited Create;
  Method := mPOST;
end;

class function TReqNew.NewBody: TFieldSet;
begin
  Result:= BodyClassType.Create;
end;

procedure TReqNew.ApplyBody(AEntity: TFieldSet);
begin
  if Assigned(ReqBody) and (AEntity is TFieldSet) then
    TFieldSet(ReqBody).Assign(TFieldSet(AEntity));
end;

{ TReqUpdate }

class function TReqUpdate.BodyClassType: TFieldSetClass;
begin
  // By default request body is plain JSON blob, descendants can override with specific entity class
  Result := nil;
end;

constructor TReqUpdate.Create;
begin
  inherited Create;
  Method := mPOST;
  FId := '';
  AddPath := '';
end;

procedure TReqUpdate.SetId(const Value: string);
var
  N: string;
begin
  N := Value.Trim;
  if FId = N then Exit;
  FId := N;
  if FId.IsEmpty then
    AddPath := ''
  else
    AddPath := Format('%s/update', [FId]);
end;

procedure TReqUpdate.ApplyFromEntity(AEntity: TEntity);
begin
  if Assigned(ReqBody) and (AEntity is TFieldSet) then
    TFieldSet(ReqBody).Assign(TFieldSet(AEntity));
end;

{ TReqRemove }

constructor TReqRemove.Create;
begin
  inherited Create;
  Method := mPOST;
  FId := '';
  AddPath := '';
end;

constructor TReqRemove.CreateID(const AId: string);
begin
  Create;
  Id := AId;
end;

procedure TReqRemove.SetId(const Value: string);
var
  N: string;
begin
  N := Value.Trim;
  if FId = N then Exit;
  FId := N;
  if FId.IsEmpty then
    AddPath := ''
  else
    AddPath := Format('%s/remove', [FId]);
end;

end.
