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

    function Post(AURL: string; const ASourceFile: TStream = nil): string;
    function Get(AURL: string): string;
    function Delete(AURL: string): string;
    function Put(AURL: string; const ASourceFile: TStream = nil): string;

  public
    constructor Create();
    destructor Destroy(); override;

  end;

/// ãëîáàëüíûå ôóíêöèè
function POST(AURL: string; const ASourceFile: TStream = nil): string;
function GET(AURL: string): string;
function PUT(AURL: string; const ASourceFile: TStream = nil): string;
function DELETE(AURL: string): string;

implementation

var
  ///  global cllass thhp client
  MainHttpModule: TMainHttpModule;

/// ãëîáàëüíàÿ ôóíêöèÿ POST
function POST(AURL: string; const ASourceFile: TStream = nil): string;
begin
  Result := MainHttpModule.Post(API_BASE_URL + AURL, ASourceFile);
end;

/// ãëîáàëüíàÿ ôóíêöèÿ POST
function GET(AURL: string): string;
begin
  Result := MainHttpModule.Get(API_BASE_URL + AURL);
end;

function PUT(AURL: string; const ASourceFile: TStream = nil): string;
begin
  Result := MainHttpModule.Put(AURL, ASourceFile);
end;

function DELETE(AURL: string): string;
begin
  Result := MainHttpModule.Delete(AURL);
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

function TMainHttpModule.Post(AURL: string; const ASourceFile: TStream = nil): string;
begin
  ///  åñëè ïàðàìåòðîâ íå ïåðåäàëè, òî çíà÷èò POST áåç òåëà
  if ASourceFile = nil then
    Result := FIdHTTP.Post(AURL, '')
  else
    Result := FIdHTTP.Post(AURL, ASourceFile);
end;

function TMainHttpModule.Get(AURL: string): string;
begin
  Result := FIdHTTP.Get(AURL);
end;

function TMainHttpModule.Put(AURL: string; const ASourceFile: TStream = nil): string;
begin
  ///  åñëè ïàðàìåòðîâ íå ïåðåäàëè, òî çíà÷èò POST áåç òåëà
    Result := FIdHTTP.Put(AURL, ASourceFile)
end;

function TMainHttpModule.Delete(AURL: string): string;
begin
  Result := FIdHTTP.Get(AURL);
end;

initialization
  ///  Create global cllass thhp client
  MainHttpModule:= TMainHttpModule.Create();

finalization
  MainHttpModule.Free;

end.
