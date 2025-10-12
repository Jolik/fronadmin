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


  ///  класс одно соединие
  TConnection = class(TFieldSet)
  private
    FAddr: string;
    FTimeout: integer;
    FDisabled: boolean;
    FSecure: TSecure;

  public
    ///  устанавливаем пол€ с другого объекта
    function Assign(ASource: TFieldSet): boolean; override;

    // эти требуют существующего правильного экземпл€ра объекта. на ошибки - эксешан
    ///  в массиве const APropertyNames передаютс€ пол€, которые необходимо использовать
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Addr: string read FAddr write FAddr;
    property Timeout: integer read FTimeout write FTimeout;
    property Secure: TSecure read FSecure write FSecure;

  end;


  ///  класс список соединений
  TConnectionList = class(TFieldSetList)
  private
    function GetConnection(Index: integer): TConnection;
    procedure SetConnection(Index: integer; const Value: TConnection);

  public
    ///  список соединений (переопредел€ет доступ к Items[])
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
    AddPair(AddrKey, Addr);
  end;
end;

{ TConnectionList }

function TConnectionList.GetConnection(Index: integer): TConnection;
begin
  Result := nil;

  ///  об€зательно провер€ем соотвествие классов
  if Items[Index] is TConnection then
    Result := Items[Index] as TConnection;

end;

procedure TConnectionList.SetConnection(Index: integer;
  const Value: TConnection);
begin
  ///  об€зательно провер€ем соотвествие классов
  if not (Value is TConnection) then
    exit;

  ///  если в этой позиции есть объект - удал€ем его
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
