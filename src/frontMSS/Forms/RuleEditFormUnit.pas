unit RuleEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniButton,
  uniGUIBaseClasses, uniPanel, uniMemo, uniScrollBox, uniCheckBox,
  System.Generics.Collections,
  LoggingUnit,
  EntityUnit, FilterUnit, RuleUnit, uniTimer;

type
  TFilterListKind = (fkInclude, fkExclude);

  TRuleEditForm = class(TParentEditForm)
    lRuid: TUniLabel;
    teRuid: TUniEdit;
    lPosition: TUniLabel;
    tePosition: TUniEdit;
    lPriority: TUniLabel;
    tePriority: TUniEdit;
    chkDoubles: TUniCheckBox;
    chkBreakRule: TUniCheckBox;
    lHandlers: TUniLabel;
    meHandlers: TUniMemo;
    lChannels: TUniLabel;
    meChannels: TUniMemo;
    lIncFilters: TUniLabel;
    lExcFilters: TUniLabel;
    sbIncFilters: TUniScrollBox;
    sbExcFilters: TUniScrollBox;
    btnAddIncFilter: TUniButton;
    btnAddExcFilter: TUniButton;
    procedure btnAddIncFilterClick(Sender: TObject);
    procedure btnAddExcFilterClick(Sender: TObject);
  private
    FIncFilterEditors: TObjectList<TObject>;
    FExcFilterEditors: TObjectList<TObject>;
    function GetRule: TRule;
    procedure FilterRemoveButtonClick(Sender: TObject);
    procedure ClearFilterEditors(AEditors: TObjectList<TObject>);
    procedure AddFilterEditor(AEditors: TObjectList<TObject>; AScrollBox: TUniScrollBox;
      const ACaptionBase: string; AKind: TFilterListKind; AFilter: TProfileFilter = nil);
    procedure UpdateFilterCaptions(AEditors: TObjectList<TObject>; const ACaptionBase: string);
  protected
    procedure AfterConstruction; override;
    function Apply: boolean; override;
    function DoCheck: Boolean; override;
    procedure SetEntity(AEntity: TFieldSet); override;
  public
    destructor Destroy; override;
    property RuleEntity: TRule read GetRule;
  end;

function RuleEditForm: TRuleEditForm;

implementation

{$R *.dfm}

uses
  System.JSON,
  MainModule, uniGUIApplication, ConstsUnit,
  SmallRuleUnit;

type
  TFilterEditorItem = class
  private
    FKind: TFilterListKind;
    FPanel: TUniContainerPanel;
    FHeaderPanel: TUniContainerPanel;
    FTitleLabel: TUniLabel;
    FDisableCheck: TUniCheckBox;
    FMemo: TUniMemo;
    FRemoveButton: TUniButton;
  public
    constructor Create(AOwnerForm: TRuleEditForm; AParent: TUniScrollBox;
      const ACaption: string; AKind: TFilterListKind; AFilter: TProfileFilter = nil);
    destructor Destroy; override;
    function FillFilter(AFilter: TProfileFilter; out AErrorMessage: string): Boolean;
    procedure UpdateCaption(const ACaption: string);
    property Kind: TFilterListKind read FKind;
    property Panel: TUniContainerPanel read FPanel;
    property RemoveButton: TUniButton read FRemoveButton;
  end;

resourcestring
  rsInvalidChannelsJSON =
    #1053#1077#1082#1086#1088#1088#1077#1082#1090#1085#1099#1081' JSON '#1082#1072#1085#1072#1083#1086#1074'. '#1054#1078#1080#1076#1072#1077#1090#1089#1103' JSON '#1086#1073#1098#1077#1082#1090' '#1080#1083#1080' '#1084#1072#1089#1089#1080#1074'.';
  rsInvalidFilterJSON =
    #1053#1077#1082#1086#1088#1088#1077#1082#1090#1085#1099#1081' JSON '#1091#1089#1083#1086#1074' '#1092#1080#1083#1100#1090#1088#1072'. '#1054#1078#1080#1076#1072#1077#1090#1089#1103' JSON '#1084#1072#1089#1089#1080#1074'.';
  rsFilterParseError = #1054#1096#1080#1073#1082#1072' '#1088#1072#1079#1073#1086#1088#1072' '#1091#1089#1083#1086#1074' '#1092#1080#1083#1100#1090#1088#1072': %s';

const
  IncFilterCaptionBase = #1060#1080#1083#1100#1090#1088' '#1074#1082#1083#1102#1095#1077#1085#1080#1103;
  ExcFilterCaptionBase = #1060#1080#1083#1100#1090#1088' '#1080#1089#1082#1083#1102#1095#1077#1085#1080#1103;

{ TFilterEditorItem }

