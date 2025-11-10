unit SebaCSDLinkSettingEditFrameUnit;

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
  TSebaCSDLinkSettingEditFrame = class(TParentLinkSettingEditFrame)
    FrameConnections1: TFrameConnections;
    FrameSchedule1: TFrameSchedule;
  private
    FSettings: TSebaUsrCsdCliDownDataSettings;
  protected
    procedure SetLink(const Value: TLink); override;
    function Apply: boolean; override;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}



{ TSebaCSDLinkSettingEditFrame }



procedure TSebaCSDLinkSettingEditFrame.SetLink(const Value: TLink);
begin
  inherited;
  FSettings := DataSettings as TSebaUsrCsdCliDownDataSettings;

  FrameConnections1.SetData(FSettings.Connections);
  FrameSchedule1.SetData(FSettings.Work);
end;

function TSebaCSDLinkSettingEditFrame.Apply: boolean;
begin
  result := inherited Apply;
  if not result then
    exit;

  FrameConnections1.GetData(FSettings.Connections);
  FrameSchedule1.GetData(FSettings.Work);

  result := true;
end;

end.
