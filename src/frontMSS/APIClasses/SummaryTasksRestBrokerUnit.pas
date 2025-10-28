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

  TSummaryTaskNewRequest = class(TTaskReqNew)
  public
    class function BodyClassType: TFieldSetClass; override;
  end;

  // Response wrappers for Summary tasks using TSummaryTask/TSummaryTaskList
  TSummaryTaskListResponse = class(TListResponse)
  public
    constructor Create; reintroduce;
  end;

  TSummaryTaskInfoResponse = class(TEntityResponse)
  public
    constructor Create; reintroduce;
  end;

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

uses APIConst;

{ TSummaryTaskListResponse }

constructor TSummaryTaskListResponse.Create;
begin
  inherited Create(TSummaryTaskList, 'response', 'tasks');
end;

{ TSummaryTaskInfoResponse }

constructor TSummaryTaskInfoResponse.Create;
begin
  inherited Create(TSummaryTask, 'response', 'task');
end;

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

{ TSummaryTaskNewRequest }

class function TSummaryTaskNewRequest.BodyClassType: TFieldSetClass;
begin

end;

{ TSummaryTaskNewBody }

//constructor TSummaryTaskNewBody.Create;
//begin
//  inherited;
//
//end;

end.
