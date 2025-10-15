unit LinkEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniButton,
  uniGUIBaseClasses, uniPanel;

type
  TLinkEditForm = class(TParentEditForm)
  private
    { Private declarations }
  public
    { Public declarations }
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

end.
