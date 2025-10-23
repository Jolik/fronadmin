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
  ///   HTTP request descriptor for /abonents/list endpoint.
  /// </summary>
  TAbonentReqList = class(THttpRequest)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

implementation

uses
  LoggingUnit;

{ TAbonentReqListBody }

constructor TAbonentReqListBody.Create;
begin
  inherited Create;
  FPageSize := 50;
  UpdateRawContent;
end;

procedure TAbonentReqListBody.SetPageSize(const Value: Integer);
begin
  if Value < 0 then
    FPageSize := 0
  else
    FPageSize := Value;
  UpdateRawContent;
end;

procedure TAbonentReqListBody.UpdateRawContent;
begin
  RawContent := Format('{' + sLineBreak + ' "pagesize": %d' + sLineBreak + '}', [FPageSize]);
end;

{ TAbonentListResponse }

constructor TAbonentListResponse.Create;
begin
  inherited Create;
  FAbonentList := TAbonentList.Create;
end;

destructor TAbonentListResponse.Destroy;
begin
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

  if not Assigned(FAbonentList) then
    FAbonentList := TAbonentList.Create
  else
    FAbonentList.Clear;

  if Value.Trim.IsEmpty then
    Exit;

  JSONResult := nil;
  try
    JSONResult := TJSONObject.ParseJSONValue(Value) as TJSONObject;
    if not Assigned(JSONResult) then
      Exit;

    ResponseObject := JSONResult.GetValue('response') as TJSONObject;
    if not Assigned(ResponseObject) then
      Exit;

    AbonentsValue := ResponseObject.GetValue('abonents');
    ItemsArray := nil;

    if AbonentsValue is TJSONArray then
      ItemsArray := TJSONArray(AbonentsValue)
    else if AbonentsValue is TJSONObject then
    begin
      ItemsValue := TJSONObject(AbonentsValue).GetValue('items');
      if ItemsValue is TJSONArray then
        ItemsArray := TJSONArray(ItemsValue);
    end;

    if Assigned(ItemsArray) then
      FAbonentList.ParseList(ItemsArray);
  except
    on E: Exception do
    begin
      Log('TAbonentListResponse.SetResponse ' + E.Message, lrtError);
      FAbonentList.Clear;
    end;
  finally
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
  if ReqBody is TAbonentReqListBody then
    TAbonentReqListBody(ReqBody).PageSize := 50;
end;

end.
