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

    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure cbUgmsChange(Sender: TObject);
    procedure cbCgmsChange(Sender: TObject);
    procedure cbCountryChange(Sender: TObject);
    procedure cbRegionChange(Sender: TObject);
    procedure cbOrgTypeChange(Sender: TObject);
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
    procedure CreateContext(const ACtxtId: string; AIndex: string);
    procedure CreateCredential(const AParams: TInterfaceCreateResult);
    procedure UpdateCredential(const AParams: TInterfaceEditResult; ACred: TSourceCreds);
    procedure EditCredential(const ACredId: string);
    function BuildLinkList: TLinkList;
    procedure UpdateUI;
    procedure LoadData;
    procedure ApplyToSource;
    procedure RefreshContexts;
    procedure RefreshCreds;
    procedure SaveSource;
    procedure UpdateSource;
    procedure PopulateOrganizationCombos;
    procedure PopulateOrganizationTypeCombos;
    procedure PopulateLocationCombos;
    procedure UpdateCgmsCombo(AParentOrgId, ASelectedOrgId: Integer);
    procedure UpdateRegionCombo(const ASelectedRegionId: string);
    procedure ApplyOrganizationSelection;
    procedure ApplyLocationSelection;
    procedure ApplyOrgTypeSelection;
    function GetSelectedOrganization(ACombo: TUniComboBox): TOrganization;
    function GetSelectedOrgType: TOrgType;
    function FindOrganizationById(AOrgId: Integer): TOrganization;
    function FindOrgTypeById(Id: Integer): TOrgType;
    function FindContextTypeById(Id: string): TContextType;
    procedure SelectOrgTypeInCombo(AOrgTypeId: Integer);
    procedure SelectOrganizationInCombo(ACombo: TUniComboBox; AOrgId: Integer);
    procedure SelectLocationInCombo(ACombo: TUniComboBox; const ALocId: string);
    function GetSelectedCountry: TLocation;
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
  LinksHttpRequests, ContextCreateFormUnit;

function SourceEditForm(isEdit:boolean;source:TSource): TSourceEditForm;
begin
  Result := TSourceEditForm(UniMainModule.GetFormInstance(TSourceEditForm));
  with Result do begin
    FIsEditMode:= isEdit;
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

procedure TSourceEditForm.CreateContext(const ACtxtId: string; AIndex: string);
var
  Req: TContextReqNew;
  Resp: TIdNewResponse;
  ContextEntity: TContext;
begin

  if not FIsEditMode then
  begin
    MessageDlg('Сохраните источник перед добавлением контекста.', mtWarning, [mbOK], nil);
    Exit;
  end;

  Req := FContextBroker.CreateReqNew() as TContextReqNew;
  Resp := nil;
  ContextEntity := TContext.Create;
  try
    ContextEntity.Sid := FSource.Sid;
    ContextEntity.CtxtId := ACtxtId;
    ContextEntity.Index := AIndex;

    Req.ApplyBody(ContextEntity);

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
    ContextEntity.Free;
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
    ContextForm.OpenWithIndex(FSource.Index);
    ContextForm.OnSave :=
      procedure(const AResult: TContextCreateResult)
      begin
        CreateContext(AResult.CtxtId, AResult.Index);
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

procedure TSourceEditForm.CreateCredential(const AParams: TInterfaceCreateResult);
var
  Req: TContextCredReqNew;
  Resp: TJSONResponse;
  Cred: TSourceCreds;
begin
  Req := FContextBroker.CreateReqCredNew() as TContextCredReqNew;
  Resp := nil;
  Cred := TSourceCreds.Create;
  try
    Cred.CtxId := AParams.CtxId;
    Cred.Lid := AParams.Lid;
    Cred.Name := AParams.Name;
    Cred.Login := AParams.Login;
    if AParams.Password.HasValue then
      Cred.Pass := AParams.Password.Value
    else
      Cred.Pass := '';
    Cred.SourceData.Def := AParams.Def;

    Req.ApplyBody(Cred);
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
    Cred.Free;
    Resp.Free;
    Req.Free;
  end;
end;

procedure TSourceEditForm.UpdateCredential(const AParams: TInterfaceEditResult; ACred: TSourceCreds);
var
  Req: TContextCredReqUpdate;
  Resp: TJSONResponse;
begin
  if not Assigned(ACred) then
    Exit;

  Req := FContextBroker.CreateReqCredUpdate(AParams.Crid) as TContextCredReqUpdate;
  Resp := nil;
  try
    ACred.Crid := AParams.Crid;
    ACred.CtxId := AParams.CtxId;
    ACred.Lid := AParams.Lid;
    ACred.Name := AParams.Name;
    ACred.Login := AParams.Login;
    if AParams.Password.HasValue then
      ACred.Pass := AParams.Password.Value;
    ACred.SourceData.Def := AParams.Def;

    Req.Id := AParams.Crid;
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
  CredCopy: TSourceCreds;
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

    CredCopy := TSourceCreds.Create;
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
        procedure(const AResult: TInterfaceEditResult)
        begin
          UpdateCredential(AResult, CredCopy);
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
    if Assigned(CredCopy) then
      CredCopy.Free;
  end;
