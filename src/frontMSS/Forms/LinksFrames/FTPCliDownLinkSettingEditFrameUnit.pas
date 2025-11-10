unit FTPCliDownLinkSettingEditFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  LinkUnit,
  LinkSettingsUnit,
  KeyValUnit,
  uniGUIClasses, uniGUIFrame, ParentLinkSettingEditFrameUnit, uniSplitter,
  SharedFrameBoolInput, SharedFrameTextInput, uniGroupBox, uniGUIBaseClasses,
  uniPanel, SharedFrameConnections, SharedFrameSchedule, SharedFrameCombobox;

type
  TFtpCliDownLinkSettingEditFrame = class(TParentLinkSettingEditFrame)
    FrameConnections1: TFrameConnections;
    FrameSchedule1: TFrameSchedule;
    FrameDir: TFrameTextInput;
    FrameDepth: TFrameTextInput;
    FrameTracking: TFrameCombobox;
    FrameReplaceIP2: TFrameBoolInput;
  private
    FSettings: TFtpCliDownDataSettings;
  protected
    procedure SetLink(const Value: TLink); override;
    function Apply: boolean; override;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}



{ TFtpCliDownLinkSettingEditFrame }


procedure TFtpCliDownLinkSettingEditFrame.SetLink(const Value: TLink);
begin
  inherited;
  FSettings := DataSettings as TFtpCliDownDataSettings;

  FrameDir.SetData(FSettings.Dir.Path);
  FrameDepth.SetData(FSettings.Dir.Depth);
  FrameConnections1.SetData(FSettings.Connections);
  FrameSchedule1.SetData(FSettings.Work);
  if FSettings.DeleteFiles then
    FrameTracking.SetDataIndex(1)
  else
    FrameTracking.SetDataIndex(0);
  FrameReplaceIP2.SetData(FSettings.ReplaceIp); // TODO: перенести в connections
end;


function TFtpCliDownLinkSettingEditFrame.Apply: boolean;
begin
  result := inherited Apply;
  if not result then
    exit;

  FSettings.Dir.Path := FrameDir.GetDataStr;
  FSettings.Dir.Depth := FrameDepth.GetDataInt;
  FrameConnections1.GetData(FSettings.Connections);
  FrameSchedule1.GetData(FSettings.Work);
  case FrameTracking.GetDataIndex  of
    0:
    begin
       FSettings.DeleteFiles := false;
       FSettings.Tracking := true;
    end;
    1:
    begin
       FSettings.DeleteFiles := true;
       FSettings.Tracking := false;
    end;
  end;
  FSettings.ReplaceIp := FrameReplaceIP2.GetData;

  result := true;
end;


end.
