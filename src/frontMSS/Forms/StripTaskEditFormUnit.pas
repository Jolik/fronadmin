unit StripTaskEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniButton,
  uniGUIBaseClasses, uniPanel,
  LoggingUnit,
  EntityUnit, StripTaskUnit;

type
  TStripTaskEditForm = class(TParentEditForm)
    teModule: TUniEdit;
    lModule: TUniLabel;
  private
    function Apply: boolean; override;
    function DoCheck: Boolean; override;
    function GetStripTask: TStripTask;

  protected
    /// ����� ������� �������������
    procedure SetEntity(AEntity : TEntity); override;

  public
    ///  ������ �� FEntity � ����������� ���� � "������"
    property StripTask : TStripTask read GetStripTask;

  end;

function StripTaskEditForm: TStripTaskEditForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function StripTaskEditForm: TStripTaskEditForm;
begin
  Result := TStripTaskEditForm(UniMainModule.GetFormInstance(TStripTaskEditForm));
end;

{ TStripTaskEditForm }

function TStripTaskEditForm.Apply : boolean;
begin
  Result := inherited Apply();

  if not Result then exit;

  StripTask.Module := teModule.Text;

  Result := true;
end;

function TStripTaskEditForm.DoCheck: Boolean;
begin
  Result := inherited DoCheck();
end;

 ///  ������ �� FEntity � ����������� ���� � "������"
function TStripTaskEditForm.GetStripTask: TStripTask;
begin
  Result := nil;
  ///  ���� ��� ������ �� ������ ���� - ���������� nil!
  if not (FEntity is TStripTask) then
  begin
    Log('TStripTaskEditForm.GetStripTas error in FEntity type', lrtError);
    exit;
  end;

  ///  ���� ��� ��������� �� ���������� ������ �� FEntity ��� �� TStripTask
  Result := Entity as TStripTask;
end;

procedure TStripTaskEditForm.SetEntity(AEntity: TEntity);
begin
  ///  ���� ��� ������ �� ������ ���� - �� ������ ������!
  if not (AEntity is TStripTask) then
  begin
    Log('TStripTaskEditForm.SetEntity error in AEntity type', lrtError);
    exit;
  end;

  try
    inherited SetEntity(AEntity);

    ///  ������� �������� ������
    teModule.Text := StripTask.Module;

  except
    Log('TStripTaskEditForm.SetEntity error', lrtError);
  end;
end;

end.