constructor TFilterEditorItem.Create(AOwnerForm: TRuleEditForm; AParent: TUniScrollBox;
  const ACaption: string; AKind: TFilterListKind; AFilter: TProfileFilter);
var
  ConditionsArray: TJSONArray;
begin
  inherited Create;

  FKind := AKind;

  FPanel := TUniContainerPanel.Create(AOwnerForm);
  FPanel.Parent := AParent;
  FPanel.AlignWithMargins := True;
  FPanel.Margins.Bottom := 6;
  FPanel.Align := alTop;
  FPanel.Height := 180;

  FHeaderPanel := TUniContainerPanel.Create(AOwnerForm);
  FHeaderPanel.Parent := FPanel;
  FHeaderPanel.Align := alTop;
  FHeaderPanel.Height := 32;

  FTitleLabel := TUniLabel.Create(AOwnerForm);
  FTitleLabel.Parent := FHeaderPanel;
  FTitleLabel.AlignWithMargins := True;
  FTitleLabel.Margins.Left := 8;
  FTitleLabel.Margins.Top := 8;
  FTitleLabel.Margins.Right := 8;
  FTitleLabel.Align := alClient;
  FTitleLabel.Caption := ACaption;

  FRemoveButton := TUniButton.Create(AOwnerForm);
  FRemoveButton.Parent := FHeaderPanel;
  FRemoveButton.AlignWithMargins := True;
  FRemoveButton.Margins.Top := 4;
  FRemoveButton.Margins.Right := 4;
  FRemoveButton.Align := alRight;
  FRemoveButton.Width := 90;
  FRemoveButton.Caption := #1059#1076#1072#1083#1080#1090#1100;
  FRemoveButton.Tag := NativeInt(Self);
  FRemoveButton.OnClick := AOwnerForm.FilterRemoveButtonClick;

  FDisableCheck := TUniCheckBox.Create(AOwnerForm);
  FDisableCheck.Parent := FPanel;
  FDisableCheck.AlignWithMargins := True;
  FDisableCheck.Margins.Left := 8;
  FDisableCheck.Margins.Top := 4;
  FDisableCheck.Margins.Right := 8;
  FDisableCheck.Align := alTop;
  FDisableCheck.Caption := #1054#1090#1082#1083#1102#1095#1080#1090#1100' '#1092#1080#1083#1100#1090#1088;

  FMemo := TUniMemo.Create(AOwnerForm);
  FMemo.Parent := FPanel;
  FMemo.AlignWithMargins := True;
  FMemo.Margins.Left := 8;
  FMemo.Margins.Top := 4;
  FMemo.Margins.Right := 8;
  FMemo.Margins.Bottom := 8;
  FMemo.Align := alClient;
//!!!  FMemo.ScrollBars := ssVertical;

  FPanel.SendToBack;

  if Assigned(AFilter) then
  begin
    FDisableCheck.Checked := AFilter.Disable;
    ConditionsArray := AFilter.Conditions.SerializeList;
    try
      if Assigned(ConditionsArray) then
        FMemo.Text := ConditionsArray.ToJSON
      else
        FMemo.Text := '[]';
    finally
      ConditionsArray.Free;
    end;
  end
  else
    FMemo.Text := '[]';

  UpdateCaption(ACaption);
end;

destructor TFilterEditorItem.Destroy;
begin
  if Assigned(FPanel) then
  begin
    FPanel.Parent := nil;
    FPanel.Free;
  end;
  inherited;
end;

function TFilterEditorItem.FillFilter(AFilter: TProfileFilter; out AErrorMessage: string): Boolean;
var
  JSONValue: TJSONValue;
  JSONArray: TJSONArray;
begin
  Result := False;
  AErrorMessage := '';

  if not Assigned(AFilter) then
    Exit;

  AFilter.Disable := FDisableCheck.Checked;
  AFilter.Conditions.Clear;

  if Trim(FMemo.Text) = '' then
  begin
    Result := True;
    Exit;
  end;

  JSONValue := TJSONObject.ParseJSONValue(FMemo.Text);
  try
    if not (JSONValue is TJSONArray) then
    begin
      AErrorMessage := rsInvalidFilterJSON;
      Exit;
    end;

    JSONArray := TJSONArray(JSONValue);
    try
      AFilter.Conditions.ParseList(JSONArray);
    except
      on E: Exception do
      begin
        AErrorMessage := Format(rsFilterParseError, [E.Message]);
        Exit;
      end;
    end;
  finally
    JSONValue.Free;
  end;

  Result := True;
end;

procedure TFilterEditorItem.UpdateCaption(const ACaption: string);
begin
  if Assigned(FTitleLabel) then
    FTitleLabel.Caption := ACaption;
end;

{ TRuleEditForm }

procedure TRuleEditForm.AfterConstruction;
begin
  inherited;

  FIncFilterEditors := TObjectList<TObject>.Create(True);
  FExcFilterEditors := TObjectList<TObject>.Create(True);
