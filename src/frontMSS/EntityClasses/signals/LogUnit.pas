unit LogUnit;

interface

uses
  System.JSON, System.SysUtils, System.Generics.Collections,
  EntityUnit;

type
  /// <summary>
  ///   Description of a single log entry.
  /// </summary>
  TLogEntry = record
    /// <summary>
    ///   Message timestamp in nanoseconds from the monotonic timer.
    /// </summary>
    Timestamp: string;
    /// <summary>
    ///   JSON representation of the message.
    /// </summary>
    Payload: string;
  end;

  /// <summary>
  ///   Result of the log query.
  /// </summary>
  TLogResult = class(TFieldSet)
  private
    FContainerName: string;
    FFilename: string;
    FHost: string;
    FSource: string;
    FSwarmService: string;
    FSwarmStack: string;
    FEntries: TArray<TLogEntry>;
  protected
    procedure ParseStreamObject(AStreamValue: TJSONValue);
    procedure ParseValuesArray(AValuesValue: TJSONValue);
  public
    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    /// <summary>
    ///   Name of the container that provided the log.
    /// </summary>
    property ContainerName: string read FContainerName write FContainerName;
    /// <summary>
    ///   Path to the log file on the Docker host.
    /// </summary>
    property Filename: string read FFilename write FFilename;
    /// <summary>
    ///   Docker host name.
    /// </summary>
    property Host: string read FHost write FHost;
    /// <summary>
    ///   Source of the output stream.
    /// </summary>
    property Source: string read FSource write FSource;
    /// <summary>
    ///   Docker Swarm service name.
    /// </summary>
    property SwarmService: string read FSwarmService write FSwarmService;
    /// <summary>
    ///   Docker Swarm stack name.
    /// </summary>
    property SwarmStack: string read FSwarmStack write FSwarmStack;
    /// <summary>
    ///   List of entries returned by Loki.
    /// </summary>
    property Entries: TArray<TLogEntry> read FEntries write FEntries;
  end;

  /// <summary>
  ///   Response from the logging service.
  /// </summary>
  TLogs = class(TFieldSet)
  private
    FStatus: string;
    FResultType: string;
    FErrorType: string;
    FError: string;
    FResults: TObjectList<TLogResult>;
    FStatisticsJson: string;
    FRequestQuery: string;
    FRequestLimit: Integer;
    FRequestStart: string;
    FRequestEnd: string;
    FRequestDirection: string;
    FRequestRegexp: string;
    FRequestStep: string;
  protected
    procedure ParseResultArray(AResultValue: TJSONValue);
    procedure ParseStatisticsValue(AStatisticsValue: TJSONValue);
    procedure ParseRequestObject(ARequestValue: TJSONValue);
  public
    constructor Create(); overload; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    /// <summary>
    ///   Status of the service response.
    /// </summary>
    property Status: string read FStatus write FStatus;
    /// <summary>
    ///   Result type (streams, etc.).
    /// </summary>
    property ResultType: string read FResultType write FResultType;
    /// <summary>
    ///   Error type (when status=error).
    /// </summary>
    property ErrorType: string read FErrorType write FErrorType;
    /// <summary>
    ///   Error text (when status=error).
    /// </summary>
    property Error: string read FError write FError;
    /// <summary>
    ///   Collection of streams with logs.
    /// </summary>
    property Results: TObjectList<TLogResult> read FResults;
    /// <summary>
    ///   Request execution statistics (in raw JSON form).
    /// </summary>
    property StatisticsJson: string read FStatisticsJson write FStatisticsJson;
    /// <summary>
    ///   Original query (the query parameter).
    /// </summary>
    property RequestQuery: string read FRequestQuery write FRequestQuery;
    /// <summary>
    ///   Limit on the number of entries.
    /// </summary>
    property RequestLimit: Integer read FRequestLimit write FRequestLimit;
    /// <summary>
    ///   Timestamp of the selection start.
    /// </summary>
    property RequestStart: string read FRequestStart write FRequestStart;
    /// <summary>
    ///   Timestamp of the selection end.
    /// </summary>
    property RequestEnd: string read FRequestEnd write FRequestEnd;
    /// <summary>
    ///   Read direction (backward / forward).
    /// </summary>
    property RequestDirection: string read FRequestDirection write FRequestDirection;
    /// <summary>
    ///   Filter regular expression.
    /// </summary>
    property RequestRegexp: string read FRequestRegexp write FRequestRegexp;
    /// <summary>
    ///   Aggregation step (if specified).
    /// </summary>
    property RequestStep: string read FRequestStep write FRequestStep;
  end;

