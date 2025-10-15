unit SmallRuleUnit;

interface

uses
  System.SysUtils, System.JSON, System.Generics.Collections,
  FuncUnit,
  EntityUnit,
  StringUnit,
  FilterUnit;

type
  /// <summary>
  ///   Представляет правило маршрутизации небольшого формата.
  /// </summary>
  TSmallRule = class(TFieldSet)
  private
    FDoubles: Boolean;
    FPosition: Integer;
    FPriority: Integer;
    FHandlers: TStringList;
    FBreakRule: Boolean;
    FChannels: TStringListsObject;
    FIncFilters: TFilterList;
    FExcFilters: TFilterList;
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
    property Handlers: TStringList read FHandlers;
    property BreakRule: Boolean read FBreakRule write FBreakRule;
    property Channels: TStringListsObject read FChannels;
    property IncFilters: TFilterList read FIncFilters;
    property ExcFilters: TFilterList read FExcFilters;
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

{ TSmallRule }

function TSmallRule.Assign(ASource: TFieldSet): boolean;
var
  SourceRule: TSmallRule;
begin
  Result := False;

  if not Assigned(ASource) then
    Exit;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TSmallRule) then
    Exit;

  SourceRule := TSmallRule(ASource);

  FDoubles := SourceRule.Doubles;
  FPosition := SourceRule.Position;
  FPriority := SourceRule.Priority;
  FBreakRule := SourceRule.BreakRule;

  if not FHandlers.Assign(SourceRule.Handlers) then
    Exit;

  FChannels.Clear;
  for var Index := 0 to SourceRule.Channels.Count - 1 do
  begin
    var Channel := TStringList.Create;
    try
      if not Channel.Assign(SourceRule.Channels[Index]) then
      begin
        Channel.Free;
        Continue;
      end;
      FChannels.Add(Channel);
    except
      Channel.Free;
      raise;
    end;
  end;

  FIncFilters.Clear;
  for var Index := 0 to SourceRule.IncFilters.Count - 1 do
  begin
    var Filter := TFilter.Create;
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
    var Filter := TFilter.Create;
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

constructor TSmallRule.Create;
begin
  inherited Create;

  FHandlers := TStringList.Create;
  FHandlers.Name := HandlersKey;
  FChannels := TStringListsObject.Create;
  FIncFilters := TFilterList.Create;
  FExcFilters := TFilterList.Create;

  ResetCollections;
end;

constructor TSmallRule.Create(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Create;

  Parse(src, APropertyNames);
end;

destructor TSmallRule.Destroy;
begin
  FExcFilters.Free;
  FIncFilters.Free;
  FChannels.Free;
  FHandlers.Free;

  inherited;
end;

procedure TSmallRule.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
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

  Value := src.FindValue(HandlersKey);
  if Value is TJSONArray then
  begin
    FHandlers.Name := HandlersKey;
    FHandlers.Values.Clear;
    for var HandlerValue in TJSONArray(Value) do
    begin
      if HandlerValue is TJSONString then
        FHandlers.Values.Add(TJSONString(HandlerValue).Value)
      else if Assigned(HandlerValue) then
        FHandlers.Values.Add(HandlerValue.Value);
    end;
  end;

  Value := src.FindValue(ChannelsKey);
  if Value is TJSONObject then
  begin
    FChannels.Clear;
    for var Pair in TJSONObject(Value) do
    begin
      var Channel := TStringList.Create;
      try
        Channel.ParsePair(Pair);
        FChannels.Add(Channel);
      except
        Channel.Free;
        raise;
      end;
    end;
  end;

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

procedure TSmallRule.ResetCollections;
begin
  if Assigned(FHandlers) then
  begin
    FHandlers.Name := HandlersKey;
    FHandlers.Values.Clear;
  end;

  if Assigned(FChannels) then
    FChannels.Clear;

  if Assigned(FIncFilters) then
    FIncFilters.Clear;

  if Assigned(FExcFilters) then
    FExcFilters.Clear;
end;

procedure TSmallRule.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  HandlersArray: TJSONArray;
  ChannelsObject: TJSONObject;
  ValuesArray: TJSONArray;
  FilterArray: TJSONArray;
  ChannelList: TStringList;
begin
  if not Assigned(dst) then
    Exit;

  dst.AddPair(DoublesKey, TJSONBool.Create(FDoubles));
  dst.AddPair(PositionKey, TJSONNumber.Create(FPosition));
  dst.AddPair(PriorityKey, TJSONNumber.Create(FPriority));
  dst.AddPair(BreakKey, TJSONBool.Create(FBreakRule));

  HandlersArray := TJSONArray.Create;
  try
    for var Handler in FHandlers.Values do
      HandlersArray.Add(Handler);
    dst.AddPair(HandlersKey, HandlersArray);
  except
    HandlersArray.Free;
    raise;
  end;

  ChannelsObject := TJSONObject.Create;
  try
    for var Index := 0 to FChannels.Count - 1 do
    begin
      ChannelList := FChannels[Index];
      if not Assigned(ChannelList) then
        Continue;
      if ChannelList.Name = '' then
        Continue;

      ValuesArray := TJSONArray.Create;
      try
        for var Alias in ChannelList.Values do
          ValuesArray.Add(Alias);
        ChannelsObject.AddPair(ChannelList.Name, ValuesArray);
      except
        ValuesArray.Free;
        raise;
      end;
    end;
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
