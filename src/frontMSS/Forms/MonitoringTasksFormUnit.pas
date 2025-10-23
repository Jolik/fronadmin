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
  TasksParentFormUnit,
  MonitoringTasksBrokerUnit, MonitoringTaskSourceBrokerUnit, TaskSourceUnit, uniPanel, uniLabel;

type
  TMonitoringTasksForm = class(TTaskParentForm)
  private
    FSourceTaskBroker: TMonitoringTaskSourcesBroker;

  protected

    function CreateBroker(): TEntityBroker; override;

    function CreateTaskSourcesBroker(): TEntityBroker; override;

    function CreateEditForm(): TParentEditForm; override;

//    procedure UpdateCallback(ASender: TComponent; AResult: Integer);

  public

  end;

function MonitoringTasksForm(): TMonitoringTasksForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, MonitoringTaskEditFormUnit, MonitoringTaskUnit, LoggingUnit, ParentFormUnit;

function MonitoringTasksForm(): TMonitoringTasksForm;
begin
  Result := TMonitoringTasksForm(UniMainModule.GetFormInstance(TMonitoringTasksForm));
end;

{ TMonitoringTasksForm }

function TMonitoringTasksForm.CreateBroker: TEntityBroker;
begin
  ///   ""
  Result := TMonitoringTasksBroker.Create(UniMainModule.CompID,UniMainModule.DeptID);
end;


function TMonitoringTasksForm.CreateEditForm: TParentEditForm;
begin
  ///   ""
  Result := MonitoringTaskEditForm();
end;

function TMonitoringTasksForm.CreateTaskSourcesBroker: TEntityBroker;
begin
  Result:= TMonitoringTaskSourcesBroker.Create();
end;

end.
