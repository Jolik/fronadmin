unit DsGroupHttpRequests;

interface

uses
  System.SysUtils,
  System.JSON,
  EntityUnit,
  HttpClientUnit,
  StringListUnit,
  BaseRequests,
  BaseResponses,
  DsGroupUnit;

type
  // Response wrapper for /dsgroups/list
  TDsGroupListResponse = class(TListResponse)
  private
    function GetDsGroupList: TDsGroupList;
  public
    constructor Create;
    property DsGroupList: TDsGroupList read GetDsGroupList;
  end;

  // Response wrapper for /dsgroups/{id}
  TDsGroupInfoResponse = class(TEntityResponse)
  private
    function GetDsGroup: TDsGroup;
  public
    constructor Create;
    property DsGroup: TDsGroup read GetDsGroup;
  end;

  // List request body with filtering support
  TDsGroupReqListBody = class(TReqListBody)
  private
    FDsgIds: TStringArray;
    FPdsgIds: TStringArray;
    FCtxIds: TStringArray;
    FSids: TStringArray;
    FDataseriesIds: TStringArray;
    FMetadata: TJSONObject;
    procedure WriteArray(const Key: string; const Value: TStringArray; dst: TJSONObject);
  protected
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
  public
    constructor Create; override;
    destructor Destroy; override;

    property DsgIds: TStringArray read FDsgIds;
    property PdsgIds: TStringArray read FPdsgIds;
    property CtxIds: TStringArray read FCtxIds;
    property Sids: TStringArray read FSids;
    property DataseriesIds: TStringArray read FDataseriesIds;
    property Metadata: TJSONObject read FMetadata;
  end;

  TDsGroupReqList = class(TReqList)
  private
    function GetBody: TDsGroupReqListBody;
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    property Body: TDsGroupReqListBody read GetBody;
  end;

  TDsGroupReqInfo = class(TReqInfo)
  public
    constructor Create; override;
    procedure SetGroupId(const Value: string);
  end;

  TDsGroupReqNew = class(TReqNew)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TDsGroupReqUpdate = class(TReqUpdate)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    procedure SetGroupId(const Value: string);
  end;

  TDsGroupReqRemove = class(TReqRemove)
  public
    constructor Create; override;
    procedure SetGroupId(const Value: string);
  end;

  // Body for include/exclude operations
  TDsGroupDataseriesBody = class(THttpReqBody)
  private
    FDataseries: TStringArray;
  protected
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Dataseries: TStringArray read FDataseries;
  end;

  TDsGroupReqDataseries = class(TBaseServiceRequest)
  private
    FGroupId: string;
    FActionSuffix: string;
    function GetBody: TDsGroupDataseriesBody;
    procedure UpdateAddPath;
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create(const ASuffix: string); reintroduce; overload;
    constructor Create;overload;
    procedure SetGroupId(const Value: string);
    property Body: TDsGroupDataseriesBody read GetBody;
    property ActionSuffix: string read FActionSuffix;
  end;

  TDsGroupReqInclude = class(TDsGroupReqDataseries)
  public
    constructor Create; overload;
  end;

  TDsGroupReqExclude = class(TDsGroupReqDataseries)
  public
    constructor Create; overload;
  end;

implementation

{ TDsGroupListResponse }

constructor TDsGroupListResponse.Create;
begin
  inherited Create(TDsGroupList, 'response', 'dsgroups');
end;

function TDsGroupListResponse.GetDsGroupList: TDsGroupList;
begin
  Result := EntityList as TDsGroupList;
end;

{ TDsGroupInfoResponse }

constructor TDsGroupInfoResponse.Create;
begin
  inherited Create(TDsGroup, 'response', 'dsgroup');
end;

function TDsGroupInfoResponse.GetDsGroup: TDsGroup;
begin
  Result := Entity as TDsGroup;
end;

{ TDsGroupReqListBody }

constructor TDsGroupReqListBody.Create;
begin
  inherited Create;
  FDsgIds := TStringArray.Create;
  FPdsgIds := TStringArray.Create;
  FCtxIds := TStringArray.Create;
  FSids := TStringArray.Create;
  FDataseriesIds := TStringArray.Create;
  FMetadata := TJSONObject.Create;
end;

destructor TDsGroupReqListBody.Destroy;
begin
  FDsgIds.Free;
  FPdsgIds.Free;
  FCtxIds.Free;
  FSids.Free;
  FDataseriesIds.Free;
  FMetadata.Free;
  inherited;
end;

procedure TDsGroupReqListBody.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  Value: TJSONValue;
begin
  inherited Parse(src, APropertyNames);
  FDsgIds.Clear;
  FPdsgIds.Clear;
  FCtxIds.Clear;
  FSids.Clear;
  FDataseriesIds.Clear;

  Value := src.GetValue('dsgid');
  if Value is TJSONArray then
    FDsgIds.Parse(TJSONArray(Value));

  Value := src.GetValue('pdsgid');
  if Value is TJSONArray then
    FPdsgIds.Parse(TJSONArray(Value));

  Value := src.GetValue('ctxid');
  if Value is TJSONArray then
    FCtxIds.Parse(TJSONArray(Value));

  Value := src.GetValue('sid');
  if Value is TJSONArray then
    FSids.Parse(TJSONArray(Value));

  Value := src.GetValue('dsid');
  if Value is TJSONArray then
    FDataseriesIds.Parse(TJSONArray(Value));

  Value := src.GetValue('metadata');
  FMetadata.Free;
  if Value is TJSONObject then
    FMetadata := TJSONObject(Value.Clone)
  else
    FMetadata := TJSONObject.Create;
