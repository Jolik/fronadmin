unit Utils;

interface
uses System.JSON, SysUtils;

function GetValueIntDef(json: TJSONValue; path: string; default: integer): integer;
function GetValueStrDef(json: TJSONValue; path: string; default: string): string;
function GetValueBool(json: TJSONValue; path: string): boolean;

implementation

// GetValueIntDef получить int из json-а по пути path.
// потому что TJSONValue GetValue и TryGetValue запороты (падают с эксепшанами конвертации)
// дженерики на простых функциях язать нельзя. бугого.
function GetValueIntDef(json: TJSONValue; path: string; default: integer): integer;
begin
  result := default;
  var val := json.FindValue(path);
  if (val = nil) or not (val is TJSONNumber) then
    exit;
  result := (val as TJSONNumber).AsInt;
end;

function GetValueStrDef(json: TJSONValue; path: string; default: string): string;
begin
  result := default;
  var val := json.FindValue(path);
  if (val = nil) or not (val is TJSONString) then
    exit;
  result := (val as TJSONString).ToString;
  if length(result) < 2 then
    exit;
  if result[1] = '"' then
    delete(result, 1, 1);
  if result[length(result)] = '"' then
    delete(result, length(result), 1);
end;

function GetValueBool(json: TJSONValue; path: string): boolean;
begin
  result := false;
  var val := json.FindValue(path);
  if (val = nil) or not (val is TJSONValue) then
    exit;
  result := (val as TJSONBool).AsBoolean;
end;

end.
