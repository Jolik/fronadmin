program GeoTypeUnitConsoleTest;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.JSON,
  GeoTypeUnit in '..\EntityClasses\Common\GeoTypeUnit.pas',
  EntityUnit in '..\EntityClasses\Common\EntityUnit.pas',
  FuncUnit in '..\Common\FuncUnit.pas',
  LoggingUnit in '..\Logging\LoggingUnit.pas';

const
  // Погрешность сравнения чисел с плавающей точкой
  DoubleEpsilon = 1.0E-8;

procedure AssertTrue(const ACondition: Boolean; const AMessage: string);
begin
  if not ACondition then
    raise Exception.Create(AMessage);
end;

procedure AssertAlmostEqual(const AExpected, AActual: Double; const AMessage: string);
begin
  AssertTrue(Abs(AExpected - AActual) <= DoubleEpsilon, AMessage);
end;

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

procedure TestPointGeometry;
var
  Source: TJSONObject;
  Target: TJSONObject;
  Coordinates: TJSONArray;
  Geo: TGeoType;
begin
  Writeln('--- Тест геометрии типа Point ---');
  Source := ParseJSONObject('{"type":"Point","coordinates":[30,10]}');
  try
    Geo := TGeoType.Create;
    try
      Geo.Parse(Source);
      AssertTrue(SameText(Geo.GeoType, 'Point'), 'Ожидается тип Point.');
      AssertTrue(Length(Geo.Point) = 2, 'Ожидается две координаты точки.');
      AssertAlmostEqual(30, Geo.Point[0], 'Неверное значение долготы.');
      AssertAlmostEqual(10, Geo.Point[1], 'Неверное значение широты.');

      Target := TJSONObject.Create;
      try
        Geo.Serialize(Target);
        AssertTrue((Target.GetValue('type') as TJSONString).Value = 'Point', 'Сериализация типа точки некорректна.');
        Coordinates := Target.GetValue('coordinates') as TJSONArray;
        AssertTrue(Assigned(Coordinates), 'Ожидается массив координат.');
        AssertTrue(Coordinates.Count = 2, 'Ожидается две координаты в JSON.');
        AssertAlmostEqual(30, TJSONNumber(Coordinates.Items[0]).AsDouble, 'Неверная долгота в JSON.');
        AssertAlmostEqual(10, TJSONNumber(Coordinates.Items[1]).AsDouble, 'Неверная широта в JSON.');
      finally
        Target.Free;
      end;
    finally
      Geo.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestLineStringGeometry;
var
  Source: TJSONObject;
  Target: TJSONObject;
  Coordinates: TJSONArray;
  Line: TJSONArray;
  Geo: TGeoType;
begin
  Writeln('--- Тест геометрии типа LineString ---');
  Source := ParseJSONObject(
    '{"type":"LineString","coordinates":[[30,10],[10,30],[40,40]]}'
  );
  try
    Geo := TGeoType.Create;
    try
      Geo.Parse(Source);
      AssertTrue(SameText(Geo.GeoType, 'LineString'), 'Ожидается тип LineString.');
      AssertTrue(Length(Geo.LineString) = 3, 'Ожидается три точки в ломаной.');
      AssertAlmostEqual(30, Geo.LineString[0][0], 'Неверное значение первой долготы.');
      AssertAlmostEqual(40, Geo.LineString[2][0], 'Неверное значение последней долготы.');

      Target := TJSONObject.Create;
      try
        Geo.Serialize(Target);
        AssertTrue((Target.GetValue('type') as TJSONString).Value = 'LineString', 'Сериализация типа LineString некорректна.');
        Coordinates := Target.GetValue('coordinates') as TJSONArray;
        AssertTrue(Assigned(Coordinates), 'Ожидается массив координат.');
        AssertTrue(Coordinates.Count = 3, 'Ожидается три точки в JSON.');
        AssertTrue(Coordinates.Items[1] is TJSONArray, 'В JSON ожидается массив координат для второй точки.');
        Line := TJSONArray(Coordinates.Items[1]);
        AssertAlmostEqual(10, TJSONNumber(Line.Items[0]).AsDouble, 'Неверная долгота второй точки.');
        AssertAlmostEqual(30, TJSONNumber(Line.Items[1]).AsDouble, 'Неверная широта второй точки.');
      finally
        Target.Free;
      end;
    finally
      Geo.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestPolygonGeometry;
