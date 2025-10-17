unit AbonentUnit;

interface

uses
  System.JSON,
  EntityUnit,
  StringUnit;

const
  ChannelsKey = 'channels';
  AttrKey = 'attr';

type
  /// <summary>
  ///   Represents a router abonent entity.
  /// </summary>
  TAbonent = class(TEntity)
  private
    FChannels: TFieldSetStringList;
    FAttr: TFieldSetStringList;
    function GetAid: string;
    procedure SetAid(const Value: string);
  protected
    function GetIdKey: string; override;
  public
    constructor Create; overload; override;
    constructor Create(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): Boolean; override;

    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Aid: string read GetAid write SetAid;
    property Channels: TFieldSetStringList read FChannels;
    property Attr: TFieldSetStringList read FAttr;
  end;

  TAbonentList = class(TEntityList)
  public
    class function ItemClassType: TEntityClass; override;
  end;

implementation

{ TAbonent }

function TAbonent.Assign(ASource: TFieldSet): Boolean;
var
  Source: TAbonent;
begin
  Result := False;

  if not Assigned(ASource) then
    Exit;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TAbonent) then
    Exit;

  Source := TAbonent(ASource);

  FChannels.Assign(Source.Channels);
  FAttr.Assign(Source.Attr);

  Result := True;
end;

constructor TAbonent.Create;
begin
  inherited Create;

  FChannels := TFieldSetStringList.Create;
  FAttr := TFieldSetStringList.Create;
end;

constructor TAbonent.Create(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Create;

  Parse(src, APropertyNames);
end;

destructor TAbonent.Destroy;
begin
  FChannels.Free;
  FAttr.Free;

  inherited;
end;

function TAbonent.GetAid: string;
begin
  Result := Id;
end;

function TAbonent.GetIdKey: string;
begin
  Result := 'aid';
end;

procedure TAbonent.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  ChannelsValue: TJSONValue;
  AttrValue: TJSONValue;
begin
  inherited Parse(src, APropertyNames);

  if not Assigned(src) then
    Exit;

  FChannels.Name := '';
  FChannels.Values.Clear;
  FAttr.Name := '';
  FAttr.Values.Clear;

  ChannelsValue := src.FindValue(ChannelsKey);
  if ChannelsValue is TJSONObject then
    FChannels.Parse(TJSONObject(ChannelsValue), APropertyNames);

  AttrValue := src.FindValue(AttrKey);
  if AttrValue is TJSONObject then
    FAttr.Parse(TJSONObject(AttrValue), APropertyNames);
end;

procedure TAbonent.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then
    Exit;

  inherited Serialize(dst, APropertyNames);

  dst.AddPair(ChannelsKey, FChannels.Serialize);
  dst.AddPair(AttrKey, FAttr.Serialize);
end;

procedure TAbonent.SetAid(const Value: string);
begin
  Id := Value;
end;

{ TAbonentList }

class function TAbonentList.ItemClassType: TEntityClass;
begin
  Result := TAbonent;
end;

end.

