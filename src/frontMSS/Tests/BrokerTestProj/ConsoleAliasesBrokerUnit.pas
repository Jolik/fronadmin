unit ConsoleAliasesBrokerUnit;

interface

uses
  System.SysUtils,
  System.JSON,
  System.Generics.Collections,
  EntityUnit,
  AliasUnit,
  EntityBrokerUnit,
  HttpRequestUnit;

type
  TConsoleAliasesBroker = class(TEntityBroker)
  private
    FTransport: TBroker;
    FLastRequest: THttpRequest;
    FLastResponse: TJSONResponse;
    function BuildUrl(const APath: string): string;
    procedure PrepareDefaultHeaders(ARequest: THttpRequest);
    procedure UpdateLastExchange(ARequest: THttpRequest; AResponse: TJSONResponse);
  protected
    function GetBasePath: string; override;
    class function ClassType: TEntityClass; override;
    class function ListClassType: TEntityListClass; override;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    function List(
      out APageCount: Integer;
      const APage: Integer = 0;
      const APageSize: Integer = 50;
      const ASearchStr: String = '';
      const ASearchBy: String = '';
      const AOrder: String = 'name';
      const AOrderDir: String = 'asc'): TEntityList; override;

    function CreateNew(): TEntity; override;
    function New(AEntity: TEntity): boolean; override;
    function Info(AId: String): TEntity; overload; override;
    function Update(AEntity: TEntity): Boolean; override;
    function Remove(AId: String): Boolean; override;

    property LastRequest: THttpRequest read FLastRequest;
    property LastResponse: TJSONResponse read FLastResponse;
  end;

implementation

uses
  APIConst,
  FuncUnit;

const
  URLAliasesList = '/aliases/list';
  URLAliasesInfo = '/aliases/%s';

{ TConsoleAliasesBroker }

class function TConsoleAliasesBroker.ClassType: TEntityClass;
begin
  Result := TAlias;
end;

constructor TConsoleAliasesBroker.Create;
begin
  inherited Create;
  FTransport := TBroker.Create('http://dcc5.modext.ru', 8088);
end;

function TConsoleAliasesBroker.CreateNew: TEntity;
begin
  Result := ClassType.Create;
end;

destructor TConsoleAliasesBroker.Destroy;
begin
  FTransport.Free;
  FLastRequest.Free;
  FLastResponse.Free;
  inherited;
end;

function TConsoleAliasesBroker.BuildUrl(const APath: string): string;
begin
  if FTransport.Port = 0 then
    Result := FTransport.Addr + APath
  else
    Result := Format('%s:%d%s', [FTransport.Addr, FTransport.Port, APath]);
end;

function TConsoleAliasesBroker.GetBasePath: string;
begin
  Result := constURLRouterBasePath;
end;

function TConsoleAliasesBroker.Info(AId: String): TEntity;
var
  Request: THttpRequest;
  Response: TJSONResponse;
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  AliasValue: TJSONValue;
  URL: string;
begin
  Result := nil;
  if AId.IsEmpty then
    Exit;

  Request := THttpRequest.Create;
  Response := TJSONResponse.Create;
  JSONResult := nil;
  try
    PrepareDefaultHeaders(Request);
    URL := Format(GetBasePath + URLAliasesInfo, [AId]);
    Request.URL := BuildUrl(URL);
    Request.Method := mGET;

    FTransport.Request(Request, Response);

    UpdateLastExchange(Request, Response);
    Request := nil;
    Response := nil;

    JSONResult := TJSONObject.ParseJSONValue(LastResponse.Response) as TJSONObject;
    if not Assigned(JSONResult) then
      Exit;

    ResponseObject := JSONResult.GetValue('response') as TJSONObject;
    if not Assigned(ResponseObject) then
      Exit;

    AliasValue := ResponseObject.GetValue('alias');
    if AliasValue is TJSONObject then
      Result := ClassType.Create(TJSONObject(AliasValue));
  finally
    JSONResult.Free;
    Request.Free;
    Response.Free;
  end;
end;

