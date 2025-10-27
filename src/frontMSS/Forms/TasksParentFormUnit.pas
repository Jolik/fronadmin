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
  EntityBrokerUnit, EntityUnit,
  TaskEditParentFormUnit, TaskSourceUnit, ParentEditFormUnit,
  TaskSourcesRestBrokerUnit, TaskSourceHttpRequests,
  TasksRestBrokerUnit, TaskHttpRequests, BaseRequests, RestBrokerBaseUnit;

type
  TTaskParentForm = class(TListParentForm)
    cpTaskInfoModule: TUniContainerPanel;
    lTaskInfoModule: TUniLabel;
    lTaskInfoModuleValue: TUniLabel;
    pSeparator5: TUniPanel;
    procedure btnUpdateClick(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
  protected
    FSourceTaskBroker: TTaskSourcesRestBroker;
    FCurrentTaskSourcesList: TTaskSourceList;

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
  MainModule, uniGUIApplication, LoggingUnit, TaskUnit;

function TasksForm: TTaskParentForm;
begin
  Result := TTaskParentForm(UniMainModule.GetFormInstance(TTaskParentForm));
end;

{ TTaskParentForm }


function TTaskParentForm.CreateRestBroker: TRestBrokerBase;
begin
  Result := TTasksRestBroker.Create(UniMainModule.XTicket);
end;


function TTaskParentForm.CreateTaskSourcesBroker: TTaskSourcesRestBroker;
begin
  Result := TTaskSourcesRestBroker.Create(UniMainModule.XTicket);
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
  ParentTaskEntity: TEntity;
  ParentTask: TTask;
  EntityList: TEntityList;
  TaskSourceList: TTaskSourceList;
  EditParentForm: TTaskEditParentForm;
begin
  PrepareEditForm(true);

  FId := FDMemTableEntity.FieldByName('Id').AsString;
  // Load task entity via REST broker
  if Assigned(RestBroker) then
  begin
    var ReqInfo := RestBroker.CreateReqInfo();
    ReqInfo.Id := FId;
    var RespInfo := RestBroker.Info(ReqInfo);
    ParentTaskEntity := RespInfo.Entity as TEntity;
    EditForm.Entity := ParentTaskEntity;
    // save id explicitly for edit session
    EditForm.Id := FId;
  end
  else
    ParentTaskEntity := nil;

  TaskSourceList := nil;

  if Assigned(ParentTaskEntity) and (ParentTaskEntity is TTask) and Assigned(FSourceTaskBroker) then
  begin
    ParentTask := ParentTaskEntity as TTask;

    if ParentTask.Tid <> '' then
    begin
      // Build REST list request for sources with task tid in path
      var ReqList := FSourceTaskBroker.CreateReqList();
      // Broker is TTaskSourcesRestBroker, so request is TTaskSourceReqList
      TTaskSourceReqList(ReqList).Tid := ParentTask.Tid;
      var RespList := FSourceTaskBroker.List(ReqList as TReqList) as TTaskSourceListResponse;
      EntityList := nil;
      try
        if Assigned(RespList) then
          EntityList := RespList.EntityList;
      except
        on E: Exception do
        begin
          Log('TTaskParentForm.btnUpdateClick list error: ' + E.Message, lrtError);
          EntityList := nil;
        end;
      end;
      RespList.Free;

      if Assigned(EntityList) then
      begin
        if EntityList is TTaskSourceList then
        begin
          TaskSourceList := TTaskSourceList(EntityList);
          EntityList := nil;
        end
        else
        begin
          EntityList.Free;
          TaskSourceList := nil;
          EntityList := nil;
        end;
      end;
    end;
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
  ParentTask: TTask;
  ParentForm: TTaskEditParentForm;
begin
  try
    if AResult = mrOk then
    begin
      if Assigned(RestBroker) then
      begin
        UpdateResult := False;
        var Req := RestBroker.CreateReqUpdate();
        if not Assigned(Req) then
          Req := TReqUpdate.Create;
        try
          // Prefer explicit Id saved in edit form
          if EditForm.Id <> '' then
            Req.Id := EditForm.Id
          else if Assigned(EditForm.Entity) and (EditForm.Entity is TEntity) then
            Req.Id := TEntity(EditForm.Entity).Id;
          if Assigned(Req.ReqBody) and (EditForm.Entity is TFieldSet) then
            TFieldSet(Req.ReqBody).Assign(TFieldSet(EditForm.Entity));
          var JR := RestBroker.Update(Req);
          try
            UpdateResult := True;
          finally
            JR.Free;
          end;
        except
          on E: Exception do
            UpdateResult := False;
        end;
    end;
      // legacy broker removed; rely on REST only
      if not UpdateResult then
        Exit;

      ParentTask := nil;
      if EditForm.Entity is TTask then
        ParentTask := TTask(EditForm.Entity);

      if Assigned(FSourceTaskBroker) and Assigned(FCurrentTaskSourcesList) and Assigned(ParentTask) then
      begin
        if not ParentTask.Tid.IsEmpty then
        begin
          for var I := 0 to FCurrentTaskSourcesList.Count - 1 do
          begin
            var Source := FCurrentTaskSourcesList.Items[I] as TTaskSource;
            if not Assigned(Source) then
              Continue;

            try
              var UB := FSourceTaskBroker;
              var ReqUpd := UB.CreateReqUpdate();
              try
                // Broker is TTaskSourcesRestBroker, so update request is TTaskSourceReqUpdate
                TTaskSourceReqUpdate(ReqUpd).Tid := ParentTask.Tid;
                ReqUpd.Id := Source.Sid;
                if Assigned(ReqUpd.ReqBody) then
                  TFieldSet(ReqUpd.ReqBody).Assign(Source);
                var JR2 := UB.Update(ReqUpd);
                JR2.Free;
              finally
                ReqUpd.Free;
              end;
            except
              on E: Exception do
                Log('TTaskParentForm.UpdateCallback update source error: ' + E.Message, lrtError);
            end;
          end;
        end;
      end;

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

procedure TTaskParentForm.OnInfoUpdated(AEntity: TEntity);
begin
  inherited;
  lTaskInfoModuleValue.Caption    := (AEntity as TTask).Module;
end;


end.


