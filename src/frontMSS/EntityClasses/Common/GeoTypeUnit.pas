unit GeoTypeUnit;

interface

uses
  System.SysUtils, System.JSON,
  FuncUnit,
  EntityUnit;

type
  /// <summary>Массив координат, описывающий одну точку (например, долготу и широту).</summary>
  TGeoCoordinate = array of Double;
  /// <summary>Набор точек, который используется для построения ломаной линии.</summary>
  TGeoLineCoordinates = array of TGeoCoordinate;
  /// <summary>Набор ломаных линий (колец), формирующих контур полигона.</summary>
  TGeoPolygonCoordinates = array of TGeoLineCoordinates;

  /// <summary>Класс для представления геометрии GeoJSON и работы с её координатами.</summary>
  TGeoType = class(TFieldSet)
  private
    /// <summary>Тип геометрии (Point, LineString, Polygon).</summary>
    FGeoType: string;
    /// <summary>Координаты точки.</summary>
    FPoint: TGeoCoordinate;
    /// <summary>Координаты ломаной линии.</summary>
    FLineString: TGeoLineCoordinates;
    /// <summary>Координаты полигона.</summary>
    FPolygon: TGeoPolygonCoordinates;

    /// <summary>Полностью очищает все массивы координат.</summary>
    procedure ClearCoordinates;
    /// <summary>Разбор массива координат для точки.</summary>
    procedure ParsePointArray(AArray: TJSONArray);
    /// <summary>Разбор массива координат для ломаной линии.</summary>
    procedure ParseLineStringArray(AArray: TJSONArray);
    /// <summary>Разбор массива координат для полигона.</summary>
    procedure ParsePolygonArray(AArray: TJSONArray);

    /// <summary>Формирует JSON-массив из координат точки.</summary>
    function BuildPointArray: TJSONArray;
    /// <summary>Формирует JSON-массив из координат ломаной линии.</summary>
    function BuildLineStringArray: TJSONArray;
    /// <summary>Формирует JSON-массив из координат полигона.</summary>
    function BuildPolygonArray: TJSONArray;

    /// <summary>Устанавливает координаты точки с копированием значений.</summary>
    procedure SetPoint(const Value: TGeoCoordinate);
    /// <summary>Устанавливает координаты ломаной линии с копированием значений.</summary>
    procedure SetLineString(const Value: TGeoLineCoordinates);
    /// <summary>Устанавливает координаты полигона с копированием значений.</summary>
    procedure SetPolygon(const Value: TGeoPolygonCoordinates);
  public
    constructor Create; overload; override;

    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property GeoType: string read FGeoType write FGeoType;
    property Point: TGeoCoordinate read FPoint write SetPoint;
    property LineString: TGeoLineCoordinates read FLineString write SetLineString;
    property Polygon: TGeoPolygonCoordinates read FPolygon write SetPolygon;
  end;

implementation

const
  // Ключи JSON-объекта согласно спецификации GeoJSON
  TypeKey = 'type';
  CoordinatesKey = 'coordinates';
  // Допустимые типы геометрии
  GeoTypePoint = 'Point';
  GeoTypeLineString = 'LineString';
  GeoTypePolygon = 'Polygon';

{ TGeoType }

function TGeoType.Assign(ASource: TFieldSet): boolean;
var
  Source: TGeoType;
begin
  Result := false;

  // Если источник не задан — нечего копировать
  if not Assigned(ASource) then
    Exit;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TGeoType) then
    Exit;

  Source := TGeoType(ASource);

  ClearCoordinates;

  // Копируем только тот тип координат, который актуален для источника
  if SameText(Source.GeoType, GeoTypePoint) then
  begin
    SetPoint(Source.Point);
    FGeoType := GeoTypePoint;
  end
  else if SameText(Source.GeoType, GeoTypeLineString) then
  begin
    SetLineString(Source.LineString);
    FGeoType := GeoTypeLineString;
  end
  else if SameText(Source.GeoType, GeoTypePolygon) then
  begin
    SetPolygon(Source.Polygon);
    FGeoType := GeoTypePolygon;
  end
  else
  begin
    SetPoint(Source.Point);
    SetLineString(Source.LineString);
    SetPolygon(Source.Polygon);
  end;

  FGeoType := Source.GeoType;

  Result := true;
