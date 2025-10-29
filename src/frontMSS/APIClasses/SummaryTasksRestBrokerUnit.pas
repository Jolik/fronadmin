unit SummaryTasksRestBrokerUnit;

interface

uses
  RestBrokerBaseUnit,
  BaseRequests,
  BaseResponses,
  HttpClientUnit,
  TaskHttpRequests,
  TasksRestBrokerUnit,
  EntityUnit,
  SummaryTaskUnit;

type

  // REST broker for Summary tasks; reuses Task requests with summary base path
  TSummaryTasksRestBroker = class(TTasksRestBroker)
  public
    constructor Create(const ATicket: string = ''); override;
    function List(AReq: TReqList): TListResponse; overload; override;
    function Info(AReq: TReqInfo): TEntityResponse; overload; override;
    function CreateReqList: TReqList; override;
//    function CreateReqNew: TReqNew; override;
    function CreateReqInfo(id:string=''): TReqInfo; override;
  end;

implementation

uses SummaryTasksHttpRequests, APIConst;

{ TSummaryTasksRestBroker }

constructor TSummaryTasksRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  BasePath := constURLSummaryBasePath;
end;

function TSummaryTasksRestBroker.Info(AReq: TReqInfo): TEntityResponse;
begin
  Result := TSummaryTaskInfoResponse.Create;
  inherited Info(AReq, Result);
end;

function TSummaryTasksRestBroker.List(AReq: TReqList): TListResponse;
begin
  Result := TSummaryTaskListResponse.Create;
  Result := inherited List(AReq, Result);
end;

function TSummaryTasksRestBroker.CreateReqList: TReqList;
begin
  Result := TTaskReqList.Create;
  Result.BasePath := BasePath;
end;

//function TSummaryTasksRestBroker.CreateReqNew: TReqNew;
//begin
//  Result := TTaskReqList.Create;
//  Result.BasePath := BasePath;
//end;

function TSummaryTasksRestBroker.CreateReqInfo(id: string): TReqInfo;
begin
  Result := TTaskReqInfo.CreateID(id);
  Result.BasePath := BasePath;
end;


end.
