unit HandlersRestBrokerUnit;

interface

uses
  RestBrokerBaseUnit,
  BaseRequests,
  BaseResponses,
  HandlerHttpRequests,
    RestEntityBrokerUnit,
  HttpClientUnit;

type
  THandlersRestBroker = class(TRestEntityBroker)
  public
    BasePath: string;
    constructor Create(const ATicket: string = ''); override;

    function List(AReq: THandlerReqList): THandlerListResponse; overload;
    function List(AReq: TReqList): TListResponse; overload; override;

    function Info(AReq: THandlerReqInfo): THandlerInfoResponse; overload;
    function Info(AReq: TReqInfo): TEntityResponse; overload; override;

    function New(AReq: THandlerReqNew): TJSONResponse; overload;
    function New(AReq: TReqNew; AResp: TEntityResponse): TEntityResponse; overload; override;

    function Update(AReq: THandlerReqUpdate): TJSONResponse; overload;
    function Update(AReq: TReqUpdate): TJSONResponse; overload; override;

    function Remove(AReq: THandlerReqRemove): TJSONResponse; overload;
    function Remove(AReq: TReqRemove): TJSONResponse; overload; override;

    function CreateReqList: TReqList; override;
    function CreateReqInfo(id:string=''): TReqInfo; override;
    function CreateReqNew: TReqNew; override;
    function CreateReqUpdate: TReqUpdate; override;
    function CreateReqRemove: TReqRemove; override;
  end;

implementation

uses APIConst;

{ THandlersRestBroker }

constructor THandlersRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  BasePath := constURLRouterBasePath;
end;

function THandlersRestBroker.List(AReq: TReqList): TListResponse;
begin
  Result := THandlerListResponse.Create;
  Result := inherited List(AReq, Result);
end;

function THandlersRestBroker.List(AReq: THandlerReqList): THandlerListResponse;
begin
  Result := List(AReq as TReqList) as THandlerListResponse;
end;

function THandlersRestBroker.New(AReq: TReqNew; AResp: TEntityResponse): TEntityResponse;
begin
  Result := inherited New(AReq, AResp);
end;

function THandlersRestBroker.New(AReq: THandlerReqNew): TJSONResponse;
begin
  Result := TJSONResponse.Create;
  HttpClient.Request(AReq, Result);
end;

function THandlersRestBroker.Remove(AReq: TReqRemove): TJSONResponse;
begin
  Result := inherited Remove(AReq);
end;

function THandlersRestBroker.Remove(AReq: THandlerReqRemove): TJSONResponse;
begin
  Result := Remove(AReq as TReqRemove);
end;

function THandlersRestBroker.Update(AReq: THandlerReqUpdate): TJSONResponse;
begin
  Result := Update(AReq as TReqUpdate);
end;

function THandlersRestBroker.CreateReqInfo(id:string=''): TReqInfo;
begin
  Result := THandlerReqInfo.CreateID(id);
  Result.BasePath := BasePath;
end;

function THandlersRestBroker.CreateReqList: TReqList;
begin
  Result := THandlerReqList.Create;
  Result.BasePath := BasePath;
end;

function THandlersRestBroker.CreateReqNew: TReqNew;
begin
  Result := THandlerReqNew.Create;
  Result.BasePath := BasePath;
end;

function THandlersRestBroker.CreateReqRemove: TReqRemove;
begin
  Result := THandlerReqRemove.Create;
  Result.BasePath := BasePath;
end;

function THandlersRestBroker.CreateReqUpdate: TReqUpdate;
begin
  Result := THandlerReqUpdate.Create;
  Result.BasePath := BasePath;
end;

function THandlersRestBroker.Info(AReq: THandlerReqInfo): THandlerInfoResponse;
begin
  Result := Info(AReq as TReqInfo) as THandlerInfoResponse;
end;

function THandlersRestBroker.Info(AReq: TReqInfo): TEntityResponse;
begin
  Result := THandlerInfoResponse.Create;
  inherited Info(AReq, Result);
end;

function THandlersRestBroker.Update(AReq: TReqUpdate): TJSONResponse;
begin
  Result := inherited Update(AReq);
end;

end.

