unit ChannelsRestBrokerUnit;

interface

uses
  RestBrokerBaseUnit, BaseRequests, BaseResponses,
  ChannelHttpRequests, HttpClientUnit;

type
  TChannelsRestBroker = class(TRestBrokerBase)
  public
    BasePath: string;
    constructor Create(const ATicket: string = ''); override;
    function List(AReq: TChannelReqList): TChannelListResponse; overload;
    function List(AReq: TReqList): TListResponse; overload; override;
    function Info(AReq: TChannelReqInfo): TChannelInfoResponse; overload;
    function Info(AReq: TReqInfo): TEntityResponse; overload; override;
    function New(AReq: TChannelReqNew): TJSONResponse; overload;
    function New(AReq: TReqNew; AResp: TFieldSetResponse): TFieldSetResponse; overload; override;
    function Update(AReq: TChannelReqUpdate): TJSONResponse; overload;
    function Update(AReq: TReqUpdate): TJSONResponse; overload; override;
    function Remove(AReq: TChannelReqRemove): TJSONResponse; overload;
    function Remove(AReq: TReqRemove): TJSONResponse; overload; override;
    function CreateReqList: TReqList; override;
    function CreateReqInfo(id:string=''): TReqInfo; override;
    function CreateReqNew: TReqNew; override;
    function CreateReqUpdate: TReqUpdate; override;
    function CreateReqRemove: TReqRemove; override;
  end;

implementation

uses APIConst;

constructor TChannelsRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  BasePath := constURLRouterBasePath;
end;

function TChannelsRestBroker.List(AReq: TReqList): TListResponse;
begin
  Result := TChannelListResponse.Create;
  Result := inherited List(AReq, Result);
end;

function TChannelsRestBroker.List(AReq: TChannelReqList): TChannelListResponse;
begin
  Result := List(AReq as TReqList) as TChannelListResponse;
end;

function TChannelsRestBroker.New(AReq: TReqNew; AResp: TFieldSetResponse): TFieldSetResponse;
begin
  Result := inherited New(AReq, AResp);
end;

function TChannelsRestBroker.New(AReq: TChannelReqNew): TJSONResponse;
begin
  Result := TJSONResponse.Create;
  HttpClient.Request(AReq, Result);
end;

function TChannelsRestBroker.Remove(AReq: TReqRemove): TJSONResponse;
begin
  Result := inherited Remove(AReq);
end;

function TChannelsRestBroker.Remove(AReq: TChannelReqRemove): TJSONResponse;
begin
  Result := Remove(AReq as TReqRemove);
end;

function TChannelsRestBroker.Update(AReq: TChannelReqUpdate): TJSONResponse;
begin
  Result := Update(AReq as TReqUpdate);
end;

function TChannelsRestBroker.CreateReqInfo(id:string=''): TReqInfo;
begin
  Result := TChannelReqInfo.CreateID(id);
  Result.BasePath := BasePath;
end;

function TChannelsRestBroker.CreateReqList: TReqList;
begin
  Result := TChannelReqList.Create;
  Result.BasePath := BasePath;
end;

function TChannelsRestBroker.CreateReqNew: TReqNew;
begin
  Result := TChannelReqNew.Create;
  Result.BasePath := BasePath;
end;

function TChannelsRestBroker.CreateReqRemove: TReqRemove;
begin
  Result := TChannelReqRemove.Create;
  Result.BasePath := BasePath;
end;

function TChannelsRestBroker.CreateReqUpdate: TReqUpdate;
begin
  Result := TChannelReqUpdate.Create;
  Result.BasePath := BasePath;
end;

function TChannelsRestBroker.Info(AReq: TReqInfo): TEntityResponse;
begin
  Result := TChannelInfoResponse.Create;
  inherited Info(AReq, Result);
end;

function TChannelsRestBroker.Info(AReq: TChannelReqInfo): TChannelInfoResponse;
begin
  Result := Info(AReq as TReqInfo) as TChannelInfoResponse;
end;

function TChannelsRestBroker.Update(AReq: TReqUpdate): TJSONResponse;
begin
  Result := inherited Update(AReq);
end;

end.

