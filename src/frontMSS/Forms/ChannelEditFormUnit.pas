unit ChannelEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniButton,
  uniGUIBaseClasses, uniPanel,   QueueFrameUnit,
  LoggingUnit, ParentLinkSettingEditFrameUnit,  LinkUnit,
  ProfilesBrokerUnit, ProfileUnit, common, ChannelsBrokerUnit,
  EntityUnit, ChannelUnit, uniSplitter, uniScrollBox, uniMultiItem, uniComboBox;

type
  TChannelEditForm = class(TParentEditForm)
    panelLink: TUniPanel;
    UniSplitter1: TUniSplitter;
    UniPanel2: TUniPanel;
    scrollBoxLinks: TUniScrollBox;
    scrollBoxQueue: TUniScrollBox;
    UniContainerPanel1: TUniContainerPanel;
    UniLabel2: TUniLabel;
    comboLinkType: TUniComboBox;
    directionPanel: TUniContainerPanel;
    UniLabel5: TUniLabel;
    ComboBoxDirection: TUniComboBox;
    procedure comboLinkTypeChange(Sender: TObject);
  private
    FLinkSettingsEditFrame: TParentLinkSettingEditFrame;
    FQueueEditFrame: TQueueFrame;
    FProfilesBroker: TProfilesBroker;
    FProfiles: TProfileList;
    function DoCheck: Boolean; override;
    function GetChannel: TChannel;
    procedure SetEntity(AEntity: TEntity); override;

  protected
    function Apply: boolean; override;
    procedure CreateFrame();
    function LoadProfiles: boolean;
    function SaveProfiles: boolean;
    function SaveChannel: boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    ///  ссылка на FEntity с приведением типа к "нашему"
    property Channel : TChannel read GetChannel;

  end;

function ChannelEditForm: TChannelEditForm;

const UID = '4bcf9d6d-53b1-11ec-ab14-02420a0001b2'; // TODO

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

constructor TChannelEditForm.Create(AOwner: TComponent);
begin
  inherited;
  for var ls in LinkType2Str.Keys do
    comboLinkType.Items.Add(ls);
  FProfilesBroker := TProfilesBroker.Create;
  FProfiles := TProfileList.Create();
end;



destructor TChannelEditForm.Destroy;
begin
  FreeAndNil(FProfiles);
  FreeAndNil(FProfilesBroker);
  inherited;
end;

function TChannelEditForm.Apply: boolean;
begin
  result := false;
  FLinkSettingsEditFrame.GetData(Channel.Link, FProfiles);
  Channel.Link.Name := teName.Text;
  Channel.Link.Dir := ComboBoxDirection.Text;
  Channel.Link.CompId := UniMainModule.CompID;
  Channel.Link.DepId := UniMainModule.DeptID;
  Channel.CompId := UniMainModule.CompID;
  Channel.DepId := UniMainModule.DeptID;
  Channel.Name := Channel.Link.Name;
  Channel.Caption := Channel.Link.Name;
  Channel.Queue.CompId := UniMainModule.CompID;
  Channel.Queue.DepId := UniMainModule.DeptID;
  Channel.Queue.Caption := 'queue for ' + Channel.Name;
  Channel.Queue.Uid := UID;
  if not SaveChannel() then
    exit;
  if not SaveProfiles then
    exit;
  result := inherited;
end;



function TChannelEditForm.DoCheck: Boolean;
begin
  Result := inherited DoCheck();
end;


function TChannelEditForm.GetChannel: TChannel;
begin
  Result := FEntity as TChannel;
end;



function TChannelEditForm.LoadProfiles: boolean;
var
  Pages : integer;
begin
  if not IsEdit then
  begin
    result := true;
    exit;
  end;

  result := false;
  FProfiles.Clear;
  try
    var pl := FProfilesBroker.List(Pages);
    if pl = nil then
      exit;
    for var p in pl do
    begin
      var profile := FProfilesBroker.Info(p.Id);
      if profile <> nil then
        FProfiles.Add(profile);
    end;
    result := true;
  except on e: exception do begin
    Log('TLinkEditForm.LoadProfiles ' + e.Message, lrtError);
  end; end;
end;



procedure TChannelEditForm.comboLinkTypeChange(Sender: TObject);
begin
  inherited;
  // редактироваие типа только при создании нового линка
  if IsEdit then
    exit;
  if not (Entity is TChannel) then
    exit;
  if  (sender as TUniComboBox).Text = '' then
    exit;
  var typeStr := (sender as TUniComboBox).Text;
  (channel.link.Data as TLinkData).LinkType := LinkType2Str.ValueByKey(typeStr, ltUnknown);
  if channel.link.LinkType = ltUnknown then
    exit;
  CreateFrame;
end;

procedure TChannelEditForm.CreateFrame;
begin
  if not LoadProfiles() then
    exit;
  var frameClass := LinkFrameByType(channel.link.linkType);
  if frameClass = nil then
    exit;
  FLinkSettingsEditFrame := frameClass.Create(self);
  FLinkSettingsEditFrame.Parent := scrollBoxLinks;
  FLinkSettingsEditFrame.SetData(channel.Link, FProfiles);

  FQueueEditFrame := TQueueFrame.Create(Self);
  FQueueEditFrame.Parent := scrollBoxQueue;
  FQueueEditFrame.SetData(channel.Queue);
end;




function TChannelEditForm.SaveChannel: boolean;
begin
  var chanBroker := TChannelsBroker.Create(UniMainModule.CompID, UniMainModule.DeptID);
  try
    try
      if IsEdit then
        result := chanBroker.Update(Channel)
      else
        result := chanBroker.New(Channel);
    except on e: exception do begin
      Log('TLinkEditForm.SaveLink ' + e.Message, lrtError);
    end; end;
  finally
    chanBroker.Free;
  end;
end;


function TChannelEditForm.SaveProfiles: boolean;
begin
  try
    result := FProfilesBroker.Synchronize(FProfiles);
  except on e: exception do begin
    Log('TLinkEditForm.SaveProfiles ' + e.Message, lrtError);
  end; end;
end;


procedure TChannelEditForm.SetEntity(AEntity: TEntity);
begin
  inherited;
  if not (AEntity is TChannel) then
  begin
    Log('TChannelEditForm.SetEntity error in AEntity type', lrtError);
    exit;
  end;
  comboLinkType.ReadOnly := IsEdit;
  comboLinkType.ItemIndex := comboLinkType.Items.IndexOf(channel.Link.TypeStr);
  if not IsEdit then
  begin
    channel.Link.id := GenerateGuid;
    channel.Queue.id := GenerateGuid;
    Channel.Chid := GenerateGuid;
  end;
  teID.Text := channel.Link.id;
  FProfilesBroker.Lid := channel.Link.Id;
  ComboBoxDirection.ItemIndex := ComboBoxDirection.Items.IndexOf(channel.Link.Dir);
  CreateFrame;
  comboLinkType.ItemIndex := comboLinkType.Items.IndexOf(channel.Link.TypeStr);
end;

end.
