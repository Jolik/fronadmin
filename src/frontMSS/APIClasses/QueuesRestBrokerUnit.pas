unit QueuesRestBrokerUnit;

interface

uses
  RestBrokerBaseUnit, BaseRequests, BaseResponses,     RestEntityBrokerUnit,
  QueueHttpRequests, HttpClientUnit;

type
  TQueuesRestBroker = class(TRestEntityBroker)
  public
    BasePath: string;
    constructor Create(const ATicket: string = ''); override;
    function List(AReq: TQueueReqList): TQueueListResponse; overload;
    function List(AReq: TReqList): TListResponse; overload; override;
    function Info(AReq: TQueueReqInfo): TQueueInfoResponse; overload;
    function Info(AReq: TReqInfo): TEntityResponse; overload; override;
    function New(AReq: TQueueReqNew): TJSONResponse; overload;
    function New(AReq: TReqNew; AResp: TEntityResponse): TEntityResponse; overload; override;
    function Update(AReq: TQueueReqUpdate): TJSONResponse; overload;
    function Update(AReq: TReqUpdate): TJSONResponse; overload; override;
    function Remove(AReq: TQueueReqRemove): TJSONResponse; overload;
    function Remove(AReq: TReqRemove): TJSONResponse; overload; override;
    function CreateReqList: TReqList; override;
    function CreateReqInfo(id:string=''): TReqInfo; override;
    function CreateReqNew: TReqNew; override;
    function CreateReqUpdate: TReqUpdate; override;
    function CreateReqRemove: TReqRemove; override;
  end;

implementation

uses APIConst;

constructor TQueuesRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  BasePath := constURLRouterBasePath;
end;

function TQueuesRestBroker.List(AReq: TReqList): TListResponse;
begin
  Result := TQueueListResponse.Create;
  Result := inherited List(AReq, Result);
end;

function TQueuesRestBroker.List(AReq: TQueueReqList): TQueueListResponse;
begin
  Result := List(AReq as TReqList) as TQueueListResponse;
end;

function TQueuesRestBroker.New(AReq: TReqNew; AResp: TEntityResponse): TEntityResponse;
begin
  Result := inherited New(AReq, AResp);
end;

function TQueuesRestBroker.New(AReq: TQueueReqNew): TJSONResponse;
begin
  Result := TJSONResponse.Create;
  HttpClient.Request(AReq, Result);
end;

function TQueuesRestBroker.Remove(AReq: TReqRemove): TJSONResponse;
begin
  Result := inherited Remove(AReq);
end;

function TQueuesRestBroker.Remove(AReq: TQueueReqRemove): TJSONResponse;
begin
  Result := Remove(AReq as TReqRemove);
end;

function TQueuesRestBroker.Update(AReq: TQueueReqUpdate): TJSONResponse;
begin
  Result := Update(AReq as TReqUpdate);
end;

function TQueuesRestBroker.CreateReqInfo(id:string=''): TReqInfo;
begin
  Result := TQueueReqInfo.CreateID(id);
  Result.BasePath := BasePath;
end;

function TQueuesRestBroker.CreateReqList: TReqList;
begin
  Result := TQueueReqList.Create;
  Result.BasePath := BasePath;
end;

function TQueuesRestBroker.CreateReqNew: TReqNew;
begin
  Result := TQueueReqNew.Create;
  Result.BasePath := BasePath;
end;

function TQueuesRestBroker.CreateReqRemove: TReqRemove;
begin
  Result := TQueueReqRemove.Create;
  Result.BasePath := BasePath;
end;

function TQueuesRestBroker.CreateReqUpdate: TReqUpdate;
begin
  Result := TQueueReqUpdate.Create;
  Result.BasePath := BasePath;
end;

function TQueuesRestBroker.Info(AReq: TReqInfo): TEntityResponse;
begin
  Result := TQueueInfoResponse.Create;
  inherited Info(AReq, Result);
end;

function TQueuesRestBroker.Info(AReq: TQueueReqInfo): TQueueInfoResponse;
begin
  Result := Info(AReq as TReqInfo) as TQueueInfoResponse;
end;

function TQueuesRestBroker.Update(AReq: TReqUpdate): TJSONResponse;
begin
  Result := inherited Update(AReq);
end;

end.

