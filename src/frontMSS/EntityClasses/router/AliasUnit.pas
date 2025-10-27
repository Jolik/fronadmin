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
    FChannels: TNamedStringListsObject;
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
    property Channels: TNamedStringListsObject read FChannels;
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

  FChannels.Assign(SourceAlias.Channels);

  Result := True;
end;

constructor TAlias.Create;
begin
  inherited Create;

  FChannels := TNamedStringListsObject.Create;
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

  if not Assigned(src) then
    Exit;

  ChannelsValue := src.FindValue(ChannelsKey);
  if ChannelsValue is TJSONObject then
    FChannels.Parse(TJSONObject(ChannelsValue), APropertyNames)
  else if ChannelsValue is TJSONArray then
    FChannels.ParseList(TJSONArray(ChannelsValue), APropertyNames)
  else
    FChannels.Clear;
end;

procedure TAlias.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  ChannelsObject: TJSONObject;
begin
  if not Assigned(dst) then
    Exit;

  inherited Serialize(dst, APropertyNames);

  ChannelsObject := TJSONObject.Create;
  try
    FChannels.Serialize(ChannelsObject, APropertyNames);
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
