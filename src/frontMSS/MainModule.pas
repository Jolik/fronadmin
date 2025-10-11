unit MainModule;

interface

uses
  uniGUIMainModule, SysUtils, Classes, IdTCPConnection, IdTCPClient, IdHTTP,
  IdBaseComponent, IdComponent, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdSSL, IdSSLOpenSSL;

const
  API_BASE_URL = 'http://dcc5.modext.ru:58140';
  X_TICKET = 'ST-test';
  User_Agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 YaBrowser/25.8.0.0 Safari/537.36';
const
  API_BASE_ROUTER_URL = '/router/api/v2';
  API_CHANNELS_URL = '/channels';

type
  TUniMainModule = class(TUniGUIMainModule)
    IdHTTP: TIdHTTP;
    SSL: TIdSSLIOHandlerSocketOpenSSL;
    procedure UniGUIMainModuleCreate(Sender: TObject);
  private
    FRequestStream: TStringStream;

    { Private declarations }
    procedure InitializeHTTPClient();

    function Post(AURL: string; const ASourceFile: TStream): string;
    function Get(AURL: string): string;

  public
    { Public declarations }
  end;

/// глобальные функции
function POST(AURL: string; const ASourceFile: TStream): string;
function GET(AURL: string): string;

function UniMainModule: TUniMainModule;

implementation

{$R *.dfm}

uses
  UniGUIVars, ServerModule, uniGUIApplication;

/// глобальная функция POST
function POST(AURL: string; const ASourceFile: TStream): string;
begin
  Result := UniMainModule.Post(API_BASE_URL + AURL, ASourceFile);
end;

/// глобальная функция POST
function GET(AURL: string): string;
begin
  Result := UniMainModule.Get(API_BASE_URL + AURL);
end;

procedure TUniMainModule.InitializeHTTPClient();
begin
  // Initialize HTTP client with SSL support
//  IdHTTP := TIdHTTP.Create(nil);
//  IdSSLIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);

  // Configure SSL
  SSL.SSLOptions.Method := sslvTLSv1_2;
  SSL.SSLOptions.Mode := sslmClient;

  // Set reasonable timeouts
  IdHTTP.IOHandler := SSL;

  IdHTTP.Request.ContentType := 'application/json';
  IdHTTP.Request.ContentEncoding := 'utf-8';
  IdHTTP.Request.Accept := 'application/json, text/plain, */*';

  IdHTTP.Request.CustomHeaders.Clear;
  IdHTTP.Request.CustomHeaders.AddValue('X-Ticket', 'ST-Test');

  IdHTTP.ConnectTimeout := 5000;
  IdHTTP.ReadTimeout := 10000;
end;

function UniMainModule: TUniMainModule;
begin
  Result := TUniMainModule(UniApplication.UniMainModule)
end;

function TUniMainModule.Post(AURL: string; const ASourceFile: TStream): string;
begin

  Result := IdHTTP.Post(AURL, ASourceFile);
end;

function TUniMainModule.Get(AURL: string): string;
begin
  Result := IdHTTP.Get(AURL);
end;

procedure TUniMainModule.UniGUIMainModuleCreate(Sender: TObject);
begin
  InitializeHTTPClient;
end;

initialization
  RegisterMainModuleClass(TUniMainModule);
end.
