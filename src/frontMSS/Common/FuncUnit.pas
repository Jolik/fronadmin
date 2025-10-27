unit FuncUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections;

function ExtractJSONProperties(
  const ASourceJSONObject: TJSONObject;
  const APropertyNames: TArray<string>): TJSONObject;

function JSONArrayToStringList(AJSONArray: TJSONArray): TStringList;
function JSONArrayToDictionary(AJSONArray: TJSONArray): TDictionary<string, string>;
function GetValueIntDef(json: TJSONValue; path: string; default: integer): integer;
function GetValueStrDef(json: TJSONValue; path: string; default: string): string;
function GetValueBool(json: TJSONValue; path: string): boolean;
function ClassNameSafe(o: TObject): string;

implementation

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



function GetValueIntDef(json: TJSONValue; path: string; default: integer): integer;
begin
  result := default;
  try
    json.TryGetValue<integer>(path, result);
  except
  end;
end;



function GetValueStrDef(json: TJSONValue; path: string; default: string): string;
begin
  result := default;
  try
    json.TryGetValue<string>(path, result);
  except
  end;
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
