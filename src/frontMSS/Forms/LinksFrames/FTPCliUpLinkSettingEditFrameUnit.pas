unit FTPCliUpLinkSettingEditFrameUnit;

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
  TFTPCliUpLinkSettingEditFrame = class(TParentLinkSettingEditFrame)
    FrameConnections1: TFrameConnections;
    FrameQueue1: TFrameQueue;
    UniGroupBox1: TUniGroupBox;
    FrameFolder: TFrameTextInput;
  private
    FSettings: TFtpCliUpDataSettings;
  protected
    procedure SetLink(const Value: TLink); override;
    function Apply: boolean; override;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}



{ TFTPCliUpLinkSettingEditFrame }

procedure TFTPCliUpLinkSettingEditFrame.SetLink(const Value: TLink);
begin
  inherited;
  FSettings := DataSettings as TFtpCliUpDataSettings;

  FrameConnections1.SetData(FSettings.Connections);
  FrameQueue1.SetData(FSettings.Queue);
  FrameFolder.SetData(FSettings.Folder)
end;

function TFTPCliUpLinkSettingEditFrame.Apply: boolean;
begin
  result := inherited Apply;
  if not result then
    exit;

  FrameConnections1.GetData(FSettings.Connections);
  FrameQueue1.GetData(FSettings.Queue);
  FSettings.Folder := FrameFolder.GetDataStr;

  result := true;
end;

end.
