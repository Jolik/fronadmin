unit CompaniesRestBrokerUnit;

interface

uses
  RestBrokerBaseUnit, BaseRequests, BaseResponses,
  CompanyHttpRequests, HttpClientUnit, RestEntityBrokerUnit;

type
  TCompaniesRestBroker = class(TRestEntityBroker)
  public
    BasePath: string;
    constructor Create(const ATicket: string = ''); override;
    function List(AReq: TCompanyReqList): TCompanyListResponse; overload;
    function List(AReq: TReqList): TListResponse; overload; override;
    function Info(AReq: TCompanyReqInfo): TCompanyInfoResponse; overload;
    function Info(AReq: TReqInfo): TEntityResponse; overload; override;
    function New(AReq: TCompanyReqNew): TJSONResponse; overload;
    function New(AReq: TReqNew; AResp: TEntityResponse): TEntityResponse; overload; override;
    function Update(AReq: TCompanyReqUpdate): TJSONResponse; overload;
    function Update(AReq: TReqUpdate): TJSONResponse; overload; override;
    function Remove(AReq: TCompanyReqRemove): TJSONResponse; overload;
    function Remove(AReq: TReqRemove): TJSONResponse; overload; override;
    function CreateReqList: TReqList; override;
    function CreateReqInfo(id:string=''): TReqInfo; override;
    function CreateReqNew: TReqNew; override;
    function CreateReqUpdate: TReqUpdate; override;
    function CreateReqRemove: TReqRemove; override;
  end;

implementation

uses APIConst;

constructor TCompaniesRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  BasePath := constURLAclBasePath;
end;

function TCompaniesRestBroker.List(AReq: TReqList): TListResponse;
begin
  Result := TCompanyListResponse.Create;
  Result := inherited List(AReq, Result);
end;

function TCompaniesRestBroker.List(AReq: TCompanyReqList): TCompanyListResponse;
begin
  Result := List(AReq as TReqList) as TCompanyListResponse;
end;

function TCompaniesRestBroker.New(AReq: TReqNew; AResp: TEntityResponse): TEntityResponse;
begin
  Result := inherited New(AReq, AResp);
end;

function TCompaniesRestBroker.New(AReq: TCompanyReqNew): TJSONResponse;
begin
  Result := TJSONResponse.Create;
  HttpClient.Request(AReq, Result);
end;

function TCompaniesRestBroker.Remove(AReq: TReqRemove): TJSONResponse;
begin
  Result := inherited Remove(AReq);
end;

function TCompaniesRestBroker.Remove(AReq: TCompanyReqRemove): TJSONResponse;
begin
  Result := Remove(AReq as TReqRemove);
end;

function TCompaniesRestBroker.Update(AReq: TCompanyReqUpdate): TJSONResponse;
begin
  Result := Update(AReq as TReqUpdate);
end;

function TCompaniesRestBroker.CreateReqInfo(id:string=''): TReqInfo;
begin
  Result := TCompanyReqInfo.CreateID(id);
  Result.BasePath := BasePath;
end;

function TCompaniesRestBroker.CreateReqList: TReqList;
begin
  Result := TCompanyReqList.Create;
  Result.BasePath := BasePath;
end;

function TCompaniesRestBroker.CreateReqNew: TReqNew;
begin
  Result := TCompanyReqNew.Create;
  Result.BasePath := BasePath;
end;

function TCompaniesRestBroker.CreateReqRemove: TReqRemove;
begin
  Result := TCompanyReqRemove.Create;
  Result.BasePath := BasePath;
end;

function TCompaniesRestBroker.CreateReqUpdate: TReqUpdate;
begin
  Result := TCompanyReqUpdate.Create;
  Result.BasePath := BasePath;
end;

function TCompaniesRestBroker.Info(AReq: TReqInfo): TEntityResponse;
begin
  Result := TCompanyInfoResponse.Create;
  inherited Info(AReq, Result);
end;

function TCompaniesRestBroker.Info(AReq: TCompanyReqInfo): TCompanyInfoResponse;
begin
  Result := Info(AReq as TReqInfo) as TCompanyInfoResponse;
end;

function TCompaniesRestBroker.Update(AReq: TReqUpdate): TJSONResponse;
begin
  Result := inherited Update(AReq);
end;

end.
