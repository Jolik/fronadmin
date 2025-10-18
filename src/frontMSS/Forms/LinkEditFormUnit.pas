unit LinkEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniButton,
  uniGUIBaseClasses, uniPanel, ParentLinkSettingEditFrameUnit;

type
  TLinkEditForm = class(TParentEditForm)
  private
    FLinkSettingsEditFrame: TParentLinkSettingEditFrame;
    { Private declarations }
  protected
    function Apply: boolean; override;
  public
    { Public declarations }
    property LinkSettingsEditFrame:  TParentLinkSettingEditFrame read FLinkSettingsEditFrame write FLinkSettingsEditFrame;
  end;

function LinkEditForm: TLinkEditForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function LinkEditForm: TLinkEditForm;
begin
  Result := TLinkEditForm(UniMainModule.GetFormInstance(TLinkEditForm));
end;

{ TLinkEditForm }

function TLinkEditForm.Apply: boolean;
begin
  result := false;
  if not  LinkSettingsEditFrame.Apply() then
    exit;
  result := inherited Apply;
end;

end.
