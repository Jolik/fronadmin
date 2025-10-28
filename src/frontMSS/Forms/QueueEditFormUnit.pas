unit QueueEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniButton,
  uniGUIBaseClasses, uniPanel,
  LoggingUnit,
  EntityUnit, QueueUnit;

type
  TQueueEditForm = class(TParentEditForm)
  private
    function DoCheck: Boolean; override;
    function GetQueue: TQueue;
    procedure SetEntity(AEntity: TFieldSet);

  protected
    function Apply: boolean; override;

  public
    property Queue: TQueue read GetQueue;
  end;

function QueueEditForm: TQueueEditForm;

implementation

{$R *.dfm}

uses MainModule;

function QueueEditForm: TQueueEditForm;
begin
  Result := TQueueEditForm(UniMainModule.GetFormInstance(TQueueEditForm));
end;

{ TQueueEditForm }

function TQueueEditForm.Apply: boolean;
begin
  Result := inherited Apply();
  if not Result then Exit;
end;

function TQueueEditForm.DoCheck: Boolean;
begin
  Result := inherited DoCheck();
end;

function TQueueEditForm.GetQueue: TQueue;
begin
  Result := nil;
  if not (FEntity is TQueue) then
  begin
    Log('TQueueEditForm.GetQueue error in FEntity type', lrtError);
    Exit;
  end;
  Result := FEntity as TQueue;
end;

procedure TQueueEditForm.SetEntity(AEntity: TFieldSet);
begin
  if not (AEntity is TQueue) then
  begin
    Log('TQueueEditForm.SetEntity error in AEntity type', lrtError);
    Exit;
  end;
  try
    inherited SetEntity(AEntity);
  except
    Log('TQueueEditForm.SetEntity error', lrtError);
  end;
end;

end.

