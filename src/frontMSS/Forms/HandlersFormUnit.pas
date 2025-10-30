unit HandlersFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ListParentFormUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniPageControl, uniSplitter, uniBasicGrid, uniDBGrid,
  uniToolBar, uniGUIBaseClasses, RestBrokerBaseUnit,
  ParentEditFormUnit, uniPanel, uniLabel,  RestEntityBrokerUnit ,
  HandlersRestBrokerUnit;

type
  THandlersForm = class(TListParentForm)
  protected
    procedure Refresh(const AId: String = ''); override;
    function  CreateRestBroker(): TRestEntityBroker; override;
    function CreateEditForm: TParentEditForm; override;
  end;

function HandlersForm: THandlersForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, HandlerEditFormUnit;

function HandlersForm: THandlersForm;
begin
  Result := THandlersForm(UniMainModule.GetFormInstance(THandlersForm));
end;

{ THandlersForm }

function THandlersForm.CreateEditForm: TParentEditForm;
begin
  Result := HandlerEditForm();
end;

function THandlersForm.CreateRestBroker: TRestEntityBroker;
begin
  Result := THandlersRestBroker.Create(UniMainModule.XTicket);
end;

procedure THandlersForm.Refresh(const AId: String);
begin
  inherited Refresh(AId);
end;

end.


