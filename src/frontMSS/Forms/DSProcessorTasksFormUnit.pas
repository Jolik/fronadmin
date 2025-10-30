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
   EntityUnit,
  ParentEditFormUnit, TasksParentFormUnit,  RestEntityBrokerUnit, TasksRestBrokerUnit,
  TaskSourcesRestBrokerUnit, TaskSourceUnit, uniPanel, uniLabel, APIConst;

type
  TDSProcessorTasksForm = class(TTaskParentForm)
  protected
    function CreateRestBroker(): TRestEntityBroker; override;
    function CreateTaskSourcesBroker(): TTaskSourcesRestBroker; override;
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

function TDSProcessorTasksForm.CreateEditForm: TParentEditForm;
begin
  Result := DSProcessorTaskEditForm();
end;

function TDSProcessorTasksForm.CreateRestBroker: TRestEntityBroker;
begin
   result:= inherited;
  (result as TTasksRestBroker).BasePath:=  APIConst.constURLDSProcessBasePath
end;

function TDSProcessorTasksForm.CreateTaskSourcesBroker: TTaskSourcesRestBroker;
begin
  Result := TTaskSourcesRestBroker.Create(UniMainModule.XTicket, APIConst.constURLDSProcessBasePath);
end;

end.
