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
  EntityBrokerUnit,
  ParentEditFormUnit,
  DSProcessorTasksBrokerUnit, uniPanel, uniLabel;

type
  TDSProcessorTasksForm = class(TListParentForm)
    cpTaskInfoModule: TUniContainerPanel;
    lTaskInfoModule: TUniLabel;
    lTaskInfoModuleValue: TUniLabel;
    pSeparator5: TUniPanel;
    procedure dbgEntitySelectionChange(Sender: TObject);
  private

  protected
    ///  ������� ���������� ��������� �� �����
    procedure Refresh(const AId: String = ''); override;

    ///  ������� ��� �������� ������� ������� �������
    function CreateBroker(): TEntityBroker; override;

    ///  ������� ��� �������� ������ ����� ��������������
    function CreateEditForm(): TParentEditForm; override;

  public

  end;

function DSProcessorTasksForm: TDSProcessorTasksForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, DSProcessorTaskEditFormUnit, DSProcessorTaskUnit;

function DSProcessorTasksForm: TDSProcessorTasksForm;
begin
  Result := TDSProcessorTasksForm(UniMainModule.GetFormInstance(TDSProcessorTasksForm));
end;

{ TDSProcessorTasksForm }
function TDSProcessorTasksForm.CreateBroker: TEntityBroker;
begin
  ///  ������� "���" ������ ��� �����
  Result := TDSProcessorTasksBroker.Create();
end;


function TDSProcessorTasksForm.CreateEditForm: TParentEditForm;
begin
  ///  ������� "����" ����� �������������� ��� �����
  Result := DSProcessorTaskEditForm();
end;

procedure TDSProcessorTasksForm.dbgEntitySelectionChange(Sender: TObject);
var
  LEntity : TDSProcessorTask;
  LId     : string;
  DT      : string;
begin
  inherited;

  LId := FDMemTableEntity.FieldByName('Id').AsString;
  ///  �������� ������ ���������� � �������� �� �������
  LEntity := Broker.Info(LId) as TDSProcessorTask;
  lTaskInfoModuleValue.Caption    := LEntity.Module;
end;

procedure TDSProcessorTasksForm.Refresh(const AId: String = '');
begin
  inherited Refresh(AId)
end;

end.
