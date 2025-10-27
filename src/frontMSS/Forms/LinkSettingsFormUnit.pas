unit LinkSettingsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentFormUnit;

type
  TLinkSettingsForm = class(TParentForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function LinkSettingsForm: TLinkSettingsForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function LinkSettingsForm: TLinkSettingsForm;
begin
  Result := TLinkSettingsForm(UniMainModule.GetFormInstance(TLinkSettingsForm));
end;

end.
