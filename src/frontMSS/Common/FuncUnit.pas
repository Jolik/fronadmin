unit FuncUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections;

type
  Nullable<T> = record
  private
    FHasValue: Boolean;
    FValue: T;
  public
    class function Create(const AValue: T): Nullable<T>; static;
    procedure Clear;
    function ValueOrDefault(const AValue: T): T;
    property HasValue: Boolean read FHasValue;
    property Value: T read FValue;
  end;

function ExtractJSONProperties(
  const ASourceJSONObject: TJSONObject;
  const APropertyNames: TArray<string>): TJSONObject;

function JSONArrayToStringList(AJSONArray: TJSONArray): TStringList;
function JSONArrayToDictionary(AJSONArray: TJSONArray): TDictionary<string, string>;
function GetValueInt64Def(json: TJSONValue; path: string; default: Int64): Int64;
function GetValueFloatDef(json: TJSONValue; path: string; default: Float64): Float64;
function GetNullableFloat(json: TJSONValue; path: string): Nullable<Double>;
function GetValueIntDef(json: TJSONValue; path: string; default: integer): integer;
function GetNullableInt(json: TJSONValue; path: string): Nullable<Integer>;
function GetNullableInt64(json: TJSONValue; path: string): Nullable<Int64>;
function GetValueStrDef(json: TJSONValue; path: string; default: string): string;
function GetNullableStr(json: TJSONValue; path: string): Nullable<string>;
function GetValueBool(json: TJSONValue; path: string): boolean;
function ClassNameSafe(o: TObject): string;

implementation

{ Nullable<T> }

class function Nullable<T>.Create(const AValue: T): Nullable<T>;
begin
  Result.FHasValue := True;
  Result.FValue := AValue;
end;

procedure Nullable<T>.Clear;
begin
  FHasValue := False;
  FValue := Default(T);
end;

function Nullable<T>.ValueOrDefault(const AValue: T): T;
begin
  if FHasValue then
    Result := FValue
  else
    Result := AValue;
end;

function ExtractJSONProperties(
  const ASourceJSONObject: TJSONObject;
  const APropertyNames: TArray<string>): TJSONObject;
var
  I: Integer;
  PropName: string;
  JSONValue: TJSONValue;
begin
  Result := TJSONObject.Create;
  try
    for PropName in APropertyNames do
    begin
      JSONValue := ASourceJSONObject.GetValue(PropName);
      if Assigned(JSONValue) then
        Result.AddPair(PropName, JSONValue.Clone as TJSONValue);
    end;
  except
    Result.Free;
    raise;
  end;
end;

function JSONArrayToStringList(AJSONArray: TJSONArray): TStringList;
var
  I: Integer;
begin
  Result := TStringList.Create;
  try
    if not Assigned(AJSONArray) then
      Exit;

    for I := 0 to AJSONArray.Count - 1 do
    begin
      // Предполагаем, что элементы массива - строки
      if AJSONArray.Items[I] is TJSONString then
        Result.Add((AJSONArray.Items[I] as TJSONString).Value)
      else
        // Если элемент не строка, преобразуем его в строковое представление
        Result.Add(AJSONArray.Items[I].ToString);
    end;
  except
    Result.Free;
    raise;
  end;
end;

function JSONArrayToDictionary(AJSONArray: TJSONArray): TDictionary<string, string>;
var
  I: Integer;
  JSONObject: TJSONObject;
  Key, Value: string;
begin
  Result := TDictionary<string, string>.Create;

  if not Assigned(AJSONArray) then
    Exit;

  try
    for I := 0 to AJSONArray.Count - 1 do
    begin
      if AJSONArray.Items[I] is TJSONObject then
      begin
        JSONObject := AJSONArray.Items[I] as TJSONObject;

        // Предполагаем структуру: {"key": "ключ", "value": "значение"}
        if JSONObject.TryGetValue<string>('key', Key) and
           JSONObject.TryGetValue<string>('value', Value) then
        begin
          Result.AddOrSetValue(Key, Value);
        end;
      end;
    end;
  except
    Result.Free;
    raise;
  end;
end;

function GetValueFloatDef(json: TJSONValue; path: string; default: Float64): Float64;
begin
  Result := default;
  try
    json.TryGetValue<Float64>(path, Result);
  except
  end;
end;

function GetNullableFloat(json: TJSONValue; path: string): Nullable<Double>;
var
  Value: Double;
  Node: TJSONValue;
begin
  Result.Clear;
  if not Assigned(json) then
    Exit;

  Node := json.FindValue(path);
  if not Assigned(Node) or (Node is TJSONNull) then
    Exit;

  if Node.TryGetValue<Double>(Value) then
    Result := Nullable<Double>.Create(Value);
end;

function GetValueInt64Def(json: TJSONValue; path: string; default: Int64): Int64;
begin
  Result := default;
  try
    json.TryGetValue<Int64>(path, Result);
  except
  end;
end;

function GetValueIntDef(json: TJSONValue; path: string; default: integer): integer;
begin
  result := default;
  try
    json.TryGetValue<integer>(path, result);
  except
  end;
end;

function GetNullableInt(json: TJSONValue; path: string): Nullable<Integer>;
var
  Value: Integer;
  Node: TJSONValue;
begin
  Result.Clear;
  if not Assigned(json) then
    Exit;

  Node := json.FindValue(path);
  if not Assigned(Node) or (Node is TJSONNull) then
    Exit;

  if Node.TryGetValue<Integer>(Value) then
    Result := Nullable<Integer>.Create(Value);
end;

function GetNullableInt64(json: TJSONValue; path: string): Nullable<Int64>;
var
  Value: Int64;
  Node: TJSONValue;
begin
  Result.Clear;
  if not Assigned(json) then
    Exit;

  Node := json.FindValue(path);
  if not Assigned(Node) or (Node is TJSONNull) then
    Exit;

  if Node.TryGetValue<Int64>(Value) then
    Result := Nullable<Int64>.Create(Value);
end;



function GetValueStrDef(json: TJSONValue; path: string; default: string): string;
begin
  result := default;
  try
    json.TryGetValue<string>(path, result);
  except
  end;
end;


function GetNullableStr(json: TJSONValue; path: string): Nullable<string>;
var
  Value: string;
  Node: TJSONValue;
begin
  Result.Clear;
  if not Assigned(json) then
    Exit;

  Node := json.FindValue(path);
  if not Assigned(Node) or (Node is TJSONNull) then
    Exit;

  if Node.TryGetValue<string>(Value) then
    Result := Nullable<string>.Create(Value);
end;


function GetValueBool(json: TJSONValue; path: string): boolean;
begin
  result := false;
  try
    json.TryGetValue<boolean>(path, result);
  except
  end;
end;


function ClassNameSafe(o: TObject): string;
begin
  if o = nil then
  begin
    result := 'nil';
    exit;
  end;
  result := o.ClassName;
end;

end.
