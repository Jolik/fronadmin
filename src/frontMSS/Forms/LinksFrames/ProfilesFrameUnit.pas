unit ProfilesFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, LinkUnit,
  uniGUIClasses, uniGUIFrame, uniGUIBaseClasses, uniTabControl, uniPanel,
  uniButton, uniPageControl, ProfileUnit, uniBitBtn, uniMultiItem, uniListBox,
  uniLabel, ProfileFrameUnit, uniComboBox, ProfilesBrokerUnit;

type
  TProfilesFrame = class(TUniFrame)
    profilePanel: TUniPanel;
    UniPanel3: TUniPanel;
    btnRemoveProfile: TUniBitBtn;
    btnAddProfile: TUniBitBtn;
    profilesComboBox: TUniComboBox;
    UniPanel1: TUniPanel;
    BitBtnSaveProfile: TUniBitBtn;
    procedure profilesComboBoxSelect(Sender: TObject);
    procedure btnRemoveProfileClick(Sender: TObject);
    procedure btnAddProfileClick(Sender: TObject);
  private
    FProfiles: TProfileList;
    FLink: TLink;
    FProfileFrame: TProfileFrame;
    FBroker: TProfilesBroker;
    procedure Clear;
    procedure LoadList;
    function DeleteProfile(prid: string): boolean;
    function LoadProfile(prid: string): boolean;
    procedure CreateProfile();
    procedure DrawProfiles;
    procedure SetLink(const Value: TLink);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Apply: boolean; virtual;
    property Link: TLink read FLink write SetLink;
  end;

implementation

uses
 LoggingUnit;

{$R *.dfm}

{ TProfilesFrame }

constructor TProfilesFrame.Create(AOwner: TComponent);
begin
  inherited;
  FBroker := TProfilesBroker.Create;
end;



destructor TProfilesFrame.Destroy;
begin
  FBroker.Free;
  inherited;
end;


procedure TProfilesFrame.SetLink(const Value: TLink);
begin
  FLink := Value;
  FBroker.Lid := FLink.Id;
  Clear;
  LoadList;
  DrawProfiles;
end;


function TProfilesFrame.Apply: boolean;
begin

  result := true;
end;



procedure TProfilesFrame.LoadList;
var
  Pages : integer;
begin
  try
    var profilesList := FBroker.List(Pages);
    if profilesList = nil then
      exit;
    FProfiles := profilesList as TProfileList;
  except on e: exception do begin
    Log('TProfilesFrame.LoadList ' + e.Message, lrtError);
    Clear;
  end; end;
end;


procedure TProfilesFrame.profilesComboBoxSelect(Sender: TObject);
begin
  if profilesComboBox.ItemIndex = -1 then
    exit;
  var prid := profilesComboBox.Items[profilesComboBox.ItemIndex];
  LoadProfile(prid);
end;


procedure TProfilesFrame.btnAddProfileClick(Sender: TObject);
begin
  profilesComboBox.ItemIndex := -1;
  CreateProfile;
end;

procedure TProfilesFrame.btnRemoveProfileClick(Sender: TObject);
begin
  if profilesComboBox.ItemIndex = -1 then
    exit;
  var prid := profilesComboBox.Items[profilesComboBox.ItemIndex];
  var q := Format('Удалить профиль "%s"?', [prid]);
  if MessageDlg(q, mtConfirmation, mbYesNo) <> mrYes then
    exit;
  if not DeleteProfile(prid) then
    exit;
  Clear;
  LoadList;
  DrawProfiles;
end;



procedure TProfilesFrame.Clear;
begin
  profilesComboBox.Clear;
  FreeAndNil(FProfileFrame);
  BitBtnSaveProfile.Visible := false;
end;



function TProfilesFrame.DeleteProfile(prid: string): boolean;
begin
  result := false;
  try
    if not FBroker.Remove(prid) then
      exit;
    result := true;
  except on e: exception do begin
    Log('TProfilesFrame.DeleteProfile ' + e.Message, lrtError);
  end; end;
end;


function TProfilesFrame.LoadProfile(prid: string): boolean;
begin
  FreeAndNil(FProfileFrame);
  try
    var p := FBroker.Info(prid);
    if not (p is TProfile) then
      exit;
    FProfileFrame := TProfileFrame.Create(Self);
    FProfileFrame.Parent := profilePanel;
    FProfileFrame.SetData(p as TProfile);
    FProfileFrame.SetLink(FLink);
    BitBtnSaveProfile.Visible := true;
    BitBtnSaveProfile.Caption := 'Сохранить';
  except on e: exception do begin
    Log('TProfileFrame.LoadProfile ' + e.Message, lrtError);
  end; end;
end;


procedure TProfilesFrame.CreateProfile;
begin
  var p := TProfile.Create;
  p.IsNew := true;
  FreeAndNil(FProfileFrame);
  FProfileFrame := TProfileFrame.Create(Self);
  FProfileFrame.Parent := profilePanel;
  FProfileFrame.SetData(p);
  BitBtnSaveProfile.Visible := true;
  BitBtnSaveProfile.Caption := 'Создать';
end;


procedure TProfilesFrame.DrawProfiles;
begin
  if FProfiles = nil then
    exit;
  for var i := 0 to FProfiles.Count-1 do
    profilesComboBox.Items.Add(FProfiles[i].Id);
  if profilesComboBox.items.Count > 0 then
    profilesComboBox.ItemIndex := 0;
  profilesComboBoxSelect(Self);
end;




end.
