unit OrganizationsRestBrokerUnit;

interface

uses
  RestFieldSetBrokerUnit,
  BaseRequests,
  BaseResponses,
  OrganizationHttpRequests,
  OrganizationUnit;

type
  // Broker for /organizations related endpoints
  TOrganizationsRestBroker = class(TRestFieldSetBroker)
  public
    BasePath: string;

    constructor Create(const ATicket: string = ''); overload;

    function List(AReq: TOrganizationReqList): TOrganizationListResponse; overload;
    function List(AReq: TReqList): TFieldSetListResponse; overload; override;
    function ListAll(AReq: TOrganizationReqList): TOrganizationListResponse; overload;
    function ListAll(AReq: TReqList): TFieldSetListResponse; overload; override;

    function ListTypes(AReq: TOrganizationTypesReqList): TOrgTypeListResponse; overload;
    function ListTypes(AReq: TReqList): TFieldSetListResponse; overload;
    function ListTypesLegacy(AReq: TOrgTypesReqList): TOrgTypeListResponse;

    function CreateReqList: TReqList; override;
    function CreateOrgTypesReqList: TOrganizationTypesReqList;
    function CreateLegacyOrgTypesReqList: TOrgTypesReqList;
  end;

implementation

uses
  APIConst;

{ TOrganizationsRestBroker }

constructor TOrganizationsRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  BasePath := constURLDataserverBasePath;
end;

function TOrganizationsRestBroker.CreateLegacyOrgTypesReqList: TOrgTypesReqList;
begin
  Result := TOrgTypesReqList.Create;
  Result.BasePath := BasePath;
end;

function TOrganizationsRestBroker.CreateOrgTypesReqList: TOrganizationTypesReqList;
begin
  Result := TOrganizationTypesReqList.Create;
  Result.BasePath := BasePath;
end;

function TOrganizationsRestBroker.CreateReqList: TReqList;
begin
  Result := TOrganizationReqList.Create;
  Result.BasePath := BasePath;
end;

function TOrganizationsRestBroker.List(AReq: TOrganizationReqList): TOrganizationListResponse;
begin
  Result := List(AReq as TReqList) as TOrganizationListResponse;
end;

function TOrganizationsRestBroker.List(AReq: TReqList): TFieldSetListResponse;
begin
  Result := TOrganizationListResponse.Create;
  inherited List(AReq, Result);
end;

function TOrganizationsRestBroker.ListAll(AReq: TOrganizationReqList): TOrganizationListResponse;
begin
  Result := ListAll(AReq as TReqList) as TOrganizationListResponse;
end;

function TOrganizationsRestBroker.ListAll(AReq: TReqList): TFieldSetListResponse;
begin
  Result := TOrganizationListResponse.Create;
  inherited ListAll(AReq, Result);
end;

function TOrganizationsRestBroker.ListTypes(AReq: TReqList): TFieldSetListResponse;
begin
  Result := TOrgTypeListResponse.Create;
  inherited List(AReq, Result);
end;

function TOrganizationsRestBroker.ListTypes(AReq: TOrganizationTypesReqList): TOrgTypeListResponse;
begin
  Result := ListTypes(AReq as TReqList) as TOrgTypeListResponse;
end;

function TOrganizationsRestBroker.ListTypesLegacy(AReq: TOrgTypesReqList): TOrgTypeListResponse;
begin
  Result := ListTypes(AReq as TReqList) as TOrgTypeListResponse;
end;

end.

