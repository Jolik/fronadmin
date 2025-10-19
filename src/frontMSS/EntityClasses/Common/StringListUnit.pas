unit StringListUnit;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.JSON;

type
  /// <summary>
  ///   Класс для хранения и сериализации массива строк, полученного из JSON.
  /// </summary>
  ///  формат JSON который парсит класс
  ///  ["lch1","mitra"]
  ///
  TStringArray = class
  private
    FItems: TList<string>;
    FObjectName: string;
    function GetCount: Integer;
    function GetItem(Index: Integer): string;
  public
    constructor Create; overload; virtual;
    constructor Create(src: TJSONArray); overload; virtual;
    destructor Destroy; override;

    procedure Parse(src: TJSONArray); virtual;
    procedure Serialize(dst: TJSONArray); overload; virtual;
    function Serialize: TJSONArray; overload; virtual;
    function JSON: string; virtual;

    procedure Add(const AValue: string);
    procedure Clear;

    function ToArray: TArray<string>;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: string read GetItem; default;
    property ObjectName: string read FObjectName write FObjectName;
  end;

  /// <summary>
  ///   Набор объектов TStringArray с поддержкой разных форматов JSON.
  /// </summary>
  ///
  ///  формат массива JSON который парсит класс для вызова ParseList
  ///  [["lch1","mitra"],["ab1","ab2","ab3"]]
  ///
  ///  формат объекта  JSON который парсит класс для вызова Parse
  ///  {"lch1":["lch1","mitra"],"lch2":["ab1","ab2"]}
  ///
  TStringArrayList = class(TObjectList<TStringArray>)
  private
    function GetItem(Index: Integer): TStringArray;
    procedure SetItem(Index: Integer; const Value: TStringArray);
  protected
    function CreateItem: TStringArray; virtual;
  public
    constructor Create; overload; virtual;
    constructor Create(src: TJSONArray); overload; virtual;
    constructor Create(src: TJSONObject); overload; virtual;

    function AddArray: TStringArray; overload; virtual;
    procedure ParseList(src: TJSONArray); virtual;
    procedure AddList(src: TJSONArray); overload; virtual;
    procedure SerializeList(dst: TJSONArray); overload; virtual;
    function SerializeList: TJSONArray; overload; virtual;

    procedure Parse(src: TJSONObject); overload; virtual;
    procedure Add(src: TJSONObject); overload; virtual;
    procedure Serialize(dst: TJSONObject); overload; virtual;
    function Serialize: TJSONObject; overload; virtual;

    function JSONList: string; virtual;
    function JSON: string; virtual;

    property Items[Index: Integer]: TStringArray read GetItem write SetItem; default;
  end;

  /// <summary>
  ///   Коллекция строковых пар «ключ-значение» с разбором из JSON-объекта.
  /// </summary>
  ///
  ///  формам объекта который парсит класс
  ///  {"name":"TTAAii","email":"first@sample.com"}
  ///
  TKeyValueStringList = class
  private
    FItems: TDictionary<string, string>;
    FOrder: TList<string>;
    function GetCount: Integer;
    function GetValue(const Name: string): string;
    procedure SetValue(const Name, Value: string);
    function GetKey(Index: Integer): string;
  public
    constructor Create; overload; virtual;
    constructor Create(src: TJSONObject); overload; virtual;
    destructor Destroy; override;

    procedure Parse(src: TJSONObject); virtual;
    procedure Serialize(dst: TJSONObject); overload; virtual;
    function Serialize: TJSONObject; overload; virtual;
    function JSON: string; virtual;

    procedure Clear;
    procedure AddPair(const Name, Value: string);
    function Contains(const Name: string): Boolean;
    function Keys: TArray<string>;

    property Count: Integer read GetCount;
    property Values[const Name: string]: string read GetValue write SetValue; default;
    property Key[Index: Integer]: string read GetKey;
  end;

implementation

{ TStringArray }

constructor TStringArray.Create;
begin
  inherited Create;
  FItems := TList<string>.Create;
  FObjectName := '';
end;

constructor TStringArray.Create(src: TJSONArray);
begin
  Create;
  Parse(src);
end;

destructor TStringArray.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure TStringArray.Add(const AValue: string);
begin
  FItems.Add(AValue);
