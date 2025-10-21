unit DSProcessorTaskEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniButton,
  uniGUIBaseClasses, uniPanel,
  LoggingUnit,
  EntityUnit, DSProcessorTaskUnit, uniMultiItem, uniComboBox, Math;

type
  TDSProcessorTaskEditForm = class(TParentEditForm)
    lModule: TUniLabel;
    cbModule: TUniComboBox;
  private
    function Apply: boolean; override;
    function DoCheck: Boolean; override;
    function GetDSProcessorTask: TDSProcessorTask;

  protected
    /// класс который редактируется
    procedure SetEntity(AEntity : TEntity); override;

  public
    ///  ссылка на FEntity с приведением типа к "нашему"
    property DSProcessorTask : TDSProcessorTask read GetDSProcessorTask;

  end;

function DSProcessorTaskEditForm: TDSProcessorTaskEditForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function DSProcessorTaskEditForm: TDSProcessorTaskEditForm;
begin
  Result := TDSProcessorTaskEditForm(UniMainModule.GetFormInstance(TDSProcessorTaskEditForm));
end;

{ TDSProcessorTaskEditForm }

function TDSProcessorTaskEditForm.Apply : boolean;
begin
  Result := inherited Apply();

  if not Result then Exit;

  DSProcessorTask.Module := cbModule.Text;

  Result := true;
end;

function TDSProcessorTaskEditForm.DoCheck: Boolean;
begin
  Result := inherited DoCheck();
end;

 ///  ссылка на FEntity с приведением типа к "нашему"
function TDSProcessorTaskEditForm.GetDSProcessorTask: TDSProcessorTask;
begin
  Result := nil;
  ///  если это объект не нашего типа - возвращаем nil!
  if not (FEntity is TDSProcessorTask) then
  begin
    Log('TDSProcessorTaskEditForm.GetDSProcessorTas error in FEntity type', lrtError);
    exit;
  end;

  ///  если тип совпадает то возвращаем ссылку на FEntity как на TDSProcessorTask
  Result := Entity as TDSProcessorTask;
end;

procedure TDSProcessorTaskEditForm.SetEntity(AEntity: TEntity);
begin
  ///  если это объект не нашего типа - не делаем ничего!
  if not (AEntity is TDSProcessorTask) then
  begin
    Log('TDSProcessorTaskEditForm.SetEntity error in AEntity type', lrtError);
    exit;
  end;

  try
    inherited SetEntity(AEntity);

    ///  выводим название модуля
    cbModule.ItemIndex := IfThen(cbModule.Items.IndexOf(DSProcessorTask.Module) <> -1, cbModule.Items.IndexOf(DSProcessorTask.Module), 0);

  except
    Log('TDSProcessorTaskEditForm.SetEntity error', lrtError);
  end;
end;

end.
