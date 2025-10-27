unit SummarySEBATaskCustomSettingsEditFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, uniLabel, uniEdit,
  ParentTaskCustomSettingsEditFrameUnit,
  TaskSettingsUnit, SummaryTaskCustomSettingsUnit;

type
  TSummarySEBATaskCustomSettingsEditFrame = class(TParentTaskCustomSettingsEditFrame)
    lMsrPeriod: TUniLabel;
    edMsrPeriod: TUniEdit;
    lMsrCaption: TUniLabel;
    edMsrCaption: TUniEdit;
    lRepLang: TUniLabel;
    edRepLang: TUniEdit;
    lMsrType: TUniLabel;
    edMsrType: TUniEdit;
  strict protected
    procedure SetDataSettings(const Value: TTaskCustomSettings); override;
  public
    function Apply: boolean; override;
  end;

implementation

{$R *.dfm}

{ TSummarySEBATaskCustomSettingsEditFrame }

function TSummarySEBATaskCustomSettingsEditFrame.Apply: boolean;
var
  Settings: TSummarySEBACustomSettings;
begin
  Result := inherited Apply;
  if not Result then
    Exit;

  if TaskCustomSettings is TSummarySEBACustomSettings then
  begin
    Settings := TSummarySEBACustomSettings(TaskCustomSettings);
    Settings.MsrPeriod := StrToIntDef(edMsrPeriod.Text, 0);
    Settings.MsrCaption := edMsrCaption.Text;
    Settings.RepLang := StrToIntDef(edRepLang.Text, 0);
    Settings.MsrType := StrToIntDef(edMsrType.Text, 0);
  end;
end;

procedure TSummarySEBATaskCustomSettingsEditFrame.SetDataSettings(
  const Value: TTaskCustomSettings);
var
  Settings: TSummarySEBACustomSettings;
begin
  inherited SetDataSettings(Value);

  if Value is TSummarySEBACustomSettings then
  begin
    Settings := TSummarySEBACustomSettings(Value);
    edMsrPeriod.Text := IntToStr(Settings.MsrPeriod);
    edMsrCaption.Text := Settings.MsrCaption;
    edRepLang.Text := IntToStr(Settings.RepLang);
    edMsrType.Text := IntToStr(Settings.MsrType);
  end
  else
  begin
    edMsrPeriod.Text := '';
    edMsrCaption.Text := '';
    edRepLang.Text := '';
    edMsrType.Text := '';
  end;
end;

end.
