unit AbonentUnit;

interface

uses
  System.SysUtils, System.JSON,
  EntityUnit,
  StringUnit;

type
  /// <summary>
  ///   Router abonent entity.
  /// </summary>
  TAbonent = class(TEntity)
  private
    FChannels: TFieldSetStringList;
    FAttr: TFieldSetStringListObject;
    function GetAbid: string;
    procedure SetAbid(const Value: string);
    procedure SetAttr(const Value: TFieldSetStringListObject);
  protected
    function GetIdKey: string; override;
  public
    constructor Create; overload; override;
    constructor Create(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): boolean; override;

    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Abid: string read GetAbid write SetAbid;
    property Channels: TFieldSetStringList read FChannels;
    property Attr: TFieldSetStringListObject read FAttr write SetAttr;
  end;

  /// <summary>
  ///   List of router abonents.
  /// </summary>
  TAbonentList = class(TEntityList)
  public
    class function ItemClassType: TEntityClass; override;
  end;

implementation

const
  ChannelsKey = 'channels';
  AttrKey = 'attr';

function TAbonent.Assign(ASource: TFieldSet): boolean;
var
  SourceAbonent: TAbonent;
begin
  Result := False;

  if not Assigned(ASource) then
    Exit;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TAbonent) then
    Exit;

  SourceAbonent := TAbonent(ASource);

  if Assigned(FChannels) then
    if not FChannels.Assign(SourceAbonent.Channels) then
      Exit;

  if Assigned(FAttr) then
    if not FAttr.Assign(SourceAbonent.Attr) then
      Exit;

  Result := True;
end;

constructor TAbonent.Create;
begin
  inherited Create;

  FChannels := TFieldSetStringList.Create;
  FAttr := TFieldSetStringListObject.Create;
end;

constructor TAbonent.Create(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Create;

  Parse(src, APropertyNames);
end;

function TAbonent.GetAbid: string;
begin
  Result := Id;
end;

function TAbonent.GetIdKey: string;
begin
  Result := 'abid';
end;

destructor TAbonent.Destroy;
begin
  FChannels.Free;
  FAttr.Free;

  inherited;
end;

procedure TAbonent.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  Value: TJSONValue;
begin
  inherited Parse(src, APropertyNames);

  if Assigned(FChannels) then
    FChannels.ClearStrings;

  if Assigned(FAttr) then
    FAttr.Clear;

  if not Assigned(src) then
    Exit;

  Value := src.FindValue(ChannelsKey);
  if Value is TJSONArray then
    FChannels.ParseList(TJSONArray(Value), APropertyNames)
  else if Assigned(FChannels) then
    FChannels.ClearStrings;

  Value := src.FindValue(AttrKey);
  if Value is TJSONObject then
    FAttr.Parse(TJSONObject(Value), APropertyNames)
  else if Assigned(FAttr) then
    FAttr.Clear;
end;

procedure TAbonent.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  ChannelsArray: TJSONArray;
  AttrObject: TJSONObject;
begin
  if not Assigned(dst) then
    Exit;

  inherited Serialize(dst, APropertyNames);

  ChannelsArray := TJSONArray.Create;
  try
    if Assigned(FChannels) then
      FChannels.SerializeList(ChannelsArray, APropertyNames);
    dst.AddPair(ChannelsKey, ChannelsArray);
  except
    ChannelsArray.Free;
    raise;
  end;

  AttrObject := TJSONObject.Create;
  try
    if Assigned(FAttr) then
      FAttr.Serialize(AttrObject, APropertyNames);
    dst.AddPair(AttrKey, AttrObject);
  except
    AttrObject.Free;
    raise;
  end;
end;

procedure TAbonent.SetAbid(const Value: string);
begin
  Id := Value;
end;

procedure TAbonent.SetAttr(const Value: TFieldSetStringListObject);
begin
  if not Assigned(FAttr) then
    FAttr := TFieldSetStringListObject.Create;

  if Assigned(Value) then
    FAttr.Assign(Value)
  else
    FAttr.Clear;
end;

class function TAbonentList.ItemClassType: TEntityClass;
begin
  Result := TAbonent;
end;

end.
