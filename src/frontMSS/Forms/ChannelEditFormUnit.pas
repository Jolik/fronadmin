unit ChannelEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniButton,
  uniGUIBaseClasses, uniPanel,   QueueFrameUnit,
  LoggingUnit, ParentLinkSettingEditFrameUnit,
  EntityUnit, ChannelUnit, uniSplitter, uniScrollBox;

type
  TChannelEditForm = class(TParentEditForm)
    panelLink: TUniPanel;
    UniSplitter1: TUniSplitter;
    UniPanel2: TUniPanel;
    scrollBoxLinks: TUniScrollBox;
    scrollBoxQueue: TUniScrollBox;
    procedure btnOkClick(Sender: TObject);
  private
    FLinkSettingsEditFrame: TParentLinkSettingEditFrame;
    FQueueEditFrame: TQueueFrame;
    function DoCheck: Boolean; override;
    function GetChannel: TChannel;
    procedure SetEntity(AEntity: TEntity); override;

  protected
    function Apply: boolean; override;

  public
    ///  ссылка на FEntity с приведением типа к "нашему"
    property Channel : TChannel read GetChannel;

  end;

function ChannelEditForm: TChannelEditForm;

implementation
{$R *.dfm}

uses
  LinkFrameUtils,

  MainModule;

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

procedure TChannelEditForm.btnOkClick(Sender: TObject);
begin
  inherited;
  FQueueEditFrame.GetData(Channel.Queue);
  if IsEdit then
  begin

  end;
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

procedure TChannelEditForm.SetEntity(AEntity: TEntity);
begin
  ///  если это объект не нашего типа - не делаем ничего!
  if not (AEntity is TChannel) then
  begin
    Log('TChannelEditForm.SetEntity error in AEntity type', lrtError);
    exit;
  end;
  inherited SetEntity(AEntity);

  try
    var chan := (AEntity as TChannel);
    var linkFrameClass := LinkFrameByType(chan.Link.linkType);
    if linkFrameClass = nil then
      exit;
    FLinkSettingsEditFrame := linkFrameClass.Create(Self);
    FLinkSettingsEditFrame.Parent := scrollBoxLinks;
    FLinkSettingsEditFrame.SetData(chan.Link, nil);

    FQueueEditFrame := TQueueFrame.Create(Self);
    FQueueEditFrame.Parent := scrollBoxQueue;
    FQueueEditFrame.SetData(chan.Queue);

  except
    Log('TChannelEditForm.SetEntity error', lrtError);
  end;
end;

end.
