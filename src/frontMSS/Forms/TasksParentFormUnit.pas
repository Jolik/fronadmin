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
  EntityBrokerUnit, EntityUnit, TaskUnit,
  TaskEditParentFormUnit, TaskSourceUnit, ParentEditFormUnit,
  TaskSourcesRestBrokerUnit, TaskSourceHttpRequests, TaskTypesUnit,
  TasksRestBrokerUnit, TaskHttpRequests, BaseRequests, RestBrokerBaseUnit;

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
    function GetModuleCaption(module:string):string;
    function GetTaskBroker: TTasksRestBroker;
    procedure OnCreate; override;
    procedure UpdateTaskTypes;
    procedure OnAddListItem(item: TEntity);override;
    procedure OnInfoUpdated(AEntity: TEntity);override;
    ///
    function CreateRestBroker(): TRestBrokerBase; override;
    function CreateTaskSourcesBroker(): TTaskSourcesRestBroker; virtual;
    ///
    function CreateEditForm(): TParentEditForm; override;

    procedure UpdateCallback(ASender: TComponent; AResult: Integer);

  public

  end;

function TasksForm: TTaskParentForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, LoggingUnit;

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


function TTaskParentForm.CreateRestBroker: TRestBrokerBase;
begin
  Result := TTasksRestBroker.Create(UniMainModule.XTicket) as TRestBrokerBase;
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
      if Assigned(RespList) and Assigned(RespList.EntityList) then
      begin
        TaskSourceList := TTaskSourceList.Create(True);
        for var J := 0 to TTaskSourceList(RespList.EntityList).Count - 1 do
        begin
          if TTaskSourceList(RespList.EntityList).Items[J] is TTaskSource then
          begin
            var Src := TTaskSource(TTaskSourceList(RespList.EntityList).Items[J]);
            var CopySrc := TTaskSource.Create;
            try
              CopySrc.Assign(Src);
              TaskSourceList.Add(CopySrc);
            except
              CopySrc.Free;
              raise;
            end;
          end;
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
  if Assigned(EditParentForm) then
    EditParentForm.TaskSourcesList := TaskSourceList;

  FreeAndNil(FCurrentTaskSourcesList);
  FCurrentTaskSourcesList := TaskSourceList;

  try
    EditForm.ShowModal(UpdateCallback);
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

procedure TTaskParentForm.UpdateCallback(ASender: TComponent; AResult: Integer);
var
  UpdateResult: Boolean;
  ParentForm: TTaskEditParentForm;
begin
  try
    if AResult = mrOk then
    begin
      UpdateResult := False;
      if Assigned(RestBroker) then
      begin
        var Req := RestBroker.CreateReqUpdate();
        if not Assigned(Req) then
          Req := TReqUpdate.Create;
        try
          // Prefer explicit Id saved in edit form
          if EditForm.Id <> '' then
            Req.Id := EditForm.Id
          else if Assigned(EditForm.Entity) and (EditForm.Entity is TEntity) then
            Req.Id := TEntity(EditForm.Entity).Id;

          // Assign scalar fields from edited entity
          if Assigned(Req.ReqBody) and (EditForm.Entity is TFieldSet) then
            TFieldSet(Req.ReqBody).Assign(TFieldSet(EditForm.Entity));

          // Populate sources[] into task update body (Go schema)
          if (Req.ReqBody is TTaskUpdateBody) then
          begin
            var UB := TTaskUpdateBody(Req.ReqBody);
            if Assigned(UB.Sources) then
            begin
              UB.Sources.Clear;
              if Assigned(FCurrentTaskSourcesList) then
                for var I := 0 to FCurrentTaskSourcesList.Count - 1 do
                begin
                  if not (FCurrentTaskSourcesList.Items[I] is TTaskSource) then
                    Continue;
                  var Src := TTaskSource(FCurrentTaskSourcesList.Items[I]);
                  var NewSrc := TNewTaskSource.Create;
                  NewSrc.Sid := Src.Sid;
                  NewSrc.Name := Src.Name;
                  NewSrc.Enabled := Src.Enabled;
                  UB.Sources.Add(NewSrc);
                end;
            end;
          end;

          var JR := RestBroker.Update(Req);
          try
            UpdateResult := Assigned(JR) and (JR.StatusCode = 200);
          finally
            JR.Free;
          end;
        except
          on E: Exception do
            UpdateResult := False;
        end;
      end;

      if not UpdateResult then Exit;

      Refresh();

      if FId = '' then
        FDMemTableEntity.First
      else
        FDMemTableEntity.Locate('Id', FId, []);
    end;
  finally
    if EditForm is TTaskEditParentForm then
    begin
      ParentForm := TTaskEditParentForm(EditForm);
      ParentForm.TaskSourcesList := nil;
    end;
    FreeAndNil(FCurrentTaskSourcesList);
  end;
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


end.