implementation

{ TLogResult }

function TLogResult.Assign(ASource: TFieldSet): boolean;
var
  Src: TLogResult;
  I: Integer;
begin
  Result := false;

  if not Assigned(ASource) then
    Exit;

  if not (ASource is TLogResult) then
    Exit;

  Src := TLogResult(ASource);

  FContainerName := Src.ContainerName;
  FFilename := Src.Filename;
  FHost := Src.Host;
  FSource := Src.Source;
  FSwarmService := Src.SwarmService;
  FSwarmStack := Src.SwarmStack;

  SetLength(FEntries, Length(Src.FEntries));
  for I := 0 to High(FEntries) do
    FEntries[I] := Src.FEntries[I];

  Result := true;
end;

procedure TLogResult.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  FContainerName := '';
  FFilename := '';
  FHost := '';
  FSource := '';
  FSwarmService := '';
  FSwarmStack := '';
  SetLength(FEntries, 0);

  if not Assigned(src) then
    Exit;

  ParseStreamObject(src.FindValue('stream'));
  ParseValuesArray(src.FindValue('values'));
end;

procedure TLogResult.ParseStreamObject(AStreamValue: TJSONValue);
var
  StreamObj: TJSONObject;
begin
  if not Assigned(AStreamValue) then
    Exit;

  if not (AStreamValue is TJSONObject) then
    Exit;

  StreamObj := TJSONObject(AStreamValue);
  StreamObj.TryGetValue<string>('container_name', FContainerName);
  StreamObj.TryGetValue<string>('filename', FFilename);
  StreamObj.TryGetValue<string>('host', FHost);
  StreamObj.TryGetValue<string>('source', FSource);
  StreamObj.TryGetValue<string>('swarm_service', FSwarmService);
  StreamObj.TryGetValue<string>('swarm_stack', FSwarmStack);
end;

procedure TLogResult.ParseValuesArray(AValuesValue: TJSONValue);
var
  ValuesArray: TJSONArray;
  EntryArray: TJSONArray;
  I: Integer;
  PairValue: TJSONValue;
begin
  if not Assigned(AValuesValue) then
    Exit;

  if not (AValuesValue is TJSONArray) then
    Exit;

  ValuesArray := TJSONArray(AValuesValue);
  SetLength(FEntries, ValuesArray.Count);

  for I := 0 to ValuesArray.Count - 1 do
  begin
    if not (ValuesArray.Items[I] is TJSONArray) then
      Continue;

    EntryArray := TJSONArray(ValuesArray.Items[I]);

    if EntryArray.Count > 0 then
    begin
      PairValue := EntryArray.Items[0];
      if PairValue is TJSONString then
        FEntries[I].Timestamp := TJSONString(PairValue).Value
      else if Assigned(PairValue) then
        FEntries[I].Timestamp := PairValue.Value
      else
        FEntries[I].Timestamp := '';
    end
    else
      FEntries[I].Timestamp := '';

    if EntryArray.Count > 1 then
    begin
      PairValue := EntryArray.Items[1];
      if PairValue is TJSONString then
        FEntries[I].Payload := TJSONString(PairValue).Value
      else if Assigned(PairValue) then
        FEntries[I].Payload := PairValue.Value
      else
        FEntries[I].Payload := '';
    end
    else
      FEntries[I].Payload := '';
  end;
end;

procedure TLogResult.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  StreamObj: TJSONObject;
  ValuesArray: TJSONArray;
  EntryArray: TJSONArray;
  Entry: TLogEntry;
