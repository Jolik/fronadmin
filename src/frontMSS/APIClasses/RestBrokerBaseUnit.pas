unit RestBrokerBaseUnit;

interface

uses
  HttpClientUnit,
  BaseRequests,
  BaseResponses,
  EntityUnit;

type
  // Base REST broker that operates on base request types
  TRestBrokerBase = class(TObject)
  private
    FTicket: string;
    procedure ApplyTicket(const Req: THttpRequest);
  public
    constructor Create(const ATicket: string = ''); virtual;
    property Ticket: string read FTicket write FTicket;

    // Фабрики базовых запросов (переопределяются в конкретных брокерах)
    function CreateReqList: TReqList; virtual;
    function CreateReqInfo: TReqInfo; virtual;
    function CreateReqNew: TReqNew; virtual;
    function CreateReqUpdate: TReqUpdate; virtual;
    function CreateReqRemove: TReqRemove; virtual;

    function ListRaw(AReq: TReqList): TJSONResponse;overload; virtual;
    function List(AReq: TReqList): TListResponse;overload; virtual;
    function List(AReq: TReqList;AResp: TListResponse): TListResponse;overload; virtual;
    // Унифицированный список c конкретным классом списка и ключом массива
    function List(AReq: TReqList; AListClass: TEntityListClass; const AItemsKey: string = 'items'): TListResponse;overload; virtual;
    // Вариант, принимающий любой THttpRequest, чтобы использовать существующие запросы
    function ListRaw2(AReq: THttpRequest; AListClass: TEntityListClass; const AItemsKey: string = 'items'): TListResponse; virtual;
    // Унифицированный info: парсит одну сущность указанного класса
    function Info(AReq: TReqInfo;AResp: TEntityResponse): TEntityResponse;overload; virtual;
    function Info(AReq: TReqInfo): TEntityResponse;overload; virtual;
    function InfoEntity(AReq: TReqInfo; AEntityClass: TEntityClass; const AItemKey: string = 'item'): TEntityResponse; virtual;
    function New(AReq: TReqNew): TJSONResponse;overload; virtual;
    function New(AReq: TReqNew;AResp: TFieldSetResponse): TFieldSetResponse;overload; virtual;
    function Update(AReq: TReqUpdate): TJSONResponse; virtual;
    function Remove(AReq: TReqRemove): TJSONResponse; virtual;
  end;

implementation

{ TRestBrokerBase }

procedure TRestBrokerBase.ApplyTicket(const Req: THttpRequest);
begin
  if Assigned(Req) and (FTicket <> '') then
    Req.Headers.AddOrSetValue('X-Ticket', FTicket);
end;

constructor TRestBrokerBase.Create(const ATicket: string);
begin
  inherited Create;
  FTicket := ATicket;
end;

function TRestBrokerBase.CreateReqInfo: TReqInfo;
begin
  Result := TReqInfo.Create;
end;

function TRestBrokerBase.CreateReqList: TReqList;
begin
  Result := TReqList.Create;
end;

function TRestBrokerBase.CreateReqNew: TReqNew;
begin
  Result := TReqNew.Create;
end;

function TRestBrokerBase.CreateReqRemove: TReqRemove;
begin
  Result := TReqRemove.Create;
end;

function TRestBrokerBase.CreateReqUpdate: TReqUpdate;
begin
  Result := TReqUpdate.Create;
end;

function TRestBrokerBase.List(AReq: TReqList;
  AResp: TListResponse): TListResponse;
begin
  Result:=AResp;
  ApplyTicket(AReq);
  HttpClient.Request(AReq, AResp);
end;

function TRestBrokerBase.ListRaw(AReq: TReqList): TJSONResponse;
begin
  Result := TJSONResponse.Create;
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

function TRestBrokerBase.List(AReq: TReqList; AListClass: TEntityListClass; const AItemsKey: string): TListResponse;
begin
  Result := TListResponse.Create(AListClass);
  ApplyTicket(AReq);
  Result.ItemsKey:= AItemsKey;
  // Передаём запрос в HttpClient; парсинг произойдёт в SetResponse
  HttpClient.Request(AReq, Result);
end;

function TRestBrokerBase.Info(AReq: TReqInfo;AResp: TEntityResponse): TEntityResponse;
begin
  Result:=AResp;
  ApplyTicket(AReq);
  HttpClient.Request(AReq, AResp);
end;

function TRestBrokerBase.Info(AReq: TReqInfo): TEntityResponse;
begin
  Result := TEntityResponse.Create();
  ApplyTicket(AReq);
  // Передаём запрос в HttpClient; парсинг произойдёт в SetResponse
  HttpClient.Request(AReq, Result);
end;

function TRestBrokerBase.InfoEntity(AReq: TReqInfo; AEntityClass: TEntityClass; const AItemKey: string): TEntityResponse;
begin
  Result := TEntityResponse.Create(AEntityClass, 'response', AItemKey);
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

function TRestBrokerBase.List(AReq: TReqList): TListResponse;
begin
  Result := TListResponse.Create(TEntityList, 'response', 'items');
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

function TRestBrokerBase.ListRaw2(AReq: THttpRequest; AListClass: TEntityListClass; const AItemsKey: string): TListResponse;
begin
  Result := TListResponse.Create(AListClass);
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

function TRestBrokerBase.New(AReq: TReqNew;
  AResp: TFieldSetResponse): TFieldSetResponse;
begin
  Result := AResp;
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result as TJSONResponse);
end;

function TRestBrokerBase.New(AReq: TReqNew): TJSONResponse;
begin
  Result := TJSONResponse.Create;
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

function TRestBrokerBase.Remove(AReq: TReqRemove): TJSONResponse;
begin
  Result := TJSONResponse.Create;
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

function TRestBrokerBase.Update(AReq: TReqUpdate): TJSONResponse;
begin
  Result := TJSONResponse.Create;
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

end.
