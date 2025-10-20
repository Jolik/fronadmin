unit ProfilesFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, LinkUnit,
  uniGUIClasses, uniGUIFrame, uniGUIBaseClasses, uniTabControl, uniPanel,
  uniButton, uniPageControl, ProfileUnit, uniBitBtn, uniMultiItem, uniListBox,
  uniLabel, ProfileFrameUnit;

type
  TProfilesFrame = class(TUniFrame)
    UniPanel2: TUniPanel;
    listboxProfiles: TUniListBox;
    UniPanel3: TUniPanel;
    btnRemoveProfile: TUniBitBtn;
    btnAddProfile: TUniBitBtn;
    profilePanel: TUniPanel;
    procedure listboxProfilesChange(Sender: TObject);
    procedure btnRemoveProfileClick(Sender: TObject);
    procedure btnAddProfileClick(Sender: TObject);
  private
    FProfiles: TProfileList;
    FLink: TLink;
    FProfileFrame: TProfileFrame;
    procedure Clear;
    procedure LoadList;
    function DeleteProfile(prid: string): boolean;
    procedure DrawProfiles;
    procedure SetLink(const Value: TLink);
  public
    function Apply: boolean; virtual;
    property Link: TLink read FLink write SetLink;
  end;

implementation

uses
 LoggingUnit,
 ProfilesBrokerUnit;

{$R *.dfm}

{ TProfilesFrame }

function TProfilesFrame.Apply: boolean;
begin

end;



procedure TProfilesFrame.LoadList;
var
  Pages : integer;
begin
  FreeAndNil(FProfiles);
  var broker := TProfilesBroker.Create;
  broker.Lid := Link.Id;
  try
    try
      var profilesList := broker.List(Pages);
      if profilesList = nil then
        exit;
      FProfiles := profilesList as TProfileList;
    except on e: exception do begin
      Log('TProfilesFrame.LoadList ' + e.Message, lrtError);
      FProfiles.Clear;
    end; end;
  finally
    broker.free;
  end;
end;


procedure TProfilesFrame.btnAddProfileClick(Sender: TObject);
begin
//
end;

procedure TProfilesFrame.btnRemoveProfileClick(Sender: TObject);
begin
  if listboxProfiles.ItemIndex = -1 then
    exit;
  var prid := listboxProfiles.Items[listboxProfiles.ItemIndex];
  if MessageDlg('Удалить профиль ' + prid + '?', mtWarning, [mbYes, mbNo] ) <> mrYes then
    exit;
  if not DeleteProfile(prid) then
    exit;
  Clear;
  LoadList;
  DrawProfiles;
  if listboxProfiles.items.Count > 0 then
    listboxProfiles.ItemIndex := 0;
  listboxProfilesChange(Self);
end;

procedure TProfilesFrame.Clear;
begin
  listboxProfiles.Clear;
end;

function TProfilesFrame.DeleteProfile(prid: string): boolean;
begin
  // todo: убрать (удаляет реальные профили)
  Showmessage('profile removing is disabled for test purposes');
  exit;

  result := false;
  var broker := TProfilesBroker.Create;
  broker.Lid := Link.Id;
  try
    try
      if not broker.Remove(prid) then
        exit;
    except on e: exception do begin
      Log('TProfilesFrame.DeleteProfile ' + e.Message, lrtError);
      exit;
    end; end;
  finally
    broker.free;
  end;
  result := true;
end;


procedure TProfilesFrame.DrawProfiles;
begin
  if FProfiles = nil then
    exit;
  for var i := 0 to FProfiles.Count-1 do
    listboxProfiles.Items.Add(FProfiles[i].Id);
end;


procedure TProfilesFrame.listboxProfilesChange(Sender: TObject);
begin
  if listboxProfiles.ItemIndex = -1 then
    exit;
  var prid := listboxProfiles.Items[listboxProfiles.ItemIndex];
  FreeAndNil(FProfileFrame);
  FProfileFrame := TProfileFrame.Create(Self);
  FProfileFrame.Parent := profilePanel;
  FProfileFrame.Lid := Link.Id;
  FProfileFrame.Prid := prid;
end;

procedure TProfilesFrame.SetLink(const Value: TLink);
begin
  FLink := Value;
  Clear;
  LoadList;
  DrawProfiles;
  if listboxProfiles.items.Count > 0 then
    listboxProfiles.ItemIndex := 0;
  listboxProfilesChange(Self);
end;

end.
