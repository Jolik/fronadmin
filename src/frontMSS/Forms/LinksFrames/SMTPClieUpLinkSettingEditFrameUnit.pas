unit SMTPClieUpLinkSettingEditFrameUnit;

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
  TSMTPClieUpLinkSettingEditFrame = class(TParentLinkSettingEditFrame)
    FrameConnections1: TFrameConnections;
    UniGroupBox1: TUniGroupBox;
    FrameEmail: TFrameTextInput;
    FrameMeteoAttach: TFrameBoolInput;
    FrameQueue1: TFrameQueue;
  private
    FSettings: TSmtpCliUpDataSettings;
  protected
    procedure SetLink(const Value: TLink); override;
    function Apply: boolean; override;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}


{ TSMTPClieUpLinkSettingEditFrame }

procedure TSMTPClieUpLinkSettingEditFrame.SetLink(const Value: TLink);
begin
  inherited;
  FSettings := DataSettings as TSmtpCliUpDataSettings;

  FrameConnections1.SetData(FSettings.Connections);
  FrameEmail.SetData(FSettings.Email);
  FrameMeteoAttach.SetData(FSettings.MeteoAttachment);
  FrameQueue1.SetData(FSettings.Queue);
end;

function TSMTPClieUpLinkSettingEditFrame.Apply: boolean;
begin
  result := inherited Apply;
  if not result then
    exit;

  FrameConnections1.GetData(FSettings.Connections);
  FSettings.Email := FrameEmail.GetDataStr;
  FSettings.MeteoAttachment := FrameMeteoAttach.GetData;
  FrameQueue1.GetData(FSettings.Queue);

  result := true;
end;

end.
