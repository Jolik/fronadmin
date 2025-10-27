unit SummaryHydraTaskCustomSettingsEditFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, uniLabel, uniEdit,
  ParentTaskCustomSettingsEditFrameUnit,
  TaskSettingsUnit, SummaryTaskCustomSettingsUnit;

type
  TSummaryHydraTaskCustomSettingsEditFrame = class(TParentTaskCustomSettingsEditFrame)
    lAllSection1: TUniLabel;
    edAllSection1: TUniEdit;
    lDaysAgo: TUniLabel;
    edDaysAgo: TUniEdit;
  strict protected
    procedure SetDataSettings(const Value: TTaskCustomSettings); override;
  public
    function Apply: boolean; override;
  end;

implementation

{$R *.dfm}

{ TSummaryHydraTaskCustomSettingsEditFrame }

function TSummaryHydraTaskCustomSettingsEditFrame.Apply: boolean;
var
  Settings: TSummaryHydraCustomSettings;
begin
  Result := inherited Apply;
  if not Result then
    Exit;

  if TaskCustomSettings is TSummaryHydraCustomSettings then
  begin
    Settings := TSummaryHydraCustomSettings(TaskCustomSettings);
    Settings.AllSection1 := StrToIntDef(edAllSection1.Text, 0);
    Settings.DaysAgo := StrToIntDef(edDaysAgo.Text, 0);
  end;
end;

procedure TSummaryHydraTaskCustomSettingsEditFrame.SetDataSettings(
  const Value: TTaskCustomSettings);
var
  Settings: TSummaryHydraCustomSettings;
begin
  inherited SetDataSettings(Value);

  if Value is TSummaryHydraCustomSettings then
  begin
    Settings := TSummaryHydraCustomSettings(Value);
    edAllSection1.Text := IntToStr(Settings.AllSection1);
    edDaysAgo.Text := IntToStr(Settings.DaysAgo);
  end
  else
  begin
    edAllSection1.Text := '';
    edDaysAgo.Text := '';
  end;
end;

end.