begin
  if not Assigned(dst) then
    Exit;

  StreamObj := TJSONObject.Create;
  StreamObj.AddPair('container_name', TJSONString.Create(FContainerName));
  StreamObj.AddPair('filename', TJSONString.Create(FFilename));
  StreamObj.AddPair('host', TJSONString.Create(FHost));
  StreamObj.AddPair('source', TJSONString.Create(FSource));
  StreamObj.AddPair('swarm_service', TJSONString.Create(FSwarmService));
  StreamObj.AddPair('swarm_stack', TJSONString.Create(FSwarmStack));
  dst.AddPair('stream', StreamObj);

  ValuesArray := TJSONArray.Create;
  for Entry in FEntries do
  begin
    EntryArray := TJSONArray.Create;
    EntryArray.Add(Entry.Timestamp);
    EntryArray.Add(Entry.Payload);
    ValuesArray.AddElement(EntryArray);
  end;
  dst.AddPair('values', ValuesArray);
end;

{ TLogs }

function TLogs.Assign(ASource: TFieldSet): boolean;
var
  Src: TLogs;
  LogResult: TLogResult;
  Clone: TLogResult;
begin
  Result := False;

  if not Assigned(ASource) then
    Exit;

  if not (ASource is TLogs) then
    Exit;

  Src := TLogs(ASource);

  FStatus := Src.Status;
  FResultType := Src.ResultType;
  FErrorType := Src.ErrorType;
  FError := Src.Error;
  FStatisticsJson := Src.StatisticsJson;
  FRequestQuery := Src.RequestQuery;
  FRequestLimit := Src.RequestLimit;
  FRequestStart := Src.RequestStart;
  FRequestEnd := Src.RequestEnd;
  FRequestDirection := Src.RequestDirection;
  FRequestRegexp := Src.RequestRegexp;
  FRequestStep := Src.RequestStep;

  FResults.Clear;
  for LogResult in Src.Results do
  begin
    Clone := TLogResult.Create;
    try
      Clone.Assign(LogResult);
      FResults.Add(Clone);
    except
      Clone.Free;
      raise;
    end;
  end;

  Result := True;
end;

constructor TLogs.Create;
begin
  inherited Create;
  FResults := TObjectList<TLogResult>.Create(True);
end;

destructor TLogs.Destroy;
begin
  FResults.Free;
  inherited;
end;

procedure TLogs.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  DataValue: TJSONValue;
begin
  FStatus := '';
  FResultType := '';
  FErrorType := '';
  FError := '';
  FStatisticsJson := '';
  FRequestQuery := '';
  FRequestLimit := 0;
  FRequestStart := '';
  FRequestEnd := '';
  FRequestDirection := '';
  FRequestRegexp := '';
  FRequestStep := '';
  FResults.Clear;

  if not Assigned(src) then
    Exit;

  src.TryGetValue<string>('status', FStatus);
  src.TryGetValue<string>('errorType', FErrorType);
  src.TryGetValue<string>('error', FError);

  DataValue := src.FindValue('data');
  if Assigned(DataValue) and (DataValue is TJSONObject) then
  begin
    var DataObj := TJSONObject(DataValue);
    DataObj.TryGetValue<string>('resultType', FResultType);
    ParseResultArray(DataObj.FindValue('result'));
    ParseStatisticsValue(DataObj.FindValue('stats'));
  end;

  ParseRequestObject(src.FindValue('request'));
end;

procedure TLogs.ParseRequestObject(ARequestValue: TJSONValue);
var
  RequestObj: TJSONObject;
  LimitValue: TJSONValue;
  LimitStr: string;
