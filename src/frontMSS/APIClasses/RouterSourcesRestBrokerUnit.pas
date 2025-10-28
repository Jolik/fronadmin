unit RouterSourcesRestBrokerUnit;

interface

uses
  RestBrokerBaseUnit, BaseRequests, BaseResponses,
  RouterSourceHttpRequests, HttpClientUnit;

type
  TRouterSourcesRestBroker = class(TRestBrokerBase)
  public
    BasePath: string;
    constructor Create(const ATicket: string = ''); override;
    function List(AReq: TRouterSourceReqList): TRouterSourceListResponse; overload;
    function List(AReq: TReqList): TListResponse; overload; override;
    function Info(AReq: TRouterSourceReqInfo): TRouterSourceInfoResponse; overload;
    function Info(AReq: TReqInfo): TEntityResponse; overload; override;
    function New(AReq: TRouterSourceReqNew): TJSONResponse; overload;
    function New(AReq: TReqNew; AResp: TFieldSetResponse): TFieldSetResponse; overload; override;
    function Update(AReq: TRouterSourceReqUpdate): TJSONResponse; overload;
    function Update(AReq: TReqUpdate): TJSONResponse; overload; override;
    function Remove(AReq: TRouterSourceReqRemove): TJSONResponse; overload;
    function Remove(AReq: TReqRemove): TJSONResponse; overload; override;
    function CreateReqList: TReqList; override;
    function CreateReqInfo(id:string=''): TReqInfo; override;
    function CreateReqNew: TReqNew; override;
    function CreateReqUpdate: TReqUpdate; override;
    function CreateReqRemove: TReqRemove; override;
  end;

implementation

uses APIConst;

constructor TRouterSourcesRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  BasePath := constURLRouterBasePath;
end;

function TRouterSourcesRestBroker.List(AReq: TReqList): TListResponse;
begin
  Result := TRouterSourceListResponse.Create;
  Result := inherited List(AReq, Result);
end;

function TRouterSourcesRestBroker.List(AReq: TRouterSourceReqList): TRouterSourceListResponse;
begin
  Result := List(AReq as TReqList) as TRouterSourceListResponse;
end;

function TRouterSourcesRestBroker.New(AReq: TReqNew; AResp: TFieldSetResponse): TFieldSetResponse;
begin
  Result := inherited New(AReq, AResp);
end;

function TRouterSourcesRestBroker.New(AReq: TRouterSourceReqNew): TJSONResponse;
begin
  Result := TJSONResponse.Create;
  HttpClient.Request(AReq, Result);
end;

function TRouterSourcesRestBroker.Remove(AReq: TReqRemove): TJSONResponse;
begin
  Result := inherited Remove(AReq);
end;

function TRouterSourcesRestBroker.Remove(AReq: TRouterSourceReqRemove): TJSONResponse;
begin
  Result := Remove(AReq as TReqRemove);
end;

function TRouterSourcesRestBroker.Update(AReq: TRouterSourceReqUpdate): TJSONResponse;
begin
  Result := Update(AReq as TReqUpdate);
end;

function TRouterSourcesRestBroker.CreateReqInfo(id:string=''): TReqInfo;
begin
  Result := TRouterSourceReqInfo.CreateID(id);
  Result.BasePath := BasePath;
end;

function TRouterSourcesRestBroker.CreateReqList: TReqList;
begin
  Result := TRouterSourceReqList.Create;
  Result.BasePath := BasePath;
end;

function TRouterSourcesRestBroker.CreateReqNew: TReqNew;
begin
  Result := TRouterSourceReqNew.Create;
  Result.BasePath := BasePath;
end;

function TRouterSourcesRestBroker.CreateReqRemove: TReqRemove;
begin
  Result := TRouterSourceReqRemove.Create;
  Result.BasePath := BasePath;
end;

function TRouterSourcesRestBroker.CreateReqUpdate: TReqUpdate;
begin
  Result := TRouterSourceReqUpdate.Create;
  Result.BasePath := BasePath;
end;

function TRouterSourcesRestBroker.Info(AReq: TReqInfo): TEntityResponse;
begin
  Result := TRouterSourceInfoResponse.Create;
  inherited Info(AReq, Result);
end;

function TRouterSourcesRestBroker.Info(AReq: TRouterSourceReqInfo): TRouterSourceInfoResponse;
begin
  Result := Info(AReq as TReqInfo) as TRouterSourceInfoResponse;
end;

function TRouterSourcesRestBroker.Update(AReq: TReqUpdate): TJSONResponse;
begin
  Result := inherited Update(AReq);
end;

end.

