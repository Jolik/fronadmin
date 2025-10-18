unit CredUnit;

interface

uses
  System.SysUtils, System.JSON,
  EntityUnit;

type
  /// <summary>
  ///   Data section for dataserver credential.
  /// </summary>
  TCredData = class(TData)
  private
    FDef: string;
    FAdditional: TJSONObject;
  public
    constructor Create; overload; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Def: string read FDef write FDef;
    property Additional: TJSONObject read FAdditional;
  end;

  /// <summary>
  ///   Body section for dataserver credential.
  /// </summary>
  TCredBody = class(TBody)
  private
    FContent: TJSONObject;
  public
    constructor Create; overload; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Content: TJSONObject read FContent;
  end;

  /// <summary>
  ///   Dataserver credential entity.
  /// </summary>
  TCred = class(TEntity)
  private
    FCtxId: string;
    FLid: string;
    FLogin: string;
    FPass: string;
    function GetCrid: string;
    function GetCredBody: TCredBody;
    function GetCredData: TCredData;
    procedure SetCrid(const Value: string);
  protected
    function GetIdKey: string; override;
    class function DataClassType: TDataClass; override;
    class function BodyClassType: TBodyClass; override;
  public
    constructor Create; overload; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Crid: string read GetCrid write SetCrid;
    property CtxId: string read FCtxId write FCtxId;
    property Lid: string read FLid write FLid;
    property Login: string read FLogin write FLogin;
    property Pass: string read FPass write FPass;
    property CredData: TCredData read GetCredData;
    property CredBody: TCredBody read GetCredBody;
  end;

  /// <summary>
  ///   List of dataserver credentials.
  /// </summary>
  TCredList = class(TEntityList)
  protected
    class function ItemClassType: TEntityClass; override;
  end;

implementation

uses
  FuncUnit;

const
  CridKey = 'crid';
  CtxIdKey = 'ctxid';
  LidKey = 'lid';
  LoginKey = 'login';
  PassKey = 'pass';
  DataDefKey = 'def';

{ TCredData }

function TCredData.Assign(ASource: TFieldSet): boolean;
var
  SourceData: TCredData;
begin
  Result := False;

  if not Assigned(ASource) then
    Exit;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TCredData) then
    Exit;

  SourceData := TCredData(ASource);

  FDef := SourceData.Def;

  FreeAndNil(FAdditional);
  if Assigned(SourceData.FAdditional) then
  begin
    FAdditional := TJSONObject.Create;
    for var Pair in SourceData.FAdditional do
      FAdditional.AddPair(Pair.JsonString.Value, Pair.JsonValue.Clone as TJSONValue);
  end;

  Result := True;
end;

constructor TCredData.Create;
begin
  FAdditional := nil;
  inherited Create;
  FAdditional := TJSONObject.Create;
end;

destructor TCredData.Destroy;
begin
  FreeAndNil(FAdditional);
  inherited;
end;

procedure TCredData.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  FDef := '';
  FreeAndNil(FAdditional);

  if not Assigned(src) then
  begin
    FAdditional := TJSONObject.Create;
    Exit;
  end;

  FDef := GetValueStrDef(src, DataDefKey, '');

  for var Pair in src do
  begin
    var Key := Pair.JsonString.Value;
    if SameText(Key, DataDefKey) then
      Continue;

    if not Assigned(FAdditional) then
      FAdditional := TJSONObject.Create;

    FAdditional.AddPair(Key, Pair.JsonValue.Clone as TJSONValue);
  end;

  if not Assigned(FAdditional) then
    FAdditional := TJSONObject.Create;
end;

procedure TCredData.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then
    Exit;

  dst.AddPair(DataDefKey, FDef);

  if Assigned(FAdditional) then
    for var Pair in FAdditional do
      dst.AddPair(Pair.JsonString.Value, Pair.JsonValue.Clone as TJSONValue);
end;

{ TCredBody }

function TCredBody.Assign(ASource: TFieldSet): boolean;
var
  SourceBody: TCredBody;
begin
  Result := False;

  if not Assigned(ASource) then
    Exit;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TCredBody) then
    Exit;

  SourceBody := TCredBody(ASource);

  FreeAndNil(FContent);
  if Assigned(SourceBody.FContent) then
    FContent := SourceBody.FContent.Clone as TJSONObject
  else
    FContent := TJSONObject.Create;

  Result := True;
end;

constructor TCredBody.Create;
begin
  FContent := nil;
  inherited Create;
  FContent := TJSONObject.Create;
end;

destructor TCredBody.Destroy;
begin
  FreeAndNil(FContent);
  inherited;
end;

procedure TCredBody.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  FreeAndNil(FContent);

  if Assigned(src) then
    FContent := src.Clone as TJSONObject
  else
    FContent := TJSONObject.Create;
end;

procedure TCredBody.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then
    Exit;

  if not Assigned(FContent) then
    Exit;

  for var Pair in FContent do
    dst.AddPair(Pair.JsonString.Value, Pair.JsonValue.Clone as TJSONValue);
end;

{ TCred }

function TCred.Assign(ASource: TFieldSet): boolean;
var
  SourceCred: TCred;
begin
  Result := False;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TCred) then
    Exit;

  SourceCred := TCred(ASource);

  FCtxId := SourceCred.CtxId;
  FLid := SourceCred.Lid;
  FLogin := SourceCred.Login;
  FPass := SourceCred.Pass;

  Result := True;
end;

class function TCred.BodyClassType: TBodyClass;
begin
  Result := TCredBody;
end;

constructor TCred.Create;
begin
  inherited Create;
end;

destructor TCred.Destroy;
begin
  inherited;
end;

class function TCred.DataClassType: TDataClass;
begin
  Result := TCredData;
end;

function TCred.GetCrid: string;
begin
  Result := Id;
end;

function TCred.GetCredBody: TCredBody;
begin
  Result := Body as TCredBody;
end;

function TCred.GetCredData: TCredData;
begin
  Result := Data as TCredData;
end;

function TCred.GetIdKey: string;
begin
  Result := CridKey;
end;

procedure TCred.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Parse(src, APropertyNames);

  if not Assigned(src) then
  begin
    FCtxId := '';
    FLid := '';
    FLogin := '';
    FPass := '';
    Exit;
  end;

  FCtxId := GetValueStrDef(src, CtxIdKey, '');
  FLid := GetValueStrDef(src, LidKey, '');
  FLogin := GetValueStrDef(src, LoginKey, '');
  FPass := GetValueStrDef(src, PassKey, '');
end;

procedure TCred.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Serialize(dst, APropertyNames);

  dst.AddPair(CtxIdKey, FCtxId);
  dst.AddPair(LidKey, FLid);
  dst.AddPair(LoginKey, FLogin);
  dst.AddPair(PassKey, FPass);
end;

procedure TCred.SetCrid(const Value: string);
begin
  Id := Value;
end;

{ TCredList }

class function TCredList.ItemClassType: TEntityClass;
begin
  Result := TCred;
end;

end.

