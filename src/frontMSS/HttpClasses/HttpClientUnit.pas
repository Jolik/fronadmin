unit HttpClientUnit;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.StrUtils,
  System.JSON,
  EntityUnit,
  IdHTTP;

type
  TMethod = (mGET, mPOST, mPUT, mDELETE);

  THttpBody = class(TBody)
  private
    FRawContent: string;
  public
    property RawContent: string read FRawContent write FRawContent;
  end;

  THttpRequest = class
  private
    FURL: string;
    FMethod: TMethod;
    FHeaders: TDictionary<string, string>;
    FBody: TBody;
    function GetCurl: string;
    procedure SetCurl(const Value: string);
    procedure SetMethodFromString(const Value: string);
    function GetBodyContent: string;
    procedure SetBodyContent(const Value: string);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property URL: string read FURL write FURL;
    property Method: TMethod read FMethod write FMethod;
    property Headers: TDictionary<string, string> read FHeaders;
    property Body: TBody read FBody write FBody;
    property Curl: string read GetCurl write SetCurl;
    property BodyContent: string read GetBodyContent write SetBodyContent;
  end;

  TJSONResponse = class
  private
    FResponse: string;
  public
    property Response: string read FResponse write FResponse;
  end;

  THttpBroker = class
  private
    FAddr: string;
    FPort: Integer;
    FHttpClient: TIdHTTP;
    function BuildURL(const Req: THttpRequest): string;
    procedure ApplyHeaders(const Req: THttpRequest);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function Request(Req: THttpRequest; Res: TJSONResponse): Integer;
    property Addr: string read FAddr write FAddr;
    property Port: Integer read FPort write FPort;
  end;

var
  HttpClient: THttpBroker;

implementation

uses
  System.Character;

function MethodToCurlOption(const AMethod: TMethod): string;
begin
  case AMethod of
    mGET: Result := 'GET';
    mPOST: Result := 'POST';
    mPUT: Result := 'PUT';
    mDELETE: Result := 'DELETE';
  else
    Result := 'GET';
  end;
end;

{ THttpRequest }

constructor THttpRequest.Create;
begin
  inherited Create;
  FHeaders := TDictionary<string, string>.Create;
  FMethod := mGET;
  FBody := THttpBody.Create;
end;

destructor THttpRequest.Destroy;
begin
  FBody.Free;
  FHeaders.Free;
  inherited;
end;

function THttpRequest.GetBodyContent: string;
begin
  if not Assigned(FBody) then
    Exit('');

  if FBody is THttpBody then
    Result := THttpBody(FBody).RawContent
  else
    Result := FBody.JSON;
end;

function THttpRequest.GetCurl: string;
var
  Builder: TStringBuilder;
  HeaderPair: TPair<string, string>;
  BodyString: string;
