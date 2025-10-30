unit RestBrokerBaseUnit;

interface

uses
  HttpClientUnit,
  BaseRequests,
  BaseResponses;

type
  // Base REST broker that operates on base request types
  TRestBrokerBase = class(TObject)
  protected
    FTicket: string;
    procedure ApplyTicket(const Req: THttpRequest);
  public
    constructor Create(const ATicket: string = ''); virtual;
    property Ticket: string read FTicket write FTicket;

      // фабрика базовых запросов (универсальные и безопасные)
    function CreateReqList: TReqList; virtual;
    function CreateReqInfo(id:string=''): TReqInfo; virtual;
    function CreateReqNew: TReqNew; virtual;
    function CreateReqUpdate: TReqUpdate; virtual;
    function CreateReqRemove: TReqRemove; virtual;


    function ExcuteRaw(AReq: THttpRequest; AResp: TJSONResponse): integer; virtual;


    function New(AReq: TReqNew): TJSONResponse; virtual;
    function Update(AReq: TReqUpdate): TJSONResponse; virtual;
    function Remove(AReq: TReqRemove): TJSONResponse; virtual;

  end;

  

implementation

uses System.Math;

{ TRestBrokerBase }

procedure TRestBrokerBase.ApplyTicket(const Req: THttpRequest);
begin
  if Assigned(Req) and (FTicket <> '') then
    Req.Headers.AddOrSetValue('X-Ticket', FTicket);
end;

constructor TRestBrokerBase.Create(const ATicket: string);
begin
  inherited Create;
  FTicket := ATicket;
end;

function TRestBrokerBase.ExcuteRaw(AReq: THttpRequest; AResp: TJSONResponse): integer;
begin
  ApplyTicket(AReq);
  Result := HttpClient.Request(AReq, AResp);
end;

{ TRestBrokerBaseBase }

function TRestBrokerBase.CreateReqInfo(id:string=''): TReqInfo;
begin
  Result := TReqInfo.CreateID(id);
end;

function TRestBrokerBase.CreateReqList: TReqList;
begin
  Result := TReqList.Create;
end;

function TRestBrokerBase.CreateReqNew: TReqNew;
begin
  Result := TReqNew.Create;
end;

function TRestBrokerBase.CreateReqRemove: TReqRemove;
begin
  Result := TReqRemove.Create;
end;

function TRestBrokerBase.CreateReqUpdate: TReqUpdate;
begin
  Result := TReqUpdate.Create;
end;

function TRestBrokerBase.New(AReq: TReqNew): TJSONResponse;
begin
  Result := TJSONResponse.Create;
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

function TRestBrokerBase.Remove(AReq: TReqRemove): TJSONResponse;
begin
  Result := TJSONResponse.Create;
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

function TRestBrokerBase.Update(AReq: TReqUpdate): TJSONResponse;
begin
  Result := TJSONResponse.Create;
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

end.
