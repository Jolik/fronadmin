unit AbonentHttpRequests;

interface

uses
  System.SysUtils,
  System.JSON,
  EntityUnit,
  HttpClientUnit,
  StringListUnit,
  AbonentUnit,
  BaseResponses,
  BaseRequests;


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
  TAbonentReqListBody = class(TReqListBody)
  end;

  /// <summary>
  ///   Response wrapper that parses abonent list payloads.
  /// </summary>
  TAbonentListResponse = class(TListResponse)
  private
    function GetAbonentList: TAbonentList;
  public
    constructor Create;
    property AbonentList: TAbonentList read GetAbonentList;
  end;

  /// <summary>
  ///   Response wrapper that parses abonent info payloads.
  /// </summary>
  TAbonentInfoResponse = class(TEntityResponse)
  private
    function GetAbonent: TAbonent;
  public
    constructor Create;
    property Abonent: TAbonent read GetAbonent;
  end;

  /// <summary>
  ///   Request body for abonent creation requests.
  /// </summary>
  TAbonentReqNewUpdateBody = class(THttpReqBody)
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
  ///   Inherits common FieldSet-based response.
  /// </summary>
  TAbonentNewResponse = class(TFieldSetResponse)
  private
    function GetAbonentNewRes: TAbonentNewResult;
  public
    constructor Create; reintroduce; virtual;
    property AbonentNewRes: TAbonentNewResult read GetAbonentNewRes;
  end;

  /// <summary>
  ///   HTTP request descriptor for /abonents/list endpoint.
  /// </summary>
  TAbonentReqList = class(TReqList)
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
  TAbonentReqNew = class(TReqNew)
  private
    function GetBody: TAbonentReqNewUpdateBody;
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    property Body: TAbonentReqNewUpdateBody read GetBody;
  end;

  /// <summary>
  ///   HTTP request descriptor for /abonents/:abid/update endpoint.
  /// </summary>
  TAbonentReqUpdate = class(TReqUpdate)
  private
    function GetBody: TAbonentReqNewUpdateBody;
    procedure SetAbonentId(const Value: string);
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    /// <summary>
    ///   Identifier of the abonent being updated. Assigning the value appends
    ///   the required "/:abid/update" suffix to the request URL via AddPath.
    /// </summary>
    property AbonentId: string write SetAbonentId;
    property Body: TAbonentReqNewUpdateBody read GetBody;
  end;

  /// <summary>
  ///   HTTP request descriptor for /rou/:abid/remove endpoint.
  /// </summary>
  TAbonentReqRemove = class(TReqRemove)
  private
    procedure SetAbonentId(const Value: string);
  public
    constructor Create; override;
    /// <summary>
    ///   Identifier of the abonent being removed. Assigning the value appends
    ///   the required "/:abid/remove" suffix to the request URL via AddPath.
    /// </summary>
    property AbonentId: string write SetAbonentId;
  end;

  /// <summary>
  ///   HTTP request descriptor for GET /abonents/:abid endpoint.
  /// </summary>
  TAbonentReqInfo = class(TReqInfo)
  public
    constructor Create; override;
    constructor CreateID(const AAbonentId: string);
  end;

implementation

uses
  LoggingUnit, APIConst;

const
  
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

{ TAbonentReqListBody } // now inherits all paging/search from TReqListBody

{ TAbonentListResponse }

{ TAbonentListResponse }

constructor TAbonentListResponse.Create;
begin
  inherited Create(TAbonentList, 'response', 'abonents');
end;

function TAbonentListResponse.GetAbonentList: TAbonentList;
begin
  Result := EntityList as TAbonentList;
end;
{ TAbonentReqNewUpdateBody }

constructor TAbonentReqNewUpdateBody.Create;
begin
  inherited Create;
  FName := '';
  FCaption := '';
  FAbid := '';
  FChannels := TStringArray.Create;
  FAttr := TKeyValueStringList.Create;
  UpdateRawContent;
end;

destructor TAbonentReqNewUpdateBody.Destroy;
begin
  FChannels.Free;
  FAttr.Free;
  inherited;
end;

procedure TAbonentReqNewUpdateBody.SetName(const Value: string);
begin
  if FName <> Value then
  begin
    FName := Value;
    UpdateRawContent;
  end;
end;

procedure TAbonentReqNewUpdateBody.UpdateRawContent;
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

procedure TAbonentReqNewUpdateBody.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    UpdateRawContent;
  end;
end;

procedure TAbonentReqNewUpdateBody.SetAbid(const Value: string);
begin
  if FAbid <> Value then
  begin
    FAbid := Value;
    UpdateRawContent;
  end;
end;

procedure TAbonentReqNewUpdateBody.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  V: TJSONValue;
begin
  inherited Parse(src, APropertyNames);
  if not Assigned(src) then Exit;

  V := src.Values[NameKey];
  if V is TJSONString then
    FName := TJSONString(V).Value
  else if Assigned(V) then
    FName := V.ToString;

  V := src.Values[CaptionKey];
  if V is TJSONString then
    FCaption := TJSONString(V).Value
  else if Assigned(V) then
    FCaption := V.ToString;

  V := src.Values[AbidKey];
  if V is TJSONString then
    FAbid := TJSONString(V).Value
  else if Assigned(V) then
    FAbid := V.ToString;

  V := src.Values[ChannelsKey];
  if V is TJSONArray then
  begin
    FChannels.Clear;
    FChannels.Parse(TJSONArray(V));
  end;

  V := src.Values[AttrKey];
  if V is TJSONObject then
  begin
    FAttr.Clear;
    FAttr.Parse(TJSONObject(V));
  end;
