unit ProfileFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, EntityUnit,
  KeyValUnit, SmallRuleUnit, FilterUnit, ConditionUnit, SharedFrameRuleConditionUnit,
  uniGUIClasses, uniGUIFrame, uniSplitter, uniMultiItem, uniListBox, LinkUnit,
  uniGUIBaseClasses, uniGroupBox, ProfileUnit, SharedFrameTextInput, uniButton,
  uniPanel, uniComboBox, uniCheckBox, Vcl.StdCtrls, Vcl.Buttons, uniTreeView,
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
  private
    FProfile: TProfile;
    FFTACheckboxes: TKeyValue<TUniCheckbox>;
    FConditionFrame: TFrameRuleCondition;
    FLink: TLink;
    FSelectedRuleItem: TObject;
    FSelecteNode: TUniTreeNode;
    procedure RuleToTreeView(rule: TSmallRule);
    procedure FiltersToTreeViewNode(filters: TFilterList; node: TUniTreeNode);
    procedure ConditionToFrame(c: TCondition);
    procedure TidyRuleControls;
    procedure DrawRules;
    function DeletObject(f: TFieldSetList; o: TObject): boolean;
    procedure OnConditionChange(Sender: TObject);
  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetData(src: TProfile); virtual;
    procedure GetData(dst: TProfile); virtual;
    procedure SetLink(link: TLink); virtual;

  end;

implementation
uses
  LoggingUnit,
  ProfilesBrokerUnit,
  uniGUIDialogs;

{$R *.dfm}



{ TProfileFrame }



constructor TProfileFrame.Create(AOwner: TComponent);
begin
  inherited;
  FFTACheckboxes := TKeyValue<TUniCheckbox>.Create;
  FFTACheckboxes.Add('fta_XML', CheckBox_fta_FILE);
  FFTACheckboxes.Add('fta_JSON', CheckBox_fta_FILE);
  FFTACheckboxes.Add('fta_SIMPLE', CheckBox_fta_FILE);
  FFTACheckboxes.Add('fta_GAO', CheckBox_fta_FILE);
  FFTACheckboxes.Add('fta_TLG', CheckBox_fta_FILE);
  FFTACheckboxes.Add('fta_TLF', CheckBox_fta_FILE);
  FFTACheckboxes.Add('fta_FILE', CheckBox_fta_FILE);
end;



destructor TProfileFrame.Destroy;
begin
  FFTACheckboxes.Free;
  FreeAndNil(FProfile);
  inherited;
end;




procedure TProfileFrame.SetData(src: TProfile);
begin
  FreeAndNil(FProfile);
  if src = nil then
    exit;
  FProfile := src;
  PridFrame.Edit.Text := FProfile.Id;
  DescriptionFrame.Edit.Text := FProfile.Description;
  DescriptionFrame.Edit.Readonly := not FProfile.IsNew;
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

end;


procedure TProfileFrame.SetLink(link: TLink);
begin
  FLink := link;
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

procedure TProfileFrame.RuleToTreeView(rule: TSmallRule);
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

procedure TProfileFrame.FiltersToTreeViewNode(filters: TFilterList;
  node: TUniTreeNode);
begin
  for var i := 0 to filters.Count-1 do
  begin
    var filter := (filters[i] as TFilter);
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
  if FSelectedRuleItem is TFilter then
  begin
    btnAddRules.Visible := true;
    btnRemoveRules.Visible := true;
    btnAddRules.Hint := 'добавить условие';
    btnRemoveRules.Hint := 'удалить фильтр';
    exit;
  end;
  if FSelectedRuleItem is TFilterList then
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
  if FSelectedRuleItem is TFilter then
  begin
    (FSelectedRuleItem as TFilter).Conditions.Add(TCondition.Create);
    DrawRules;
    exit;
  end;
  if FSelectedRuleItem is TFilterList then
  begin
    (FSelectedRuleItem as TFilterList).Add(TFilter.Create);
    DrawRules;
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
    if not (TObject(FSelecteNode.Parent.Data) is TFilter) then
      exit;
    var f := (TObject(FSelecteNode.Parent.Data) as TFilter);
    if not DeletObject(f.Conditions, FSelectedRuleItem) then
      exit;
  end;

  if FSelectedRuleItem is TFilter then
  begin
    var q := Format('Удалить фильтр (%d условий)?', [(FSelectedRuleItem as TFilter).Conditions.Count]);
    if MessageDlg(q, mtConfirmation, mbYesNo) <> mrYes then
      exit;
    if not (TObject(FSelecteNode.Parent.Data) is TFilterList) then
      exit;
    var f := (TObject(FSelecteNode.Parent.Data) as TFilterList);
    if not DeletObject(f, FSelectedRuleItem) then
      exit;
  end;

  DrawRules;
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
end;


end.
