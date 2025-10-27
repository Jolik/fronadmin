unit ProfilesFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, LinkUnit,
  uniGUIClasses, uniGUIFrame, uniGUIBaseClasses, uniTabControl, uniPanel,
  uniButton, uniPageControl, ProfileUnit, uniBitBtn, uniMultiItem, uniListBox,
  uniLabel, ProfileFrameUnit, uniComboBox,
  RestBrokerBaseUnit, ProfilesRestBrokerUnit, ProfileHttpRequests, BaseResponses;

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
    procedure BitBtnSaveProfileClick(Sender: TObject);
  private
    FProfiles: TProfileList;
    FLink: TLink;
    FProfileFrame: TProfileFrame;
    FBroker: TProfilesRestBroker;
    procedure Clear;
    procedure LoadList;
    function DeleteProfile(prid: string): boolean;
    function LoadProfile(prid: string): boolean;
    function SaveProfile(): boolean;
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
  LoggingUnit, MainModule, uniGUIApplication, EntityUnit;

{$R *.dfm}

{ TProfilesFrame }

constructor TProfilesFrame.Create(AOwner: TComponent);
begin
  inherited;
  FBroker := TProfilesRestBroker.Create(UniMainModule.XTicket);
end;

destructor TProfilesFrame.Destroy;
begin
  FBroker.Free;
  inherited;
end;

procedure TProfilesFrame.SetLink(const Value: TLink);
begin
  FLink := Value;
  Clear;
  LoadList;
  DrawProfiles;
end;

function TProfilesFrame.Apply: boolean;
begin
  Result := true;
end;

procedure TProfilesFrame.LoadList;
var
  Pages : integer;
  Req: TProfileReqList;
  Resp: TProfileListResponse;
  List: TEntityList;
begin
  try
    Req := FBroker.CreateReqList() as TProfileReqList;
    Req.Lid := FLink.Id;
    Resp := FBroker.List(Req) as TProfileListResponse;
    try
      if not Assigned(Resp) then Exit;
      List := Resp.EntityList;
      FreeAndNil(FProfiles);
      if Assigned(List) and (List is TProfileList) then
      begin
        FProfiles := TProfileList.Create(True);
        for var i := 0 to List.Count - 1 do
          if List.Items[i] is TProfile then
          begin
            var NewP := TProfile.Create;
            NewP.Assign(TProfile(List.Items[i]));
            FProfiles.Add(NewP);
          end;
      end;
    finally
      Resp.Free;
    end;
  except on e: exception do
    begin
      Log('TProfilesFrame.LoadList ' + e.Message, lrtError);
      Clear;
    end;
  end;
end;

procedure TProfilesFrame.profilesComboBoxSelect(Sender: TObject);
begin
  if profilesComboBox.ItemIndex = -1 then
    Exit;
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
    Exit;
  var prid := profilesComboBox.Items[profilesComboBox.ItemIndex];
  var q := Format('Удалить профиль "%s"?', [prid]);
  if MessageDlg(q, mtConfirmation, mbYesNo) <> mrYes then
    Exit;
  if not DeleteProfile(prid) then
    Exit;
  Clear;
  LoadList;
  DrawProfiles;
end;

procedure TProfilesFrame.BitBtnSaveProfileClick(Sender: TObject);
begin
  SaveProfile;
end;

procedure TProfilesFrame.Clear;
begin
  profilesComboBox.Clear;
  FreeAndNil(FProfileFrame);
  BitBtnSaveProfile.Visible := false;
end;

function TProfilesFrame.DeleteProfile(prid: string): boolean;
begin
  Result := false;
  try
    var Req := FBroker.CreateReqRemove() as TProfileReqRemove;
    Req.Lid := FLink.Id;
    Req.Id := prid;
    var JR := FBroker.Remove(Req);
    try
      if not Assigned(JR) then Exit;
    finally
      JR.Free;
    end;
    Result := true;
  except on e: exception do
    begin
      Log('TProfilesFrame.DeleteProfile ' + e.Message, lrtError);
    end;
  end;
end;

function TProfilesFrame.LoadProfile(prid: string): boolean;
var
  Req: TProfileReqInfo;
  Resp: TProfileInfoResponse;
  P, CopyP: TProfile;
begin
  FreeAndNil(FProfileFrame);
  try
    Req := FBroker.CreateReqInfo() as TProfileReqInfo;
    Req.Lid := FLink.Id;
    Req.Id := prid;
    Resp := FBroker.Info(Req) as TProfileInfoResponse;
    try
      P := nil;
      if Assigned(Resp) and (Resp.Entity is TProfile) then
        P := TProfile(Resp.Entity);
      if not Assigned(P) then Exit;
      CopyP := TProfile.Create;
      CopyP.Assign(P);
    finally
      Resp.Free;
    end;
    FProfileFrame := TProfileFrame.Create(Self);
    FProfileFrame.Parent := profilePanel;
    FProfileFrame.SetData(CopyP);
    FProfileFrame.SetLink(FLink);
    BitBtnSaveProfile.Visible := true;
    BitBtnSaveProfile.Caption := 'Редактировать';
  except on e: exception do
    begin
      Log('TProfileFrame.LoadProfile ' + e.Message, lrtError);
    end;
  end;
end;

procedure TProfilesFrame.CreateProfile;
begin
  var p := TProfile.Create;
  p.IsNew := true;
  FreeAndNil(FProfileFrame);
  FProfileFrame := TProfileFrame.Create(Self);
  FProfileFrame.Parent := profilePanel;
  FProfileFrame.SetData(p);
  FProfileFrame.SetLink(FLink);
  BitBtnSaveProfile.Visible := true;
  BitBtnSaveProfile.Caption := 'Создать';
end;

function TProfilesFrame.SaveProfile(): boolean;
const
  updString: array[boolean] of string = ('создание','обновление');
begin
  Result := false;
  if FProfileFrame = nil then
    Exit;
  var profile := TProfile.Create;
  FProfileFrame.GetData(profile);
  try
    if profile.IsNew then
    begin
      var R := FBroker.CreateReqNew() as TProfileReqNew;
      R.Lid := FLink.Id;
      R.ApplyBody(profile);
      var JR := FBroker.New(R);
      try
        Result := Assigned(JR) and (JR.StatusCode = 201);
      finally
        JR.Free;
      end;
    end
    else
    begin
      var U := FBroker.CreateReqUpdate() as TProfileReqUpdate;
      U.Lid := FLink.Id;
      U.Id := profile.Id;
      U.ApplyFromEntity(profile);
      var JR2 := FBroker.Update(U);
      try
        Result := Assigned(JR2) and (JR2.StatusCode = 200);
      finally
        JR2.Free;
      end;
    end;
    if Result then
    begin
      Log('Профиль %s %s', [profile.id, updString[profile.IsNew]]);
      Clear;
      LoadList;
      DrawProfiles;
    end;
  except on e: exception do
    begin
      Log('TProfileFrame.SaveProfile ' + e.Message, lrtError);
    end;
  end;
end;

procedure TProfilesFrame.DrawProfiles;
begin
  if FProfiles = nil then
    Exit;
  for var i := 0 to FProfiles.Count-1 do
    profilesComboBox.Items.Add(FProfiles[i].Id);
  if profilesComboBox.items.Count > 0 then
    profilesComboBox.ItemIndex := 0;
  profilesComboBoxSelect(Self);
end;

end.

