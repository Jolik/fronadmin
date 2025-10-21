unit TaskEditParentFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniButton,
  uniGUIBaseClasses, uniPanel;

type
  TTaskEditParentForm = class(TParentEditForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function TaskEditParentForm: TTaskEditParentForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function TaskEditParentForm: TTaskEditParentForm;
begin
  Result := TTaskEditParentForm(UniMainModule.GetFormInstance(TTaskEditParentForm));
end;

end.
