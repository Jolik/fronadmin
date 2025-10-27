unit DirDownSettingEditFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  SharedFrameSchedule, linkUnit, LinkSettingsUnit,
  uniGUIClasses, uniGUIFrame, ParentLinkSettingEditFrameUnit, uniSplitter,
  SharedFrameBoolInput, SharedFrameTextInput, uniGroupBox, uniGUIBaseClasses,
  uniPanel, SharedFrameS3;

type
  TDirDownSettingEditFrame = class(TParentLinkSettingEditFrame)
    FrameSchedule1: TFrameSchedule;
    FrameDepth: TFrameTextInput;
    FrameDir: TFrameTextInput;
    FrameSeekMetaFile: TFrameBoolInput;
    FrameS3: TFrameS3;
  private
    Fsettings: TDirDownDataSettings;
  protected
    procedure SetLink(const Value: TLink); override;
    function Apply: boolean; override;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}



{ TDirDownSettingEditFrame }



procedure TDirDownSettingEditFrame.SetLink(const Value: TLink);
begin
  inherited;
  FSettings := DataSettings as TDirDownDataSettings;

  FrameDir.SetData(FSettings.Dir.Path);
  FrameDepth.SetData(FSettings.Dir.Depth);
  FrameSchedule1.SetData(FSettings.Work);
  FrameSeekMetaFile.SetData(FSettings.SeekMetaFile);
  FrameS3.SetData(FSettings.S3);
end;


function TDirDownSettingEditFrame.Apply: boolean;
begin
  result := inherited Apply;
  if not result then
    exit;

  FSettings.Dir.Path := FrameDir.GetDataStr;
  FSettings.Dir.Depth := FrameDepth.GetDataInt;
  FrameSchedule1.GetData(FSettings.Work);
  FSettings.SeekMetaFile := FrameSeekMetaFile.GetData;
  FrameS3.GetData(FSettings.S3);

  result := true;
end;

end.
