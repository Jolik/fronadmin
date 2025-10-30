unit StripTasksFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ListParentFormUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniPageControl, uniSplitter, uniBasicGrid, uniDBGrid,
  uniToolBar, uniGUIBaseClasses,
  
  ParentEditFormUnit, TasksParentFormUnit, RestEntityBrokerUnit, TasksRestBrokerUnit,
  TaskSourcesRestBrokerUnit, uniPanel, uniLabel, APIConst;

type
  TStripTasksForm = class(TTaskParentForm)
  private

  protected
    procedure OnCreate; override;
    ///  функция обновления компоннет на форме
    procedure Refresh(const AId: String = ''); override;

    ///  функция для создания нужного брокера потоком
    function CreateRestBroker(): TRestEntityBroker; override;
    ///  функиця для создания нужной формы редактирвоания
    function CreateEditForm(): TParentEditForm; override;

    function CreateTaskSourcesBroker(): TTaskSourcesRestBroker; override;

  public

  end;

function StripTasksForm: TStripTasksForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, StripTaskEditFormUnit, StripTaskUnit;

function StripTasksForm: TStripTasksForm;
begin
  Result := TStripTasksForm(UniMainModule.GetFormInstance(TStripTasksForm));
end;

{ TStripTasksForm }
function TStripTasksForm.CreateEditForm: TParentEditForm;
begin
  ///  создаем "нашу" форму редактирования для Задач
  Result := StripTaskEditForm();
end;

function TStripTasksForm.CreateRestBroker: TRestEntityBroker;
begin
   result:= inherited;
  (result as TTasksRestBroker).BasePath:=  APIConst.constURLStripBasePath;
end;

function TStripTasksForm.CreateTaskSourcesBroker: TTaskSourcesRestBroker;
begin
Result := TTaskSourcesRestBroker.Create(UniMainModule.XTicket, APIConst.constURLStripBasePath);
end;

procedure TStripTasksForm.OnCreate;
begin
  FEnabledTaskTypes:= true;
  inherited;

end;

procedure TStripTasksForm.Refresh(const AId: String = '');
begin
  inherited Refresh(AId)
end;

end.
