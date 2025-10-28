unit AliasesRestBrokerUnit;

interface

uses
  RestBrokerBaseUnit,
  BaseRequests,
  BaseResponses,
  HttpClientUnit,
  AliasHttpRequests,
  AliasUnit,
  APIConst;

type
  TAliasesRestBroker = class(TRestBrokerBase)
  public
    // Базовый путь API (например, '/router/api/v2')
    BasePath: string;
    constructor Create(const ATicket: string = ''); override;

    // Типизированные обертки
    function List(AReq: TAliasReqList): TAliasListResponse; overload;
    function List(AReq: TReqList): TListResponse; overload; override;

    function Info(AReq: TAliasReqInfo): TAliasInfoResponse; overload;
    function Info(AReq: TReqInfo): TEntityResponse; overload; override;

    function New(AReq: TAliasReqNew): TAliasNewResponse; overload;
    function New(AReq: TReqNew; AResp: TFieldSetResponse): TFieldSetResponse; overload; override;

    function Update(AReq: TAliasReqUpdate): TJSONResponse; overload;
    function Update(AReq: TReqUpdate): TJSONResponse; overload; override;

    function Remove(AReq: TAliasReqRemove): TJSONResponse; overload;
    function Remove(AReq: TReqRemove): TJSONResponse; overload; override;

    // Фабрики запросов
    function CreateReqList: TReqList; override;
    function CreateReqInfo(id:string=''): TReqInfo; override;
    function CreateReqNew: TReqNew; override;
    function CreateReqUpdate: TReqUpdate; override;
    function CreateReqRemove: TReqRemove; override;
  end;

implementation

{ TAliasesRestBroker }

constructor TAliasesRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  // Задаём фиксированный базовый путь для маршрутизатора
  BasePath := constURLRouterBasePath;
end;

function TAliasesRestBroker.List(AReq: TReqList): TListResponse;
begin
  Result := TAliasListResponse.Create;
  Result := inherited List(AReq, Result);
end;

function TAliasesRestBroker.List(AReq: TAliasReqList): TAliasListResponse;
begin
  Result := List(AReq as TReqList) as TAliasListResponse;
end;

function TAliasesRestBroker.New(AReq: TReqNew; AResp: TFieldSetResponse): TFieldSetResponse;
begin
  Result := TAliasNewResponse.Create;
  Result := inherited New(AReq, Result);
end;

function TAliasesRestBroker.New(AReq: TAliasReqNew): TAliasNewResponse;
begin
  Result := TAliasNewResponse.Create;
  New(AReq, Result);
end;

function TAliasesRestBroker.Remove(AReq: TReqRemove): TJSONResponse;
begin
  Result := inherited Remove(AReq);
end;

function TAliasesRestBroker.Remove(AReq: TAliasReqRemove): TJSONResponse;
begin
  Result := Remove(AReq as TReqRemove);
end;

function TAliasesRestBroker.Update(AReq: TAliasReqUpdate): TJSONResponse;
begin
  Result := Update(AReq as TReqUpdate);
end;

function TAliasesRestBroker.CreateReqInfo(id:string=''): TReqInfo;
begin
  Result := TAliasReqInfo.CreateID(id);
  Result.BasePath := BasePath;
end;

function TAliasesRestBroker.CreateReqList: TReqList;
begin
  Result := TAliasReqList.Create;
  Result.BasePath := BasePath;
end;

function TAliasesRestBroker.CreateReqNew: TReqNew;
begin
  Result := TAliasReqNew.Create;
  Result.BasePath := BasePath;
end;

function TAliasesRestBroker.CreateReqRemove: TReqRemove;
begin
  Result := TAliasReqRemove.Create;
  Result.BasePath := BasePath;
end;

function TAliasesRestBroker.CreateReqUpdate: TReqUpdate;
begin
  Result := TAliasReqUpdate.Create;
  Result.BasePath := BasePath;
end;

function TAliasesRestBroker.Info(AReq: TAliasReqInfo): TAliasInfoResponse;
begin
  Result := Info(AReq as TReqInfo) as TAliasInfoResponse;
end;

function TAliasesRestBroker.Info(AReq: TReqInfo): TEntityResponse;
begin
  Result := TAliasInfoResponse.Create;
  inherited Info(AReq, Result);
end;

function TAliasesRestBroker.Update(AReq: TReqUpdate): TJSONResponse;
begin
  Result := inherited Update(AReq);
end;

end.
