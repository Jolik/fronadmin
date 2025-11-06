unit IntefraceEditFormUnit;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.UITypes,
  uniGUIClasses, uniGUIForm, uniGUIBaseClasses, uniPanel, uniButton,
  uniLabel, uniEdit, uniMemo, uniComboBox,
  SourceCredsUnit, LinkUnit, FuncUnit;

type
  TInterfaceCreateResult = record
    CtxId: string;
    Lid: string;
    Name: string;
    Login: string;
    Password: Nullable<string>;
    Def: string;
  end;

  TInterfaceEditResult = record
    Crid: string;
    CtxId: string;
    Lid: string;
    Name: string;
    Login: string;
    Password: Nullable<string>;
    Def: string;
  end;

  TOnCreateCredential = reference to procedure(const AResult: TInterfaceCreateResult);
  TOnUpdateCredential = reference to procedure(const AResult: TInterfaceEditResult);

  TInterfaceModalForm = class(TUniForm)
    pnlFooter: TUniPanel;
    btnClose: TUniButton;
    btnSave: TUniButton;
    pnlBody: TUniPanel;
    lblType: TUniLabel;
    cbLink: TUniComboBox;
    lblName: TUniLabel;
    edName: TUniEdit;
    lblLogin: TUniLabel;
    edLogin: TUniEdit;
    lblPass: TUniLabel;
    edPass: TUniEdit;
    lblDef: TUniLabel;
    mmDef: TUniMemo;
    procedure UniFormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    FIsEditMode: Boolean;
    FCtxId: string;
    FLinks: TLinkList;
    FEditCred: TSourceCreds;
    FOnCreate: TOnCreateCredential;
    FOnUpdate: TOnUpdateCredential;
    procedure AssignLinks(const ALinks: TLinkList);
    procedure PopulateLinks;
    function SelectedLink(out ALink: TLink): Boolean;
    procedure UpdatePasswordHint;
    function ValidateForm(out ErrMsg: string): Boolean;
    procedure ApplyCredentialToFields(const ACred: TSourceCreds);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadForCreate(const ACtxId: string; const ALinks: TLinkList);
    procedure LoadForEdit(const ACred: TSourceCreds; const ALinks: TLinkList);

    property OnCreate: TOnCreateCredential read FOnCreate write FOnCreate;
    property OnUpdate: TOnUpdateCredential read FOnUpdate write FOnUpdate;
  end;

implementation
uses uniGUITypes;

{$R *.dfm}

constructor TInterfaceModalForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLinks := nil;
  FEditCred := nil;
end;

destructor TInterfaceModalForm.Destroy;
begin
  FLinks.Free;
  inherited;
end;

procedure TInterfaceModalForm.AssignLinks(const ALinks: TLinkList);
var
  Link: TLink;
begin
  FreeAndNil(FLinks);
  FLinks := TLinkList.Create(False);
  if Assigned(ALinks) then
      FLinks.AddRange(ALinks);
end;

procedure TInterfaceModalForm.PopulateLinks;
var
  Link: TLink;
begin
  cbLink.Items.BeginUpdate;
  try
    cbLink.Items.Clear;
    if Assigned(FLinks) then
      for var Linkp in FLinks do
      begin
        Link := Linkp as  TLink;
        cbLink.Items.AddObject(Format('%s (%s)', [Link.Name, Link.Id]), Link);
      end;
  finally
    cbLink.Items.EndUpdate;
  end;
end;

procedure TInterfaceModalForm.UpdatePasswordHint;
begin
  if FIsEditMode then
    edPass.Hint := 'Оставьте пустым, если пароль не нужно менять'
  else
    edPass.Hint := 'Введите пароль для новой учетной записи';
end;

procedure TInterfaceModalForm.ApplyCredentialToFields(const ACred: TSourceCreds);
begin
  edName.Text := ACred.Name;
  edLogin.Text := ACred.Login;
  mmDef.Lines.Text := ACred.SourceData.Def;
  edPass.Text := '';
end;

procedure TInterfaceModalForm.UniFormCreate(Sender: TObject);
begin
  FreeOnClose := True;
end;

procedure TInterfaceModalForm.LoadForCreate(const ACtxId: string; const ALinks: TLinkList);
begin
  FIsEditMode := False;
  FCtxId := ACtxId;
  FEditCred := nil;
  AssignLinks(ALinks);
  PopulateLinks;
  cbLink.Enabled := True;
  cbLink.ItemIndex := -1;
  edName.Text := '';
  edLogin.Text := '';
  edPass.Text := '';
  mmDef.Lines.Clear;
  UpdatePasswordHint;
