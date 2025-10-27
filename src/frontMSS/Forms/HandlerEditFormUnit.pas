unit HandlerEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniButton,
  uniGUIBaseClasses, uniPanel,
  LoggingUnit,
  EntityUnit, HandlerUnit;

type
  THandlerEditForm = class(TParentEditForm)
    lHid: TUniLabel;
    teHid: TUniEdit;
    lSvcId: TUniLabel;
    teSvcId: TUniEdit;
    lLid: TUniLabel;
    teLid: TUniEdit;
  private
    function Apply: Boolean; override;
    function DoCheck: Boolean; override;
    function GetHandler: THandler;
  protected
    procedure SetEntity(AEntity: TFieldSet); override;
  public
    property Handler: THandler read GetHandler;
  end;

function HandlerEditForm: THandlerEditForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, ConstsUnit;

function HandlerEditForm: THandlerEditForm;
begin
  Result := THandlerEditForm(UniMainModule.GetFormInstance(THandlerEditForm));
end;

{ THandlerEditForm }

function THandlerEditForm.Apply: Boolean;
var
  LHandler: THandler;
begin
  Result := inherited Apply();

  if not Result then
    Exit;

  LHandler := GetHandler;
  if not Assigned(LHandler) then
    Exit(False);

  LHandler.Hid := teHid.Text;
  LHandler.Svcid := teSvcId.Text;
  LHandler.Lid := teLid.Text;

  Result := True;
end;

function THandlerEditForm.DoCheck: Boolean;
begin
  Result := inherited DoCheck();

  if not Result then
    Exit;

  if teHid.Text = '' then
  begin
    MessageDlg(Format(rsWarningValueNotSetInField, [lHid.Caption]), TMsgDlgType.mtWarning, [mbOK], nil);
    Exit(False);
  end;

  if teSvcId.Text = '' then
  begin
    MessageDlg(Format(rsWarningValueNotSetInField, [lSvcId.Caption]), TMsgDlgType.mtWarning, [mbOK], nil);
    Exit(False);
  end;

  if teLid.Text = '' then
  begin
    MessageDlg(Format(rsWarningValueNotSetInField, [lLid.Caption]), TMsgDlgType.mtWarning, [mbOK], nil);
    Exit(False);
  end;

  Result := True;
end;

function THandlerEditForm.GetHandler: THandler;
begin
  Result := nil;

  if not (FEntity is THandler) then
  begin
    Log('THandlerEditForm.GetHandler error in FEntity type', lrtError);
    Exit;
  end;

  Result := FEntity as THandler;
end;

procedure THandlerEditForm.SetEntity(AEntity: TFieldSet);
var
  LHandler: THandler;
begin
  if not (AEntity is THandler) then
  begin
    Log('THandlerEditForm.SetEntity error in AEntity type', lrtError);
    Exit;
  end;

  try
    inherited SetEntity(AEntity);

    LHandler := GetHandler;
    if not Assigned(LHandler) then
      Exit;

    teHid.Text := LHandler.Hid;
    teSvcId.Text := LHandler.Svcid;
    teLid.Text := LHandler.Lid;

  except
    Log('THandlerEditForm.SetEntity error', lrtError);
  end;
end;

end.

