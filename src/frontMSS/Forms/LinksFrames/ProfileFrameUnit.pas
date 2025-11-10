unit ProfileFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, EntityUnit,
  KeyValUnit, FilterUnit, ConditionUnit, SharedFrameRuleConditionUnit,
  uniGUIClasses, uniGUIFrame, uniSplitter, uniMultiItem, uniListBox, LinkUnit,
  uniGUIBaseClasses, uniGroupBox, ProfileUnit, SharedFrameTextInput, uniButton,
  uniPanel, uniComboBox, uniCheckBox, Vcl.StdCtrls, Vcl.Buttons, uniTreeView,
  ProfileRuleUnit,
  uniTreeMenu, uniEdit, SharedFrameBoolInput, uniBitBtn;

type
  TProfileFrame = class(TUniFrame)
    UniGroupBox1: TUniGroupBox;
    UniSplitter1: TUniSplitter;
    UniGroupBox2: TUniGroupBox;
    PridFrame: TFrameTextInput;
    FtaGroupBox: TUniGroupBox;
    CheckBox_fta_XML: TUniCheckBox;
    CheckBox_fta_JSON: TUniCheckBox;
    CheckBox_fta_SIMPLE: TUniCheckBox;
    CheckBox_fta_GAO: TUniCheckBox;
    CheckBox_fta_TLG: TUniCheckBox;
    CheckBox_fta_TLF: TUniCheckBox;
    CheckBox_fta_FILE: TUniCheckBox;
    DescriptionFrame: TFrameTextInput;
    UniPanel1: TUniPanel;
    UniPanel2: TUniPanel;
    UniSplitter2: TUniSplitter;
    FrameRuleEnabled: TFrameBoolInput;
    FrameRulePosition: TFrameTextInput;
    PanelConditions: TUniPanel;
    UniPanel3: TUniPanel;
    RuleTreeView: TUniTreeView;
    UniPanel4: TUniPanel;
    UniPanel5: TUniPanel;
    btnAddRules: TUniBitBtn;
    UniPanel6: TUniPanel;
    btnRemoveRules: TUniBitBtn;
    procedure RuleTreeViewChange(Sender: TObject; Node: TUniTreeNode);
    procedure btnAddRulesClick(Sender: TObject);
    procedure btnRemoveRulesClick(Sender: TObject);
    procedure DescriptionFrameEditChange(Sender: TObject);
    procedure FrameRuleEnabledCheckBoxChange(Sender: TObject);
    procedure FrameRulePositionEditChange(Sender: TObject);
    procedure CheckBox_fta_FILEChange(Sender: TObject);
    procedure CheckBox_fta_TLFChange(Sender: TObject);
    procedure CheckBox_fta_TLGChange(Sender: TObject);
    procedure CheckBox_fta_GAOChange(Sender: TObject);
    procedure CheckBox_fta_SIMPLEChange(Sender: TObject);
    procedure CheckBox_fta_JSONChange(Sender: TObject);
    procedure CheckBox_fta_XMLChange(Sender: TObject);
  private
    FProfile: TProfile;
    FFTACheckboxes: TKeyValue<TUniCheckbox>;
    FConditionFrame: TFrameRuleCondition;
    FLink: TLink;
    FSelectedRuleItem: TObject;
    FSelecteNode: TUniTreeNode;
    FOnChange: TNotifyEvent;
    procedure RuleToTreeView(rule: TProfileRule);
    procedure FiltersToTreeViewNode(filters: TProfileFilterList; node: TUniTreeNode);
    procedure ConditionToFrame(c: TCondition);
    procedure TidyRuleControls;
    procedure DrawRules;
    function DeletObject(f: TFieldSetList; o: TObject): boolean;
    procedure OnConditionChange(Sender: TObject);
  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetData(srcProfile: TProfile; srclink: TLink); virtual;
    procedure GetData(dst: TProfile); virtual;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

implementation
uses
  LoggingUnit;

{$R *.dfm}



{ TProfileFrame }



constructor TProfileFrame.Create(AOwner: TComponent);
begin
  inherited;
  FFTACheckboxes := TKeyValue<TUniCheckbox>.Create;
  FFTACheckboxes.Add('fta_XML', CheckBox_fta_XML);
  FFTACheckboxes.Add('fta_JSON', CheckBox_fta_JSON);
  FFTACheckboxes.Add('fta_SIMPLE', CheckBox_fta_SIMPLE);
  FFTACheckboxes.Add('fta_GAO', CheckBox_fta_GAO);
  FFTACheckboxes.Add('fta_TLG', CheckBox_fta_TLG);
  FFTACheckboxes.Add('fta_TLF', CheckBox_fta_TLF);
  FFTACheckboxes.Add('fta_FILE', CheckBox_fta_FILE);
