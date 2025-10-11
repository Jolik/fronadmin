unit SocketSpecialFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, utils,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, System.JSON,
  uniGUIClasses, uniGUIFrame, ParentFrameUnit, SharedFrameConnection,
  SharedFrameTextInput, uniGUIBaseClasses, uniGroupBox, SharedFrameCombobox,
  SharedFrameIntegerInput, uniButton, uniBitBtn, uniPanel, SharedFrameBoolInput;

type
  TSocketSpecialFrame = class(TParentFrame)
    FrameConnection1: TFrameConnection;
    UniGroupBox1: TUniGroupBox;
    FrameProtVer: TFrameCombobox;
    FrameKeyInput: TFrameTextInput;
    FrameCliSrv: TFrameCombobox;
    UniGroupBox2: TUniGroupBox;
    FrameaAckCount: TFrameIntegerInput;
    FrameAckTimeout: TFrameIntegerInput;
    UniPanel1: TUniPanel;
    UniBitBtn1: TUniBitBtn;
    FrameTriggerSize: TFrameIntegerInput;
    FrameTriggerTime: TFrameIntegerInput;
    FrameBufferSize: TFrameIntegerInput;
    FrameConfirmMode: TFrameCombobox;
    FrameTriggerCount: TFrameIntegerInput;
    FrameCompability: TFrameCombobox;
    FrameKeepAlive: TFrameBoolInput;
    procedure FrameCombobox1ComboBoxChange(Sender: TObject);
    procedure UniBitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure DataToFrame(AData: TJSONObject); override;
    procedure DataFromFrame(AData: TJSONObject); override;
  end;

implementation

{$R *.dfm}



procedure TSocketSpecialFrame.DataFromFrame(AData: TJSONObject);
begin
  inherited;

end;

procedure TSocketSpecialFrame.DataToFrame(AData: TJSONObject);
begin
  inherited;
  // connections
  FrameConnection1.DataToFrame(AData);
  var conn := AData.FindValue('main.tasks[0].connections[0]');
  if (conn = nil) or not (conn is TJSONObject) then
    exit;
  FrameKeyInput.Edit.Text := GetValueStrDef(conn, 'key', '');
  // custom
  var custom := AData.FindValue('main.tasks[0].custom');
  if (custom = nil) or not (custom is TJSONObject) then
    exit;
  var contype := GetValueStrDef(custom, 'type', '');
  if contype='client' then
    FrameCliSrv.ComboBox.ItemIndex := 0
  else if contype='server' then
    FrameCliSrv.ComboBox.ItemIndex := 1;
  var prot := custom.FindValue('protocol');
  if (prot = nil) or not (prot is TJSONObject) then
    exit;
  var protVer := GetValueStrDef(prot, 'version', '');
  if protVer = '1' then
    FrameProtVer.ComboBox.ItemIndex := 0
  else if (protVer = '2') or (protVer = '2g') or (protVer = '2G') then
    FrameProtVer.ComboBox.ItemIndex := 1;
  FrameaAckCount.Edit.Text := GetValueStrDef(prot, 'ack_count', '');
  FrameAckTimeout.Edit.Text := GetValueStrDef(prot, 'ack_timeout', '');
  FrameTriggerSize.Edit.Text := GetValueStrDef(prot, 'input_trigger_size', '');
  FrameTriggerTime.Edit.Text := GetValueStrDef(prot, 'input_trigger_time', '');
  FrameTriggerCount.Edit.Text := GetValueStrDef(prot, 'input_trigger_count', '');
  var conf := GetValueStrDef(prot, 'confirmation_mode', '');
  if conf='light' then
    FrameConfirmMode.ComboBox.ItemIndex := 0
  else if conf='normal' then
    FrameConfirmMode.ComboBox.ItemIndex := 1
  else if conf='strong' then
    FrameConfirmMode.ComboBox.ItemIndex := 2;
  FrameBufferSize.Edit.Text := GetValueStrDef(prot, 'max_input_buf_size', '');
  FrameCompability.ComboBox.ItemIndex := FrameCompability.ComboBox.Items.IndexOf(GetValueStrDef(prot, 'compatibility', ''));
  FrameKeepAlive.CheckBox.Checked := GetValueBool(prot, 'keep_alive');
  //TODO: queue
  FrameProtVer.ComboBox.OnChange(self);
end;

procedure TSocketSpecialFrame.FrameCombobox1ComboBoxChange(Sender: TObject);
begin
  inherited;
  FrameKeyInput.Visible := FrameProtVer.ComboBox.ItemIndex = 1;
end;

procedure TSocketSpecialFrame.UniBitBtn1Click(Sender: TObject);
begin
  inherited;
  FrameaAckCount.Edit.Text := '30';
  FrameAckTimeout.Edit.Text := '30';
  FrameTriggerSize.Edit.Text := '1000';
  FrameTriggerTime.Edit.Text := '2';
  FrameTriggerCount.Edit.Text := '30';
  FrameConfirmMode.ComboBox.ItemIndex := 1;
  FrameBufferSize.Edit.Text := '1000000';
  FrameCompability.ComboBox.ItemIndex := 0;
  FrameKeepAlive.CheckBox.Checked := true;
end;

end.
