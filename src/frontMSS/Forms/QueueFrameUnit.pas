unit QueueFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, LoggingUnit,
  uniGUIClasses, uniGUIFrame, uniGUIBaseClasses, uniGroupBox,
  QueueUnit, SharedFrameQueueFilterUnit, FilterUnit, ConditionUnit,
  SharedFrameTextInput, SharedFrameBoolInput, uniDBNavigator, uniBasicGrid,
  uniDBGrid, uniPanel, FireDAC.Stan.Intf, FireDAC.Stan.Option, EntityUnit,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  uniButton, uniBitBtn, uniTreeView, uniSplitter, SharedFrameCombobox,
  uniMultiItem, uniComboBox;

type
  TQueueFrame = class(TUniFrame)
    UniGroupBox1: TUniGroupBox;
    FrameQID: TFrameTextInput;
    FrameCaption: TFrameTextInput;
    FrameDoubles: TFrameBoolInput;
    FrameAllowPut: TFrameBoolInput;
    UniGroupBox2: TUniGroupBox;
    UniPanel2: TUniPanel;
    UniSplitter2: TUniSplitter;
    PanelConditions: TUniPanel;
    UniPanel3: TUniPanel;
    RuleTreeView: TUniTreeView;
    UniPanel4: TUniPanel;
    UniPanel5: TUniPanel;
    btnAddRules: TUniBitBtn;
    UniPanel6: TUniPanel;
    btnRemoveRules: TUniBitBtn;
    panelFilterType: TUniPanel;
    comboFilterType: TUniComboBox;
    UniPanel7: TUniPanel;
    procedure RuleTreeViewChange(Sender: TObject; Node: TUniTreeNode);
    procedure btnRemoveRulesClick(Sender: TObject);
    procedure btnAddRulesClick(Sender: TObject);
    procedure comboFilterTypeChange(Sender: TObject);
  private
    { Private declarations }
    FQueue: TQueue;
    FSelecteNode: TUniTreeNode;
    FSelectedFilterItem: TObject;
    FConditionFrame: TQueueConditionFrame;
    procedure DrawFiltersTree();
    procedure ConditionToNode(condition: TCondition; node: TUniTreeNode);
    procedure TidyRuleControls;
    procedure ShowFilterSetup();
    procedure OnConditionChange(Sender: TObject);
    function DeletObject(f: TFieldSetList; o: TObject): boolean;
    procedure Refresh;
  public
    { Public declarations }
    procedure SetData(src: TQueue); virtual; // объект -> фрейм
    procedure GetData(dst: TQueue); virtual; // фрейм -> объект
  end;

implementation

{$R *.dfm}



{ TQueueFrame }


procedure TQueueFrame.SetData(src: TQueue);
begin
  if not(src is TQueue) then
    exit;
  FQueue := src;
  FrameCaption.SetData(src.Caption);
  FrameQID.SetData(src.Qid);
  FrameAllowPut.SetData(src.AllowPut);
  FrameDoubles.SetData(src.Doubles);
  DrawFiltersTree();
end;


procedure TQueueFrame.ConditionToNode(condition: TCondition;
  node: TUniTreeNode);
begin
  var s := Format('[%s %s %s]', [condition.Field, condition.&Type, condition.Text]);
  node := RuleTreeView.Items.AddChildObject(node, s, condition);
  node.CheckboxVisible := false;
end;



procedure TQueueFrame.DrawFiltersTree();
begin
  RuleTreeView.Items.Clear;
  var root := RuleTreeView.Items.AddChildObject(nil, 'фильтры', FQueue.Filters);
  root.CheckboxVisible := false;
  for var i := 0 to FQueue.Filters.Count-1  do
  begin
    var filter := FQueue.Filters[i] as TQueueFilter;
    var s: string;
    if filter.Sig = 'inc' then
      s := 'включающий'
    else if filter.Sig = 'exc' then
      s := 'исключающий'
    else
      s := '';
    var node := RuleTreeView.Items.AddChildObject(root, s, filter);
    node.CheckboxVisible := false;
    for var j := 0 to filter.Filters.Count-1 do
       ConditionToNode(filter.Filters[j], node);
  end;
  RuleTreeView.FullExpand;
end;


procedure TQueueFrame.GetData(dst: TQueue);
begin
  dst.Caption := FrameCaption.GetDataStr;
  dst.AllowPut := FrameAllowPut.GetData;
  dst.Doubles := FrameDoubles.GetData;
end;

procedure TQueueFrame.Refresh;
begin
  DrawFiltersTree();
  TidyRuleControls();
  ShowFilterSetup();
end;