end;

procedure TStringArray.Clear;
begin
  FItems.Clear;
end;

function TStringArray.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TStringArray.GetItem(Index: Integer): string;
begin
  Result := FItems[Index];
end;

function TStringArray.JSON: string;
var
  Arr: TJSONArray;
begin
  Arr := Serialize;
  try
    Result := Arr.ToJSON;
  finally
    Arr.Free;
  end;
end;

procedure TStringArray.Parse(src: TJSONArray);
var
  Value: TJSONValue;
begin
  // При повторном чтении полностью очищаем текущий список значений
  Clear;

  if not Assigned(src) then
    Exit;

  for Value in src do
  begin
    // Поддерживаем хранение как строковых значений, так и любых JSON, конвертируя их в строку
    if Value is TJSONString then
      Add(TJSONString(Value).Value)
    else
      Add(Value.Value);
  end;
end;

procedure TStringArray.Serialize(dst: TJSONArray);
var
  Item: string;
begin
  if not Assigned(dst) then
    Exit;

  for Item in FItems do
    // Каждый элемент исходного списка превращаем в строковый JSON-элемент
    dst.AddElement(TJSONString.Create(Item));
end;

function TStringArray.Serialize: TJSONArray;
begin
  Result := TJSONArray.Create;
  try
    Serialize(Result);
  except
    Result.Free;
    raise;
  end;
end;

function TStringArray.ToArray: TArray<string>;
begin
  if Assigned(FItems) then
    Result := FItems.ToArray
  else
    Result := nil;
end;

{ TStringArrayList }

function TStringArrayList.AddArray: TStringArray;
begin
  Result := CreateItem;
  inherited Add(Result);
end;

constructor TStringArrayList.Create;
begin
  inherited Create(True);
end;

constructor TStringArrayList.Create(src: TJSONArray);
begin
  Create;
  ParseList(src);
end;

constructor TStringArrayList.Create(src: TJSONObject);
begin
  Create;
  Parse(src);
end;

function TStringArrayList.CreateItem: TStringArray;
begin
  Result := TStringArray.Create;
end;

function TStringArrayList.GetItem(Index: Integer): TStringArray;
begin
  Result := inherited Items[Index];
end;

procedure TStringArrayList.AddList(src: TJSONArray);
var
  Value: TJSONValue;
  Item: TStringArray;
begin
  if not Assigned(src) then
    Exit;

  for Value in src do
  begin
    if Value is TJSONArray then
    begin
      // Создаём новый элемент списка для каждого вложенного массива
      Item := CreateItem;
      try
        Item.Parse(TJSONArray(Value));
        inherited Add(Item);
      except
        Item.Free;
        raise;
      end;
    end;
  end;
end;

procedure TStringArrayList.Add(src: TJSONObject);
var
  Pair: TJSONPair;
  Item: TStringArray;
begin
  if not Assigned(src) then
    Exit;

  for Pair in src do
  begin
    if Pair.JsonValue is TJSONArray then
    begin
      // Имя свойства сохраняем в ObjectName для дальнейшей сериализации
      Item := CreateItem;
      try
        Item.ObjectName := Pair.JsonString.Value;
        Item.Parse(Pair.JsonValue as TJSONArray);
        inherited Add(Item);
      except
        Item.Free;
        raise;
      end;
    end;
  end;
end;

procedure TStringArrayList.ParseList(src: TJSONArray);
begin
  Clear;
  AddList(src);
end;

procedure TStringArrayList.Parse(src: TJSONObject);
begin
  Clear;
  Add(src);
end;

procedure TStringArrayList.Serialize(dst: TJSONObject);
var
  Item: TStringArray;
  Arr: TJSONArray;
  Index: Integer;
  Name: string;
begin
  if not Assigned(dst) then
    Exit;

  Index := 0;
  for Item in Self do
  begin
    Inc(Index);
    Name := Item.ObjectName;
    if Name = '' then
      // Если имя отсутствует, создаём уникальный идентификатор
      Name := Format('Item%d', [Index]);

    Arr := Item.Serialize;
    try
      dst.AddPair(Name, Arr);
    except
      Arr.Free;
      raise;
    end;
  end;
end;

