unit SourceEditFormUnit;

interface

uses
  SysUtils, Classes, System.Generics.Collections, UniGUIClasses, UniGUIForm, UniGUIBaseClasses, UniGUIAbstractClasses,
  UniGUIApplication, UniPanel, UniEdit, UniLabel, UniButton, UniComboBox, UniScrollBox,
  UniGroupBox, UniMemo, UniSplitter, UniDBGrid, System.StrUtils, System.UITypes, uniBasicGrid,
  uniGUITypes, uniMultiItem, Vcl.Controls, Vcl.Forms,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  SourceUnit, OrganizationUnit, ContextTypeUnit, SourceCredsUnit,
  LocationUnit, ContextsRestBrokerUnit, ContextUnit, SourceCredsRestBrokerUnit,
  LinkUnit, FuncUnit, IntefraceEditFormUnit;

type
  TSourceEditForm = class(TUniForm)
    pnlMain: TUniPanel;
    pnlBottom: TUniPanel;
    btnClose: TUniButton;
    splMain: TUniSplitter;
    pnlLeft: TUniScrollBox;
    pnlRight: TUniPanel;
    gbIdentification: TUniGroupBox;
    lblName: TUniLabel;
    edtName: TUniEdit;
    lblSid: TUniLabel;
    edtSid: TUniEdit;
    lblPid: TUniLabel;
    edtPid: TUniEdit;
    btnSelectPid: TUniButton;
    lblIndex: TUniLabel;
    edtIndex: TUniEdit;
    lblNumber: TUniLabel;
    edtNumber: TUniEdit;
    lblOrgType: TUniLabel;
    cbOrgType: TUniComboBox;
    gbOwner: TUniGroupBox;
    lblUgms: TUniLabel;
    cbUgms: TUniComboBox;
    lblCgms: TUniLabel;
    cbCgms: TUniComboBox;
    gbTerritory: TUniGroupBox;
    lblCountry: TUniLabel;
    cbCountry: TUniComboBox;
    lblRegion: TUniLabel;
    cbRegion: TUniComboBox;
    lblLat: TUniLabel;
    edtLat: TUniEdit;
    lblLon: TUniLabel;
    edtLon: TUniEdit;
    lblElev: TUniLabel;
    edtElev: TUniEdit;
    lblTimeShift: TUniLabel;
    edtTimeShift: TUniEdit;
    lblMeteoRange: TUniLabel;
    edtMeteoRange: TUniEdit;
    gbContacts: TUniGroupBox;
    lblOrg: TUniLabel;
    edtOrg: TUniEdit;
    lblDirector: TUniLabel;
    edtDirector: TUniEdit;
    lblPhone: TUniLabel;
    edtPhone: TUniEdit;
    lblEmail: TUniLabel;
    edtEmail: TUniEdit;
    lblMail: TUniLabel;
    memMail: TUniMemo;
    gbContexts: TUniGroupBox;
    grdContexts: TUniDBGrid;
    gbInterfaces: TUniGroupBox;
    grdInterfaces: TUniDBGrid;
    ContextMem: TFDMemTable;
    ContextMemsid: TStringField;
    ContextMemname: TStringField;
    ContextMemctxtid: TStringField;
    ContextMemctxid: TStringField;
    SourcesContextDS: TDataSource;
    ContextCredsDS: TDataSource;
    ContextCredsMem: TFDMemTable;
    CredMemName: TStringField;
    CredMemIntf: TStringField;
    CredMemLogin: TStringField;
    CredMemDef: TStringField;
    unpnlCredsButtons: TUniPanel;
    unbtnAddCred: TUniButton;
    unbtnDeleteCred: TUniButton;
    UniPanel1: TUniPanel;
    unbtnAddContext: TUniButton;
    unbtnDelContext: TUniButton;
    btnSave: TUniButton;
    ContextCredsMemlid: TStringField;
    unbtnContextRefresh: TUniButton;
    unbtnCredsRefresh: TUniButton;
    CredsMemCrID: TStringField;
    unbtnEditCred: TUniButton;

    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure cbUgmsChange(Sender: TObject);
    procedure cbCgmsChange(Sender: TObject);
    procedure cbCountryChange(Sender: TObject);
    procedure cbRegionChange(Sender: TObject);
    procedure cbOrgTypeChange(Sender: TObject);
    procedure edtIndexChange(Sender: TObject);
    procedure edtNumberChange(Sender: TObject);
    procedure grdContextsSelectionChange(Sender: TObject);
    procedure unbtnDelContextClick(Sender: TObject);
    procedure unbtnContextRefreshClick(Sender: TObject);
    procedure unbtnCredsRefreshClick(Sender: TObject);
    procedure unbtnDeleteCredClick(Sender: TObject);
    procedure unbtnAddContextClick(Sender: TObject);
    procedure unbtnAddCredClick(Sender: TObject);
    procedure grdInterfacesDblClick(Sender: TObject);
   protected
    class var FLinks: TDictionary<string, TLink>;
    FIsEditMode: Boolean;
    FSource: TSource;
    FOrganizations: TObjectList<TOrganization>;
    FLocations: TObjectList<TLocation>;
    FOrgTypes: TObjectList<TOrgType>;
    FContextTypes: TObjectList<TContextType>;
    FSelectedOrgTypeId:integer;
    FSelectedCountryId: string;
    FSelectedRegionId: string;
    FSelectedOwnerOrgId: Integer;

    FContextBroker: TContextsRestBroker;
    FCredBroker: TSourceCredsRestBroker;

    procedure SetContextDS(contexts: TContextList);
    procedure DelContext;
    procedure DelCred;
    procedure CreateContext(ACtx: TContext);
    procedure CreateCredential(ACred: TSourceCred);
    procedure UpdateCredential(ACred: TSourceCred);
    procedure EditCredential(const ACredId: string);
    function BuildLinkList: TLinkList;
    procedure UpdateUI;
    procedure LoadData;
    procedure ApplyToSource;
    procedure RefreshContexts;
    procedure RefreshCreds;
    procedure CreateSource;
    procedure UpdateSource;
    procedure PopulateOrganizationCombos;
    procedure PopulateOrganizationTypeCombos;
    procedure PopulateLocationCombos;
    procedure UpdateCgmsCombo(AParentOrgId, ASelectedOrgId: Integer);
    procedure UpdateRegionCombo(const ASelectedRegionId: string);
    procedure ApplyOrganizationSelection;
    procedure ApplyLocationSelection;
    procedure ApplyOrgTypeSelection;
    procedure UpdateSourceCountry(const ACountryId: string);
    procedure UpdateSourceRegion(const ARegionId: string);
    procedure UpdateSourceOwnerOrg(const AOwnerOrgId: Integer);
    procedure UpdateSourcePid(const APid: string);
    procedure UpdateSourceName(const AName: string);
    procedure UpdateSourceIndex(const AIndex: string);
    procedure UpdateSourceSrcType(const ATypeId: Integer);
    procedure UpdateSourceContactOrg(const AOrg: string);
    procedure UpdateSourceContactDirector(const ADirector: string);
    procedure UpdateSourceContactPhone(const APhone: string);
    procedure UpdateSourceContactEmail(const AEmail: string);
    procedure UpdateSourceContactMail(const AMail: string);
    function GetSelectedOrganization(ACombo: TUniComboBox): TOrganization;
    function GetSelectedOrgType: TOrgType;
    function FindOrganizationById(AOrgId: Integer): TOrganization;
    function FindOrgTypeById(Id: Integer): TOrgType;
    function FindContextTypeById(Id: string): TContextType;
    procedure SelectOrgTypeInCombo(AOrgTypeId: Integer);
    procedure SelectOrganizationInCombo(ACombo: TUniComboBox; AOrgId: Integer);
    procedure SelectLocationInCombo(ACombo: TUniComboBox; const ALocId: string);
    function GetSelectedCountry: TLocation;
    function GetParentOrgId(const Org: TOrganization): Integer;
    function FindLocationById(const ALocId: string): TLocation;
    function PadSidSegment(const AValue: string; ALength: Integer): string;
    function BuildSidPrefix: string;
    function BuildAutoSid: string;
    procedure UpdateSidFromInputs;
  public
    procedure AfterConstruction; override;
    destructor Destroy; override;
  end;

