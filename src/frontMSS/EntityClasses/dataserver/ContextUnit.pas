unit ContextUnit;

interface

uses
  System.JSON,
  EntityUnit;

type
  /// <summary>Context entity for dataserver sources.</summary>
  TContext = class(TFieldSet)
  private
    FCtxId: string;
    FCtxtid: string;
    FSid: string;
    FIndex: string;
    FData: TJSONObject;
    function GetCtxId: string;
    procedure SetCtxId(const Value: string);
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
  TContextList = class(TFieldSetList)
  protected
    class function ItemClassType: TFieldSetClass; override;
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
var
  Src: TContext;
begin
  if not Assigned(ASource) then
    Exit(False);

  if not (ASource is TContext) then
    Exit(inherited Assign(ASource));

  Result := inherited Assign(ASource);
  if not Result then
    Exit;

  Src := TContext(ASource);

  FCtxId := Src.CtxId;
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
  Result := FCtxId;
end;

procedure TContext.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  DataValue: TJSONValue;
begin
  FCtxId := '';
  FCtxtid := '';
  FSid := '';
  FIndex := '';

  FreeAndNil(FData);

  if not Assigned(src) then
  begin
    FData := TJSONObject.Create;
    Exit;
  end;

  FCtxId := GetValueStrDef(src, CtxIdKey, '');
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

  if not FCtxId.IsEmpty then
    dst.AddPair(CtxIdKey, FCtxId);
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
  FCtxId := Value;
end;

{ TContextList }

class function TContextList.ItemClassType: TFieldSetClass;
begin
  Result := TContext;
end;

end.
