unit FTPServerDownLinkSettingEditFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  LinkUnit,
  LinkSettingsUnit,
  KeyValUnit,
  uniGUIClasses, uniGUIFrame, ParentLinkSettingEditFrameUnit, uniSplitter,
  SharedFrameBoolInput, SharedFrameTextInput, uniGroupBox, uniGUIBaseClasses,
  uniPanel, SharedFrameConnections;

type
  TFTPServerDownLinkSettingEditFrame = class(TParentLinkSettingEditFrame)
    FrameConnections1: TFrameConnections;
    FramePassivePorts: TFrameTextInput;
    FramePublicIP: TFrameTextInput;
  private
    FSettings: TFtpSrvDownDataSettings;
  protected
    procedure SetLink(const Value: TLink); override;
    function Apply: boolean; override;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}



{ TFTPServerDownLinkSettingEditFrame }


procedure TFTPServerDownLinkSettingEditFrame.SetLink(const Value: TLink);
begin
  inherited;
  FSettings := DataSettings as TFtpSrvDownDataSettings;

  FrameConnections1.SetData(FSettings.Connections);
  FramePassivePorts.SetData(FSettings.PassivePorts);
  FramePublicIP.SetData(FSettings.PublicIP);
end;


function TFTPServerDownLinkSettingEditFrame.Apply: boolean;
begin
  result := inherited Apply;
  if not result then
    exit;

  FrameConnections1.GetData(FSettings.Connections);
  FSettings.PassivePorts := FramePassivePorts.GetDataStr;
  FSettings.PublicIP := FramePublicIP.GetDataStr;

  result := true;
end;



end.
