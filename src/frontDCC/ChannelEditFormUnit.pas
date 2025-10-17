unit ChannelEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, System.Generics.Collections,
  uniGUIClasses, uniGUIForm, uniGUIFrame, uniPanel, uniButton, uniLabel,
  uniEdit, uniComboBox, uniPageControl, uniCheckBox,
  uniGUIBaseClasses, System.JSON, System.StrUtils, uniMultiItem,
  uniGUIApplication,
  MainModule, uniScrollBox, uniGroupBox,
  LoggingUnit,
  ParentFrameUnit,

  SharedFrameConnection,
  DirUpLinkEditFrameUnit,
  DirDownLinkEditFrameUnit,
  FTPSRVDownFrameUnit,
  SocketSpecialFrameUnit  ;

type
  TChannelDirection = (cdDownload, cdUpload, cdDuplex);
  TChannelType = (
    // datacomm
    ctDirDown,
    ctDirUp,
    ctFTPClientDown,
    ctFTPClientUp,
    ctFTPServerDown,
    ctFTPServerUp,
    ctOpenMCEP,
    ctPOP3Client,
    ctSMTPClient,
    ctSMTPServer,
    ctSocketSpecial,
    //drvcomm
    ctSebaSGS,
    ctSebaCSD,
    ctHTTPClient,
    //
    ctLinkopMsgHolder,
    ctDestClient  // ?
  );
  TService = (svDatacomm, svDrvComm);

  TFrameClass = class of TParentFrame;

  TLinkSetup = record
    Name: string;
    StringType: string;
    ChannelType: TChannelType;
    Direction: TChannelDirection;
    FrameClass:  TFrameClass;
    Service: TService;
    constructor Create(AName, AStringType: string;
      AChannelType: TChannelType;
      ADirection: TChannelDirection;
      AService: TService;
      AFrameClass:  TFrameClass);
  end;

  TChannelEditForm = class(TUniForm)
    // Main container
    MainPanel: TUniPanel;
    
    // Buttons panel
    ButtonsPanel: TUniPanel;
    OkButton: TUniButton;
    CancelButton: TUniButton;
    
    // Page control for tabs
    PageControl: TUniPageControl;
    
    // Basic settings tab
    BasicTab: TUniTabSheet;
    ChannelNameLabel: TUniLabel;
    ChannelNameEdit: TUniEdit;
    ChannelCaptionLabel: TUniLabel;
    ChannelCaptionEdit: TUniEdit;
    
    // Queue settings tab
    QueueTab: TUniTabSheet;
    AllowPutCheckBox: TUniCheckBox;
    DoublesCheckBox: TUniCheckBox;
    MaxLimitLabel: TUniLabel;
    MaxLimitEdit: TUniEdit;
    CriticalLimitLabel: TUniLabel;
    CriticalLimitEdit: TUniEdit;
    
    // Link settings tab
    LinkTab: TUniTabSheet;
    UniPanel1: TUniPanel;
    DirectionLabel: TUniLabel;
    DirectionComboBox: TUniComboBox;
    TypeLabel: TUniLabel;
    TypeComboBox: TUniComboBox;
    UniScrollBox1: TUniScrollBox;
    UniTabSheet1: TUniTabSheet;
    UniTabSheet2: TUniTabSheet;

    procedure UniFormCreate(Sender: TObject);
    procedure DirectionComboBoxChange(Sender: TObject);
    procedure TypeComboBoxChange(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);

  private
    FChannelID: string;
    FIsEditMode: Boolean;
    FCurrentSetup: TLinkSetup;

    ///  setup chanel frame
    FLinkEditFrame: TParentFrame;

    procedure SetupLayout;
    procedure LoadChannelData(const ChannelData: TJSONObject);
    function ValidateData: Boolean;
    function GenerateJSONData: string;

    procedure SetupLinkTab;

    function SendCreateRequest(const JSONData: string): Boolean;
    function SendUpdateRequest(const JSONData: string): Boolean;

  public
    property ChannelID: string read FChannelID write FChannelID;
    property IsEditMode: Boolean read FIsEditMode write FIsEditMode;
  end;


  ///  create edit form to edit channel
  function EditChannel(const AChannelID: string; const ChannelData: TJSONObject): Boolean;
  ///  create edit form to create new channel
  function CreateChannel: Boolean;

implementation


var
  linkSetupMap: TDictionary<string, TLinkSetup>;

{$R *.dfm}

function EditChannel(const AChannelID: string; const ChannelData: TJSONObject): Boolean;
var
  Form: TChannelEditForm;

