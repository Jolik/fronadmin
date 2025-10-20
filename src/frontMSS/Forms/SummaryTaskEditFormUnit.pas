unit SummaryTaskEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniButton,
  uniGUIBaseClasses, uniPanel, uniMemo, uniCheckBox,
  LoggingUnit,
  EntityUnit, SummaryTaskUnit, uniMultiItem, uniComboBox, Math,
  ParentTaskCustomSettingsEditFrameUnit,
  SummaryCXMLTaskCustomSettingsEditFrameUnit,
  SummarySEBATaskCustomSettingsEditFrameUnit,
  SummarySynopTaskCustomSettingsEditFrameUnit,
  SummaryHydraTaskCustomSettingsEditFrameUnit;

type
  TParentTaskCustomSettingsEditFrameClass = class of TParentTaskCustomSettingsEditFrame;

  TSummaryTaskEditForm = class(TParentEditForm)
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
  private
    FCustomSettingsFrame: TParentTaskCustomSettingsEditFrame;
    function Apply: boolean; override;
    function DoCheck: Boolean; override;
    function GetSummaryTask: TSummaryTask;
    function GetSummarySettings: TSummaryTaskSettings;
    procedure ClearCustomSettingsFrame;
    procedure UpdateCustomSettingsFrame;
    function GetFrameClassByType(const AType: TSummaryTaskType): TParentTaskCustomSettingsEditFrameClass;
    function GetSummaryTaskTypeByModule(const AModule: string): TSummaryTaskType;
    procedure cbModuleChange(Sender: TObject);
(*!!!    function FormatExcludeWeek(const Values: TExcludeWeek): string;
    function ParseExcludeWeekText(const AText: string): TExcludeWeek; *)

  protected
    ///
    procedure SetEntity(AEntity : TEntity); override;

  public
    ///    FEntity     ""
    property SummaryTask : TSummaryTask read GetSummaryTask;

  end;

function SummaryTaskEditForm: TSummaryTaskEditForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function SummaryTaskEditForm: TSummaryTaskEditForm;
begin
  Result := TSummaryTaskEditForm(UniMainModule.GetFormInstance(TSummaryTaskEditForm));
end;

{ TSummaryTaskEditForm }

function TSummaryTaskEditForm.Apply: boolean;
begin
  Result := inherited Apply();

  if not Result then
    Exit;

  SummaryTask.Tid := teTid.Text;
  SummaryTask.CompId := teCompId.Text;
  SummaryTask.DepId := teDepId.Text;
  SummaryTask.Module := cbModule.Text;
  SummaryTask.Def := meDef.Lines.Text;
  SummaryTask.Enabled := cbEnabled.Checked;

  var Settings := GetSummarySettings();
  if Assigned(Settings) then
    Settings.LatePeriod := StrToIntDef(teLatePeriod.Text, 0);

  if Assigned(FCustomSettingsFrame) then
    Result := FCustomSettingsFrame.Apply() and Result;
end;

function TSummaryTaskEditForm.DoCheck: Boolean;
begin
  Result := inherited DoCheck();
end;

 ///    FEntity     ""
function TSummaryTaskEditForm.GetSummaryTask: TSummaryTask;
begin
  Result := nil;
  ///        -  nil!
  if not (FEntity is TSummaryTask) then
  begin
    Log('TSummaryTaskEditForm.GetSummaryTask error in FEntity type', lrtError);
    exit;
  end;

  ///         FEntity   TSummaryTask
  Result := Entity as TSummaryTask;
end;

function TSummaryTaskEditForm.GetSummarySettings: TSummaryTaskSettings;
begin
  Result := nil;

  if SummaryTask = nil then
    Exit;

  if not (SummaryTask.Settings is TSummaryTaskSettings) then
  begin
    Log('TSummaryTaskEditForm.GetSummarySettings invalid settings type', lrtError);
    Exit;
  end;

  Result := SummaryTask.Settings as TSummaryTaskSettings;
end;

procedure TSummaryTaskEditForm.ClearCustomSettingsFrame;
begin
  if Assigned(FCustomSettingsFrame) then
  begin
    FCustomSettingsFrame.Parent := nil;
    FreeAndNil(FCustomSettingsFrame);
  end;
  pnCustomSettings.Visible := False;
end;

function TSummaryTaskEditForm.GetFrameClassByType(const AType: TSummaryTaskType): TParentTaskCustomSettingsEditFrameClass;
begin
  case AType of
    sttTaskSummaryCXML: Result := TSummaryCXMLTaskCustomSettingsEditFrame;
    sttTaskSummarySEBA: Result := TSummarySEBATaskCustomSettingsEditFrame;
    sttTaskSummarySynop: Result := TSummarySynopTaskCustomSettingsEditFrame;
    sttTaskSummaryHydra: Result := TSummaryHydraTaskCustomSettingsEditFrame;
  else
    Result := nil;
  end;
