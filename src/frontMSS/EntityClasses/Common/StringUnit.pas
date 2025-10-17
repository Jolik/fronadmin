unit StringUnit;

interface

uses
  System.JSON, System.Generics.Collections, System.SysUtils,
  EntityUnit;

type
  /// <summary>
  ///   String list item.
  /// </summary>
  TFieldSetString = class(TFieldSet)
  private
    FValue: string;
  public
    constructor Create; overload; override;
    constructor Create(const AValue: string); reintroduce; overload;

    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    /// <summary>
    ///   Parses a value from an arbitrary JSON element.
    /// </summary>
    procedure ParseValue(const AValue: TJSONValue);
    /// <summary>
    ///   Creates a JSON representation of the string.
    /// </summary>
    function SerializeValue: TJSONValue;

    /// <summary>
    ///   Stored text value.
    /// </summary>
    property Value: string read FValue write FValue;
  end;

  /// <summary>
  ///   List of string values.
  /// </summary>
  TFieldSetStringList = class(TFieldSetList)
  private
    function GetItemValue(Index: Integer): string;
    procedure SetItemValue(Index: Integer; const AValue: string);
    function GetStringItem(Index: Integer): TFieldSetString;
    procedure SetStringItem(Index: Integer; const AItem: TFieldSetString);
  protected
    class function ItemClassType: TFieldSetClass; override;
  public
    function Assign(ASource: TFieldSetList): boolean; override;

    procedure ParseList(src: TJSONArray; const APropertyNames: TArray<string> = nil); overload; override;
    procedure AddList(src: TJSONArray; const APropertyNames: TArray<string> = nil); overload; override;
    procedure SerializeList(dst: TJSONArray; const APropertyNames: TArray<string> = nil); overload; override;

    /// <summary>
    ///   Adds a new value.
    /// </summary>
    procedure AddString(const AValue: string);
    /// <summary>
    ///   Clears the list.
    /// </summary>
    procedure ClearStrings;
    /// <summary>
    ///   Represents the contents as an array of strings.
    /// </summary>
    function ToStringArray: TArray<string>;

