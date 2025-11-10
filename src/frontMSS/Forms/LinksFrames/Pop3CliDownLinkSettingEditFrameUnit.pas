unit Pop3CliDownLinkSettingEditFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  LinkUnit,
  LinkSettingsUnit,
  KeyValUnit,
  uniGUIClasses, uniGUIFrame, ParentLinkSettingEditFrameUnit, uniSplitter,
  SharedFrameBoolInput, SharedFrameTextInput, uniGroupBox, uniGUIBaseClasses,
  uniPanel, SharedFrameConnections, SharedFrameSchedule;

type
  TPop3CliDownLinkSettingEditFrame = class(TParentLinkSettingEditFrame)
    FrameConnections1: TFrameConnections;
    FrameSchedule1: TFrameSchedule;
    FrameDelete: TFrameBoolInput;
  private
    FSettings: TPop3CliDownDataSettings;
  protected
    procedure SetLink(const Value: TLink); override;
    function Apply: boolean; override;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}



{ TPop3CliDownLinkSettingEditFrame }



procedure TPop3CliDownLinkSettingEditFrame.SetLink(const Value: TLink);
begin
  inherited;
  FSettings := DataSettings as TPop3CliDownDataSettings;

  FrameConnections1.SetData(FSettings.Connections);
  FrameSchedule1.SetData(FSettings.Work);
  FrameDelete.SetData(FSettings.DeleteFiles);
end;


function TPop3CliDownLinkSettingEditFrame.Apply: boolean;
begin
  result := inherited Apply;
  if not result then
    exit;

  FrameConnections1.GetData(FSettings.Connections);
  FrameSchedule1.GetData(FSettings.Work);
  FSettings.DeleteFiles := FrameDelete.GetData;

  result := true;
end;

end.
