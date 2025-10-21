unit DSProcessorTaskEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniCheckBox,
  uniGUIBaseClasses, uniPanel, uniMemo,
  LoggingUnit,
  EntityUnit, DSProcessorTaskUnit, TaskSourceUnit, uniListBox, uniComboBox;

type
  TTaskSourcesList = TTaskSourceList;

  TDSProcessorTaskEditForm = class(TParentEditForm)
    lTid: TUniLabel;
    teTid: TUniEdit;
    lCompId: TUniLabel;
    teCompId: TUniEdit;
    lDepId: TUniLabel;
    teDepId: TUniEdit;
    lModule: TUniLabel;
    cbModule: TUniComboBox;
    cbEnabled: TUniCheckBox;
    lDef: TUniLabel;
    meDef: TUniMemo;
    pnSources: TUniContainerPanel;
    lbTaskSources: TUniListBox;
    lSources: TUniLabel;
  private
    FTaskSourcesList: TTaskSourcesList;
    function Apply: Boolean; override;
    function DoCheck: Boolean; override;
    function GetDSProcessorTask: TDSProcessorTask;
    procedure SetTaskSourcesList(const Value: TTaskSourcesList);
  protected
    procedure SetEntity(AEntity: TEntity); override;
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
  if not Result then
    Exit;

  if not Assigned(DSProcessorTask) then
  begin
    Result := False;
    Exit;
  end;

  DSProcessorTask.Tid := teTid.Text;
  DSProcessorTask.CompId := teCompId.Text;
  DSProcessorTask.DepId := teDepId.Text;
  DSProcessorTask.Module := cbModule.Text;
  DSProcessorTask.Def := meDef.Lines.Text;
  DSProcessorTask.Enabled := cbEnabled.Checked;

  if Assigned(FTaskSourcesList) and Assigned(lbTaskSources) then
    for var I := 0 to lbTaskSources.Items.Count - 1 do
    begin
      var SourceObj := lbTaskSources.Items.Objects[I];
      if SourceObj is TTaskSource then
        TTaskSource(SourceObj).Enabled := lbTaskSources.Selected[I];
    end;
end;

function TDSProcessorTaskEditForm.DoCheck: Boolean;
begin
  Result := inherited DoCheck();
  if not Result then
    Exit;

  if teTid.Text = '' then
  begin
    MessageDlg('Не заполнено значение в поле "Tid"', TMsgDlgType.mtWarning, [mbOK], nil);
    Result := False;
  end;
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

procedure TDSProcessorTaskEditForm.SetEntity(AEntity: TEntity);
begin
  if not (AEntity is TDSProcessorTask) then
  begin
    Log('TDSProcessorTaskEditForm.SetEntity invalid entity type', lrtError);
    Exit;
  end;

  inherited SetEntity(AEntity);

  teTid.Text := DSProcessorTask.Tid;
  teCompId.Text := DSProcessorTask.CompId;
  teDepId.Text := DSProcessorTask.DepId;
  cbModule.Text := DSProcessorTask.Module;
  meDef.Lines.Text := DSProcessorTask.Def;
  cbEnabled.Checked := DSProcessorTask.Enabled;
end;

procedure TDSProcessorTaskEditForm.SetTaskSourcesList(
  const Value: TTaskSourcesList);
begin
  FTaskSourcesList := Value;

  if not Assigned(lbTaskSources) then
    Exit;

  lbTaskSources.Items.Clear;

  if not Assigned(FTaskSourcesList) then
    Exit;

  for var I := 0 to FTaskSourcesList.Count - 1 do
  begin
    var Source := FTaskSourcesList.Items[I] as TTaskSource;
    if not Assigned(Source) then
      Continue;

    var Index := lbTaskSources.Items.AddObject(Source.Name, Source);
    if (Index >= 0) and (Index < lbTaskSources.Items.Count) then
      lbTaskSources.Selected[Index] := Source.Enabled;
  end;
end;

end.
