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
  private
    FLinkSettingsEditFrame: TParentLinkSettingEditFrame;
    FQueueEditFrame: TQueueFrame;
    function DoCheck: Boolean; override;
    function GetChannel: TChannel;
    procedure SetEntity(AEntity: TEntity); override;

  protected
    function Apply: boolean; override;

  public
    ///  ������ �� FEntity � ����������� ���� � "������"
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

function TChannelEditForm.DoCheck: Boolean;
begin
  Result := inherited DoCheck();
end;

 ///  ������ �� FEntity � ����������� ���� � "������"
function TChannelEditForm.GetChannel: TChannel;
begin
  Result := nil;
  ///  ���� ��� ������ �� ������ ���� - ���������� nil!
  if not (FEntity is TChannel) then
  begin
    Log('TChannelEditForm.GetChannel error in FEntity type', lrtError);
    exit;
  end;

  ///  ���� ��� ��������� �� ���������� ������ �� FEntity ��� �� TChannel
  Result := FEntity as TChannel;
end;

procedure TChannelEditForm.SetEntity(AEntity: TEntity);
begin
  ///  ���� ��� ������ �� ������ ���� - �� ������ ������!
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
    FLinkSettingsEditFrame.Link := chan.Link;

    FQueueEditFrame := TQueueFrame.Create(Self);
    FQueueEditFrame.Parent := scrollBoxQueue;
    FQueueEditFrame.SetData(chan.Queue);

  except
    Log('TChannelEditForm.SetEntity error', lrtError);
  end;
end;

end.
