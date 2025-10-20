unit MonitoringTaskEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniButton,
  uniGUIBaseClasses, uniPanel,
  LoggingUnit,
  EntityUnit, MonitoringTaskUnit, uniMultiItem, uniComboBox, Math;

type
  TMonitoringTaskEditForm = class(TParentEditForm)
    lModule: TUniLabel;
    cbModule: TUniComboBox;
  private
    function Apply: boolean; override;
    function DoCheck: Boolean; override;
    function GetMonitoringTask: TMonitoringTask;

  protected
    /// ����� ������� �������������
    procedure SetEntity(AEntity : TEntity); override;

  public
    ///  ������ �� FEntity � ����������� ���� � "������"
    property MonitoringTask : TMonitoringTask read GetMonitoringTask;

  end;

function MonitoringTaskEditForm: TMonitoringTaskEditForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function MonitoringTaskEditForm: TMonitoringTaskEditForm;
begin
  Result := TMonitoringTaskEditForm(UniMainModule.GetFormInstance(TMonitoringTaskEditForm));
end;

{ TMonitoringTaskEditForm }

function TMonitoringTaskEditForm.Apply : boolean;
begin
  Result := inherited Apply();

  if not Result then Exit;

  MonitoringTask.Module := cbModule.Text;

  Result := true;
end;

function TMonitoringTaskEditForm.DoCheck: Boolean;
begin
  Result := inherited DoCheck();
end;

 ///  ������ �� FEntity � ����������� ���� � "������"
function TMonitoringTaskEditForm.GetMonitoringTask: TMonitoringTask;
begin
  Result := nil;
  ///  ���� ��� ������ �� ������ ���� - ���������� nil!
  if not (FEntity is TMonitoringTask) then
  begin
    Log('TMonitoringTaskEditForm.GetMonitoringTas error in FEntity type', lrtError);
    exit;
  end;

  ///  ���� ��� ��������� �� ���������� ������ �� FEntity ��� �� TMonitoringTask
  Result := Entity as TMonitoringTask;
end;

procedure TMonitoringTaskEditForm.SetEntity(AEntity: TEntity);
begin
  ///  ���� ��� ������ �� ������ ���� - �� ������ ������!
  if not (AEntity is TMonitoringTask) then
  begin
    Log('TMonitoringTaskEditForm.SetEntity error in AEntity type', lrtError);
    exit;
  end;

  try
    inherited SetEntity(AEntity);

    ///  ������� �������� ������
    cbModule.ItemIndex := IfThen(cbModule.Items.IndexOf(MonitoringTask.Module) <> -1, cbModule.Items.IndexOf(MonitoringTask.Module), cbModule.Items.Count - 1);

  except
    Log('TMonitoringTaskEditForm.SetEntity error', lrtError);
  end;
end;

end.