end;

function TGeoType.BuildLineStringArray: TJSONArray;
var
  I, J: Integer;
  PointArray: TJSONArray;
begin
  // Преобразуем внутренние массивы в иерархию JSON-массивов
  Result := TJSONArray.Create;
  for I := 0 to High(FLineString) do
  begin
    PointArray := TJSONArray.Create;
    for J := 0 to High(FLineString[I]) do
      PointArray.Add(FLineString[I][J]);
    Result.AddElement(PointArray);
  end;
end;

function TGeoType.BuildPointArray: TJSONArray;
var
  I: Integer;
begin
  Result := TJSONArray.Create;
  // Сериализуем координаты точки по порядку
  for I := 0 to High(FPoint) do
    Result.Add(FPoint[I]);
end;

function TGeoType.BuildPolygonArray: TJSONArray;
var
  I, J, K: Integer;
  LineArray: TJSONArray;
  PointArray: TJSONArray;
begin
  Result := TJSONArray.Create;
  for I := 0 to High(FPolygon) do
  begin
    LineArray := TJSONArray.Create;
    for J := 0 to High(FPolygon[I]) do
    begin
      PointArray := TJSONArray.Create;
      for K := 0 to High(FPolygon[I][J]) do
        PointArray.Add(FPolygon[I][J][K]);
      LineArray.AddElement(PointArray);
    end;
    Result.AddElement(LineArray);
  end;
end;

procedure TGeoType.ClearCoordinates;
begin
  SetLength(FPoint, 0);
  SetLength(FLineString, 0);
  SetLength(FPolygon, 0);
end;

constructor TGeoType.Create;
begin
  inherited Create;
  FGeoType := '';
  // Сразу очищаем состояния массивов
  ClearCoordinates;
end;

procedure TGeoType.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  CoordinatesValue: TJSONValue;
  CoordinatesArray: TJSONArray;
begin
  FGeoType := '';
  ClearCoordinates;

  // Если входной JSON не задан, то дальнейшая обработка не требуется
  if not Assigned(src) then
    Exit;

  FGeoType := GetValueStrDef(src, TypeKey, '');

  CoordinatesValue := src.FindValue(CoordinatesKey);
  if not Assigned(CoordinatesValue) then
    Exit;

  if not (CoordinatesValue is TJSONArray) then
    Exit;

  CoordinatesArray := TJSONArray(CoordinatesValue);

  // В зависимости от типа выбираем процедуру разбора массива координат
  if SameText(FGeoType, GeoTypePoint) then
    ParsePointArray(CoordinatesArray)
  else if SameText(FGeoType, GeoTypeLineString) then
    ParseLineStringArray(CoordinatesArray)
  else if SameText(FGeoType, GeoTypePolygon) then
    ParsePolygonArray(CoordinatesArray);
end;

procedure TGeoType.ParseLineStringArray(AArray: TJSONArray);
var
  I, J: Integer;
  ItemArray: TJSONArray;
begin
  SetLength(FLineString, 0);

  if not Assigned(AArray) then
    Exit;

  // Каждый элемент верхнего массива — это массив координат точки
  SetLength(FLineString, AArray.Count);
  for I := 0 to AArray.Count - 1 do
  begin
    if AArray.Items[I] is TJSONArray then
    begin
      ItemArray := TJSONArray(AArray.Items[I]);
      SetLength(FLineString[I], ItemArray.Count);
      for J := 0 to ItemArray.Count - 1 do
        if ItemArray.Items[J] is TJSONNumber then
          FLineString[I][J] := TJSONNumber(ItemArray.Items[J]).AsDouble
        else
          FLineString[I][J] := 0.0;
    end
    else
      SetLength(FLineString[I], 0);
  end;
end;

procedure TGeoType.ParsePointArray(AArray: TJSONArray);
var
  I: Integer;
begin
  SetLength(FPoint, 0);

  if not Assigned(AArray) then
    Exit;

  // Заполняем массив координат точными значениями из JSON
  SetLength(FPoint, AArray.Count);
  for I := 0 to AArray.Count - 1 do
    if AArray.Items[I] is TJSONNumber then
      FPoint[I] := TJSONNumber(AArray.Items[I]).AsDouble
    else
      FPoint[I] := 0.0;
