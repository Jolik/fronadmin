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
    procedure SetTaskCustomSettings(const Value: TTaskCustomSettings);
  strict protected
    procedure SetDataSettings(const Value: TTaskCustomSettings); virtual;
    ///
    property TaskCustomSettings: TTaskCustomSettings read FTaskCustomSettings;
  public
    function Apply: boolean; virtual;
    procedure AssignTaskCustomSettings(const Value: TTaskCustomSettings);

  end;

implementation

{$R *.dfm}



{ TParentTaskCustomSettingsEditFrame }

function TParentTaskCustomSettingsEditFrame.Apply: boolean;
begin
  Result := True;
end;

procedure TParentTaskCustomSettingsEditFrame.SetDataSettings(
  const Value: TTaskCustomSettings);
begin

end;

procedure TParentTaskCustomSettingsEditFrame.SetTaskCustomSettings(
  const Value: TTaskCustomSettings);
begin
  FTaskCustomSettings := Value;
  SetDataSettings(Value);
end;

procedure TParentTaskCustomSettingsEditFrame.AssignTaskCustomSettings(
  const Value: TTaskCustomSettings);
begin
  SetTaskCustomSettings(Value);
end;

end.