function TConsoleAliasesBroker.List(out APageCount: Integer; const APage,
  APageSize: Integer; const ASearchStr, ASearchBy, AOrder,
  AOrderDir: String): TEntityList;
var
  Request: THttpRequest;
  Response: TJSONResponse;
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  InfoObject: TJSONObject;
  AliasesValue: TJSONValue;
  ItemsValue: TJSONValue;
  ItemsArray: TJSONArray;
  RequestObject: TJSONObject;
begin
  Result := nil;
  APageCount := 0;
  Request := THttpRequest.Create;
  Response := TJSONResponse.Create;
  JSONResult := nil;
  RequestObject := nil;
  try
    PrepareDefaultHeaders(Request);
    Request.URL := BuildUrl(GetBasePath + URLAliasesList);
    Request.Method := mPOST;

    RequestObject := TJSONObject.Create;
    RequestObject.AddPair('page', TJSONNumber.Create(APage));
    RequestObject.AddPair('pagesize', TJSONNumber.Create(APageSize));
    if not ASearchStr.IsEmpty then
      RequestObject.AddPair('searchStr', ASearchStr);
    if not ASearchBy.IsEmpty then
      RequestObject.AddPair('searchBy', ASearchBy);
    if not AOrder.IsEmpty then
      RequestObject.AddPair('order', AOrder);
    if not AOrderDir.IsEmpty then
      RequestObject.AddPair('orderDir', AOrderDir);
    Request.Body := TBody.Create;
    Request.Body.Content := RequestObject.ToJSON;

    Request.Headers.AddOrSetValue('Content-Type', 'application/json');

    FTransport.Request(Request, Response);

    UpdateLastExchange(Request, Response);
    Request := nil;
    Response := nil;

    JSONResult := TJSONObject.ParseJSONValue(LastResponse.Response) as TJSONObject;
    if not Assigned(JSONResult) then
      Exit;

    ResponseObject := JSONResult.GetValue('response') as TJSONObject;
    if not Assigned(ResponseObject) then
      Exit;

    InfoObject := ResponseObject.GetValue('info') as TJSONObject;
    if Assigned(InfoObject) then
      APageCount := GetValueIntDef(InfoObject, 'pagecount', 0);

    AliasesValue := ResponseObject.GetValue('aliases');
    ItemsArray := nil;

    if AliasesValue is TJSONArray then
      ItemsArray := TJSONArray(AliasesValue)
    else if AliasesValue is TJSONObject then
    begin
      ItemsValue := TJSONObject(AliasesValue).GetValue('items');
      if ItemsValue is TJSONArray then
        ItemsArray := TJSONArray(ItemsValue);
    end;

    if Assigned(ItemsArray) then
      Result := ListClassType.Create(ItemsArray);
  finally
    JSONResult.Free;
    RequestObject.Free;
    Request.Free;
    Response.Free;
  end;
end;

function TConsoleAliasesBroker.New(AEntity: TEntity): boolean;
begin
  raise Exception.Create('Method not supported in console broker.');
end;

procedure TConsoleAliasesBroker.PrepareDefaultHeaders(ARequest: THttpRequest);
begin
  ARequest.Headers.AddOrSetValue('Accept', 'application/json, text/plain, */*');
  ARequest.Headers.AddOrSetValue('User-Agent', 'BrokerTestProj/1.0');
  ARequest.Headers.AddOrSetValue('X-Ticket', 'ST-Test');
end;

procedure TConsoleAliasesBroker.UpdateLastExchange(ARequest: THttpRequest;
  AResponse: TJSONResponse);
begin
  FreeAndNil(FLastRequest);
  FreeAndNil(FLastResponse);
  FLastRequest := ARequest;
  FLastResponse := AResponse;
end;

function TConsoleAliasesBroker.Remove(AId: String): Boolean;
begin
  raise Exception.Create('Method not supported in console broker.');
end;

function TConsoleAliasesBroker.Update(AEntity: TEntity): Boolean;
begin
  raise Exception.Create('Method not supported in console broker.');
end;

end.

