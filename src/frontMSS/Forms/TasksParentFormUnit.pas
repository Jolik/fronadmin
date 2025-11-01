unit TasksParentFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ListParentFormUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniPanel, uniLabel, uniPageControl, uniSplitter,
  uniBasicGrid, uniDBGrid, uniToolBar, uniGUIBaseClasses,
  EntityUnit, TaskUnit,
  TaskEditParentFormUnit, TaskSourceUnit, ParentEditFormUnit,
  TaskSourcesRestBrokerUnit, TaskSourceHttpRequests, TaskTypesUnit,
  TasksRestBrokerUnit, TaskHttpRequests, BaseRequests, RestEntityBrokerUnit;

type
  TTaskParentForm = class(TListParentForm)
    cpTaskInfoModule: TUniContainerPanel;
    lTaskInfoModule: TUniLabel;
    lTaskInfoModuleValue: TUniLabel;
    pSeparator5: TUniPanel;
    FDMemTableEntitymodule: TStringField;
    FDMemTableEntityenabled: TBooleanField;
    procedure btnUpdateClick(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
  protected
    FEnabledTaskTypes:boolean;
    FTaskTypesList: TTaskTypesList;
    FSourceTaskBroker: TTaskSourcesRestBroker;
    FCurrentTaskSourcesList: TTaskSourceList;
    function SaveTaskCommon(IsNew: Boolean; const AID: string; AEntity: TFieldSet): Boolean;
    function GetModuleCaption(module:string):string;
    function GetTaskBroker: TTasksRestBroker;
    procedure OnCreate; override;
    procedure UpdateTaskTypes;
    procedure OnAddListItem(item: TEntity);override;
    procedure OnInfoUpdated(AEntity: TEntity);override;
    ///
    function CreateRestBroker(): TRestEntityBroker; override;
    function CreateTaskSourcesBroker(): TTaskSourcesRestBroker; virtual;
    function CreateEditForm(): TParentEditForm; override;

    function NewCallback(const AID: string; AEntity: TFieldSet):boolean;
    function UpdateCallback(const AID: string; AEntity: TFieldSet):Boolean;

  public

  end;

function TasksForm: TTaskParentForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, LoggingUnit, HttpClientUnit;

function TasksForm: TTaskParentForm;
begin
  Result := TTaskParentForm(UniMainModule.GetFormInstance(TTaskParentForm));
  Result.FSelectedEntity:= nil;
end;

{ TTaskParentForm }

procedure TTaskParentForm.UpdateTaskTypes;
begin
   var req := GetTaskBroker.CreateTypesReqList;
   var resp := GetTaskBroker.TypesList(req);
   FTaskTypesList:= resp.TaskTypesList;

end;


function TTaskParentForm.CreateRestBroker: TRestEntityBroker;
begin
  Result := TTasksRestBroker.Create(UniMainModule.XTicket);
end;


function TTaskParentForm.CreateTaskSourcesBroker: TTaskSourcesRestBroker;
begin
  Result := TTaskSourcesRestBroker.Create(UniMainModule.XTicket);
end;

function TTaskParentForm.GetModuleCaption(module:string): string;
begin
  result:= module;
  if not FEnabledTaskTypes  then exit;
  
  for var ttype  in FTaskTypesList do
  with ttype as TTaskTypes do
  begin
    if Name = module  then
    begin
      Result:= Caption;
      exit;
    end;
  end;
end;

function TTaskParentForm.GetTaskBroker: TTasksRestBroker;
begin
  Result:= RestBroker as TTasksRestBroker;

end;

function TTaskParentForm.NewCallback(const AID: string;
  AEntity: TFieldSet): boolean;
begin
   Result := SaveTaskCommon(True, AID, AEntity);
end;

function TTaskParentForm.CreateEditForm: TParentEditForm;
begin
   Result := ParentTaskEditForm() as TParentEditForm;
end;


procedure TTaskParentForm.UniFormCreate(Sender: TObject);
begin
  inherited;
  FSourceTaskBroker := CreateTaskSourcesBroker();
  FCurrentTaskSourcesList := nil;
end;

procedure TTaskParentForm.UniFormDestroy(Sender: TObject);
begin
  FreeAndNil(FCurrentTaskSourcesList);
  FreeAndNil(FSourceTaskBroker);

  inherited;
end;

procedure TTaskParentForm.btnUpdateClick(Sender: TObject);
var
  TaskSourceList: TTaskSourceList;
  EditParentForm: TTaskEditParentForm;
begin

  if not Assigned(FSelectedEntity) or (FSelectedEntity.Id='') then  Exit;

  PrepareEditForm(true);
  TaskSourceList := nil;

  if  Assigned(FSourceTaskBroker) then
  begin
    // Build REST list request for sources with task tid in path
    var ReqList := FSourceTaskBroker.CreateReqList();
    // Broker is TTaskSourcesRestBroker, so request is TTaskSourceReqList
    TTaskSourceReqList(ReqList).Tid := (FSelectedEntity as TTask).Tid;
    var RespList := FSourceTaskBroker.List(ReqList as TReqList) as TTaskSourceListResponse;
    try
      if Assigned(RespList) and Assigned(RespList.FieldSetList) then
      begin
        TaskSourceList := TTaskSourceList.Create(True);
        for var J := 0 to RespList.TaskSourceList.Count - 1 do
        begin
          var Src := RespList.TaskSourceList.Items[J] ;
          var newSrc := TTaskSource.Create();
          newSrc.Assign(Src);
          TaskSourceList.Add(newSrc);
        end;
      end
      else
        TaskSourceList := nil;
    except
      on E: Exception do
      begin
        Log('TTaskParentForm.btnUpdateClick list error: ' + E.Message, lrtError);
        FreeAndNil(TaskSourceList);
      end;
    end;
    RespList.Free;
  end;

  EditParentForm := EditForm as TTaskEditParentForm;
  if Assigned(EditParentForm) then begin
    EditParentForm.TaskSourcesList := TaskSourceList;
    EditParentForm.Entity:= FSelectedEntity;
  end;

  FreeAndNil(FCurrentTaskSourcesList);
  FCurrentTaskSourcesList := TaskSourceList;

  try
    EditForm.ShowModalEx(UpdateCallback);
  except
    on E: Exception do
    begin
      Log('TTaskParentForm.btnUpdateClick show modal error: ' + E.Message, lrtError);

      if Assigned(EditParentForm) then
        EditParentForm.TaskSourcesList := nil;

      FreeAndNil(FCurrentTaskSourcesList);
      raise;
    end;
  end;
end;

function TTaskParentForm.UpdateCallback(const AID: string; AEntity: TFieldSet):Boolean;
begin
 result:=  SaveTaskCommon(False, AID, AEntity);
end;

procedure TTaskParentForm.OnAddListItem(item: TEntity);
begin
  inherited;
  with Item as TTask do
  begin
    FDMemTableEntity.FieldByName('module').AsString := GetModuleCaption(module);
    FDMemTableEntity.FieldByName('enabled').AsBoolean := Enabled;
  end;
end;

procedure TTaskParentForm.OnCreate;
begin
  If FEnabledTaskTypes then
    UpdateTaskTypes;
end;

procedure TTaskParentForm.OnInfoUpdated(AEntity: TEntity);
begin
  inherited;
  lTaskInfoModuleValue.Caption := (AEntity as TTask).Module;
end;

function TTaskParentForm.SaveTaskCommon(IsNew: Boolean; const AID: string; AEntity: TFieldSet): Boolean;
var
  Req: TBaseServiceRequest;
  JR: TJSONResponse;
begin
  Result := False;

  if not Assigned(RestBroker) then
    Exit;

  try
    // Создаём запрос
    if IsNew then
      Req := RestBroker.CreateReqNew
    else
      Req := RestBroker.CreateReqUpdate;

    if not Assigned(Req) then
      Exit;


    // Заполняем ID, если есть
    if not IsNew then
    with (Req as TReqUpdate) do begin
      if EditForm.Id <> '' then
        Id := EditForm.Id
      else if Assigned(EditForm.Entity) and (EditForm.Entity is TEntity) then
        Id := TEntity(EditForm.Entity).Id;
    end;

    // Копируем поля из формы в тело запроса
    if Assigned(Req.ReqBody) and (AEntity is TFieldSet) then
      TFieldSet(Req.ReqBody).Assign(AEntity);

    // Собираем sources[]
    var taskBody := TTaskUpdateBody(Req.ReqBody);
    if Assigned(taskBody.Sources) then
    begin
      taskBody.Sources.OwnsObjects:=false;
      var tsrList := (EditForm as TTaskEditParentForm).TaskSourcesList;
      taskBody.Sources.AddRange(tsrList)
    end;


    // Отправляем запрос
    if IsNew then
      JR := RestBroker.New(Req as TReqNew)
    else
      JR := RestBroker.Update(Req as TReqUpdate);

    Result := Assigned(JR) and (JR.StatusCode = 200);
    JR.Free;

  except
    on E: Exception do
    begin
      Log('TTaskParentForm.SaveTaskCommon error: ' + E.Message, lrtError);
      Result := False;
    end;
  end;

  if Result then
    Refresh;
end;

end.










