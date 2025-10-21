unit TasksParentFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ListParentFormUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniPanel, uniLabel, uniPageControl, uniSplitter,
  uniBasicGrid, uniDBGrid, uniToolBar, uniGUIBaseClasses;

type
  TTaskParentForm = class(TListParentForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function TaskParentForm: TTaskParentForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function TaskParentForm: TTaskParentForm;
begin
  Result := TTaskParentForm(UniMainModule.GetFormInstance(TTaskParentForm));
end;

end.
