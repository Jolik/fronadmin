unit KeyValUnit;

interface
uses
 Classes, SysUtils;

type
  TKeyValue<T> = class
  private
    FKeys: TArray<string>;
    FValues: TArray<T>;
  public
    procedure Add(key: string; value: T); virtual;
    function ValueByKey(key: string; default: T): T; virtual;
    function KeyByValue(value: T; default: string = ''): string; virtual;
    property Keys: TArray<string> read FKeys;
    property Values: TArray<T> read FValues;
  end;

implementation



{ TKeyValue<T> }

procedure TKeyValue<T>.Add(key: string; value: T);
begin
  var idx := length(FKeys);
  SetLength(FKeys, idx+1);
  SetLength(FValues, idx+1);
  FKeys[idx] := key;
  FValues[idx] := value;
end;


function TKeyValue<T>.ValueByKey(key: string; default: T): T;
begin
  for var i := Low(FKeys) to High(FKeys) do
    if FKeys[i] = key then
    begin
      result := FValues[i];
      exit;
    end;
  result := default;
end;

function TKeyValue<T>.KeyByValue(value: T; default: string = ''): string;
begin
  for var i := Low(FValues) to High(FValues) do
    if FValues[i] = value then
    begin
      result := FKeys[i];
      exit;
    end;
  result := default;
end;


end.
