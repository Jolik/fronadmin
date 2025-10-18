program TestsEntities;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.JSON,
  EntityUnit in '..\EntityClasses\Common\EntityUnit.pas',
  FuncUnit in '..\Common\FuncUnit.pas',
  LoggingUnit in '..\Logging\LoggingUnit.pas';

type
  TSimpleFieldSet = class(TFieldSet)
  private
    FKey1: string;
    FKey2: string;
    FKey3: string;
  public
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Key1: string read FKey1 write FKey1;
    property Key2: string read FKey2 write FKey2;
    property Key3: string read FKey3 write FKey3;
  end;

  TSimpleFieldSetList = class(TFieldSetList)
  protected
    class function ItemClassType: TFieldSetClass; override;
  end;

  TSimpleEntity = class(TEntity)
  private
    FKey1: string;
    FKey2: string;
    FKey3: string;
  public
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Key1: string read FKey1 write FKey1;
    property Key2: string read FKey2 write FKey2;
    property Key3: string read FKey3 write FKey3;
  end;

  TSimpleEntityList = class(TEntityList)
  protected
    class function ItemClassType: TEntityClass; override;
  end;

const
  SAMPLE_ARRAY_JSON =
    '[{"key1":"value1","key2":"value2","key3":"value3"},' +
    ' {"key1":"value4","key2":"value5","key3":"value6"},' +
    ' {"key1":"value7","key2":"value8","key3":"value9"}]';

  SAMPLE_OBJECT_JSON =
    '{"class1":{"key1":"value1","key2":"value2","key3":"value3"},' +
    ' "class2":{"key1":"value4","key2":"value5","key3":"value6"},' +
    ' "class3":{"key1":"value7","key2":"value8","key3":"value9"}}';

  REPEATING_ARRAY_JSON =
    '[{"key1":"value1","key2":"value2","key3":"value3"},' +
    ' {"key1":"value1","key2":"value2","key3":"value3"},' +
    ' {"key1":"value1","key2":"value2","key3":"value3"}]';

  REPEATING_OBJECT_JSON =
    '{"class1":{"key1":"value1","key2":"value2","key3":"value3"},' +
    ' "class2":{"key1":"value1","key2":"value2","key3":"value3"},' +
    ' "class3":{"key1":"value1","key2":"value2","key3":"value3"}}';

  ENTITY_ARRAY_JSON =
    '[{"key1":"value1","key2":"value2","key3":"value3"},' +
    ' {"key1":"value4","key2":"value5","key3":"value6"},' +
    ' {"key1":"value7","key2":"value8","key3":"value9"}]';

  ENTITY_OBJECT_JSON =
    '{"entity1":{"key1":"value1","key2":"value2","key3":"value3"},' +
    ' "entity2":{"key1":"value4","key2":"value5","key3":"value6"},' +
    ' "entity3":{"key1":"value7","key2":"value8","key3":"value9"}}';

  ENTITY_REPEATING_ARRAY_JSON =
    '[{"key1":"value1","key2":"value2","key3":"value3"},' +
    ' {"key1":"value1","key2":"value2","key3":"value3"},' +
    ' {"key1":"value1","key2":"value2","key3":"value3"}]';

  ENTITY_REPEATING_OBJECT_JSON =
    '{"entity1":{"key1":"value1","key2":"value2","key3":"value3"},' +
    ' "entity2":{"key1":"value1","key2":"value2","key3":"value3"},' +
    ' "entity3":{"key1":"value1","key2":"value2","key3":"value3"}}';

{ Helper routines }

function ParseJSONObject(const AJsonText: string): TJSONObject;
var
  Value: TJSONValue;
begin
  Value := TJSONObject.ParseJSONValue(AJsonText, False, True);
  if not Assigned(Value) then
    raise Exception.Create('Не удалось разобрать JSON-объект.');
  if not (Value is TJSONObject) then
  begin
    Value.Free;
    raise Exception.Create('Ожидается JSON-объект.');
  end;
  Result := TJSONObject(Value);
end;

function ParseJSONArray(const AJsonText: string): TJSONArray;
var
  Value: TJSONValue;
begin
  Value := TJSONObject.ParseJSONValue(AJsonText, False, True);
  if not Assigned(Value) then
    raise Exception.Create('Не удалось разобрать JSON-массив.');
  if not (Value is TJSONArray) then
  begin
    Value.Free;
    raise Exception.Create('Ожидается JSON-массив.');
  end;
  Result := TJSONArray(Value);
