unit ParentLinkSettingEditFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, LinkUnit,   ProfilesFrameUnit,
  LinkSettingsUnit, uniGUIBaseClasses, uniPanel, uniSplitter, uniEdit,
  uniCheckBox, uniGroupBox, uniButton, SharedFrameTextInput,
  SharedFrameBoolInput;

type
  TParentLinkSettingEditFrame = class(TUniFrame)
    SettingsPanel: TUniPanel;
    SettingsGroupBox: TUniGroupBox;
    ProfilesGroupBox: TUniGroupBox;
    UniPanel3: TUniPanel;
    UniSplitter1: TUniSplitter;
    ActiveTimeoutFrame: TFrameTextInput;
    DumpFrame: TFrameBoolInput;
    SettingsParentPanel: TUniPanel;
    ProfilesPanel: TUniPanel;
  private
    Flink: TLink;
    FLid: string;
    FDataSettings: TDataSettings;
    FProfilesFrame: TProfilesFrame;
  protected
    property DataSettings: TDataSettings read FDataSettings write FDataSettings;
    property Lid: string read FLid write FLid;
    procedure SetLink(const Value: TLink); virtual;
  public
    function Apply: boolean; virtual;
    ///  класс с настройками которые правит фрейм
    property Link: TLink read Flink write SetLink;
  end;

implementation
uses
  uniGUIForm;
{$R *.dfm}

{ TParentChannelSettingEditFrame }

function TParentLinkSettingEditFrame.Apply: boolean;
begin
  result := false;
  if FProfilesFrame <> nil then
    if not  FProfilesFrame.Apply() then
      exit;
  FDataSettings.Dump := DumpFrame.GetData;
  FDataSettings.LastActivityTimeout := ActiveTimeoutFrame.GetDataInt();
  result := true;
end;


procedure TParentLinkSettingEditFrame.SetLink(const Value: TLink);
begin
  Flink := Value;
  FDataSettings := (Link.Data as TLinkData).DataSettings;
  FLid := Flink.Id;

  DumpFrame.SetData(FDataSettings.Dump);
  ActiveTimeoutFrame.SetData(FDataSettings.LastActivityTimeout);

  FProfilesFrame := TProfilesFrame.Create(self);
  FProfilesFrame.Parent := ProfilesPanel;
  FProfilesFrame.Align := alClient;
  FProfilesFrame.Link := Flink;
end;

end.
