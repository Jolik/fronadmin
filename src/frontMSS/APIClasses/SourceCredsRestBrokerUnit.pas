unit SourceCredsRestBrokerUnit;

interface

uses
  RestBrokerBaseUnit, BaseRequests, BaseResponses, RestEntityBrokerUnit,
  SourceCredsHttpRequests, HttpClientUnit;

type
  TSourceCredsRestBroker = class(TRestEntityBroker)
  public
    BasePath: string;
    constructor Create(const ATicket: string = ''); override;
    function List(AReq: TSourceCredsReqList): TSourceCredsListResponse; overload;
    function List(AReq: TReqList): TListResponse; overload; override;
    function Info(AReq: TSourceCredsReqInfo): TSourceCredsInfoResponse; overload;
    function Info(AReq: TReqInfo): TEntityResponse; overload; override;
    function New(AReq: TSourceCredsReqNew): TJSONResponse; overload;
    function New(AReq: TReqNew; AResp: TEntityResponse): TEntityResponse; overload; override;
    function Update(AReq: TSourceCredsReqUpdate): TJSONResponse; overload;
    function Update(AReq: TReqUpdate): TJSONResponse; overload; override;
    function Remove(AReq: TSourceCredsReqRemove): TJSONResponse; overload;
    function Remove(AReq: TReqRemove): TJSONResponse; overload; override;
    function CreateReqList: TReqList; override;
    function CreateReqInfo(id:string=''): TReqInfo; override;
    function CreateReqNew: TReqNew; override;
    function CreateReqUpdate: TReqUpdate; override;
    function CreateReqRemove: TReqRemove; override;
  end;

implementation

uses APIConst;

constructor TSourceCredsRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  BasePath := constURLDataserverBasePath;
end;

function TSourceCredsRestBroker.List(AReq: TReqList): TListResponse;
begin
  Result := TSourceCredsListResponse.Create;
  Result := inherited List(AReq, Result);
end;

function TSourceCredsRestBroker.List(AReq: TSourceCredsReqList): TSourceCredsListResponse;
begin
  Result := List(AReq as TReqList) as TSourceCredsListResponse;
end;

function TSourceCredsRestBroker.New(AReq: TReqNew; AResp: TEntityResponse): TEntityResponse;
begin
  Result := inherited New(AReq, AResp);
end;

function TSourceCredsRestBroker.New(AReq: TSourceCredsReqNew): TJSONResponse;
begin
  Result := TJSONResponse.Create;
  HttpClient.Request(AReq, Result);
end;

function TSourceCredsRestBroker.Remove(AReq: TReqRemove): TJSONResponse;
begin
  Result := inherited Remove(AReq);
end;

function TSourceCredsRestBroker.Remove(AReq: TSourceCredsReqRemove): TJSONResponse;
begin
  Result := Remove(AReq as TReqRemove);
end;

function TSourceCredsRestBroker.Update(AReq: TSourceCredsReqUpdate): TJSONResponse;
begin
  Result := Update(AReq as TReqUpdate);
end;

function TSourceCredsRestBroker.CreateReqInfo(id:string=''): TReqInfo;
begin
  Result := TSourceCredsReqInfo.CreateID(id);
  Result.BasePath := BasePath;
end;

function TSourceCredsRestBroker.CreateReqList: TReqList;
begin
  Result := TSourceCredsReqList.Create;
  Result.BasePath := BasePath;
end;

function TSourceCredsRestBroker.CreateReqNew: TReqNew;
begin
  Result := TSourceCredsReqNew.Create;
  Result.BasePath := BasePath;
end;

function TSourceCredsRestBroker.CreateReqRemove: TReqRemove;
begin
  Result := TSourceCredsReqRemove.Create;
  Result.BasePath := BasePath;
end;

function TSourceCredsRestBroker.CreateReqUpdate: TReqUpdate;
begin
  Result := TSourceCredsReqUpdate.Create;
  Result.BasePath := BasePath;
end;

function TSourceCredsRestBroker.Info(AReq: TReqInfo): TEntityResponse;
begin
  Result := TSourceCredsInfoResponse.Create;
  inherited Info(AReq, Result);
end;

function TSourceCredsRestBroker.Info(AReq: TSourceCredsReqInfo): TSourceCredsInfoResponse;
begin
  Result := Info(AReq as TReqInfo) as TSourceCredsInfoResponse;
end;

function TSourceCredsRestBroker.Update(AReq: TReqUpdate): TJSONResponse;
begin
  Result := inherited Update(AReq);
end;

end.
