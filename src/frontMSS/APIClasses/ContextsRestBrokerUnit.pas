unit ContextsRestBrokerUnit;

interface

uses
  RestBrokerBaseUnit, BaseRequests, BaseResponses, RestEntityBrokerUnit,
  ContextsHttpRequests, HttpClientUnit;

type
  TContextsRestBroker = class(TRestEntityBroker)
  public
    BasePath: string;
    constructor Create(const ATicket: string = ''); override;
    function List(AReq: TContextReqList): TContextListResponse; overload;
    function List(AReq: TReqList): TListResponse; overload; override;
    function Info(AReq: TContextReqInfo): TContextInfoResponse; overload;
    function Info(AReq: TReqInfo): TEntityResponse; overload; override;
    function New(AReq: TContextReqNew): TJSONResponse; overload;
    function New(AReq: TReqNew; AResp: TEntityResponse): TEntityResponse; overload; override;
    function Update(AReq: TContextReqUpdate): TJSONResponse; overload;
    function Update(AReq: TReqUpdate): TJSONResponse; overload; override;
    function Remove(AReq: TContextReqRemove): TJSONResponse; overload;
    function Remove(AReq: TReqRemove): TJSONResponse; overload; override;
    function CreateReqList: TReqList; override;
    function CreateReqInfo(id:string=''): TReqInfo; override;
    function CreateReqNew: TReqNew; override;
    function CreateReqUpdate: TReqUpdate; override;
    function CreateReqRemove: TReqRemove; override;
  end;

implementation

uses APIConst;

constructor TContextsRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  BasePath := constURLDataserverBasePath;
end;

function TContextsRestBroker.List(AReq: TReqList): TListResponse;
begin
  Result := TContextListResponse.Create;
  Result := inherited List(AReq, Result);
end;

function TContextsRestBroker.List(AReq: TContextReqList): TContextListResponse;
begin
  Result := List(AReq as TReqList) as TContextListResponse;
end;

function TContextsRestBroker.New(AReq: TReqNew; AResp: TEntityResponse): TEntityResponse;
begin
  Result := inherited New(AReq, AResp);
end;

function TContextsRestBroker.New(AReq: TContextReqNew): TJSONResponse;
begin
  Result := TJSONResponse.Create;
  HttpClient.Request(AReq, Result);
end;

function TContextsRestBroker.Remove(AReq: TReqRemove): TJSONResponse;
begin
  Result := inherited Remove(AReq);
end;

function TContextsRestBroker.Remove(AReq: TContextReqRemove): TJSONResponse;
begin
  Result := Remove(AReq as TReqRemove);
end;

function TContextsRestBroker.Update(AReq: TContextReqUpdate): TJSONResponse;
begin
  Result := Update(AReq as TReqUpdate);
end;

function TContextsRestBroker.CreateReqInfo(id:string=''): TReqInfo;
begin
  Result := TContextReqInfo.CreateID(id);
  Result.BasePath := BasePath;
end;

function TContextsRestBroker.CreateReqList: TReqList;
begin
  Result := TContextReqList.Create;
  Result.BasePath := BasePath;
end;

function TContextsRestBroker.CreateReqNew: TReqNew;
begin
  Result := TContextReqNew.Create;
  Result.BasePath := BasePath;
end;

function TContextsRestBroker.CreateReqRemove: TReqRemove;
begin
  Result := TContextReqRemove.Create;
  Result.BasePath := BasePath;
end;

function TContextsRestBroker.CreateReqUpdate: TReqUpdate;
begin
  Result := TContextReqUpdate.Create;
  Result.BasePath := BasePath;
end;

function TContextsRestBroker.Info(AReq: TReqInfo): TEntityResponse;
begin
  Result := TContextInfoResponse.Create;
  inherited Info(AReq, Result);
end;

function TContextsRestBroker.Info(AReq: TContextReqInfo): TContextInfoResponse;
begin
  Result := Info(AReq as TReqInfo) as TContextInfoResponse;
end;

function TContextsRestBroker.Update(AReq: TReqUpdate): TJSONResponse;
begin
  Result := inherited Update(AReq);
end;

end.
