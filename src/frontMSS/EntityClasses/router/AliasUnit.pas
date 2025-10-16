unit AliasUnit;

interface

uses
  System.JSON,
  EntityUnit,
  StringUnit;

type
  /// <summary>
  ///   Represents a router alias entity.
  /// </summary>
  TAlias = class(TEntity)
  private
    FChannels: TFieldSetStringListsObject;
    function GetAlid: string;
    procedure SetAlid(const Value: string);
  protected
    function GetIdKey: string; override;
  public
    constructor Create; overload; override;
    constructor Create(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): boolean; override;

    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Alid: string read GetAlid write SetAlid;
    property Channels: TFieldSetStringListsObject read FChannels;
  end;

  TAliasList = class(TEntityList)
  public
    class function ItemClassType: TEntityClass; override;
  end;

implementation

uses
  System.SysUtils;

const
  ChannelsKey = 'channels';

{ TAlias }

function TAlias.Assign(ASource: TFieldSet): boolean;
var
  SourceAlias: TAlias;
begin
  Result := False;

  if not Assigned(ASource) then
    Exit;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TAlias) then
    Exit;

  SourceAlias := TAlias(ASource);

  FChannels.Clear;
  for var Index := 0 to SourceAlias.Channels.Count - 1 do
  begin
    var Channel := TFieldSetStringList.Create;
    try
      if not Channel.Assign(SourceAlias.Channels[Index]) then
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

  Result := True;
end;

constructor TAlias.Create;
begin
  inherited Create;

  FChannels := TFieldSetStringListsObject.Create;
end;

constructor TAlias.Create(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Create;

  Parse(src, APropertyNames);
end;

destructor TAlias.Destroy;
begin
  FChannels.Free;

  inherited;
end;

function TAlias.GetAlid: string;
begin
  Result := Id;
end;

function TAlias.GetIdKey: string;
begin
  Result := 'alid';
end;

procedure TAlias.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  ChannelsValue: TJSONValue;
begin
  inherited Parse(src, APropertyNames);

  FChannels.Clear;

  if not Assigned(src) then
    Exit;

  ChannelsValue := src.FindValue(ChannelsKey);
  if ChannelsValue is TJSONObject then
  begin
    for var Pair in TJSONObject(ChannelsValue) do
    begin
      var Channel := TFieldSetStringList.Create;
      try
        Channel.ParsePair(Pair);
        FChannels.Add(Channel);
      except
        Channel.Free;
        raise;
      end;
    end;
  end;
end;

procedure TAlias.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  ChannelsObject: TJSONObject;
  ValuesArray: TJSONArray;
  ChannelList: TFieldSetStringList;
begin
  if not Assigned(dst) then
    Exit;

  inherited Serialize(dst, APropertyNames);

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
        for var AliasValue in ChannelList.Values do
          ValuesArray.Add(AliasValue);
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
end;

procedure TAlias.SetAlid(const Value: string);
begin
  Id := Value;
end;

{ TAliasList }

class function TAliasList.ItemClassType: TEntityClass;
begin
  Result := TAlias;
end;

end.
