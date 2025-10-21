unit DSProcessorTasksFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ListParentFormUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniPageControl, uniSplitter, uniBasicGrid, uniDBGrid,
  uniToolBar, uniGUIBaseClasses,
  EntityBrokerUnit, EntityUnit,
  ParentEditFormUnit,
  DSProcessorTasksBrokerUnit, DSProcessorTaskSourceBrokerUnit, TaskSourceUnit, uniPanel, uniLabel;

type
  TDSProcessorTasksForm = class(TListParentForm)
    cpTaskInfoModule: TUniContainerPanel;
    lTaskInfoModule: TUniLabel;
    lTaskInfoModuleValue: TUniLabel;
    pSeparator5: TUniPanel;
    procedure btnUpdateClick(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
    procedure dbgEntitySelectionChange(Sender: TObject);
  private
    FSourceTaskBroker: TDSProcessorTaskSourcesBroker;
    FCurrentTaskSourcesList: TTaskSourceList;
  protected
    procedure Refresh(const AId: String = ''); override;
    function CreateBroker(): TEntityBroker; override;
    function CreateEditForm(): TParentEditForm; override;
    procedure UpdateCallback(ASender: TComponent; AResult: Integer);
  public

  end;

function DSProcessorTasksForm: TDSProcessorTasksForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, DSProcessorTaskEditFormUnit, DSProcessorTaskUnit, LoggingUnit;

function DSProcessorTasksForm: TDSProcessorTasksForm;
begin
  Result := TDSProcessorTasksForm(UniMainModule.GetFormInstance(TDSProcessorTasksForm));
end;

{ TDSProcessorTasksForm }

function TDSProcessorTasksForm.CreateBroker: TEntityBroker;
begin
  Result := TDSProcessorTasksBroker.Create();
end;

function TDSProcessorTasksForm.CreateEditForm: TParentEditForm;
begin
  Result := DSProcessorTaskEditForm();
end;

procedure TDSProcessorTasksForm.UniFormCreate(Sender: TObject);
begin
  inherited;

  FSourceTaskBroker := TDSProcessorTaskSourcesBroker.Create();
  FCurrentTaskSourcesList := nil;
end;

procedure TDSProcessorTasksForm.UniFormDestroy(Sender: TObject);
begin
  FreeAndNil(FCurrentTaskSourcesList);
  FreeAndNil(FSourceTaskBroker);

  inherited;
end;

procedure TDSProcessorTasksForm.btnUpdateClick(Sender: TObject);
var
  DSProcessorTaskEntity: TEntity;
  DSProcessorTask: TDSProcessorTask;
  TaskSourcePageCount: Integer;
  EntityList: TEntityList;
  TaskSourceList: TTaskSourceList;
  EditDSProcessorForm: TDSProcessorTaskEditForm;
begin
  PrepareEditForm;

  FId := FDMemTableEntity.FieldByName('Id').AsString;

  DSProcessorTaskEntity := Broker.Info(FId);
  EditForm.Entity := DSProcessorTaskEntity;

  TaskSourceList := nil;

  if Assigned(FSourceTaskBroker) then
    FSourceTaskBroker.AddPath := '';

  if Assigned(DSProcessorTaskEntity) and (DSProcessorTaskEntity is TDSProcessorTask) and Assigned(FSourceTaskBroker) then
  begin
    DSProcessorTask := DSProcessorTaskEntity as TDSProcessorTask;

    if DSProcessorTask.Tid <> '' then
    begin
      FSourceTaskBroker.AddPath := '/' + DSProcessorTask.Tid;

      EntityList := nil;
      try
        EntityList := FSourceTaskBroker.List(TaskSourcePageCount);
      except
        on E: Exception do
        begin
          Log('TDSProcessorTasksForm.btnUpdateClick list error: ' + E.Message, lrtError);
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

  EditDSProcessorForm := EditForm as TDSProcessorTaskEditForm;
  if Assigned(EditDSProcessorForm) then
    EditDSProcessorForm.TaskSourcesList := TaskSourceList;

  FreeAndNil(FCurrentTaskSourcesList);
  FCurrentTaskSourcesList := TaskSourceList;

  try
    EditForm.ShowModal(UpdateCallback);
  except
    on E: Exception do
    begin
      Log('TDSProcessorTasksForm.btnUpdateClick show modal error: ' + E.Message, lrtError);

      if Assigned(EditDSProcessorForm) then
        EditDSProcessorForm.TaskSourcesList := nil;

      FreeAndNil(FCurrentTaskSourcesList);
      raise;
    end;
  end;
end;

procedure TDSProcessorTasksForm.UpdateCallback(ASender: TComponent;
  AResult: Integer);
var
  UpdateResult: Boolean;
  DSProcessorTask: TDSProcessorTask;
  DSProcessorForm: TDSProcessorTaskEditForm;
begin
  try
    if AResult = mrOk then
    begin
      UpdateResult := Broker.Update(EditForm.Entity);
      if not UpdateResult then
        Exit;

      DSProcessorTask := nil;
      if EditForm.Entity is TDSProcessorTask then
        DSProcessorTask := TDSProcessorTask(EditForm.Entity);

      if Assigned(FSourceTaskBroker) and Assigned(FCurrentTaskSourcesList) and Assigned(DSProcessorTask) then
      begin
        FSourceTaskBroker.AddPath := '';

        if DSProcessorTask.Tid <> '' then
        begin
          FSourceTaskBroker.AddPath := '/' + DSProcessorTask.Tid;

          for var I := 0 to FCurrentTaskSourcesList.Count - 1 do
          begin
            var Source := FCurrentTaskSourcesList.Items[I] as TTaskSource;
            if not Assigned(Source) then
              Continue;

            try
              FSourceTaskBroker.Update(Source);
            except
              on E: Exception do
                Log('TDSProcessorTasksForm.UpdateCallback update source error: ' + E.Message, lrtError);
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
    if EditForm is TDSProcessorTaskEditForm then
    begin
      DSProcessorForm := TDSProcessorTaskEditForm(EditForm);
      DSProcessorForm.TaskSourcesList := nil;
    end;

    FreeAndNil(FCurrentTaskSourcesList);
  end;
end;

procedure TDSProcessorTasksForm.dbgEntitySelectionChange(Sender: TObject);
var
  LEntity: TDSProcessorTask;
  LId: string;
  DT: string;
begin
  inherited;

  LId := FDMemTableEntity.FieldByName('Id').AsString;
  LEntity := Broker.Info(LId) as TDSProcessorTask;
  lTaskInfoModuleValue.Caption := LEntity.Module;
end;

procedure TDSProcessorTasksForm.Refresh(const AId: String);
begin
  inherited Refresh(AId);
end;

end.
