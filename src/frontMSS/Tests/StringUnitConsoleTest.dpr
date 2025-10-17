program StringUnitConsoleTest;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.JSON,
  StringUnit in '..\EntityClasses\Common\StringUnit.pas';

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

procedure TestFieldSetString;
var
  Source: TJSONObject;
  Target: TJSONObject;
  Item: TFieldSetString;
begin
  Writeln('--- Тест TFieldSetString ---');

  // Разбираем простейший JSON-объект со строкой
  Source := ParseJSONObject('{"value":"input ftp meteorf"}');
  try
    Item := TFieldSetString.Create;
    try
      Item.Parse(Source);

      Target := TJSONObject.Create;
      try
        Item.Serialize(Target);
        Writeln(Target.ToJSON);
      finally
        Target.Free;
      end;
    finally
      Item.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestFieldSetStringList;
var
  Source: TJSONArray;
  Target: TJSONArray;
  List: TFieldSetStringList;
begin
  Writeln('--- Тест TFieldSetStringList ---');

  // Разбираем массив строк и затем сериализуем его обратно
  Source := ParseJSONArray('["input ftp meteorf","output ss cli mitra5:7702"]');
  try
    List := TFieldSetStringList.Create;
    try
      List.ParseList(Source);

      Target := TJSONArray.Create;
      try
        List.SerializeList(Target);
        Writeln(Target.ToJSON);
      finally
        Target.Free;
      end;
    finally
      List.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestNamedStringList;
var
  Source: TJSONObject;
  Target: TJSONObject;
  Item: TNamedStringList;
begin
  Writeln('--- Тест TNamedStringList ---');

  // Проверяем именованный список строк
  Source := ParseJSONObject('{"foo1":["input ftp meteorf","output ss cli mitra5:7702"]}');
  try
    Item := TNamedStringList.Create;
    try
      Item.Parse(Source);

      Target := TJSONObject.Create;
      try
        Item.Serialize(Target);
        Writeln(Target.ToJSON);
      finally
        Target.Free;
      end;
    finally
      Item.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestNamedStringListList;
var
  Source: TJSONArray;
  Target: TJSONArray;
  List: TNamedStringListList;
begin
  Writeln('--- Тест TNamedStringListList ---');

  // Разбираем массив объектов с именованными списками строк
  Source := ParseJSONArray('[{"foo1":["input ftp meteorf","output ss cli mitra5:7702"]},{"foo2":["input ftp meteorf","output ss cli mitra5:7702"]}]');
  try
    List := TNamedStringListList.Create;
    try
      List.ParseList(Source);

      Target := TJSONArray.Create;
      try
        List.SerializeList(Target);
        Writeln(Target.ToJSON);
      finally
        Target.Free;
      end;
    finally
      List.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestStringListsObject;
var
  Source: TJSONObject;
  Target: TJSONObject;
  Obj: TFieldSetStringListsObject;
begin
  Writeln('--- Тест TFieldSetStringListsObject ---');

  // Разбираем JSON-объект с несколькими наборами строк
  Source := ParseJSONObject('{"foo1":["input ftp meteorf","output ss cli mitra5:7702"],"foo2":["input ftp meteorf","output ss cli mitra5:7702"]}');
  try
    Obj := TFieldSetStringListsObject.Create;
    try
      Obj.Parse(Source);

      Target := TJSONObject.Create;
      try
        Obj.Serialize(Target);
        Writeln(Target.ToJSON);
      finally
        Target.Free;
      end;
    finally
      Obj.Free;
    end;
  finally
    Source.Free;
  end;
end;

begin
  ReportMemoryLeaksOnShutdown := True;

  try
    TestFieldSetString;
    TestFieldSetStringList;
    TestNamedStringList;
    TestNamedStringListList;
    TestStringListsObject;
  except
    on E: Exception do
    begin
      Writeln('Ошибка: ' + E.ClassName + ': ' + E.Message);
    end;
  end;

  Writeln('Нажмите Enter для завершения.');
  Readln;
end.

