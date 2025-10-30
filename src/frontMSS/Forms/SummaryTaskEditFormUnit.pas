unit SummaryTaskEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniButton,
  uniGUIBaseClasses, uniPanel, uniMemo, uniCheckBox,
  LoggingUnit,
  EntityUnit, SummaryTaskUnit, TaskSourceUnit, uniMultiItem, uniComboBox, Math,
  TaskEditParentFormUnit,
  ParentTaskCustomSettingsEditFrameUnit,
  SummaryCXMLTaskCustomSettingsEditFrameUnit,
  SummarySEBATaskCustomSettingsEditFrameUnit,
  SummarySynopTaskCustomSettingsEditFrameUnit,
  SummaryHydraTaskCustomSettingsEditFrameUnit, uniListBox, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniBasicGrid, uniDBGrid, uniTimer, uniGroupBox,
  uniSpinEdit, uniBitBtn, uniSpeedButton;

type
  TParentTaskCustomSettingsEditFrameClass = class of TParentTaskCustomSettingsEditFrame;
  TTaskSourcesList = TTaskSourceList;

  TSummaryTaskEditForm = class(TTaskEditParentForm)
    lLatePeriod: TUniLabel;
    ueHeader: TUniEdit;
    UniLabel1: TUniLabel;
    ueHeader2: TUniEdit;
    UniLabel2: TUniLabel;
    UniLabel3: TUniLabel;
    uspHeaderCorr: TUniSpinEdit;
    UniGroupBox1: TUniGroupBox;
    undtMonthDays: TUniEdit;
    UniLabel5: TUniLabel;
    UniLabel6: TUniLabel;
    UniLabel7: TUniLabel;
    UniPanel1: TUniPanel;
    unspndtLateEvery: TUniSpinEdit;
    UniLabel8: TUniLabel;
    UniLabel9: TUniLabel;
    unspndtLatePeriod: TUniSpinEdit;
    unchckbxCheckLate: TUniCheckBox;
    unpnlWeekDaysArr: TUniPanel;
    bt7: TUniSpeedButton;
    bt6: TUniSpeedButton;
    bt5: TUniSpeedButton;
    bt4: TUniSpeedButton;
    bt3: TUniSpeedButton;
    bt2: TUniSpeedButton;
    bt1: TUniSpeedButton;
    uncmbxTime: TUniComboBox;
    uncmbxTime1: TUniComboBox;
    procedure cbModuleChange(Sender: TObject);
  private
    function Apply: boolean; override;
    function DoCheck: Boolean; override;
    function GetSummaryTask: TSummaryTask;
    function GetSummarySettings: TSummaryTaskSettings;
    procedure ClearCustomSettingsFrame;
    procedure UpdateCustomSettingsFrame;
    function GetFrameClassByType(const AType: TSummaryTaskType): TParentTaskCustomSettingsEditFrameClass;
    function GetSummaryTaskTypeByModule(const AModule: string): TSummaryTaskType;


  protected
    ///
    procedure SetEntity(AEntity : TFieldSet); override;

  public
    ///    FEntity     ""
    property SummaryTask : TSummaryTask read GetSummaryTask;

  end;

function SummaryTaskEditForm: TSummaryTaskEditForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, SelectTaskSourcesFormUnit, TaskUnit;

function SummaryTaskEditForm: TSummaryTaskEditForm;
begin
  Result := TSummaryTaskEditForm(UniMainModule.GetFormInstance(TSummaryTaskEditForm));
end;

{ TSummaryTaskEditForm }

function TSummaryTaskEditForm.Apply: Boolean;
var
  Settings: TSummaryTaskSettings;
  I: Integer;
begin
  Result := inherited Apply;

  if not Result then
    Exit;

  Settings := GetSummarySettings();
  if not Assigned(Settings) then
    Exit(False);

  with Settings do
  begin
    Header := ueHeader.Text;
    Header2 := ueHeader2.Text;
    HeaderCorr := uspHeaderCorr.Value;
    Local := uncmbxTime.ItemIndex = 0;

    for I := Low(ExcludeWeek) to High(ExcludeWeek) do
    begin
      with unpnlWeekDaysArr.Controls[I] as TUniSpeedButton do
        ExcludeWeek[I] := integer(not Down); // обратная логика из SetEntity
    end;

    MonthDays := undtMonthDays.Text;
    Time := uncmbxTime1.Text;
    CheckLate := unchckbxCheckLate.Checked;

    LateEvery := unspndtLateEvery.Value;
    LatePeriod := unspndtLatePeriod.Value;

    // При смене модуля можно обновить тип
    SummaryTaskType := GetSummaryTaskTypeByModule(GetCurrentModuleValues);
  end;

  // Если есть кастомные настройки — применяем их тоже
  if Assigned(FCustomSettingsFrame) then
    Result := FCustomSettingsFrame.Apply() and Result;
end;

function TSummaryTaskEditForm.DoCheck: Boolean;
begin
  Result := inherited;
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
  inherited;

  Settings := GetSummarySettings();

  if not Assigned(Settings) then
  begin
    ClearCustomSettingsFrame;
    Exit;
  end;

  NewType := GetSummaryTaskTypeByModule(GetCurrentModuleValues);
  if Settings.SummaryTaskType <> NewType then
    Settings.SummaryTaskType := NewType;

  UpdateCustomSettingsFrame;
end;

procedure TSummaryTaskEditForm.SetEntity(AEntity: TFieldSet);
var
 i:Integer;
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

    var Settings := GetSummarySettings();
    if Assigned(Settings) then
    with Settings do begin
      ueHeader.Text :=  Header;
      ueHeader2.Text:=  Header2;
      uspHeaderCorr.Value:= HeaderCorr;
      uncmbxTime.ItemIndex := Integer(not Local);
      for I := Low(ExcludeWeek) to High(ExcludeWeek) do
      begin
        with unpnlWeekDaysArr do
        with Controls[I] as TUniSpeedButton do begin
            Down := not Boolean(ExcludeWeek[i]);
      end;
      end;
      undtMonthDays.Text:= MonthDays;
      uncmbxTime1.Text :=  Time;
      unchckbxCheckLate.Checked:= CheckLate;

      unspndtLateEvery.Enabled:= CheckLate;
      unspndtLatePeriod.Enabled:= CheckLate;
      unspndtLateEvery.Value:=LateEvery;
      unspndtLatePeriod.Value:= LatePeriod;



    end;
//      teLatePeriod.Text := IntToStr(Settings.LatePeriod)
//    else
//      teLatePeriod.Text := '';

    UpdateCustomSettingsFrame;
  except
    Log('TSummaryTaskEditForm.SetEntity error', lrtError);
    ClearCustomSettingsFrame;
  end;
end;

end.
