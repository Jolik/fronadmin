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
    /// класс который редактируется
    procedure SetEntity(AEntity : TEntity); override;

  public
    ///  ссылка на FEntity с приведением типа к "нашему"
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

 ///  ссылка на FEntity с приведением типа к "нашему"
function TStripTaskEditForm.GetStripTask: TStripTask;
begin
  Result := nil;
  ///  если это объект не нашего типа - возвращаем nil!
  if not (FEntity is TStripTask) then
  begin
    Log('TStripTaskEditForm.GetStripTas error in FEntity type', lrtError);
    exit;
  end;

  ///  если тип совпадает то возвращаем ссылку на FEntity как на TStripTask
  Result := Entity as TStripTask;
end;

procedure TStripTaskEditForm.SetEntity(AEntity: TEntity);
begin
  ///  если это объект не нашего типа - не делаем ничего!
  if not (AEntity is TStripTask) then
  begin
    Log('TStripTaskEditForm.SetEntity error in AEntity type', lrtError);
    exit;
  end;

  try
    inherited SetEntity(AEntity);

    ///  выводим название модуля
    cbModule.ItemIndex := IfThen(cbModule.Items.IndexOf(StripTask.Module) <> -1, cbModule.Items.IndexOf(StripTask.Module), cbModule.Items.Count - 1);

  except
    Log('TStripTaskEditForm.SetEntity error', lrtError);
  end;
end;

end.