end;

procedure TGeoType.ParsePolygonArray(AArray: TJSONArray);
var
  I, J, K: Integer;
  LineArray: TJSONArray;
  PointArray: TJSONArray;
begin
  SetLength(FPolygon, 0);

  if not Assigned(AArray) then
    Exit;

  // Структура полигона — массив линий, каждая линия состоит из точек
  SetLength(FPolygon, AArray.Count);
  for I := 0 to AArray.Count - 1 do
  begin
    if AArray.Items[I] is TJSONArray then
    begin
      LineArray := TJSONArray(AArray.Items[I]);
      SetLength(FPolygon[I], LineArray.Count);
      for J := 0 to LineArray.Count - 1 do
      begin
        if LineArray.Items[J] is TJSONArray then
        begin
          PointArray := TJSONArray(LineArray.Items[J]);
          SetLength(FPolygon[I][J], PointArray.Count);
          for K := 0 to PointArray.Count - 1 do
            if PointArray.Items[K] is TJSONNumber then
              FPolygon[I][J][K] := TJSONNumber(PointArray.Items[K]).AsDouble
            else
              FPolygon[I][J][K] := 0.0;
        end
        else
          SetLength(FPolygon[I][J], 0);
      end;
    end
    else
      SetLength(FPolygon[I], 0);
  end;
end;

procedure TGeoType.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  CoordinatesArray: TJSONArray;
begin
  if not Assigned(dst) then
    Exit;

  dst.AddPair(TypeKey, FGeoType);

  // Формируем массив координат в соответствии с текущим типом геометрии
  if SameText(FGeoType, GeoTypePoint) then
    CoordinatesArray := BuildPointArray
  else if SameText(FGeoType, GeoTypeLineString) then
    CoordinatesArray := BuildLineStringArray
  else if SameText(FGeoType, GeoTypePolygon) then
    CoordinatesArray := BuildPolygonArray
  else if Length(FPolygon) > 0 then
    CoordinatesArray := BuildPolygonArray
  else if Length(FLineString) > 0 then
    CoordinatesArray := BuildLineStringArray
  else if Length(FPoint) > 0 then
    CoordinatesArray := BuildPointArray
  else
    CoordinatesArray := TJSONArray.Create;

  dst.AddPair(CoordinatesKey, CoordinatesArray);
end;

procedure TGeoType.SetLineString(const Value: TGeoLineCoordinates);
var
  I, J: Integer;
begin
  SetLength(FPoint, 0);
  SetLength(FLineString, Length(Value));
  // Копируем значения, чтобы избежать разделения памяти между объектами
  for I := 0 to High(Value) do
  begin
    SetLength(FLineString[I], Length(Value[I]));
    for J := 0 to High(Value[I]) do
      FLineString[I][J] := Value[I][J];
  end;

  SetLength(FPolygon, 0);
  FGeoType := GeoTypeLineString;
end;

procedure TGeoType.SetPoint(const Value: TGeoCoordinate);
var
  I: Integer;
begin
  SetLength(FLineString, 0);
  SetLength(FPolygon, 0);
  SetLength(FPoint, Length(Value));
  // Создаём копию массива координат точки
  for I := 0 to High(Value) do
    FPoint[I] := Value[I];

  FGeoType := GeoTypePoint;
end;

procedure TGeoType.SetPolygon(const Value: TGeoPolygonCoordinates);
var
  I, J, K: Integer;
begin
  SetLength(FPoint, 0);
  SetLength(FLineString, 0);
  SetLength(FPolygon, Length(Value));
  // Глубоко копируем все уровни массива полигона
  for I := 0 to High(Value) do
  begin
    SetLength(FPolygon[I], Length(Value[I]));
    for J := 0 to High(Value[I]) do
    begin
      SetLength(FPolygon[I][J], Length(Value[I][J]));
      for K := 0 to High(Value[I][J]) do
        FPolygon[I][J][K] := Value[I][J][K];
    end;
  end;

  FGeoType := GeoTypePolygon;
end;

end.