procedure TStringArrayList.SerializeList(dst: TJSONArray);
var
  Item: TStringArray;
  Arr: TJSONArray;
begin
  if not Assigned(dst) then
    Exit;

  for Item in Self do
  begin
    Arr := Item.Serialize;
    try
      dst.AddElement(Arr);
    except
      Arr.Free;
      raise;
    end;
  end;
end;

function TStringArrayList.Serialize: TJSONObject;
begin
  Result := TJSONObject.Create;
  try
    Serialize(Result);
  except
    Result.Free;
    raise;
  end;
end;

function TStringArrayList.SerializeList: TJSONArray;
begin
  Result := TJSONArray.Create;
  try
    SerializeList(Result);
  except
    Result.Free;
    raise;
  end;
end;

procedure TStringArrayList.SetItem(Index: Integer; const Value: TStringArray);
begin
  inherited Items[Index] := Value;
end;

function TStringArrayList.JSON: string;
var
  Obj: TJSONObject;
begin
  Obj := Serialize;
  try
    Result := Obj.ToJSON;
  finally
    Obj.Free;
  end;
end;

function TStringArrayList.JSONList: string;
var
  Arr: TJSONArray;
begin
  Arr := SerializeList;
  try
    Result := Arr.ToJSON;
  finally
    Arr.Free;
  end;
end;

{ TKeyValueStringList }

procedure TKeyValueStringList.AddPair(const Name, Value: string);
begin
  SetValue(Name, Value);
end;

procedure TKeyValueStringList.Clear;
begin
  FItems.Clear;
  FOrder.Clear;
end;

function TKeyValueStringList.Contains(const Name: string): Boolean;
begin
  Result := FItems.ContainsKey(Name);
end;

constructor TKeyValueStringList.Create;
begin
  inherited Create;
  FItems := TDictionary<string, string>.Create;
  FOrder := TList<string>.Create;
end;

constructor TKeyValueStringList.Create(src: TJSONObject);
begin
  Create;
  Parse(src);
end;

destructor TKeyValueStringList.Destroy;
begin
  FItems.Free;
  FOrder.Free;
  inherited;
end;

function TKeyValueStringList.GetCount: Integer;
begin
  Result := FOrder.Count;
end;

function TKeyValueStringList.GetKey(Index: Integer): string;
begin
  Result := FOrder[Index];
end;

function TKeyValueStringList.GetValue(const Name: string): string;
begin
  if not FItems.TryGetValue(Name, Result) then
    Result := '';
end;

function TKeyValueStringList.JSON: string;
var
  Obj: TJSONObject;
begin
  Obj := Serialize;
  try
    Result := Obj.ToJSON;
  finally
    Obj.Free;
  end;
end;

function TKeyValueStringList.Keys: TArray<string>;
begin
  Result := FOrder.ToArray;
end;

procedure TKeyValueStringList.Parse(src: TJSONObject);
var
  Pair: TJSONPair;
begin
  Clear;

  if not Assigned(src) then
    Exit;

  for Pair in src do
  begin
    if Pair.JsonValue is TJSONString then
      SetValue(Pair.JsonString.Value, TJSONString(Pair.JsonValue).Value)
    else
      // Для нестандартных типов приводим значение к строковому представлению
      SetValue(Pair.JsonString.Value, Pair.JsonValue.Value);
  end;
end;

procedure TKeyValueStringList.Serialize(dst: TJSONObject);
var
  Key: string;
  Value: string;
begin
  if not Assigned(dst) then
    Exit;

  for Key in FOrder do
  begin
    Value := FItems[Key];
    // Значения хранятся в словаре, поэтому при сериализации восстанавливаем порядок по списку ключей
    dst.AddPair(Key, TJSONString.Create(Value));
  end;
end;

function TKeyValueStringList.Serialize: TJSONObject;
begin
  Result := TJSONObject.Create;
  try
    Serialize(Result);
  except
    Result.Free;
    raise;
  end;
end;

procedure TKeyValueStringList.SetValue(const Name, Value: string);
begin
  if Name = '' then
    Exit;

  if not FItems.ContainsKey(Name) then
    FOrder.Add(Name);

  FItems.AddOrSetValue(Name, Value);
end;

end.

