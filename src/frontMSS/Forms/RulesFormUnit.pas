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
  ParentEditFormUnit,
  uniPanel, uniLabel,
  RestBrokerBaseUnit, RestEntityBrokerUnit,
  RulesRestBrokerUnit;

type
  TRulesForm = class(TListParentForm)
  private
    procedure btnNewClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
  protected
    procedure Refresh(const AId: String = ''); override;
    function CreateRestBroker(): TRestEntityBroker; override;
    function CreateEditForm(): TParentEditForm; override;
    procedure UniFormCreate(Sender: TObject);
  end;

function RulesForm: TRulesForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, RuleEditFormUnit, RuleUnit, EntityUnit;

function RulesForm: TRulesForm;
begin
  Result := TRulesForm(UniMainModule.GetFormInstance(TRulesForm));
end;

{ TRulesForm }

function TRulesForm.CreateEditForm: TParentEditForm;
begin
  Result := RuleEditForm();
end;

procedure TRulesForm.Refresh(const AId: String = '');
begin
  inherited Refresh(AId)
end;

function TRulesForm.CreateRestBroker: TRestEntityBroker;
begin
  Result := TRulesRestBroker.Create(UniMainModule.XTicket);
end;

procedure TRulesForm.UniFormCreate(Sender: TObject);
begin
  inherited;
  btnNew.OnClick := btnNewClick;
  btnUpdate.OnClick := btnUpdateClick;
end;

procedure TRulesForm.btnNewClick(Sender: TObject);
begin
  PrepareEditForm;
  EditForm.Entity := TRule.Create;
  try
    EditForm.OnOkCalback:= NewCallback;
    EditForm.ShowModal();
  finally
  end;
end;

procedure TRulesForm.btnUpdateClick(Sender: TObject);
begin
  PrepareEditForm(true);
  FId := FDMemTableEntity.FieldByName('Id').AsString;

  if Assigned(RestBroker) then
  begin
    var Req := RestBroker.CreateReqInfo();
    Req.Id := FId;
    var Resp := RestBroker.Info(Req);
    try
      EditForm.Entity := Resp.Entity as TEntity;
    finally
      Resp.Free;
    end;
  end;

  try
    EditForm.OnOkCalback:=UpdateCallback;
    EditForm.ShowModal();
  finally
  end;
end;

end.