end;

procedure AssertTrue(Condition: Boolean; const Msg: string);
begin
  if not Condition then
    raise Exception.CreateFmt('AssertTrue failed: %s', [Msg]);
end;

procedure AssertEquals(const Msg: string; const Expected, Actual: string); overload;
begin
  if Expected <> Actual then
    raise Exception.CreateFmt('%s. Ожидалось "%s", получено "%s"', [Msg, Expected, Actual]);
end;

procedure AssertEquals(const Msg: string; const Expected, Actual: Integer); overload;
begin
  if Expected <> Actual then
    raise Exception.CreateFmt('%s. Ожидалось %d, получено %d', [Msg, Expected, Actual]);
end;

{ TSimpleFieldSet }

procedure TSimpleFieldSet.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Parse(src, APropertyNames);
  FKey1 := GetValueStrDef(src, 'key1', '');
  FKey2 := GetValueStrDef(src, 'key2', '');
  FKey3 := GetValueStrDef(src, 'key3', '');
end;

procedure TSimpleFieldSet.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Serialize(dst, APropertyNames);
  dst.AddPair('key1', Key1);
  dst.AddPair('key2', Key2);
  dst.AddPair('key3', Key3);
end;

{ TSimpleFieldSetList }

class function TSimpleFieldSetList.ItemClassType: TFieldSetClass;
begin
  Result := TSimpleFieldSet;
end;

{ TSimpleEntity }

procedure TSimpleEntity.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Parse(src, APropertyNames);
  FKey1 := GetValueStrDef(src, 'key1', '');
  FKey2 := GetValueStrDef(src, 'key2', '');
  FKey3 := GetValueStrDef(src, 'key3', '');
end;

procedure TSimpleEntity.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  dst.AddPair('key1', Key1);
  dst.AddPair('key2', Key2);
  dst.AddPair('key3', Key3);
end;

{ TSimpleEntityList }

class function TSimpleEntityList.ItemClassType: TEntityClass;
begin
  Result := TSimpleEntity;
end;

{ Helper creators }

function CreateListFromArray: TSimpleFieldSetList;
var
  Source: TJSONArray;
begin
  Source := ParseJSONArray(SAMPLE_ARRAY_JSON);
  try
    Result := TSimpleFieldSetList.Create;
    Result.ParseList(Source);
  finally
    Source.Free;
  end;
end;

function CreateListFromObject: TSimpleFieldSetList;
var
  Source: TJSONObject;
begin
  Source := ParseJSONObject(SAMPLE_OBJECT_JSON);
  try
    Result := TSimpleFieldSetList.Create(Source);
  finally
    Source.Free;
  end;
end;

function CreateEntityListFromArray: TSimpleEntityList;
var
  Source: TJSONArray;
begin
  Source := ParseJSONArray(ENTITY_ARRAY_JSON);
  try
    Result := TSimpleEntityList.Create;
    Result.ParseList(Source);
  finally
    Source.Free;
  end;
end;

function CreateEntityListFromObject: TSimpleEntityList;
var
  Source: TJSONObject;
begin
  Source := ParseJSONObject(ENTITY_OBJECT_JSON);
  try
    Result := TSimpleEntityList.Create(Source);
  finally
    Source.Free;
  end;
end;

{ Tests }

procedure TestParseList;
var
  Source: TJSONArray;
  List: TSimpleFieldSetList;
begin
  Writeln('--- Тест ParseList ---');
  Source := ParseJSONArray(SAMPLE_ARRAY_JSON);
  try
    List := TSimpleFieldSetList.Create;
    try
      List.ParseList(Source);
      AssertEquals('Количество элементов после ParseList', 3, List.Count);
      AssertEquals('Первый элемент.key1', 'value1', TSimpleFieldSet(List.Items[0]).Key1);
      AssertEquals('Второй элемент.key2', 'value5', TSimpleFieldSet(List.Items[1]).Key2);
      AssertEquals('Третий элемент.key3', 'value9', TSimpleFieldSet(List.Items[2]).Key3);
    finally
      List.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestParseObject;
var
  Source: TJSONObject;
  List: TSimpleFieldSetList;
