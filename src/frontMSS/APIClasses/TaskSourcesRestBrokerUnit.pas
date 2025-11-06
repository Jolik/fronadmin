unit TaskSourcesRestBrokerUnit;

interface

uses
  System.SysUtils,
  RestFieldSetBrokerUnit,
  BaseRequests,
  BaseResponses,
  HttpClientUnit,
  TaskSourceHttpRequests,
  TaskSourceUnit;

type
  // REST broker for task sources API
  TTaskSourcesRestBroker = class(TRestFieldSetBroker)
  public
    // Base service path (e.g. '/api/v2'); final base path is ServicePath + '/tasks'
    ServicePath: string;
    BasePath: string;
    constructor Create(const ATicket: string = ''; const AServicePath: string = '/api/v2'); reintroduce; overload;

    function List(AReq: TTaskSourceReqList): TTaskSourceListResponse; overload;
    function List(AReq: TReqList): TFieldSetListResponse; overload;
    function Info(AReq: TTaskSourceReqInfo): TTaskSourceInfoResponse; overload;
    function Info(AReq: TReqInfo): TFieldSetResponse;overload;
    function New(AReq: TTaskSourceReqNew; const AIdFieldName: string): TIdNewResponse; overload;
    function Update(AReq: TTaskSourceReqUpdate): TJSONResponse; overload;
    function Update(AReq: TReqUpdate): TJSONResponse; overload;

    function Remove(AReq: TTaskSourceReqRemove): TJSONResponse; overload;
    function Remove(AReq: TReqRemove): TJSONResponse; overload; override;

    // Request factories
    function CreateReqList: TReqList; override;
    function CreateReqInfo(id:string=''): TReqInfo; override;
    function CreateReqNew: TReqNew; override;
    function CreateReqUpdate: TReqUpdate; override;
    function CreateReqRemove: TReqRemove; override;
  end;

implementation

uses StrUtils;
{ TTaskSourcesRestBroker }

constructor TTaskSourcesRestBroker.Create(const ATicket: string; const AServicePath: string);
begin
  inherited Create(ATicket);
  ServicePath := AServicePath;
  BasePath := ServicePath.TrimRight(['/']) + '/tasks';
end;


function TTaskSourcesRestBroker.List(AReq: TTaskSourceReqList): TTaskSourceListResponse;
begin
  Result := List(AReq as TReqList) as TTaskSourceListResponse;
end;

function TTaskSourcesRestBroker.List(AReq: TReqList): TFieldSetListResponse;
begin
  Result := TTaskSourceListResponse.Create;
  List(AReq, result);
end;


function TTaskSourcesRestBroker.New(AReq: TTaskSourceReqNew; const AIdFieldName: string): TIdNewResponse;
begin
  Result := TIdNewResponse.Create('tid');
  HttpClient.Request(AReq, Result);
end;

function TTaskSourcesRestBroker.Remove(AReq: TReqRemove): TJSONResponse;
begin
  Result := inherited Remove(AReq);
end;

function TTaskSourcesRestBroker.Remove(AReq: TTaskSourceReqRemove): TJSONResponse;
begin
  Result := Remove(AReq as TReqRemove);
end;

function TTaskSourcesRestBroker.Update(AReq: TTaskSourceReqUpdate): TJSONResponse;
begin
  Result := Update(AReq as TReqUpdate);
end;

function TTaskSourcesRestBroker.CreateReqInfo(id:string=''): TReqInfo;
begin
  Result := TTaskSourceReqInfo.CreateID(id);
  Result.BasePath := BasePath;
end;

function TTaskSourcesRestBroker.CreateReqList: TReqList;
begin
  // Though the request inherits from TBaseServiceRequest, it fits into TReqList type for API compatibility
  Result := TTaskSourceReqList.Create;
  Result.BasePath := BasePath;
end;

function TTaskSourcesRestBroker.CreateReqNew: TReqNew;
begin
  Result := TTaskSourceReqNew.Create;
  Result.BasePath := BasePath;
end;

function TTaskSourcesRestBroker.CreateReqRemove: TReqRemove;
begin
  Result := TTaskSourceReqRemove.Create;
  Result.BasePath := BasePath;
end;

function TTaskSourcesRestBroker.CreateReqUpdate: TReqUpdate;
begin
  Result := TTaskSourceReqUpdate.Create;
  Result.BasePath := BasePath;
end;

function TTaskSourcesRestBroker.Info(AReq: TTaskSourceReqInfo): TTaskSourceInfoResponse;
begin
  Result := Info(AReq as TReqInfo) as TTaskSourceInfoResponse;
end;

function TTaskSourcesRestBroker.Info(AReq: TReqInfo): TFieldSetResponse;
begin
  inherited Info(AReq, Result);
end;

function TTaskSourcesRestBroker.Update(AReq: TReqUpdate): TJSONResponse;
begin
  Result := inherited Update(AReq);
end;

end.