end;

procedure TInterfaceModalForm.LoadForEdit(const ACred: TSourceCreds; const ALinks: TLinkList);
var
  I: Integer;
  Link: TLink;
begin
  FIsEditMode := True;
  FCtxId := ACred.CtxId;
  FEditCred := ACred;
  AssignLinks(ALinks);
  PopulateLinks;
  cbLink.Enabled := False;

  if Assigned(FLinks) then
    for I := 0 to cbLink.Items.Count - 1 do
    begin
      Link := TLink(cbLink.Items.Objects[I]);
      if Assigned(Link) and SameText(Link.Id, ACred.Lid) then
      begin
        cbLink.ItemIndex := I;
        Break;
      end;
    end;
  if (cbLink.ItemIndex = -1) and Assigned(FEditCred) then
  begin
    cbLink.Items.Add(Format('%s (%s)', [FEditCred.Lid, FEditCred.Lid]));
    cbLink.ItemIndex := cbLink.Items.Count - 1;
  end;

  ApplyCredentialToFields(ACred);
  UpdatePasswordHint;
end;

function TInterfaceModalForm.SelectedLink(out ALink: TLink): Boolean;
begin
  Result := False;
  ALink := nil;
  if cbLink.ItemIndex < 0 then
    Exit;

  ALink := TLink(cbLink.Items.Objects[cbLink.ItemIndex]);
  Result := Assigned(ALink);
end;

function TInterfaceModalForm.ValidateForm(out ErrMsg: string): Boolean;
var
  DummyLink: TLink;
begin
  ErrMsg := '';

  if not FIsEditMode then
  begin
    if not SelectedLink(DummyLink) then
    begin
      ErrMsg := 'Выберите интерфейс.';
      Exit(False);
    end;
  end;

  if trim(edName.Text).IsEmpty then
  begin
    ErrMsg := 'Укажите имя интерфейса.';
    Exit(False);
  end;

  if trim(edLogin.Text).IsEmpty then
  begin
    ErrMsg := 'Укажите логин.';
    Exit(False);
  end;

  if (not FIsEditMode) and trim(edPass.Text).IsEmpty then
  begin
    ErrMsg := 'Пароль обязателен при создании.';
    Exit(False);
  end;

  if mmDef.Lines.Text.Trim.IsEmpty then
  begin
    ErrMsg := 'Заполните описание (def).';
    Exit(False);
  end;

  Result := True;
end;

procedure TInterfaceModalForm.btnSaveClick(Sender: TObject);
var
  ErrMsg: string;
  Link: TLink;
  CreateResult: TInterfaceCreateResult;
  UpdateResult: TInterfaceEditResult;
begin
  if not ValidateForm(ErrMsg) then
  begin
    MessageDlg(ErrMsg, TMsgDlgType.mtWarning, [mbOK], nil);
    Exit;
  end;

  if FIsEditMode then
  begin
    if not Assigned(FEditCred) then
    begin
      MessageDlg('Нет выбранной учетной записи для редактирования.', TMsgDlgType.mtWarning, [mbOK], nil);
      Exit;
    end;

    UpdateResult.Crid := FEditCred.Crid;
    UpdateResult.CtxId := FEditCred.CtxId;
    UpdateResult.Lid := FEditCred.Lid;
    UpdateResult.Name := trim(edName.Text);
    UpdateResult.Login := trim(edLogin.Text);
    if trim(edPass.Text).IsEmpty then
      UpdateResult.Password.Clear
    else
      UpdateResult.Password := Nullable<string>.Create(trim(edPass.Text));
    UpdateResult.Def := mmDef.Lines.Text.Trim;

    if Assigned(FOnUpdate) then
      FOnUpdate(UpdateResult);
  end
  else
  begin
    if not SelectedLink(Link) then
    begin
      MessageDlg('Не удалось определить выбранный интерфейс.', mtWarning, [mbOK], nil);
      Exit;
    end;

    CreateResult.CtxId := FCtxId;
    CreateResult.Lid := Link.Id;
    CreateResult.Name := trim(edName.Text);
    CreateResult.Login := trim(edLogin.Text);
    CreateResult.Password := Nullable<string>.Create(trim(edPass.Text));
    CreateResult.Def := mmDef.Lines.Text.Trim;

    if Assigned(FOnCreate) then
      FOnCreate(CreateResult);
  end;

  Close;
end;

procedure TInterfaceModalForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