function SourceEditForm(isEdit:boolean;source:TSource): TSourceEditForm;

implementation

{$R *.dfm}

uses
  IdHTTP, MainModule, SourcesRestBrokerUnit, OrganizationsRestBrokerUnit,
  OrganizationHttpRequests, LocationsRestBrokerUnit, LocationHttpRequests,
  ContextsHttpRequests, LinksRestBrokerUnit, APIConst,
  HttpClientUnit, LoggingUnit, BaseResponses,
  LinksHttpRequests, ContextCreateFormUnit, SourceHttpRequests;

function SourceEditForm(isEdit:boolean;source:TSource): TSourceEditForm;
begin
  Result := TSourceEditForm(UniMainModule.GetFormInstance(TSourceEditForm));
  with Result do begin
    FIsEditMode:= isEdit;
    pnlRight.Enabled:= isEdit;

    FSource:= source;
    UpdateUI;
    LoadData;
  end;
end;

{ TSourceEditForm }

procedure TSourceEditForm.AfterConstruction;
begin
  inherited;
  FSelectedCountryId := 'RU';
  FSelectedRegionId := '';
  FSelectedOwnerOrgId := 0;
  if not Assigned(FLinks) then
     FLinks:= TDictionary<String,TLink>.Create;
  FCredBroker:= TSourceCredsRestBroker.Create(UniMainModule.XTicket);
  FContextBroker:= TContextsRestBroker.Create(UniMainModule.XTicket);
  FOrganizations := TObjectList<TOrganization>.Create(false);
  FLocations := TObjectList<TLocation>.Create(false);
  FOrgTypes:=  TObjectList<TOrgType>.Create(false);
  FContextTypes:= TObjectList<TContextType>.Create(false);
end;

procedure TSourceEditForm.DelContext;
var
 resp :TJSONResponse;