begin
  Writeln('--- Тест Parse ---');
  Source := ParseJSONObject(SAMPLE_OBJECT_JSON);
  try
    List := TSimpleFieldSetList.Create;
    try
      List.Parse(Source);
      AssertEquals('Количество элементов после Parse', 3, List.Count);
      AssertEquals('ObjectName первого элемента', 'class1', TSimpleFieldSet(List.Items[0]).ObjectName);
      AssertEquals('Первый элемент.key2', 'value2', TSimpleFieldSet(List.Items[0]).Key2);
    finally
      List.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestAddFromObject;
var
  BaseArray: TJSONArray;
  ExtraObject: TJSONObject;
  List: TSimpleFieldSetList;
begin
  Writeln('--- Тест Add ---');
  BaseArray := ParseJSONArray('[{"key1":"value1","key2":"value2","key3":"value3"}]');
  try
    ExtraObject := ParseJSONObject('{"extra":{"key1":"value4","key2":"value5","key3":"value6"}}');
    try
      List := TSimpleFieldSetList.Create;
      try
        List.ParseList(BaseArray);
        List.Add(ExtraObject);
        AssertEquals('Количество элементов после Add', 2, List.Count);
        AssertEquals('ObjectName добавленного элемента', 'extra', TSimpleFieldSet(List.Items[1]).ObjectName);
        AssertEquals('Добавленный элемент.key3', 'value6', TSimpleFieldSet(List.Items[1]).Key3);
      finally
        List.Free;
      end;
    finally
      ExtraObject.Free;
    end;
  finally
    BaseArray.Free;
  end;
end;

procedure TestSerializeList;
var
  List: TSimpleFieldSetList;
  Target: TJSONArray;
  Item: TJSONObject;
begin
  Writeln('--- Тест SerializeList ---');
  List := CreateListFromArray;
  try
    Target := TJSONArray.Create;
    try
      List.SerializeList(Target);
      AssertEquals('Количество элементов в сериализованном массиве', 3, Target.Count);
      Item := Target.Items[0] as TJSONObject;
      AssertEquals('SerializeList[0].key1', 'value1', GetValueStrDef(Item, 'key1', ''));
    finally
      Target.Free;
    end;
  finally
    List.Free;
  end;
end;

procedure TestSerializeObject;
var
  List: TSimpleFieldSetList;
  Target: TJSONObject;
  Item: TJSONObject;
begin
  Writeln('--- Тест Serialize ---');
  List := CreateListFromObject;
  try
    Target := TJSONObject.Create;
    try
      List.Serialize(Target);
      AssertEquals('Количество пар в сериализованном объекте', 3, Target.Count);
      Item := Target.Values['class2'] as TJSONObject;
      AssertTrue(Assigned(Item), 'Ожидается объект для ключа class2');
      AssertEquals('Serialize["class2"].key3', 'value6', GetValueStrDef(Item, 'key3', ''));
    finally
      Target.Free;
    end;
  finally
    List.Free;
  end;
end;

procedure TestJSONList;
var
  List: TSimpleFieldSetList;
  JsonText: string;
  Parsed: TJSONArray;
begin
  Writeln('--- Тест JSONList ---');
  List := CreateListFromObject;
  try
    JsonText := List.JSONList;
    Parsed := ParseJSONArray(JsonText);
    try
      AssertEquals('Количество элементов в JSONList', 3, Parsed.Count);
    finally
      Parsed.Free;
    end;
  finally
    List.Free;
  end;
end;

procedure TestJSONObject;
var
  List: TSimpleFieldSetList;
  JsonText: string;
  Parsed: TJSONObject;
  Item: TJSONObject;
begin
  Writeln('--- Тест JSON ---');
  List := CreateListFromArray;
  try
    JsonText := List.JSON;
    Parsed := ParseJSONObject(JsonText);
    try
      Item := Parsed.Values['Item2'] as TJSONObject;
      AssertTrue(Assigned(Item), 'Ожидается объект для ключа Item2');
      AssertEquals('JSON["Item2"].key2', 'value5', GetValueStrDef(Item, 'key2', ''));
    finally
      Parsed.Free;
    end;
  finally
    List.Free;
  end;
end;

procedure TestArrayToJSONObject;
var
  Source: TJSONArray;
  List: TSimpleFieldSetList;
  JsonText: string;
  Parsed: TJSONObject;
