unit SummaryTasksFormUnit;

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
  TasksParentFormUnit, RestBrokerBaseUnit, SummaryTasksRestBrokerUnit,
  TaskSourcesRestBrokerUnit, TaskSourceUnit, uniPanel, uniLabel, APIConst;

type
  TSummaryTasksForm = class(TTaskParentForm)
  protected
    ///
//    procedure Refresh(const AId: String = ''); override;
    function CreateTaskSourcesBroker(): TTaskSourcesRestBroker; override;
    function CreateEditForm(): TParentEditForm; override;
    function CreateRestBroker(): TRestBrokerBase; override;

//    procedure UpdateCallback(ASender: TComponent; AResult: Integer);

  public

  end;

function SummaryTasksForm(): TSummaryTasksForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, SummaryTaskEditFormUnit, SummaryTaskUnit, LoggingUnit, ParentFormUnit, TasksRestBrokerUnit;

function SummaryTasksForm(): TSummaryTasksForm;
begin
  Result := TSummaryTasksForm(UniMainModule.GetFormInstance(TSummaryTasksForm));
end;


function TSummaryTasksForm.CreateEditForm: TParentEditForm;
begin
  Result := SummaryTaskEditForm();
end;

function TSummaryTasksForm.CreateRestBroker: TRestBrokerBase;
begin
  result:= TSummaryTasksRestBroker.Create(UniMainModule.XTicket);
end;

function TSummaryTasksForm.CreateTaskSourcesBroker: TTaskSourcesRestBroker;
begin
  Result := TTaskSourcesRestBroker.Create(UniMainModule.XTicket, APIConst.constURLSummaryBasePath);
end;

//procedure TSummaryTasksForm.btnUpdateClick(Sender: TObject);
//var
//  SummaryTaskEntity: TEntity;
//  SummaryTask: TSummaryTask;
//  TaskSourcePageCount: Integer;
//  EntityList: TEntityList;
//  TaskSourceList: TTaskSourceList;
//  EditSummaryForm: TSummaryTaskEditForm;
//begin
//  PrepareEditForm;
//
//  FId := FDMemTableEntity.FieldByName('Id').AsString;
//
//  SummaryTaskEntity := Broker.Info(FId);
//  EditForm.Entity := SummaryTaskEntity;
//
//  TaskSourceList := nil;
//
//  if Assigned(FSourceTaskBroker) then
//    FSourceTaskBroker.AddPath := '';
//
//  if Assigned(SummaryTaskEntity) and (SummaryTaskEntity is TSummaryTask) and Assigned(FSourceTaskBroker) then
//  begin
//    SummaryTask := SummaryTaskEntity as TSummaryTask;
//
//    if SummaryTask.Tid <> '' then
//    begin
//      FSourceTaskBroker.AddPath := '/' + SummaryTask.Tid;
//
//      EntityList := nil;
//      try
//        EntityList := FSourceTaskBroker.List(TaskSourcePageCount);
//      except
//        on E: Exception do
//        begin
//          Log('TSummaryTasksForm.btnUpdateClick list error: ' + E.Message, lrtError);
//          EntityList := nil;
//        end;
//      end;
//
//      if Assigned(EntityList) then
//      begin
//        if EntityList is TTaskSourceList then
//        begin
//          TaskSourceList := TTaskSourceList(EntityList);
//          EntityList := nil;
//        end
//        else
//        begin
//          EntityList.Free;
//          TaskSourceList := nil;
//          EntityList := nil;
//        end;
//      end;
//    end;
//  end;
//
//  EditSummaryForm := EditForm as TSummaryTaskEditForm;
//  if Assigned(EditSummaryForm) then
//    EditSummaryForm.TaskSourcesList := TaskSourceList;
//
////  FreeAndNil(FCurrentTaskSourcesList);
////  FCurrentTaskSourcesList := TaskSourceList;
//
//  try
//    EditForm.ShowModal(UpdateCallback);
//  except
//    on E: Exception do
//    begin
//      Log('TSummaryTasksForm.btnUpdateClick show modal error: ' + E.Message, lrtError);
//
//      if Assigned(EditSummaryForm) then
//        EditSummaryForm.TaskSourcesList := nil;
//
////      FreeAndNil(FCurrentTaskSourcesList);
//      raise;
//    end;
//  end;
//end;

//procedure TSummaryTasksForm.UpdateCallback(ASender: TComponent; AResult: Integer);
//var
//  UpdateResult: Boolean;
//  SummaryTask: TSummaryTask;
//  SummaryForm: TSummaryTaskEditForm;
//begin
//  try
//    if AResult = mrOk then
//    begin
//      UpdateResult := Broker.Update(EditForm.Entity);
//      if not UpdateResult then
//        Exit;
//
//      SummaryTask := nil;
//      if EditForm.Entity is TSummaryTask then
//        SummaryTask := TSummaryTask(EditForm.Entity);
//
//      if Assigned(FSourceTaskBroker) and Assigned(FCurrentTaskSourcesList) and Assigned(SummaryTask) then
//      begin
//        FSourceTaskBroker.AddPath := '';
//
//        if SummaryTask.Tid <> '' then
//        begin
//          FSourceTaskBroker.AddPath := '/' + SummaryTask.Tid;
//
//          for var I := 0 to FCurrentTaskSourcesList.Count - 1 do
//          begin
//            var Source := FCurrentTaskSourcesList.Items[I] as TTaskSource;
//            if not Assigned(Source) then
//              Continue;
//
//            try
//              FSourceTaskBroker.Update(Source);
//            except
//              on E: Exception do
//                Log('TSummaryTasksForm.UpdateCallback update source error: ' + E.Message, lrtError);
//            end;
//          end;
//        end;
//      end;
//
//      Refresh();
//
//      if FId = '' then
//        FDMemTableEntity.First
//      else
//        FDMemTableEntity.Locate('Id', FId, []);
//    end;
//  finally
//    if EditForm is TSummaryTaskEditForm then
//    begin
//      SummaryForm := TSummaryTaskEditForm(EditForm);
//      SummaryForm.TaskSourcesList := nil;
//    end;
//
//    FreeAndNil(FCurrentTaskSourcesList);
//  end;
//end;

//procedure TSummaryTasksForm.dbgEntitySelectionChange(Sender: TObject);
//var
//  LEntity : TSummaryTask;
//  LId     : string;
//  DT      : string;
//begin
//  inherited;
//
//  LId := FDMemTableEntity.FieldByName('Id').AsString;
//  ///  ïîëó÷àåì ïîëíóþ èíôîðìàöèþ î ñóùíîñòè îò áðîêåðà
//  LEntity := Broker.Info(LId) as TSummaryTask;
//  lTaskInfoModuleValue.Caption    := LEntity.Module;
//end;

//procedure TSummaryTasksForm.Refresh(const AId: String = '');
//begin
//  inherited Refresh(AId)
//end;

end.