begin

  ///  create chanel edit form
  Form := TChannelEditForm.Create(UniApplication); //(UniMainModule.GetFormInstance(TChannelEditForm));

  try
    Form.ChannelID := AChannelID;
    Form.IsEditMode := True;
    Form.Caption := 'Редактирование канала';

    if Assigned(ChannelData) then
      Form.LoadChannelData(ChannelData);

    Result := (Form.ShowModal = mrOk);

  finally
    //Form.Free;
  end;

end;

function CreateChannel: Boolean;
var
  Form: TChannelEditForm;

begin
  Form := TChannelEditForm.Create(UniApplication); //(UniMainModule.GetFormInstance(TChannelEditForm));

  try
    Form.IsEditMode := False;
    Form.Caption := 'Создание нового канала';

    Result := (Form.ShowModal = mrOk);

  finally
    //Form.Free;
  end;

end;

{  TChannelEditForm  }

procedure TChannelEditForm.UniFormCreate(Sender: TObject);
begin
  SetupLayout;

  // Set default values
  MaxLimitEdit.Text := '1500';
  CriticalLimitEdit.Text := '2000';

end;

procedure TChannelEditForm.SetupLayout;
begin
  // Basic form setup
  Self.Width := 800;
  Self.Height := 600;
  Self.BorderStyle := bsDialog;
  Self.Position := poScreenCenter;

  // Main panel
  MainPanel.Align := alClient;
  MainPanel.Layout := 'fit';

  // Page control
  PageControl.Align := alClient;

  // Buttons panel
  ButtonsPanel.Align := alBottom;
  ButtonsPanel.Height := 50;
  ButtonsPanel.Layout := 'hbox';
  ButtonsPanel.LayoutAttribs.Pack := 'end';
  ButtonsPanel.LayoutAttribs.Align := 'middle';
  ButtonsPanel.LayoutConfig.Padding := '10';

  OkButton.ModalResult := mrOk;
  CancelButton.ModalResult := mrCancel;

  // Setup tab layouts
  SetupLinkTab;
end;

procedure TChannelEditForm.SetupLinkTab;
begin
  // Link tab layout
  LinkTab.Layout := 'vbox';
  LinkTab.LayoutConfig.Padding := '10';

  // Direction and type selection
  DirectionComboBox.Width := 200;
  TypeComboBox.Width := 300;

  // Type settings panel
  //TypeSettingsPanel.Align := alClient;
  //TypeSettingsPanel.Layout := 'fit';
  //TypeSettingsPanel.Margins.Top := 10;
end;

procedure TChannelEditForm.DirectionComboBoxChange(Sender: TObject);
var
  direction: TChannelDirection;
begin
  direction := TChannelDirection(DirectionComboBox.ItemIndex);

  // Update available types based on direction
  TypeComboBox.Items.Clear;
  for var setup in linkSetupMap do
    if (setup.Value.Direction = direction) and assigned(setup.Value.FrameClass) then
      TypeComboBox.Items.AddPair(setup.Value.Name, setup.Key);

  if TypeComboBox.Items.Count > 0 then
    TypeComboBox.ItemIndex := 0;
    
  TypeComboBoxChange(Sender);
end;

procedure TChannelEditForm.TypeComboBoxChange(Sender: TObject);
var
  TypeStr: string;
  setup: TLinkSetup;

begin
  if TypeComboBox.ItemIndex = -1 then
    exit;
  TypeStr := TypeComboBox.Items.ValueFromIndex[TypeComboBox.ItemIndex];
  if not linkSetupMap.TryGetValue(TypeStr, setup) then
  begin
    Log(llError, TypeStr + ' not found');
    exit;
  end;
  FCurrentSetup := setup;
  FreeAndNil(FLinkEditFrame);
  FLinkEditFrame := setup.FrameClass.Create(UniScrollBox1);
  FLinkEditFrame.Parent := UniScrollBox1;
  FLinkEditFrame.Align := alTop;
  Log(llInfo, TypeStr + ' setup created');
end;

procedure TChannelEditForm.LoadChannelData(const ChannelData: TJSONObject);
var
  QueueObj, LinkObj, SettingsObj: TJSONObject;

