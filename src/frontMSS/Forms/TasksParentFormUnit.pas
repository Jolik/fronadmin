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
  TaskEditParentFormUnit, TaskSourceUnit, TaskSourcesBrokerUnit, ParentEditFormUnit;

type
  TTaskParentForm = class(TListParentForm)
    cpTaskInfoModule: TUniContainerPanel;
    lTaskInfoModule: TUniLabel;
    lTaskInfoModuleValue: TUniLabel;
    pSeparator5: TUniPanel;
    procedure btnUpdateClick(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
    procedure dbgEntitySelectionChange(Sender: TObject);
  private
    FSourceTaskBroker: TTaskSourcesBroker;
    FCurrentTaskSourcesList: TTaskSourceList;
  protected
    procedure Refresh(const AId: String = ''); override;

    ///
    function CreateBroker(): TEntityBroker; override;

    function CreateTaskSourcesBroker(): TEntityBroker; virtual;
    ///
    function CreateEditForm(): TParentEditForm; override;

    procedure UpdateCallback(ASender: TComponent; AResult: Integer);

  public

  end;

function TasksForm: TTaskParentForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, LoggingUnit, TasksBrokerUnit, TaskUnit;

function TasksForm: TTaskParentForm;
begin
  Result := TTaskParentForm(UniMainModule.GetFormInstance(TTaskParentForm));
end;

{ TTaskParentForm }


function TTaskParentForm.CreateBroker: TEntityBroker;
begin
  ///   ""
  Result := TTasksBroker.Create(UniMainModule.CompID,UniMainModule.DeptID);
end;


function TTaskParentForm.CreateEditForm: TParentEditForm;
begin
   Result := ParentTaskEditForm() as TParentEditForm;
end;

function TTaskParentForm.CreateTaskSourcesBroker: TEntityBroker;
begin
  FSourceTaskBroker := TTaskSourcesBroker.Create();
end;

procedure TTaskParentForm.UniFormCreate(Sender: TObject);
begin
  inherited;
  FSourceTaskBroker:= CreateTaskSourcesBroker() as TTaskSourcesBroker;
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
  TaskSourcePageCount: Integer;
  EntityList: TEntityList;
  TaskSourceList: TTaskSourceList;
  EditParentForm: TTaskEditParentForm;
begin
  PrepareEditForm(true);

  FId := FDMemTableEntity.FieldByName('Id').AsString;

  ParentTaskEntity := Broker.Info(FId);
  EditForm.Entity := ParentTaskEntity;

  TaskSourceList := nil;

  if Assigned(FSourceTaskBroker) then
    FSourceTaskBroker.AddPath := '';

  if Assigned(ParentTaskEntity) and (ParentTaskEntity is TTask) and Assigned(FSourceTaskBroker) then
  begin
    ParentTask := ParentTaskEntity as TTask;

    if ParentTask.Tid <> '' then
    begin
      FSourceTaskBroker.AddPath := '/' + ParentTask.Tid;

      EntityList := nil;
      try
        EntityList := FSourceTaskBroker.List(TaskSourcePageCount);
      except
        on E: Exception do
        begin
          Log('TTaskParentForm.btnUpdateClick list error: ' + E.Message, lrtError);
          EntityList := nil;
        end;
      end;

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
      UpdateResult := Broker.Update(EditForm.Entity);
      if not UpdateResult then
        Exit;

      ParentTask := nil;
      if EditForm.Entity is TTask then
        ParentTask := TTask(EditForm.Entity);

      if Assigned(FSourceTaskBroker) and Assigned(FCurrentTaskSourcesList) and Assigned(ParentTask) then
      begin
        FSourceTaskBroker.AddPath := '';

        if ParentTask.Tid <> '' then
        begin
          FSourceTaskBroker.AddPath := '/' + ParentTask.Tid;

          for var I := 0 to FCurrentTaskSourcesList.Count - 1 do
          begin
            var Source := FCurrentTaskSourcesList.Items[I] as TTaskSource;
            if not Assigned(Source) then
              Continue;

            try
              FSourceTaskBroker.Update(Source);
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

procedure TTaskParentForm.dbgEntitySelectionChange(Sender: TObject);
var
  LEntity : TTask;
  LId     : string;
  DT      : string;
begin
  inherited;

  LId := FDMemTableEntity.FieldByName('Id').AsString;
  ///  ???????? ?????? ?????????? ? ???????? ?? ???????
  LEntity := Broker.Info(LId) as TTask;
  lTaskInfoModuleValue.Caption    := LEntity.Module;
end;

procedure TTaskParentForm.Refresh(const AId: String = '');
begin
  inherited Refresh(AId)
end;

end.
