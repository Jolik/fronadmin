unit LocationsRestBrokerUnit;

interface

uses
  RestFieldSetBrokerUnit,
  BaseRequests,
  BaseResponses,
  LocationHttpRequests,
  LocationUnit;

type
  // Broker for /locations endpoints
  TLocationsRestBroker = class(TRestFieldSetBroker)
  public
    BasePath: string;

    constructor Create(const ATicket: string = ''); overload;

    function List(AReq: TLocationReqList): TLocationListResponse; overload;
    function List(AReq: TReqList): TFieldSetListResponse; overload; override;
    function ListAll(AReq: TLocationReqList): TLocationListResponse; overload;
    function ListAll(AReq: TReqList): TFieldSetListResponse; overload; override;

    function CreateReqList: TReqList; override;
  end;

implementation

uses
  APIConst;

{ TLocationsRestBroker }

constructor TLocationsRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  BasePath := constURLManagementcommBasePath;
end;

function TLocationsRestBroker.CreateReqList: TReqList;
begin
  Result := TLocationReqList.Create;
  Result.BasePath := BasePath;
end;

function TLocationsRestBroker.List(AReq: TLocationReqList): TLocationListResponse;
begin
  Result := List(AReq as TReqList) as TLocationListResponse;
end;

function TLocationsRestBroker.List(AReq: TReqList): TFieldSetListResponse;
begin
  Result := TLocationListResponse.Create;
  inherited List(AReq, Result);
end;

function TLocationsRestBroker.ListAll(AReq: TLocationReqList): TLocationListResponse;
begin
  Result := TLocationListResponse.Create;
  ListAll(AReq, Result);
end;

function TLocationsRestBroker.ListAll(AReq: TReqList): TFieldSetListResponse;
begin
  Result := TLocationListResponse.Create;
  inherited ListAll(AReq, Result);
end;

end.
