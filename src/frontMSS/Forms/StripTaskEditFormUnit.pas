unit StripTaskEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniButton,
  uniGUIBaseClasses, uniPanel,
  LoggingUnit,  TaskEditParentFormUnit,
  EntityUnit, StripTaskUnit, uniMultiItem, uniComboBox, Math, uniListBox,
  uniCheckBox, uniMemo, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  uniBasicGrid, uniDBGrid, uniTimer;

type
  TStripTaskEditForm = class(TTaskEditParentForm)
  private
    function Apply: boolean; override;
    function DoCheck: Boolean; override;
    function GetStripTask: TStripTask;

  protected
    procedure SetEntity(AEntity : TFieldSet); override;

  public
    property StripTask : TStripTask read GetStripTask;

  end;

function StripTaskEditForm: TStripTaskEditForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, TaskUnit;

function StripTaskEditForm: TStripTaskEditForm;
begin
  Result := TStripTaskEditForm(UniMainModule.GetFormInstance(TStripTaskEditForm));
end;

{ TStripTaskEditForm }

function TStripTaskEditForm.Apply : boolean;
begin
  Result := inherited Apply();

  if not Result then Exit;

//  StripTask.Module := cbModule.Text;

  Result := true;
end;

function TStripTaskEditForm.DoCheck: Boolean;
begin
  Result := inherited DoCheck();
end;

function TStripTaskEditForm.GetStripTask: TStripTask;
begin
  Result := nil;
  if not (FEntity is TStripTask) then
  begin
    Log('TStripTaskEditForm.GetStripTas error in FEntity type', lrtError);
    exit;
  end;

  Result := Entity as TStripTask;
end;

procedure TStripTaskEditForm.SetEntity(AEntity: TFieldSet);
begin
  // Accept both TStripTask and base TTask to allow generic REST entities
  if not (AEntity is TTask) then
  begin
    Log('TStripTaskEditForm.SetEntity error: invalid entity type', lrtError);
    Exit;
  end;

  try
    inherited SetEntity(AEntity);
    // base TTaskEditParentForm fills standard fields (tid/compid/depid/module/def/enabled)
  except
    Log('TStripTaskEditForm.SetEntity error', lrtError);
  end;
end;

end.
