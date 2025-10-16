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
    FChannels: TFieldSetStringList;
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
    property Channels: TFieldSetStringList read FChannels;
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

  FChannels := TFieldSetStringList.Create;
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
  begin
    FChannels.Parse(ChannelsValue as TJSONObject, APropertyNames);
  end;
end;

procedure TAlias.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  ValuesArray: TJSONArray;
  ChannelList: TFieldSetStringList;
begin
  if not Assigned(dst) then
    Exit;

  inherited Serialize(dst, APropertyNames);

  dst.AddPair(ChannelsKey, FChannels.Serialize);

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
