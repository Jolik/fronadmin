unit AbonentsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ListParentFormUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniPageControl, uniSplitter, uniBasicGrid, uniDBGrid,
  uniToolBar, uniGUIBaseClasses,
  EntityBrokerUnit, ParentEditFormUnit,
  AbonentsBrokerUnit,
  RestBrokerBaseUnit, BaseRequests, BaseResponses,
  AbonentsRestBrokerUnit, uniPanel, uniLabel;

type
  TAbonentsForm = class(TListParentForm)
  protected
    procedure Refresh(const AId: String = ''); override;
    function CreateBroker: TEntityBroker; override;
    function CreateRestBroker: TRestBrokerBase; override;
    function CreateEditForm: TParentEditForm; override;
  end;

function AbonentsForm: TAbonentsForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, AbonentEditFormUnit;

function AbonentsForm: TAbonentsForm;
begin
  Result := TAbonentsForm(UniMainModule.GetFormInstance(TAbonentsForm));
end;

{ TAbonentForm }

function TAbonentsForm.CreateBroker: TEntityBroker;
begin
  Result := TAbonentsBroker.Create;
end;

function TAbonentsForm.CreateRestBroker: TRestBrokerBase;
begin
  Result := TAbonentsRestBroker.Create;
end;

function TAbonentsForm.CreateEditForm: TParentEditForm;
begin
  Result := AbonentEditForm();
end;

procedure TAbonentsForm.Refresh(const AId: String);
begin
  inherited Refresh(AId);
end;


end.