begin
  Writeln('--- Тест загрузки массива и выгрузки объекта ---');
  Source := ParseJSONArray(REPEATING_ARRAY_JSON);
  try
    List := TSimpleFieldSetList.Create;
    try
      List.ParseList(Source);
      JsonText := List.JSON;
      Parsed := ParseJSONObject(JsonText);
      try
        AssertEquals('JSON объект из массива содержит 3 элемента', 3, Parsed.Count);
      finally
        Parsed.Free;
      end;
    finally
      List.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestObjectToJSONArray;
var
  Source: TJSONObject;
  List: TSimpleFieldSetList;
  JsonText: string;
  Parsed: TJSONArray;
begin
  Writeln('--- Тест загрузки объекта и выгрузки массива ---');
  Source := ParseJSONObject(REPEATING_OBJECT_JSON);
  try
    List := TSimpleFieldSetList.Create(Source);
    try
      JsonText := List.JSONList;
      Parsed := ParseJSONArray(JsonText);
      try
        AssertEquals('JSON массив из объекта содержит 3 элемента', 3, Parsed.Count);
      finally
        Parsed.Free;
      end;
    finally
      List.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestEntityParseList;
var
  Source: TJSONArray;
  List: TSimpleEntityList;
begin
  Writeln('--- Тест Entity ParseList ---');
  Source := ParseJSONArray(ENTITY_ARRAY_JSON);
  try
    List := TSimpleEntityList.Create;
    try
      List.ParseList(Source);
      AssertEquals('Количество элементов Entity после ParseList', 3, List.Count);
      AssertEquals('Entity[0].key1', 'value1', TSimpleEntity(List.Items[0]).Key1);
      AssertEquals('Entity[1].key2', 'value5', TSimpleEntity(List.Items[1]).Key2);
      AssertEquals('Entity[2].key3', 'value9', TSimpleEntity(List.Items[2]).Key3);
    finally
      List.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestEntityParseObject;
var
  Source: TJSONObject;
  List: TSimpleEntityList;
begin
  Writeln('--- Тест Entity Parse ---');
  Source := ParseJSONObject(ENTITY_OBJECT_JSON);
  try
    List := TSimpleEntityList.Create;
    try
      List.Parse(Source);
      AssertEquals('Количество элементов Entity после Parse', 3, List.Count);
      AssertEquals('ObjectName Entity первого элемента', 'entity1', TSimpleEntity(List.Items[0]).ObjectName);
      AssertEquals('Entity первый элемент.key2', 'value2', TSimpleEntity(List.Items[0]).Key2);
    finally
      List.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestEntityAddFromObject;
var
  BaseArray: TJSONArray;
  ExtraObject: TJSONObject;
  List: TSimpleEntityList;
begin
  Writeln('--- Тест Entity Add ---');
  BaseArray := ParseJSONArray('[{"key1":"value1","key2":"value2","key3":"value3"}]');
  try
    ExtraObject := ParseJSONObject('{"extra":{"key1":"value4","key2":"value5","key3":"value6"}}');
    try
      List := TSimpleEntityList.Create;
      try
        List.ParseList(BaseArray);
        List.Add(ExtraObject);
        AssertEquals('Количество элементов Entity после Add', 2, List.Count);
        AssertEquals('ObjectName Entity добавленного элемента', 'extra', TSimpleEntity(List.Items[1]).ObjectName);
        AssertEquals('Entity добавленный элемент.key3', 'value6', TSimpleEntity(List.Items[1]).Key3);
      finally
        List.Free;
      end;
    finally
      ExtraObject.Free;
    end;
  finally
    BaseArray.Free;
  end;
end;

procedure TestEntitySerializeList;
var
  List: TSimpleEntityList;
  Target: TJSONArray;
  Item: TJSONObject;
begin
  Writeln('--- Тест Entity SerializeList ---');
  List := CreateEntityListFromArray;
  try
    Target := TJSONArray.Create;
    try
      List.SerializeList(Target);
      AssertEquals('Количество элементов Entity в сериализованном массиве', 3, Target.Count);
      Item := Target.Items[0] as TJSONObject;
      AssertEquals('Entity SerializeList[0].key1', 'value1', GetValueStrDef(Item, 'key1', ''));
    finally
      Target.Free;
    end;
  finally
    List.Free;
  end;
end;

