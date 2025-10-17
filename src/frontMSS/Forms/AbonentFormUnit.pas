unit AbonentFormUnit;

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
  AbonentBrokerUnit;

type
  TAbonentForm = class(TListParentForm)
  protected
    procedure Refresh(const AId: String = ''); override;
    function CreateBroker: TParentBroker; override;
    function CreateEditForm: TParentEditForm; override;
  end;

function AbonentForm: TAbonentForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, AbonentEditFormUnit;

function AbonentForm: TAbonentForm;
begin
  Result := TAbonentForm(UniMainModule.GetFormInstance(TAbonentForm));
end;

{ TAbonentForm }

function TAbonentForm.CreateBroker: TParentBroker;
begin
  Result := TAbonentBroker.Create;
end;

function TAbonentForm.CreateEditForm: TParentEditForm;
begin
  Result := AbonentEditForm();
end;

procedure TAbonentForm.Refresh(const AId: String);
begin
  inherited Refresh(AId);
end;

end.

