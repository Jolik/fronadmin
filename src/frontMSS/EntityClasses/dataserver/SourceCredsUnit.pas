unit SourceCredsUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  EntityUnit;

type
  ///  data   creds
  TSourceCredData = class(TData)
  private
    FDef: string;
    FAdditional: TJSONObject;
  public
    destructor Destroy; override;
    function Assign(ASource: TFieldSet): boolean; override;

    //      .   -
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Def: string read FDef write FDef;
  end;

type
  // TSourceCreds .
  TSourceCreds = class (TEntity)
  private
    FCtxId: string;
    FLid: string;
    FLogin: string;
    FPass: string;
    function GetCrid: string;
    function GetSourceData: TSourceCredData;
    procedure SetCrid(const Value: string);
  protected
    ///
    function GetIdKey: string; override;
    ///       Data
    class function DataClassType: TDataClass; override;
  public
    function Assign(ASource: TFieldSet): boolean; override;

    //      .   -
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    //
    property Crid: string read GetCrid write SetCrid;
    property CtxId: string read FCtxId write FCtxId;
    property Lid: string read FLid write FLid;
    property Login: string read FLogin write FLogin;
    property Pass: string read FPass write FPass;
    ///    Data.Def
    property SourceData: TSourceCredData read GetSourceData;
  end;

type
  ///
  TSourceCredsList = class (TEntityList)
    ///
    ///     ,
    class function ItemClassType: TEntityClass; override;
  end;

implementation

uses
  System.SysUtils,
  FuncUnit;

const
  CridKey = 'crid';
  CtxIdKey = 'ctxid';
  DataDefKey = 'def';
  LidKey = 'lid';
  LoginKey = 'login';
  PassKey = 'pass';

{ TSourceCredData }

function TSourceCredData.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;

  if not Assigned(ASource) then
    exit;

  if not (ASource is TSourceCredData) then
    exit;

  var src := TSourceCredData(ASource);

  Def := src.Def;

  FreeAndNil(FAdditional);

  if Assigned(src.FAdditional) then
  begin
    FAdditional := TJSONObject.Create;

    for var Pair in src.FAdditional do
      FAdditional.AddPair(Pair.JsonString.Value, Pair.JsonValue.Clone as TJSONValue);
  end;

  Result := true;
end;

procedure TSourceCredData.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(src) then
    exit;

  Def := GetValueStrDef(src, DataDefKey, '');

  FreeAndNil(FAdditional);

  for var Pair in src do
  begin
    var Key := Pair.JsonString.Value;

    if SameText(Key, DataDefKey) then
      Continue;

    if not Assigned(FAdditional) then
      FAdditional := TJSONObject.Create;

    FAdditional.AddPair(Key, Pair.JsonValue.Clone as TJSONValue);
  end;
end;

procedure TSourceCredData.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then
    exit;

  dst.AddPair(DataDefKey, Def);

  if Assigned(FAdditional) then
    for var Pair in FAdditional do
      dst.AddPair(Pair.JsonString.Value, Pair.JsonValue.Clone as TJSONValue);
end;

destructor TSourceCredData.Destroy;
begin
  FreeAndNil(FAdditional);

  inherited;
end;

{ TSourceCreds }

function TSourceCreds.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;

  if not inherited Assign(ASource) then
    exit;

  if not (ASource is TSourceCreds) then
    exit;

  var src := ASource as TSourceCreds;

  CtxId := src.CtxId;
  Lid := src.Lid;
  Login := src.Login;
  Pass := src.Pass;

  Result := true;
end;

function TSourceCreds.GetCrid: string;
begin
  Result := Id;
end;

function TSourceCreds.GetSourceData: TSourceCredData;
begin
  Result := Data as TSourceCredData;
end;

function TSourceCreds.GetIdKey: string;
begin
  Result := CridKey;
end;

class function TSourceCreds.DataClassType: TDataClass;
begin
  Result := TSourceCredData;
end;

procedure TSourceCreds.SetCrid(const Value: string);
begin
  Id := Value;
end;

procedure TSourceCreds.Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil);
begin
  inherited Parse(src, APropertyNames);

  CtxId := GetValueStrDef(src, CtxIdKey, '');
  Lid := GetValueStrDef(src, LidKey, '');
  Login := GetValueStrDef(src, LoginKey, '');
  Pass := GetValueStrDef(src, PassKey, '');
end;

procedure TSourceCreds.Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil);
begin
  inherited Serialize(dst, APropertyNames);

  dst.AddPair(CtxIdKey, CtxId);
  dst.AddPair(LidKey, Lid);
  dst.AddPair(LoginKey, Login);
  dst.AddPair(PassKey, Pass);
end;

{ TSourceCredsList }

class function TSourceCredsList.ItemClassType: TEntityClass;
begin
  Result := TSourceCreds;
end;

end.
