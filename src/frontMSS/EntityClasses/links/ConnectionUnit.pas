unit ConnectionUnit;

interface
uses
  System.Generics.Collections, System.JSON,
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
  TConnection = class(TEntity)
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
    property Secure: TSecure read FSecure write FSecure;

  end;


  ///  ����� ������ ����������
  TConnectionList = class(TEntityList)
  private
    function GetConnection(Index: integer): TConnection;
    procedure SetConnection(Index: integer; const Value: TConnection);

  public
    function Assign(ASource: TEntityList): boolean; override;

    ///  ������ ���������� (�������������� ������ � Items[])
    property Connections[Index : integer] : TConnection read GetConnection write SetConnection;
  end;



implementation

const
  AddrKey = 'addr';

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
  Secure := src.Secure;

  Result := true;
end;

procedure TConnection.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Addr := GetValueStrDef(src, AddrKey, '');

end;

procedure TConnection.Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil);
begin
  with dst do
  begin
    AddPair(AddrKey, Id);
  end;
end;

{ TConnectionList }

function TConnectionList.Assign(ASource: TEntityList): boolean;
begin
  Result := false;

  if not (ASource is TConnectionList) then
    exit;

  for var i := 0 to ASource.Count-1 do
  begin
    var c := TConnection.Create;

    ///  ���� �� ������� ����������� ������ �� ����� � ���
    if not c.Assign(Items[i]) then
    begin
      Log('TConnectionList.Assign: Error �� assign', lrtError);
      exit;
    end;

    Add(c);
  end;

  Result := true;

end;

function TConnectionList.GetConnection(Index: integer): TConnection;
begin
  Result := nil;

  ///  ����������� ��������� ����������� �������
  if Items[Index] is TConnection then
    Result := Items[Index] as TConnection;

end;

procedure TConnectionList.SetConnection(Index: integer;
  const Value: TConnection);
begin
  ///  ����������� ��������� ����������� �������
  if not (Value is TConnection) then
    exit;

  ///  ���� � ���� ������� ���� ������ - ������� ���
  if Assigned(Items[Index]) then
  begin
    try
      Items[Index].Free();
    finally
      Items[Index] := nil;
    end;
  end;

  Items[Index] := Value;

end;

end.
