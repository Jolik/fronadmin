unit ContextTypeUnit;

interface

uses
  System.JSON,
  System.Generics.Collections,
  FuncUnit,
  EntityUnit;

type
  /// <summary>Context type description for the dataserver.</summary>
  TContextType = class(TFieldSet)
  private
    FCtxtid: string;
    FName: string;
    FDef: TJSONObject;
  public
    constructor Create; overload; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Ctxtid: string read FCtxtid write FCtxtid;
    property Name: string read FName write FName;
    property Def: TJSONObject read FDef;
  end;

  /// <summary>Collection of context types for the dataserver.</summary>
  TContextTypeList = class(TFieldSetList)
  private
    function GetContextType(Index: Integer): TContextType;
    procedure SetContextType(Index: Integer; const Value: TContextType);
  protected
    class function ItemClassType: TFieldSetClass; override;
  public
    property Items[Index: Integer]: TContextType read GetContextType write SetContextType; default;
  end;

implementation

uses
  System.SysUtils;

const
  CtxtidKey = 'ctxtid';
  NameKey = 'name';
  DefKey = 'def';

{ TContextType }

function TContextType.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;

  if not Assigned(ASource) then
    Exit;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TContextType) then
    Exit;

  var Src := TContextType(ASource);

  FCtxtid := Src.Ctxtid;
  FName := Src.Name;

  FreeAndNil(FDef);
  if Assigned(Src.FDef) then
    FDef := Src.FDef.Clone as TJSONObject
  else
    FDef := TJSONObject.Create;

  Result := true;
end;

constructor TContextType.Create;
begin
  FDef := nil;
  inherited Create;
  FDef := TJSONObject.Create;
end;

destructor TContextType.Destroy;
begin
  FreeAndNil(FDef);
  inherited;
end;

procedure TContextType.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  DefValue: TJSONValue;
begin
  if not Assigned(src) then
  begin
    FCtxtid := '';
    FName := '';

    FreeAndNil(FDef);
    FDef := TJSONObject.Create;
    Exit;
  end;

  FCtxtid := GetValueStrDef(src, CtxtidKey, '');
  FName := GetValueStrDef(src, NameKey, '');

  FreeAndNil(FDef);
  DefValue := src.FindValue(DefKey);
  if DefValue is TJSONObject then
    FDef := (DefValue as TJSONObject).Clone as TJSONObject
  else
    FDef := TJSONObject.Create;
end;

procedure TContextType.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  DefClone: TJSONValue;
begin
  if not Assigned(dst) then
    Exit;

  dst.AddPair(CtxtidKey, FCtxtid);
  dst.AddPair(NameKey, FName);

  if Assigned(FDef) then
    DefClone := FDef.Clone as TJSONValue
  else
    DefClone := TJSONObject.Create;
  dst.AddPair(DefKey, DefClone);
end;

{ TContextTypeList }

function TContextTypeList.GetContextType(Index: Integer): TContextType;
begin
  Result := nil;

  if (Index < 0) or (Index >= Count) then
    Exit;

  if inherited Items[Index] is TContextType then
    Result := TContextType(inherited Items[Index]);
end;

class function TContextTypeList.ItemClassType: TFieldSetClass;
begin
  Result := TContextType;
end;

procedure TContextTypeList.SetContextType(Index: Integer; const Value: TContextType);
begin
  if (Index < 0) or (Index >= Count) then
    Exit;

  if not Assigned(Value) then
    Exit;

  if not (Value is TContextType) then
    Exit;

  if Assigned(inherited Items[Index]) then
    inherited Items[Index].Free;

  inherited Items[Index] := Value;
end;

end.