begin
  if not Assigned(ChannelData) then Exit;
  
  // Basic information
  ChannelNameEdit.Text := ChannelData.GetValue<string>('name', '');
  ChannelCaptionEdit.Text := ChannelData.GetValue<string>('caption', '');
  
  // Queue information
  QueueObj := ChannelData.GetValue<TJSONObject>('queue');
  if Assigned(QueueObj) then
  begin
    AllowPutCheckBox.Checked := QueueObj.GetValue<Boolean>('allow_put', True);
    DoublesCheckBox.Checked := QueueObj.GetValue<Boolean>('doubles', False);

    // Limits
    if QueueObj.GetValue('limits') is TJSONObject then
    begin
      MaxLimitEdit.Text := QueueObj.GetValue<TJSONObject>('limits').GetValue<Integer>('max', 1500).ToString;
      CriticalLimitEdit.Text := QueueObj.GetValue<TJSONObject>('limits').GetValue<Integer>('critical', 2000).ToString;
    end;
  end;

  // Link information
  LinkObj := ChannelData.GetValue<TJSONObject>('link');
  if LinkObj = nil then
    exit;

  // Set direction
  case IndexStr(LinkObj.GetValue<string>('dir', ''), ['download', 'upload', 'duplex']) of
    0: DirectionComboBox.ItemIndex := 0; // Incoming
    1: DirectionComboBox.ItemIndex := 1; // Outgoing
    2: DirectionComboBox.ItemIndex := 2; // Duplex
  end;

  DirectionComboBoxChange(nil);

  // Set type
  for var I := 0 to TypeComboBox.Items.Count - 1 do
    if TypeComboBox.Items.ValueFromIndex[I] = LinkObj.GetValue<string>('type', '') then
    begin
      TypeComboBox.ItemIndex := I;
      Break;
    end;

  TypeComboBoxChange(nil);

  // Load type-specific settings
  if FLinkEditFrame = nil then
    exit;
  var data := LinkObj.GetValue<TJSONObject>('data');
  if data = nil then
    exit;
  SettingsObj := data.GetValue<TJSONObject>('settings');
  if SettingsObj = nil then
    exit;
  ///  load data to link frame
  FLinkEditFrame.DataToFrame(SettingsObj);
end;


function TChannelEditForm.ValidateData: Boolean;
var
 I: Integer;
begin
  Result := False;

  // validate data on link edit frame
  if Assigned(FLinkEditFrame) then
    if not FLinkEditFrame.Validate() then
      exit;


  if Trim(ChannelNameEdit.Text) = '' then
  begin
    ShowMessage('Введите имя канала');
    Exit;
  end;
  
  if Trim(ChannelCaptionEdit.Text) = '' then
  begin
    ShowMessage('Введите название канала');
    Exit;
  end;
  
  // Validate numeric fields
  if not TryStrToInt(MaxLimitEdit.Text, I) then
  begin
    ShowMessage('Максимальное значение должно быть числом');
    Exit;
  end;

  if not TryStrToInt(CriticalLimitEdit.Text, I) then
  begin
    ShowMessage('Критическое значение должно быть числом');
    Exit;
  end;

  Result := True;
end;

function TChannelEditForm.GenerateJSONData: string;
var
  JSONObj, QueueObj, LinkObj, DataObj, SettingsObj: TJSONObject;
  LimitsObj: TJSONObject;

begin
  JSONObj := TJSONObject.Create;
  try
    if FIsEditMode then
    begin
      // For updates
      JSONObj.AddPair('caption', ChannelCaptionEdit.Text);
      JSONObj.AddPair('name', ChannelNameEdit.Text);
    end
    else
    begin
      // For creation
      JSONObj.AddPair('compid', '85697f9f-b80d-4668-8ed2-2f70ed825eee');
      JSONObj.AddPair('depid', '4cf0dbf0-820b-4e05-a819-d6d1ec5652f0');
      JSONObj.AddPair('name', ChannelNameEdit.Text);
      JSONObj.AddPair('caption', ChannelCaptionEdit.Text);
    end;

    // Queue information
    QueueObj := TJSONObject.Create;
    QueueObj.AddPair('allow_put', TJSONBool.Create(AllowPutCheckBox.Checked));
    QueueObj.AddPair('doubles', TJSONBool.Create(DoublesCheckBox.Checked));

    LimitsObj := TJSONObject.Create;
    LimitsObj.AddPair('max', TJSONNumber.Create(StrToInt(MaxLimitEdit.Text)));
    LimitsObj.AddPair('critical', TJSONNumber.Create(StrToInt(CriticalLimitEdit.Text)));
    QueueObj.AddPair('limits', LimitsObj);

    QueueObj.AddPair('caption', ChannelCaptionEdit.Text); // Same caption as in the root
    QueueObj.AddPair('filters', TJSONArray.Create);

    QueueObj.AddPair('compid', '85697f9f-b80d-4668-8ed2-2f70ed825eee');
    QueueObj.AddPair('depid', '4cf0dbf0-820b-4e05-a819-d6d1ec5652f0');
    QueueObj.AddPair('uid', 'd4867249-7e90-11ec-9c1d-02420a000672');

    JSONObj.AddPair('queue', QueueObj);

    // Link information
    LinkObj := TJSONObject.Create;
    LinkObj.AddPair('name', ChannelNameEdit.Text);


    // Set direction
    case FCurrentSetup.Direction of
      cdDownload: LinkObj.AddPair('dir', 'download');
      cdUpload: LinkObj.AddPair('dir', 'upload');
      cdDuplex: LinkObj.AddPair('dir', 'duplex');
    end;


    LinkObj.AddPair('type', TypeComboBox.Items.ValueFromIndex[TypeComboBox.ItemIndex]);

    LinkObj.AddPair('compid', '85697f9f-b80d-4668-8ed2-2f70ed825eee');
    LinkObj.AddPair('depid', '4cf0dbf0-820b-4e05-a819-d6d1ec5652f0');

    // Link data and settings - corrected structure
    DataObj := TJSONObject.Create;
    SettingsObj := TJSONObject.Create;

    if Assigned(FLinkEditFrame) then
      FLinkEditFrame.DataFromFrame(SettingsObj);

    DataObj.AddPair('settings', SettingsObj);

    LinkObj.AddPair('data', DataObj);
    JSONObj.AddPair('link', LinkObj);

    Result := JSONObj.ToString;

  finally
    JSONObj.Free;
  end;
