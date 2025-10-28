unit UniversalRestBrokerUnit;

interface

uses
  System.SysUtils,
  HttpClientUnit,
  BrokerIntfUnit,
  // Known request/response pairs
  AbonentHttpRequests,
  TaskHttpRequests,
  // Newly added request/response pairs
  CompanyHttpRequests,
  DepartmentHttpRequests,
  LinksHttpRequests,
  ContextsHttpRequests,
  SourceCredsHttpRequests,
  SourceTypesHttpRequests;

type
  TRestBroker = class(TInterfacedObject, IBroker)
  private
    FTicket: string;
    procedure ApplyTicket(const Req: THttpRequest);
    function DispatchAndCreateResponse(const Req: THttpRequest): TJSONResponse;
  public
    constructor Create(const ATicket: string = ''); virtual;
    property Ticket: string read FTicket write FTicket;

    function List(AReq: THttpRequest): TJSONResponse;
    function Info(AReq: THttpRequest): TJSONResponse;
    function New(AReq: THttpRequest): TJSONResponse;
    function Update(AReq: THttpRequest): TJSONResponse;
    function Remove(AReq: THttpRequest): TJSONResponse;

    // Generic helpers to execute typed requests inline with an initializer
    function Exec<TReq: constructor; TRes: TJSONResponse, constructor>(const Init: TProc<TReq>): TRes; overload;
    function Exec<TRes: TJSONResponse, constructor>(Req: THttpRequest): TRes; overload;
  end;

implementation

{ TRestBroker }

procedure TRestBroker.ApplyTicket(const Req: THttpRequest);
begin
  if Assigned(Req) and not FTicket.Trim.IsEmpty then
    Req.Headers.AddOrSetValue('X-Ticket', FTicket);
end;

constructor TRestBroker.Create(const ATicket: string);
begin
  inherited Create;
  FTicket := ATicket;
end;

function TRestBroker.DispatchAndCreateResponse(const Req: THttpRequest): TJSONResponse;
begin
  // Abonents
  if Req is TAbonentReqList then Exit(TAbonentListResponse.Create);
  if Req is TAbonentReqInfo then Exit(TAbonentInfoResponse.Create);
  if Req is TAbonentReqNew then Exit(TAbonentNewResponse.Create);
  if Req is TAbonentReqUpdate then Exit(TJSONResponse.Create);
  if Req is TAbonentReqRemove then Exit(TJSONResponse.Create);

  // Tasks
  if Req is TTaskReqList then Exit(TTaskListResponse.Create);
  if Req is TTaskReqInfo then Exit(TTaskInfoResponse.Create);
  if Req is TTaskReqNew then Exit(TTaskNewResponse.Create);
  if Req is TTaskReqUpdate then Exit(TJSONResponse.Create);
  if Req is TTaskReqRemove then Exit(TJSONResponse.Create);

  // Companies (ACL)
  if Req is TCompanyReqList then Exit(TCompanyListResponse.Create);
  if Req is TCompanyReqInfo then Exit(TCompanyInfoResponse.Create);
  if Req is TCompanyReqNew then Exit(TJSONResponse.Create);
  if Req is TCompanyReqUpdate then Exit(TJSONResponse.Create);
  if Req is TCompanyReqRemove then Exit(TJSONResponse.Create);

  // Departments (ACL)
  if Req is TDepartmentReqList then Exit(TDepartmentListResponse.Create);
  if Req is TDepartmentReqInfo then Exit(TDepartmentInfoResponse.Create);
  if Req is TDepartmentReqNew then Exit(TJSONResponse.Create);
  if Req is TDepartmentReqUpdate then Exit(TJSONResponse.Create);
  if Req is TDepartmentReqRemove then Exit(TJSONResponse.Create);

  // Links (Datacomm)
  if Req is TLinkReqList then Exit(TLinkListResponse.Create);
  if Req is TLinkReqInfo then Exit(TLinkInfoResponse.Create);
  if Req is TLinkReqNew then Exit(TJSONResponse.Create);
  if Req is TLinkReqUpdate then Exit(TJSONResponse.Create);
  if Req is TLinkReqRemove then Exit(TJSONResponse.Create);

  // Contexts (Dataserver)
  if Req is TContextReqList then Exit(TContextListResponse.Create);
  if Req is TContextReqInfo then Exit(TContextInfoResponse.Create);
  if Req is TContextReqNew then Exit(TJSONResponse.Create);
  if Req is TContextReqUpdate then Exit(TJSONResponse.Create);
  if Req is TContextReqRemove then Exit(TJSONResponse.Create);

  // Source credentials (Dataserver)
  if Req is TSourceCredsReqList then Exit(TSourceCredsListResponse.Create);
  if Req is TSourceCredsReqInfo then Exit(TSourceCredsInfoResponse.Create);
  if Req is TSourceCredsReqNew then Exit(TJSONResponse.Create);
  if Req is TSourceCredsReqUpdate then Exit(TJSONResponse.Create);
  if Req is TSourceCredsReqRemove then Exit(TJSONResponse.Create);

  // Source types (Dataserver)
  if Req is TSourceTypeReqList then Exit(TSourceTypeListResponse.Create);

  // Fallback generic
  Result := TJSONResponse.Create;
end;

function TRestBroker.Info(AReq: THttpRequest): TJSONResponse;
begin
  Result := DispatchAndCreateResponse(AReq);
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

function TRestBroker.List(AReq: THttpRequest): TJSONResponse;
begin
  Result := DispatchAndCreateResponse(AReq);
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

function TRestBroker.New(AReq: THttpRequest): TJSONResponse;
begin
  Result := DispatchAndCreateResponse(AReq);
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

function TRestBroker.Remove(AReq: THttpRequest): TJSONResponse;
begin
  Result := DispatchAndCreateResponse(AReq);
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

function TRestBroker.Update(AReq: THttpRequest): TJSONResponse;
begin
  Result := DispatchAndCreateResponse(AReq);
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

function TRestBroker.Exec<TReq, TRes>(const Init: TProc<TReq>): TRes;
var
  Req: TReq;
begin
//  Req := TReq.Create;
//  try
//    if Assigned(Init) then
//      Init(Req);
//    Result := TRes.Create;
//    ApplyTicket(Req);
//    HttpClient.Request(Req, Result);
//  finally
//    Req.Free;
//  end;
end;

function TRestBroker.Exec<TRes>(Req: THttpRequest): TRes;
begin
  Result := TRes.Create;
  ApplyTicket(Req);
  HttpClient.Request(Req, Result);
end;

end.
