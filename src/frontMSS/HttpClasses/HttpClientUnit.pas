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

  THttpReqBody = class(TFieldSet)
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
    FParams: TDictionary<string, string>;
    FReqBody: TFieldSet;
    function GetCurl: string;
    procedure SetCurl(const Value: string);
    procedure SetMethodFromString(const Value: string);
    function GetReqBodyContent: string;
    procedure SetReqBodyContent(const Value: string);
    procedure SetURL(const Value: string);
    procedure ParseParamsFromQuery(const Query: string);
  protected
    class function BodyClassType: TFieldSetClass; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property URL: string read FURL write SetURL;
    property Method: TMethod read FMethod write FMethod;
    property Headers: TDictionary<string, string> read FHeaders;
    property Params: TDictionary<string, string> read FParams;
    property ReqBody: TFieldSet read FReqBody write FReqBody;
    property Curl: string read GetCurl write SetCurl;
    property ReqBodyContent: string read GetReqBodyContent write SetReqBodyContent;
    function GetURLWithParams(const BaseUrl: string = ''): string;
  end;

  TJSONResponse = class
  private
    FResponse: string;
  protected
    procedure SetResponse(const Value: string); virtual;
  public
    property Response: string read FResponse write SetResponse;
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
  System.Character,
  System.NetEncoding;

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
  FParams := TDictionary<string, string>.Create;
  FMethod := mGET;
  if BodyClassType <> nil then
    FReqBody := BodyClassType.Create
  else
    FReqBody := THttpReqBody.Create();
end;

destructor THttpRequest.Destroy;
begin
  FReqBody.Free;
  FHeaders.Free;
  FParams.Free;
  inherited;
end;

class function THttpRequest.BodyClassType: TFieldSetClass;
begin
  Result := THttpReqBody;
end;

function THttpRequest.GetReqBodyContent: string;
begin
  if not Assigned(FReqBody) then
    Exit('');

  if FReqBody is THttpReqBody then
    Result := THttpReqBody(FReqBody).RawContent
  else
    Result := FReqBody.JSON;
end;

function THttpRequest.GetCurl: string;
var
  Builder: TStringBuilder;
  HeaderPair: TPair<string, string>;
  ReqBodyString: string;
  EffectiveUrl: string;
