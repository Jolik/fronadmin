unit SourceTypesRestBrokerUnit;

interface

uses
  RestBrokerBaseUnit, BaseRequests, BaseResponses,  RestEntityBrokerUnit,
  SourceTypesHttpRequests, HttpClientUnit;

type
  TSourceTypesRestBroker = class(TRestEntityBroker)
  public
    BasePath: string;
    constructor Create(const ATicket: string = ''); override;
    function List(AReq: TSourceTypeReqList): TSourceTypeListResponse; overload;
    function List(AReq: TReqList): TListResponse; overload; override;
    function CreateReqList: TReqList; override;
  end;

implementation

uses APIConst;

constructor TSourceTypesRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  BasePath := constURLDataserverBasePath;
end;

function TSourceTypesRestBroker.List(AReq: TReqList): TListResponse;
begin
  Result := TSourceTypeListResponse.Create;
  Result := inherited List(AReq, Result);
end;

function TSourceTypesRestBroker.List(AReq: TSourceTypeReqList): TSourceTypeListResponse;
begin
  Result := List(AReq as TReqList) as TSourceTypeListResponse;
end;

function TSourceTypesRestBroker.CreateReqList: TReqList;
begin
  Result := TSourceTypeReqList.Create;
  Result.BasePath := BasePath;
end;

end.

