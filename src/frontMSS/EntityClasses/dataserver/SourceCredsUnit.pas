unit SourceCredsUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  EntityUnit;

type
  // TSourceCreds .
  TSourceCreds = class (TEntity)
  private
    FCtxId: string;
    FLid: string;
    FLogin: string;
    FPass: string;
    function GetCrid: string;
    procedure SetCrid(const Value: string);
  protected
    ///
    function GetIdKey: string; override;
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
  LidKey = 'lid';
  LoginKey = 'login';
  PassKey = 'pass';

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

function TSourceCreds.GetIdKey: string;
begin
  Result := CridKey;
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
