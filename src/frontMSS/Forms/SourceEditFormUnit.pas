unit SourceEditFormUnit;

interface

uses
  SysUtils, Classes, System.Generics.Collections, UniGUIClasses, UniGUIForm, UniGUIBaseClasses, UniGUIAbstractClasses,
  UniGUIApplication, UniPanel, UniEdit, UniLabel, UniButton, UniComboBox, UniScrollBox,
  UniGroupBox, UniMemo, UniSplitter, UniDBGrid, System.StrUtils, uniBasicGrid,
  uniMultiItem, Vcl.Controls, Vcl.Forms, SourceUnit, OrganizationUnit, ContextTypeUnit,
  LocationUnit, ContextsRestBrokerUnit, ContextUnit, SourceCredsRestBrokerUnit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

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

    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure cbUgmsChange(Sender: TObject);
    procedure cbCgmsChange(Sender: TObject);
    procedure cbCountryChange(Sender: TObject);
    procedure cbRegionChange(Sender: TObject);
    procedure cbOrgTypeChange(Sender: TObject);
    procedure ContextMemCalcFields(DataSet: TDataSet);
    procedure grdContextsSelectionChange(Sender: TObject);
   protected
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
    procedure UpdateUI;
    procedure LoadData;
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
  MainModule, SourcesRestBrokerUnit, OrganizationsRestBrokerUnit, OrganizationHttpRequests,
  LocationsRestBrokerUnit, LocationHttpRequests, IdHTTP, ContextsHttpRequests, SourceCredsUnit;

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
  FCredBroker:= TSourceCredsRestBroker.Create(UniMainModule.XTicket);
  FContextBroker:= TContextsRestBroker.Create(UniMainModule.XTicket);
  FOrganizations := TObjectList<TOrganization>.Create(True);
  FLocations := TObjectList<TLocation>.Create(True);
  FOrgTypes:=  TObjectList<TOrgType>.Create(true);
  FContextTypes:= TObjectList<TContextType>.Create(true);
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
    edtLat.Text := FloatToStr(FSource.Lat);
    edtLon.Text := FloatToStr(FSource.Lon);
    edtElev.Text := IntToStr(FSource.Elev);
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
    OrgTypeReq := nil;
    OrgTypeResp := nil;
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
        CtxTypeResp.Free;
        OrgReq.Free;
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
      if Loc.ParentLocId.Trim = '' then
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
var 
  req: TContextCredsReqList;
  resp: TContextCredsListResponse;
begin
  ContextCredsMem.EmptyDataSet;
  ContextCredsMem.DisableControls;
  var id := ContextMem.FieldByName('ctxid').AsString;
  if id = '' then exit;
  try

    req := FContextBroker.CreateReqCredList();
    req.Body.CtxIds.Add(id);
    resp := FContextBroker.ListCredentialsAll(req);

    for var credp in resp.CredentialList do
    with credp as TSourceCreds do begin
      ContextCredsMem.Append;
      ContextCredsMem.FieldByName('name').AsString := Name;
      ContextCredsMem.FieldByName('login').AsString := Login;
      if assigned(SourceData) then
        ContextCredsMem.FieldByName('def').AsString :=SourceData.Def;
      ContextMem.Post;
  end;
  finally
    req.Free;
    resp.Free;
    ContextCredsMem.EnableControls;
  end;
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

  for var ctx in contexts do
  with ctx as TContext do begin
    ContextMem.Append;
    ContextMem.FieldByName('index').AsString := Index;
    ContextMem.FieldByName('ctxid').AsString := CtxId;
    ContextMem.FieldByName('ctxtid').AsString :=CtxtId;
    ContextMem.Post;
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

procedure TSourceEditForm.ContextMemCalcFields(DataSet: TDataSet);
begin
  var ctxtid := DataSet.FieldByName('ctxtid').AsString;
  var ctxType := FindContextTypeById(ctxtid);
  if ctxType <> nil then
    DataSet.FieldByName('typeName').AsString := ctxType.Name;
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
    ShowMessage('������ ����� ��������: ' + edtName.Text)
  else
    ShowMessage('��������� ��������� ��� ��������� ' + edtSid.Text);
end;

end.












