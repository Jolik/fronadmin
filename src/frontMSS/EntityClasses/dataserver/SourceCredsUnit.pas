unit SourceCredsUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections, System.DateUtils,
  EntityUnit, FuncUnit;

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
  // TSourceCred .
  TSourceCred = class(TFieldSet)
  private
    FId: string;
    FName: string;
    FCompId: string;
    FCreated: TDateTime;
    FUpdated: TDateTime;
    FArchived: Nullable<TDateTime>;
    FCtxId: string;
    FLid: string;
    FLogin: string;
    FPass: Nullable<string>;
    FBody: TBody;
    FSourceData: TSourceCredData;
    function GetCrid: string;
    procedure SetCrid(const Value: string);
  public
    constructor Create; override;
    constructor Create(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    destructor Destroy; override;
    function Assign(ASource: TFieldSet): boolean; override;

    //      .   -
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    //
    property Id: string read FId write FId;
    property Crid: string read GetCrid write SetCrid;
    property Name: string read FName write FName;
    property CompId: string read FCompId write FCompId;
    property Created: TDateTime read FCreated write FCreated;
    property Updated: TDateTime read FUpdated write FUpdated;
    property Archived: Nullable<TDateTime> read FArchived write FArchived;
    property CtxId: string read FCtxId write FCtxId;
    property Lid: string read FLid write FLid;
    property Login: string read FLogin write FLogin;
    property Pass: Nullable<string> read FPass write FPass;
    property Body: TBody read FBody;
    ///    Data.Def
    property Data: TSourceCredData read FSourceData;
  end;

type
  ///
  TSourceCredsList = class(TFieldSetList)
    class function ItemClassType: TFieldSetClass; override;
  end;

implementation

uses
  System.SysUtils;

const
  CridKey = 'crid';
  CtxIdKey = 'ctxid';
  DataDefKey = 'def';
  LidKey = 'lid';
  LoginKey = 'login';
  PassKey = 'pass';
  NameKey = 'name';
  CompIdKey = 'compid';
  CreatedKey = 'created';
  UpdatedKey = 'updated';
  ArchivedKey = 'archived';
  BodyKey = 'body';
  DataKey = 'data';

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

{ TSourceCred }

function TSourceCred.Assign(ASource: TFieldSet): boolean;
var
  Src: TSourceCred;
begin
  Result := False;

  if not Assigned(ASource) then
    Exit;

  if not (ASource is TSourceCred) then
    Exit;

  Src := TSourceCred(ASource);

  FId := Src.Id;
  FName := Src.Name;
  FCompId := Src.CompId;
  FCreated := Src.Created;
  FUpdated := Src.Updated;
  FArchived := Src.Archived;

  FCtxId := Src.CtxId;
  FLid := Src.Lid;
  FLogin := Src.Login;
  FPass := Src.Pass;

  FBody.Assign(Src.Body);
  FSourceData.Assign(Src.Data);

  Result := True;
end;

constructor TSourceCred.Create;
begin
  inherited Create;
  FBody := TBody.Create;
  FSourceData := TSourceCredData.Create;
end;

constructor TSourceCred.Create(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Create;
  Parse(src, APropertyNames);
end;

destructor TSourceCred.Destroy;
begin
  FSourceData.Free;
  FBody.Free;
  inherited;
end;

function TSourceCred.GetCrid: string;
begin
  Result := FId;
end;

procedure TSourceCred.SetCrid(const Value: string);
begin
  FId := Value;
end;

procedure TSourceCred.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  BodyObj, DataObj: TJSONObject;
  CreatedValue, UpdatedValue: Int64;
  ArchivedValue: Nullable<Int64>;
begin
  if not Assigned(src) then
    Exit;

  FId := GetValueStrDef(src, CridKey, '');
  FName := GetValueStrDef(src, NameKey, '');
  FCompId := GetValueStrDef(src, CompIdKey, '');

  CreatedValue := GetValueInt64Def(src, CreatedKey, 0);
  UpdatedValue := GetValueInt64Def(src, UpdatedKey, 0);
  ArchivedValue := GetNullableInt64(src, ArchivedKey);

  if CreatedValue <> 0 then
    FCreated := UnixToDateTime(CreatedValue)
  else
    FCreated := 0;

  if UpdatedValue <> 0 then
    FUpdated := UnixToDateTime(UpdatedValue)
  else
    FUpdated := 0;

  FArchived.Clear;
  if ArchivedValue.HasValue then
    FArchived := Nullable<TDateTime>.Create(UnixToDateTime(ArchivedValue.Value));

  FCtxId := GetValueStrDef(src, CtxIdKey, '');
  FLid := GetValueStrDef(src, LidKey, '');
  FLogin := GetValueStrDef(src, LoginKey, '');
  FPass := GetNullableStr(src, PassKey);

  BodyObj := src.GetValue(BodyKey) as TJSONObject;
  if Assigned(BodyObj) then
    FBody.Parse(BodyObj);

  DataObj := src.GetValue(DataKey) as TJSONObject;
  if Assigned(DataObj) then
    FSourceData.Parse(DataObj);
end;

procedure TSourceCred.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  BodyObj, DataObj: TJSONObject;
begin
  if not Assigned(dst) then
    Exit;

  dst.AddPair(CridKey, FId);
  dst.AddPair(NameKey, FName);
  dst.AddPair(CompIdKey, FCompId);
  dst.AddPair(CreatedKey, TJSONNumber.Create(DateTimeToUnix(FCreated)));
  dst.AddPair(UpdatedKey, TJSONNumber.Create(DateTimeToUnix(FUpdated)));
  if FArchived.HasValue then
    dst.AddPair(ArchivedKey, TJSONNumber.Create(DateTimeToUnix(FArchived.Value)))
  else
    dst.AddPair(ArchivedKey, TJSONNull.Create);

  DataObj := FSourceData.Serialize;
  if Assigned(DataObj) then
    dst.AddPair(DataKey, DataObj);

  BodyObj := FBody.Serialize;
  if Assigned(BodyObj) then
    dst.AddPair(BodyKey, BodyObj);

  dst.AddPair(CtxIdKey, FCtxId);
  dst.AddPair(LidKey, FLid);
  dst.AddPair(LoginKey, FLogin);
  if FPass.HasValue then
    dst.AddPair(PassKey, FPass.Value)
  else
    dst.AddPair(PassKey, TJSONNull.Create);
end;

{ TSourceCredsList }

class function TSourceCredsList.ItemClassType: TFieldSetClass;
begin
  Result := TSourceCred;
end;

end.