end;

function RuleEditForm: TRuleEditForm;
begin
  Result := TRuleEditForm(UniMainModule.GetFormInstance(TRuleEditForm));
end;

function TRuleEditForm.Apply: boolean;
var
  Rule: TRule;
  SmallRule: TSmallRule;
  ChannelsText: string;
  ChannelsValue: TJSONValue;
  Filter: TProfileFilter;
  ErrorMessage: string;
  EditorObj: TObject;
  Editor: TFilterEditorItem;
  Handler: string;
begin
  Result := inherited Apply();

  if not Result then
    Exit;

  Rule := GetRule;
  if not Assigned(Rule) then
    Exit(False);

  Rule.Ruid := teRuid.Text;

//!!!  SmallRule := Rule.Rule;
  SmallRule.Position := StrToIntDef(tePosition.Text, 0);
  SmallRule.Priority := StrToIntDef(tePriority.Text, 0);
  SmallRule.Doubles := chkDoubles.Checked;
  SmallRule.BreakRule := chkBreakRule.Checked;

  SmallRule.Handlers.ClearStrings;
  for Handler in meHandlers.Lines do
  begin
//!!!    Handler := Trim(Handler);
    if Handler <> '' then
      SmallRule.Handlers.AddString(Handler);
  end;

  ChannelsText := Trim(meChannels.Text);
  SmallRule.Channels.Clear;
  if ChannelsText <> '' then
  begin
    ChannelsValue := TJSONObject.ParseJSONValue(ChannelsText);
    if not Assigned(ChannelsValue) then
    begin
      MessageDlg(rsInvalidChannelsJSON, TMsgDlgType.mtError, [mbOK], nil);
      Exit(False);
    end;
    try
      if ChannelsValue is TJSONObject then
        SmallRule.Channels.Parse(TJSONObject(ChannelsValue))
      else if ChannelsValue is TJSONArray then
        SmallRule.Channels.ParseList(TJSONArray(ChannelsValue))
      else
      begin
        MessageDlg(rsInvalidChannelsJSON, TMsgDlgType.mtError, [mbOK], nil);
        Exit(False);
      end;
    finally
      ChannelsValue.Free;
    end;
  end;

  SmallRule.IncFilters.Clear;
  for EditorObj in FIncFilterEditors do
  begin
    Editor := TFilterEditorItem(EditorObj);
    Filter := TProfileFilter.Create;
    if not Editor.FillFilter(Filter, ErrorMessage) then
    begin
      Filter.Free;
      if ErrorMessage <> '' then
        MessageDlg(ErrorMessage, TMsgDlgType.mtError, [mbOK], nil);
      Exit(False);
    end;
    SmallRule.IncFilters.Add(Filter);
  end;

  SmallRule.ExcFilters.Clear;
  for EditorObj in FExcFilterEditors do
  begin
    Editor := TFilterEditorItem(EditorObj);
    Filter := TProfileFilter.Create;
    if not Editor.FillFilter(Filter, ErrorMessage) then
    begin
      Filter.Free;
      if ErrorMessage <> '' then
        MessageDlg(ErrorMessage, TMsgDlgType.mtError, [mbOK], nil);
      Exit(False);
    end;
    SmallRule.ExcFilters.Add(Filter);
  end;

  Result := True;
end;

procedure TRuleEditForm.btnAddExcFilterClick(Sender: TObject);
begin
  AddFilterEditor(FExcFilterEditors, sbExcFilters, ExcFilterCaptionBase, fkExclude);
  UpdateFilterCaptions(FExcFilterEditors, ExcFilterCaptionBase);
end;

procedure TRuleEditForm.btnAddIncFilterClick(Sender: TObject);
begin
  AddFilterEditor(FIncFilterEditors, sbIncFilters, IncFilterCaptionBase, fkInclude);
  UpdateFilterCaptions(FIncFilterEditors, IncFilterCaptionBase);
end;

procedure TRuleEditForm.ClearFilterEditors(AEditors: TObjectList<TObject>);
begin
  if not Assigned(AEditors) then
    Exit;

  AEditors.Clear;
end;

destructor TRuleEditForm.Destroy;
begin
  FIncFilterEditors.Free;
  FExcFilterEditors.Free;
  inherited;
end;

function TRuleEditForm.DoCheck: Boolean;
begin
  Result := inherited DoCheck();

  if not Result then
    Exit;

  if teRuid.Text = '' then
  begin
    MessageDlg(Format(rsWarningValueNotSetInField, [lRuid.Caption]), TMsgDlgType.mtWarning, [mbOK], nil);
    Exit(False);
  end;

  Result := True;
end;

procedure TRuleEditForm.FilterRemoveButtonClick(Sender: TObject);
var
  Button: TUniButton;
  Editor: TFilterEditorItem;
  Index: Integer;
