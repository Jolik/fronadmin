unit SourceTypeUnit;

interface

uses
  System.JSON,
  System.Generics.Collections,
  FuncUnit,
  EntityUnit;

type
  /// <summary>Source type description for the dataserver.</summary>
  TSourceType = class(TFieldSet)
  private
    FSrctid: string;
    FSrcType: Integer;
    FName: string;
    FDef: TJSONObject;
  public
    constructor Create; overload; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Srctid: string read FSrctid write FSrctid;
    property SrcType: Integer read FSrcType write FSrcType;
    property Name: string read FName write FName;
    property Def: TJSONObject read FDef;
  end;

  /// <summary>Collection of source types for the dataserver.</summary>
  TSourceTypeList = class(TFieldSetList)
  private
    function GetSourceType(Index: Integer): TSourceType;
    procedure SetSourceType(Index: Integer; const Value: TSourceType);
  protected
    class function ItemClassType: TFieldSetClass; override;
  public
    property Items[Index: Integer]: TSourceType read GetSourceType write SetSourceType; default;
  end;

implementation

uses
  System.SysUtils;

const
  SrctidKey = 'srctid';
  SrcTypeKey = 'srcType';
  NameKey = 'name';
  DefKey = 'def';

{ TSourceType }

function TSourceType.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;

  if not Assigned(ASource) then
    Exit;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TSourceType) then
    Exit;

  var Src := TSourceType(ASource);

  FSrctid := Src.Srctid;
  FSrcType := Src.SrcType;
  FName := Src.Name;

  FreeAndNil(FDef);
  if Assigned(Src.FDef) then
    FDef := Src.FDef.Clone as TJSONObject
  else
    FDef := TJSONObject.Create;

  Result := true;
end;

constructor TSourceType.Create;
begin
  FDef := nil;
  inherited Create;
  FDef := TJSONObject.Create;
end;

destructor TSourceType.Destroy;
begin
  FreeAndNil(FDef);
  inherited;
end;

procedure TSourceType.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  DefValue: TJSONValue;
begin
  if not Assigned(src) then
  begin
    FSrctid := '';
    FSrcType := 0;
    FName := '';

    FreeAndNil(FDef);
    FDef := TJSONObject.Create;
    Exit;
  end;

  FSrctid := GetValueStrDef(src, SrctidKey, '');
  FSrcType := GetValueIntDef(src, SrcTypeKey, 0);
  FName := GetValueStrDef(src, NameKey, '');

  FreeAndNil(FDef);
  DefValue := src.FindValue(DefKey);
  if DefValue is TJSONObject then
    FDef := (DefValue as TJSONObject).Clone as TJSONObject
  else
    FDef := TJSONObject.Create;
end;

procedure TSourceType.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  DefClone: TJSONValue;
begin
  if not Assigned(dst) then
    Exit;

  dst.AddPair(SrctidKey, FSrctid);
  dst.AddPair(SrcTypeKey, FSrcType);
  dst.AddPair(NameKey, FName);

  if Assigned(FDef) then
    DefClone := FDef.Clone as TJSONValue
  else
    DefClone := TJSONObject.Create;
  dst.AddPair(DefKey, DefClone);
end;

{ TSourceTypeList }

function TSourceTypeList.GetSourceType(Index: Integer): TSourceType;
begin
  Result := nil;

  if (Index < 0) or (Index >= Count) then
    Exit;

  if Items[Index] is TSourceType then
    Result := TSourceType(Items[Index]);
end;

class function TSourceTypeList.ItemClassType: TFieldSetClass;
begin
  Result := TSourceType;
end;

procedure TSourceTypeList.SetSourceType(Index: Integer; const Value: TSourceType);
begin
  if (Index < 0) or (Index >= Count) then
    Exit;

  if not Assigned(Value) then
    Exit;

  if not (Value is TSourceType) then
    Exit;

  if Assigned(Items[Index]) then
    Items[Index].Free;

  Items[Index] := Value;
end;

end.

