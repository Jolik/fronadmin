unit GUIDListUnit;

interface

uses
  System.SysUtils, System.Generics.Collections, System.JSON,
  LoggingUnit;

type
  ///  GUID
  TGUIDList = class(TObject)
  private
    FItems: TList<TGUID>;
    function GetCount: Integer;
    function GetItem(Index: Integer): TGUID;
  public
    constructor Create; overload;
    constructor Create(src: TJSONArray); overload;
    destructor Destroy; override;

    procedure Clear;
    procedure Assign(ASource: TGUIDList);
    procedure Parse(src: TJSONArray);
    procedure Serialize(dst: TJSONArray);
    function SerializeList: TJSONArray;
    procedure Add(const Value: TGUID);

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TGUID read GetItem; default;
  end;

implementation

function NormalizeGuidString(const AGuid: TGUID): string;
begin
  Result := GUIDToString(AGuid);
  Result := Result.Trim(['{', '}']);
  Result := LowerCase(Result);
end;

{ TGUIDList }

procedure TGUIDList.Add(const Value: TGUID);
begin
  FItems.Add(Value);
end;

procedure TGUIDList.Assign(ASource: TGUIDList);
begin
  if ASource = nil then
  begin
    Clear;
    Exit;
  end;

  Clear;

  for var GuidValue in ASource.FItems do
    FItems.Add(GuidValue);
end;

procedure TGUIDList.Clear;
begin
  FItems.Clear;
end;

constructor TGUIDList.Create;
begin
  inherited Create;

  FItems := TList<TGUID>.Create;
end;

constructor TGUIDList.Create(src: TJSONArray);
begin
  Create;

  Parse(src);
end;

destructor TGUIDList.Destroy;
begin
  FItems.Free;

  inherited;
end;

function TGUIDList.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TGUIDList.GetItem(Index: Integer): TGUID;
begin
  Result := FItems[Index];
end;

procedure TGUIDList.Parse(src: TJSONArray);
var
  GuidValue: TGUID;
  GuidString: string;
begin
  Clear;

  if not Assigned(src) then
    Exit;

  for var JSONValue in src do
  begin
    if JSONValue is TJSONString then
      GuidString := TJSONString(JSONValue).Value
    else
      GuidString := JSONValue.Value;
    try
      GuidValue := StringToGUID(GuidString);
      FItems.Add(GuidValue);
    except on e:exception do
      begin
        Log('TGUIDList.Parse '+ e.Message, lrtError);
      end;
    end;
  end;
end;

procedure TGUIDList.Serialize(dst: TJSONArray);
begin
  if not Assigned(dst) then
    Exit;

  for var GuidValue in FItems do
    dst.Add(NormalizeGuidString(GuidValue));
end;

function TGUIDList.SerializeList: TJSONArray;
begin
  Result := TJSONArray.Create;
  try
    Serialize(Result);
  except
    Result.Free;
    raise;
  end;
end;

end.

