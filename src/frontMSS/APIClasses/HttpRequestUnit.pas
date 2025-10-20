unit HttpRequestUnit;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Data.DB;

type
  TMethod = (mGET, mPOST, mPUT, mDELETE);

  TBody = class(TFieldDef)
  private
    FContent: string;
  public
    constructor Create; reintroduce;
    property Content: string read FContent write FContent;
  end;

  THttpRequest = class
  private
    FURL: string;
    FMethod: TMethod;
    FHeaders: TDictionary<string, string>;
    FBody: TBody;
    procedure SetBody(const Value: TBody);
    function MethodToString: string;
  public
    constructor Create;
    destructor Destroy; override;
    function Curl: string;
    property URL: string read FURL write FURL;
    property Method: TMethod read FMethod write FMethod;
    property Headers: TDictionary<string, string> read FHeaders;
    property Body: TBody read FBody write SetBody;
  end;

  TJSONResponse = class
  private
    FResponse: string;
  public
    property Response: string read FResponse write FResponse;
  end;

  TBroker = class
  private
    FAddr: string;
    FPort: Word;
  public
    constructor Create(const AAddr: string; APort: Word);
    procedure Request(Req: THttpRequest; Res: TJSONResponse);
    property Addr: string read FAddr write FAddr;
    property Port: Word read FPort write FPort;
  end;

implementation

uses
  System.StrUtils,
  MainHttpModuleUnit;

{ TBody }

constructor TBody.Create;
begin
  inherited Create(nil);
  FContent := '';
end;

{ THttpRequest }

constructor THttpRequest.Create;
begin
  inherited Create;
  FHeaders := TDictionary<string, string>.Create;
  FMethod := mGET;
end;

destructor THttpRequest.Destroy;
begin
  FHeaders.Free;
  FBody.Free;
  inherited;
end;

function THttpRequest.MethodToString: string;
begin
  case FMethod of
    mGET: Result := 'GET';
    mPOST: Result := 'POST';
    mPUT: Result := 'PUT';
    mDELETE: Result := 'DELETE';
  else
    Result := 'GET';
  end;
end;

procedure THttpRequest.SetBody(const Value: TBody);
begin
  if FBody = Value then
    Exit;
  FBody.Free;
  FBody := Value;
end;

function THttpRequest.Curl: string;
var
  Header: TPair<string, string>;
  Builder: TStringBuilder;
  BodyText: string;
  Escaped: string;
begin
  Builder := TStringBuilder.Create;
  try
    Builder.Append('curl');
    if Method <> mGET then
      Builder.AppendFormat(' -X %s', [MethodToString]);

    Builder.AppendFormat(' "%s"', [FURL]);

    for Header in FHeaders do
      Builder.AppendFormat(' -H "%s: %s"', [Header.Key, Header.Value]);

    if Assigned(FBody) then
    begin
      BodyText := FBody.Content;
      if not BodyText.IsEmpty then
      begin
        Escaped := StringReplace(BodyText, '"', '\"', [rfReplaceAll]);
        Builder.AppendFormat(' -d "%s"', [Escaped]);
      end;
    end;

    Result := Builder.ToString;
  finally
    Builder.Free;
  end;
end;

{ TBroker }

constructor TBroker.Create(const AAddr: string; APort: Word);
begin
  inherited Create;
  FAddr := AAddr;
  FPort := APort;
end;

procedure TBroker.Request(Req: THttpRequest; Res: TJSONResponse);
var
  FullUrl: string;
  BodyStream: TStringStream;
  Content: string;
begin
  if (Req = nil) or (Res = nil) then
    raise EArgumentNilException.Create('Request and response must be assigned.');

  CONFIGUREHEADERS(Req.Headers);

  if StartsText('http://', Req.URL) then
    FullUrl := Req.URL
  else if FPort = 0 then
    FullUrl := FAddr + Req.URL
  else
    FullUrl := Format('%s:%d%s', [FAddr, FPort, Req.URL]);

  Content := '';
  if Assigned(Req.Body) then
    Content := Req.Body.Content;

  BodyStream := nil;
  if not Content.IsEmpty then
    BodyStream := TStringStream.Create(Content, TEncoding.UTF8);
  try
    case Req.Method of
      mGET:
        Res.Response := GET(FullUrl);
      mDELETE:
        Res.Response := DELETE(FullUrl);
      mPOST:
        Res.Response := POST(FullUrl, BodyStream);
      mPUT:
        Res.Response := PUT(FullUrl, BodyStream);
    else
      Res.Response := GET(FullUrl);
    end;
  finally
    BodyStream.Free;
  end;
end;

end.
