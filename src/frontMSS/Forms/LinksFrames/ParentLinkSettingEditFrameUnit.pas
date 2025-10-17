unit ParentLinkSettingEditFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame,
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
    ActivTimeoutFrame: TFrameTextInput;
    DumpFrame: TFrameBoolInput;
    SettingsParentPanel: TUniPanel;
  private
    FDataSettings: TDataSettings;

  protected
    procedure SetDataSettings(const Value: TDataSettings); virtual;
    function Apply: boolean; virtual;

  public
    ///  класс с настройками которе правит фрейм
    property DataSettings: TDataSettings read FDataSettings write SetDataSettings;
  end;

implementation
uses
  uniGUIForm;
{$R *.dfm}

{ TParentChannelSettingEditFrame }

function TParentLinkSettingEditFrame.Apply: boolean;
begin
  FDataSettings.Dump := DumpFrame.GetData;
  FDataSettings.LastActivityTimeout := ActivTimeoutFrame.GetDataInt();
  result := true;
end;




procedure TParentLinkSettingEditFrame.SetDataSettings(
  const Value: TDataSettings);
begin
  FDataSettings := Value;

  DumpFrame.SetData(FDataSettings.Dump);
  ActivTimeoutFrame.SetData(FDataSettings.LastActivityTimeout);
end;

end.
