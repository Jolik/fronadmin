unit AbonentHttpRequests;

interface

uses
  System.SysUtils,
  System.JSON,
  EntityUnit,
  HttpClientUnit,
  AbonentUnit;

type
  /// <summary>
  ///   Request body for abonent list requests.
  /// </summary>
  TAbonentReqListBody = class(THttpReqBody)
  private
    FPageSize: Integer;
    procedure SetPageSize(const Value: Integer);
    procedure UpdateRawContent;
  protected
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
  public
    constructor Create; override;
    property PageSize: Integer read FPageSize write SetPageSize;
  end;

  /// <summary>
  ///   Response wrapper that parses abonent list payloads.
  /// </summary>
  TAbonentListResponse = class(TJSONResponse)
  private
    FAbonentList: TAbonentList;
  protected
    procedure SetResponse(const Value: string); override;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property AbonentList: TAbonentList read FAbonentList;
  end;

  /// <summary>
  ///   Response wrapper that parses abonent info payloads.
  /// </summary>
  TAbonentInfoResponse = class(TJSONResponse)
  private
    // FAbonent holds the parsed abonent entity extracted from the response payload.
    FAbonent: TAbonent;
  protected
    // Overrides TJSONResponse.SetResponse to deserialize abonent details from JSON.
    procedure SetResponse(const Value: string); override;
  public
    // Creates the response wrapper and prepares the abonent placeholder.
    constructor Create; override;
    // Ensures the abonent instance is released together with the response wrapper.
    destructor Destroy; override;
    // Provides read-only access to the parsed abonent entity.
    property Abonent: TAbonent read FAbonent;
  end;

  /// <summary>
  ///   HTTP request descriptor for /abonents/list endpoint.
  /// </summary>
  TAbonentReqList = class(THttpRequest)
  private
    function GetBody: TAbonentReqListBody;
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    property Body: TAbonentReqListBody read GetBody;
  end;

implementation

uses
  LoggingUnit;

const
  PageSizeKey = 'pagesize';
  DefaultPageSize = 50;

{ TAbonentReqListBody }

constructor TAbonentReqListBody.Create;
begin
  inherited Create;
  FPageSize := DefaultPageSize;
  UpdateRawContent;
end;

procedure TAbonentReqListBody.SetPageSize(const Value: Integer);
var
  Normalized: Integer;
begin
  Normalized := Value;
  if Normalized < 0 then
    Normalized := 0;

  if FPageSize <> Normalized then
  begin
    FPageSize := Normalized;
    UpdateRawContent;
  end;
end;

procedure TAbonentReqListBody.UpdateRawContent;
var
  Payload: TJSONObject;
begin
  Payload := TJSONObject.Create;
  try
    Serialize(Payload);
    RawContent := Payload.Format;
  finally
    Payload.Free;
  end;
end;

procedure TAbonentReqListBody.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  Value: TJSONValue;
  ParsedPageSize: Integer;
begin
  inherited Parse(src, APropertyNames);

  ParsedPageSize := FPageSize;
  if Assigned(src) then
  begin
    Value := src.Values[PageSizeKey];
    if Value is TJSONNumber then
      ParsedPageSize := TJSONNumber(Value).AsInt
    else if Value is TJSONString then
    begin
      if not TryStrToInt(TJSONString(Value).Value, ParsedPageSize) then
        ParsedPageSize := FPageSize;
    end;
  end;

  SetPageSize(ParsedPageSize);
end;

procedure TAbonentReqListBody.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then
    Exit;

  inherited Serialize(dst, APropertyNames);

  dst.AddPair(PageSizeKey, TJSONNumber.Create(FPageSize));
end;

{ TAbonentListResponse }

constructor TAbonentListResponse.Create;
begin
  inherited Create;
  // Pre-create the abonent list to simplify parsing logic and avoid repeated nil checks.
  FAbonentList := TAbonentList.Create;
end;

destructor TAbonentListResponse.Destroy;
begin
  // Release the list together with the response wrapper to keep ownership clear.
  FAbonentList.Free;
  inherited;
end;

procedure TAbonentListResponse.SetResponse(const Value: string);
var
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  AbonentsValue: TJSONValue;
  ItemsArray: TJSONArray;
  ItemsValue: TJSONValue;
