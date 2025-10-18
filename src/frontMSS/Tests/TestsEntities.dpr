program TestsEntities;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.JSON,
  EntityUnit in '..\EntityClasses\Common\EntityUnit.pas',
  FuncUnit in '..\Common\FuncUnit.pas',
  LoggingUnit in '..\Logging\LoggingUnit.pas';

type
  TSimpleEntity = class;

  TSimpleEntityList = class(TEntityList)
  protected
    class function ItemClassType: TEntityClass; override;
  end;

  TSimpleEntity = class(TEntity)
  private
    FValue: string;
  public
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    class function ListClassType: TEntityListClass; override;

    property Value: string read FValue write FValue;
  end;

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

{ TSimpleEntity }

procedure TSimpleEntity.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Parse(src, APropertyNames);
  Value := GetValueStrDef(src, 'value', '');
end;

procedure TSimpleEntity.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Serialize(dst, APropertyNames);
  dst.AddPair('value', Value);
end;

class function TSimpleEntity.ListClassType: TEntityListClass;
begin
  Result := TSimpleEntityList;
end;

{ TSimpleEntityList }

class function TSimpleEntityList.ItemClassType: TEntityClass;
begin
  Result := TSimpleEntity;
end;

{ Tests }

procedure TestParseList;
var
  Source: TJSONArray;
  List: TSimpleEntityList;
  Item: TSimpleEntity;
begin
  Writeln('--- Тест ParseList ---');
  Source := ParseJSONArray('[{"id":"1","value":"one"},{"id":"2","value":"two"}]');
  try
    List := TSimpleEntityList.Create;
    try
      List.ParseList(Source);
      AssertEquals('Количество элементов после ParseList', 2, List.Count);

      Item := TSimpleEntity(List.Items[0]);
      AssertEquals('Первый элемент.Id', '1', Item.Id);
      AssertEquals('Первый элемент.Value', 'one', Item.Value);

      Item := TSimpleEntity(List.Items[1]);
      AssertEquals('Второй элемент.Id', '2', Item.Id);
      AssertEquals('Второй элемент.Value', 'two', Item.Value);
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
  List: TSimpleEntityList;
  Item: TSimpleEntity;
begin
  Writeln('--- Тест Parse ---');
  Source := ParseJSONObject('{"first":{"id":"1","value":"one"},"second":{"id":"2","value":"two"}}');
  try
    List := TSimpleEntityList.Create;
    try
      List.Parse(Source);
      AssertEquals('Количество элементов после Parse', 2, List.Count);

      Item := TSimpleEntity(List.Items[0]);
      AssertEquals('Первый элемент.Value', 'one', Item.Value);

      Item := TSimpleEntity(List.Items[1]);
      AssertEquals('Второй элемент.Value', 'two', Item.Value);
    finally
      List.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestAddFromObject;
var
  InitialArray: TJSONArray;
  ExtraObject: TJSONObject;
  List: TSimpleEntityList;
begin
  Writeln('--- Тест Add (JSON объект) ---');
  InitialArray := ParseJSONArray('[{"id":"1","value":"one"}]');
  try
    ExtraObject := ParseJSONObject('{"second":{"id":"2","value":"two"}}');
    try
      List := TSimpleEntityList.Create;
      try
        List.ParseList(InitialArray);
        List.Add(ExtraObject);
        AssertEquals('Количество элементов после Add', 2, List.Count);
        AssertEquals('Последний элемент.Value', 'two', TSimpleEntity(List.Items[List.Count-1]).Value);
      finally
        List.Free;
      end;
    finally
      ExtraObject.Free;
    end;
  finally
    InitialArray.Free;
  end;
end;

function CreateListFromArray: TSimpleEntityList;
var
  Source: TJSONArray;
begin
  Source := ParseJSONArray('[{"id":"1","value":"one"},{"id":"2","value":"two"}]');
  try
    Result := TSimpleEntityList.Create;
    Result.ParseList(Source);
  finally
    Source.Free;
  end;
end;

procedure TestSerializeList;
var
  List: TSimpleEntityList;
  Target: TJSONArray;
  Item: TJSONObject;
begin
  Writeln('--- Тест SerializeList ---');
  List := CreateListFromArray;
  try
    Target := TJSONArray.Create;
    try
      List.SerializeList(Target);
      AssertEquals('Количество элементов в сериализованном массиве', 2, Target.Count);

      Item := Target.Items[0] as TJSONObject;
      AssertEquals('SerializeList[0].id', '1', GetValueStrDef(Item, 'id', ''));
      AssertEquals('SerializeList[0].value', 'one', GetValueStrDef(Item, 'value', ''));

      Item := Target.Items[1] as TJSONObject;
      AssertEquals('SerializeList[1].id', '2', GetValueStrDef(Item, 'id', ''));
      AssertEquals('SerializeList[1].value', 'two', GetValueStrDef(Item, 'value', ''));
    finally
      Target.Free;
    end;
  finally
    List.Free;
  end;
end;

procedure TestSerializeObject;
var
  List: TSimpleEntityList;
  Target: TJSONObject;
  Value: TJSONValue;
  Item: TJSONObject;
begin
  Writeln('--- Тест Serialize ---');
  List := CreateListFromArray;
  try
    Target := TJSONObject.Create;
    try
      List.Serialize(Target);
      AssertEquals('Количество пар в сериализованном объекте', 2, Target.Count);

      Value := Target.Values['1'];
      AssertTrue(Assigned(Value) and (Value is TJSONObject), 'Ожидается объект для ключа 1');
      Item := TJSONObject(Value);
      AssertEquals('Serialize["1"].value', 'one', GetValueStrDef(Item, 'value', ''));

      Value := Target.Values['2'];
      AssertTrue(Assigned(Value) and (Value is TJSONObject), 'Ожидается объект для ключа 2');
      Item := TJSONObject(Value);
      AssertEquals('Serialize["2"].value', 'two', GetValueStrDef(Item, 'value', ''));
    finally
      Target.Free;
    end;
  finally
    List.Free;
  end;
end;

procedure TestJSONList;
var
  List: TSimpleEntityList;
  JsonText: string;
  Parsed: TJSONArray;
  Item: TJSONObject;
begin
  Writeln('--- Тест JSONList ---');
  List := CreateListFromArray;
  try
    JsonText := List.JSONList;
    Parsed := ParseJSONArray(JsonText);
    try
      AssertEquals('JSONList количество элементов', 2, Parsed.Count);
      Item := Parsed.Items[0] as TJSONObject;
      AssertEquals('JSONList[0].value', 'one', GetValueStrDef(Item, 'value', ''));
    finally
      Parsed.Free;
    end;
  finally
    List.Free;
  end;
end;

procedure TestJSONObject;
var
  List: TSimpleEntityList;
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
      Item := Parsed.Values['1'] as TJSONObject;
      AssertTrue(Assigned(Item), 'Ожидается объект для ключа 1');
      AssertEquals('JSON["1"].value', 'one', GetValueStrDef(Item, 'value', ''));
    finally
      Parsed.Free;
    end;
  finally
    List.Free;
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
    Writeln('Все тесты успешно выполнены.');
  except
    on E: Exception do
    begin
      Writeln('Ошибка теста: ' + E.Message);
      Halt(1);
    end;
  end;
end.
