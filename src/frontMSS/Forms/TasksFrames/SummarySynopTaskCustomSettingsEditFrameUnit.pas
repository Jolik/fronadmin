unit SummarySynopTaskCustomSettingsEditFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, uniLabel, uniEdit,
  ParentTaskCustomSettingsEditFrameUnit,
  TaskSettingsUnit, SummaryTaskCustomSettingsUnit, uniGUIBaseClasses;

type
  TSummarySynopTaskCustomSettingsEditFrame = class(TParentTaskCustomSettingsEditFrame)
    lDataPercent: TUniLabel;
    edDataPercent: TUniEdit;
    lWindGustFrom: TUniLabel;
    edWindGustFrom: TUniEdit;
    lIsAutoStations: TUniLabel;
    edIsAutoStations: TUniEdit;
  strict protected
    procedure SetDataSettings(const Value: TTaskCustomSettings); override;
  public
    function Apply: boolean; override;
  end;

implementation

{$R *.dfm}

{ TSummarySynopTaskCustomSettingsEditFrame }

function TSummarySynopTaskCustomSettingsEditFrame.Apply: boolean;
var
  Settings: TSummarySynopCustomSettings;
begin
  Result := inherited Apply;
  if not Result then
    Exit;

  if TaskCustomSettings is TSummarySynopCustomSettings then
  begin
    Settings := TSummarySynopCustomSettings(TaskCustomSettings);
    Settings.DataPercent := StrToIntDef(edDataPercent.Text, 0);
    Settings.WindGustFrom := StrToIntDef(edWindGustFrom.Text, 0);
    Settings.IsAutoStations := StrToIntDef(edIsAutoStations.Text, 0);
  end;
end;

procedure TSummarySynopTaskCustomSettingsEditFrame.SetDataSettings(
  const Value: TTaskCustomSettings);
var
  Settings: TSummarySynopCustomSettings;
begin
  inherited SetDataSettings(Value);

  if Value is TSummarySynopCustomSettings then
  begin
    Settings := TSummarySynopCustomSettings(Value);
    edDataPercent.Text := IntToStr(Settings.DataPercent);
    edWindGustFrom.Text := IntToStr(Settings.WindGustFrom);
    edIsAutoStations.Text := IntToStr(Settings.IsAutoStations);
  end
  else
  begin
    edDataPercent.Text := '';
    edWindGustFrom.Text := '';
    edIsAutoStations.Text := '';
  end;
end;

end.