procedure TestEntitySerializeObject;
var
  List: TSimpleEntityList;
  Target: TJSONObject;
  Item: TJSONObject;
begin
  Writeln('--- Тест Entity Serialize ---');
  List := CreateEntityListFromObject;
  try
    Target := TJSONObject.Create;
    try
      List.Serialize(Target);
      AssertEquals('Количество пар Entity в сериализованном объекте', 3, Target.Count);
      Item := Target.Values['entity2'] as TJSONObject;
      AssertTrue(Assigned(Item), 'Ожидается Entity объект для ключа entity2');
      AssertEquals('Entity Serialize["entity2"].key3', 'value6', GetValueStrDef(Item, 'key3', ''));
    finally
      Target.Free;
    end;
  finally
    List.Free;
  end;
end;

procedure TestEntityJSONList;
var
  List: TSimpleEntityList;
  JsonText: string;
  Parsed: TJSONArray;
begin
  Writeln('--- Тест Entity JSONList ---');
  List := CreateEntityListFromObject;
  try
    JsonText := List.JSONList;
    Parsed := ParseJSONArray(JsonText);
    try
      AssertEquals('Количество элементов Entity в JSONList', 3, Parsed.Count);
    finally
      Parsed.Free;
    end;
  finally
    List.Free;
  end;
end;

procedure TestEntityJSON;
var
  List: TSimpleEntityList;
  JsonText: string;
  Parsed: TJSONObject;
  Item: TJSONObject;
begin
  Writeln('--- Тест Entity JSON ---');
  List := CreateEntityListFromArray;
  try
    JsonText := List.JSON;
    Parsed := ParseJSONObject(JsonText);
    try
      Item := Parsed.Values['Item2'] as TJSONObject;
      AssertTrue(Assigned(Item), 'Ожидается Entity объект для ключа Item2');
      AssertEquals('Entity JSON["Item2"].key2', 'value5', GetValueStrDef(Item, 'key2', ''));
    finally
      Parsed.Free;
    end;
  finally
    List.Free;
  end;
end;

procedure TestEntityArrayToJSONObject;
var
  Source: TJSONArray;
  List: TSimpleEntityList;
  JsonText: string;
  Parsed: TJSONObject;
begin
  Writeln('--- Тест Entity загрузки массива и выгрузки объекта ---');
  Source := ParseJSONArray(ENTITY_REPEATING_ARRAY_JSON);
  try
    List := TSimpleEntityList.Create;
    try
      List.ParseList(Source);
      JsonText := List.JSON;
      Parsed := ParseJSONObject(JsonText);
      try
        AssertEquals('Entity JSON объект из массива содержит 3 элемента', 3, Parsed.Count);
      finally
        Parsed.Free;
      end;
    finally
      List.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestEntityObjectToJSONArray;
var
  Source: TJSONObject;
  List: TSimpleEntityList;
  JsonText: string;
  Parsed: TJSONArray;
begin
  Writeln('--- Тест Entity загрузки объекта и выгрузки массива ---');
  Source := ParseJSONObject(ENTITY_REPEATING_OBJECT_JSON);
  try
    List := TSimpleEntityList.Create(Source);
    try
      JsonText := List.JSONList;
      Parsed := ParseJSONArray(JsonText);
      try
        AssertEquals('Entity JSON массив из объекта содержит 3 элемента', 3, Parsed.Count);
      finally
        Parsed.Free;
      end;
    finally
      List.Free;
    end;
  finally
    Source.Free;
  end;
end;

begin
  ReportMemoryLeaksOnShutdown := True;
  try
    TestParseList;
    TestParseObject;
    TestAddFromObject;
    TestSerializeList;
    TestSerializeObject;
    TestJSONList;
    TestJSONObject;
    TestArrayToJSONObject;
    TestObjectToJSONArray;
    TestEntityParseList;
    TestEntityParseObject;
    TestEntityAddFromObject;
    TestEntitySerializeList;
    TestEntitySerializeObject;
    TestEntityJSONList;
    TestEntityJSON;
    TestEntityArrayToJSONObject;
    TestEntityObjectToJSONArray;
    Writeln('Все тесты успешно выполнены. Нажмите любую кнопку!');
    Readln;
  except
    on E: Exception do
    begin
      Writeln('Ошибка теста: ' + E.Message);
      Halt(1);
    end;
  end;
end.

