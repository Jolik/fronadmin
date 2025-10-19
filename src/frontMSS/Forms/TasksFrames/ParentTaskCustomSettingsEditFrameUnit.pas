unit ParentTaskCustomSettingsEditFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame,
  TaskSettingsUnit;

type
  TParentTaskCustomSettingsEditFrame = class(TUniFrame)
  private
    FTaskCustomSettings: TTaskCustomSettings;
    procedure SetDataSettings(const Value: TTaskCustomSettings); virtual;
    procedure SetTaskCustomSettings(const Value: TTaskCustomSettings);
  public
    function Apply: boolean; virtual;
    ///  класс с настройками которе правит фрейм
    property TaskCustomSettings: TTaskCustomSettings read FTaskCustomSettings write SetTaskCustomSettings;

  end;

implementation

{$R *.dfm}



{ TParentTaskCustomSettingsEditFrame }

function TParentTaskCustomSettingsEditFrame.Apply: boolean;
begin

end;

procedure TParentTaskCustomSettingsEditFrame.SetDataSettings(
  const Value: TTaskCustomSettings);
begin

end;

procedure TParentTaskCustomSettingsEditFrame.SetTaskCustomSettings(
  const Value: TTaskCustomSettings);
begin
  FTaskCustomSettings := Value;
end;

end.
