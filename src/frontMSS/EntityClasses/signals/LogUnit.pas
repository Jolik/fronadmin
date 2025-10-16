unit LogUnit;

interface

uses
  System.JSON, System.SysUtils,
  EntityUnit;

type
  /// <summary>
  ///   Описание отдельной записи лога.
  /// </summary>
  TLogEntry = record
    /// <summary>
    ///   Метка времени сообщения в наносекундах от монотонного таймера.
    /// </summary>
    Timestamp: string;
    /// <summary>
    ///   JSON-представление сообщения.
    /// </summary>
    Payload: string;
  end;

  /// <summary>
  ///   Результат запроса логов.
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
    ///   Имя контейнера, предоставившего лог.
    /// </summary>
    property ContainerName: string read FContainerName write FContainerName;
    /// <summary>
    ///   Путь к файлу логов на хосте Docker.
    /// </summary>
    property Filename: string read FFilename write FFilename;
    /// <summary>
    ///   Имя хоста Docker.
    /// </summary>
    property Host: string read FHost write FHost;
    /// <summary>
    ///   Источник потока вывода.
    /// </summary>
    property Source: string read FSource write FSource;
    /// <summary>
    ///   Имя сервиса Docker Swarm.
    /// </summary>
    property SwarmService: string read FSwarmService write FSwarmService;
    /// <summary>
    ///   Имя стека Docker Swarm.
    /// </summary>
    property SwarmStack: string read FSwarmStack write FSwarmStack;
    /// <summary>
    ///   Список записей, возвращённых Loki.
    /// </summary>
    property Entries: TArray<TLogEntry> read FEntries write FEntries;
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

end.