procedure TQueueFrame.RuleTreeViewChange(Sender: TObject; Node: TUniTreeNode);
begin
  FSelecteNode := Node;
  if Node <> nil then
    FSelectedFilterItem := TObject(Node.Data)
  else
    FSelectedFilterItem := nil;
  Refresh;
end;


procedure TQueueFrame.ShowFilterSetup;
begin
  FreeAndNil(FConditionFrame);
  panelFilterType.Visible := false;
  if (FSelectedFilterItem is TCondition) then
  begin
    FConditionFrame := TQueueConditionFrame.Create(Self);
    FConditionFrame.Parent := PanelConditions;
    FConditionFrame.SetData(FSelectedFilterItem as TCondition);
    FConditionFrame.OnOK := OnConditionChange;
    exit;
  end;
  if (FSelectedFilterItem is TQueueFilter) then
  begin
    panelFilterType.Visible := true;
    if (FSelectedFilterItem as TQueueFilter).Sig = 'inc' then
      comboFilterType.ItemIndex := 0
    else
      comboFilterType.ItemIndex := 1;
  end;
end;


procedure TQueueFrame.OnConditionChange(Sender: TObject);
begin
  if not (FSelectedFilterItem is TCondition) then
    exit;
  if FConditionFrame = nil then
    exit;
  FConditionFrame.GetData(FSelectedFilterItem as TCondition);
  Refresh;
end;


procedure TQueueFrame.TidyRuleControls;
begin
  if FSelectedFilterItem is TCondition then
  begin
    btnAddRules.Visible := false;
    btnRemoveRules.Visible := true;
    btnRemoveRules.Hint := 'удалить условие';
    exit;
  end;
  if FSelectedFilterItem is TQueueFilter then
  begin
    btnAddRules.Visible := true;
    btnRemoveRules.Visible := true;
    btnAddRules.Hint := 'добавить условие';
    btnRemoveRules.Hint := 'удалить фильтр';
    exit;
  end;
  if FSelectedFilterItem is TQueueFilterList then
  begin
    btnAddRules.Visible := true;
    btnRemoveRules.Visible := false;
    btnAddRules.Hint := 'добавить фильтр';
    exit;
  end;
  btnAddRules.Visible := false;
  btnRemoveRules.Visible := false;
end;




procedure TQueueFrame.btnRemoveRulesClick(Sender: TObject);
begin
 if FSelectedFilterItem = nil then
    exit;

  if FSelectedFilterItem is TCondition then
  begin
    var q := Format('Удалить условие %s?', [(FSelectedFilterItem as TCondition).Caption]);
    if MessageDlg(q, mtConfirmation, mbYesNo) <> mrYes then
      exit;
    if not (TObject(FSelecteNode.Parent.Data) is TQueueFilter) then
      exit;
    var f := (TObject(FSelecteNode.Parent.Data) as TQueueFilter);
    if not DeletObject(f.Filters, FSelectedFilterItem) then
      exit;
  end;

  if FSelectedFilterItem is TQueueFilter then
  begin
    var q := Format('Удалить фильтр (%d условий)?', [(FSelectedFilterItem as TQueueFilter).Filters.Count]);
    if MessageDlg(q, mtConfirmation, mbYesNo) <> mrYes then
      exit;
    if not (TObject(FSelecteNode.Parent.Data) is TQueueFilterList) then
      exit;
    var f := (TObject(FSelecteNode.Parent.Data) as TQueueFilterList);
    if not DeletObject(f, FSelectedFilterItem) then
      exit;
  end;

  FSelectedFilterItem := nil;
  FSelecteNode := nil;
  Refresh;
end;


procedure TQueueFrame.comboFilterTypeChange(Sender: TObject);
begin
  if not (FSelectedFilterItem is TQueueFilter) then
    exit;
  var f := (FSelectedFilterItem as TQueueFilter);
  if (Sender as TUniComboBox).ItemIndex = 0 then
    f.Sig := 'inc'
  else
    f.Sig := 'exc';
  Refresh;    
end;

function TQueueFrame.DeletObject(f: TFieldSetList; o: TObject): boolean;
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

procedure TQueueFrame.btnAddRulesClick(Sender: TObject);
begin
  if FSelectedFilterItem is TQueueFilter then
  begin
    (FSelectedFilterItem as TQueueFilter).Filters.Add(TCondition.Create);
    Refresh;
    exit;
  end;
  if FSelectedFilterItem is TQueueFilterList then
  begin
    var f := TQueueFilter.Create;
    f.Sig := 'inc';
    (FSelectedFilterItem as TQueueFilterList).Add(f);
    Refresh;
    exit;
  end;
end;


end.