begin
  if not Assigned(ARequestValue) then
    Exit;

  if not (ARequestValue is TJSONObject) then
    Exit;

  RequestObj := TJSONObject(ARequestValue);

  RequestObj.TryGetValue<string>('query', FRequestQuery);
  RequestObj.TryGetValue<string>('start', FRequestStart);
  RequestObj.TryGetValue<string>('end', FRequestEnd);
  RequestObj.TryGetValue<string>('direction', FRequestDirection);
  RequestObj.TryGetValue<string>('regexp', FRequestRegexp);
  RequestObj.TryGetValue<string>('step', FRequestStep);

  FRequestLimit := 0;
  LimitValue := RequestObj.Values['limit'];
  if Assigned(LimitValue) then
  begin
    if LimitValue is TJSONNumber then
      FRequestLimit := TJSONNumber(LimitValue).AsInt
    else if LimitValue is TJSONString then
    begin
      LimitStr := TJSONString(LimitValue).Value;
      TryStrToInt(LimitStr, FRequestLimit);
    end;
  end;
end;

procedure TLogs.ParseResultArray(AResultValue: TJSONValue);
var
  ResultArray: TJSONArray;
  I: Integer;
  ItemValue: TJSONValue;
  LogResult: TLogResult;
begin
  if not Assigned(AResultValue) then
    Exit;

  if not (AResultValue is TJSONArray) then
    Exit;

  ResultArray := TJSONArray(AResultValue);

  for I := 0 to ResultArray.Count - 1 do
  begin
    ItemValue := ResultArray.Items[I];
    if not (ItemValue is TJSONObject) then
      Continue;

    LogResult := TLogResult.Create;
    try
      LogResult.Parse(TJSONObject(ItemValue));
      FResults.Add(LogResult);
    except
      LogResult.Free;
      raise;
    end;
  end;
end;

procedure TLogs.ParseStatisticsValue(AStatisticsValue: TJSONValue);
begin
  if not Assigned(AStatisticsValue) then
  begin
    FStatisticsJson := '';
    Exit;
  end;

  FStatisticsJson := AStatisticsValue.ToJSON;
end;

procedure TLogs.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  DataObj: TJSONObject;
  ResultArray: TJSONArray;
  LogResult: TLogResult;
  ResultObj: TJSONObject;
  StatisticsValue: TJSONValue;
  RequestObj: TJSONObject;
begin
  if not Assigned(dst) then
    Exit;

  dst.AddPair('status', TJSONString.Create(FStatus));

  if FErrorType <> '' then
    dst.AddPair('errorType', TJSONString.Create(FErrorType));

  if FError <> '' then
    dst.AddPair('error', TJSONString.Create(FError));

  DataObj := TJSONObject.Create;
  DataObj.AddPair('resultType', TJSONString.Create(FResultType));

  ResultArray := TJSONArray.Create;
  for LogResult in FResults do
  begin
    ResultObj := TJSONObject.Create;
    LogResult.Serialize(ResultObj);
    ResultArray.AddElement(ResultObj);
  end;
  DataObj.AddPair('result', ResultArray);

  if FStatisticsJson <> '' then
  begin
    StatisticsValue := TJSONObject.ParseJSONValue(FStatisticsJson);
    if Assigned(StatisticsValue) then
      DataObj.AddPair('stats', StatisticsValue)
    else
      DataObj.AddPair('stats', TJSONString.Create(FStatisticsJson));
  end;

  dst.AddPair('data', DataObj);

  RequestObj := TJSONObject.Create;

  if FRequestQuery <> '' then
    RequestObj.AddPair('query', TJSONString.Create(FRequestQuery));

  if FRequestLimit <> 0 then
    RequestObj.AddPair('limit', TJSONNumber.Create(FRequestLimit));

  if FRequestStart <> '' then
    RequestObj.AddPair('start', TJSONString.Create(FRequestStart));

  if FRequestEnd <> '' then
    RequestObj.AddPair('end', TJSONString.Create(FRequestEnd));

  if FRequestDirection <> '' then
    RequestObj.AddPair('direction', TJSONString.Create(FRequestDirection));

  if FRequestRegexp <> '' then
    RequestObj.AddPair('regexp', TJSONString.Create(FRequestRegexp));

  if FRequestStep <> '' then
    RequestObj.AddPair('step', TJSONString.Create(FRequestStep));

  if RequestObj.Count > 0 then
    dst.AddPair('request', RequestObj)
  else
    RequestObj.Free;
end;

end.

