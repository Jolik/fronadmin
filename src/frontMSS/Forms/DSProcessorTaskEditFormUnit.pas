unit DSProcessorTaskEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniCheckBox,
  uniGUIBaseClasses, uniPanel, uniMemo,
  LoggingUnit,   TasksParentFormUnit, TaskEditParentFormUnit,
  EntityUnit, DSProcessorTaskUnit, TaskSourceUnit, uniListBox, uniComboBox,
  uniMultiItem, uniButton;

type
  TTaskSourcesList = TTaskSourceList;

  TDSProcessorTaskEditForm = class(TTaskEditParentForm)

  private
    FTaskSourcesList: TTaskSourcesList;
    function Apply: Boolean; override;
    function DoCheck: Boolean; override;
    function GetDSProcessorTask: TDSProcessorTask;
  protected
    procedure SetEntity(AEntity: TFieldSet); override;
  public
    property DSProcessorTask: TDSProcessorTask read GetDSProcessorTask;
    property TaskSourcesList: TTaskSourcesList read FTaskSourcesList write SetTaskSourcesList;
  end;

function DSProcessorTaskEditForm: TDSProcessorTaskEditForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function DSProcessorTaskEditForm: TDSProcessorTaskEditForm;
begin
  Result := TDSProcessorTaskEditForm(UniMainModule.GetFormInstance(TDSProcessorTaskEditForm));
end;

{ TDSProcessorTaskEditForm }

function TDSProcessorTaskEditForm.Apply: Boolean;
begin
  Result := inherited Apply();
end;

function TDSProcessorTaskEditForm.DoCheck: Boolean;
begin
  Result := inherited DoCheck();
end;

function TDSProcessorTaskEditForm.GetDSProcessorTask: TDSProcessorTask;
begin
  Result := nil;

  if not (FEntity is TDSProcessorTask) then
  begin
    Log('TDSProcessorTaskEditForm.GetDSProcessorTask invalid entity type', lrtError);
    Exit;
  end;

  Result := FEntity as TDSProcessorTask;
end;

procedure TDSProcessorTaskEditForm.SetEntity(AEntity: TFieldSet);
begin
  inherited SetEntity(AEntity);
 
end;
end.