end;

procedure TSourceEditForm.unbtnAddCredClick(Sender: TObject);
var
  ContextId: string;
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
  try
    Form := TInterfaceModalForm.Create(UniApplication);
    try
      Form.LoadForCreate(ContextId, LinkList);
      Form.OnCreate :=
        procedure(const AResult: TInterfaceCreateResult)
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
  edtSid.Enabled := not FIsEditMode;
  edtIndex.Enabled := not FIsEditMode;
  edtNumber.Enabled := not FIsEditMode;

  if Assigned(FSource) then
  begin
    edtSid.Text := FSource.Sid;
    edtName.Text := FSource.Name;
    edtPid.Text := FSource.Pid;
    edtIndex.Text := FSource.Index;
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
  end;

  if FIsEditMode and Assigned(FSource) then
  begin
    FSelectedCountryId := FSource.Country;
    FSelectedRegionId := FSource.Region;
    FSelectedOwnerOrgId := FSource.OwnerOrg;
    FSelectedOrgTypeId := FSource.SrcTypeID;
    ApplyOrgTypeSelection;
  end
  else
  begin
    FSelectedCountryId := 'RU';
    FSelectedRegionId := '';
    FSelectedOwnerOrgId := 0;
    if Assigned(FSource) then
    begin
      FSource.Country := FSelectedCountryId;
      FSource.Region := FSelectedRegionId;
      FSource.OwnerOrg := FSelectedOwnerOrgId;
    end;
  end;

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
      if Org.ParentOrgId = 0 then
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
        if Org.ParentOrgId = AParentOrgId then
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
    FSource.Region := FSelectedRegionId;
end;

procedure TSourceEditForm.UpdateSource;
begin

end;

procedure TSourceEditForm.ApplyOrganizationSelection;
var
  Owner: TOrganization;
  Parent: TOrganization;
begin
  if cbUgms.Items.Count = 0 then
  begin
    cbUgms.ItemIndex := -1;
    UpdateCgmsCombo(0, 0);
    FSelectedOwnerOrgId := 0;
    if Assigned(FSource) then
      FSource.OwnerOrg := 0;
    Exit;
  end;

  Owner := FindOrganizationById(FSelectedOwnerOrgId);
  if not Assigned(Owner) then
  begin
    cbUgms.ItemIndex := -1;
    UpdateCgmsCombo(0, 0);
    FSelectedOwnerOrgId := 0;
    if Assigned(FSource) then
      FSource.OwnerOrg := 0;
    Exit;
  end;

  if Owner.ParentOrgId > 0 then
  begin
    Parent := FindOrganizationById(Owner.ParentOrgId);
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
    FSource.OwnerOrg := FSelectedOwnerOrgId;
end;

procedure TSourceEditForm.ApplyOrgTypeSelection;
begin
  if FSelectedOrgTypeId <> -1 then
    SelectOrgTypeInCombo(FSelectedOrgTypeId)
  else
    cbOrgType.ItemIndex := -1;
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
    FSource.Name := edtName.Text;
    FSource.Pid := edtPid.Text;
    FSource.Index := edtIndex.Text;
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
    FSource.Country := FSelectedCountryId;
    FSource.Region := FSelectedRegionId;
  end;
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
       DelContext;
     end);
end;

procedure TSourceEditForm.unbtnDeleteCredClick(Sender: TObject);
begin
  MessageDlg('Удалить интерфейс источника?', mtConfirmation, [mbYes, mbNo],
     procedure(Sender: TComponent; Res: Integer)
     begin
       DelCred;
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

procedure TSourceEditForm.SaveSource;
begin

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
    if Assigned(CurrentOwner) and (CurrentOwner.ParentOrgId = SelectedUgm.OrgId) then
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
    FSource.OwnerOrg := FSelectedOwnerOrgId;
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
    FSource.OwnerOrg := FSelectedOwnerOrgId;
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
    FSource.Country := FSelectedCountryId;
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
    FSource.Srctid := FSelectedCountryId;
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
    FSource.Region := FSelectedRegionId;
end;

procedure TSourceEditForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TSourceEditForm.btnSaveClick(Sender: TObject);
begin
  if not FIsEditMode then
    ShowMessage('Источник обновлен: ' + edtName.Text)
  else
    ShowMessage('Создан источник ' + edtSid.Text);
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
  ContextCredsMem.EmptyDataSet;
  ContextCredsMem.DisableControls;
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
    with credp as TSourceCreds do begin
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
      if assigned(SourceData) then
        ContextCredsMem.FieldByName('def').AsString:= SourceData.Def
      else
        ContextCredsMem.FieldByName('def').Clear;
      ContextCredsMem.Post;
    end;
  finally
    req.Free;
    resp.Free;
    ContextCredsMem.EnableControls;
  end;
end;

end.

finalization
  FLinks.Free;
