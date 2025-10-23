unit AbonentHttpRequests;

interface

uses
  System.SysUtils,
  System.JSON,
  EntityUnit,
  HttpClientUnit,
  StringListUnit,
  AbonentUnit;

type
  /// <summary>
  ///   Helper field set that stores the identifier of the newly created abonent.
  /// </summary>
  TAbonentNewResult = class(TFieldSet)
  private
    FAbid: string;
  public
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    property Abid: string read FAbid write FAbid;
  end;

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
    constructor Create;
    // Ensures the abonent instance is released together with the response wrapper.
    destructor Destroy; override;
    // Provides read-only access to the parsed abonent entity.
    property Abonent: TAbonent read FAbonent;
  end;

  /// <summary>
  ///   Request body for abonent creation requests.
  /// </summary>
  TAbonentReqNewBody = class(THttpReqBody)
  private
    FName: string;
    FCaption: string;
    FAbid: string;
    FChannels: TStringArray;
    FAttr: TKeyValueStringList;
    procedure SetName(const Value: string);
    procedure SetCaption(const Value: string);
    procedure SetAbid(const Value: string);
  protected
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure UpdateRawContent;
    property Name: string read FName write SetName;
    property Caption: string read FCaption write SetCaption;
    property Abid: string read FAbid write SetAbid;
    property Channels: TStringArray read FChannels;
    property Attr: TKeyValueStringList read FAttr;
  end;

  /// <summary>
  ///   Response wrapper that parses abonent creation payloads.
  /// </summary>
  TAbonentNewResponse = class(TJSONResponse)
  private
    FAbonentNewRes: TAbonentNewResult;
  protected
    procedure SetResponse(const Value: string); override;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property AbonentNewRes: TAbonentNewResult read FAbonentNewRes;
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

  /// <summary>
  ///   HTTP request descriptor for /abonents/new endpoint.
  /// </summary>
  TAbonentReqNew = class(THttpRequest)
  private
    function GetBody: TAbonentReqNewBody;
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    property Body: TAbonentReqNewBody read GetBody;
  end;

implementation

uses
  LoggingUnit;

const
  PageSizeKey = 'pagesize';
  DefaultPageSize = 50;

  AbidKey = 'abid';
  NameKey = 'name';
  CaptionKey = 'caption';
  ChannelsKey = 'channels';
  AttrKey = 'attr';

{ TAbonentNewResult }

procedure TAbonentNewResult.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  Value: TJSONValue;
begin
  FAbid := '';

  if not Assigned(src) then
    Exit;

  Value := src.Values[AbidKey];
  if Value is TJSONString then
    FAbid := TJSONString(Value).Value
  else if Assigned(Value) then
    FAbid := Value.ToString;
end;

procedure TAbonentNewResult.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then
    Exit;

  dst.AddPair(AbidKey, TJSONString.Create(FAbid));
end;

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

{ TAbonentReqNewBody }

constructor TAbonentReqNewBody.Create;
begin
  inherited Create;
  FChannels := TStringArray.Create;
  FAttr := TKeyValueStringList.Create;
  FName := '';
  FCaption := '';
  FAbid := '';
  UpdateRawContent;
end;

destructor TAbonentReqNewBody.Destroy;
begin
  FAttr.Free;
  FChannels.Free;
  inherited;
end;

procedure TAbonentReqNewBody.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  Value: TJSONValue;
begin
  inherited Parse(src, APropertyNames);

  FName := '';
  FCaption := '';
  FAbid := '';

  if not Assigned(FChannels) then
    FChannels := TStringArray.Create
  else
    FChannels.Clear;

  if not Assigned(FAttr) then
    FAttr := TKeyValueStringList.Create
  else
    FAttr.Clear;

  if Assigned(src) then
  begin
    Value := src.Values[NameKey];
    if Value is TJSONString then
      FName := TJSONString(Value).Value
    else if Assigned(Value) then
      FName := Value.ToString;

    Value := src.Values[CaptionKey];
    if Value is TJSONString then
      FCaption := TJSONString(Value).Value
    else if Assigned(Value) then
      FCaption := Value.ToString;

    Value := src.Values[AbidKey];
    if Value is TJSONString then
      FAbid := TJSONString(Value).Value
    else if Assigned(Value) then
      FAbid := Value.ToString;

    Value := src.Values[ChannelsKey];
    if Value is TJSONArray then
      FChannels.Parse(TJSONArray(Value));

    Value := src.Values[AttrKey];
    if Value is TJSONObject then
      FAttr.Parse(TJSONObject(Value));
  end;

  UpdateRawContent;