begin
  var ctxid:= ContextMem.FieldByName('ctxid').AsString;
  if ctxid = '' then exit;
  var req := FContextBroker.CreateReqRemove();
  try
    req.Id := ctxid;
    try
      resp:= FContextBroker.Remove(req);
      RefreshContexts;
    except
      on E: EIdHTTPProtocolException do begin
        var msg := Format('Ошибка удаления контекста. HTTP %d'#13#10'%s', [E.ErrorCode, E.ErrorMessage]);
        Log(msg, lrtError);
        MessageDlg(msg, TMsgDlgType.mtWarning, [mbOK], nil);
      end;

      on E: Exception do begin
        var msg := Format('Ошибка удаления контекста. %s', [e.Message]);
        Log(msg, lrtError);
        MessageDlg(msg, TMsgDlgType.mtWarning, [mbOK], nil);
      end;
    end;
  finally
    resp.free;
    req.free;
  end;
end;

procedure TSourceEditForm.DelCred;
var
 resp :TJSONResponse;
begin
  var crid:= ContextCredsMem.FieldByName('crid').AsString;
  if crid = '' then exit;
  var req := FContextBroker.CreateReqCredRemove(crid);
  try
    try
      resp:= FContextBroker.RemoveCredential(req);
      RefreshCreds;
    except
      on E: EIdHTTPProtocolException do begin
        var msg := Format('Ошибка удаления: HTTP %d'#13#10'%s', [E.ErrorCode, E.ErrorMessage]);
        Log(msg, lrtError);
        MessageDlg(msg, TMsgDlgType.mtWarning, [mbOK], nil);
      end;

      on E: Exception do begin
        var msg := Format('Ошибка удаления: %s', [e.Message]);
        Log(msg, lrtError);
        MessageDlg(msg, TMsgDlgType.mtWarning, [mbOK], nil);
      end;
    end;
  finally
    resp.free;
    req.free;
  end;
end;

procedure TSourceEditForm.CreateContext(ACtx:TContext);
var
  Req: TContextReqNew;
  Resp: TIdNewResponse;
begin
  if not FIsEditMode then
  begin
    MessageDlg('Сохраните источник перед добавлением контекста.', mtWarning, [mbOK], nil);
    Exit;
  end;
  ACtx.Sid := FSource.Sid;
  Req := FContextBroker.CreateReqNew() as TContextReqNew;
  Resp := nil;
  try
    Req.ApplyBody(ACtx);
    try
      Resp := FContextBroker.New(Req);
      if Assigned(Resp) and (Resp.StatusCode in [200, 201]) then
      begin
        RefreshContexts;
        MessageDlg('Контекст успешно создан.', mtInformation, [mbOK], nil);
      end
      else if Assigned(Resp) then
        MessageDlg(Format('Не удалось создать контекст. HTTP %d'#13#10'%s',
          [Resp.StatusCode, Resp.Response]), mtWarning, [mbOK], nil);
    except
      on E: EIdHTTPProtocolException do
        MessageDlg(Format('Ошибка создания контекста. HTTP %d'#13#10'%s',
          [E.ErrorCode, E.ErrorMessage]), mtWarning, [mbOK], nil);
      on E: Exception do
        MessageDlg(Format('Ошибка создания контекста. %s',
          [E.Message]), mtWarning, [mbOK], nil);
    end;
  finally
    Resp.Free;
    Req.Free;
  end;
end;

procedure TSourceEditForm.unbtnAddContextClick(Sender: TObject);
var
  ContextForm: TContextCreateForm;
begin
  if (not Assigned(FContextTypes)) or (FContextTypes.Count = 0) then
  begin
    MessageDlg('Типы контекстов не загружены.', mtWarning, [mbOK], nil);
    Exit;
  end;

  ContextForm := TContextCreateForm.Create(UniApplication);
  try
    ContextForm.SetContextTypes(FContextTypes);
    ContextForm.OpenWithIndex(FSource.Index.ValueOrDefault(''));
    ContextForm.OnSave :=
      procedure(const AResult: TContext)
      begin
        CreateContext(AResult);
      end;
    ContextForm.ShowModal;
  except
    ContextForm.Free;
    raise;
  end;
end;


function TSourceEditForm.BuildLinkList: TLinkList;
begin
  Result := TLinkList.Create(False);
  if Assigned(FLinks) then
    for var Pair in FLinks do
      Result.Add(Pair.Value);
end;

procedure TSourceEditForm.CreateCredential(ACred: TSourceCred);
var
  Req: TContextCredReqNew;
  Resp: TJSONResponse;
begin
  if not Assigned(ACred) then Exit;
  Req:= nil; Resp:=nil;
  try
    Req := FContextBroker.CreateReqCredNew() as TContextCredReqNew;
    Req.ApplyBody(ACred);
    try
      Resp := FContextBroker.NewCredential(Req);
      if Assigned(Resp) and (Resp.StatusCode in [200, 201]) then
      begin
        RefreshCreds;
        MessageDlg('Интерфейс создан.', mtInformation, [mbOK], nil);
      end
      else if Assigned(Resp) then
        MessageDlg(Format('Не удалось создать интерфейс. HTTP %d'#13#10'%s',
          [Resp.StatusCode, Resp.Response]), mtWarning, [mbOK], nil);
    except
      on E: EIdHTTPProtocolException do
        MessageDlg(Format('Ошибка создания интерфейса. HTTP %d'#13#10'%s',
          [E.ErrorCode, E.ErrorMessage]), mtWarning, [mbOK], nil);
      on E: Exception do
        MessageDlg('Ошибка создания интерфейса: ' + E.Message, mtWarning, [mbOK], nil);
    end;
  finally
    ACred.Free;
    Resp.Free;
    Req.Free;
  end;
end;

procedure TSourceEditForm.UpdateCredential(ACred: TSourceCred);
var
  Req: TContextCredReqUpdate;
  Resp: TJSONResponse;
begin
  if not Assigned(ACred) then Exit;
  Req:= nil; Resp:=nil;
  try
    Req := FContextBroker.CreateReqCredUpdate(ACred.Crid) as TContextCredReqUpdate;
    Req.ReqBody.Assign(ACred);
    try
      Resp := FContextBroker.UpdateCredential(Req);
      if Assigned(Resp) and (Resp.StatusCode in [200, 204]) then
      begin
        RefreshCreds;
        MessageDlg('Интерфейс обновлен.', mtInformation, [mbOK], nil);
      end
      else if Assigned(Resp) then
        MessageDlg(Format('Не удалось обновить интерфейс. HTTP %d'#13#10'%s',
          [Resp.StatusCode, Resp.Response]), mtWarning, [mbOK], nil);
    except
      on E: EIdHTTPProtocolException do
        MessageDlg(Format('Ошибка обновления интерфейса. HTTP %d'#13#10'%s',
          [E.ErrorCode, E.ErrorMessage]), mtWarning, [mbOK], nil);
      on E: Exception do
        MessageDlg('Ошибка обновления интерфейса: ' + E.Message, mtWarning, [mbOK], nil);
    end;
  finally
    Resp.Free;
    Req.Free;
  end;
end;

procedure TSourceEditForm.EditCredential(const ACredId: string);
var
  Req: TContextCredReqInfo;
  Resp: TContextCredInfoResponse;
  CredCopy: TSourceCred;
  LinkList: TLinkList;
  Form: TInterfaceModalForm;
begin
  if ACredId.Trim.IsEmpty then
    Exit;

  Req := FContextBroker.CreateReqCredInfo(ACredId);
  Resp := nil;
  CredCopy := nil;
  try
    try
      Resp := FContextBroker.CredentialInfo(Req);
    except
      on E: EIdHTTPProtocolException do
      begin
        MessageDlg(Format('Ошибка получения интерфейса. HTTP %d'#13#10'%s',
          [E.ErrorCode, E.ErrorMessage]), mtWarning, [mbOK], nil);
        Exit;
      end;
      on E: Exception do
      begin
        MessageDlg('Ошибка получения интерфейса: ' + E.Message, mtWarning, [mbOK], nil);
        Exit;
      end;
    end;

    if not Assigned(Resp) or not Assigned(Resp.Credential) then
    begin
      MessageDlg('Не удалось получить данные интерфейса.', mtWarning, [mbOK], nil);
      Exit;
    end;

    CredCopy := TSourceCred.Create;
    CredCopy.Assign(Resp.Credential);
  finally
    Resp.Free;
    Req.Free;
  end;

  LinkList := BuildLinkList;
  try
    Form := TInterfaceModalForm.Create(UniApplication);
    try
      Form.LoadForEdit(CredCopy, LinkList);
      Form.OnUpdate :=
        procedure(const AResult: TSourceCred)
        begin
          UpdateCredential(CredCopy);
          CredCopy.Free;
          CredCopy := nil;
        end;
      Form.ShowModal;
    except
      Form.Free;
      raise;
    end;
  finally
    LinkList.Free;
  end;
end;

procedure TSourceEditForm.unbtnAddCredClick(Sender: TObject);
var
  ContextId: string;
  NewCred: TSourceCred;
  LinkList: TLinkList;
  Form: TInterfaceModalForm;
begin
  if (not ContextMem.Active) or ContextMem.IsEmpty then
  begin
    MessageDlg('Выберите контекст перед добавлением интерфейса.', mtWarning, [mbOK], nil);
    Exit;
  end;

  ContextId := ContextMem.FieldByName('ctxid').AsString;
  if ContextId.Trim.IsEmpty then
  begin
    MessageDlg('Контекст не выбран.', mtWarning, [mbOK], nil);
    Exit;
  end;

  if (not Assigned(FLinks)) or (FLinks.Count = 0) then
  begin
    MessageDlg('Список интерфейсов пуст. Обновите данные.', mtWarning, [mbOK], nil);
    Exit;
  end;

  LinkList := BuildLinkList;
  NewCred:= TSourceCred.Create;
  NewCred.CtxId := ContextId;
  try
    Form := TInterfaceModalForm.Create(UniApplication);
    try
      Form.LoadForCreate(NewCred, LinkList);
      Form.OnCreate :=
        procedure(const AResult: TSourceCred)
        begin
          CreateCredential(AResult);
        end;
      Form.ShowModal;
    except
      Form.Free;
      raise;
    end;
  finally
    LinkList.Free;
  end;
end;

procedure TSourceEditForm.grdInterfacesDblClick(Sender: TObject);
var
  CredId: string;
begin
  if (not ContextCredsMem.Active) or ContextCredsMem.IsEmpty then
    Exit;

  CredId := ContextCredsMem.FieldByName('crid').AsString;
  if CredId.Trim.IsEmpty then
    Exit;

  EditCredential(CredId);
end;

destructor TSourceEditForm.Destroy;
begin
  FCredBroker.Free;
  FContextBroker.Free;
  FOrganizations.Free;
  FLocations.Free;
  FOrgTypes.Free;
  FContextTypes.Free;
  inherited;
end;

procedure TSourceEditForm.UpdateUI;
begin
  Caption := IfThen(FIsEditMode, 'Редактирование источника', 'Создать источник');
  btnSave.Caption := IfThen(FIsEditMode, 'Сохранить', 'Создать');
  edtSid.Enabled := True;
  edtSid.ReadOnly := True;
  edtIndex.Enabled := not FIsEditMode;
  edtNumber.Enabled := not FIsEditMode;

  if Assigned(FSource) then
  begin
    edtSid.Text := FSource.Sid;
    edtName.Text := FSource.Name.ValueOrDefault('');
    edtPid.Text := FSource.Pid.ValueOrDefault('');
    edtIndex.Text := FSource.Index.ValueOrDefault('');
    edtNumber.Text := IntToStr(FSource.Number);
    if FSource.Lat.HasValue then
      edtLat.Text := FloatToStr(FSource.Lat.Value)
    else
      edtLat.Text := '';
    if FSource.Lon.HasValue then
      edtLon.Text := FloatToStr(FSource.Lon.Value)
    else
      edtLon.Text := '';
    if FSource.Elev.HasValue then
      edtElev.Text := IntToStr(FSource.Elev.Value)
    else
      edtElev.Text := '';
    edtTimeShift.Text := IntToStr(FSource.TimeShift);
    edtMeteoRange.Text := IntToStr(FSource.MeteoRange);
    edtOrg.Text := FSource.ContactOrg.ValueOrDefault('');
    edtDirector.Text := FSource.ContactDirector.ValueOrDefault('');
    edtPhone.Text := FSource.ContactPhone.ValueOrDefault('');
    edtEmail.Text := FSource.ContactEmail.ValueOrDefault('');
    memMail.Lines.Text := FSource.ContactMailAddr.ValueOrDefault('');
  end
  else
  begin
    edtSid.Text := '';
    edtName.Text := '';
    edtPid.Text := '';
    edtIndex.Text := '';
    edtNumber.Text := '';
    edtLat.Text := '';
    edtLon.Text := '';
    edtElev.Text := '';
    edtTimeShift.Text := '';
    edtMeteoRange.Text := '';
    edtOrg.Text := '';
    edtDirector.Text := '';
    edtPhone.Text := '';
    edtEmail.Text := '';
    memMail.Lines.Text := '';
  end;

  if FIsEditMode and Assigned(FSource) then
  begin
    FSelectedCountryId := FSource.Country.ValueOrDefault('');
    FSelectedRegionId := FSource.Region.ValueOrDefault('');
    FSelectedOwnerOrgId := FSource.OwnerOrg.ValueOrDefault(0);
    FSelectedOrgTypeId := FSource.SrcTypeID.ValueOrDefault(-1);
    ApplyOrgTypeSelection;
  end
  else
  begin
    FSelectedCountryId := 'RU';
    FSelectedRegionId := '';
    FSelectedOwnerOrgId := 0;
    if Assigned(FSource) then
    begin
      UpdateSourceCountry(FSelectedCountryId);
      UpdateSourceRegion(FSelectedRegionId);
      UpdateSourceOwnerOrg(FSelectedOwnerOrgId);
    end;
  end;

  UpdateSidFromInputs;
end;

procedure TSourceEditForm.LoadData;
var
  OrgBroker: TOrganizationsRestBroker;
  OrgReq: TOrganizationReqList;
  OrgResp: TOrganizationListResponse;
  OrgTypeReq: TOrganizationTypesReqList;
  OrgTypeResp: TOrgTypeListResponse;
  CtxTypeReq: TContextTypesReqList;
  CtxTypeResp: TContextTypeListResponse;
  LinkReq: TLinkReqList;
  LinkResp: TLinkListResponse;
  LocBroker: TLocationsRestBroker;
  LocReq: TLocationReqList;
  LocResp: TLocationListResponse;
  OrgIndex: Integer;
  LocIndex: Integer;
  MainModuleInst: TUniMainModule;
  HasOrgCache: Boolean;
  HasLocCache: Boolean;
  HasContextTypesCache: Boolean;
  HasOrgTypeCache: Boolean;
  HasContextTypeCache:Boolean;
begin
  MainModuleInst := UniMainModule;
  if not Assigned(MainModuleInst) then exit;
  cbCountry.Items.Clear;
  cbRegion.Items.Clear;
  cbUgms.Items.Clear;
  cbCgms.Items.Clear;

  if Assigned(FOrganizations) then
    FOrganizations.Clear;
  if Assigned(FLocations) then
    FLocations.Clear;

  MainModuleInst.AssignOrganizationsTo(FOrganizations);
  HasOrgCache := FOrganizations.Count > 0;
  MainModuleInst.AssignLocationsTo(FLocations);
  HasLocCache := FLocations.Count > 0;
  MainModuleInst.AssignOrganizationsTo(FOrganizations);
  HasOrgCache := FOrganizations.Count > 0;

  MainModuleInst.AssignContextTypesTo(FContextTypes);
  HasContextTypesCache := FContextTypes.Count > 0;


  if not HasOrgCache then
  begin

    OrgBroker := nil;
    OrgReq := nil;
    OrgResp := nil;
    try
      try
        OrgBroker := TOrganizationsRestBroker.Create(MainModuleInst.XTicket);
        OrgReq := OrgBroker.CreateReqList as TOrganizationReqList;
        OrgResp := OrgBroker.ListAll(OrgReq);
        if Assigned(OrgResp) and Assigned(OrgResp.OrganizationList) then
        begin
          OrgResp.OrganizationList.OwnsObjects:= false;
          for var org in OrgResp.OrganizationList do
            FOrganizations.Add(org as TOrganization);
        end;
      finally
        OrgResp.Free;
        OrgReq.Free;
        FreeAndNil(OrgBroker);
      end;
    except
      on E: EIdHTTPProtocolException do
        ShowMessage(Format('Ошибка загрузки огранизаций: %d %s', [E.ErrorCode, E.ErrorMessage]));
      on E: Exception do
        ShowMessage('Ошибка загрузки огранизаций: ' + E.Message);
    end;
    MainModuleInst.UpdateOrganizationsCache(FOrganizations);
  end;

  if not HasLocCache then
  begin
    LocBroker := nil;
    LocReq := nil;
    LocResp := nil;
    try
      try
        LocBroker := TLocationsRestBroker.Create(MainModuleInst.XTicket);
        LocReq := LocBroker.CreateReqList as TLocationReqList;
        LocResp := LocBroker.ListAll(LocReq);
        if Assigned(LocResp) and Assigned(LocResp.LocationList) then
        begin
          LocResp.LocationList.OwnsObjects:= false;
          for var loc in LocResp.LocationList do
            FLocations.Add(loc as TLocation);
        end;
      finally
        LocResp.Free;
        LocReq.Free;
        LocBroker.Free;
      end;
    except
      on E: EIdHTTPProtocolException do
        ShowMessage(Format('Ошибка загрузки локаций: %d %s', [E.ErrorCode, E.ErrorMessage]));
      on E: Exception do
        ShowMessage('Ошибка загрузки локаций: ' + E.Message);
    end;
    MainModuleInst.UpdateLocationsCache(FLocations);
  end;

  if not HasOrgTypeCache then
  begin
    OrgTypeReq := nil; OrgTypeResp := nil; OrgBroker := nil;
    try
      try
        OrgBroker := TOrganizationsRestBroker.Create(MainModuleInst.XTicket);
        OrgTypeReq := OrgBroker.CreateOrgTypesReqList;
        OrgTypeResp := OrgBroker.ListTypesAll(OrgTypeReq);
        if Assigned(OrgTypeResp) and Assigned(OrgTypeResp.OrgTypeList) then
        begin
          OrgTypeResp.OrgTypeList.OwnsObjects:= false;
          for var org in OrgTypeResp.OrgTypeList do
            FOrgTypes.Add(org as TOrgType);
        end;
      finally
        OrgTypeResp.Free;
        OrgReq.Free;
        OrgBroker.Free;
      end;
    except
      on E: EIdHTTPProtocolException do
        ShowMessage(Format('Ошибка загрузки огранизаций: %d %s', [E.ErrorCode, E.ErrorMessage]));
      on E: Exception do
        ShowMessage('Ошибка загрузки огранизаций: ' + E.Message);
    end;
    MainModuleInst.UpdateOrgTypesCache(FOrgTypes);
  end;

  if not HasContextTypeCache then
  begin
    CtxTypeReq := nil;
    CtxTypeResp := nil;
    try
      try
        CtxTypeReq := FContextBroker.CreateReqContextTypes;
        CtxTypeResp := FContextBroker.ListTypes(CtxTypeReq);
        if Assigned(CtxTypeResp) and Assigned(CtxTypeResp.ContextTypesList) then
        begin
          CtxTypeResp.ContextTypesList.OwnsObjects:= false;
          for var ctxType in CtxTypeResp.ContextTypesList do
            FContextTypes.Add(ctxType as TContextType);
        end;
      finally
        CtxTypeReq.Free;
        CtxTypeResp.Free;
      end;
    except
      on E: EIdHTTPProtocolException do
        ShowMessage(Format('Ошибка загрузки огранизаций: %d %s', [E.ErrorCode, E.ErrorMessage]));
      on E: Exception do
        ShowMessage('Ошибка загрузки огранизаций: ' + E.Message);
    end;
  end;

  if FLinks.Count = 0 then
  begin
    LinkReq := nil;
    LinkResp := nil;
    try
      var DrvLinkBroker:= TLinksRestBroker.Create(MainModuleInst.XTicket);
      DrvLinkBroker.BasePath:= APIConst.constURLDrvcommBasePath;

      try
        LinkReq := DrvLinkBroker.CreateReqList as TLinkReqList;
        LinkResp := DrvLinkBroker.List(LinkReq);
        if Assigned(LinkResp.LinkList) then
        begin
          LinkResp.LinkList.OwnsObjects:= false;
          for var link in LinkResp.LinkList do
            FLinks.Add(link.id, link as TLink);
        end;
      finally
        DrvLinkBroker.Free;
        LinkReq.Free;
        LinkResp.Free;
      end;
    except
      on E: EIdHTTPProtocolException do
        ShowMessage(Format('Ошибка загрузки огранизаций: %d %s', [E.ErrorCode, E.ErrorMessage]));
      on E: Exception do
        ShowMessage('Ошибка загрузки огранизаций: ' + E.Message);
    end;
  end;

  SetContextDS(FSource.Contexts);
  PopulateOrganizationCombos;
  PopulateLocationCombos;
  PopulateOrganizationTypeCombos;
end;

procedure TSourceEditForm.PopulateOrganizationCombos;
var
  Org: TOrganization;
  DisplayName: string;
begin
  cbUgms.Items.BeginUpdate;
  try
    cbUgms.Items.Clear;
    for Org in FOrganizations do
      if GetParentOrgId(Org) = 0 then
      begin
        if Org.ShortName.Trim <> '' then
          DisplayName := Org.ShortName.Trim
        else
          DisplayName := Org.Name;
        cbUgms.Items.AddObject(DisplayName, Org);
      end;
  finally
    cbUgms.Items.EndUpdate;
  end;

  ApplyOrganizationSelection;
end;

procedure TSourceEditForm.PopulateOrganizationTypeCombos;
var
  DisplayName: string;
begin
  cbOrgType.Items.BeginUpdate;
  try
    cbOrgType.Items.Clear;
    for var OrgType in FOrgTypes do
    begin
      if OrgType.ShortName.Trim <> '' then
        DisplayName := OrgType.ShortName.Trim
      else
        DisplayName := OrgType.Name;
      cbOrgType.Items.AddObject(DisplayName, OrgType);
    end;
  finally
    cbOrgType.Items.EndUpdate;
  end;

  ApplyOrgTypeSelection;
end;

procedure TSourceEditForm.PopulateLocationCombos;
var
  Loc: TLocation;
begin
  cbCountry.Items.BeginUpdate;
  try
    cbCountry.Items.Clear;
    for Loc in FLocations do
      if Loc.ParentLocId = '' then
        cbCountry.Items.AddObject(Loc.Name, Loc);
  finally
    cbCountry.Items.EndUpdate;
  end;

  ApplyLocationSelection;
end;

procedure TSourceEditForm.UpdateCgmsCombo(AParentOrgId, ASelectedOrgId: Integer);
var
  Org: TOrganization;
  DisplayName: string;
  SelectedIndex: Integer;
begin
  cbCgms.Items.BeginUpdate;
  try
    cbCgms.Items.Clear;
    SelectedIndex := -1;

    if AParentOrgId > 0 then
      for Org in FOrganizations do
        if GetParentOrgId(Org) = AParentOrgId then
        begin
          if Org.ShortName.Trim <> '' then
            DisplayName := Org.ShortName.Trim
          else
            DisplayName := Org.Name;
          cbCgms.Items.AddObject(DisplayName, Org);
          if (ASelectedOrgId <> 0) and (Org.OrgId = ASelectedOrgId) then
            SelectedIndex := cbCgms.Items.Count - 1;
        end;

    cbCgms.ItemIndex := SelectedIndex;
  finally
    cbCgms.Items.EndUpdate;
  end;
end;

procedure TSourceEditForm.UpdateRegionCombo(const ASelectedRegionId: string);
var
  Country: TLocation;
  Region: TLocation;
  SelectedIndex: Integer;
begin
  cbRegion.Items.BeginUpdate;
  try
    cbRegion.Items.Clear;
    Country := GetSelectedCountry;
    if not Assigned(Country) then
    begin
      cbRegion.ItemIndex := -1;
      Exit;
    end;

    SelectedIndex := -1;
    for Region in FLocations do
      if SameText(Region.ParentLocId, Country.LocId) then
      begin
        cbRegion.Items.AddObject(Region.Name, Region);
        if (ASelectedRegionId <> '') and SameText(Region.LocId, ASelectedRegionId) then
          SelectedIndex := cbRegion.Items.Count - 1;
      end;

    cbRegion.ItemIndex := SelectedIndex;
  finally
    cbRegion.Items.EndUpdate;
  end;

  if cbRegion.ItemIndex >= 0 then
    FSelectedRegionId := TLocation(cbRegion.Items.Objects[cbRegion.ItemIndex]).LocId
  else
    FSelectedRegionId := '';

  if Assigned(FSource) then
    UpdateSourceRegion(FSelectedRegionId);

  UpdateSidFromInputs;
end;

procedure TSourceEditForm.UpdateSource;
var
  Broker: TSourcesRestBroker;
  Req: TSourceReqUpdate;
  Resp: TJSONResponse;
  SourceId: string;
begin
  if not Assigned(FSource) then
    Exit;

  SourceId := Trim(FSource.Sid);
  if SourceId.IsEmpty then
  begin
    MessageDlg('SID источника не задан.', mtWarning, [mbOK], nil);
    Exit;
  end;

  Broker := nil;
  Req := nil;
  Resp := nil;
  try
    try
      Broker := TSourcesRestBroker.Create(UniMainModule.XTicket);
      Req := Broker.CreateReqUpdate as TSourceReqUpdate;
      if not Assigned(Req) then
      begin
        MessageDlg('Не удалось подготовить запрос на обновление источника.', mtWarning, [mbOK], nil);
        Exit;
      end;

      Req.SetSourceId(SourceId);
      if Assigned(Req.ReqBody) then
        TSource(Req.ReqBody).Assign(FSource);

      Resp := Broker.Update(Req);
      if Assigned(Resp) and (Resp.StatusCode in [200, 204]) then
      begin
        MessageDlg('Источник обновлен: ' + edtName.Text, mtInformation, [mbOK], nil);
        Close;
      end
      else if Assigned(Resp) then
        MessageDlg(Format('Не удалось обновить источник. HTTP %d'#13#10'%s',
          [Resp.StatusCode, Resp.Response]), mtWarning, [mbOK], nil)
      else
        MessageDlg('Не удалось обновить источник: пустой ответ сервера.', mtWarning, [mbOK], nil);
    except
      on E: EIdHTTPProtocolException do
        MessageDlg(Format('Ошибка обновления источника. HTTP %d'#13#10'%s',
          [E.ErrorCode, E.ErrorMessage]), mtWarning, [mbOK], nil);
      on E: Exception do
        MessageDlg('Ошибка обновления источника: ' + E.Message, mtWarning, [mbOK], nil);
    end;
  finally
    Resp.Free;
    Req.Free;
    Broker.Free;
  end;
end;

procedure TSourceEditForm.ApplyOrganizationSelection;
var
  Owner: TOrganization;
  Parent: TOrganization;
  ParentOrgId: Integer;
begin
  if cbUgms.Items.Count = 0 then
  begin
    cbUgms.ItemIndex := -1;
    UpdateCgmsCombo(0, 0);
    FSelectedOwnerOrgId := 0;
    if Assigned(FSource) then
      UpdateSourceOwnerOrg(0);
    Exit;
  end;

  Owner := FindOrganizationById(FSelectedOwnerOrgId);
  if not Assigned(Owner) then
  begin
    cbUgms.ItemIndex := -1;
    UpdateCgmsCombo(0, 0);
    FSelectedOwnerOrgId := 0;
    if Assigned(FSource) then
      UpdateSourceOwnerOrg(0);
    Exit;
  end;

  ParentOrgId := GetParentOrgId(Owner);
  if ParentOrgId > 0 then
  begin
    Parent := FindOrganizationById(ParentOrgId);
    if Assigned(Parent) then
    begin
      SelectOrganizationInCombo(cbUgms, Parent.OrgId);
      UpdateCgmsCombo(Parent.OrgId, Owner.OrgId);
      SelectOrganizationInCombo(cbCgms, Owner.OrgId);
      FSelectedOwnerOrgId := Owner.OrgId;
    end
    else
    begin
      SelectOrganizationInCombo(cbUgms, Owner.OrgId);
      UpdateCgmsCombo(Owner.OrgId, 0);
      cbCgms.ItemIndex := -1;
      FSelectedOwnerOrgId := Owner.OrgId;
    end;
  end
  else
  begin
    SelectOrganizationInCombo(cbUgms, Owner.OrgId);
    UpdateCgmsCombo(Owner.OrgId, 0);
    cbCgms.ItemIndex := -1;
    FSelectedOwnerOrgId := Owner.OrgId;
  end;

  if Assigned(FSource) then
    UpdateSourceOwnerOrg(FSelectedOwnerOrgId);
end;

procedure TSourceEditForm.ApplyOrgTypeSelection;
begin
  if FSelectedOrgTypeId <> -1 then
    SelectOrgTypeInCombo(FSelectedOrgTypeId)
  else
    cbOrgType.ItemIndex := -1;

  if Assigned(FSource) then
    UpdateSourceSrcType(FSelectedOrgTypeId);
end;

procedure TSourceEditForm.UpdateSourceCountry(const ACountryId: string);
var
  NullableValue: Nullable<string>;
begin
  if not Assigned(FSource) then
    Exit;

  NullableValue.Clear;
  if not ACountryId.IsEmpty then
    NullableValue := Nullable<string>.Create(ACountryId);
  FSource.Country := NullableValue;
end;

procedure TSourceEditForm.UpdateSourceRegion(const ARegionId: string);
var
  NullableValue: Nullable<string>;
begin
  if not Assigned(FSource) then
    Exit;

  NullableValue.Clear;
  if not ARegionId.IsEmpty then
    NullableValue := Nullable<string>.Create(ARegionId);
  FSource.Region := NullableValue;
end;

procedure TSourceEditForm.UpdateSourceOwnerOrg(const AOwnerOrgId: Integer);
var
  NullableValue: Nullable<Integer>;
begin
  if not Assigned(FSource) then
    Exit;

  NullableValue.Clear;
  if AOwnerOrgId > 0 then
    NullableValue := Nullable<Integer>.Create(AOwnerOrgId);
  FSource.OwnerOrg := NullableValue;
end;

procedure TSourceEditForm.UpdateSourcePid(const APid: string);
var
  NullableValue: Nullable<string>;
begin
  if not Assigned(FSource) then
    Exit;

  NullableValue.Clear;
  if not APid.IsEmpty then
    NullableValue := Nullable<string>.Create(APid);
  FSource.Pid := NullableValue;
end;

procedure TSourceEditForm.UpdateSourceName(const AName: string);
var
  NullableValue: Nullable<string>;
begin
  if not Assigned(FSource) then
    Exit;

  NullableValue.Clear;
  if not AName.IsEmpty then
    NullableValue := Nullable<string>.Create(AName);
  FSource.Name := NullableValue;
end;

procedure TSourceEditForm.UpdateSourceIndex(const AIndex: string);
var
  NullableValue: Nullable<string>;
begin
  if not Assigned(FSource) then
    Exit;

  NullableValue.Clear;
  if not AIndex.IsEmpty then
    NullableValue := Nullable<string>.Create(AIndex);
  FSource.Index := NullableValue;
end;

procedure TSourceEditForm.UpdateSourceSrcType(const ATypeId: Integer);
var
  NullableValue: Nullable<Integer>;
begin
  if not Assigned(FSource) then
    Exit;

  NullableValue.Clear;
  if ATypeId >= 0 then
    NullableValue := Nullable<Integer>.Create(ATypeId);
  FSource.SrcTypeID := NullableValue;
end;

procedure TSourceEditForm.UpdateSourceContactOrg(const AOrg: string);
var
  NullableValue: Nullable<string>;
begin
  if not Assigned(FSource) then
    Exit;

  NullableValue.Clear;
  if not AOrg.IsEmpty then
    NullableValue := Nullable<string>.Create(AOrg);
  FSource.ContactOrg := NullableValue;
end;

procedure TSourceEditForm.UpdateSourceContactDirector(const ADirector: string);
var
  NullableValue: Nullable<string>;
begin
  if not Assigned(FSource) then
    Exit;

  NullableValue.Clear;
  if not ADirector.IsEmpty then
    NullableValue := Nullable<string>.Create(ADirector);
  FSource.ContactDirector := NullableValue;
end;

procedure TSourceEditForm.UpdateSourceContactPhone(const APhone: string);
var
  NullableValue: Nullable<string>;
begin
  if not Assigned(FSource) then
    Exit;

  NullableValue.Clear;
  if not APhone.IsEmpty then
    NullableValue := Nullable<string>.Create(APhone);
  FSource.ContactPhone := NullableValue;
end;

procedure TSourceEditForm.UpdateSourceContactEmail(const AEmail: string);
var
  NullableValue: Nullable<string>;
begin
  if not Assigned(FSource) then
    Exit;

  NullableValue.Clear;
  if not AEmail.IsEmpty then
    NullableValue := Nullable<string>.Create(AEmail);
  FSource.ContactEmail := NullableValue;
end;

procedure TSourceEditForm.UpdateSourceContactMail(const AMail: string);
var
  NullableValue: Nullable<string>;
begin
  if not Assigned(FSource) then
    Exit;

  NullableValue.Clear;
  if not AMail.IsEmpty then
    NullableValue := Nullable<string>.Create(AMail);
  FSource.ContactMailAddr := NullableValue;
end;

procedure TSourceEditForm.ApplyToSource;
var
  LatValue, LonValue: Double;
  ElevValue: Integer;
  NullableLat, NullableLon: Nullable<Double>;
  NullableElev: Nullable<Integer>;
begin
  if Assigned(FSource) then
  begin
    FSource.Sid := edtSid.Text;
    UpdateSourceName(Trim(edtName.Text));
    UpdateSourcePid(Trim(edtPid.Text));
    UpdateSourceIndex(Trim(edtIndex.Text));
    FSource.Number := StrToIntDef(edtNumber.Text, 0);
    NullableLat.Clear;
    if TryStrToFloat(Trim(edtLat.Text), LatValue) then
      NullableLat := Nullable<Double>.Create(LatValue);
    FSource.Lat := NullableLat;

    NullableLon.Clear;
    if TryStrToFloat(Trim(edtLon.Text), LonValue) then
      NullableLon := Nullable<Double>.Create(LonValue);
    FSource.Lon := NullableLon;

    NullableElev.Clear;
    if TryStrToInt(Trim(edtElev.Text), ElevValue) then
      NullableElev := Nullable<Integer>.Create(ElevValue);
    FSource.Elev := NullableElev;
    FSource.TimeShift := StrToIntDef(edtTimeShift.Text, 0);
    FSource.MeteoRange := StrToIntDef(edtMeteoRange.Text, 0);
    UpdateSourceContactOrg(Trim(edtOrg.Text));
    UpdateSourceContactDirector(Trim(edtDirector.Text));
    UpdateSourceContactPhone(Trim(edtPhone.Text));
    UpdateSourceContactEmail(Trim(edtEmail.Text));
    UpdateSourceContactMail(Trim(memMail.Lines.Text));
  end
end;

procedure TSourceEditForm.ApplyLocationSelection;
var
  Country: TLocation;
begin
  if FSelectedCountryId <> '' then
    SelectLocationInCombo(cbCountry, FSelectedCountryId)
  else if cbCountry.Items.Count > 0 then
    cbCountry.ItemIndex := 0
  else
    cbCountry.ItemIndex := -1;

  Country := GetSelectedCountry;
  if Assigned(Country) then
    FSelectedCountryId := Country.LocId
  else
    FSelectedCountryId := '';

  UpdateRegionCombo(FSelectedRegionId);

  if Assigned(FSource) then
  begin
    UpdateSourceCountry(FSelectedCountryId);
    UpdateSourceRegion(FSelectedRegionId);
  end;

  UpdateSidFromInputs;
end;

function TSourceEditForm.GetSelectedOrganization(ACombo: TUniComboBox): TOrganization;
begin
  Result := nil;
  if not Assigned(ACombo) then
    Exit;

  if (ACombo.ItemIndex >= 0) and (ACombo.ItemIndex < ACombo.Items.Count) then
    Result := TOrganization(ACombo.Items.Objects[ACombo.ItemIndex]);
end;

function TSourceEditForm.GetSelectedOrgType: TOrgType;
begin
  Result := nil;
  if (cbOrgType.ItemIndex >= 0) and (cbOrgType.ItemIndex < cbOrgType.Items.Count) then
    Result := TOrgType(cbOrgType.Items.Objects[cbOrgType.ItemIndex]);
end;

procedure TSourceEditForm.grdContextsSelectionChange(Sender: TObject);
begin
  RefreshCreds;
end;

function TSourceEditForm.FindContextTypeById(Id: string): TContextType;
begin
   result:= nil;
   for var ctxType in FContextTypes do
   if SameText(ctxType.Ctxtid, id) then
     Exit(ctxType);
end;

function TSourceEditForm.FindOrganizationById(AOrgId: Integer): TOrganization;
var
  Org: TOrganization;
begin
  Result := nil;
  for Org in FOrganizations do
    if Org.OrgId = AOrgId then
    begin
      Result := Org;
      Exit;
    end;
end;

function TSourceEditForm.FindOrgTypeById(Id: Integer): TOrgType;
begin
  result:= nil;
  for var orgType in FOrgTypes do
    if orgType.OrgTypeId = id then
      Exit(orgType);
end;

function TSourceEditForm.PadSidSegment(const AValue: string; ALength: Integer): string;
var
  Segment: string;
begin
  Segment := Trim(AValue);
  while Length(Segment) < ALength do
    Segment := '0' + Segment;
  Result := Copy(Segment, 1, ALength);
  if Result = '' then
    Result := StringOfChar('0', ALength);
end;

function TSourceEditForm.BuildSidPrefix: string;
var
  Region: TLocation;
  RegionCode: string;
  RegionSuffix: string;
begin
  Result := '';
  if not FSelectedRegionId.Trim.IsEmpty then
  begin
    if SameText(FSelectedCountryId, 'RU') then
    begin
      Region := FindLocationById(FSelectedRegionId);
      if Assigned(Region) and not Region.LocGroup.Trim.IsEmpty then
        RegionCode := Region.LocGroup
      else
        RegionCode := FSelectedRegionId;

      if Length(RegionCode) > 2 then
        RegionSuffix := Copy(RegionCode, 3, Length(RegionCode))
      else
        RegionSuffix := RegionCode;

      Result := 'RU' + RegionSuffix;
    end
    else
      Result := StringReplace(FSelectedRegionId, '-', '', [rfReplaceAll]);
    Exit;
  end;

  if not FSelectedCountryId.Trim.IsEmpty then
    Result := FSelectedCountryId + 'XX';
end;

function TSourceEditForm.BuildAutoSid: string;
var
  Prefix: string;
begin
  Prefix := BuildSidPrefix;
  if Prefix.IsEmpty then
    Exit('');

  Result := Format('%s-%s-%s', [
    Prefix,
    PadSidSegment(edtIndex.Text, 6),
    PadSidSegment(edtNumber.Text, 4)
  ]);
end;

procedure TSourceEditForm.UpdateSidFromInputs;
var
  DisplaySid: string;
begin
  if Assigned(FSource) and not FSource.Sid.Trim.IsEmpty then
    DisplaySid := FSource.Sid
  else
    DisplaySid := BuildAutoSid;

  edtSid.Text := DisplaySid;
end;

procedure TSourceEditForm.SelectOrganizationInCombo(ACombo: TUniComboBox; AOrgId: Integer);
var
  I: Integer;
  Org: TOrganization;
begin
  if not Assigned(ACombo) then
    Exit;

  for I := 0 to ACombo.Items.Count - 1 do
  begin
    Org := TOrganization(ACombo.Items.Objects[I]);
    if Assigned(Org) and (Org.OrgId = AOrgId) then
    begin
      ACombo.ItemIndex := I;
      Exit;
    end;
  end;

  ACombo.ItemIndex := -1;
end;

procedure TSourceEditForm.SelectOrgTypeInCombo(AOrgTypeId: Integer);
var
  I: Integer;
  orgType: TOrgType;
begin
  for I := 0 to cbOrgType.Items.Count - 1 do
  begin
    orgType:= TOrgType(cbOrgType.Items.Objects[I]);
    if Assigned(orgType) and (orgType.OrgTypeId = AOrgTypeId) then
    begin
      cbOrgType.ItemIndex := I;
      Exit;
    end;
  end;

  cbOrgType.ItemIndex := -1;
end;

procedure TSourceEditForm.SetContextDS(contexts:TContextList);
begin
  unbtnDelContext.Enabled := contexts.Count > 0;
  unbtnAddCred.Enabled := unbtnDelContext.Enabled;
  if not assigned(contexts) or (contexts.Count = 0) then exit;
  ContextMem.EmptyDataSet;
  ContextMem.DisableControls;
  try
    for var ctx in contexts do
    with ctx as TContext do begin
      ContextMem.Append;
      ContextMem.FieldByName('index').AsString := Index;
      ContextMem.FieldByName('ctxid').AsString := CtxId;
      ContextMem.FieldByName('ctxtid').AsString :=CtxtId;
      var ctxType := FindContextTypeById(ctxtid);
      if ctxType <> nil then
        ContextMem.FieldByName('typeName').AsString := ctxType.Name;
      ContextMem.Post;
    end;
  finally
    ContextMem.EnableControls;
  end;
end;

procedure TSourceEditForm.unbtnDelContextClick(Sender: TObject);
begin
  MessageDlg('Удалить контекст?', mtConfirmation, [mbYes, mbNo],
     procedure(Sender: TComponent; Res: Integer)
     begin
       if Res = mrYes then DelContext;
     end);
end;

procedure TSourceEditForm.unbtnDeleteCredClick(Sender: TObject);
begin
  MessageDlg('Удалить интерфейс источника?', mtConfirmation, [mbYes, mbNo],
     procedure(Sender: TComponent; Res: Integer)
     begin
       if Res = mrYes then DelCred;
     end);

end;

procedure TSourceEditForm.unbtnContextRefreshClick(Sender: TObject);
begin
  RefreshContexts;
end;

procedure TSourceEditForm.unbtnCredsRefreshClick(Sender: TObject);
begin
  RefreshCreds;
end;

procedure TSourceEditForm.CreateSource;
var
  Broker: TSourcesRestBroker;
  Req: TSourceReqNew;
  Resp: TIdNewResponse;
  NewId: string;
begin
  if not Assigned(FSource) then
    Exit;

  Broker := nil;
  Req := nil;
  Resp := nil;

  try
    Broker := TSourcesRestBroker.Create(UniMainModule.XTicket);
    Req := Broker.CreateReqNew as TSourceReqNew;
    if not Assigned(Req) then
    begin
      MessageDlg('Не удалось подготовить запрос на создание источника.', mtWarning, [mbOK], nil);
      Exit;
    end;

    if Assigned(Req.ReqBody) then
      TSource(Req.ReqBody).Assign(FSource);
    try
      Resp := Broker.New(Req);
      if Assigned(Resp) and (Resp.StatusCode in [200, 201]) then
      begin
        NewId := '';
        if Assigned(Resp.ResBody) then
          NewId := Resp.ResBody.ID;

        if not NewId.IsEmpty then
        begin
          FSource.Sid := NewId;
          UpdateSidFromInputs;
        end;

        MessageDlg('Создан источник ' + FSource.Sid, mtInformation, [mbOK], nil);
        Close;
      end
      else if Assigned(Resp) then
        MessageDlg(Format('Не удалось создать источник. HTTP %d'#13#10'%s',
          [Resp.StatusCode, Resp.Response]), mtWarning, [mbOK], nil)
      else
        MessageDlg('Не удалось создать источник: пустой ответ сервера.', mtWarning, [mbOK], nil);
    except
      on E: EIdHTTPProtocolException do
        MessageDlg(Format('Ошибка создания источника. HTTP %d'#13#10'%s',
          [E.ErrorCode, E.ErrorMessage]), mtWarning, [mbOK], nil);
      on E: Exception do
        MessageDlg('Ошибка создания источника: ' + E.Message, mtWarning, [mbOK], nil);
    end;
  finally
    Resp.Free;
    Req.Free;
    Broker.Free;
  end;
end;

procedure TSourceEditForm.SelectLocationInCombo(ACombo: TUniComboBox; const ALocId: string);
var
  I: Integer;
  Loc: TLocation;
begin
  if not Assigned(ACombo) then
    Exit;

  for I := 0 to ACombo.Items.Count - 1 do
  begin
    Loc := TLocation(ACombo.Items.Objects[I]);
    if Assigned(Loc) and SameText(Loc.LocId, ALocId) then
    begin
      ACombo.ItemIndex := I;
      Exit;
    end;
  end;

  ACombo.ItemIndex := -1;
end;

function TSourceEditForm.GetSelectedCountry: TLocation;
begin
  Result := nil;
  if (cbCountry.ItemIndex >= 0) and (cbCountry.ItemIndex < cbCountry.Items.Count) then
    Result := TLocation(cbCountry.Items.Objects[cbCountry.ItemIndex]);
end;

function TSourceEditForm.GetParentOrgId(const Org: TOrganization): Integer;
begin
  Result := 0;
  if not Assigned(Org) then
    Exit;

  if Org.ParentOrgId.HasValue then
    Result := Org.ParentOrgId.Value;
end;

function TSourceEditForm.FindLocationById(const ALocId: string): TLocation;
var
  Loc: TLocation;
begin
  Result := nil;
  if ALocId.Trim.IsEmpty then
    Exit;

  for Loc in FLocations do
    if SameText(Loc.LocId, ALocId) then
      Exit(Loc);
end;

procedure TSourceEditForm.cbUgmsChange(Sender: TObject);
var
  SelectedUgm: TOrganization;
  CurrentOwner: TOrganization;
  ChildId: Integer;
begin
  SelectedUgm := GetSelectedOrganization(cbUgms);
  if Assigned(SelectedUgm) then
  begin
    CurrentOwner := FindOrganizationById(FSelectedOwnerOrgId);
    if Assigned(CurrentOwner) and (GetParentOrgId(CurrentOwner) = SelectedUgm.OrgId) then
      ChildId := CurrentOwner.OrgId
    else
      ChildId := 0;

    UpdateCgmsCombo(SelectedUgm.OrgId, ChildId);

    if ChildId = 0 then
      FSelectedOwnerOrgId := SelectedUgm.OrgId
    else
      FSelectedOwnerOrgId := ChildId;
  end
  else
  begin
    UpdateCgmsCombo(0, 0);
    FSelectedOwnerOrgId := 0;
  end;

  if Assigned(FSource) then
    UpdateSourceOwnerOrg(FSelectedOwnerOrgId);
end;

procedure TSourceEditForm.cbCgmsChange(Sender: TObject);
var
  SelectedCgms: TOrganization;
  SelectedUgm: TOrganization;
begin
  SelectedCgms := GetSelectedOrganization(cbCgms);
  if Assigned(SelectedCgms) then
    FSelectedOwnerOrgId := SelectedCgms.OrgId
  else
  begin
    SelectedUgm := GetSelectedOrganization(cbUgms);
    if Assigned(SelectedUgm) then
      FSelectedOwnerOrgId := SelectedUgm.OrgId
    else
      FSelectedOwnerOrgId := 0;
  end;

  if Assigned(FSource) then
    UpdateSourceOwnerOrg(FSelectedOwnerOrgId);
end;

procedure TSourceEditForm.cbCountryChange(Sender: TObject);
var
  Country: TLocation;
begin
  Country := GetSelectedCountry;
  if Assigned(Country) then
    FSelectedCountryId := Country.LocId
  else
    FSelectedCountryId := '';

  FSelectedRegionId := '';
  UpdateRegionCombo('');

  if Assigned(FSource) then
    UpdateSourceCountry(FSelectedCountryId);

  UpdateSidFromInputs;
end;

procedure TSourceEditForm.cbOrgTypeChange(Sender: TObject);
var
  orgType: TOrgType;
begin
  orgType := GetSelectedOrgType;
  if Assigned(orgType) then
    FSelectedOrgTypeId := orgType.OrgTypeId
  else
    FSelectedOrgTypeId := -1;
  if Assigned(FSource) then
  begin
    FSource.Srctid := FSelectedCountryId;
    UpdateSourceSrcType(FSelectedOrgTypeId);
  end;
end;

procedure TSourceEditForm.edtIndexChange(Sender: TObject);
begin
  UpdateSidFromInputs;
end;

procedure TSourceEditForm.edtNumberChange(Sender: TObject);
begin
  UpdateSidFromInputs;
end;

procedure TSourceEditForm.cbRegionChange(Sender: TObject);
var
  Region: TLocation;
begin
  if (cbRegion.ItemIndex >= 0) and (cbRegion.ItemIndex < cbRegion.Items.Count) then
  begin
    Region := TLocation(cbRegion.Items.Objects[cbRegion.ItemIndex]);
    FSelectedRegionId := Region.LocId;
  end
  else
    FSelectedRegionId := '';

  if Assigned(FSource) then
    UpdateSourceRegion(FSelectedRegionId);

  UpdateSidFromInputs;
end;

procedure TSourceEditForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TSourceEditForm.btnSaveClick(Sender: TObject);
var
  SidValue, NameValue: string;
begin
  if not Assigned(FSource) then
  begin
    MessageDlg('Источник не инициализирован.', mtWarning, [mbOK], nil);
    Exit;
  end;

  SidValue := Trim(edtSid.Text);
  NameValue := Trim(edtName.Text);

  if SidValue.IsEmpty then
  begin
    MessageDlg('Укажите SID источника.', mtWarning, [mbOK], nil);
    edtSid.SetFocus;
    Exit;
  end;

  if NameValue.IsEmpty then
  begin
    MessageDlg('Укажите наименование источника.', mtWarning, [mbOK], nil);
    edtName.SetFocus;
    Exit;
  end;

  ApplyToSource;

  if FIsEditMode then
    UpdateSource
  else
    CreateSource;
end;

procedure TSourceEditForm.RefreshContexts;
var 
  req: TContextReqList;
  resp: TContextListResponse;
begin
  try
    req := FContextBroker.CreateReqList() as TContextReqList;
    req.Body.Sids.Add(FSource.Sid);
    resp := FContextBroker.ListAll(req) as TContextListResponse;
    SetContextDS(resp.ContextList);
  finally
    req.Free;
    resp.Free;
  end;  
end;

procedure TSourceEditForm.RefreshCreds;
var
  req: TContextCredsReqList;
  resp: TContextCredsListResponse;
  link: TLink;
begin
  ContextCredsMem.DisableControls;
  ContextCredsMem.EmptyDataSet;
  var id := ContextMem.FieldByName('ctxid').AsString;
  if id = '' then
  begin
    ContextCredsMem.EnableControls;
    Exit;
  end;
  try
    req := FContextBroker.CreateReqCredList();
    req.Body.CtxIds.Add(id);
    resp := FContextBroker.ListCredentialsAll(req);

    for var credp in resp.CredentialList do
    with credp as TSourceCred do begin
      ContextCredsMem.Append;
      ContextCredsMem.FieldByName('lid').AsString:= Lid;
      ContextCredsMem.FieldByName('name').AsString:= Name;
      ContextCredsMem.FieldByName('login').AsString:= Login;
      ContextCredsMem.FieldByName('crid').AsString:= Id;
      ContextCredsMem.FieldByName('ctxid').AsString := CtxId;

      if (Lid <> '') and FLinks.TryGetValue(lid, link) then
        ContextCredsMem.FieldByName('interface').AsString:= link.Name
      else
        ContextCredsMem.FieldByName('interface').AsString := Lid;
      if assigned(Data) then
        ContextCredsMem.FieldByName('def').AsString:= Data.Def
      else
        ContextCredsMem.FieldByName('def').Clear;
      ContextCredsMem.Post;
    end;
  finally
    req.Free;
    resp.Free;
    ContextCredsMem.EnableControls;
    var hasCreds:=  ContextCredsMem.RecordCount > 0;
    unbtnDeleteCred.Enabled := hasCreds;
    unbtnEditCred.Enabled := hasCreds;
    grdInterfaces.Refresh;
  end;
end;

end.

finalization
  FLinks.Free;

