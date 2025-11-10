unit ProfilesFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, LinkUnit,
  uniGUIClasses, uniGUIFrame, uniGUIBaseClasses, uniTabControl, uniPanel,
  uniButton, uniPageControl, ProfileUnit, uniBitBtn, uniMultiItem, uniListBox,
  uniLabel, ProfileFrameUnit, uniComboBox, ProfilesRestBrokerUnit;

type
  TProfilesFrame = class(TUniFrame)
    profilePanel: TUniPanel;
    UniPanel3: TUniPanel;
    btnRemoveProfile: TUniBitBtn;
    btnAddProfile: TUniBitBtn;
    profilesComboBox: TUniComboBox;
    procedure profilesComboBoxSelect(Sender: TObject);
    procedure btnRemoveProfileClick(Sender: TObject);
    procedure btnAddProfileClick(Sender: TObject);
  private
    FProfiles: TProfileList;
    FProfileFrame: TProfileFrame;
    FLink: TLink;
    procedure Clear;
    procedure CreateProfile();
    procedure DrawProfile;
    procedure FillProfilesCombobox;
    procedure OnFrameChange(sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetData(src: TProfileList; link: TLink); virtual;
    procedure GetData(dst: TProfileList); virtual;

    function Validate(): boolean; virtual;
  end;

implementation

uses
 LoggingUnit, common;

{$R *.dfm}

{ TProfilesFrame }

constructor TProfilesFrame.Create(AOwner: TComponent);
begin
  inherited;
  FProfiles := TProfileList.Create()
end;



destructor TProfilesFrame.Destroy;
begin
  FProfiles.Free;
  inherited;
end;


procedure TProfilesFrame.SetData(src: TProfileList; link: TLink);
begin
  FProfiles.Assign(src);
  var pf1 := TProfile(src[0]).ProfileBody <> nil;
  var pf2 := TProfile(FProfiles[0]).ProfileBody <> nil;
  FLink := link;
  FillProfilesCombobox;
  if profilesComboBox.items.Count > 0 then
  begin
    profilesComboBox.ItemIndex := 0;
    profilesComboBoxSelect(self);
  end;
end;


function TProfilesFrame.Validate: boolean;
begin
  result := false;
  for var p in FProfiles do
    if (p as TProfile).Description = '' then
    begin
      MessageDlg(Format('неn описания профиля %s', [p.Id]), TMsgDlgType.mtError, [mbOK], nil);
      exit;
    end;
  result := true;
end;

procedure TProfilesFrame.GetData(dst: TProfileList);
begin
  dst.Assign(FProfiles);
end;



procedure TProfilesFrame.OnFrameChange(sender: TObject);
begin
  var p := TProfile(profilesComboBox.Items.Objects[profilesComboBox.ItemIndex]);
  if (FProfileFrame <> nil) and (p <> nil) then
    FProfileFrame.GetData(p);
end;


procedure TProfilesFrame.btnAddProfileClick(Sender: TObject);
begin
  CreateProfile;
end;



procedure TProfilesFrame.btnRemoveProfileClick(Sender: TObject);
begin
  if profilesComboBox.ItemIndex = -1 then
    exit;
  var p := TProfile(profilesComboBox.Items.Objects[profilesComboBox.ItemIndex]);
  var q := Format('Удалить профиль "%s"?', [p.id]);
  if MessageDlg(q, mtConfirmation, mbYesNo) <> mrYes then
    exit;
  FProfiles.Remove(p);
  Clear;
  FillProfilesCombobox;
  if profilesComboBox.items.Count > 0 then
  begin
    profilesComboBox.ItemIndex := 0;
    profilesComboBoxSelect(self);
  end;
end;


procedure TProfilesFrame.Clear;
begin
  profilesComboBox.Clear;
  FreeAndNil(FProfileFrame);
end;


procedure TProfilesFrame.CreateProfile;
begin
  var p := TProfile.Create;
  p.IsNew := true;
  p.Id := GenerateGuid;
  FProfiles.Add(p);
  FillProfilesCombobox;
  profilesComboBox.ItemIndex := profilesComboBox.Items.IndexOf(p.Id);
  profilesComboBoxSelect(self);
end;


procedure TProfilesFrame.profilesComboBoxSelect(Sender: TObject);
begin
  DrawProfile;
end;


procedure TProfilesFrame.DrawProfile;
begin
  FreeAndNil(FProfileFrame);
  if profilesComboBox.ItemIndex = -1 then
    exit;
  var p := TProfile(profilesComboBox.Items.Objects[profilesComboBox.ItemIndex]);
  FProfileFrame := TProfileFrame.Create(Self);
  FProfileFrame.Parent := profilePanel;
  FProfileFrame.SetData(p, FLink);
  FProfileFrame.OnChange := OnFrameChange;
end;



procedure TProfilesFrame.FillProfilesCombobox;
begin
  profilesComboBox.Clear;
  for var i := 0 to FProfiles.Count-1 do
    profilesComboBox.Items.AddObject(FProfiles[i].Id, FProfiles[i]);
end;





end.
