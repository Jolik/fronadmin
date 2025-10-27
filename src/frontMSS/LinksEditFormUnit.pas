unit LinksEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniButton,
  uniGUIBaseClasses, uniPanel;

type
  TParentEditForm1 = class(TParentEditForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ParentEditForm1: TParentEditForm1;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function ParentEditForm1: TParentEditForm1;
begin
  Result := TParentEditForm1(UniMainModule.GetFormInstance(TParentEditForm1));
end;

end.