//    property Items[Index: Integer]: TFieldSetString read GetStringItem write SetStringItem; default;
//    property Strings[Index: Integer]: string read GetItemValue write SetItemValue;
  end;

  /// <summary>
  ///   Named string value stored inside a JSON object.
  /// </summary>
  TFieldSetNamedString = class(TFieldSetString)
  private
    FName: string;
  public
    function Assign(ASource: TFieldSet): boolean; override;

    procedure ParsePair(APair: TJSONPair);
    procedure SerializePair(dst: TJSONObject);

    property Name: string read FName write FName;
  end;

  /// <summary>
  ///   JSON object with string values.
  /// </summary>
  TFieldSetStringListObject = class(TFieldSetStringList)
  private
    function GetNamedItem(Index: Integer): TFieldSetNamedString;
    procedure SetNamedItem(Index: Integer; const AItem: TFieldSetNamedString);
  protected
    class function ItemClassType: TFieldSetClass; override;
    class function ShouldIncludeProperty(const APropertyName: string;
      const APropertyNames: TArray<string>): Boolean; static;
  public
    constructor Create(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; virtual;

    function Assign(ASource: TFieldSetList): boolean; override;

    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); virtual;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); virtual;

    function Find(const AName: string): TFieldSetNamedString;
    procedure AddPair(const AName, AValue: string);
    function GetValue(const AName: string): string;
    procedure SetValue(const AName, AValue: string);

    property Pairs[Index: Integer]: TFieldSetNamedString read GetNamedItem write SetNamedItem;
    property Values[const AName: string]: string read GetValue write SetValue; default;
  end;

  /// <summary>
  ///   Named list of strings in the form "name": ["values"].
  /// </summary>
  TNamedStringList = class(TFieldSet)
  private
    FName: string;
    FValues: TFieldSetStringList;
  protected
    class function ShouldIncludeProperty(const APropertyName: string;
      const APropertyNames: TArray<string>): Boolean; static;
  public
    constructor Create; overload; override;
    constructor Create(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    /// <summary>
    ///   Parses a JSON pair.
    /// </summary>
    procedure ParsePair(APair: TJSONPair; const APropertyNames: TArray<string> = nil);

    /// <summary>
    ///   Name of the string set.
    /// </summary>
    property Name: string read FName write FName;
    /// <summary>
    ///   Values associated with the name.
    /// </summary>
    property Values: TFieldSetStringList read FValues;
  end;

  /// <summary>
  ///   Collection of named string lists in the form
  /// </summary>
  TNamedStringListList = class(TFieldSetList)
  private
    function GetNamedList(Index: Integer): TNamedStringList;
    procedure SetNamedList(Index: Integer; const AValue: TNamedStringList);
  protected
    class function ItemClassType: TFieldSetClass; override;
  public
    function Assign(ASource: TFieldSetList): boolean; overload; override;

    procedure ParseList(src: TJSONArray; const APropertyNames: TArray<string> = nil); overload; override;
    procedure AddList(src: TJSONArray; const APropertyNames: TArray<string> = nil); overload; override;
    procedure SerializeList(dst: TJSONArray; const APropertyNames: TArray<string> = nil); overload; override;

    constructor Create(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; virtual;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; virtual;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; virtual;

//    property Items[Index: Integer]: TNamedStringList read GetNamedList write SetNamedList; default;
  end;

  /// <summary>
  ///   JSON object with named string lists.
  /// </summary>
  TNamedStringListsObject = class(TNamedStringListList)
  public
    constructor Create(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload;

    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
  end;

implementation

{ TFieldSetString }

function TFieldSetString.Assign(ASource: TFieldSet): boolean;
begin
  Result := False;

  if not Assigned(ASource) then
    Exit;

  if not (ASource is TFieldSetString) then
    Exit;

  FValue := TFieldSetString(ASource).Value;

  Result := True;
end;

constructor TFieldSetString.Create;
begin
  inherited Create;

  FValue := '';
end;

constructor TFieldSetString.Create(const AValue: string);
begin
  Create;

  FValue := AValue;
end;

procedure TFieldSetString.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  FValue := '';

  if not Assigned(src) then
    Exit;

  if src.Count = 0 then
    Exit;

  ParseValue(src.Pairs[0].JsonValue);
end;

procedure TFieldSetString.ParseValue(const AValue: TJSONValue);
begin
  FValue := '';

  if not Assigned(AValue) then
    Exit;

  if AValue is TJSONString then
    FValue := TJSONString(AValue).Value
  else
    FValue := AValue.Value;
end;

procedure TFieldSetString.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then
    Exit;

  dst.AddPair('value', SerializeValue);
end;

function TFieldSetString.SerializeValue: TJSONValue;
begin
  Result := TJSONString.Create(FValue);
end;

{ TFieldSetStringList }

procedure TFieldSetStringList.AddList(src: TJSONArray; const APropertyNames: TArray<string>);
begin
  if not Assigned(src) then
    Exit;

  for var Value in src do
  begin
    var Item := TFieldSetString(ItemClassType.Create);
    try
      Item.ParseValue(Value);
      Add(Item);
    except
      Item.Free;
      raise;
    end;
  end;
end;

procedure TFieldSetStringList.AddString(const AValue: string);
var
  Item: TFieldSetString;
begin
  Item := TFieldSetString(ItemClassType.Create);
  try
    Item.Value := AValue;
    Add(Item);
  except
    Item.Free;
    raise;
  end;
end;

function TFieldSetStringList.Assign(ASource: TFieldSetList): boolean;
var
  Index: Integer;
  SourceItem: TFieldSet;
begin
  Result := False;

  if not Assigned(ASource) then
    Exit;

  if not (ASource is TFieldSetStringList) then
    Exit;

  Clear;
  for Index := 0 to ASource.Count - 1 do
  begin
    SourceItem := ASource.Items[Index];
    if not (SourceItem is TFieldSetString) then
      Continue;
    AddString(TFieldSetString(SourceItem).Value);
  end;

  Result := True;
end;

procedure TFieldSetStringList.ClearStrings;
begin
  Clear;
end;

function TFieldSetStringList.GetItemValue(Index: Integer): string;
var
  Item: TFieldSetString;
begin
  Item := GetStringItem(Index);
  if Assigned(Item) then
    Result := Item.Value
  else
    Result := '';
end;

function TFieldSetStringList.GetStringItem(Index: Integer): TFieldSetString;
begin
  Result := nil;

  if (Index < 0) or (Index >= Count) then
    Exit;

  if Items[Index] is TFieldSetString then
    Result := TFieldSetString(Items[Index]);
end;

class function TFieldSetStringList.ItemClassType: TFieldSetClass;
begin
  Result := TFieldSetString;
end;

procedure TFieldSetStringList.ParseList(src: TJSONArray; const APropertyNames: TArray<string>);
var
  Value: TJSONValue;
  Item: TFieldSetString;
begin
  Clear;

  if not Assigned(src) then
    Exit;

  for Value in src do
  begin
    Item := TFieldSetString(ItemClassType.Create);
    try
      Item.ParseValue(Value);
      Add(Item);
    except
      Item.Free;
      raise;
    end;
  end;
end;

procedure TFieldSetStringList.SerializeList(dst: TJSONArray; const APropertyNames: TArray<string>);
var
  Item: TFieldSetString;
  Index: Integer;
begin
  if not Assigned(dst) then
    Exit;

  for Index := 0 to Count - 1 do
  begin
    Item := GetStringItem(Index);
    if not Assigned(Item) then
      Continue;
    dst.AddElement(Item.SerializeValue);
  end;
end;

procedure TFieldSetStringList.SetItemValue(Index: Integer; const AValue: string);
var
  Item: TFieldSetString;
begin
  Item := GetStringItem(Index);
  if not Assigned(Item) then
    Exit;

  Item.Value := AValue;
end;

procedure TFieldSetStringList.SetStringItem(Index: Integer; const AItem: TFieldSetString);
begin
  if (Index < 0) or (Index >= Count) then
    Exit;

  if not Assigned(AItem) then
    Exit;

  if Assigned(Items[Index]) then
    Items[Index].Free;

  Items[Index] := AItem;
end;

function TFieldSetStringList.ToStringArray: TArray<string>;
var
  Index: Integer;
begin
  SetLength(Result, Count);

  for Index := 0 to Count - 1 do
    Result[Index] := GetItemValue(Index);
end;

{ TFieldSetNamedString }

function TFieldSetNamedString.Assign(ASource: TFieldSet): boolean;
begin
  Result := inherited Assign(ASource);

  if not Result then
    Exit;

  if not (ASource is TFieldSetNamedString) then
  begin
    Result := False;
    Exit;
  end;

  FName := TFieldSetNamedString(ASource).Name;

  Result := True;
end;

procedure TFieldSetNamedString.ParsePair(APair: TJSONPair);
begin
  FName := '';
  Value := '';

  if not Assigned(APair) then
    Exit;

  if not Assigned(APair.JsonString) then
    Exit;

  FName := APair.JsonString.Value;

  if Assigned(APair.JsonValue) then
    ParseValue(APair.JsonValue)
  else
    Value := '';
end;

procedure TFieldSetNamedString.SerializePair(dst: TJSONObject);
begin
  if not Assigned(dst) then
    Exit;

  if FName = '' then
    Exit;

  dst.AddPair(FName, SerializeValue);
end;

{ TFieldSetStringListObject }

procedure TFieldSetStringListObject.AddPair(const AName, AValue: string);
var
  Item: TFieldSetNamedString;
begin
  Item := TFieldSetNamedString(ItemClassType.Create);
  try
    if AName = '' then
    begin
      Item.Free;
      Exit;
    end;
    Item.Name := AName;
    Item.Value := AValue;
    Add(Item);
  except
    Item.Free;
    raise;
  end;
end;

function TFieldSetStringListObject.Assign(ASource: TFieldSetList): boolean;
var
  Source: TFieldSetStringListObject;
  Index: Integer;
  Item: TFieldSetNamedString;
begin
  Result := False;

  if not Assigned(ASource) then
    Exit;

  if not (ASource is TFieldSetStringListObject) then
    Exit;

  Source := TFieldSetStringListObject(ASource);

  Clear;
  for Index := 0 to Source.Count - 1 do
  begin
    Item := Source.GetNamedItem(Index);
    if not Assigned(Item) then
      Continue;
    AddPair(Item.Name, Item.Value);
  end;

  Result := True;
end;

constructor TFieldSetStringListObject.Create(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Create;

  Parse(src, APropertyNames);
end;

function TFieldSetStringListObject.Find(const AName: string): TFieldSetNamedString;
var
  Index: Integer;
  Item: TFieldSetNamedString;
begin
  Result := nil;

  for Index := 0 to Count - 1 do
  begin
    Item := GetNamedItem(Index);
    if not Assigned(Item) then
      Continue;
    if SameText(Item.Name, AName) then
      Exit(Item);
  end;
end;

function TFieldSetStringListObject.GetNamedItem(Index: Integer): TFieldSetNamedString;
begin
  Result := nil;

  if (Index < 0) or (Index >= Count) then
    Exit;

  if inherited Items[Index] is TFieldSetNamedString then
    Result := TFieldSetNamedString(inherited Items[Index]);
end;

function TFieldSetStringListObject.GetValue(const AName: string): string;
var
  Item: TFieldSetNamedString;
begin
  Result := '';

  Item := Find(AName);
  if Assigned(Item) then
    Result := Item.Value;
end;

procedure TFieldSetStringListObject.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  Pair: TJSONPair;
  Item: TFieldSetNamedString;
begin
  Clear;

  if not Assigned(src) then
    Exit;

  for Pair in src do
  begin
    if not Assigned(Pair.JsonString) then
      Continue;
    if not ShouldIncludeProperty(Pair.JsonString.Value, APropertyNames) then
      Continue;

    Item := TFieldSetNamedString(ItemClassType.Create);
    try
      Item.ParsePair(Pair);
      if Item.Name <> '' then
        Add(Item)
      else
        Item.Free;
    except
      Item.Free;
      raise;
    end;
  end;
end;

procedure TFieldSetStringListObject.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  Index: Integer;
  Item: TFieldSetNamedString;
begin
  if not Assigned(dst) then
    Exit;

  for Index := 0 to Count - 1 do
  begin
    Item := GetNamedItem(Index);
    if not Assigned(Item) then
      Continue;
    if Item.Name = '' then
      Continue;
    if not ShouldIncludeProperty(Item.Name, APropertyNames) then
      Continue;

    Item.SerializePair(dst);
  end;
end;

procedure TFieldSetStringListObject.SetNamedItem(Index: Integer; const AItem: TFieldSetNamedString);
begin
  if (Index < 0) or (Index >= Count) then
    Exit;

  if not Assigned(AItem) then
    Exit;

  if Assigned(inherited Items[Index]) then
    inherited Items[Index].Free;

  inherited Items[Index] := AItem;
end;

procedure TFieldSetStringListObject.SetValue(const AName, AValue: string);
var
  Item: TFieldSetNamedString;
begin
  Item := Find(AName);
  if not Assigned(Item) then
  begin
    AddPair(AName, AValue);
    Exit;
  end;

  Item.Value := AValue;
end;

class function TFieldSetStringListObject.ItemClassType: TFieldSetClass;
begin
  Result := TFieldSetNamedString;
end;

class function TFieldSetStringListObject.ShouldIncludeProperty(
  const APropertyName: string; const APropertyNames: TArray<string>): Boolean;
var
  PropertyName: string;
begin
  Result := Length(APropertyNames) = 0;

  if Result then
    Exit;

  for PropertyName in APropertyNames do
    if SameText(PropertyName, APropertyName) then
      Exit(True);

  Result := False;
end;

{ TNamedStringList }

function TNamedStringList.Assign(ASource: TFieldSet): boolean;
var
  Source: TNamedStringList;
begin
  Result := False;

  if not Assigned(ASource) then
    Exit;

  if not (ASource is TNamedStringList) then
    Exit;

  Source := TNamedStringList(ASource);

  FName := Source.Name;
  FValues.Assign(Source.Values);

  Result := True;
end;

constructor TNamedStringList.Create;
begin
  inherited Create;

  FValues := TFieldSetStringList.Create;
  FName := '';
end;

constructor TNamedStringList.Create(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Create;

  Parse(src, APropertyNames);
end;

destructor TNamedStringList.Destroy;
begin
  FValues.Free;

  inherited;
end;

procedure TNamedStringList.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  Pair: TJSONPair;
begin
  FName := '';
  FValues.Clear;

  if not Assigned(src) then
    Exit;

  if src.Count = 0 then
    Exit;

  Pair := src.Pairs[0];
  ParsePair(Pair, APropertyNames);
end;

procedure TNamedStringList.ParsePair(APair: TJSONPair; const APropertyNames: TArray<string>);
var
  Value: TJSONValue;
begin
  FName := '';
  FValues.Clear;

  if not Assigned(APair) then
    Exit;

  if not Assigned(APair.JsonString) then
    Exit;

  if not ShouldIncludeProperty(APair.JsonString.Value, APropertyNames) then
    Exit;

  FName := APair.JsonString.Value;

  Value := APair.JsonValue;
  if not Assigned(Value) then
    Exit;

  if Value is TJSONArray then
    FValues.ParseList(TJSONArray(Value), APropertyNames)
  else
  begin
    FValues.ClearStrings;
    FValues.AddString(Value.Value);
  end;
end;

procedure TNamedStringList.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  ValuesArray: TJSONArray;
begin
  if not Assigned(dst) then
    Exit;

  if FName = '' then
    Exit;

  if not ShouldIncludeProperty(FName, APropertyNames) then
    Exit;

  ValuesArray := TJSONArray.Create;
  try
    FValues.SerializeList(ValuesArray, APropertyNames);
    dst.AddPair(FName, ValuesArray);
  except
    ValuesArray.Free;
    raise;
  end;
end;

class function TNamedStringList.ShouldIncludeProperty(const APropertyName: string;
  const APropertyNames: TArray<string>): Boolean;
var
  PropertyName: string;
begin
  Result := Length(APropertyNames) = 0;

  if Result then
    Exit;

  for PropertyName in APropertyNames do
    if SameText(PropertyName, APropertyName) then
      Exit(True);

  Result := False;
end;

{ TNamedStringListList }

procedure TNamedStringListList.AddList(src: TJSONArray; const APropertyNames: TArray<string>);
var
  Value: TJSONValue;
  JSONObject: TJSONObject;
  Pair: TJSONPair;
  Item: TNamedStringList;
begin
  if not Assigned(src) then
    Exit;

  for Value in src do
  begin
    if not (Value is TJSONObject) then
      Continue;

    JSONObject := TJSONObject(Value);
    for Pair in JSONObject do
    begin
      Item := TNamedStringList(ItemClassType.Create);
      try
        Item.ParsePair(Pair, APropertyNames);
        if Item.Name <> '' then
          Add(Item)
        else
          Item.Free;
      except
        Item.Free;
        raise;
      end;
    end;
  end;
end;

function TNamedStringListList.Assign(ASource: TFieldSetList): boolean;
var
  Index: Integer;
  SourceItem: TFieldSet;
  Item: TNamedStringList;
begin
  Result := False;

  if not Assigned(ASource) then
    Exit;

  if not (ASource is TNamedStringListList) then
    Exit;

  Clear;
  for Index := 0 to ASource.Count - 1 do
  begin
    SourceItem := ASource.Items[Index];
    if not (SourceItem is TNamedStringList) then
      Continue;

    Item := TNamedStringList(ItemClassType.Create);
    try
      Item.Assign(SourceItem);
      Add(Item);
    except
      Item.Free;
      raise;
    end;
  end;

  Result := True;
end;

constructor TNamedStringListList.Create(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Create;

  Parse(src, APropertyNames);
end;

function TNamedStringListList.GetNamedList(Index: Integer): TNamedStringList;
begin
  Result := nil;

  if (Index < 0) or (Index >= Count) then
    Exit;

  if Items[Index] is TNamedStringList then
    Result := TNamedStringList(Items[Index]);
end;

class function TNamedStringListList.ItemClassType: TFieldSetClass;
begin
  Result := TNamedStringList;
end;

procedure TNamedStringListList.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  Pair: TJSONPair;
  Item: TNamedStringList;
begin
  Clear;

  if not Assigned(src) then
    Exit;

  for Pair in src do
  begin
    Item := TNamedStringList(ItemClassType.Create);
    try
      Item.ParsePair(Pair, APropertyNames);
      if Item.Name <> '' then
        Add(Item)
      else
        Item.Free;
    except
      Item.Free;
      raise;
    end;
  end;
end;

procedure TNamedStringListList.ParseList(src: TJSONArray; const APropertyNames: TArray<string>);
begin
  Clear;

  AddList(src, APropertyNames);
end;

procedure TNamedStringListList.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  Item: TNamedStringList;
  Index: Integer;
begin
  if not Assigned(dst) then
    Exit;

  for Index := 0 to Count - 1 do
  begin
    Item := GetNamedList(Index);
    if not Assigned(Item) then
      Continue;
    Item.Serialize(dst, APropertyNames);
  end;
end;

procedure TNamedStringListList.SerializeList(dst: TJSONArray; const APropertyNames: TArray<string>);
var
  Item: TNamedStringList;
  JSONObject: TJSONObject;
  Index: Integer;
begin
  if not Assigned(dst) then
    Exit;

  for Index := 0 to Count - 1 do
  begin
    Item := GetNamedList(Index);
    if not Assigned(Item) then
      Continue;

    JSONObject := TJSONObject.Create;
    try
      Item.Serialize(JSONObject, APropertyNames);
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

procedure TNamedStringListList.SetNamedList(Index: Integer; const AValue: TNamedStringList);
begin
  if (Index < 0) or (Index >= Count) then
    Exit;

  if not Assigned(AValue) then
    Exit;

  if Assigned(Items[Index]) then
    Items[Index].Free;

  Items[Index] := AValue;
end;

{ TNamedStringListsObject }

constructor TNamedStringListsObject.Create(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Create;

  Parse(src, APropertyNames);
end;

procedure TNamedStringListsObject.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Parse(src, APropertyNames);
end;

procedure TNamedStringListsObject.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Serialize(dst, APropertyNames);
end;

end.
