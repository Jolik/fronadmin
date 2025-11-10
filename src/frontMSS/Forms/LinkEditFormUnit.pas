unit LinkEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,  EntityUnit,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniButton,
  uniGUIBaseClasses, uniPanel, ParentLinkSettingEditFrameUnit, uniMultiItem,
  uniComboBox,  ProfileUnit, ProfilesRestBrokerUnit, LinkUnit, uniTimer;

type
  TLinkEditForm = class(TParentEditForm)
    UniContainerPanel1: TUniContainerPanel;
    UniLabel2: TUniLabel;
    teID: TUniEdit;
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
    FProfilesBroker: TProfilesRestBroker;
    FProfiles: TProfileList;
    function GetLink: TLink;
  protected
    function Apply: boolean; override;
    procedure SetEntity(AEntity : TFieldSet); override;
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
  MainModule, uniGUIApplication, IdHTTP,
  LinkFrameUtils,
  LoggingUnit,
  common,
  BaseResponses,
  ProfileHttpRequests,
  HttpClientUnit,
  LinksRestBrokerUnit;

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
  FProfilesBroker := TProfilesRestBroker.Create(UniMainModule.XTicket);
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
var
  resp : TJSONResponse;
begin
  resp:= nil;
  Result:=false;
  var LinksBroker := TLinksRestBroker.Create();
  try
    try
      if IsEdit then
      begin
        var req := LinksBroker.CreateReqUpdate();
        try
          req.ApplyFromEntity(Link);
          resp := LinksBroker.Update(req);
          exit(true);
        finally
           req.free;
        end;
      end
      else
      begin
      var req := LinksBroker.CreateReqNew();
        try
          req.ApplyBody(Link);
          resp := LinksBroker.New(req);
          exit(true);
        finally
          req.Free;
        end;
      end;
    except on e: exception do begin
      Log('TLinkEditForm.SaveLink ' + e.Message, lrtError);
    end; end;
  finally
    LinksBroker.Free;
    resp.Free
  end;
end;


function TLinkEditForm.LoadProfiles: boolean;
var
  Pages : integer;
  resp: TProfileListResponse;
  infoResp : TEntityResponse;
  req: TProfileReqList;
begin
  if not IsEdit then
  begin
    result := true;
    exit;
  end;

  result := false;
  FProfiles.Clear;
  resp:= nil;
  try
    try
      req := FProfilesBroker.CreateReqList as TProfileReqList;
      req.Lid := Link.Id;
      resp := FProfilesBroker.List(req);
      if resp = nil then exit;
      for var p in resp.ProfileList do
      begin
        infoResp:= nil;
        var reqInfo := FProfilesBroker.CreateReqInfo(Link.Id, p.Id);
        try
          infoResp := FProfilesBroker.Info(reqInfo);
          if infoResp.Entity <> nil then
          begin
            var ec := TProfile.Create;
            ec.Assign(infoResp.Entity);
            var pb2 := ec.ProfileBody;
            FProfiles.Add(ec);
          end;
        finally
          reqInfo.Free;
          infoResp.Free;
        end;
      end;
      result := true;
    except
      on E: EIdHTTPProtocolException do begin
        MessageDlg(Format('Ошибка получения спика профилей лика. HTTP %d'#13#10'%s',
          [E.ErrorCode, E.ErrorMessage]), mtWarning, [mbOK], nil);
        Log('TLinkEditForm.LoadProfiles ' + e.Message+' '+E.ErrorMessage, lrtError);
        result := false;
      end;
      on E: Exception do begin
        MessageDlg('Ошибка получения спика профилей лика: ' + E.Message, mtWarning, [mbOK], nil);
        Log('TLinkEditForm.LoadProfiles ' + e.Message, lrtError);
        result := false;
      end;

    end;
  finally
    req.Free;
    resp.Free;
  end;
end;


function TLinkEditForm.SaveProfiles(): boolean;
var
  delresp, newresp :TJSONResponse;
begin
  try
    for var prof in FProfiles do
    begin
       var remReq := FProfilesBroker.CreateReqRemove;
       try
         remReq.Id := prof.Id;
         delresp := FProfilesBroker.Remove(remReq);
       finally
          delresp.Free;
          remReq.Free;
       end;
       var newReq := FProfilesBroker.CreateReqNew;
       try
         newReq.ApplyBody(prof);
         newResp := FProfilesBroker.New(newReq);
       finally
          newReq.Free;
          newResp.Free;
       end;
    end;
  except on e: exception do begin
    Log('TLinkEditForm.SaveProfiles ' + e.Message, lrtError);
  end; end;
end;


procedure TLinkEditForm.SetEntity(AEntity: TFieldSet);
begin
  inherited;
  comboLinkType.ReadOnly := IsEdit;
  if not (entity is TLink) then
    exit;
  if not IsEdit then
    Link.id := GenerateGuid;
  teID.Text := Link.id;
//  FProfilesBroker.Lid := Link.Id;
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
  FLinkSettingsEditFrame.Align := alClient;
  FLinkSettingsEditFrame.SetData(Link, FProfiles);
end;




end.
