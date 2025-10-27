unit ConditionUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  FuncUnit,
  System.SysUtils,
  EntityUnit;

type
  ///
  TCondition = class(TFieldSet)
  private
    FField: string;
    FText: string;
    FType: string;
  public
    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    function Caption: string;
    property Field: string read FField write FField;
    property Text: string read FText write FText;
    property &Type: string read FType write FType;
  end;

  ///
  TConditionList = class(TFieldSetList)
  private
    function GetCondition(Index: Integer): TCondition;
    procedure SetCondition(Index: Integer; const Value: TCondition);
  protected
    class function ItemClassType: TFieldSetClass; override;
  public
    property Items[Index: Integer]: TCondition read GetCondition write SetCondition; default;
  end;

implementation

{ TCondition }

function TCondition.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;

  if not Assigned(ASource) then
    Exit;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TCondition) then
    Exit;

  var src := TCondition(ASource);

  Field := src.Field;
  Text := src.Text;
  &Type := src.&Type;

  Result := true;
end;

function TCondition.Caption: string;
begin
  result := Format('[%s %s %s]', [Field, &Type, Text])
end;

procedure TCondition.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(src) then
  begin
    Field := '';
    Text := '';
    &Type := '';
    Exit;
  end;

  Field := GetValueStrDef(src, 'field', '');
  Text := GetValueStrDef(src, 'text', '');
  &Type := GetValueStrDef(src, 'type', '');
end;

procedure TCondition.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then
    Exit;

  dst.AddPair('field', Field);
  dst.AddPair('text', Text);
  dst.AddPair('type', &Type);
end;

{ TConditionList }

function TConditionList.GetCondition(Index: Integer): TCondition;
begin
  Result := nil;

  if (Index < 0) or (Index >= Count) then
    Exit;

  if inherited Items[Index] is TCondition then
    Result := TCondition(inherited Items[Index]);
end;

class function TConditionList.ItemClassType: TFieldSetClass;
begin
  Result := TCondition;
end;

procedure TConditionList.SetCondition(Index: Integer; const Value: TCondition);
begin
  if (Index < 0) or (Index >= Count) then
    Exit;

  if not Assigned(Value) then
    Exit;

  if not (Value is TCondition) then
    Exit;

  if Assigned(inherited Items[Index]) then
    inherited Items[Index].Free;

  inherited Items[Index] := Value;
end;

end.
