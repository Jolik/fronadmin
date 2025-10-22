unit RulesFormUnit;

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
  RulesBrokerUnit, uniPanel, uniLabel;

type
  TRulesForm = class(TListParentForm)
  protected
    procedure Refresh(const AId: String = ''); override;
    function CreateBroker(): TEntityBroker; override;
    function CreateEditForm(): TParentEditForm; override;
  end;

function RulesForm: TRulesForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, RuleEditFormUnit;

function RulesForm: TRulesForm;
begin
  Result := TRulesForm(UniMainModule.GetFormInstance(TRulesForm));
end;

{ TRulesForm }

function TRulesForm.CreateBroker: TEntityBroker;
begin
  Result := TRulesBroker.Create();
end;

function TRulesForm.CreateEditForm: TParentEditForm;
begin
  Result := RuleEditForm();
end;

procedure TRulesForm.Refresh(const AId: String = '');
begin
  inherited Refresh(AId)
end;

end.
