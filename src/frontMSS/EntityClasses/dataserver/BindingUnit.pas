unit BindingUnit;

interface

uses
  System.JSON,
  EntityUnit;

type
  /// <summary>Additional data for a metadata binding.</summary>
  TBindingData = class(TData)
  private
    FDef: string;
    FAttr: TJSONObject;
  public
    constructor Create; overload; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): boolean; override;

    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Def: string read FDef write FDef;
    property Attr: TJSONObject read FAttr;
  end;

  /// <summary>Metadata binding entity.</summary>
  TBinding = class(TEntity)
  private
    FEntityId: string;
    FBindingType: string;
    FUrn: string;
    FIndex: string;
    function GetBid: string;
    function GetBindingData: TBindingData;
    procedure SetBid(const Value: string);
  protected
    function GetIdKey: string; override;
    class function DataClassType: TDataClass; override;
  public
    function Assign(ASource: TFieldSet): boolean; override;

    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Bid: string read GetBid write SetBid;
    property EntityId: string read FEntityId write FEntityId;
    property BindingType: string read FBindingType write FBindingType;
    property Urn: string read FUrn write FUrn;
    property Index: string read FIndex write FIndex;
    property BindingData: TBindingData read GetBindingData;
  end;

  /// <summary>Collection of metadata bindings.</summary>
  TBindingList = class(TEntityList)
  protected
    class function ItemClassType: TEntityClass; override;
  end;

implementation

uses
  System.SysUtils,
  FuncUnit;

const
  BidKey = 'bid';
  EntityKey = 'entity';
  TypeKey = 'type';
  UrnKey = 'urn';
  IndexKey = 'index';
  DataDefKey = 'def';
  DataAttrKey = 'attr';

{ TBindingData }

function TBindingData.Assign(ASource: TFieldSet): boolean;
var
  Src: TBindingData;
begin
  Result := false;

  if not Assigned(ASource) then
    Exit;

  if not (ASource is TBindingData) then
    Exit;

  Src := TBindingData(ASource);

  FDef := Src.Def;

  FreeAndNil(FAttr);
  if Assigned(Src.FAttr) then
    FAttr := Src.FAttr.Clone as TJSONObject
  else
    FAttr := TJSONObject.Create;

  Result := true;
end;

constructor TBindingData.Create;
begin
  inherited Create;
  FAttr := TJSONObject.Create;
end;

destructor TBindingData.Destroy;
begin
  FreeAndNil(FAttr);
  inherited;
end;

procedure TBindingData.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  AttrValue: TJSONValue;
begin
  FDef := '';

  FreeAndNil(FAttr);
  FAttr := TJSONObject.Create;

  if not Assigned(src) then
    Exit;

  FDef := GetValueStrDef(src, DataDefKey, '');

  AttrValue := src.FindValue(DataAttrKey);
  if AttrValue is TJSONObject then
  begin
    FreeAndNil(FAttr);
    FAttr := (AttrValue as TJSONObject).Clone as TJSONObject;
  end;
end;

procedure TBindingData.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  AttrClone: TJSONValue;
begin
  if not Assigned(dst) then
    Exit;

  dst.AddPair(DataDefKey, FDef);

  if Assigned(FAttr) then
    AttrClone := FAttr.Clone as TJSONValue
  else
    AttrClone := TJSONObject.Create;

  dst.AddPair(DataAttrKey, AttrClone);
end;

{ TBinding }

function TBinding.Assign(ASource: TFieldSet): boolean;
var
  Src: TBinding;
begin
  Result := false;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TBinding) then
    Exit;

  Src := TBinding(ASource);

  FEntityId := Src.EntityId;
  FBindingType := Src.BindingType;
  FUrn := Src.Urn;
  FIndex := Src.Index;

  Result := true;
end;

function TBinding.GetBid: string;
begin
  Result := Id;
end;

function TBinding.GetBindingData: TBindingData;
begin
  Result := Data as TBindingData;
end;

function TBinding.GetIdKey: string;
begin
  Result := BidKey;
end;

class function TBinding.DataClassType: TDataClass;
begin
  Result := TBindingData;
end;

procedure TBinding.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  FEntityId := '';
  FBindingType := '';
  FUrn := '';
  FIndex := '';

  BindingData.Parse(nil);

  inherited Parse(src, APropertyNames);

  if not Assigned(src) then
    Exit;

  FEntityId := GetValueStrDef(src, EntityKey, '');
  FBindingType := GetValueStrDef(src, TypeKey, '');
  FUrn := GetValueStrDef(src, UrnKey, '');
  FIndex := GetValueStrDef(src, IndexKey, '');
end;

procedure TBinding.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then
    Exit;

  inherited Serialize(dst, APropertyNames);

  dst.AddPair(EntityKey, FEntityId);
  dst.AddPair(TypeKey, FBindingType);
  dst.AddPair(UrnKey, FUrn);
  dst.AddPair(IndexKey, FIndex);
end;

procedure TBinding.SetBid(const Value: string);
begin
  Id := Value;
end;

{ TBindingList }

class function TBindingList.ItemClassType: TEntityClass;
begin
  Result := TBinding;
end;

end.