begin
  if not (Sender is TUniButton) then
    Exit;

  Button := TUniButton(Sender);
  Editor := TFilterEditorItem(Pointer(Button.Tag));
  if not Assigned(Editor) then
    Exit;

  case Editor.Kind of
    fkInclude:
      begin
        Index := FIncFilterEditors.IndexOf(Editor);
        if Index >= 0 then
          FIncFilterEditors.Delete(Index);
        UpdateFilterCaptions(FIncFilterEditors, IncFilterCaptionBase);
      end;
    fkExclude:
      begin
        Index := FExcFilterEditors.IndexOf(Editor);
        if Index >= 0 then
          FExcFilterEditors.Delete(Index);
        UpdateFilterCaptions(FExcFilterEditors, ExcFilterCaptionBase);
      end;
  end;
end;

function TRuleEditForm.GetRule: TRule;
begin
  Result := nil;
  if not (FEntity is TRule) then
  begin
    Log('TRuleEditForm.GetRule error in FEntity type', lrtError);
    Exit;
  end;

  Result := TRule(FEntity);
end;

procedure TRuleEditForm.SetEntity(AEntity: TFieldSet);
var
  Rule: TRule;
  SmallRule: TSmallRule;
  Value: string;
  ChannelsObject: TJSONObject;
  Filter: TProfileFilter;
  I: Integer;
begin
  if not (AEntity is TRule) then
  begin
    Log('TRuleEditForm.SetEntity error in AEntity type', lrtError);
    Exit;
  end;

  try
    inherited SetEntity(AEntity);

    Rule := GetRule;
    if not Assigned(Rule) then
      Exit;

    teRuid.Text := Rule.Ruid;

//!!!    SmallRule := Rule.Rule;
    tePosition.Text := IntToStr(SmallRule.Position);
    tePriority.Text := IntToStr(SmallRule.Priority);
    chkDoubles.Checked := SmallRule.Doubles;
    chkBreakRule.Checked := SmallRule.BreakRule;

    meHandlers.Lines.Clear;
    for Value in SmallRule.Handlers.ToStringArray do
      meHandlers.Lines.Add(Value);

    ChannelsObject := TJSONObject.Create;
    try
      SmallRule.Channels.Serialize(ChannelsObject);
      if ChannelsObject.Count > 0 then
        meChannels.Text := ChannelsObject.ToJSON
      else
        meChannels.Text := '';
    finally
      ChannelsObject.Free;
    end;

    ClearFilterEditors(FIncFilterEditors);
    for I := 0 to SmallRule.IncFilters.Count - 1 do
    begin
      Filter := SmallRule.IncFilters.Filters[I];
      AddFilterEditor(FIncFilterEditors, sbIncFilters, IncFilterCaptionBase, fkInclude, Filter);
    end;
    if FIncFilterEditors.Count = 0 then
      AddFilterEditor(FIncFilterEditors, sbIncFilters, IncFilterCaptionBase, fkInclude);
    UpdateFilterCaptions(FIncFilterEditors, IncFilterCaptionBase);

    ClearFilterEditors(FExcFilterEditors);
    for I := 0 to SmallRule.ExcFilters.Count - 1 do
    begin
      Filter := SmallRule.ExcFilters.Filters[I];
      AddFilterEditor(FExcFilterEditors, sbExcFilters, ExcFilterCaptionBase, fkExclude, Filter);
    end;
    if FExcFilterEditors.Count = 0 then
      AddFilterEditor(FExcFilterEditors, sbExcFilters, ExcFilterCaptionBase, fkExclude);
    UpdateFilterCaptions(FExcFilterEditors, ExcFilterCaptionBase);

  except
    Log('TRuleEditForm.SetEntity error', lrtError);
  end;
end;

procedure TRuleEditForm.AddFilterEditor(AEditors: TObjectList<TObject>; AScrollBox: TUniScrollBox;
  const ACaptionBase: string; AKind: TFilterListKind; AFilter: TProfileFilter);
var
  Caption: string;
  Editor: TFilterEditorItem;
begin
  Caption := Format('%s %d', [ACaptionBase, AEditors.Count + 1]);
  Editor := TFilterEditorItem.Create(Self, AScrollBox, Caption, AKind, AFilter);
  AEditors.Add(Editor);
end;

procedure TRuleEditForm.UpdateFilterCaptions(AEditors: TObjectList<TObject>;
  const ACaptionBase: string);
var
  Index: Integer;
  Editor: TFilterEditorItem;
begin
  for Index := 0 to AEditors.Count - 1 do
  begin
    Editor := TFilterEditorItem(AEditors[Index]);
    Editor.UpdateCaption(Format('%s %d', [ACaptionBase, Index + 1]));
  end;
end;

end.
