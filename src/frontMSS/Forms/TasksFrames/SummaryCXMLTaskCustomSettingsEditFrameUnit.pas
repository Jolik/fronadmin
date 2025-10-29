unit SummaryCXMLTaskCustomSettingsEditFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, uniLabel, uniEdit, uniCheckBox,
  ParentTaskCustomSettingsEditFrameUnit,
  TaskSettingsUnit, SummaryTaskCustomSettingsUnit, uniGUIBaseClasses;

type
  TSummaryCXMLTaskCustomSettingsEditFrame = class(TParentTaskCustomSettingsEditFrame)
    cbMeteo: TUniCheckBox;
    lAnyTime: TUniLabel;
    edAnyTime: TUniEdit;
    cbSeparate: TUniCheckBox;
  strict protected
    procedure SetDataSettings(const Value: TTaskCustomSettings); override;
  public
    function Apply: boolean; override;
  end;

implementation

{$R *.dfm}

{ TSummaryCXMLTaskCustomSettingsEditFrame }

function TSummaryCXMLTaskCustomSettingsEditFrame.Apply: boolean;
var
  Settings: TSummaryCXMLCustomSettings;
begin
  Result := inherited Apply;
  if not Result then
    Exit;

  if TaskCustomSettings is TSummaryCXMLCustomSettings then
  begin
    Settings := TSummaryCXMLCustomSettings(TaskCustomSettings);
    Settings.Meteo := cbMeteo.Checked;
    Settings.AnyTime := StrToIntDef(edAnyTime.Text, 0);
    Settings.Separate := cbSeparate.Checked;
  end;
end;

procedure TSummaryCXMLTaskCustomSettingsEditFrame.SetDataSettings(
  const Value: TTaskCustomSettings);
var
  Settings: TSummaryCXMLCustomSettings;
begin
  inherited SetDataSettings(Value);

  if Value is TSummaryCXMLCustomSettings then
  begin
    Settings := TSummaryCXMLCustomSettings(Value);
    cbMeteo.Checked := Settings.Meteo;
    edAnyTime.Text := IntToStr(Settings.AnyTime);
    cbSeparate.Checked := Settings.Separate;
  end
  else
  begin
    cbMeteo.Checked := False;
    edAnyTime.Text := '';
    cbSeparate.Checked := False;
  end;
end;

end.