var
  Source: TJSONObject;
  Target: TJSONObject;
  Coordinates: TJSONArray;
  Ring: TJSONArray;
  Point: TJSONArray;
  Geo: TGeoType;
begin
  Writeln('--- Тест геометрии типа Polygon ---');
  Source := ParseJSONObject(
    '{"type":"Polygon","coordinates":[[[30,10],[40,40],[20,40],[10,20],[30,10]]]}'
  );
  try
    Geo := TGeoType.Create;
    try
      Geo.Parse(Source);
      AssertTrue(SameText(Geo.GeoType, 'Polygon'), 'Ожидается тип Polygon.');
      AssertTrue(Length(Geo.Polygon) = 1, 'Ожидается одно кольцо полигона.');
      AssertTrue(Length(Geo.Polygon[0]) = 5, 'Ожидается пять точек в кольце.');
      AssertAlmostEqual(20, Geo.Polygon[0][2][0], 'Неверная долгота третьей точки.');
      AssertAlmostEqual(40, Geo.Polygon[0][2][1], 'Неверная широта третьей точки.');

      Target := TJSONObject.Create;
      try
        Geo.Serialize(Target);
        AssertTrue((Target.GetValue('type') as TJSONString).Value = 'Polygon', 'Сериализация типа Polygon некорректна.');
        Coordinates := Target.GetValue('coordinates') as TJSONArray;
        AssertTrue(Assigned(Coordinates), 'Ожидается массив координат.');
        AssertTrue(Coordinates.Count = 1, 'Ожидается одно кольцо в JSON.');
        AssertTrue(Coordinates.Items[0] is TJSONArray, 'Ожидается массив точек в JSON.');
        Ring := TJSONArray(Coordinates.Items[0]);
        AssertTrue(Ring.Count = 5, 'Ожидается пять точек в JSON.');
        AssertTrue(Ring.Items[4] is TJSONArray, 'Ожидается массив координат точки.');
        Point := TJSONArray(Ring.Items[4]);
        AssertAlmostEqual(30, TJSONNumber(Point.Items[0]).AsDouble, 'Неверная долгота последней точки.');
        AssertAlmostEqual(10, TJSONNumber(Point.Items[1]).AsDouble, 'Неверная широта последней точки.');
      finally
        Target.Free;
      end;
    finally
      Geo.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestAssignCreatesDeepCopy;
var
  Original: TGeoType;
  Clone: TGeoType;
  Coordinates: TJSONArray;
  Source: TJSONObject;
  Target: TJSONObject;
begin
  Writeln('--- Тест глубокого копирования через Assign ---');
  Source := ParseJSONObject('{"type":"Point","coordinates":[1,2]}');
  try
    Original := TGeoType.Create;
    Clone := TGeoType.Create;
    try
      Original.Parse(Source);
      AssertTrue(Clone.Assign(Original), 'Метод Assign должен вернуть True.');
      Clone.Point[0] := 100;
      AssertAlmostEqual(1, Original.Point[0], 'Оригинальный объект не должен изменяться при модификации клона.');

      Target := TJSONObject.Create;
      try
        Clone.Serialize(Target);
        Coordinates := Target.GetValue('coordinates') as TJSONArray;
        AssertTrue(Assigned(Coordinates), 'Ожидается массив координат точки.');
        AssertAlmostEqual(100, TJSONNumber(Coordinates.Items[0]).AsDouble, 'В клоне ожидается обновлённое значение координаты.');
      finally
        Target.Free;
      end;
    finally
      Original.Free;
      Clone.Free;
    end;
  finally
    Source.Free;
  end;
end;

begin
  try
    TestPointGeometry;
    TestLineStringGeometry;
    TestPolygonGeometry;
    TestAssignCreatesDeepCopy;
    Writeln('Все тесты успешно завершены.');
  except
    on E: Exception do
    begin
      Writeln('Ошибка выполнения тестов: ' + E.Message);
      ExitCode := 1;
    end;
  end;
end.
