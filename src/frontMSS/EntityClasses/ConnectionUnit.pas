unit ConnectionUnit;

interface
uses
  LoggingUnit,
  EntityUnit, System.Generics.Collections;

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
  TConnection = class(TEntity)
  private
    FAddr: string;
    FTimeout: integer;
    FDisabled: boolean;
    FSecure: TSecure;

  public
    function Assign(ASource: TFieldSet): boolean; override;

    property Addr: string read FAddr write FAddr;
    property Timeout: integer read FTimeout write FTimeout;
    property Secure: TSecure read FSecure write FSecure;

  end;

  ///  класс список соединений
  TConnectionList = class(TEntityList)
  private
    function GetConnection(Index: integer): TConnection;
    procedure SetConnection(Index: integer; const Value: TConnection);

  public
    function Assign(ASource: TEntityList): boolean; override;

    ///  список соединений
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
  Secure := src.Secure;

  Result := true;
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

    ///  если не удалось скопировать данные то пишем в лог
    if not c.Assign(Items[i]) then
    begin
      Log('TConnectionList.Assign: Error то assign', lrtError);
      exit;
    end;

    Add(c);
  end;

  Result := true;

end;

function TConnectionList.GetConnection(Index: integer): TConnection;
begin
  Result := nil;

  ///  обязательно проверяем соотвествие классов
  if Items[Index] is TConnection then
    Result := Items[Index] as TConnection;

end;

procedure TConnectionList.SetConnection(Index: integer;
  const Value: TConnection);
begin
  ///  обязательно проверяем соотвествие классов
  if not (Value is TConnection) then
    exit;

  ///  если в этой позиции есть объект - удаляем его
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
