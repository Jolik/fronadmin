unit ProfileRuleUnit;

interface

uses
  System.SysUtils, System.JSON, System.Generics.Collections,
  FuncUnit,
  EntityUnit,
  StringUnit,
  FilterUnit;

type
  /// <summary>
  ///   Represents a small-format routing rule.
  /// </summary>
  TProfileRule = class(TFieldSet)
  private
    FDoubles: Boolean;
    FPosition: Integer;
    FPriority: Integer;
    FHandlers: TFieldSetStringList;
    FBreakRule: Boolean;
    FChannels: TNamedStringListsObject;
    FIncFilters: TProfileFilterList;
    FExcFilters: TProfileFilterList;
    FEnabled: boolean;
    procedure ResetCollections;
  public
    constructor Create; overload; override;
    constructor Create(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Doubles: Boolean read FDoubles write FDoubles;
    property Position: Integer read FPosition write FPosition;
    property Priority: Integer read FPriority write FPriority;
    property Handlers: TFieldSetStringList read FHandlers;
    property BreakRule: Boolean read FBreakRule write FBreakRule;
    property Channels: TNamedStringListsObject read FChannels;
    property IncFilters: TProfileFilterList read FIncFilters;
    property ExcFilters: TProfileFilterList read FExcFilters;
    property Enabled: boolean read FEnabled write FEnabled;
  end;

implementation

const
  DoublesKey = 'doubles';
  PositionKey = 'position';
  PriorityKey = 'priority';
  HandlersKey = 'handlers';
  BreakKey = 'break';
  ChannelsKey = 'channels';
  IncFiltersKey = 'incFilters';
  ExcFiltersKey = 'excFilters';
  DisableKey = 'disable';

{ TProfileRule }

function TProfileRule.Assign(ASource: TFieldSet): boolean;
var
  SourceRule: TProfileRule;
begin
  Result := False;

  if not Assigned(ASource) then
    Exit;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TProfileRule) then
    Exit;

  SourceRule := TProfileRule(ASource);

  FDoubles := SourceRule.Doubles;
  FPosition := SourceRule.Position;
  FPriority := SourceRule.Priority;
  FBreakRule := SourceRule.BreakRule;
  FEnabled := SourceRule.Enabled;

  if not FHandlers.Assign(SourceRule.Handlers) then
    Exit;

  FChannels.Assign(SourceRule.Channels);

  FIncFilters.Clear;
  for var Index := 0 to SourceRule.IncFilters.Count - 1 do
  begin
    var Filter := TProfileFilter.Create;
    try
      if not Filter.Assign(SourceRule.IncFilters.Filters[Index]) then
      begin
        Filter.Free;
        Continue;
      end;
      FIncFilters.Add(Filter);
    except
      Filter.Free;
      raise;
    end;
  end;

  FExcFilters.Clear;
  for var Index := 0 to SourceRule.ExcFilters.Count - 1 do
  begin
    var Filter := TProfileFilter.Create;
    try
      if not Filter.Assign(SourceRule.ExcFilters.Filters[Index]) then
      begin
        Filter.Free;
        Continue;
      end;
      FExcFilters.Add(Filter);
    except
      Filter.Free;
      raise;
    end;
  end;

  Result := True;
end;

constructor TProfileRule.Create;
begin
  inherited Create;

  FHandlers := TFieldSetStringList.Create;
  FChannels := TNamedStringListsObject.Create;
  FIncFilters := TProfileFilterList.Create;
  FExcFilters := TProfileFilterList.Create;
  FEnabled := true;


  ResetCollections;
end;

constructor TProfileRule.Create(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Create;

  Parse(src, APropertyNames);
end;

destructor TProfileRule.Destroy;
begin
  FExcFilters.Free;
  FIncFilters.Free;
  FChannels.Free;
  FHandlers.Free;

  inherited;
end;

procedure TProfileRule.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  Value: TJSONValue;
begin
  FDoubles := False;
  FBreakRule := False;
  FPosition := 0;
  FPriority := 0;

  ResetCollections;

  if not Assigned(src) then
    Exit;

  FDoubles := GetValueBool(src, DoublesKey);
  FBreakRule := GetValueBool(src, BreakKey);
  FPosition := GetValueIntDef(src, PositionKey, 0);
  FPriority := GetValueIntDef(src, PriorityKey, 0);
  FEnabled := not GetValueBool(src, DisableKey);

  Value := src.FindValue(HandlersKey);
  if Value is TJSONArray then
    FHandlers.ParseList(TJSONArray(Value))
  else
    FHandlers.ClearStrings;

  Value := src.FindValue(ChannelsKey);
  if Value is TJSONObject then
    FChannels.Parse(TJSONObject(Value))
  else if Value is TJSONArray then
    FChannels.ParseList(TJSONArray(Value))
  else
    FChannels.Clear;

  Value := src.FindValue(IncFiltersKey);
  if Value is TJSONArray then
    FIncFilters.ParseList(TJSONArray(Value))
  else
    FIncFilters.Clear;

  Value := src.FindValue(ExcFiltersKey);
  if Value is TJSONArray then
    FExcFilters.ParseList(TJSONArray(Value))
  else
    FExcFilters.Clear;
end;

procedure TProfileRule.ResetCollections;
begin
  if Assigned(FHandlers) then
    FHandlers.ClearStrings;

  if Assigned(FChannels) then
    FChannels.Clear;

  if Assigned(FIncFilters) then
    FIncFilters.Clear;

  if Assigned(FExcFilters) then
    FExcFilters.Clear;
end;

procedure TProfileRule.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  HandlersArray: TJSONArray;
  ChannelsObject: TJSONObject;
  FilterArray: TJSONArray;
begin
  if not Assigned(dst) then
    Exit;

  dst.AddPair(DoublesKey, TJSONBool.Create(FDoubles));
  dst.AddPair(PositionKey, TJSONNumber.Create(FPosition));
  dst.AddPair(PriorityKey, TJSONNumber.Create(FPriority));
  dst.AddPair(BreakKey, TJSONBool.Create(FBreakRule));
  if not FEnabled then
    dst.AddPair(DisableKey, true);

  HandlersArray := TJSONArray.Create;
  try
    FHandlers.SerializeList(HandlersArray);
    dst.AddPair(HandlersKey, HandlersArray);
  except
    HandlersArray.Free;
    raise;
  end;

  ChannelsObject := TJSONObject.Create;
  try
    FChannels.Serialize(ChannelsObject);
    dst.AddPair(ChannelsKey, ChannelsObject);
  except
    ChannelsObject.Free;
    raise;
  end;

  FilterArray := FIncFilters.SerializeList;
  if Assigned(FilterArray) then
    dst.AddPair(IncFiltersKey, FilterArray)
  else
    dst.AddPair(IncFiltersKey, TJSONArray.Create);

  FilterArray := FExcFilters.SerializeList;
  if Assigned(FilterArray) then
    dst.AddPair(ExcFiltersKey, FilterArray)
  else
    dst.AddPair(ExcFiltersKey, TJSONArray.Create);
end;

end.
