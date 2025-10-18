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
  EntityBrokerUnit,
  ParentEditFormUnit,
  SummaryTasksBrokerUnit, uniPanel, uniLabel;

type
  TSummaryTasksForm = class(TListParentForm)
    cpTaskInfoModule: TUniContainerPanel;
    lTaskInfoModule: TUniLabel;
    lTaskInfoModuleValue: TUniLabel;
    pSeparator5: TUniPanel;
    procedure dbgEntitySelectionChange(Sender: TObject);
  private

  protected
    ///
    procedure Refresh(const AId: String = ''); override;

    ///
    function CreateBroker(): TEntityBroker; override;

    ///
    function CreateEditForm(): TParentEditForm; override;

  public

  end;

function SummaryTasksForm: TSummaryTasksForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, SummaryTaskEditFormUnit, SummaryTaskUnit;

function SummaryTasksForm: TSummaryTasksForm;
begin
  Result := TSummaryTasksForm(UniMainModule.GetFormInstance(TSummaryTasksForm));
end;

{ TSummaryTasksForm }

function TSummaryTasksForm.CreateBroker: TEntityBroker;
begin
  ///   ""
  Result := TSummaryTasksBroker.Create();
end;


function TSummaryTasksForm.CreateEditForm: TParentEditForm;
begin
  ///   ""
  Result := SummaryTaskEditForm();
end;

procedure TSummaryTasksForm.dbgEntitySelectionChange(Sender: TObject);
var
  LEntity : TSummaryTask;
  LId     : string;
  DT      : string;
begin
  inherited;

  LId := FDMemTableEntity.FieldByName('Id').AsString;
  ///  получаем полную информацию о сущности от брокера
  LEntity := Broker.Info(LId) as TSummaryTask;
  lTaskInfoModuleValue.Caption    := LEntity.Module;
end;

procedure TSummaryTasksForm.Refresh(const AId: String = '');
begin
  inherited Refresh(AId)
end;

end.
