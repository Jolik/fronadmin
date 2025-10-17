unit AliasesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ListParentFormUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniPageControl, uniSplitter, uniBasicGrid, uniDBGrid,
  uniToolBar, uniGUIBaseClasses,
  ParentBrokerUnit, ParentEditFormUnit,
  AliasesBrokerUnit;

type
  TAliasesForm = class(TListParentForm)
  private

  protected
    ///
    procedure Refresh(const AId: String = ''); override;

    ///
    function CreateBroker(): TParentBroker; override;

    ///
    function CreateEditForm(): TParentEditForm; override;

  public

  end;

function AliasesForm: TAliasesForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, AliasEditFormUnit;

function AliasesForm: TAliasesForm;
begin
  Result := TAliasesForm(UniMainModule.GetFormInstance(TAliasesForm));
end;

{ TAliasesForm }

function TAliasesForm.CreateBroker: TParentBroker;
begin
  ///   ""
  Result := TAliasesBroker.Create();
end;

function TAliasesForm.CreateEditForm: TParentEditForm;
begin
  ///   ""
  Result := AliasEditForm();
end;

procedure TAliasesForm.Refresh(const AId: String = '');
begin
  inherited Refresh(AId)
end;

end.

