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
  ParentEditFormUnit, TasksParentFormUnit,
  DSProcessorTasksBrokerUnit, DSProcessorTaskSourceBrokerUnit, TaskSourceUnit, uniPanel, uniLabel;

type
  TDSProcessorTasksForm = class(TTaskParentForm)
  protected
    function CreateBroker(): TEntityBroker; override;
    function CreateTaskSourcesBroker(): TEntityBroker; override;
    function CreateEditForm(): TParentEditForm; override;
  public

  end;

function DSProcessorTasksForm(): TDSProcessorTasksForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, DSProcessorTaskEditFormUnit, DSProcessorTaskUnit, LoggingUnit, ParentFormUnit;

function DSProcessorTasksForm(): TDSProcessorTasksForm;
begin
  Result := TDSProcessorTasksForm(UniMainModule.GetFormInstance(TDSProcessorTasksForm));
end;

{ TDSProcessorTasksForm }

function TDSProcessorTasksForm.CreateBroker: TEntityBroker;
begin
  Result := TDSProcessorTasksBroker.Create(UniMainModule.CompID,UniMainModule.DeptID);
end;


function TDSProcessorTasksForm.CreateEditForm: TParentEditForm;
begin
  Result := DSProcessorTaskEditForm();
end;

function TDSProcessorTasksForm.CreateTaskSourcesBroker: TEntityBroker;
begin
  Result:= TDSProcessorTaskSourcesBroker.Create();
end;

end.
