unit AbonentsRestBrokerUnit;

interface

uses
  System.SysUtils,
  HttpClientUnit,
  AbonentHttpRequests,
  BaseResponses,
  BaseRequests,
  RestEntityBrokerUnit,
  RestBrokerBaseUnit,
  EntityUnit,
  AbonentUnit;

type
  TAbonentsRestBroker = class(TRestEntityBroker)
  private
    procedure ApplyTicketLocal(const Req: THttpRequest);
  public
    // Фабрики базовых запросов
    function CreateReqList: TReqList; override;
    function CreateReqInfo(id:string=''): TReqInfo; override;
    function CreateReqNew: TReqNew; override;
    function CreateReqUpdate: TReqUpdate; override;
    function CreateReqRemove: TReqRemove; override;

    function List(AReq: TAbonentReqList): TAbonentListResponse;
    function ListBase(AReq: TAbonentReqList): TListResponse;
    function Info(AReq: TAbonentReqInfo): TAbonentInfoResponse;
    function New(AReq: TAbonentReqNew): TAbonentNewResponse;
    function Update(AReq: TAbonentReqUpdate): TJSONResponse;
    function Remove(AReq: TAbonentReqRemove): TJSONResponse;
  end;

implementation

procedure TAbonentsRestBroker.ApplyTicketLocal(const Req: THttpRequest);
begin
  if Assigned(Req) and not Ticket.Trim.IsEmpty then
    Req.Headers.AddOrSetValue('X-Ticket', Ticket);
end;

function TAbonentsRestBroker.List(AReq: TAbonentReqList): TAbonentListResponse;
begin
  Result := TAbonentListResponse.Create;
  ApplyTicketLocal(AReq);
  HttpClient.Request(AReq, Result);
end;

function TAbonentsRestBroker.ListBase(AReq: TAbonentReqList): TListResponse;
begin
  Result := TListResponse.Create(TAbonentList, 'response', 'abonents');
  ApplyTicketLocal(AReq);
  HttpClient.Request(AReq, Result);
end;

function TAbonentsRestBroker.Info(AReq: TAbonentReqInfo): TAbonentInfoResponse;
begin
  Result := TAbonentInfoResponse.Create;
  ApplyTicketLocal(AReq);
  HttpClient.Request(AReq, Result);
end;

function TAbonentsRestBroker.New(AReq: TAbonentReqNew): TAbonentNewResponse;
begin
  Result := TAbonentNewResponse.Create;
  ApplyTicketLocal(AReq);
  HttpClient.Request(AReq, Result);
end;

function TAbonentsRestBroker.Update(AReq: TAbonentReqUpdate): TJSONResponse;
begin
  Result := TJSONResponse.Create;
  ApplyTicketLocal(AReq);
  HttpClient.Request(AReq, Result);
end;

function TAbonentsRestBroker.Remove(AReq: TAbonentReqRemove): TJSONResponse;
begin
  Result := TJSONResponse.Create;
  ApplyTicketLocal(AReq);
  HttpClient.Request(AReq, Result);
end;

function TAbonentsRestBroker.CreateReqList: TReqList;
begin
  Result := TAbonentReqList.Create;
end;

function TAbonentsRestBroker.CreateReqInfo(id:string=''): TReqInfo;
begin
  Result := TAbonentReqInfo.CreateID(id);
end;

function TAbonentsRestBroker.CreateReqNew: TReqNew;
begin
  Result := TAbonentReqNew.Create;
end;

function TAbonentsRestBroker.CreateReqUpdate: TReqUpdate;
begin
  Result := TAbonentReqUpdate.Create;
end;

function TAbonentsRestBroker.CreateReqRemove: TReqRemove;
begin
  Result := TAbonentReqRemove.Create;
end;

end.
