unit DsGroupUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  EntityUnit, DataserieUnit;

type
  ///  dataserver group entity
  TDsGroup = class(TEntity)
  private
    FPdsgid: string;
    FCtxid: string;
    FSid: string;
    FMetadata: TJSONObject;
    FDataseries: TDataseriesList;
    FDataseriesCount: Integer;
    function GetDsgid: string;
    procedure SetDsgid(const Value: string);
  protected
    function GetIdKey: string; override;
  public
    constructor Create; overload; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): boolean; override;

    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Dsgid: string read GetDsgid write SetDsgid;
    property Pdsgid: string read FPdsgid write FPdsgid;
    property Ctxid: string read FCtxid write FCtxid;
    property Sid: string read FSid write FSid;
    property Metadata: TJSONObject read FMetadata;
    property Dataseries: TDataseriesList read FDataseries;
    property DataseriesCount: Integer read FDataseriesCount write FDataseriesCount;
  end;

type
  /// list of dataserver groups
  TDsGroupList = class(TEntityList)
  public
    class function ItemClassType: TEntityClass; override;
  end;

implementation

uses
  System.SysUtils,
  FuncUnit;

const
  DsgidKey = 'dsgid';
  PdsgidKey = 'pdsgid';
  CtxidKey = 'ctxid';
  SidKey = 'sid';
  MetadataKey = 'metadata';
  DataseriesKey = 'dataseries';
  CountKey = 'count';
  ItemsKey = 'items';

{ TDsGroup }

function TDsGroup.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TDsGroup) then
    Exit;

  var Src := TDsGroup(ASource);

  FPdsgid := Src.Pdsgid;
  FCtxid := Src.Ctxid;
  FSid := Src.Sid;
  FDataseriesCount := Src.DataseriesCount;

  FreeAndNil(FMetadata);
  if Assigned(Src.Metadata) then
    FMetadata := Src.Metadata.Clone as TJSONObject
  else
    FMetadata := TJSONObject.Create;

  FDataseries.Clear;
  for var Entity in Src.Dataseries do
  begin
    var Item := TDataserie.Create;
    Item.Assign(Entity);
    FDataseries.Add(Item);
  end;

  Result := true;
end;

constructor TDsGroup.Create;
begin
  FMetadata := nil;
  FDataseries := nil;
  inherited Create;
  FMetadata := TJSONObject.Create;
  FDataseries := TDataseriesList.Create;
end;

destructor TDsGroup.Destroy;
begin
  FreeAndNil(FDataseries);
  FreeAndNil(FMetadata);
  inherited;
end;

function TDsGroup.GetDsgid: string;
begin
  Result := Id;
end;

function TDsGroup.GetIdKey: string;
begin
  Result := DsgidKey;
end;

procedure TDsGroup.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  MetadataValue: TJSONValue;
  DataseriesValue: TJSONValue;
  DataseriesObject: TJSONObject;
  ItemsValue: TJSONValue;
begin
  inherited Parse(src, APropertyNames);

  FPdsgid := GetValueStrDef(src, PdsgidKey, '');
  FCtxid := GetValueStrDef(src, CtxidKey, '');
  FSid := GetValueStrDef(src, SidKey, '');

  FreeAndNil(FMetadata);
  MetadataValue := src.FindValue(MetadataKey);
  if MetadataValue is TJSONObject then
    FMetadata := (MetadataValue as TJSONObject).Clone as TJSONObject
  else
    FMetadata := TJSONObject.Create;

  FDataseries.Clear;
  FDataseriesCount := 0;

  DataseriesValue := src.FindValue(DataseriesKey);
  if DataseriesValue is TJSONObject then
  begin
    DataseriesObject := DataseriesValue as TJSONObject;
    FDataseriesCount := GetValueIntDef(DataseriesObject, CountKey, 0);

    ItemsValue := DataseriesObject.GetValue(ItemsKey);
    if ItemsValue is TJSONArray then
      FDataseries.ParseList(ItemsValue as TJSONArray);
  end;
end;

procedure TDsGroup.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  MetadataClone: TJSONValue;
  DataseriesObject: TJSONObject;
  ItemsArray: TJSONArray;
begin
  inherited Serialize(dst, APropertyNames);

  dst.AddPair(PdsgidKey, FPdsgid);
  dst.AddPair(CtxidKey, FCtxid);
  dst.AddPair(SidKey, FSid);

  if Assigned(FMetadata) then
    MetadataClone := FMetadata.Clone as TJSONValue
  else
    MetadataClone := TJSONObject.Create;
  dst.AddPair(MetadataKey, MetadataClone);

  DataseriesObject := TJSONObject.Create;
  try
    DataseriesObject.AddPair(CountKey, FDataseriesCount);

    ItemsArray := FDataseries.SerializeList;
    if not Assigned(ItemsArray) then
      ItemsArray := TJSONArray.Create;
    DataseriesObject.AddPair(ItemsKey, ItemsArray);

    dst.AddPair(DataseriesKey, DataseriesObject);
  except
    DataseriesObject.Free;
    raise;
  end;
end;

procedure TDsGroup.SetDsgid(const Value: string);
begin
  Id := Value;
end;

{ TDsGroupList }

class function TDsGroupList.ItemClassType: TEntityClass;
begin
  Result := TDsGroup;
end;

end.

