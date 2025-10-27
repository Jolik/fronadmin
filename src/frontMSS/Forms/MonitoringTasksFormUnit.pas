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
  EntityBrokerUnit, EntityUnit,
  ParentEditFormUnit,
  TasksParentFormUnit, RestBrokerBaseUnit,
  TaskSourcesRestBrokerUnit, TaskSourceUnit, uniPanel, uniLabel, APIConst;

type
  TMonitoringTasksForm = class(TTaskParentForm)
  private
    FSourceTaskBroker: TMonitoringTaskSourcesBroker;

  protected

    function CreateBroker(): TEntityBroker; override;

    function CreateTaskSourcesBroker(): TTaskSourcesRestBroker; override;

    function CreateEditForm(): TParentEditForm; override;
    function CreateRestBroker(): TRestBrokerBase; override;
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

function TMonitoringTasksForm.CreateBroker: TEntityBroker;
begin
  // Legacy broker not used
  Result := nil;
end;


function TMonitoringTasksForm.CreateEditForm: TParentEditForm;
begin
  ///   ""
  Result := MonitoringTaskEditForm();
end;

function TMonitoringTasksForm.CreateRestBroker: TRestBrokerBase;
begin
  result:= inherited;
  (result as TTasksRestBroker).BasePath:= APIConst.constURLMonitoringBasePath
end;

function TMonitoringTasksForm.CreateTaskSourcesBroker: TTaskSourcesRestBroker;
begin
  Result := TTaskSourcesRestBroker.Create(UniMainModule.XTicket, APIConst.constURLMonitoringBasePath);
end;

end.
