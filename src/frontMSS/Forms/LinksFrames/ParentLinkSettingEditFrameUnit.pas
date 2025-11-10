unit ParentLinkSettingEditFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, LinkUnit,   ProfilesFrameUnit,
  LinkSettingsUnit, uniGUIBaseClasses, uniPanel, uniSplitter, uniEdit,
  uniCheckBox, uniGroupBox, uniButton, SharedFrameTextInput,
  SharedFrameBoolInput, ProfileUnit, ProfilesRestBrokerUnit;

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
    FDataSettings: TDataSettings;
    FProfilesFrame: TProfilesFrame;

  protected
    property DataSettings: TDataSettings read FDataSettings write FDataSettings;
    function Apply: boolean; virtual;
    procedure SetLink(const Value: TLink); virtual;

  public
    procedure SetData(srcLink: TLink; srcProfiles: TProfileList); virtual;
    procedure GetData(dstLink: TLink; dstProfiles: TProfileList); virtual;

    function Validate(): boolean; virtual;
  end;

 TParentLinkSettingEditFrameClass = class of TParentLinkSettingEditFrame;

implementation
uses
  uniGUIForm, loggingUnit;
{$R *.dfm}

{ TParentChannelSettingEditFrame }




procedure TParentLinkSettingEditFrame.GetData(dstLink: TLink; dstProfiles: TProfileList);
begin
  Apply;
  FDataSettings.Dump := DumpFrame.GetData;
  FDataSettings.LastActivityTimeout := ActiveTimeoutFrame.GetDataInt();
  if FProfilesFrame <> nil then
    FProfilesFrame.GetData(dstProfiles);
end;


procedure TParentLinkSettingEditFrame.SetData(srcLink: TLink;srcProfiles: TProfileList);
begin
  FDataSettings := (srcLink.Data as TLinkData).DataSettings;

  DumpFrame.SetData(FDataSettings.Dump);
  ActiveTimeoutFrame.SetData(FDataSettings.LastActivityTimeout);

  SetLink(srcLink);

  FProfilesFrame := TProfilesFrame.Create(self);
  FProfilesFrame.Parent := ProfilesPanel;
  FProfilesFrame.Align := alClient;
  FProfilesFrame.SetData(srcProfiles, srcLink);
end;


procedure TParentLinkSettingEditFrame.SetLink(const Value: TLink);
begin
end;

function TParentLinkSettingEditFrame.Validate: boolean;
begin
  result := false;
  if not FProfilesFrame.Validate then
    exit;
  result := true;
end;

function TParentLinkSettingEditFrame.Apply: boolean;
begin
  result := true;
end;



end.