begin
  Builder := TStringBuilder.Create;
  try
    Builder.Append('curl ');
    Builder.Append('--request ').Append(MethodToCurlOption(FMethod)).Append(' ');
    if not FURL.IsEmpty then
      Builder.Append('''').Append(FURL).Append('''');

    for HeaderPair in FHeaders do
    begin
      Builder.Append(' --header ');
      Builder.Append('''').Append(HeaderPair.Key).Append(': ').Append(HeaderPair.Value).Append('''');
    end;

    BodyString := GetBodyContent;
    if not BodyString.IsEmpty then
    begin
      Builder.Append(' --data-raw ');
      Builder.Append('''').Append(BodyString).Append('''');
    end;

    Result := Builder.ToString.Trim;
  finally
    Builder.Free;
  end;
end;

procedure THttpRequest.SetBodyContent(const Value: string);
var
  JsonValue: TJSONObject;
begin
  if not Assigned(FBody) then
    FBody := THttpBody.Create;

  if FBody is THttpBody then
    THttpBody(FBody).RawContent := Value
  else
  begin
    if Value.IsEmpty then
      Exit;

    try
      JsonValue := TJSONObject.ParseJSONValue(Value) as TJSONObject;
      try
        if Assigned(JsonValue) then
          FBody.Parse(JsonValue);
      finally
        JsonValue.Free;
      end;
    except
      on E: Exception do
        raise EConvertError.CreateFmt('Failed to parse body JSON: %s', [E.Message]);
    end;
  end;
end;

procedure THttpRequest.SetCurl(const Value: string);
var
  Tokens: TList<string>;
  Token: string;
  I: Integer;
  HeaderValue: string;
  ColonPos: Integer;
  HeaderName: string;
  HeaderContent: string;

  function NormalizeToken(const S: string): string;
  begin
    Result := S;
    if (Result.Length >= 2) and ((Result.StartsWith('"') and Result.EndsWith('"')) or
      (Result.StartsWith('''') and Result.EndsWith(''''))) then
      Result := Result.Substring(1, Result.Length - 2);
  end;

  procedure TokenizeCurl(const Input: string; const Output: TList<string>);
  var
    InQuotes: Boolean;
    QuoteChar: Char;
    Current: string;
    Ch: Char;
  begin
    InQuotes := False;
    QuoteChar := #0;
    Current := '';
    for Ch in Input do
    begin
      if InQuotes then
      begin
        if Ch = QuoteChar then
        begin
          InQuotes := False;
          Current := Current + Ch;
        end
        else
          Current := Current + Ch;
      end
      else
      begin
        if (Ch = '"') or (Ch = '''') then
        begin
          InQuotes := True;
          QuoteChar := Ch;
          Current := Current + Ch;
        end
        else if Ch.IsWhiteSpace then
        begin
          if not Current.IsEmpty then
          begin
            Output.Add(Current);
            Current := '';
          end;
        end
        else
          Current := Current + Ch;
      end;
    end;

    if not Current.IsEmpty then
      Output.Add(Current);
  end;

begin
  FHeaders.Clear;
  FMethod := mGET;
  FURL := '';
  SetBodyContent('');

  Tokens := TList<string>.Create;
  try
    TokenizeCurl(Value.Trim, Tokens);

    I := 0;
    while I < Tokens.Count do
    begin
      Token := Tokens[I];
      if SameText(Token, 'curl') then
      begin
        Inc(I);
        Continue;
      end
      else if SameText(Token, '--location') or SameText(Token, '-L') then
      begin
        Inc(I);
        Continue;
      end
      else if SameText(Token, '--request') or SameText(Token, '-X') then
      begin
        Inc(I);
        if I < Tokens.Count then
        begin
          SetMethodFromString(NormalizeToken(Tokens[I]));
          Inc(I);
        end;
        Continue;
      end
      else if SameText(Token, '--header') or SameText(Token, '-H') then
      begin
        Inc(I);
        if I < Tokens.Count then
        begin
          HeaderValue := NormalizeToken(Tokens[I]);
          ColonPos := HeaderValue.IndexOf(':');
          if ColonPos > -1 then
          begin
            HeaderName := HeaderValue.Substring(0, ColonPos).Trim;
            HeaderContent := HeaderValue.Substring(ColonPos + 1).Trim;
            FHeaders.AddOrSetValue(HeaderName, HeaderContent);
          end;
          Inc(I);
        end;
        Continue;
      end
      else if StartsText('--data', Token) then
      begin
        Inc(I);
        if I < Tokens.Count then
        begin
          SetBodyContent(NormalizeToken(Tokens[I]));
          Inc(I);
        end;
        Continue;
      end
      else if Token.StartsWith('http://', True) or Token.StartsWith('https://', True) then
      begin
        FURL := NormalizeToken(Token);
        Inc(I);
        Continue;
      end
      else
      begin
        if FURL.IsEmpty then
          FURL := NormalizeToken(Token);
        Inc(I);
      end;
    end;
  finally
    Tokens.Free;
  end;
end;

procedure THttpRequest.SetMethodFromString(const Value: string);
begin
  if SameText(Value, 'GET') then
    FMethod := mGET
  else if SameText(Value, 'POST') then
    FMethod := mPOST
  else if SameText(Value, 'PUT') then
    FMethod := mPUT
  else if SameText(Value, 'DELETE') then
    FMethod := mDELETE
  else
    FMethod := mGET;
end;

{ THttpBroker }

constructor THttpBroker.Create;
begin
  inherited Create;
  FHttpClient := TIdHTTP.Create(nil);
  FHttpClient.HandleRedirects := True;
end;

destructor THttpBroker.Destroy;
begin
  FHttpClient.Free;
  inherited;
end;

procedure THttpBroker.ApplyHeaders(const Req: THttpRequest);
var
  Pair: TPair<string, string>;
begin
  FHttpClient.Request.CustomHeaders.Clear;
  FHttpClient.Request.ContentType := '';
  FHttpClient.Request.Accept := '';
  FHttpClient.Request.UserAgent := '';
  for Pair in Req.Headers do
  begin
    if SameText(Pair.Key, 'Content-Type') then
      FHttpClient.Request.ContentType := Pair.Value
    else if SameText(Pair.Key, 'Accept') then
      FHttpClient.Request.Accept := Pair.Value
    else if SameText(Pair.Key, 'User-Agent') then
      FHttpClient.Request.UserAgent := Pair.Value
    else
      FHttpClient.Request.CustomHeaders.AddValue(Pair.Key, Pair.Value);
  end;
end;

function THttpBroker.BuildURL(const Req: THttpRequest): string;
var
  Path: string;
  Protocol: string;
begin
  if Req.URL.StartsWith('http://', True) or Req.URL.StartsWith('https://', True) then
    Exit(Req.URL);

  if FAddr.IsEmpty then
    raise EInvalidOpException.Create('Server address is not specified');

  Protocol := 'http://';
  if FPort = 443 then
    Protocol := 'https://';

  Path := Req.URL;
  if not Path.StartsWith('/') then
    Path := '/' + Path;

  if FPort > 0 then
    Result := Format('%s%s:%d%s', [Protocol, FAddr, FPort, Path])
  else
    Result := Format('%s%s%s', [Protocol, FAddr, Path]);
end;

function THttpBroker.Request(Req: THttpRequest; Res: TJSONResponse): Integer;
var
  Url: string;
  BodyStream: TStringStream;
  ResponseContent: string;
  BodyContent: string;
begin
  if not Assigned(Req) then
    raise EArgumentNilException.Create('Request must not be nil');
  if not Assigned(Res) then
    raise EArgumentNilException.Create('Response must not be nil');

  Url := BuildURL(Req);
  ApplyHeaders(Req);

  BodyContent := Req.BodyContent;

  case Req.Method of
    mGET:
      ResponseContent := FHttpClient.Get(Url);
    mPOST:
      begin
        BodyStream := TStringStream.Create(BodyContent, TEncoding.UTF8);
        try
          ResponseContent := FHttpClient.Post(Url, BodyStream);
        finally
          BodyStream.Free;
        end;
      end;
    mPUT:
      begin
        BodyStream := TStringStream.Create(BodyContent, TEncoding.UTF8);
        try
          ResponseContent := FHttpClient.Put(Url, BodyStream);
        finally
          BodyStream.Free;
        end;
      end;
    mDELETE:
      ResponseContent := FHttpClient.Delete(Url);
  else
    ResponseContent := FHttpClient.Get(Url);
  end;

  Res.Response := ResponseContent;
  Result := FHttpClient.ResponseCode;
end;

initialization
  HttpClient := THttpBroker.Create;

finalization
  HttpClient.Free;

end.

