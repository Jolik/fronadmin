unit SummaryTasksHttpRequests;

interface

uses
  System.JSON,
  BaseRequests,
  EntityUnit,
  BaseResponses,
  SummaryTaskUnit,
  TaskHttpRequests,
  TaskSourceUnit,
  APIConst;

type

  TSummaryTaskNewBody = class(TSummaryTask)
  protected
    FSources: TTaskSourceList;
  public
//    constructor Create; override;
//    destructor Destroy; override;
//    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
//    property Sources: TNewTaskSourceList read FSources;
  end;

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

  // Базовый запрос для Summary Tasks: задаёт базовый путь на сервис Summary
  TSummaryTasksRequest = class(TBaseServiceRequest)
  public
    constructor Create; override;
  end;

implementation

{ TSummaryTasksRequest }

constructor TSummaryTasksRequest.Create;
begin
  inherited Create;
  BasePath := constURLSummaryBasePath;
  URL := BasePath;
end;


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


{ TSummaryTaskNewRequest }

class function TSummaryTaskNewRequest.BodyClassType: TFieldSetClass;
begin
   result := TSummaryTaskNewBody;
end;


{ TSummaryTaskNewBody }

procedure TSummaryTaskNewBody.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

end;

end.

