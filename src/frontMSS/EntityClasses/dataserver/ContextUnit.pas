unit ContextUnit;

interface

uses
  System.JSON,
  EntityUnit;

type
  /// <summary>Context entity for dataserver sources.</summary>
  TContext = class(TEntity)
  private
    FCtxtid: string;
    FSid: string;
    FIndex: string;
    FData: TJSONObject;
    function GetCtxId: string;
    procedure SetCtxId(const Value: string);
  protected
    function GetIdKey: string; override;
  public
    constructor Create; overload; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property CtxId: string read GetCtxId write SetCtxId;
    property CtxtId: string read FCtxtid write FCtxtid;
    property Sid: string read FSid write FSid;
    property Index: string read FIndex write FIndex;
    property Data: TJSONObject read FData;
  end;

  /// <summary>Collection of contexts for dataserver sources.</summary>
  TContextList = class(TEntityList)
  protected
    class function ItemClassType: TEntityClass; override;
  end;

implementation

uses
  System.SysUtils,
  FuncUnit;

const
  CtxIdKey = 'ctxid';
  CtxtIdKey = 'ctxtid';
  SidKey = 'sid';
  IndexKey = 'index';
  DataKey = 'data';

{ TContext }

function TContext.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TContext) then
    Exit;

  var Src := TContext(ASource);

  FCtxtid := Src.CtxtId;
  FSid := Src.Sid;
  FIndex := Src.Index;

  FreeAndNil(FData);
  if Assigned(Src.Data) then
    FData := Src.Data.Clone as TJSONObject
  else
    FData := TJSONObject.Create;

  Result := true;
end;

constructor TContext.Create;
begin
  FData := nil;
  inherited Create;
  FData := TJSONObject.Create;
end;

destructor TContext.Destroy;
begin
  FreeAndNil(FData);
  inherited;
end;

function TContext.GetCtxId: string;
begin
  Result := Id;
end;

function TContext.GetIdKey: string;
begin
  Result := CtxIdKey;
end;

procedure TContext.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  DataValue: TJSONValue;
begin
  Id := '';
  FCtxtid := '';
  FSid := '';
  FIndex := '';

  FreeAndNil(FData);

  if not Assigned(src) then
  begin
    FData := TJSONObject.Create;
    Exit;
  end;

  Id := GetValueStrDef(src, GetIdKey, '');
  FCtxtid := GetValueStrDef(src, CtxtIdKey, '');
  FSid := GetValueStrDef(src, SidKey, '');
  FIndex := GetValueStrDef(src, IndexKey, '');

  DataValue := src.FindValue(DataKey);
  if DataValue is TJSONObject then
    FData := (DataValue as TJSONObject).Clone as TJSONObject
  else
    FData := TJSONObject.Create;
end;

procedure TContext.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  DataClone: TJSONValue;
begin
  if not Assigned(dst) then
    Exit;

  dst.AddPair(GetIdKey, Id);
  dst.AddPair(CtxtIdKey, FCtxtid);
  dst.AddPair(SidKey, FSid);
  dst.AddPair(IndexKey, FIndex);

  if Assigned(FData) then
    DataClone := FData.Clone as TJSONValue
  else
    DataClone := TJSONObject.Create;
  dst.AddPair(DataKey, DataClone);
end;

procedure TContext.SetCtxId(const Value: string);
begin
  Id := Value;
end;

{ TContextList }

class function TContextList.ItemClassType: TEntityClass;
begin
  Result := TContext;
end;

end.