end;

procedure TAbonentReqNewBody.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  ChannelsArray: TJSONArray;
  AttrObject: TJSONObject;
begin
  if not Assigned(dst) then
    Exit;

  inherited Serialize(dst, APropertyNames);

  dst.AddPair(NameKey, FName);
  dst.AddPair(CaptionKey, FCaption);

  if not FAbid.IsEmpty then
    dst.AddPair(AbidKey, FAbid);

  ChannelsArray := TJSONArray.Create;
  try
    if Assigned(FChannels) then
      FChannels.Serialize(ChannelsArray);
    dst.AddPair(ChannelsKey, ChannelsArray);
    ChannelsArray := nil;
  finally
    ChannelsArray.Free;
  end;

  AttrObject := TJSONObject.Create;
  try
    if Assigned(FAttr) then
      FAttr.Serialize(AttrObject);
    dst.AddPair(AttrKey, AttrObject);
    AttrObject := nil;
  finally
    AttrObject.Free;
  end;
end;

procedure TAbonentReqNewBody.SetName(const Value: string);
begin
  if FName <> Value then
  begin
    FName := Value;
    UpdateRawContent;
  end;
end;

procedure TAbonentReqNewBody.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    UpdateRawContent;
  end;
end;

procedure TAbonentReqNewBody.SetAbid(const Value: string);
begin
  if FAbid <> Value then
  begin
    FAbid := Value;
    UpdateRawContent;
  end;
end;

procedure TAbonentReqNewBody.UpdateRawContent;
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

{ TAbonentNewResponse }

constructor TAbonentNewResponse.Create;
begin
  inherited Create;
  FAbonentNewRes := TAbonentNewResult.Create;
end;

destructor TAbonentNewResponse.Destroy;
begin
  FAbonentNewRes.Free;
  inherited;
end;

procedure TAbonentNewResponse.SetResponse(const Value: string);
var
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
begin
  inherited SetResponse(Value);

  if not Assigned(FAbonentNewRes) then
    FAbonentNewRes := TAbonentNewResult.Create
  else
    FAbonentNewRes.Abid := '';

  if Value.Trim.IsEmpty then
    Exit;

  JSONResult := nil;
  try
    try
      JSONResult := TJSONObject.ParseJSONValue(Value) as TJSONObject;
      if not Assigned(JSONResult) then
        Exit;

      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      if not Assigned(ResponseObject) then
        Exit;

      FAbonentNewRes.Parse(ResponseObject);
    except
      on E: Exception do
      begin
        Log('TAbonentNewResponse.SetResponse ' + E.Message, lrtError);
        FAbonentNewRes.Abid := '';
      end;
    end;
  finally
    JSONResult.Free;
  end;
end;

{ TAbonentReqNew }

class function TAbonentReqNew.BodyClassType: TFieldSetClass;
begin
  Result := TAbonentReqNewBody;
end;

constructor TAbonentReqNew.Create;
begin
  inherited Create;
  Method := mPOST;
  URL := '/router/api/v2/abonents/new';
  Headers.AddOrSetValue('Content-Type', 'application/json');
  Headers.AddOrSetValue('Accept', 'application/json');
end;

function TAbonentReqNew.GetBody: TAbonentReqNewBody;
begin
  if ReqBody is TAbonentReqNewBody then
    Result := TAbonentReqNewBody(ReqBody)
  else
    Result := nil;
end;

end.
