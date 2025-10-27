unit RouterSourceEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniButton,
  uniGUIBaseClasses, uniPanel,
  LoggingUnit,
  EntityUnit, RouterSourceUnit;

type
  TRouterSourceEditForm = class(TParentEditForm)
    teWho: TUniEdit;
    lWho: TUniLabel;
    teSvcId: TUniEdit;
    lSvcId: TUniLabel;
    teLid: TUniEdit;
    lLid: TUniLabel;
  private
    function Apply: boolean; override;
    function DoCheck: Boolean; override;
    function GetRouterSource: TRouterSource;

  protected
    ///
    procedure SetEntity(AEntity : TFieldSet); override;

  public
    ///    FEntity     ""
    property RouterSource : TRouterSource read GetRouterSource;

  end;

function RouterSourceEditForm: TRouterSourceEditForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, ConstsUnit;

function RouterSourceEditForm: TRouterSourceEditForm;
begin
  Result := TRouterSourceEditForm(UniMainModule.GetFormInstance(TRouterSourceEditForm));
end;

{ TRouterSourceEditForm }

function TRouterSourceEditForm.Apply : boolean;
begin
  Result := inherited Apply();

  if not Result then
    Exit;

  RouterSource.Who := teWho.Text;
  RouterSource.SvcId := teSvcId.Text;
  RouterSource.Lid := teLid.Text;

  Result := true;
end;

function TRouterSourceEditForm.DoCheck: Boolean;
begin
  Result := inherited DoCheck();

  if not Result then
    Exit;

  if teWho.Text = '' then
  begin
    MessageDlg(Format(rsWarningValueNotSetInField, [lWho.Caption]), TMsgDlgType.mtWarning, [mbOK], nil);
    Result := False;
    Exit;
  end;

  Result := True;
end;

 ///    FEntity     ""
function TRouterSourceEditForm.GetRouterSource: TRouterSource;
begin
  Result := nil;
  ///        -  nil!
  if not (FEntity is TRouterSource) then
  begin
    Log('TRouterSourceEditForm.GetRouterSource error in FEntity type', lrtError);
    exit;
  end;

  ///         FEntity   TRouterSource
  Result := Entity as TRouterSource;
end;

procedure TRouterSourceEditForm.SetEntity(AEntity: TFieldSet);
begin
  ///        -   !
  if not (AEntity is TRouterSource) then
  begin
    Log('TRouterSourceEditForm.SetEntity error in AEntity type', lrtError);
    exit;
  end;

  try
    inherited SetEntity(AEntity);

    ///
    teWho.Text := RouterSource.Who;
    teSvcId.Text := RouterSource.SvcId;
    teLid.Text := RouterSource.Lid;

  except
    Log('TRouterSourceEditForm.SetEntity error', lrtError);
  end;
end;

end.

