unit ConnectionSettingsUnit;

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
  TConnectionSettings = class(TFieldSet)
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
  TConnectionSettingsList = class(TFieldSetList)
  private
    function GeTConnectionSettings(Index: integer): TConnectionSettings;
    procedure SeTConnectionSettings(Index: integer; const Value: TConnectionSettings);
  protected
    class function ItemClassType: TFieldSetClass; override;
  public
    ///  ������ ���������� (�������������� ������ � Items[])
    property Connections[Index : integer] : TConnectionSettings read GeTConnectionSettings write SeTConnectionSettings;
  end;


implementation

{ TConnectionSettings }

function TConnectionSettings.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;
  if not inherited Assign(ASource) then
    exit;
  if not (ASource is TConnectionSettings) then
    exit;
  var src := ASource as TConnectionSettings;
  Addr := src.Addr;
  Timeout := src.Timeout;
  Disabled := src.Disabled;
  Secure := src.Secure;
  Result := true;
end;

procedure TConnectionSettings.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
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

procedure TConnectionSettings.Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil);
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

{ TConnectionSettingsList }

function TConnectionSettingsList.GeTConnectionSettings(Index: integer): TConnectionSettings;
begin
  Result := nil;
  if Index >= Count then
    exit;
  ///  ����������� ��������� ����������� �������
  if Items[Index] is TConnectionSettings then
    Result := Items[Index] as TConnectionSettings;
end;

class function TConnectionSettingsList.ItemClassType: TFieldSetClass;
begin
  result := TConnectionSettings;
end;

procedure TConnectionSettingsList.SeTConnectionSettings(Index: integer;
  const Value: TConnectionSettings);
begin
  if Index >= Count then
    exit;
  ///  ����������� ��������� ����������� �������
  if not (Value is TConnectionSettings) then
    exit;
  ///  ���� � ���� ������� ���� ������ - ������� ���
  if Assigned(Items[Index]) then
    Items[Index].Free();
  Items[Index] := Value;
end;

end.
