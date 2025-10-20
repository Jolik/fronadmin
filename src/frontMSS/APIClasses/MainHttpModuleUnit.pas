unit MainHttpModuleUnit;

interface

uses
  SysUtils, Classes, System.Generics.Collections,
  IdTCPConnection, IdTCPClient, IdHTTP,
  IdBaseComponent, IdComponent, IdIOHandler, IdIOHandlerSocket;

const
  API_BASE_URL = 'http://dcc5.modext.ru:8088';
  X_TICKET = 'ST-test';
  User_Agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 YaBrowser/25.8.0.0 Safari/537.36';

type
  TMainHttpModule = class(TObject)
    FIdHTTP: TIdHTTP;

  private
    procedure InitializeHTTPClient();
    function ResolveUrl(const AURL: string): string;

    function Post(AURL: string; const ASourceFile: TStream = nil): string;
    function Get(AURL: string): string;
    function Put(AURL: string; const ASourceFile: TStream = nil): string;
    function Delete(AURL: string): string;

  public
    constructor Create();
    destructor Destroy(); override;

    procedure ConfigureRequest(const Headers: TDictionary<string, string>);

  end;

function PUT(AURL: string; const ASourceFile: TStream = nil): string;
function DELETE(AURL: string): string;
procedure CONFIGUREHEADERS(const Headers: TDictionary<string, string>);
uses
  System.StrUtils;

  Result := MainHttpModule.Post(AURL, ASourceFile);
  Result := MainHttpModule.Get(AURL);
end;

function PUT(AURL: string; const ASourceFile: TStream = nil): string;
begin
  Result := MainHttpModule.Put(AURL, ASourceFile);
end;

function DELETE(AURL: string): string;
begin
  Result := MainHttpModule.Delete(AURL);
end;

procedure CONFIGUREHEADERS(const Headers: TDictionary<string, string>);
begin
  MainHttpModule.ConfigureRequest(Headers);
  FIdHTTP.Request.CharSet := 'utf-8';
  FIdHTTP.Request.UserAgent := User_Agent;
  FIdHTTP.Request.CustomHeaders.AddValue('X-Ticket', X_TICKET);

function TMainHttpModule.ResolveUrl(const AURL: string): string;
const
  HTTP_PREFIX = 'http://';
  HTTPS_PREFIX = 'https://';
begin
  if AURL.IsEmpty then
    Exit(API_BASE_URL);

  if StartsText(HTTPS_PREFIX, AURL) then
    raise EArgumentException.Create('HTTPS is not supported');

  if StartsText(HTTP_PREFIX, AURL) then
    Result := AURL
  else
    Result := API_BASE_URL + AURL;
end;

procedure TMainHttpModule.ConfigureRequest(const Headers: TDictionary<string, string>);
var
  Header: TPair<string, string>;
begin
  FIdHTTP.Request.ContentType := 'application/json';
  FIdHTTP.Request.ContentEncoding := 'utf-8';
  FIdHTTP.Request.CharSet := 'utf-8';
  FIdHTTP.Request.Accept := 'application/json, text/plain, */*';
  FIdHTTP.Request.UserAgent := User_Agent;

  FIdHTTP.Request.CustomHeaders.Clear;
  FIdHTTP.Request.CustomHeaders.AddValue('X-Ticket', X_TICKET);

  if Headers = nil then
    Exit;

  for Header in Headers do
  begin
    if SameText(Header.Key, 'Content-Type') then
      FIdHTTP.Request.ContentType := Header.Value
    else if SameText(Header.Key, 'Accept') then
      FIdHTTP.Request.Accept := Header.Value
    else if SameText(Header.Key, 'User-Agent') then
      FIdHTTP.Request.UserAgent := Header.Value
    else
      FIdHTTP.Request.CustomHeaders.Values[Header.Key] := Header.Value;
  end;
end;

    Result := FIdHTTP.Post(ResolveUrl(AURL), '')
    Result := FIdHTTP.Post(ResolveUrl(AURL), ASourceFile);
  Result := FIdHTTP.Get(ResolveUrl(AURL));
end;

function TMainHttpModule.Put(AURL: string; const ASourceFile: TStream = nil): string;
var
  EmptyStream: TStringStream;
begin
  if ASourceFile = nil then
  begin
    EmptyStream := TStringStream.Create('', TEncoding.UTF8);
    try
      Result := FIdHTTP.Put(ResolveUrl(AURL), EmptyStream);
    finally
      EmptyStream.Free;
    end;
  end
  else
    Result := FIdHTTP.Put(ResolveUrl(AURL), ASourceFile);
end;

function TMainHttpModule.Delete(AURL: string): string;
begin
  Result := FIdHTTP.Delete(ResolveUrl(AURL));

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

initialization
  ///  Create global cllass thhp client
  MainHttpModule:= TMainHttpModule.Create();

finalization
  MainHttpModule.Free;

end.