end;



procedure TProfileFrame.DescriptionFrameEditChange(Sender: TObject);
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

destructor TProfileFrame.Destroy;
begin
  FFTACheckboxes.Free;
  inherited;
end;




procedure TProfileFrame.SetData(srcProfile: TProfile; srclink: TLink);
begin
  FLink := srclink;
  if srcProfile = nil then
    exit;
  FProfile := srcProfile;
  PridFrame.Edit.Text := FProfile.Id;
  DescriptionFrame.Edit.Text := FProfile.Description;
  if FProfile.ProfileBody = nil then
    exit;
  for var fta in FProfile.ProfileBody.Play.FTA.ToArray do
  begin
    var cb := FFTACheckboxes.ValueByKey(fta, nil);
    if cb <> nil then
      cb.Checked := true
    else
      Log('TProfileFrame.SetData unknown FTA: '+fta, lrtError);
  end;
  DrawRules;
end;

procedure TProfileFrame.GetData(dst: TProfile);
begin
  if FProfile = nil then
    exit;
  FProfile.ProfileBody.Play.FTA.Clear;
  for var cb in FFTACheckboxes.Values do
    if cb.Checked then
      FProfile.ProfileBody.Play.FTA.Add( FFTACheckboxes.KeyByValue(cb) );
  FProfile.Description := DescriptionFrame.Edit.Text;
  (FProfile.Body as TProfileBody).Rule.Enabled := FrameRuleEnabled.GetData;
  (FProfile.Body as TProfileBody).Rule.Position := FrameRulePosition.GetDataInt(0);
end;



procedure TProfileFrame.DrawRules;
begin
  FSelectedRuleItem := nil;
  FSelecteNode := nil;
  ConditionToFrame(nil);
  RuleToTreeView(FProfile.ProfileBody.Rule);
  RuleTreeView.FullExpand;
  RuleTreeView.Selected := nil;
  TidyRuleControls;
end;

procedure TProfileFrame.RuleToTreeView(rule: TProfileRule);
begin
  FrameRuleEnabled.SetData(rule.Enabled);
  FrameRulePosition.SetData(rule.Position);
  RuleTreeView.Items.Clear;
  var root := RuleTreeView.Items.AddChildObject(nil, 'фильтры', nil);
  var incFiltersNode := RuleTreeView.Items.AddChildObject(root, 'включающие', rule.IncFilters);
  var excFiltersNode := RuleTreeView.Items.AddChildObject(root, 'исключающие', rule.ExcFilters);
  root.CheckboxVisible := false;
  incFiltersNode.CheckboxVisible := false;
  excFiltersNode.CheckboxVisible := false;
  FiltersToTreeViewNode(rule.IncFilters, incFiltersNode);
  FiltersToTreeViewNode(rule.ExcFilters, excFiltersNode);
end;


procedure TProfileFrame.FiltersToTreeViewNode(filters: TProfileFilterList;
  node: TUniTreeNode);
begin
  for var i := 0 to filters.Count-1 do
  begin
    var filter := (filters[i] as TProfileFilter);
    var filterNode := RuleTreeView.Items.AddChildObject(node, 'фильтр-' + IntToStr(i), filter);
    filterNode.CheckboxVisible := true;
    filterNode.Checked := not filter.Disable;
    for var j := 0 to filter.Conditions.Count-1 do
    begin
      var condition := (filter.Conditions[j] as TCondition);
      var c := RuleTreeView.Items.AddChildObject(filterNode, condition.Caption, condition);
      c.CheckboxVisible := false;
    end;
  end;
end;



procedure TProfileFrame.FrameRuleEnabledCheckBoxChange(Sender: TObject);
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TProfileFrame.FrameRulePositionEditChange(Sender: TObject);
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TProfileFrame.CheckBox_fta_FILEChange(Sender: TObject);
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TProfileFrame.CheckBox_fta_GAOChange(Sender: TObject);
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TProfileFrame.CheckBox_fta_JSONChange(Sender: TObject);
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TProfileFrame.CheckBox_fta_SIMPLEChange(Sender: TObject);
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TProfileFrame.CheckBox_fta_TLFChange(Sender: TObject);
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TProfileFrame.CheckBox_fta_TLGChange(Sender: TObject);
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TProfileFrame.CheckBox_fta_XMLChange(Sender: TObject);
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TProfileFrame.ConditionToFrame(c: TCondition);
begin
  FreeAndNil(FConditionFrame);
  if c = nil then
    exit;
  FConditionFrame := TFrameRuleCondition.Create(self);
  FConditionFrame.Parent := PanelConditions;
  FConditionFrame.Align := alClient;
  FConditionFrame.SetLinkType(FLink.LinkType);
  FConditionFrame.SetData(c);
  FConditionFrame.OnOK := OnConditionChange;
