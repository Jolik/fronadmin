unit DataserieUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  EntityUnit;

type
  ///  data serie entity
  TDataserie = class(TEntity)
  private
    FLastInsert: TDateTime;
    FMid: string;
    FLastData: TJSONValue;
    function GetDsid: string;
    procedure SetDsid(const Value: string);
  protected
    function GetIdKey: string; override;
  public
    constructor Create; overload; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): boolean; override;

    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Dsid: string read GetDsid write SetDsid;
    property Mid: string read FMid write FMid;
    property LastInsert: TDateTime read FLastInsert write FLastInsert;
    property LastData: TJSONValue read FLastData;
  end;

type
  /// list of dataseries
  TDataseriesList = class(TEntityList)
  public
    class function ItemClassType: TEntityClass; override;
    procedure SerializeList(dst: TJSONArray; const APropertyNames: TArray<string> = nil); override;
  end;

implementation

uses
  System.SysUtils, System.DateUtils,
  FuncUnit;

const
  DsidKey = 'dsid';
  MidKey = 'mid';
  LastInsertKey = 'last_insert';
  LastDataKey = 'lastData';

{ TDataserie }

function TDataserie.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TDataserie) then
    Exit;

  var Src := TDataserie(ASource);

  FLastInsert := Src.LastInsert;
  FMid := Src.Mid;

  FreeAndNil(FLastData);
  if Assigned(Src.FLastData) then
    FLastData := Src.FLastData.Clone as TJSONValue;

  Result := true;
end;

constructor TDataserie.Create;
begin
  FLastData := nil;
  inherited Create;
end;

destructor TDataserie.Destroy;
begin
  FreeAndNil(FLastData);
  inherited;
end;

function TDataserie.GetDsid: string;
begin
  Result := Id;
end;

function TDataserie.GetIdKey: string;
begin
  Result := DsidKey;
end;

procedure TDataserie.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  Value: TJSONValue;
begin
  inherited Parse(src, APropertyNames);

  FMid := GetValueStrDef(src, MidKey, '');
  FLastInsert := UnixToDateTime(GetValueIntDef(src, LastInsertKey, 0));

  FreeAndNil(FLastData);
  Value := src.FindValue(LastDataKey);
  if Assigned(Value) then
    FLastData := Value.Clone as TJSONValue;
end;

procedure TDataserie.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  Value: TJSONValue;
begin
  inherited Serialize(dst, APropertyNames);

  dst.AddPair(MidKey, FMid);
  dst.AddPair(LastInsertKey, DateTimeToUnix(FLastInsert));

  if Assigned(FLastData) then
    Value := FLastData.Clone as TJSONValue
  else
    Value := TJSONNull.Create;

  dst.AddPair(LastDataKey, Value);
end;

procedure TDataserie.SetDsid(const Value: string);
begin
  Id := Value;
end;

{ TDataseriesList }

class function TDataseriesList.ItemClassType: TEntityClass;
begin
  Result := TDataserie;
end;

procedure TDataseriesList.SerializeList(dst: TJSONArray;
  const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then
    Exit;

  for var Serie in Self do
  begin
    var Obj := Serie.Serialize(APropertyNames);
    if Assigned(Obj) then
      dst.AddElement(Obj)
    else
      dst.AddElement(TJSONObject.Create);
  end;
end;

end.

