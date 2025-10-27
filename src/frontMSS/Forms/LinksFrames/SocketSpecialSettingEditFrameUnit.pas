unit SocketSpecialSettingEditFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, ParentLinkSettingEditFrameUnit, uniCheckBox,
  LinkSettingsUnit, KeyValUnit, LinkUnit,
  uniEdit, uniGroupBox, uniSplitter, uniGUIBaseClasses, uniPanel, uniButton,
  SharedFrameBoolInput, SharedFrameTextInput, SharedFrameConnections,
  SharedFrameQueue, SharedFrameCombobox;

type
  TSocketSpecialSettingEditFrame = class(TParentLinkSettingEditFrame)
    FrameConnections1: TFrameConnections;
    FrameQueue1: TFrameQueue;
    FrameAType: TFrameCombobox;
    FrameProtocolVer: TFrameCombobox;
    UniGroupBox1: TUniGroupBox;
    FrameAckCount: TFrameTextInput;
    FrameAckTimeout: TFrameTextInput;
    FrameTriggerByte: TFrameTextInput;
    FrameTriggerCount: TFrameTextInput;
    FrameConfirm: TFrameCombobox;
    FrameBufferSize: TFrameTextInput;
    FrameTriggerSec: TFrameTextInput;
    FrameCompatibility: TFrameCombobox;
    FrameRR: TFrameBoolInput;
    procedure FrameProtocolVerComboBoxChange(Sender: TObject);
  private
    { Private declarations }
    FSettings: TSocketSpecialDataSettings;
    FComboIndex: TKeyValue<integer>;
  protected
    procedure SetLink(const Value: TLink); override;
    function Apply: boolean; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}



{ TParentLinkSettingEditFrame1 }

constructor TSocketSpecialSettingEditFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FComboIndex := TKeyValue<integer>.Create;
  FComboIndex.Add('server', 0);
  FComboIndex.Add('client', 1);

  FComboIndex.Add('1', 0);
  FComboIndex.Add('2', 1);
  FComboIndex.Add('2g', 1);
  FComboIndex.Add('2G', 1);

  FComboIndex.Add('light', 0);
  FComboIndex.Add('normal', 1);
  FComboIndex.Add('strong', 2);

  FComboIndex.Add('mitra', 0);
  FComboIndex.Add('unimas', 1);
  FComboIndex.Add('sriv', 2);
end;

destructor TSocketSpecialSettingEditFrame.Destroy;
begin
  FComboIndex.Free;
  inherited;
end;


procedure TSocketSpecialSettingEditFrame.FrameProtocolVerComboBoxChange(
  Sender: TObject);
begin
  inherited;
  FrameConnections1.HasConnectionKey := FrameProtocolVer.ComboBox.ItemIndex = 1;
end;


procedure TSocketSpecialSettingEditFrame.SetLink(const Value: TLink);
begin
  inherited;
  FSettings := DataSettings as TSocketSpecialDataSettings;

  FrameConnections1.SetData(FSettings.Connections);
  FrameQueue1.SetData(FSettings.Queue);
  FrameAType.SetDataIndex(FComboIndex.ValueByKey(FSettings.Atype, 0));
  FrameProtocolVer.SetDataIndex(FComboIndex.ValueByKey(FSettings.ProtocolVer, 0));
  FrameAckCount.SetData(FSettings.AckCount);
  FrameAckTimeout.SetData(FSettings.AckTimeout);
  FrameTriggerByte.SetData(FSettings.InputTriggerSize);
  FrameTriggerSec.SetData(FSettings.InputTriggerTime);
  FrameTriggerCount.SetData(FSettings.InputTriggerCount);
  FrameBufferSize.SetData(FSettings.MaxInputBufferSize);
  FrameConfirm.SetDataIndex(FComboIndex.ValueByKey(FSettings.ConfirmationMode, 0));
  FrameCompatibility.SetDataIndex(FComboIndex.ValueByKey(FSettings.Compatibility, 0));
  FrameRR.SetData(FSettings.KeepAlive);

  FrameProtocolVerComboBoxChange(nil);
end;

function TSocketSpecialSettingEditFrame.Apply: boolean;
begin
  result := inherited Apply;
  if not result then
    exit;
  FrameConnections1.GetData(FSettings.Connections);
  FrameQueue1.GetData(FSettings.Queue);
  FSettings.Atype := FComboIndex.KeyByValue(FrameAType.GetDataIndex());
  FSettings.ProtocolVer := FrameProtocolVer.GetDataStr();
  FSettings.AckCount := FrameAckCount.GetDataInt();
  FSettings.AckTimeout := FrameAckTimeout.GetDataInt();
  FSettings.InputTriggerSize := FrameTriggerByte.GetDataInt();
  FSettings.InputTriggerTime := FrameTriggerSec.GetDataInt();
  FSettings.InputTriggerCount := FrameTriggerCount.GetDataInt();
  FSettings.MaxInputBufferSize := FrameBufferSize.GetDataInt();
  FSettings.ConfirmationMode := FComboIndex.KeyByValue(FrameConfirm.GetDataIndex());
  FSettings.Compatibility := FComboIndex.KeyByValue(FrameCompatibility.GetDataIndex());
  FSettings.KeepAlive := FrameRR.GetData();
  result := true;
end;


end.
