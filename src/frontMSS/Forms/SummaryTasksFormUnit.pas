unit SummaryTasksFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ListParentFormUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniPageControl, uniSplitter, uniBasicGrid, uniDBGrid,
  uniToolBar, uniGUIBaseClasses,
  //ParentBrokerUnit,
  ParentEditFormUnit,
  SummaryTasksBrokerUnit;

type
  TSummaryTasksForm = class(TListParentForm)
  private

  protected
    ///
    procedure Refresh(const AId: String = ''); override;

    ///
  //  function CreateBroker(): TParentBroker; override;

    ///
    function CreateEditForm(): TParentEditForm; override;

  public

  end;

function SummaryTasksForm: TSummaryTasksForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, SummaryTaskEditFormUnit;

function SummaryTasksForm: TSummaryTasksForm;
begin
  Result := TSummaryTasksForm(UniMainModule.GetFormInstance(TSummaryTasksForm));
end;

{ TSummaryTasksForm }
{
function TSummaryTasksForm.CreateBroker: TParentBroker;
begin
  ///   ""
  Result := TSummaryTasksBroker.Create();
end;
}

function TSummaryTasksForm.CreateEditForm: TParentEditForm;
begin
  ///   ""
  Result := SummaryTaskEditForm();
end;

procedure TSummaryTasksForm.Refresh(const AId: String = '');
begin
  inherited Refresh(AId)
end;

end.
