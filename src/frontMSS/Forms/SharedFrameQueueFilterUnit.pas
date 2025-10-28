unit SharedFrameQueueFilterUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  ConditionUnit,  KeyValUnit,
  uniGUIClasses, uniGUIFrame, uniButton, uniBitBtn, uniEdit, uniMultiItem,
  uniComboBox, uniPanel, uniGUIBaseClasses, uniGroupBox;

type
  TQueueConditionFrame = class(TUniFrame)
    GroupBoxCondition: TUniGroupBox;
    UniPanel3: TUniPanel;
    UniPanel4: TUniPanel;
    EditRuleText: TUniEdit;
    UniPanel7: TUniPanel;
    UniPanel8: TUniPanel;
    ComboBoxRuleType: TUniComboBox;
    UniPanel1: TUniPanel;
    btnOK: TUniBitBtn;
    UniPanel2: TUniPanel;
    UniPanel5: TUniPanel;
    editField: TUniEdit;
    procedure btnOKClick(Sender: TObject);
  private
    FOnOk: TNotifyEvent;
    FRuleComboIndex: TKeyValue<integer>;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    { Public declarations }
    procedure SetData(src: TCondition); virtual;
    procedure GetData(dst: TCondition); virtual;
    property OnOk: TNotifyEvent read FOnOk write FOnOk;
  end;

implementation

{$R *.dfm}



{ TQueueConditionFrame }



constructor TQueueConditionFrame.Create(AOwner: TComponent);
begin
  inherited;
  FRuleComboIndex := TKeyValue<integer>.Create;
  FRuleComboIndex.Add('regex', 0);
  FRuleComboIndex.Add('mask', 1);
end;

destructor TQueueConditionFrame.Destroy;
begin
  FRuleComboIndex.Free;
  inherited;
end;

procedure TQueueConditionFrame.btnOKClick(Sender: TObject);
begin
  if Assigned(FOnOk) then
    FOnOk(Sender);
end;

procedure TQueueConditionFrame.GetData(dst: TCondition);
begin
  dst.Text := EditRuleText.Text;
  dst.Field := editField.Text;
  dst.&Type := FRuleComboIndex.KeyByValue(ComboBoxRuleType.ItemIndex, '');
end;

procedure TQueueConditionFrame.SetData(src: TCondition);
begin
  if src = nil then
  begin
    editField.Text := '';
    ComboBoxRuleType.ItemIndex := -1;
    EditRuleText.Text := '';
    exit;
  end;

  editField.Text := src.Field;
  ComboBoxRuleType.ItemIndex := FRuleComboIndex.ValueByKey(src.&Type, -1);
  EditRuleText.Text := src.Text;
end;

end.
