unit FilterUnit;

interface

uses
  System.JSON, System.Generics.Collections,
  FuncUnit,
  ConditionUnit,
  EntityUnit;

type
  ///
  TFilter = class(TFieldSet)
  private
    FDisable: boolean;
    FConditions: TConditionList;
  public
    constructor Create; overload; override;
    constructor Create(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Disable: boolean read FDisable write FDisable;
    property Conditions: TConditionList read FConditions;
  end;

  ///
  TFilterList = class(TFieldSetList)
  private
    function GetFilter(Index: Integer): TFilter;
    procedure SetFilter(Index: Integer; const Value: TFilter);
  protected
    class function ItemClassType: TFieldSetClass; override;
  public
    property Filters[Index: Integer]: TFilter read GetFilter write SetFilter;
  end;

implementation

{ TFilter }

function TFilter.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;

  if not Assigned(ASource) then
    Exit;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TFilter) then
    Exit;

  var src := TFilter(ASource);

  Disable := src.Disable;

  FConditions.Clear;
  for var I := 0 to src.Conditions.Count - 1 do
  begin
    var Condition := src.Conditions[I];
    if not Assigned(Condition) then
      Continue;

    var NewCondition := TCondition.Create;
    if not NewCondition.Assign(Condition) then
    begin
      NewCondition.Free;
      Continue;
    end;

    FConditions.Add(NewCondition);
  end;

  Result := true;
end;

constructor TFilter.Create;
begin
  inherited Create;

  FConditions := TConditionList.Create;
end;

constructor TFilter.Create(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Create;

  Parse(src, APropertyNames);
end;

destructor TFilter.Destroy;
begin
  FConditions.Free;

  inherited;
end;

procedure TFilter.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  Value: TJSONValue;
begin
  FDisable := false;
  FConditions.Clear;

  if not Assigned(src) then
    Exit;

  FDisable := GetValueBool(src, 'disable');

  Value := src.FindValue('conditions');
  if Assigned(Value) and (Value is TJSONArray) then
    FConditions.ParseList(Value as TJSONArray);
end;

procedure TFilter.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then
    Exit;

  dst.AddPair('disable', TJSONBool.Create(FDisable));
  var ConditionsArray := FConditions.SerializeList;
  if Assigned(ConditionsArray) then
    dst.AddPair('conditions', ConditionsArray)
  else
    dst.AddPair('conditions', TJSONArray.Create);
end;

{ TFilterList }

function TFilterList.GetFilter(Index: Integer): TFilter;
begin
  Result := nil;

  if (Index < 0) or (Index >= Count) then
    Exit;

  if Items[Index] is TFilter then
    Result := TFilter(Items[Index]);
end;

class function TFilterList.ItemClassType: TFieldSetClass;
begin
  Result := TFilter;
end;

procedure TFilterList.SetFilter(Index: Integer; const Value: TFilter);
begin
  if (Index < 0) or (Index >= Count) then
    Exit;

  if not Assigned(Value) then
    Exit;

  if not (Value is TFilter) then
    Exit;

  if Assigned(Items[Index]) then
    Items[Index].Free;

  Items[Index] := Value;
end;

end.
