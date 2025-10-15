unit ParentLinkSettingEditFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame,
  LinkSettingsUnit;

type
  TParentLinkSettingEditFrame = class(TUniFrame)
  private
    FDataSettings: TDataSettings;

    procedure SetDataSettings(const Value: TDataSettings);
    { Private declarations }
  public
    ///  класс с настройками которе правит фрейм
    property DataSettings: TDataSettings read FDataSettings write SetDataSettings;

  end;

implementation

{$R *.dfm}



{ TParentChannelSettingEditFrame }

procedure TParentLinkSettingEditFrame.SetDataSettings(
  const Value: TDataSettings);
begin
  FDataSettings := Value;
end;

end.
