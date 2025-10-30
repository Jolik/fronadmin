unit SourcesRestBrokerUnit;

interface

uses
  System.SysUtils,
  RestFieldSetBrokerUnit,
  BaseRequests,
  BaseResponses,
  HttpClientUnit,
  SourceHttpRequests,
  SourceUnit;

type
  // REST broker for /sources API
  TSourcesRestBroker = class(TRestFieldSetBroker)
  public
    ServicePath: string;
    BasePath: string;

    constructor Create(const ATicket: string = ''; const AServicePath: string = '/api/v2'); reintroduce; overload;

    function List(AReq: TSourceReqList): TSourceListResponse; overload;
    function List(AReq: TReqList): TFieldSetListResponse; overload;
    function Info(AReq: TSourceReqInfo): TSourceInfoResponse; overload;
    function Info(AReq: TReqInfo): TFieldSetResponse; overload;
    function New(AReq: TSourceReqNew): TIdNewResponse; overload;
    function Update(AReq: TSourceReqUpdate): TJSONResponse; overload;
    function Update(AReq: TReqUpdate): TJSONResponse; overload;
    function Remove(AReq: TSourceReqRemove): TJSONResponse; overload;
    function Remove(AReq: TReqRemove): TJSONResponse; overload; override;

    // Request factories
    function CreateReqList: TReqList; override;
    function CreateReqInfo(id: string = ''): TReqInfo; override;
    function CreateReqNew: TReqNew; override;
    function CreateReqUpdate: TReqUpdate; override;
    function CreateReqRemove: TReqRemove; override;
  end;

implementation

uses
  StrUtils;

{ TSourcesRestBroker }

constructor TSourcesRestBroker.Create(const ATicket: string; const AServicePath: string);
begin
  inherited Create(ATicket);
  ServicePath := AServicePath;
  BasePath := ServicePath.TrimRight(['/']) + '/sources';
end;

function TSourcesRestBroker.CreateReqInfo(id: string): TReqInfo;
begin
  Result := TSourceReqInfo.CreateID(id);
  Result.BasePath := BasePath;
end;

function TSourcesRestBroker.CreateReqList: TReqList;
begin
  Result := TSourceReqList.Create;
  Result.BasePath := BasePath;
end;

function TSourcesRestBroker.CreateReqNew: TReqNew;
begin
  Result := TSourceReqNew.Create;
  Result.BasePath := BasePath;
end;

function TSourcesRestBroker.CreateReqUpdate: TReqUpdate;
begin
  Result := TSourceReqUpdate.Create;
  Result.BasePath := BasePath;
end;

function TSourcesRestBroker.CreateReqRemove: TReqRemove;
begin
  Result := TSourceReqRemove.Create;
  Result.BasePath := BasePath;
end;

function TSourcesRestBroker.Info(AReq: TSourceReqInfo): TSourceInfoResponse;
begin
  Result := Info(AReq as TReqInfo) as TSourceInfoResponse;
end;

function TSourcesRestBroker.Info(AReq: TReqInfo): TFieldSetResponse;
begin
  inherited Info(AReq, Result);
end;

function TSourcesRestBroker.List(AReq: TSourceReqList): TSourceListResponse;
begin
  Result := List(AReq as TReqList) as TSourceListResponse;
end;

function TSourcesRestBroker.List(AReq: TReqList): TFieldSetListResponse;
begin
  Result := TSourceListResponse.Create;
  List(AReq, Result);
end;

function TSourcesRestBroker.New(AReq: TSourceReqNew): TIdNewResponse;
begin
  Result := TIdNewResponse.Create;
  HttpClient.Request(AReq, Result);
end;

function TSourcesRestBroker.Update(AReq: TSourceReqUpdate): TJSONResponse;
begin
  Result := Update(AReq as TReqUpdate);
end;

function TSourcesRestBroker.Update(AReq: TReqUpdate): TJSONResponse;
begin
  Result := inherited Update(AReq);
end;

function TSourcesRestBroker.Remove(AReq: TSourceReqRemove): TJSONResponse;
begin
  Result := Remove(AReq as TReqRemove);
end;

function TSourcesRestBroker.Remove(AReq: TReqRemove): TJSONResponse;
begin
  Result := inherited Remove(AReq);
end;

end.