end;



procedure TProfileFrame.RuleTreeViewChange(Sender: TObject; Node: TUniTreeNode);
begin
  FSelecteNode := Node;
  if Node = nil then
    exit;
  FSelectedRuleItem := TObject(Node.Data);
  TidyRuleControls;
  if FSelectedRuleItem is TCondition then
    ConditionToFrame(FSelectedRuleItem as TCondition)
  else
    ConditionToFrame(nil);
end;


procedure TProfileFrame.TidyRuleControls;
begin
  if FSelectedRuleItem is TCondition then
  begin
    btnAddRules.Visible := false;
    btnRemoveRules.Visible := true;
    btnRemoveRules.Hint := 'удалить условие';
    exit;
  end;
  if FSelectedRuleItem is TProfileFilter then
  begin
    btnAddRules.Visible := true;
    btnRemoveRules.Visible := true;
    btnAddRules.Hint := 'добавить условие';
    btnRemoveRules.Hint := 'удалить фильтр';
    exit;
  end;
  if FSelectedRuleItem is TProfileFilterList then
  begin
    btnAddRules.Visible := true;
    btnRemoveRules.Visible := false;
    btnAddRules.Hint := 'добавить фильтр';
    exit;
  end;
  btnAddRules.Visible := false;
  btnRemoveRules.Visible := false;
end;


procedure TProfileFrame.btnAddRulesClick(Sender: TObject);
begin
  if FSelectedRuleItem is TProfileFilter then
  begin
    (FSelectedRuleItem as TProfileFilter).Conditions.Add(TCondition.Create);
    DrawRules;
    exit;
  end;
  if FSelectedRuleItem is TProfileFilterList then
  begin
    (FSelectedRuleItem as TProfileFilterList).Add(TProfileFilter.Create);
    DrawRules;
    if Assigned(FOnChange) then
      FOnChange(Self);
    exit;
  end;
end;



procedure TProfileFrame.btnRemoveRulesClick(Sender: TObject);
begin
  if FSelectedRuleItem = nil then
    exit;

  if FSelectedRuleItem is TCondition then
  begin
    var q := Format('Удалить условие %s?', [(FSelectedRuleItem as TCondition).Caption]);
    if MessageDlg(q, mtConfirmation, mbYesNo) <> mrYes then
      exit;
    if not (TObject(FSelecteNode.Parent.Data) is TProfileFilter) then
      exit;
    var f := (TObject(FSelecteNode.Parent.Data) as TProfileFilter);
    if not DeletObject(f.Conditions, FSelectedRuleItem) then
      exit;
  end;

  if FSelectedRuleItem is TProfileFilter then
  begin
    var q := Format('Удалить фильтр (%d условий)?', [(FSelectedRuleItem as TProfileFilter).Conditions.Count]);
    if MessageDlg(q, mtConfirmation, mbYesNo) <> mrYes then
      exit;
    if not (TObject(FSelecteNode.Parent.Data) is TProfileFilterList) then
      exit;
    var f := (TObject(FSelecteNode.Parent.Data) as TProfileFilterList);
    if not DeletObject(f, FSelectedRuleItem) then
      exit;
  end;

  DrawRules;
  if Assigned(FOnChange) then
    FOnChange(Self);
end;


function TProfileFrame.DeletObject(f: TFieldSetList; o: TObject): boolean;
begin
  result := false;
  for var i := 0 to f.Count-1 do
    if f[i] = o then
    begin
      f.Delete(i);
      result := true;
      exit;
    end;
end;

procedure TProfileFrame.OnConditionChange(Sender: TObject);
begin
  if not (FSelectedRuleItem is TCondition) then
    exit;
  if FConditionFrame = nil then
    exit;
  FConditionFrame.GetData(FSelectedRuleItem as TCondition);
  DrawRules;
  if Assigned(FOnChange) then
    FOnChange(Self);
end;


end.
