unit FilterUnit;

interface

uses
  System.JSON, System.Generics.Collections,
  FuncUnit,
  ConditionUnit,
  EntityUnit;

type

  TProfileFilter = class(TFieldSet)
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


  TProfileFilterList = class(TFieldSetList)
  private
    function GeTProfileFilter(Index: Integer): TProfileFilter;
    procedure SeTProfileFilter(Index: Integer; const Value: TProfileFilter);
  protected
    class function ItemClassType: TFieldSetClass; override;
  public
    property Filters[Index: Integer]: TProfileFilter read GeTProfileFilter write SeTProfileFilter;
  end;


  TQueueFilter = class(TFieldSet)
  private
    FSig: string; // inc|exc
    FFilters: TConditionList;
  public
    constructor Create; overload; override;
    constructor Create(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Sig: string read FSig write FSig;
    property Filters: TConditionList read FFilters;
  end;


  TQueueFilterList = class(TFieldSetList)
  private
    function GetQueueFilter(Index: Integer): TQueueFilter;
    procedure SetQueueFilter(Index: Integer; const Value: TQueueFilter);
  protected
    class function ItemClassType: TFieldSetClass; override;
  public
    property Filters[Index: Integer]: TQueueFilter read GetQueueFilter write SetQueueFilter;
  end;




implementation

{ TProfileFilter }

function TProfileFilter.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;

  if not Assigned(ASource) then
    Exit;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TProfileFilter) then
    Exit;

  var src := TProfileFilter(ASource);

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

constructor TProfileFilter.Create;
begin
  inherited Create;

  FConditions := TConditionList.Create;
end;

constructor TProfileFilter.Create(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Create;

  Parse(src, APropertyNames);
end;

destructor TProfileFilter.Destroy;
begin
  FConditions.Free;

  inherited;
end;

procedure TProfileFilter.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
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

procedure TProfileFilter.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
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

{ TProfileFilterList }

function TProfileFilterList.GeTProfileFilter(Index: Integer): TProfileFilter;
begin
  Result := nil;

  if (Index < 0) or (Index >= Count) then
    Exit;

  if Items[Index] is TProfileFilter then
    Result := TProfileFilter(Items[Index]);
end;

class function TProfileFilterList.ItemClassType: TFieldSetClass;
begin
  Result := TProfileFilter;
end;

procedure TProfileFilterList.SeTProfileFilter(Index: Integer; const Value: TProfileFilter);
begin
  if (Index < 0) or (Index >= Count) then
    Exit;

  if not Assigned(Value) then
    Exit;

  if not (Value is TProfileFilter) then
    Exit;

  if Assigned(Items[Index]) then
    Items[Index].Free;

  Items[Index] := Value;
end;

{ TQueueFilter }

function TQueueFilter.Assign(ASource: TFieldSet): boolean;
begin
 Result := false;

  if not Assigned(ASource) then
    Exit;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TQueueFilter) then
    Exit;

  var src := TQueueFilter(ASource);

  FSig := src.Sig;

  FFilters.Clear;
  for var I := 0 to src.Filters.Count - 1 do
  begin
    var Filter := src.Filters[I];
    if not Assigned(Filter) then
      Continue;

    var NewFilter := TCondition.Create;
    if not NewFilter.Assign(Filter) then
    begin
      NewFilter.Free;
      Continue;
    end;

    FFilters.Add(NewFilter);
  end;

  Result := true;
end;

constructor TQueueFilter.Create;
begin
  FFilters := TConditionList.Create;
end;

constructor TQueueFilter.Create(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  Create;

  Parse(src, APropertyNames);
end;

destructor TQueueFilter.Destroy;
begin
  FFilters.Free;
  inherited;
end;

procedure TQueueFilter.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
var
  Value: TJSONValue;
begin
  FSig := '';
  FFilters.Clear;

  if not Assigned(src) then
    Exit;

  FSig := GetValueStrDef(src, 'sig', '');

  Value := src.FindValue('filter');
  if (Value is TJSONArray) then
    FFilters.ParseList(Value as TJSONArray);
end;


procedure TQueueFilter.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then
    Exit;

  dst.AddPair('sig', FSig);
  var f := FFilters.SerializeList;
  if Assigned(f) then
    dst.AddPair('filter', f)
  else
    dst.AddPair('filter', TJSONArray.Create);
end;


{ TQueueFilterList }

function TQueueFilterList.GeTQueueFilter(Index: Integer): TQueueFilter;
begin
  Result := nil;

  if (Index < 0) or (Index >= Count) then
    Exit;

  if Items[Index] is TQueueFilter then
    Result := TQueueFilter(Items[Index]);
end;

procedure TQueueFilterList.SetQueueFilter(Index: Integer;
  const Value: TQueueFilter);
begin
  if (Index < 0) or (Index >= Count) then
    Exit;

  if not Assigned(Value) then
    Exit;

  if not (Value is TQueueFilter) then
    Exit;

  if Assigned(Items[Index]) then
    Items[Index].Free;

  Items[Index] := Value;
end;

class function TQueueFilterList.ItemClassType: TFieldSetClass;
begin
  result := TQueueFilter;
end;



end.
