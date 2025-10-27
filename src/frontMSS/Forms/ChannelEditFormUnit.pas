unit ChannelEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniButton,
  uniGUIBaseClasses, uniPanel,
  LoggingUnit,
  EntityUnit, ChannelUnit;

type
  TChannelEditForm = class(TParentEditForm)
  private
    function DoCheck: Boolean; override;
    function GetChannel: TChannel;
    procedure SetEntity(AEntity: TFieldSet);

  protected
    function Apply: boolean; override;

  public
    ///  ссылка на FEntity с приведением типа к "нашему"
    property Channel : TChannel read GetChannel;

  end;

function ChannelEditForm: TChannelEditForm;

implementation
{$R *.dfm}

uses MainModule;

function ChannelEditForm: TChannelEditForm;
begin
  Result := TChannelEditForm(UniMainModule.GetFormInstance(TChannelEditForm));
end;

{ TChannelEditForm }

function TChannelEditForm.Apply: boolean;
begin
  Result := inherited Apply();

  if not Result then exit;

//  Abonent.Channels := GetChannelsList;
//  Abonent.Attr := GetAttrList;
end;

function TChannelEditForm.DoCheck: Boolean;
begin
  Result := inherited DoCheck();
end;

 ///  ссылка на FEntity с приведением типа к "нашему"
function TChannelEditForm.GetChannel: TChannel;
begin
  Result := nil;
  ///  если это объект не нашего типа - возвращаем nil!
  if not (FEntity is TChannel) then
  begin
    Log('TChannelEditForm.GetChannel error in FEntity type', lrtError);
    exit;
  end;

  ///  если тип совпадает то возвращаем ссылку на FEntity как на TChannel
  Result := FEntity as TChannel;
end;

procedure TChannelEditForm.SetEntity(AEntity: TFieldSet);
begin
  ///  если это объект не нашего типа - не делаем ничего!
  if not (AEntity is TChannel) then
  begin
    Log('TChannelEditForm.SetEntity error in AEntity type', lrtError);
    exit;
  end;

  try
    inherited SetEntity(AEntity);

    ///  выводим поля канала
//    teModuleEdit.Text := StripTask.Module;

  except
    Log('TChannelEditForm.SetEntity error', lrtError);
  end;
end;

end.
