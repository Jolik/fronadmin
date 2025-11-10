unit FTPSrvUpLinkSettingEditFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  LinkUnit,
  LinkSettingsUnit,
  KeyValUnit,
  uniGUIClasses, uniGUIFrame, ParentLinkSettingEditFrameUnit, uniSplitter,
  SharedFrameBoolInput, SharedFrameTextInput, uniGroupBox, uniGUIBaseClasses,
  uniPanel, SharedFrameConnections, SharedFrameQueue;

type
  TFTPSrvUpLinkSettingEditFrame = class(TParentLinkSettingEditFrame)
    FrameConnections1: TFrameConnections;
    FrameQueue1: TFrameQueue;
    FramePassivePorts: TFrameTextInput;
    FramePublicIP: TFrameTextInput;
    FrameFolder: TFrameTextInput;
    FrameQuota: TFrameTextInput;
  private
    FSettings: TFtpSrvUpDataSettings;
  protected
    procedure SetLink(const Value: TLink); override;
    function Apply: boolean; override;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}



{ TFTPSrvUpLinkSettingEditFrame }



procedure TFTPSrvUpLinkSettingEditFrame.SetLink(const Value: TLink);
begin
  inherited;
  FSettings := DataSettings as TFtpSrvUpDataSettings;

  FrameConnections1.SetData(FSettings.Connections);
  FrameQueue1.SetData(FSettings.Queue);
  FramePassivePorts.SetData(FSettings.PassivePorts);
  FramePublicIP.SetData(FSettings.PublicIP);
  FrameFolder.SetData(FSettings.Dir.Path);
  FrameQuota.SetData(FSettings.Dir.Quota);
end;


function TFTPSrvUpLinkSettingEditFrame.Apply: boolean;
begin
  result := inherited Apply;
  if not result then
    exit;

  FrameConnections1.GetData(FSettings.Connections);
  FrameQueue1.GetData(FSettings.Queue);
  FSettings.PassivePorts := FramePassivePorts.GetDataStr;
  FSettings.PublicIP := FramePublicIP.GetDataStr;
  FSettings.Dir.Path := FrameFolder.GetDataStr;
  FSettings.Dir.Quota := FrameQuota.GetDataInt;

  result := true;
end;


end.