end;

procedure TAbonentReqNewUpdateBody.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  Arr: TJSONArray;
  Obj: TJSONObject;
begin
  if not Assigned(dst) then Exit;
  inherited Serialize(dst, APropertyNames);

  if not FName.Trim.IsEmpty then
    dst.AddPair(NameKey, TJSONString.Create(FName));
  if not FCaption.Trim.IsEmpty then
    dst.AddPair(CaptionKey, TJSONString.Create(FCaption));
  if not FAbid.Trim.IsEmpty then
    dst.AddPair(AbidKey, TJSONString.Create(FAbid));

  Arr := TJSONArray.Create;
  try
    if Assigned(FChannels) then
      FChannels.Serialize(Arr);
    dst.AddPair(ChannelsKey, Arr);
    Arr := nil;
  finally
    Arr.Free;
  end;

  Obj := TJSONObject.Create;
  try
    if Assigned(FAttr) then
      FAttr.Serialize(Obj);
    dst.AddPair(AttrKey, Obj);
    Obj := nil;
  finally
    Obj.Free;
  end;
end;
{ TAbonentInfoResponse }

{ TAbonentInfoResponse }

constructor TAbonentInfoResponse.Create;
begin
  inherited Create(TAbonent, 'response', 'abonent');
end;

function TAbonentInfoResponse.GetAbonent: TAbonent;
begin
  Result := Entity as TAbonent;
end;
{ TAbonentReqNew }

constructor TAbonentReqNew.Create;
begin
  inherited Create;
  Method := mPOST;
  SetEndpoint('abonents/new');
end;

 

{ TAbonentReqUpdate }

 

{ TAbonentReqRemove }

 

{ TAbonentReqInfo }

 


{ TAbonentReqList }

class function TAbonentReqList.BodyClassType: TFieldSetClass;
begin
  Result := TAbonentReqListBody;
end;

constructor TAbonentReqList.Create;
begin
  inherited Create;
  Method := mPOST;
  SetEndpoint('abonents/list');
end;

function TAbonentReqList.GetBody: TAbonentReqListBody;
begin
  if ReqBody is TAbonentReqListBody then
    Result := TAbonentReqListBody(ReqBody)
  else
    Result := nil;
end;
{ TAbonentReqNew }

class function TAbonentReqNew.BodyClassType: TFieldSetClass;
begin
  Result := TAbonentReqNewUpdateBody;
end;


function TAbonentReqNew.GetBody: TAbonentReqNewUpdateBody;
begin
  if ReqBody is TAbonentReqNewUpdateBody then
    Result := TAbonentReqNewUpdateBody(ReqBody)
  else
    Result := nil;
end;
{ TAbonentReqUpdate }

class function TAbonentReqUpdate.BodyClassType: TFieldSetClass;
begin
  Result := TAbonentReqNewUpdateBody;
end;

constructor TAbonentReqUpdate.Create;
begin
  inherited Create;
  Method := mPOST;
  SetEndpoint('abonents');
end;

function TAbonentReqUpdate.GetBody: TAbonentReqNewUpdateBody;
begin
  if ReqBody is TAbonentReqNewUpdateBody then
    Result := TAbonentReqNewUpdateBody(ReqBody)
  else
    Result := nil;
end;

procedure TAbonentReqUpdate.SetAbonentId(const Value: string);
var
  Normalized: string;
begin
  Normalized := Value.Trim;
  if Normalized.IsEmpty then
    AddPath := ''
  else
    AddPath := Format('%s/update', [Normalized]);
  Id := Normalized;
end;
{ TAbonentReqRemove }

constructor TAbonentReqRemove.Create;
begin
  inherited Create;
  Method := mPOST;
  SetEndpoint('abonents');
end;

procedure TAbonentReqRemove.SetAbonentId(const Value: string);
var
  Normalized: string;
begin
  Normalized := Value.Trim;
  if Normalized.IsEmpty then
    AddPath := ''
  else
    AddPath := Format('%s/remove', [Normalized]);
  Id := Normalized;
end;
{ TAbonentReqInfo }

constructor TAbonentReqInfo.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('abonents');
  AddPath := '';
end;

constructor TAbonentReqInfo.CreateID(const AAbonentId: string);
begin
  Create;
  Id := AAbonentId;
end;


{ TAbonentNewResponse }

constructor TAbonentNewResponse.Create;
begin
  inherited Create(TAbonentNewResult, 'response', '');
end;

function TAbonentNewResponse.GetAbonentNewRes: TAbonentNewResult;
begin
  if FieldSet is TAbonentNewResult then
    Result := TAbonentNewResult(FieldSet)
  else
    Result := nil;
end;

end.
