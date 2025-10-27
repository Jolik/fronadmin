unit SharedFrameRuleConditionUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, ConditionUnit,
  KeyValUnit, LinkUnit,
  uniGUIClasses, uniGUIFrame, uniEdit, uniMultiItem, uniComboBox, uniPanel,
  uniGUIBaseClasses, uniGroupBox, uniButton, uniBitBtn;

type
  TFrameRuleCondition = class(TUniFrame)
    GroupBoxCondition: TUniGroupBox;
    UniPanel5: TUniPanel;
    UniPanel6: TUniPanel;
    ComboBoxRuleField: TUniComboBox;
    UniPanel3: TUniPanel;
    UniPanel4: TUniPanel;
    EditRuleText: TUniEdit;
    UniPanel7: TUniPanel;
    UniPanel8: TUniPanel;
    ComboBoxRuleType: TUniComboBox;
    UniPanel1: TUniPanel;
    btnOK: TUniBitBtn;
    procedure btnOKClick(Sender: TObject);
  private
    FRuleComboIndex: TKeyValue<integer>;
    FLinkType: TLinkType;
    FOnOk: TNotifyEvent;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetData(src: TCondition); virtual;
    procedure GetData(dst: TCondition); virtual;
    // SetLinkFields допустимые поля к которым применять правила (константы для линов)
    procedure SetLinkType(lt: TLinkType); virtual;
    property OnOk: TNotifyEvent read FOnOk write FOnOk;
  end;

implementation

{$R *.dfm}




constructor TFrameRuleCondition.Create(AOwner: TComponent);
begin
  inherited;
  FRuleComboIndex := TKeyValue<integer>.Create;
  FRuleComboIndex.Add('equ', 0);
  FRuleComboIndex.Add('regex', 1);
  FRuleComboIndex.Add('mask', 2);
end;

destructor TFrameRuleCondition.Destroy;
begin
  FRuleComboIndex.Free;
  inherited;
end;




{ TFrameRuleCondition }

procedure TFrameRuleCondition.SetData(src: TCondition);
begin
  if src = nil then
  begin
    ComboBoxRuleField.ItemIndex := -1;
    ComboBoxRuleType.ItemIndex := -1;
    EditRuleText.Text := '';
    exit;
  end;

  ComboBoxRuleField.Items.Clear;
  for var s in LinkConditionFields.Items[FLinkType] do
    ComboBoxRuleField.Items.Add(s);

  ComboBoxRuleField.ItemIndex := ComboBoxRuleField.Items.IndexOf(src.Field);
  ComboBoxRuleType.ItemIndex := FRuleComboIndex.ValueByKey(src.&Type, -1);
  EditRuleText.Text := src.Text;
end;



procedure TFrameRuleCondition.SetLinkType(lt: TLinkType);
begin
  FLinkType := lt;
end;

procedure TFrameRuleCondition.GetData(dst: TCondition);
begin
  dst.Text := EditRuleText.Text;
  dst.Field := ComboBoxRuleField.Text;
  dst.&Type := FRuleComboIndex.KeyByValue(ComboBoxRuleType.ItemIndex, 'equ');
end;


procedure TFrameRuleCondition.btnOKClick(Sender: TObject);
begin
  if Assigned(FOnOk) then
    FOnOk(Sender);
end;



end.
