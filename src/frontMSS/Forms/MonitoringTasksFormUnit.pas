unit MonitoringTasksFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ListParentFormUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniPageControl, uniSplitter, uniBasicGrid, uniDBGrid,
  uniToolBar, uniGUIBaseClasses,
  EntityUnit,
  ParentEditFormUnit,
  TasksParentFormUnit, RestEntityBrokerUnit,
  TaskSourcesRestBrokerUnit, TaskSourceUnit, uniPanel, uniLabel, APIConst;

type
  TMonitoringTasksForm = class(TTaskParentForm)
  protected
    function CreateTaskSourcesBroker(): TTaskSourcesRestBroker; override;
    function CreateEditForm(): TParentEditForm; override;
    function CreateRestBroker(): TRestEntityBroker; override;
//    procedure UpdateCallback(ASender: TComponent; AResult: Integer);

  public

  end;

function MonitoringTasksForm(): TMonitoringTasksForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, MonitoringTaskEditFormUnit, MonitoringTaskUnit, LoggingUnit, ParentFormUnit,
  TasksRestBrokerUnit;

function MonitoringTasksForm(): TMonitoringTasksForm;
begin
  Result := TMonitoringTasksForm(UniMainModule.GetFormInstance(TMonitoringTasksForm));
end;

{ TMonitoringTasksForm }

function TMonitoringTasksForm.CreateEditForm: TParentEditForm;
begin
  ///   ""
  Result := MonitoringTaskEditForm();
end;

function TMonitoringTasksForm.CreateRestBroker: TRestEntityBroker;
begin
  result:= inherited;
  (result as TTasksRestBroker).BasePath:= APIConst.constURLMonitoringBasePath
end;

function TMonitoringTasksForm.CreateTaskSourcesBroker: TTaskSourcesRestBroker;
begin
  Result := TTaskSourcesRestBroker.Create(UniMainModule.XTicket, APIConst.constURLMonitoringBasePath);
end;

end.
