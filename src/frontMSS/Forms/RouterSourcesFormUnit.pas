unit RouterSourcesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ListParentFormUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniPageControl, uniSplitter, uniBasicGrid, uniDBGrid,
  uniToolBar, uniGUIBaseClasses,
   ParentEditFormUnit, RestBrokerBaseUnit,   RestEntityBrokerUnit,
  RouterSourcesRestBrokerUnit, uniPanel, uniLabel;

type
  TRouterSourcesForm = class(TListParentForm)
  protected
    ///
    procedure Refresh(const AId: String = ''); override;

    ///
    function  CreateRestBroker(): TRestEntityBroker; override;

    ///
    function CreateEditForm(): TParentEditForm; override;
  end;

function RouterSourcesForm: TRouterSourcesForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, RouterSourceEditFormUnit;

function RouterSourcesForm: TRouterSourcesForm;
begin
  Result := TRouterSourcesForm(UniMainModule.GetFormInstance(TRouterSourcesForm));
end;

{ TRouterSourcesForm }

function TRouterSourcesForm.CreateEditForm: TParentEditForm;
begin
  ///   ""
  Result := RouterSourceEditForm();
end;

function TRouterSourcesForm.CreateRestBroker: TRestEntityBroker;
begin
  Result := TRouterSourcesRestBroker.Create(UniMainModule.XTicket);
end;

procedure TRouterSourcesForm.Refresh(const AId: String = '');
begin
  inherited Refresh(AId)
end;

end.