end;

function TChannelEditForm.SendCreateRequest(const JSONData: string): Boolean;
var
  Response: string;
  JSONValue, Meta: TJSONValue;
  Code: Integer;
//  RequestStream: TStringStream;
  RequestStream: string;

begin
  Result := False;
//  RequestStream := TStringStream.Create(JSONData, TEncoding.UTF8);
  try
    try
      Response := POST(API_BASE_ROUTER_URL + API_CHANNELS_URL + '/new', RequestStream);

      JSONValue := TJSONObject.ParseJSONValue(Response);
      if not Assigned(JSONValue) then
        exit;

      try
        Meta := (JSONValue as TJSONObject).GetValue('meta');
        if Assigned(Meta) then
        begin
          Code := (Meta as TJSONObject).GetValue<Integer>('code');
          Result := (Code = 0);
          if not Result then
            ShowMessage('Ошибка создания канала: код ' + IntToStr(Code));
        end;
      finally
        JSONValue.Free;
      end;
    except
      on E: Exception do
        ShowMessage('Ошибка при создании канала: ' + E.Message);
    end;
  finally
//    RequestStream.Free;
  end;
end;

function TChannelEditForm.SendUpdateRequest(const JSONData: string): Boolean;
var
  Response: string;
  JSONValue, Meta: TJSONValue;
  Code: Integer;
//  RequestStream: TStringStream;
  RequestStream: string;

begin
  Result := False;
//  RequestStream := TStringStream.Create(JSONData, TEncoding.UTF8);
  try
    try
      Response := POST(API_BASE_ROUTER_URL + API_CHANNELS_URL + '/' + ChannelID + '/update', RequestStream);

      JSONValue := TJSONObject.ParseJSONValue(Response);
      if not Assigned(JSONValue) then Exit;

      try
        Meta := (JSONValue as TJSONObject).GetValue('meta');
        if Assigned(Meta) then
        begin
          Code := (Meta as TJSONObject).GetValue<Integer>('code');
          Result := (Code = 0);
          if not Result then
            ShowMessage('Ошибка обновления канала: код ' + IntToStr(Code));
        end;
      finally
        JSONValue.Free;
      end;
    except
      on E: Exception do
        ShowMessage('Ошибка при обновлении канала: ' + E.Message);
    end;
  finally
//    RequestStream.Free;
  end;
end;

procedure TChannelEditForm.OkButtonClick(Sender: TObject);
var
  JSONData: string;
  Success: Boolean;
begin
  if not ValidateData then
    Exit;

  JSONData := GenerateJSONData;

  ShowMessage(JSONData); exit;    // TODO: test remove

  if FIsEditMode then
    Success := SendUpdateRequest(JSONData)
  else
    Success := SendCreateRequest(JSONData);

  if not Success then
    exit;

  ShowMessage('Канал успешно ' + IfThen(FIsEditMode, 'обновлен', 'создан'));
  ModalResult := mrOk;
end;



{ TLinkSetup }

constructor TLinkSetup.Create(AName, AStringType: string;
      AChannelType: TChannelType;
      ADirection: TChannelDirection;
      AService: TService;
      AFrameClass:  TFrameClass);