end;

function TSummaryTaskEditForm.GetSummaryTaskTypeByModule(const AModule: string): TSummaryTaskType;
begin
  if SameText(AModule, 'SummaryCXML') then
    Result := sttTaskSummaryCXML
  else if SameText(AModule, 'SummarySEBA') then
    Result := sttTaskSummarySEBA
  else if SameText(AModule, 'SummarySynop') then
    Result := sttTaskSummarySynop
  else if SameText(AModule, 'SummaryHydra') then
    Result := sttTaskSummaryHydra
  else
    Result := sttUnknown;
end;

procedure TSummaryTaskEditForm.UpdateCustomSettingsFrame;
var
  Settings: TSummaryTaskSettings;
  FrameClass: TParentTaskCustomSettingsEditFrameClass;
begin
  Settings := GetSummarySettings();
  if Settings = nil then
  begin
    ClearCustomSettingsFrame;
    Exit;
  end;

  FrameClass := GetFrameClassByType(Settings.SummaryTaskType);

  if FrameClass = nil then
  begin
    ClearCustomSettingsFrame;
    Exit;
  end;

  if Assigned(FCustomSettingsFrame) and (FCustomSettingsFrame.ClassType <> FrameClass) then
    ClearCustomSettingsFrame;

  if not Assigned(FCustomSettingsFrame) then
  begin
    FCustomSettingsFrame := FrameClass.Create(Self);
    FCustomSettingsFrame.Parent := pnCustomSettings;
    FCustomSettingsFrame.Align := alClient;
  end;

  FCustomSettingsFrame.AssignTaskCustomSettings(Settings.TaskCustomSettings);
  pnCustomSettings.Visible := True;
end;

procedure TSummaryTaskEditForm.cbModuleChange(Sender: TObject);
var
  Settings: TSummaryTaskSettings;
  NewType: TSummaryTaskType;
begin
  Settings := GetSummarySettings();
  if not Assigned(Settings) then
  begin
    ClearCustomSettingsFrame;
    Exit;
  end;

  NewType := GetSummaryTaskTypeByModule(cbModule.Text);
  if Settings.SummaryTaskType <> NewType then
    Settings.SummaryTaskType := NewType;

  UpdateCustomSettingsFrame;
end;

(* !!!! function TSummaryTaskEditForm.FormatExcludeWeek(
  const Values: TExcludeWeek): string;
begin
  Result := '';

  for var I := 0 to Length(Values) - 1 do
  begin
    if Result <> '' then
      Result := Result + ', ';
    Result := Result + IntToStr(Values[I]);
  end;
end;

function TSummaryTaskEditForm.ParseExcludeWeekText(
  const AText: string): TExcludeWeek;
var
  Parts: TStringList;
  Normalized: string;
  ValueText: string;
begin
  SetLength(Result, 0);

  Normalized := StringReplace(AText, ';', ',', [rfReplaceAll]);
  Normalized := StringReplace(Normalized, ' ', ',', [rfReplaceAll]);

  Parts := TStringList.Create;
  try
    Parts.StrictDelimiter := True;
    Parts.Delimiter := ',';
    Parts.DelimitedText := Normalized;

    for var I := 0 to Parts.Count - 1 do
    begin
      ValueText := Trim(Parts[I]);
      if ValueText = '' then
        Continue;

      SetLength(Result, Length(Result) + 1);
      Result[High(Result)] := StrToIntDef(ValueText, 0);
    end;
  finally
    Parts.Free;
  end;
end;    *)

procedure TSummaryTaskEditForm.SetEntity(AEntity: TEntity);
begin
  ClearCustomSettingsFrame;
  ///        -   !
  if not (AEntity is TSummaryTask) then
  begin
    Log('TSummaryTaskEditForm.SetEntity error in AEntity type', lrtError);
    exit;
  end;

  try
    inherited SetEntity(AEntity);

    ///
    teTid.Text         := SummaryTask.Tid;
    teCompId.Text      := SummaryTask.CompId;
    teDepId.Text       := SummaryTask.DepId;
    cbModule.ItemIndex := IfThen(cbModule.Items.IndexOf(SummaryTask.Module) <> -1, cbModule.Items.IndexOf(SummaryTask.Module), 4);
    meDef.Lines.Text   := SummaryTask.Def;
    cbEnabled.Checked  := SummaryTask.Enabled;

    var Settings := GetSummarySettings();
    if Assigned(Settings) then
      teLatePeriod.Text := IntToStr(Settings.LatePeriod)
    else
      teLatePeriod.Text := '';

    UpdateCustomSettingsFrame;
  except
    Log('TSummaryTaskEditForm.SetEntity error', lrtError);
    ClearCustomSettingsFrame;
  end;
end;

end.