end;

procedure TDsGroupReqListBody.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Serialize(dst, APropertyNames);
  WriteArray('dsgid', FDsgIds, dst);
  WriteArray('pdsgid', FPdsgIds, dst);
  WriteArray('ctxid', FCtxIds, dst);
  WriteArray('sid', FSids, dst);
  if Assigned(FMetadata) and (FMetadata.Count > 0) then
    dst.AddPair('metadata', FMetadata.Clone as TJSONObject);
  WriteArray('dsid', FDataseriesIds, dst);
end;

procedure TDsGroupReqListBody.WriteArray(const Key: string; const Value: TStringArray; dst: TJSONObject);
var
  Arr: TJSONArray;
begin
  if not Assigned(Value) or (Value.Count = 0) then
    Exit;

  Arr := TJSONArray.Create;
  try
    Value.Serialize(Arr);
    dst.AddPair(Key, Arr);
  except
    Arr.Free;
    raise;
  end;
end;

{ TDsGroupReqList }

class function TDsGroupReqList.BodyClassType: TFieldSetClass;
begin
  Result := TDsGroupReqListBody;
end;

constructor TDsGroupReqList.Create;
begin
  inherited Create;
  SetEndpoint('dsgroups/list');
  Params.AddOrSetValue('flag', 'dataseries');
end;

function TDsGroupReqList.GetBody: TDsGroupReqListBody;
begin
  if ReqBody is TDsGroupReqListBody then
    Result := TDsGroupReqListBody(ReqBody)
  else
    Result := nil;
end;

{ TDsGroupReqInfo }

constructor TDsGroupReqInfo.Create;
begin
  inherited Create;
  SetEndpoint('dsgroups');
  Params.AddOrSetValue('flag', 'dataseries');
end;

procedure TDsGroupReqInfo.SetGroupId(const Value: string);
begin
  Id := Value;
end;

{ TDsGroupReqNew }

class function TDsGroupReqNew.BodyClassType: TFieldSetClass;
begin
  Result := TDsGroup;
end;

constructor TDsGroupReqNew.Create;
begin
  inherited Create;
  SetEndpoint('dsgroups/new');
end;

{ TDsGroupReqUpdate }

class function TDsGroupReqUpdate.BodyClassType: TFieldSetClass;
begin
  Result := TDsGroup;
end;

constructor TDsGroupReqUpdate.Create;
begin
  inherited Create;
  SetEndpoint('dsgroups');
end;

procedure TDsGroupReqUpdate.SetGroupId(const Value: string);
begin
  Id := Value;
end;

{ TDsGroupReqRemove }

constructor TDsGroupReqRemove.Create;
begin
  inherited Create;
  SetEndpoint('dsgroups');
end;

procedure TDsGroupReqRemove.SetGroupId(const Value: string);
begin
  Id := Value;
end;

{ TDsGroupDataseriesBody }

constructor TDsGroupDataseriesBody.Create;
begin
  inherited Create;
  FDataseries := TStringArray.Create;
end;

destructor TDsGroupDataseriesBody.Destroy;
begin
  FDataseries.Free;
  inherited;
end;

procedure TDsGroupDataseriesBody.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  Value: TJSONValue;
begin
  inherited Parse(src, APropertyNames);
  FDataseries.Clear;
  Value := src.GetValue('dataseries');
  if Value is TJSONArray then
    FDataseries.Parse(TJSONArray(Value));
end;

procedure TDsGroupDataseriesBody.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  Arr: TJSONArray;
begin
  inherited Serialize(dst, APropertyNames);
  if Assigned(FDataseries) and (FDataseries.Count > 0) then
  begin
    Arr := TJSONArray.Create;
    try
      FDataseries.Serialize(Arr);
      dst.AddPair('dataseries', Arr);
    except
      Arr.Free;
      raise;
    end;
  end;
end;

{ TDsGroupReqDataseries }

class function TDsGroupReqDataseries.BodyClassType: TFieldSetClass;
begin
  Result := TDsGroupDataseriesBody;
end;

constructor TDsGroupReqDataseries.Create;
begin
  Create('');
end;

constructor TDsGroupReqDataseries.Create(const ASuffix: string);
begin
  inherited Create;
  Method := mPOST;
  SetEndpoint('dsgroups');
  FGroupId := '';
  FActionSuffix := ASuffix.Trim;
  UpdateAddPath;
end;

function TDsGroupReqDataseries.GetBody: TDsGroupDataseriesBody;
begin
  if ReqBody is TDsGroupDataseriesBody then
    Result := TDsGroupDataseriesBody(ReqBody)
  else
    Result := nil;
end;

procedure TDsGroupReqDataseries.SetGroupId(const Value: string);
begin
  FGroupId := Value.Trim;
  UpdateAddPath;
end;

procedure TDsGroupReqDataseries.UpdateAddPath;
var
  Segment: string;
begin
  if FGroupId.IsEmpty then
  begin
    AddPath := '';
    Exit;
  end;

  if FActionSuffix.IsEmpty then
    Segment := ''
  else if FActionSuffix.StartsWith('/') then
    Segment := FActionSuffix.Substring(1)
  else
    Segment := FActionSuffix;

  if Segment.IsEmpty then
    AddPath := FGroupId
  else
    AddPath := Format('%s/%s', [FGroupId, Segment]);
end;

{ TDsGroupReqInclude }

constructor TDsGroupReqInclude.Create;
begin
  inherited Create('include');
end;

{ TDsGroupReqExclude }

constructor TDsGroupReqExclude.Create;
begin
  inherited Create('exclude');
end;

end.
