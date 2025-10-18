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
  EntityBrokerUnit,
  ParentEditFormUnit,
  StripTasksBrokerUnit, uniPanel, uniLabel;

type
  TStripTasksForm = class(TListParentForm)
    cpTaskInfoModule: TUniContainerPanel;
    lTaskInfoModule: TUniLabel;
    lTaskInfoModuleValue: TUniLabel;
    pSeparator5: TUniPanel;
    procedure dbgEntitySelectionChange(Sender: TObject);
  private

  protected
    ///  функция обновления компоннет на форме
    procedure Refresh(const AId: String = ''); override;

    ///  функция для создания нужного брокера потоком
    function CreateBroker(): TEntityBroker; override;

    ///  функиця для создания нужной формы редактирвоания
    function CreateEditForm(): TParentEditForm; override;

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
function TStripTasksForm.CreateBroker: TEntityBroker;
begin
  ///  создаем "наш" брокер для Задач
  Result := TStripTasksBroker.Create();
end;


function TStripTasksForm.CreateEditForm: TParentEditForm;
begin
  ///  создаем "нашу" форму редактирования для Задач
  Result := StripTaskEditForm();
end;

procedure TStripTasksForm.dbgEntitySelectionChange(Sender: TObject);
var
  LEntity : TStripTask;
  LId     : string;
  DT      : string;
begin
  inherited;

  LId := FDMemTableEntity.FieldByName('Id').AsString;
  ///  получаем полную информацию о сущности от брокера
  LEntity := Broker.Info(LId) as TStripTask;
  lTaskInfoModuleValue.Caption    := LEntity.Module;
end;

procedure TStripTasksForm.Refresh(const AId: String = '');
begin
  inherited Refresh(AId)
end;

end.
