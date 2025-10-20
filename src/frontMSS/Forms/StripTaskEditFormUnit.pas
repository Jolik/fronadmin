unit StripTaskEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniButton,
  uniGUIBaseClasses, uniPanel,
  LoggingUnit,
  EntityUnit, StripTaskUnit, uniMultiItem, uniComboBox, Math;

type
  TStripTaskEditForm = class(TParentEditForm)
    lModule: TUniLabel;
    cbModule: TUniComboBox;
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

  if not Result then Exit;

  StripTask.Module := cbModule.Text;

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
    cbModule.ItemIndex := IfThen(cbModule.Items.IndexOf(StripTask.Module) <> -1, cbModule.Items.IndexOf(StripTask.Module), cbModule.Items.Count - 1);

  except
    Log('TStripTaskEditForm.SetEntity error', lrtError);
  end;
end;

end.