begin
  Builder := TStringBuilder.Create;
  try
    Builder.Append('curl ');
    Builder.Append('--request ').Append(MethodToCurlOption(FMethod)).Append(' ');
    EffectiveUrl := GetURLWithParams;
    if not EffectiveUrl.IsEmpty then
      Builder.Append('''').Append(EffectiveUrl).Append('''');

    for HeaderPair in FHeaders do
    begin
      Builder.Append(' --header ');
      Builder.Append('''').Append(HeaderPair.Key).Append(': ').Append(HeaderPair.Value).Append('''');
    end;

    ReqBodyString := GetReqBodyContent;
    if not ReqBodyString.IsEmpty then
    begin
      Builder.Append(' --data-raw ');
      Builder.Append('''').Append(ReqBodyString).Append('''');
    end;

    Result := Builder.ToString.Trim;
  finally
    Builder.Free;
  end;
end;

procedure THttpRequest.SetReqBodyContent(const Value: string);
var
  JsonValue: TJSONObject;
begin
  if not Assigned(FReqBody) then
  begin
    if BodyClassType <> nil then
      FReqBody := BodyClassType.Create
    else
      FReqBody := THttpReqBody.Create;
  end;

  if FReqBody is THttpReqBody then
    THttpReqBody(FReqBody).RawContent := Value;

  if Value.IsEmpty then
    Exit;

  try
    JsonValue := TJSONObject.ParseJSONValue(Value) as TJSONObject;
    try
      if Assigned(JsonValue) then
        FReqBody.Parse(JsonValue);
    finally
      JsonValue.Free;
    end;
  except
    on E: Exception do
      raise EConvertError.CreateFmt('Failed to parse ReqBody JSON: %s', [E.Message]);
  end;
end;

procedure TJSONResponse.SetResponse(const Value: string);
begin
  FResponse := Value;
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
  FParams.Clear;
  FURL := '';
  SetReqBodyContent('');

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
          SetReqBodyContent(NormalizeToken(Tokens[I]));
          Inc(I);
        end;
        Continue;
      end
      else if Token = '\' then
      begin
        Inc(I);
        Continue;
      end
      else if Token.StartsWith('http://', True) or Token.StartsWith('https://', True) then
      begin
        SetURL(NormalizeToken(Token));
        Inc(I);
        Continue;
      end
      else
      begin
        if FURL.IsEmpty then
          SetURL(NormalizeToken(Token));
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

procedure THttpRequest.ParseParamsFromQuery(const Query: string);
var
  Parts: TArray<string>;
  Part: string;
  Key: string;
  Value: string;
  EqPos: Integer;
begin
  if Query.IsEmpty then
    Exit;

  Parts := Query.Split(['&']);
  for Part in Parts do
  begin
    if Part.IsEmpty then
      Continue;

    EqPos := Part.IndexOf('=');
    if EqPos > -1 then
    begin
      Key := Part.Substring(0, EqPos);
      Value := Part.Substring(EqPos + 1);
    end
    else
    begin
      Key := Part;
      Value := '';
    end;

    Key := TNetEncoding.URL.Decode(Key);
    Value := TNetEncoding.URL.Decode(Value);

    if not Key.IsEmpty then
      FParams.AddOrSetValue(Key, Value);
  end;
end;

function THttpRequest.GetURLWithParams(const BaseUrl: string): string;
var
  ResultUrl: string;
  Pair: TPair<string, string>;
  Separator: string;
begin
  if BaseUrl.IsEmpty then
    ResultUrl := FURL
  else
    ResultUrl := BaseUrl;

  if FParams.Count = 0 then
    Exit(ResultUrl);

  if ResultUrl.Contains('?') then
    Separator := '&'
  else
    Separator := '?';

  for Pair in FParams do
  begin
    ResultUrl := ResultUrl + Separator + TNetEncoding.URL.Encode(Pair.Key) + '=' + TNetEncoding.URL.Encode(Pair.Value);
    Separator := '&';
  end;

  Result := ResultUrl;
end;

procedure THttpRequest.SetURL(const Value: string);
var
  TrimmedValue: string;
  QueryPos: Integer;
  Query: string;
begin
  TrimmedValue := Value.Trim;
  FParams.Clear;

  if TrimmedValue.IsEmpty then
  begin
    FURL := '';
    Exit;
  end;

  QueryPos := TrimmedValue.IndexOf('?');
  if QueryPos > -1 then
  begin
    Query := TrimmedValue.Substring(QueryPos + 1);
    FURL := TrimmedValue.Substring(0, QueryPos);
    ParseParamsFromQuery(Query);
  end
  else
    FURL := TrimmedValue;
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
    Exit(Req.GetURLWithParams);

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

  Result := Req.GetURLWithParams(Result);
end;

function THttpBroker.Request(Req: THttpRequest; Res: TJSONResponse): Integer;
var
  Url: string;
  ReqBodyStream: TStringStream;
  ResponseContent: string;
  ReqBodyContent: string;
begin
  if not Assigned(Req) then
    raise EArgumentNilException.Create('Request must not be nil');
  if not Assigned(Res) then
    raise EArgumentNilException.Create('Response must not be nil');

  Url := BuildURL(Req);
  ApplyHeaders(Req);

  ReqBodyContent := Req.ReqBodyContent;

  case Req.Method of
    mGET:
      ResponseContent := FHttpClient.Get(Url);
    mPOST:
      begin
        ReqBodyStream := TStringStream.Create(ReqBodyContent, TEncoding.UTF8);
        try
          ResponseContent := FHttpClient.Post(Url, ReqBodyStream);
        finally
          ReqBodyStream.Free;
        end;
      end;
    mPUT:
      begin
        ReqBodyStream := TStringStream.Create(ReqBodyContent, TEncoding.UTF8);
        try
          ResponseContent := FHttpClient.Put(Url, ReqBodyStream);
        finally
          ReqBodyStream.Free;
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
