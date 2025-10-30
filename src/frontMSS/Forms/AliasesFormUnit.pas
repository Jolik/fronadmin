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
  ParentEditFormUnit,
  RestBrokerBaseUnit, RestEntityBrokerUnit,
  AliasesRestBrokerUnit,
  APIConst, uniPanel, uniLabel;

type
  TAliasesForm = class(TListParentForm)
  private
    procedure btnNewClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
  private

  protected
    ///
    procedure Refresh(const AId: String = ''); override;

    // REST broker for HTTP-based API
    function CreateRestBroker(): TRestEntityBroker; override;

    ///
    function CreateEditForm(): TParentEditForm; override;

    procedure UniFormCreate(Sender: TObject);
  public

  end;

function AliasesForm: TAliasesForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, AliasEditFormUnit, AliasUnit, BaseResponses, BaseRequests, EntityUnit;

function AliasesForm: TAliasesForm;
begin
  Result := TAliasesForm(UniMainModule.GetFormInstance(TAliasesForm));
end;

{ TAliasesForm }

function TAliasesForm.CreateRestBroker: TRestEntityBroker;
begin
  Result := TAliasesRestBroker.Create(UniMainModule.XTicket);
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

procedure TAliasesForm.UniFormCreate(Sender: TObject);
begin
  inherited;
  // route buttons to REST-based handlers for Aliases
  btnNew.OnClick := btnNewClick;
  btnUpdate.OnClick := btnUpdateClick;
end;

procedure TAliasesForm.btnNewClick(Sender: TObject);
var
  LEntity: TEntity;
begin
  PrepareEditForm;
  LEntity := TAlias.Create; // create empty alias entity without legacy broker
  EditForm.Entity := LEntity;
  try
    EditForm.ShowModalEx(NewCallback);
  finally
    // entity lifetime is managed by form after modal; do not free here
  end;
end;

procedure TAliasesForm.btnUpdateClick(Sender: TObject);
var
  LEntity: TEntity;
begin
  PrepareEditForm(true);
  FId := FDMemTableEntity.FieldByName('Id').AsString;

  if Assigned(RestBroker) then
  begin
    var Req := RestBroker.CreateReqInfo();
    Req.Id := FId;
    var Resp := RestBroker.Info(Req);
    try
      LEntity := Resp.Entity as TEntity;
      EditForm.Entity := LEntity;
    finally
      // LEntity is owned by form during editing; response can be freed now
      Resp.Free;
    end;
  end;

  try
    EditForm.ShowModalEx(UpdateCallback);
  finally
  end;
end;

end.

