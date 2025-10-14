unit ConnectionUnit;

interface
uses
  System.Generics.Collections, System.JSON, SysUtils,
  FuncUnit,
  LoggingUnit,
  EntityUnit;

type

  TAuth = record
    Login: string;
    Password: string;
  end;

  TCertificates = record
    CRT: string;
    Key: string;
    CA: string;
  end;

  TTLS = record
    Enabled: boolean;
    Certificates: TCertificates;
  end;

  TSecure = record
    Auth: TAuth;
    TLS: TTLS;
  end;


  ///  ����� ���� ��������
  TConnection = class(TFieldSet)
  private
    FAddr: string;
    FTimeout: integer;
    FDisabled: boolean;
    FSecure: TSecure;

  public
    ///  ������������� ���� � ������� �������
    function Assign(ASource: TFieldSet): boolean; override;

    // ��� ������� ������������� ����������� ���������� �������. �� ������ - �������
    ///  � ������� const APropertyNames ���������� ����, ������� ���������� ������������
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Addr: string read FAddr write FAddr;
    property Timeout: integer read FTimeout write FTimeout;
    property Disabled: boolean read FDisabled write FDisabled;
    property Secure: TSecure read FSecure write FSecure;
  end;


  ///  ����� ������ ����������
  TConnectionList = class(TFieldSetList)
  private
    function GetConnection(Index: integer): TConnection;
    procedure SetConnection(Index: integer; const Value: TConnection);
  protected
    class function ItemClassType: TFieldSetClass; override;
  public
    ///  ������ ���������� (�������������� ������ � Items[])
    property Connections[Index : integer] : TConnection read GetConnection write SetConnection;
  end;


implementation

{ TConnection }

function TConnection.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;
  if not inherited Assign(ASource) then
    exit;
  if not (ASource is TConnection) then
    exit;
  var src := ASource as TConnection;
  Addr := src.Addr;
  Timeout := src.Timeout;
  Disabled := src.Disabled;
  Secure := src.Secure;
  Result := true;
end;

procedure TConnection.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Addr := GetValueStrDef(src, 'addr', '');
  Timeout := GetValueIntDef(src, 'timeout', 0);
  Disabled := GetValueBool(src, 'disabled');
  var s: TSecure;
  with s.tls.Certificates do
  begin
    CRT := GetValueStrDef(src, 'secure.tls.certificates.crt', '');
    Key := GetValueStrDef(src, 'secure.tls.certificates.key', '');
    CA := GetValueStrDef(src, 'secure.tls.certificates.ca', '');
  end;
  with s.tls do
  Enabled := GetValueBool(src, 'secure.tls.enabled');
  with s.Auth do
  begin
    Login := GetValueStrDef(src, 'secure.auth.login', '');
    Password := GetValueStrDef(src, 'secure.auth.password', '');
  end;
  Secure := s;
end;

procedure TConnection.Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil);
const
  connectionStr = '{"secure":{"auth":{},"tls":{"certificates":{}}}}';
begin
  dst.AddPair('addr', Addr);
  dst.AddPair('timeout', Timeout);
  dst.AddPair('disabled', Disabled);
  dst.Parse(TEncoding.UTF8.GetBytes(connectionStr),0);
  var s := dst.FindValue('secure.auth') as TJSONObject;
  s.AddPair('login', Secure.Auth.Login);
  s.AddPair('password', Secure.Auth.Password);
  var tls := dst.FindValue('secure.tls') as TJSONObject;
  tls.AddPair('enabled', Secure.TLS.Enabled);
  var certificates := dst.FindValue('secure.tls.certificates') as TJSONObject;
  certificates.AddPair('crt', Secure.TLS.Certificates.CRT);
  certificates.AddPair('key', Secure.TLS.Certificates.Key);
  certificates.AddPair('ca',  Secure.TLS.Certificates.CA);
end;

{ TConnectionList }

function TConnectionList.GetConnection(Index: integer): TConnection;
begin
  Result := nil;
  if Index >= Count then
    exit;
  ///  ����������� ��������� ����������� �������
  if Items[Index] is TConnection then
    Result := Items[Index] as TConnection;
end;

class function TConnectionList.ItemClassType: TFieldSetClass;
begin
  result := TConnection;
end;

procedure TConnectionList.SetConnection(Index: integer;
  const Value: TConnection);
begin
  if Index >= Count then
    exit;
  ///  ����������� ��������� ����������� �������
  if not (Value is TConnection) then
    exit;
  ///  ���� � ���� ������� ���� ������ - ������� ���
  if Assigned(Items[Index]) then
    Items[Index].Free();
  Items[Index] := Value;
end;

end.