begin
  Name := AName;
  StringType := AStringType;
  ChannelType := AChannelType;
  Direction := ADirection;
  FrameClass := AFrameClass;
  Service := AService;
end;

procedure initLinkSetups();
begin
  linkSetupMap.Add('DIR_DOWN', TLinkSetup.Create(
    'Импорт из каталога',
    'DIR_DOWN',
    ctDirDown,
    cdDownload,
    svDatacomm,
    nil
  ));

  linkSetupMap.Add('DIR_UP', TLinkSetup.Create(
    'Экспорт в каталог',
    'DIR_UP',
    ctDirUp,
    cdUpload,
    svDatacomm,
    nil
  ));

  linkSetupMap.Add('FTP_CLIENT_DOWN', TLinkSetup.Create(
    'FTP клиент импорт',
    'FTP_CLIENT_DOWN',
    ctFTPClientDown,
    cdDownload,
    svDatacomm,
    nil
  ));

  linkSetupMap.Add('FTP_CLIENT_UP', TLinkSetup.Create(
    'FTP клиент экспорт',
    'FTP_CLIENT_UP',
    ctFTPClientUp,
    cdUpload,
    svDatacomm,
    nil
  ));

  linkSetupMap.Add('FTP_SERVER_DOWN', TLinkSetup.Create(
    'FTP сервер импорт',
    'FTP_SERVER_DOWN',
    ctFTPServerDown,
    cdDownload,
    svDatacomm,
    TFTPSRVDownFrame
  ));

  linkSetupMap.Add('FTP_SERVER_UP', TLinkSetup.Create(
    'FTP сервер экспорт',
    'FTP_SERVER_UP',
    ctFTPServerUp,
    cdUpload,
    svDatacomm,
    nil
  ));

  linkSetupMap.Add('OPENMCEP', TLinkSetup.Create(
    'OPENMCEP',
    'OPENMCEP',
    ctOpenMCEP,
    cdDuplex,
    svDatacomm,
    nil
  ));

  linkSetupMap.Add('POP3_CLI_DOWN', TLinkSetup.Create(
    'POP3 клиент',
    'POP3_CLI_DOWN',
    ctPOP3Client,
    cdDownload,
    svDatacomm,
    nil
  ));

  linkSetupMap.Add('SMTP_CLI_UP', TLinkSetup.Create(
    'SMTP клиент',
    'SMTP_CLI_UP',
    ctSMTPClient,
    cdUpload,
    svDatacomm,
    nil
  ));

  linkSetupMap.Add('SMTP_SRV_DOWN', TLinkSetup.Create(
    'SMTP сервер',
    'SMTP_SRV_DOWN',
    ctSMTPServer,
    cdDownload,
    svDatacomm,
    nil
  ));

  linkSetupMap.Add('SOCKET_SPECIAL', TLinkSetup.Create(
    'SOCKET SPECIAL',
    'SOCKET_SPECIAL',
    ctSocketSpecial,
    cdDuplex,
    svDatacomm,
    TSocketSpecialFrame
  ));

  linkSetupMap.Add('SEBA_SGS_CLIENT_DOWN', TLinkSetup.Create(
    'SEBA SGS клиент',
    'SEBA_SGS_CLIENT_DOWN',
    ctSebaSGS,
    cdDownload,
    svDrvComm,
    nil
  ));

  linkSetupMap.Add('SEBA_USR_CSD_CLIENT_DOWN', TLinkSetup.Create(
    'SEBA CSD клиент',
    'SEBA_USR_CSD_CLIENT_DOWN',
    ctSebaCSD,
    cdDownload,
    svDrvComm,
    nil
  ));

  linkSetupMap.Add('HTTP_CLIENT_DOWN', TLinkSetup.Create(
    'HTTP клиент',
    'HTTP_CLIENT_DOWN',
    ctHTTPClient,
    cdDownload,
    svDrvComm,
    nil
  ));

  linkSetupMap.Add('LINKOP-MSG-HOLDER', TLinkSetup.Create(
    'TBD (выдача)',
    'LINKOP-MSG-HOLDER',
    ctLinkopMsgHolder,
    cdUpload, // ?
    svDatacomm, // ?
    nil
  ));

  linkSetupMap.Add('DEST-CLIENT', TLinkSetup.Create(
    'TBD',
    'DEST-CLIENT',
    ctDestClient,
    cdUpload, // ?
    svDatacomm, // ?
    nil
  ));
end;

initialization
  linkSetupMap := TDictionary<string, TLinkSetup>.Create;
  initLinkSetups();

finalization
  linkSetupMap.Free;
end.