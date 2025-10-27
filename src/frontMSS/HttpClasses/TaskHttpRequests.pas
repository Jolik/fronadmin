unit TaskHttpRequests;

interface

uses
  System.SysUtils,
  System.JSON,
  EntityUnit,
  HttpClientUnit,
  StringListUnit,
  BaseRequests,
  BaseResponses,
  TaskUnit;

type
  // Тело запроса списка задач
  TTaskReqListBody = class(TReqListBody)
  protected
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
  end;

  // Ответ: список задач
  TTaskListResponse = class(TListResponse)
  private
    function GetTaskList: TTaskList;
  public
    constructor Create;
    property TaskList: TTaskList read GetTaskList;
  end;

  // Ответ: одна задача
  TTaskInfoResponse = class(TEntityResponse)
  private
    function GetTask: TTask;
  public
    constructor Create;
    property Task: TTask read GetTask;
  end;

  // Create: response for new task
  TTaskNewResult = class(TFieldSet)
  private
    FTid: string;
  public
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    property Tid: string read FTid write FTid;
  end;

  TTaskNewResponse = class(TFieldSetResponse)
  private
    function GetTaskNewRes: TTaskNewResult;
  public
    constructor Create; virtual;
    property TaskNewRes: TTaskNewResult read GetTaskNewRes;
  end;

  // Запросы
  TTaskReqList = class(TReqList)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    function Body: TTaskReqListBody;
  end;

  TTaskReqInfo = class(TReqInfo)
  public
    constructor Create; override;
    constructor CreateID(const ATaskId: string);
  end;

  TTaskReqNew = class(TReqNew)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TTaskReqUpdate = class(TReqUpdate)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    procedure SetTaskId(const Value: string);
  end;

  TTaskReqRemove = class(TReqRemove)
  public
    constructor Create; override;
    procedure SetTaskId(const Value: string);
  end;

implementation

uses
  APIConst, FuncUnit;

{ TTaskListResponse }

constructor TTaskListResponse.Create;
begin
  inherited Create(TTaskList, 'response', 'tasks');
end;

function TTaskListResponse.GetTaskList: TTaskList;
begin
  Result := EntityList as TTaskList;
end;

{ TTaskInfoResponse }

constructor TTaskInfoResponse.Create;
begin
  inherited Create(TTask, 'response', 'task');
end;

function TTaskInfoResponse.GetTask: TTask;
begin
  Result := Entity as TTask;
end;

{ TTaskNewResponse / TTaskNewResult }

constructor TTaskNewResponse.Create;
begin
  inherited Create(TTaskNewResult, 'response', '');
end;

function TTaskNewResponse.GetTaskNewRes: TTaskNewResult;
begin
  if FieldSet is TTaskNewResult then
    Result := TTaskNewResult(FieldSet)
  else
    Result := nil;
end;

procedure TTaskNewResult.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  V: TJSONValue;
begin
  inherited Parse(src, APropertyNames);
  if not Assigned(src) then Exit;
  FTid := '';
  V := src.Values['tid'];
  if V is TJSONString then
    FTid := TJSONString(V).Value
  else if Assigned(V) then
    FTid := V.ToString;
end;

procedure TTaskNewResult.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then Exit;
  inherited Serialize(dst, APropertyNames);
  dst.AddPair('tid', TJSONString.Create(FTid));
end;

{ TTaskReqList }

class function TTaskReqList.BodyClassType: TFieldSetClass;
begin
  Result := TTaskReqListBody;
end;

constructor TTaskReqList.Create;
begin
  inherited Create;
  SetEndpoint('tasks/list');
end;

function TTaskReqList.Body: TTaskReqListBody;
begin
  if ReqBody is TTaskReqListBody then
    Result := TTaskReqListBody(ReqBody)
  else
    Result := nil;
end;

{ TTaskReqListBody }

procedure TTaskReqListBody.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  Arr: TJSONArray;
begin
  inherited Serialize(dst, APropertyNames);
  // Ensure default ordering for tasks only
  if dst.Values['order'] = nil then
  begin
    Arr := TJSONArray.Create;
    Arr.Add('name');
    dst.AddPair('order', Arr);
  end;
  if dst.Values['orderDir'] = nil then
    dst.AddPair('orderDir', 'asc');
end;

{ TTaskReqInfo }

constructor TTaskReqInfo.Create;
begin
  inherited Create;
  SetEndpoint('tasks');
end;

constructor TTaskReqInfo.CreateID(const ATaskId: string);
begin
  Create;
  Id := ATaskId;
end;

{ TTaskReqNew }

class function TTaskReqNew.BodyClassType: TFieldSetClass;
begin
  Result := TTask; // позволим сериализовать задачу напрямую
end;

constructor TTaskReqNew.Create;
begin
  inherited Create;
  SetEndpoint('tasks/new');
end;

{ TTaskReqUpdate }

class function TTaskReqUpdate.BodyClassType: TFieldSetClass;
begin
  Result := TTask;
end;

constructor TTaskReqUpdate.Create;
begin
  inherited Create;
  SetEndpoint('tasks');
end;

procedure TTaskReqUpdate.SetTaskId(const Value: string);
begin
  Id := Value;
end;

{ TTaskReqRemove }

constructor TTaskReqRemove.Create;
begin
  inherited Create;
  SetEndpoint('tasks');
end;

procedure TTaskReqRemove.SetTaskId(const Value: string);
begin
  Id := Value;
end;

end.




