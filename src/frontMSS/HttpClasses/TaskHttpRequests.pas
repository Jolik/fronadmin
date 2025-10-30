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
  TaskUnit,
  TaskSourceUnit,
  TaskTypesUnit,
  FuncUnit;

type
  TTaskReqListBody = class(TReqListBody)
  protected
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
  end;

  TTaskListResponse = class(TListResponse)
  private
    function GetTaskList: TTaskList;
  public
    constructor Create;
    property TaskList: TTaskList read GetTaskList;
  end;

  TTaskTypesListResponse = class(TFieldSetListResponse)
  private
    function GetTaskTypesList: TTaskTypesList;
  public
    constructor Create;
    property TaskTypesList: TTaskTypesList read GetTaskTypesList;
  end;

  TTaskInfoResponse = class(TEntityResponse)
  private
    function GetTask: TTask;
  public
    constructor Create;
    property Task: TTask read GetTask;
  end;

  TTaskNewResult = class(TFieldSet)
  private
    FTid: string;
  public
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    property Tid: string read FTid write FTid;
  end;

  TTaskNewResponse = class(TEntityResponse)
  private
    function GetTaskID: string;
  public
    constructor Create;
    property ID: string read GetTaskID;
  end;

  TTaskReqList = class(TReqList)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    function Body: TTaskReqListBody;
  end;

  TTaskTypesReqList = class(TReqList)
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

 
  TTaskNewBody = class(TTask)
  protected
    FSources: TTaskSourceList;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    property Sources: TTaskSourceList read FSources;
  end;

  TTaskUpdateBody = class(TTask)
  private
    FSources: TTaskSourceList;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    property Sources: TTaskSourceList read FSources;
  end;

implementation

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
  inherited Create(TEntity, 'response', 'task');
end;

function TTaskNewResponse.GetTaskID: string;
begin
 Result :=Entity.Id
end;

procedure TTaskNewResult.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  V: TJSONValue;
begin
  inherited Parse(src, APropertyNames);
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

{ New / Update / Remove requests }

class function TTaskReqNew.BodyClassType: TFieldSetClass;
begin
  Result := TTaskNewBody;
end;

constructor TTaskReqNew.Create;
begin
  inherited Create;
  SetEndpoint('tasks/new');
end;

class function TTaskReqUpdate.BodyClassType: TFieldSetClass;
begin
  Result := TTaskUpdateBody;
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

constructor TTaskReqRemove.Create;
begin
  inherited Create;
  SetEndpoint('tasks');
end;

procedure TTaskReqRemove.SetTaskId(const Value: string);
begin
  Id := Value;
end;


{ TTaskNewBody }

constructor TTaskNewBody.Create;
begin
  inherited Create;
  FSources := TTaskSourceList.Create(True);
end;

destructor TTaskNewBody.Destroy;
begin
  FSources.Free;
  inherited;
end;

procedure TTaskNewBody.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  V: TJSONValue;
begin
  Name := GetValueStrDef(src, 'name', '');
  Def := GetValueStrDef(src, 'def', '');
  Module := GetValueStrDef(src, 'module', '');
  Enabled := GetValueBool(src, 'enabled');
  V := src.FindValue('settings');
  if (V is TJSONObject) and Assigned(Settings) then
    Settings.Parse(TJSONObject(V));
  V := src.FindValue('sources');
  if (V is TJSONArray) then
    FSources.ParseList(TJSONArray(V));
end;

procedure TTaskNewBody.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  Arr: TJSONArray;
begin
  dst.AddPair('name', Name);
  if not Def.IsEmpty then
    dst.AddPair('def', Def);
  dst.AddPair('module', Module);
  dst.AddPair('enabled', Enabled);
  if Assigned(Settings) then
    dst.AddPair('settings', Settings.Serialize());
  if not CompId.IsEmpty then dst.AddPair('compid', CompId);
  if not DepId.IsEmpty then dst.AddPair('deptid', DepId);
  if Assigned(FSources) and (FSources.Count > 0) then
  begin
    Arr := TJSONArray.Create;
    FSources.SerializeList(Arr);
    dst.AddPair('sources', Arr);
  end;
end;

{ TTaskUpdateBody }

constructor TTaskUpdateBody.Create;
begin
  inherited Create;
  FSources := TTaskSourceList.Create(True);
end;

destructor TTaskUpdateBody.Destroy;
begin
  FSources.Free;
  inherited;
end;

procedure TTaskUpdateBody.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  V: TJSONValue;
begin
  Name := GetValueStrDef(src, 'name', Name);
  Def := GetValueStrDef(src, 'def', Def);
  if src.FindValue('enabled') <> nil then
    Enabled := GetValueBool(src, 'enabled');
  V := src.FindValue('settings');
  if (V is TJSONObject) and Assigned(Settings) then
    Settings.Parse(TJSONObject(V));
  V := src.FindValue('sources');
  if (V is TJSONArray) then
    FSources.ParseList(TJSONArray(V));
end;

procedure TTaskUpdateBody.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  Arr: TJSONArray;
begin
  if not Name.IsEmpty then
    dst.AddPair('name', Name);
  if not Def.IsEmpty then
    dst.AddPair('def', Def);
  dst.AddPair('enabled', Enabled);
  if Assigned(Settings) then
    dst.AddPair('settings', Settings.Serialize());
  if Assigned(FSources) and (FSources.Count > 0) then
  begin
    Arr := TJSONArray.Create;
    FSources.SerializeList(Arr);
    dst.AddPair('sources', Arr);
  end;
end;


{ TTaskTypesListResponse }

constructor TTaskTypesListResponse.Create;
begin
    inherited Create(TTaskTypesList, 'response', 'types');
end;

function TTaskTypesListResponse.GetTaskTypesList: TTaskTypesList;
begin
   Result := FieldSetList as TTaskTypesList;
end;

{ TTaskTypesReqList }


function TTaskTypesReqList.Body: TTaskReqListBody;
begin
   Result := nil;
end;

class function TTaskTypesReqList.BodyClassType: TFieldSetClass;
begin
   Result := TTaskReqListBody;
end;

constructor TTaskTypesReqList.Create;
begin
  inherited Create;
  Method:= mGET;
  SetEndpoint('tasks/types');

end;

end.


