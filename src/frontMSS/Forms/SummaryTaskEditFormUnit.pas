unit SummaryTaskEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniButton,
  uniGUIBaseClasses, uniPanel, uniMemo, uniCheckBox,
  LoggingUnit,
  EntityUnit, SummaryTaskUnit, uniMultiItem, uniComboBox, Math;

type
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
    cbCustomMeteo: TUniCheckBox;
    lCustomMeteo: TUniLabel;
    teCustomAnyTime: TUniEdit;
    lCustomAnyTime: TUniLabel;
    cbCustomSeparate: TUniCheckBox;
    lCustomSeparate: TUniLabel;
    teExcludeWeek: TUniEdit;
    lExcludeWeek: TUniLabel;
    cbModule: TUniComboBox;
    pnCustomSettings: TUniContainerPanel;
    pnSources: TUniContainerPanel;
  private
    function Apply: boolean; override;
    function DoCheck: Boolean; override;
    function GetSummaryTask: TSummaryTask;
    function GetSummarySettings: TSummaryTaskSettings;
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

function TSummaryTaskEditForm.Apply : boolean;
begin
  Result := inherited Apply();

  if not Result then exit;

  SummaryTask.Tid := teTid.Text;
  SummaryTask.CompId := teCompId.Text;
  SummaryTask.DepId := teDepId.Text;
  SummaryTask.Module := cbModule.Text;
  SummaryTask.Def := meDef.Lines.Text;
  SummaryTask.Enabled := cbEnabled.Checked;

  var Settings := GetSummarySettings();
  if Assigned(Settings) then
  begin
    Settings.LatePeriod := StrToIntDef(teLatePeriod.Text, 0);

(*!!!    var Custom := Settings.Custom;
    Custom.Meteo := cbCustomMeteo.Checked;
    Custom.AnyTime := StrToIntDef(teCustomAnyTime.Text, 0);
    Custom.Separate := cbCustomSeparate.Checked;
    Settings.Custom := Custom;

    Settings.ExcludeWeek := ParseExcludeWeekText(teExcludeWeek.Text);  *)
  end;

  Result := true;
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
    begin
      teLatePeriod.Text := IntToStr(Settings.LatePeriod);

(* !!!      var Custom := Settings.Custom;
      cbCustomMeteo.Checked := Custom.Meteo;
      teCustomAnyTime.Text := IntToStr(Custom.AnyTime);
      cbCustomSeparate.Checked := Custom.Separate;

      teExcludeWeek.Text := FormatExcludeWeek(Settings.ExcludeWeek);*)
    end
    else
    begin
      teLatePeriod.Text := '';
      cbCustomMeteo.Checked := False;
      teCustomAnyTime.Text := '';
      cbCustomSeparate.Checked := False;
      teExcludeWeek.Text := '';
    end;

  except
    Log('TSummaryTaskEditForm.SetEntity error', lrtError);
  end;
end;

end.
