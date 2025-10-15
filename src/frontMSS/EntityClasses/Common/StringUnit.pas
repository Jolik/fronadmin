unit StringUnit;

interface

uses
  System.JSON, System.Generics.Collections,
  EntityUnit;

type
  /// <summary>
  ///   Представляет набор строк, ассоциированных с именем свойства JSON.
  /// </summary>
  TStringList = class(TFieldSet)
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
  ///   Коллекция объектов TStringList для работы с JSON-объектом вида
  ///   "ключ" : [ "строки" ].
  /// </summary>
  TStringListsObject = class(TFieldSetList)
  private
    function GetStringList(Index: Integer): TStringList;
    procedure SetStringList(Index: Integer; const Value: TStringList);
  protected
    class function ItemClassType: TFieldSetClass; override;
  public
    procedure ParseObject(src: TJSONObject; const APropertyNames: TArray<string> = nil);
    procedure SerializeObject(dst: TJSONObject; const APropertyNames: TArray<string> = nil);
    function SerializeObject(const APropertyNames: TArray<string> = nil): TJSONObject;

    property Items[Index: Integer]: TStringList read GetStringList write SetStringList; default;
  end;

implementation

{ TStringList }

function TStringList.Assign(ASource: TFieldSet): boolean;
var
  Source: TStringList;
begin
  Result := false;

  if not Assigned(ASource) then
    Exit;

  if not (ASource is TStringList) then
    Exit;

  Source := TStringList(ASource);

  FName := Source.Name;
  FValues.Clear;
  for var Value in Source.Values do
    FValues.Add(Value);

  Result := true;
end;

constructor TStringList.Create;
begin
  inherited Create;

  FValues := TList<string>.Create;
end;

constructor TStringList.Create(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Create;

  Parse(src, APropertyNames);
end;

destructor TStringList.Destroy;
begin
  FValues.Free;

  inherited;
end;

procedure TStringList.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
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

procedure TStringList.ParsePair(APair: TJSONPair);
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

procedure TStringList.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
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

{ TStringListsObject }

function TStringListsObject.GetStringList(Index: Integer): TStringList;
begin
  Result := nil;

  if (Index < 0) or (Index >= Count) then
    Exit;

  if Items[Index] is TStringList then
    Result := TStringList(Items[Index]);
end;

class function TStringListsObject.ItemClassType: TFieldSetClass;
begin
  Result := TStringList;
end;

procedure TStringListsObject.ParseObject(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Clear;

  if not Assigned(src) then
    Exit;

  for var I := 0 to src.Count - 1 do
  begin
    var Pair := src.Pairs[I];
    if not Assigned(Pair) then
      Continue;

    var List := TStringList(ItemClassType.Create);
    try
      List.ParsePair(Pair);
      Add(List);
    except
      List.Free;
      raise;
    end;
  end;
end;

procedure TStringListsObject.SerializeObject(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  ValuesArray: TJSONArray;
  List: TStringList;
begin
  if not Assigned(dst) then
    Exit;

  for var I := 0 to Count - 1 do
  begin
    List := GetStringList(I);
    if not Assigned(List) then
      Continue;

    if List.Name = '' then
      Continue;

    ValuesArray := TJSONArray.Create;
    try
      for var Value in List.Values do
        ValuesArray.Add(Value);
    except
      ValuesArray.Free;
      raise;
    end;

    dst.AddPair(List.Name, ValuesArray);
  end;
end;

function TStringListsObject.SerializeObject(const APropertyNames: TArray<string>): TJSONObject;
begin
  Result := TJSONObject.Create;
  try
    SerializeObject(Result, APropertyNames);
  except
    Result.Free;
    raise;
  end;
end;

procedure TStringListsObject.SetStringList(Index: Integer; const Value: TStringList);
begin
  if (Index < 0) or (Index >= Count) then
    Exit;

  if not Assigned(Value) then
    Exit;

  if not (Value is TStringList) then
    Exit;

  if Assigned(Items[Index]) then
    Items[Index].Free;

  Items[Index] := Value;
end;

end.

