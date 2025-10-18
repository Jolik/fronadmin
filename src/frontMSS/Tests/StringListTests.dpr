program StringListTests;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.JSON,
  StringListUnit in '..\EntityClasses\Common\StringListUnit.pas';

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

procedure Ensure(Condition: Boolean; const Msg: string);
begin
  if not Condition then
    raise Exception.Create(Msg);
end;

procedure TestStringArray;
var
  Source: TJSONArray;
  Target: TJSONArray;
  Item: TStringArray;
begin
  Writeln('--- Тест TStringArray ---');

  Source := ParseJSONArray('["lch1","mitra"]');
  try
    Item := TStringArray.Create;
    try
      Item.Parse(Source);
      Ensure(Item.Count = 2, 'Ожидалось две строки.');
      Ensure(Item[0] = 'lch1', 'Первая строка должна быть lch1.');
      Ensure(Item[1] = 'mitra', 'Вторая строка должна быть mitra.');

      Target := TJSONArray.Create;
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

procedure TestStringArrayListFromArray;
var
  Source: TJSONArray;
  Target: TJSONArray;
  List: TStringArrayList;
begin
  Writeln('--- Тест TStringArrayList (массив массивов) ---');

  Source := ParseJSONArray('[["lch1","mitra"],["ab1","ab2","ab3"]]');
  try
    List := TStringArrayList.Create;
    try
      List.ParseList(Source);
      Ensure(List.Count = 2, 'Ожидалось два элемента.');
      Ensure(List[0].Count = 2, 'Первый массив должен содержать две строки.');
      Ensure(List[1].Count = 3, 'Второй массив должен содержать три строки.');

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

procedure TestStringArrayListFromObject;
var
  Source: TJSONObject;
  Target: TJSONObject;
  List: TStringArrayList;
  Item: TStringArray;
begin
  Writeln('--- Тест TStringArrayList (JSON-объект) ---');

  Source := ParseJSONObject('{"channels":{"lch1":["lch1","mitra"],"lch2":["ab1","ab2"]}}');
  try
    List := TStringArrayList.Create;
    try
      List.Parse(Source.GetValue('channels') as TJSONObject);
      Ensure(List.Count = 2, 'Ожидалось два канала.');

      Item := List[0];
      Ensure(Item.ObjectName = 'lch1', 'Имя первого канала должно быть lch1.');
      Ensure(Item.Count = 2, 'Первый канал должен содержать две строки.');

      Item := List[1];
      Ensure(Item.ObjectName = 'lch2', 'Имя второго канала должно быть lch2.');
      Ensure(Item.Count = 2, 'Второй канал должен содержать две строки.');

      Target := TJSONObject.Create;
      try
        List.Serialize(Target);
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

procedure TestKeyValueStringList;
var
  Source: TJSONObject;
  Target: TJSONObject;
  Pairs: TKeyValueStringList;
begin
  Writeln('--- Тест TKeyValueStringList ---');

  Source := ParseJSONObject('{"name":"TTAAii","email":"first@sample.com"}');
  try
    Pairs := TKeyValueStringList.Create;
    try
      Pairs.Parse(Source);
      Ensure(Pairs.Count = 2, 'Ожидалось две пары.');
      Ensure(Pairs['name'] = 'TTAAii', 'Имя должно совпадать.');
      Ensure(Pairs['email'] = 'first@sample.com', 'Email должен совпадать.');

      Pairs['email'] := 'updated@sample.com';
      Ensure(Pairs['email'] = 'updated@sample.com', 'Email должен обновиться.');

      Target := TJSONObject.Create;
      try
        Pairs.Serialize(Target);
        Writeln(Target.ToJSON);
      finally
        Target.Free;
      end;
    finally
      Pairs.Free;
    end;
  finally
    Source.Free;
  end;
end;

begin
  ReportMemoryLeaksOnShutdown := True;

  try
    TestStringArray;
    TestStringArrayListFromArray;
    TestStringArrayListFromObject;
    TestKeyValueStringList;
  except
    on E: Exception do
    begin
      Writeln(E.ClassName + ': ' + E.Message);
      Halt(1);
    end;
  end;
end.

