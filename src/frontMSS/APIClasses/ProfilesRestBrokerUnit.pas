unit ProfilesRestBrokerUnit;

interface

uses
  RestBrokerBaseUnit, BaseRequests, BaseResponses,RestEntityBrokerUnit,
  ProfileHttpRequests, HttpClientUnit;

type
  TProfilesRestBroker = class(TRestEntityBroker)
  public
    BasePath: string;
    constructor Create(const ATicket: string = ''); override;
    function List(AReq: TProfileReqList): TProfileListResponse; overload;
    function List(AReq: TReqList): TListResponse; overload; override;
    function Info(AReq: TProfileReqInfo): TProfileInfoResponse; overload;
    function Info(AReq: TReqInfo): TEntityResponse; overload; override;
    function New(AReq: TProfileReqNew): TJSONResponse; overload;
    function New(AReq: TReqNew; AResp: TEntityResponse): TEntityResponse; overload; override;
    function Update(AReq: TProfileReqUpdate): TJSONResponse; overload;
    function Update(AReq: TReqUpdate): TJSONResponse; overload; override;
    function Remove(AReq: TProfileReqRemove): TJSONResponse; overload;
    function Remove(AReq: TReqRemove): TJSONResponse; overload; override;
    function CreateReqList: TReqList; override;
    function CreateReqInfo(id:string=''): TReqInfo;overload; override;
    function CreateReqInfo(lid:string='';id:string=''): TReqInfo;overload;
    function CreateReqNew: TReqNew; override;
    function CreateReqUpdate: TReqUpdate; override;
    function CreateReqRemove: TReqRemove; override;
  end;

implementation

uses APIConst;

constructor TProfilesRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  BasePath := constURLDatacommBasePath;
end;

function TProfilesRestBroker.List(AReq: TReqList): TListResponse;
begin
  Result := TProfileListResponse.Create;
  Result := inherited List(AReq, Result);
end;

function TProfilesRestBroker.List(AReq: TProfileReqList): TProfileListResponse;
begin
  Result := List(AReq as TReqList) as TProfileListResponse;
end;

function TProfilesRestBroker.New(AReq: TReqNew; AResp: TEntityResponse): TEntityResponse;
begin
  Result := inherited New(AReq, AResp);
end;

function TProfilesRestBroker.New(AReq: TProfileReqNew): TJSONResponse;
begin
  Result := TJSONResponse.Create;
  HttpClient.Request(AReq, Result);
end;

function TProfilesRestBroker.Remove(AReq: TReqRemove): TJSONResponse;
begin
  Result := inherited Remove(AReq);
end;

function TProfilesRestBroker.Remove(AReq: TProfileReqRemove): TJSONResponse;
begin
  Result := Remove(AReq as TReqRemove);
end;

function TProfilesRestBroker.Update(AReq: TProfileReqUpdate): TJSONResponse;
begin
  Result := Update(AReq as TReqUpdate);
end;

function TProfilesRestBroker.CreateReqInfo(id:string=''): TReqInfo;
begin
  Result := TProfileReqInfo.CreateID(id);
  Result.BasePath := BasePath;
end;

function TProfilesRestBroker.CreateReqInfo(lid, id: string): TReqInfo;
begin
  Result := TProfileReqInfo.CreateID(id);
  Result.BasePath := BasePath;
  (Result as TProfileReqInfo).Lid := lid;
end;

function TProfilesRestBroker.CreateReqList: TReqList;
begin
  Result := TProfileReqList.Create;
  Result.BasePath := BasePath;
end;

function TProfilesRestBroker.CreateReqNew: TReqNew;
begin
  Result := TProfileReqNew.Create;
  Result.BasePath := BasePath;
end;

function TProfilesRestBroker.CreateReqRemove: TReqRemove;
begin
  Result := TProfileReqRemove.Create;
  Result.BasePath := BasePath;
end;

function TProfilesRestBroker.CreateReqUpdate: TReqUpdate;
begin
  Result := TProfileReqUpdate.Create;
  Result.BasePath := BasePath;
end;

function TProfilesRestBroker.Info(AReq: TReqInfo): TEntityResponse;
begin
  Result := TProfileInfoResponse.Create;
  inherited Info(AReq, Result);
end;

function TProfilesRestBroker.Info(AReq: TProfileReqInfo): TProfileInfoResponse;
begin
  Result := Info(AReq as TReqInfo) as TProfileInfoResponse;
end;

function TProfilesRestBroker.Update(AReq: TReqUpdate): TJSONResponse;
begin
  Result := inherited Update(AReq);
end;

end.

