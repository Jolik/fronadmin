unit MonitoringTaskEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniCheckBox,
  uniGUIBaseClasses, uniPanel, uniMemo,
  LoggingUnit,   TasksParentFormUnit, TaskEditParentFormUnit,
  EntityUnit, MonitoringTaskUnit, TaskSourceUnit, uniListBox, uniComboBox,
  uniMultiItem, uniButton;

type
  TTaskSourcesList = TTaskSourceList;

  TMonitoringTaskEditForm = class(TTaskEditParentForm)

  private
    FTaskSourcesList: TTaskSourcesList;
    function Apply: Boolean; override;
    function DoCheck: Boolean; override;
    function GetMonitoringTask: TMonitoringTask;
  protected
    procedure SetEntity(AEntity: TFieldSet); override;
  public
    property MonitoringTask: TMonitoringTask read GetMonitoringTask;
    property TaskSourcesList: TTaskSourcesList read FTaskSourcesList write SetTaskSourcesList;
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

function TMonitoringTaskEditForm.Apply: Boolean;
begin
  Result := inherited Apply();
end;

function TMonitoringTaskEditForm.DoCheck: Boolean;
begin
  Result := inherited DoCheck();
end;

function TMonitoringTaskEditForm.GetMonitoringTask: TMonitoringTask;
begin
  Result := nil;

  if not (FEntity is TMonitoringTask) then
  begin
    Log('TMonitoringTaskEditForm.GetMonitoringTask invalid entity type', lrtError);
    Exit;
  end;

  Result := FEntity as TMonitoringTask;
end;

procedure TMonitoringTaskEditForm.SetEntity(AEntity: TFieldSet);
begin
  inherited SetEntity(AEntity);
 
end;
end.
