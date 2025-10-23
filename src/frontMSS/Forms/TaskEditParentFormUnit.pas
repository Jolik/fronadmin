unit TaskEditParentFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniButton,
  uniGUIBaseClasses, uniPanel, uniMemo, uniCheckBox,
  LoggingUnit,
  EntityUnit, TaskSourceUnit, uniMultiItem, uniComboBox, Math,
  TaskSourcesBrokerUnit,
  ParentTaskCustomSettingsEditFrameUnit, SelectTaskSourcesFormUnit,
  TaskUnit,
  uniListBox;


type
  TTaskSourcesList = TTaskSourceList;

type
  TTaskEditParentForm = class(TParentEditForm)
    lModule: TUniLabel;
    teTid: TUniEdit;
    lTid: TUniLabel;
    teCompId: TUniEdit;
    lCompId: TUniLabel;
    teDepId: TUniEdit;
    lDepId: TUniLabel;
    meDef: TUniMemo;
    lDef: TUniLabel;
    cbEnabled: TUniCheckBox;
    teLatePeriod: TUniEdit;
    lLatePeriod: TUniLabel;
    cbModule: TUniComboBox;
    pnCustomSettings: TUniContainerPanel;
    pnSources: TUniContainerPanel;
    lbTaskSources: TUniListBox;
    btnSourcesEdit: TUniButton;
    procedure btnSourcesEditClick(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
  protected
    FTaskSourcesBroker: TTaskSourcesBroker;
    FCustomSettingsFrame: TParentTaskCustomSettingsEditFrame;
    FTaskSourcesList: TTaskSourcesList;
    FTaskSourcesListOwned: Boolean;
    function Apply: boolean; override;
    function DoCheck: Boolean; override;
    function GetSettings: TTaskSettings;
    function GetTask: TTask;
    procedure ClearCustomSettingsFrame;
    procedure SetTaskSourcesList(const Value: TTaskSourcesList);
    procedure RefreshTaskSourcesList;
    procedure AssignTaskSourcesFrom(const ASourceList: TTaskSourcesList);
    procedure SourcesEditCallback(ASender: TComponent; AResult: Integer);


    function CreateTaskSourceEditForm(): TSelectTaskSourcesForm; virtual;
    procedure SetEntity(AEntity : TEntity); override;

  public
    ///    FEntity     ""
    property Task : TTask read GetTask;
    property TaskSourcesList: TTaskSourcesList read FTaskSourcesList write SetTaskSourcesList;

  end;

function ParentTaskEditForm(taskSourceBroker: TTaskSourcesBroker = nil): TTaskEditParentForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, ConstsUnit, Common;

function ParentTaskEditForm(taskSourceBroker: TTaskSourcesBroker): TTaskEditParentForm;
begin
  Result := TTaskEditParentForm(UniMainModule.GetFormInstance(TTaskEditParentForm));
  Result.FTaskSourcesBroker:= taskSourceBroker;
end;

{ TTaskEditParentForm }

function TTaskEditParentForm.Apply: boolean;
begin
  Result := inherited Apply();

  if not Result then
    Exit;

  Task.Tid := teTid.Text;
  Task.CompId := teCompId.Text;
  Task.DepId := teDepId.Text;
  Task.Module := cbModule.Text;
  Task.Def := meDef.Lines.Text;
  Task.Enabled := cbEnabled.Checked;

  if Assigned(FTaskSourcesList) and Assigned(lbTaskSources) then
    for var I := 0 to lbTaskSources.Items.Count - 1 do
    begin
      var SourceObj := lbTaskSources.Items.Objects[I];
      if SourceObj is TTaskSource then
        TTaskSource(SourceObj).Enabled := lbTaskSources.Selected[I];
    end;

  if Assigned(FCustomSettingsFrame) then
    Result := FCustomSettingsFrame.Apply() and Result;
end;

function TTaskEditParentForm.DoCheck: Boolean;
begin
  Result := inherited DoCheck();
  if not IsEdit and (teTid.Text<> '') and  not ValidateUUID(teTid.Text) then
  begin
    Result := false;
    MessageDlg(Format(rsWarningValueMustBeUUID, [lTid.Caption]), TMsgDlgType.mtWarning, [mbOK], nil)
  end;
end;

function TTaskEditParentForm.GetSettings: TTaskSettings;
begin
  Result := nil;

  if Task = nil then
    Exit;

  if not (Task.Settings is TTaskSettings) then
  begin
    Log('TSummaryTaskEditForm.GetSummarySettings invalid settings type', lrtError);
    Exit;
  end;

  Result := Task.Settings as TTaskSettings;
end;

function TTaskEditParentForm.GetTask: TTask;
begin
  Result := nil;
  if not (FEntity is TTask) then
  begin
    Log('TSummaryTaskEditForm.GetSummaryTask error in FEntity type', lrtError);
    exit;
  end;
  Result := Entity as TTask;
end;

procedure TTaskEditParentForm.ClearCustomSettingsFrame;
begin
  if Assigned(FCustomSettingsFrame) then
  begin
    FCustomSettingsFrame.Parent := nil;
    FreeAndNil(FCustomSettingsFrame);
  end;
  pnCustomSettings.Visible := False;
end;

function TTaskEditParentForm.CreateTaskSourceEditForm: TSelectTaskSourcesForm;
begin
  Result := SelectTaskSourcesForm(FTaskSourcesBroker) as TSelectTaskSourcesForm;
end;

procedure TTaskEditParentForm.SetTaskSourcesList(
  const Value: TTaskSourcesList);
begin
  if FTaskSourcesListOwned and (FTaskSourcesList <> Value) then
  begin
    FreeAndNil(FTaskSourcesList);
    FTaskSourcesListOwned := False;
  end;

  FTaskSourcesList := Value;

  if not Assigned(Value) then
    FTaskSourcesListOwned := False;

  RefreshTaskSourcesList;
end;

procedure TTaskEditParentForm.RefreshTaskSourcesList;
begin
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

procedure TTaskEditParentForm.AssignTaskSourcesFrom(const ASourceList: TTaskSourcesList);
var
  Source: TTaskSource;
  NewSource: TTaskSource;
  CreatedList: Boolean;
begin
  CreatedList := False;

  if not Assigned(FTaskSourcesList) then
  begin
    FTaskSourcesList := TTaskSourcesList.Create(True);
    CreatedList := True;
  end;

  if CreatedList then
    FTaskSourcesListOwned := True;

  FTaskSourcesList.Clear;

  if Assigned(ASourceList) then
  begin
    for var I := 0 to ASourceList.Count - 1 do
    begin
      if not (ASourceList.Items[I] is TTaskSource) then
        Continue;

      Source := TTaskSource(ASourceList.Items[I]);
      if not Assigned(Source) then
        Continue;

      NewSource := TTaskSource.Create;
      try
        NewSource.Assign(Source);
        FTaskSourcesList.Add(NewSource);
      except
        NewSource.Free;
        raise;
      end;
    end;
  end;

  RefreshTaskSourcesList;
end;

procedure TTaskEditParentForm.btnSourcesEditClick(Sender: TObject);
var
  SelectForm: TSelectTaskSourcesForm;
begin
  SelectForm := CreateTaskSourceEditForm;
  if not Assigned(SelectForm) then
    Exit;

  SelectForm.TaskSourceList := TaskSourcesList;

  SelectForm.ShowModal(SourcesEditCallback);
end;

procedure TTaskEditParentForm.SourcesEditCallback(ASender: TComponent; AResult: Integer);
var
  SelectForm: TSelectTaskSourcesForm;
begin
  if not (ASender is TSelectTaskSourcesForm) then
    Exit;

  SelectForm := TSelectTaskSourcesForm(ASender);

  if AResult = mrOk then
    AssignTaskSourcesFrom(SelectForm.TaskSourceList);
end;

procedure TTaskEditParentForm.UniFormShow(Sender: TObject);
begin
  inherited;
  teTid.Enabled:= not IsEdit;
  cbModule.Enabled:= not IsEdit;
end;

procedure TTaskEditParentForm.SetEntity(AEntity: TEntity);
begin
  ClearCustomSettingsFrame;
  ///        -   !
  if not (AEntity is TTask) then
  begin
    Log('TTaskEditParentForm.SetEntity error in AEntity type', lrtError);
    exit;
  end;

  try
    inherited SetEntity(AEntity);

    ///
    teTid.Text         := Task.Tid;
    teCompId.Text      := Task.CompId;
    teDepId.Text       := Task.DepId;
    cbModule.ItemIndex := IfThen(cbModule.Items.IndexOf(Task.Module) <> -1, cbModule.Items.IndexOf(Task.Module), 4);
    meDef.Lines.Text   := Task.Def;
    cbEnabled.Checked  := Task.Enabled;

  except
    Log('TTaskEditParentForm.SetEntity error', lrtError);
    ClearCustomSettingsFrame;
  end;
end;

end.
