unit SummaryTaskEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniButton,
  uniGUIBaseClasses, uniPanel,
  LoggingUnit,
  EntityUnit, SummaryTaskUnit;

type
  TSummaryTaskEditForm = class(TParentEditForm)
    teModule: TUniEdit;
    lModule: TUniLabel;
  private
    function Apply: boolean; override;
    function DoCheck: Boolean; override;
    function GetSummaryTask: TSummaryTask;

  protected
    ///
    procedure SetEntity(AEntity : TEntity); override;

  public
    ///    FEntity     ""
    property SummaryTask : TSummaryTask read GetSummaryTask;

  end;

function SummaryTaskEditForm: TSummaryTaskEditForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function SummaryTaskEditForm: TSummaryTaskEditForm;
begin
  Result := TSummaryTaskEditForm(UniMainModule.GetFormInstance(TSummaryTaskEditForm));
end;

{ TSummaryTaskEditForm }

function TSummaryTaskEditForm.Apply : boolean;
begin
  Result := inherited Apply();

  if not Result then exit;

  SummaryTask.Module := teModule.Text;

  Result := true;
end;

function TSummaryTaskEditForm.DoCheck: Boolean;
begin
  Result := inherited DoCheck();
end;

 ///    FEntity     ""
function TSummaryTaskEditForm.GetSummaryTask: TSummaryTask;
begin
  Result := nil;
  ///        -  nil!
  if not (FEntity is TSummaryTask) then
  begin
    Log('TSummaryTaskEditForm.GetSummaryTask error in FEntity type', lrtError);
    exit;
  end;

  ///         FEntity   TSummaryTask
  Result := Entity as TSummaryTask;
end;

procedure TSummaryTaskEditForm.SetEntity(AEntity: TEntity);
begin
  ///        -   !
  if not (AEntity is TSummaryTask) then
  begin
    Log('TSummaryTaskEditForm.SetEntity error in AEntity type', lrtError);
    exit;
  end;

  try
    inherited SetEntity(AEntity);

    ///
    teModule.Text := SummaryTask.Module;

  except
    Log('TSummaryTaskEditForm.SetEntity error', lrtError);
  end;
end;

end.
