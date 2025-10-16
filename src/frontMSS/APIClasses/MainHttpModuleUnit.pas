unit MainHttpModuleUnit;

interface

uses
  SysUtils, Classes, IdTCPConnection, IdTCPClient, IdHTTP,
  IdBaseComponent, IdComponent, IdIOHandler, IdIOHandlerSocket;

const
  API_BASE_URL = 'http://dcc5.modext.ru:8088';
  X_TICKET = 'ST-test';
  User_Agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 YaBrowser/25.8.0.0 Safari/537.36';

type
  TMainHttpModule = class(TObject)
    FIdHTTP: TIdHTTP;

  private
    FRequestStream: TStringStream;

    procedure InitializeHTTPClient();

    function Post(AURL: string; const ASourceFile: TStream): string;
    function Get(AURL: string): string;

  public
    constructor Create();
    destructor Destroy(); override;

  end;

/// глобальные функции
function POST(AURL: string; const ASourceFile: TStream): string;
function GET(AURL: string): string;

implementation

var
  ///  global cllass thhp client
  MainHttpModule: TMainHttpModule;

/// глобальная функция POST
function POST(AURL: string; const ASourceFile: TStream): string;
begin
  Result := MainHttpModule.Post(API_BASE_URL + AURL, ASourceFile);
end;

/// глобальная функция POST
function GET(AURL: string): string;
begin
  Result := MainHttpModule.Get(API_BASE_URL + AURL);
end;

procedure TMainHttpModule.InitializeHTTPClient();
begin
  FIdHttp := TIdHTTP.Create(nil);

  FIdHTTP.Request.ContentType := 'application/json';
  FIdHTTP.Request.ContentEncoding := 'utf-8';
  FIdHTTP.Request.Accept := 'application/json, text/plain, */*';

  FIdHTTP.Request.CustomHeaders.Clear;
  FIdHTTP.Request.CustomHeaders.AddValue('X-Ticket', 'ST-Test');

  FIdHTTP.ConnectTimeout := 5000;
  FIdHTTP.ReadTimeout := 10000;
end;

constructor TMainHttpModule.Create;
begin
  inherited Create();

  InitializeHTTPClient;

end;

destructor TMainHttpModule.Destroy;
begin
  FreeAndNil(FIdHTTP);

  inherited;
end;

function TMainHttpModule.Post(AURL: string; const ASourceFile: TStream): string;
begin
  Result := FIdHTTP.Post(AURL, ASourceFile);
end;

function TMainHttpModule.Get(AURL: string): string;
begin
  Result := FIdHTTP.Get(AURL);
end;

initialization
  ///  Create global cllass thhp client
  MainHttpModule:= TMainHttpModule.Create();

finalization
  MainHttpModule.Free;

end.

