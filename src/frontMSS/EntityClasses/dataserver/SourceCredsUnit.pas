unit SourceCredsUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections, System.DateUtils,
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
  TSourceCreds = class(TFieldSet)
  private
    FId: string;
    FName: string;
    FCompId: string;
    FCreated: TDateTime;
    FUpdated: TDateTime;
    FArchived: TDateTime;
    FCtxId: string;
    FLid: string;
    FLogin: string;
    FPass: string;
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
    property Archived: TDateTime read FArchived write FArchived;
    property CtxId: string read FCtxId write FCtxId;
    property Lid: string read FLid write FLid;
    property Login: string read FLogin write FLogin;
    property Pass: string read FPass write FPass;
    property Body: TBody read FBody;
    ///    Data.Def
    property SourceData: TSourceCredData read FSourceData;
  end;

type
  ///
  TSourceCredsList = class(TFieldSetList)
    class function ItemClassType: TFieldSetClass; override;
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

{ TSourceCreds }

function TSourceCreds.Assign(ASource: TFieldSet): boolean;
var
  Src: TSourceCreds;
begin
  Result := False;

  if not Assigned(ASource) then
    Exit;

  if not (ASource is TSourceCreds) then
    Exit;

  Src := TSourceCreds(ASource);

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
  FSourceData.Assign(Src.SourceData);

  Result := True;
end;

constructor TSourceCreds.Create;
begin
  inherited Create;
  FBody := TBody.Create;
  FSourceData := TSourceCredData.Create;
end;

constructor TSourceCreds.Create(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Create;
  Parse(src, APropertyNames);
end;

destructor TSourceCreds.Destroy;
begin
  FSourceData.Free;
  FBody.Free;
  inherited;
end;

function TSourceCreds.GetCrid: string;
begin
  Result := FId;
end;

procedure TSourceCreds.SetCrid(const Value: string);
begin
  FId := Value;
end;

procedure TSourceCreds.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  BodyObj, DataObj: TJSONObject;
  CreatedValue, UpdatedValue, ArchivedValue: Integer;
begin
  if not Assigned(src) then
    Exit;

  FId := GetValueStrDef(src, CridKey, '');
  FName := GetValueStrDef(src, NameKey, '');
  FCompId := GetValueStrDef(src, CompIdKey, '');

  CreatedValue := GetValueIntDef(src, CreatedKey, 0);
  UpdatedValue := GetValueIntDef(src, UpdatedKey, 0);
  ArchivedValue := GetValueIntDef(src, ArchivedKey, 0);

  if CreatedValue <> 0 then
    FCreated := UnixToDateTime(CreatedValue)
  else
    FCreated := 0;

  if UpdatedValue <> 0 then
    FUpdated := UnixToDateTime(UpdatedValue)
  else
    FUpdated := 0;

  if ArchivedValue <> 0 then
    FArchived := UnixToDateTime(ArchivedValue)
  else
    FArchived := 0;

  FCtxId := GetValueStrDef(src, CtxIdKey, '');
  FLid := GetValueStrDef(src, LidKey, '');
  FLogin := GetValueStrDef(src, LoginKey, '');
  FPass := GetValueStrDef(src, PassKey, '');

  BodyObj := src.GetValue(BodyKey) as TJSONObject;
  if Assigned(BodyObj) then
    FBody.Parse(BodyObj);

  DataObj := src.GetValue(DataKey) as TJSONObject;
  if Assigned(DataObj) then
    FSourceData.Parse(DataObj);
end;

procedure TSourceCreds.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
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
  dst.AddPair(ArchivedKey, TJSONNumber.Create(DateTimeToUnix(FArchived)));

  DataObj := FSourceData.Serialize;
  if Assigned(DataObj) then
    dst.AddPair(DataKey, DataObj);

  BodyObj := FBody.Serialize;
  if Assigned(BodyObj) then
    dst.AddPair(BodyKey, BodyObj);

  dst.AddPair(CtxIdKey, FCtxId);
  dst.AddPair(LidKey, FLid);
  dst.AddPair(LoginKey, FLogin);
  dst.AddPair(PassKey, FPass);
end;

{ TSourceCredsList }

class function TSourceCredsList.ItemClassType: TFieldSetClass;
begin
  Result := TSourceCreds;
end;

end.




