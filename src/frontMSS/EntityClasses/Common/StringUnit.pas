unit StringUnit;

interface

uses
  System.JSON, System.Generics.Collections, System.SysUtils,
  EntityUnit;

type
  /// <summary>
  ///   Представляет набор строк, ассоциированных с именем свойства JSON.
  /// </summary>
  TFieldSetStringList = class(TFieldSet)
  private
    FName: string;
    FValues: TList<string>;
  public
    constructor Create; overload; override;
    constructor Create(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure ParsePair(APair: TJSONPair);

    property Name: string read FName write FName;
    property Values: TList<string> read FValues;
  end;

  /// <summary>
  ///   Коллекция объектов TFieldSetStringList для работы с JSON-объектом вида
  ///   "ключ" : [ "строки" ].
  /// </summary>
  TFieldSetStringListsObject = class(TFieldSetList)
  private
    function GetFieldSetStringList(Index: Integer): TFieldSetStringList;
    procedure SetFieldSetStringList(Index: Integer; const Value: TFieldSetStringList);
    class function ShouldIncludeProperty(const APropertyName: string;
      const APropertyNames: TArray<string>): Boolean; static;
  protected
    class function ItemClassType: TFieldSetClass; override;
  public
    procedure ParseList(src: TJSONArray; const APropertyNames: TArray<string> = nil); overload; override;
    procedure AddList(src: TJSONArray; const APropertyNames: TArray<string> = nil); overload; override;
    procedure SerializeList(dst: TJSONArray; const APropertyNames: TArray<string> = nil); overload; override;

    property Items[Index: Integer]: TFieldSetStringList read GetFieldSetStringList write SetFieldSetStringList; default;
  end;

implementation

{ TFieldSetStringList }

function TFieldSetStringList.Assign(ASource: TFieldSet): boolean;
var
  Source: TFieldSetStringList;
begin
  Result := false;

  if not Assigned(ASource) then
    Exit;

  if not (ASource is TFieldSetStringList) then
    Exit;

  Source := TFieldSetStringList(ASource);

  FName := Source.Name;
  FValues.Clear;
  for var Value in Source.Values do
    FValues.Add(Value);

  Result := true;
end;

constructor TFieldSetStringList.Create;
begin
  inherited Create;

  FValues := TList<string>.Create;
end;

constructor TFieldSetStringList.Create(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Create;

  Parse(src, APropertyNames);
end;

destructor TFieldSetStringList.Destroy;
begin
  FValues.Free;

  inherited;
end;

procedure TFieldSetStringList.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  FName := '';
  FValues.Clear;

  if not Assigned(src) then
    Exit;

  for var I := 0 to src.Count - 1 do
  begin
    ParsePair(src.Pairs[I]);
    Break;
  end;
end;

procedure TFieldSetStringList.ParsePair(APair: TJSONPair);
var
  ValuesArray: TJSONArray;
  Value: TJSONValue;
begin
  FName := '';
  FValues.Clear;

  if not Assigned(APair) then
    Exit;

  if not Assigned(APair.JsonString) then
    Exit;

  FName := APair.JsonString.Value;

  if not Assigned(APair.JsonValue) then
    Exit;

  if APair.JsonValue is TJSONArray then
  begin
    ValuesArray := TJSONArray(APair.JsonValue);
    for var Index := 0 to ValuesArray.Count - 1 do
    begin
      Value := ValuesArray.Items[Index];
      if Value is TJSONString then
        FValues.Add(TJSONString(Value).Value)
      else if Assigned(Value) then
        FValues.Add(Value.ToString);
    end;
  end
  else if APair.JsonValue is TJSONString then
    FValues.Add(TJSONString(APair.JsonValue).Value)
  else
    FValues.Add(APair.JsonValue.ToString);
end;

procedure TFieldSetStringList.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  ValuesArray: TJSONArray;
begin
  if not Assigned(dst) then
    Exit;

  if FName = '' then
    Exit;

  ValuesArray := TJSONArray.Create;
  try
    for var Value in FValues do
      ValuesArray.Add(Value);
  except
    ValuesArray.Free;
    raise;
  end;

  dst.AddPair(FName, ValuesArray);
end;

{ TFieldSetStringListsObject }

function TFieldSetStringListsObject.GetFieldSetStringList(Index: Integer): TFieldSetStringList;
begin
  Result := nil;

  if (Index < 0) or (Index >= Count) then
    Exit;

  if Items[Index] is TFieldSetStringList then
    Result := TFieldSetStringList(Items[Index]);
end;

class function TFieldSetStringListsObject.ShouldIncludeProperty(
  const APropertyName: string; const APropertyNames: TArray<string>): Boolean;
begin
  Result := Length(APropertyNames) = 0;

  if Result then
    Exit;

  for var PropertyName in APropertyNames do
    if SameText(PropertyName, APropertyName) then
      Exit(True);

  Result := False;
end;

class function TFieldSetStringListsObject.ItemClassType: TFieldSetClass;
begin
  Result := TFieldSetStringList;
end;

procedure TFieldSetStringListsObject.ParseList(src: TJSONArray;
  const APropertyNames: TArray<string>);
begin
  Clear;

  if not Assigned(src) then
    Exit;

  for var Value in src do
  begin
    if not (Value is TJSONObject) then
      Continue;

    var JSONObject := TJSONObject(Value);
    for var Index := 0 to JSONObject.Count - 1 do
    begin
      var Pair := JSONObject.Pairs[Index];
      if not Assigned(Pair) then
        Continue;

      if not Assigned(Pair.JsonString) then
        Continue;

      if not ShouldIncludeProperty(Pair.JsonString.Value, APropertyNames) then
        Continue;

      var List := TFieldSetStringList(ItemClassType.Create);
      if not Assigned(List) then
        raise EInvalidOpException.Create('Unable to create TFieldSetStringList item instance');
      try
        List.ParsePair(Pair);
        Add(List);
      except
        List.Free;
        raise;
      end;
    end;
  end;
end;

procedure TFieldSetStringListsObject.AddList(src: TJSONArray;
  const APropertyNames: TArray<string>);
begin
  if not Assigned(src) then
    Exit;

  for var Value in src do
  begin
    if not (Value is TJSONObject) then
      Continue;

    var JSONObject := TJSONObject(Value);
    for var Index := 0 to JSONObject.Count - 1 do
    begin
      var Pair := JSONObject.Pairs[Index];
      if not Assigned(Pair) then
        Continue;

      if not Assigned(Pair.JsonString) then
        Continue;

      if not ShouldIncludeProperty(Pair.JsonString.Value, APropertyNames) then
        Continue;

      var List := TFieldSetStringList(ItemClassType.Create);
      if not Assigned(List) then
        raise EInvalidOpException.Create('Unable to create TFieldSetStringList item instance');
      try
        List.ParsePair(Pair);
        Add(List);
      except
        List.Free;
        raise;
      end;
    end;
  end;
end;

procedure TFieldSetStringListsObject.SerializeList(dst: TJSONArray;
  const APropertyNames: TArray<string>);
var
  List: TFieldSetStringList;
  JSONObject: TJSONObject;
begin
  if not Assigned(dst) then
    Exit;

  for var Index := 0 to Count - 1 do
  begin
    List := GetFieldSetStringList(Index);
    if not Assigned(List) then
      Continue;

    if List.Name = '' then
      Continue;

    if not ShouldIncludeProperty(List.Name, APropertyNames) then
      Continue;

    JSONObject := TJSONObject.Create;
    try
      List.Serialize(JSONObject, APropertyNames);

      if JSONObject.Count > 0 then
        dst.AddElement(JSONObject)
      else
        JSONObject.Free;
    except
      JSONObject.Free;
      raise;
    end;
  end;
end;

procedure TFieldSetStringListsObject.SetFieldSetStringList(Index: Integer; const Value: TFieldSetStringList);
begin
  if (Index < 0) or (Index >= Count) then
    Exit;

  if not Assigned(Value) then
    Exit;

  if not (Value is TFieldSetStringList) then
    Exit;

  if Assigned(Items[Index]) then
    Items[Index].Free;

  Items[Index] := Value;
end;

end.

