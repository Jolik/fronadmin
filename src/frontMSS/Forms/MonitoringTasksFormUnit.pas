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
  EntityBrokerUnit,
  ParentEditFormUnit,
  MonitoringTasksBrokerUnit, uniPanel, uniLabel;

type
  TMonitoringTasksForm = class(TListParentForm)
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

function MonitoringTasksForm: TMonitoringTasksForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, MonitoringTaskEditFormUnit, MonitoringTaskUnit;

function MonitoringTasksForm: TMonitoringTasksForm;
begin
  Result := TMonitoringTasksForm(UniMainModule.GetFormInstance(TMonitoringTasksForm));
end;

{ TMonitoringTasksForm }
function TMonitoringTasksForm.CreateBroker: TEntityBroker;
begin
  ///  ������� "���" ������ ��� �����
  Result := TMonitoringTasksBroker.Create();
end;


function TMonitoringTasksForm.CreateEditForm: TParentEditForm;
begin
  ///  ������� "����" ����� �������������� ��� �����
  Result := MonitoringTaskEditForm();
end;

procedure TMonitoringTasksForm.dbgEntitySelectionChange(Sender: TObject);
var
  LEntity : TMonitoringTask;
  LId     : string;
  DT      : string;
begin
  inherited;

  LId := FDMemTableEntity.FieldByName('Id').AsString;
  ///  �������� ������ ���������� � �������� �� �������
  LEntity := Broker.Info(LId) as TMonitoringTask;
  lTaskInfoModuleValue.Caption    := LEntity.Module;
end;

procedure TMonitoringTasksForm.Refresh(const AId: String = '');
begin
  inherited Refresh(AId)
end;

end.