begin
  inherited SetResponse(Value);

  // Prepare the list to hold fresh data for every response processed by this instance.
  if not Assigned(FAbonentList) then
    FAbonentList := TAbonentList.Create
  else
    FAbonentList.Clear;

  // Abort parsing when the backend responded with an empty payload.
  if Value.Trim.IsEmpty then
    Exit;

  JSONResult := nil;
  try
    try
      // Deserialize the root JSON document returned by the API.
      JSONResult := TJSONObject.ParseJSONValue(Value) as TJSONObject;
      if not Assigned(JSONResult) then
        Exit;

      // Extract the `response` container which holds the actual abonent data.
      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      if not Assigned(ResponseObject) then
        Exit;

      // API responses might return either an array or an object with an `items` array.
      AbonentsValue := ResponseObject.GetValue('abonents');
      ItemsArray := nil;

      if AbonentsValue is TJSONArray then
        ItemsArray := TJSONArray(AbonentsValue)
      else if AbonentsValue is TJSONObject then
      begin
        // Handle the wrapped format by drilling into the `items` property.
        ItemsValue := TJSONObject(AbonentsValue).GetValue('items');
        if ItemsValue is TJSONArray then
          ItemsArray := TJSONArray(ItemsValue);
      end;

      if Assigned(ItemsArray) then
        // Delegate the heavy lifting to the entity list parser which maps fields automatically.
        FAbonentList.ParseList(ItemsArray);
    except
      on E: Exception do
      begin
        // Emit a log entry for diagnostics and clear partially parsed data.
        Log('TAbonentListResponse.SetResponse ' + E.Message, lrtError);
        FAbonentList.Clear;
      end;
    end;
  finally
    // Clean up temporary JSON structures regardless of parsing success.
    JSONResult.Free;
  end;
end;

{ TAbonentInfoResponse }

constructor TAbonentInfoResponse.Create;
begin
  inherited Create;
  // Abonent details are populated lazily during SetResponse, hence initialize with nil.
  FAbonent := nil;
end;

destructor TAbonentInfoResponse.Destroy;
begin
  // Explicitly free the abonent object to avoid leaks when the response wrapper is destroyed.
  FAbonent.Free;
  inherited;
end;

procedure TAbonentInfoResponse.SetResponse(const Value: string);
var
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  AbonentValue: TJSONValue;
begin
  inherited SetResponse(Value);

  // Reset previously parsed abonent before attempting to deserialize a new payload.
  FreeAndNil(FAbonent);

  // Guard clause: nothing to parse when the server returned an empty body.
  if Value.Trim.IsEmpty then
    Exit;

  JSONResult := nil;
  try
    try
      // Parse the root JSON document received from the server.
      JSONResult := TJSONObject.ParseJSONValue(Value) as TJSONObject;
      if not Assigned(JSONResult) then
        Exit;

      // According to API docs, abonent data is located inside the "response" object.
      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      if not Assigned(ResponseObject) then
        Exit;

      // Extract the abonent object itself. It can be absent when the identifier is unknown.
      AbonentValue := ResponseObject.GetValue('abonent');
      if AbonentValue is TJSONObject then
        // Delegate entity parsing to TAbonent, which already encapsulates field mapping logic.
        FAbonent := TAbonent.Create(TJSONObject(AbonentValue));
    except
      on E: Exception do
      begin
        // Log parsing issues for diagnostics and leave the response in a predictable state.
        Log('TAbonentInfoResponse.SetResponse ' + E.Message, lrtError);
        FreeAndNil(FAbonent);
      end;
    end;
  finally
    // Always release the temporary JSON DOM objects to avoid memory leaks.
    JSONResult.Free;
  end;
end;

{ TAbonentReqList }

class function TAbonentReqList.BodyClassType: TFieldSetClass;
begin
  Result := TAbonentReqListBody;
end;

constructor TAbonentReqList.Create;
begin
  inherited Create;
  Method := mPOST;
  URL := '/router/api/v2/abonents/list';
  Headers.AddOrSetValue('Content-Type', 'application/json');
  Headers.AddOrSetValue('Accept', 'application/json');
  if Assigned(Body) then
    Body.PageSize := DefaultPageSize;
end;

function TAbonentReqList.GetBody: TAbonentReqListBody;
begin
  if ReqBody is TAbonentReqListBody then
    Result := TAbonentReqListBody(ReqBody)
  else
    Result := nil;
end;

end.
