unit LinkEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,  EntityUnit,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniButton,
  uniGUIBaseClasses, uniPanel, ParentLinkSettingEditFrameUnit, uniMultiItem,
  uniComboBox,  ProfileUnit, ProfilesBrokerUnit, LinkUnit;

type
  TLinkEditForm = class(TParentEditForm)
    UniContainerPanel1: TUniContainerPanel;
    UniLabel2: TUniLabel;
    comboLinkType: TUniComboBox;
    UniContainerPanel3: TUniContainerPanel;
    UniLabel4: TUniLabel;
    UniComboBox2: TUniComboBox;
    directionPanel: TUniContainerPanel;
    UniLabel5: TUniLabel;
    ComboBoxDirection: TUniComboBox;
    procedure btnOkClick(Sender: TObject);
    procedure comboLinkTypeChange(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FLinkSettingsEditFrame: TParentLinkSettingEditFrame;
    FProfilesBroker: TProfilesBroker;
    FProfiles: TProfileList;
    function GetLink: TLink;
  protected
    function Apply: boolean; override;
    procedure SetEntity(AEntity : TEntity); override;
    function SaveLink: boolean;
    procedure CreateFrame();
    function LoadProfiles: boolean;
    function SaveProfiles: boolean;
    property Link: TLink read GetLink;
    function DoCheck: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

function LinkEditForm: TLinkEditForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication,
  LinkFrameUtils,
  LoggingUnit,
  common,
  LinksBrokerUnit;

function LinkEditForm: TLinkEditForm;
begin
  Result := TLinkEditForm(UniMainModule.GetFormInstance(TLinkEditForm));
end;

{ TLinkEditForm }


constructor TLinkEditForm.Create(AOwner: TComponent);
begin
  inherited;
  for var ls in LinkType2Str.Keys do
    comboLinkType.Items.Add(ls);
  FProfilesBroker := TProfilesBroker.Create;
  FProfiles := TProfileList.Create();
end;


destructor TLinkEditForm.Destroy;
begin
  FreeAndNil(FProfiles);
  FreeAndNil(FProfilesBroker);
  inherited;
end;


function TLinkEditForm.DoCheck: Boolean;
begin
  result := false;
  if not FLinkSettingsEditFrame.Validate() then
    exit;
  result := inherited;
end;

function TLinkEditForm.GetLink: TLink;
begin
  result :=  (Entity as TLink);
end;

procedure TLinkEditForm.btnCancelClick(Sender: TObject);
begin
  inherited;
  // не стрирать!
end;

procedure TLinkEditForm.btnOkClick(Sender: TObject);
begin
  inherited;
  // не стрирать!
end;


procedure TLinkEditForm.comboLinkTypeChange(Sender: TObject);
begin
  inherited;
  // редактироваие типа только при создании нового линка
  if IsEdit then
    exit;
  if not (Entity is TLink) then
    exit;
  if  (sender as TUniComboBox).Text = '' then
    exit;
  var typeStr := (sender as TUniComboBox).Text;
  (link.Data as TLinkData).LinkType := LinkType2Str.ValueByKey(typeStr, ltUnknown);
  if link.LinkType = ltUnknown then
    exit;
  CreateFrame;
end;




function TLinkEditForm.Apply: boolean;
begin
  result := false;
  Link.Name := teName.Text;
  Link.Dir := ComboBoxDirection.Text;
  Link.CompId := UniMainModule.CompID;
  Link.DepId := UniMainModule.DeptID;
  FLinkSettingsEditFrame.GetData(Link, FProfiles);
  if not SaveLink() then
    exit;
  if not SaveProfiles then
    exit;
  result := inherited;
end;


function TLinkEditForm.SaveLink: boolean;
begin
  var LinksBroker := TLinksBroker.Create();
  try
    try
      if IsEdit then
        result := LinksBroker.Update(Link)
      else
        result := LinksBroker.New(Link);
    except on e: exception do begin
      Log('TLinkEditForm.SaveLink ' + e.Message, lrtError);
    end; end;
  finally
    LinksBroker.Free;
  end;
end;


function TLinkEditForm.LoadProfiles: boolean;
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


function TLinkEditForm.SaveProfiles(): boolean;
begin
  try
    result := FProfilesBroker.Synchronize(FProfiles);
  except on e: exception do begin
    Log('TLinkEditForm.SaveProfiles ' + e.Message, lrtError);
  end; end;
end;


procedure TLinkEditForm.SetEntity(AEntity: TEntity);
begin
  inherited;
  comboLinkType.ReadOnly := IsEdit;
  if not (entity is TLink) then
    exit;
  if not IsEdit then
    Link.id := GenerateGuid;
  teID.Text := Link.id;
  FProfilesBroker.Lid := Link.Id;
  ComboBoxDirection.ItemIndex := ComboBoxDirection.Items.IndexOf(Link.Dir);
  CreateFrame;
  comboLinkType.ItemIndex := comboLinkType.Items.IndexOf(Link.TypeStr);
end;



procedure TLinkEditForm.CreateFrame;
begin
  if not (entity is TLink) then
    exit;
  if not LoadProfiles() then
    exit;
  var frameClass := LinkFrameByType(link.linkType);
  if frameClass = nil then
    exit;
  FLinkSettingsEditFrame := frameClass.Create(LinkEditForm);
  FLinkSettingsEditFrame.Parent := pnClient;
  FLinkSettingsEditFrame.SetData(Link, FProfiles);
end;




end.
