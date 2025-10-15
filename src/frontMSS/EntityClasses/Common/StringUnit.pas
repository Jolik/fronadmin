unit StringUnit;

interface

uses
  System.SysUtils, System.Generics.Collections, System.JSON;

type
  /// <summary>
  ///   Представление массива строк JSON в виде списка.
  /// </summary>
  TStringList = class(TObject)
  private
    FItems: TList<string>;
    function GetCount: Integer;
    function GetItem(Index: Integer): string;
  public
    constructor Create; overload;
    constructor Create(src: TJSONArray); overload;
    destructor Destroy; override;

    procedure Clear;
    procedure Assign(ASource: TStringList);
    procedure Parse(src: TJSONArray);
    procedure Serialize(dst: TJSONArray);
    function SerializeList: TJSONArray;
    procedure Add(const Value: string);

    property Count: Integer read GetCount;
    property Items[Index: Integer]: string read GetItem; default;
  end;

  /// <summary>
  ///   Представление JSON-объекта, содержащего массивы строк.
  /// </summary>
  TStringListsObject = class(TObject)
  private
    FItems: TObjectDictionary<string, TStringList>;
    function GetCount: Integer;
    function GetItem(const Key: string): TStringList;
  public
    constructor Create; overload;
    constructor Create(src: TJSONObject); overload;
    destructor Destroy; override;

    procedure Clear;
    procedure Assign(ASource: TStringListsObject);
    procedure Parse(src: TJSONObject);
    procedure Serialize(dst: TJSONObject);
    function SerializeObject: TJSONObject;
    function Add(const Key: string): TStringList;
    function Contains(const Key: string): Boolean;

    property Count: Integer read GetCount;
    property Items[const Key: string]: TStringList read GetItem; default;
  end;

implementation

{ TStringList }

procedure TStringList.Add(const Value: string);
begin
  FItems.Add(Value);
end;

procedure TStringList.Assign(ASource: TStringList);
begin
  if ASource = nil then
  begin
    Clear;
    Exit;
  end;

  Clear;

  for var StringValue in ASource.FItems do
    FItems.Add(StringValue);
end;

procedure TStringList.Clear;
begin
  FItems.Clear;
end;

constructor TStringList.Create;
begin
  inherited Create;

  FItems := TList<string>.Create;
end;

constructor TStringList.Create(src: TJSONArray);
begin
  Create;

  Parse(src);
end;

destructor TStringList.Destroy;
begin
  FItems.Free;

  inherited;
end;

function TStringList.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TStringList.GetItem(Index: Integer): string;
begin
  Result := FItems[Index];
end;

procedure TStringList.Parse(src: TJSONArray);
begin
  Clear;

  if not Assigned(src) then
    Exit;

  for var JSONValue in src do
  begin
    if JSONValue is TJSONString then
      FItems.Add(TJSONString(JSONValue).Value)
    else
      FItems.Add(JSONValue.Value);
  end;
end;

procedure TStringList.Serialize(dst: TJSONArray);
begin
  if not Assigned(dst) then
    Exit;

  for var StringValue in FItems do
    dst.Add(StringValue);
end;

function TStringList.SerializeList: TJSONArray;
begin
  Result := TJSONArray.Create;
  try
    Serialize(Result);
  except
    Result.Free;
    raise;
  end;
end;

{ TStringListsObject }

function TStringListsObject.Add(const Key: string): TStringList;
begin
  if not FItems.TryGetValue(Key, Result) then
  begin
    Result := TStringList.Create;
    FItems.Add(Key, Result);
  end;
end;

procedure TStringListsObject.Assign(ASource: TStringListsObject);
var
  Key: string;
  SourceList: TStringList;
  TargetList: TStringList;
begin
  if ASource = nil then
  begin
    Clear;
    Exit;
  end;

  Clear;

  for Key in ASource.FItems.Keys do
  begin
    SourceList := ASource.FItems.Items[Key];
    TargetList := TStringList.Create;
    try
      TargetList.Assign(SourceList);
      FItems.Add(Key, TargetList);
    except
      TargetList.Free;
      raise;
    end;
  end;
end;

procedure TStringListsObject.Clear;
begin
  FItems.Clear;
end;

function TStringListsObject.Contains(const Key: string): Boolean;
begin
  Result := FItems.ContainsKey(Key);
end;

constructor TStringListsObject.Create;
begin
  inherited Create;

  FItems := TObjectDictionary<string, TStringList>.Create([doOwnsValues]);
end;

constructor TStringListsObject.Create(src: TJSONObject);
begin
  Create;

  Parse(src);
end;

destructor TStringListsObject.Destroy;
begin
  FItems.Free;

  inherited;
end;

function TStringListsObject.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TStringListsObject.GetItem(const Key: string): TStringList;
begin
  if not FItems.TryGetValue(Key, Result) then
    Result := nil;
end;

procedure TStringListsObject.Parse(src: TJSONObject);
var
  Pair: TJSONPair;
  List: TStringList;
begin
  Clear;

  if not Assigned(src) then
    Exit;

  for Pair in src do
  begin
    List := TStringList.Create;
    try
      if Pair.JsonValue is TJSONArray then
        List.Parse(TJSONArray(Pair.JsonValue))
      else if Pair.JsonValue is TJSONString then
        List.Add(TJSONString(Pair.JsonValue).Value)
      else if Pair.JsonValue <> nil then
        List.Add(Pair.JsonValue.Value);

      FItems.Add(Pair.JsonString.Value, List);
    except
      List.Free;
      raise;
    end;
  end;
end;

procedure TStringListsObject.Serialize(dst: TJSONObject);
var
  Key: string;
  List: TStringList;
  JSONArray: TJSONArray;
begin
  if not Assigned(dst) then
    Exit;

  for Key in FItems.Keys do
  begin
    List := FItems.Items[Key];
    JSONArray := List.SerializeList;
    dst.AddPair(Key, JSONArray);
  end;
end;

function TStringListsObject.SerializeObject: TJSONObject;
begin
  Result := TJSONObject.Create;
  try
    Serialize(Result);
  except
    Result.Free;
    raise;
  end;
end;

end.

