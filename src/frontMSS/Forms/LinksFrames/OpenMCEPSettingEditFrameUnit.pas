unit OpenMCEPSettingEditFrameUnit;

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
  TOpenMCEPSettingEditFrame = class(TParentLinkSettingEditFrame)
    FrameConnections1: TFrameConnections;
    FrameQueue1: TFrameQueue;
    FrameAType: TFrameCombobox;
    FrameDir: TFrameTextInput;
    UniGroupBox2: TUniGroupBox;
    FramePostponeTimeout: TFrameTextInput;
    FrameMaxPostponeMessages: TFrameTextInput;
    FrameResendTimeoutSec: TFrameTextInput;
    FrameHeartbeatDelay: TFrameTextInput;
    FrameMaxFileSize: TFrameTextInput;
  private
    { Private declarations }
    FSettings: TOpenMCEPDataSettings;
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


constructor TOpenMCEPSettingEditFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FComboIndex := TKeyValue<integer>.Create;
  FComboIndex.Add('server', 0);
  FComboIndex.Add('client', 1);
end;

destructor TOpenMCEPSettingEditFrame.Destroy;
begin
  FComboIndex.Free;
  inherited;
end;



procedure TOpenMCEPSettingEditFrame.SetLink(const Value: TLink);
begin
  inherited;
  FSettings := DataSettings as TOpenMCEPDataSettings;

  FrameAType.SetDataIndex(FComboIndex.ValueByKey(FSettings.Atype, 0));
  FrameConnections1.SetData(FSettings.Connections);
  FrameQueue1.SetData(FSettings.Queue);
  FrameDir.SetData(FSettings.Dir.Path);
  FramePostponeTimeout.SetData(FSettings.PostponeTimeout);
  FrameMaxPostponeMessages.SetData(FSettings.MaxPostponeMessages);
  FrameResendTimeoutSec.SetData(FSettings.ResendTimeoutSec);
  FrameHeartbeatDelay.SetData(FSettings.HeartbeatDelay);
  FrameMaxFileSize.SetData(FSettings.MaxFileSize);
end;

function TOpenMCEPSettingEditFrame.Apply: boolean;
begin
  result := inherited Apply;
  if not result then
    exit;

  FSettings.Atype := FComboIndex.KeyByValue(FrameAType.GetDataIndex());
  FrameConnections1.GetData(FSettings.Connections);
  FrameQueue1.GetData(FSettings.Queue);
  FSettings.Dir.Path := FrameDir.GetDataStr();
  FSettings.PostponeTimeout  := FramePostponeTimeout.GetDataInt();
  FSettings.MaxPostponeMessages := FrameMaxPostponeMessages.GetDataInt();
  FSettings.ResendTimeoutSec := FrameResendTimeoutSec.GetDataInt();
  FSettings.HeartbeatDelay := FrameHeartbeatDelay.GetDataInt();
  FSettings.MaxFileSize  := FrameMaxFileSize.GetDataInt();

  result := true;
end;




end.
