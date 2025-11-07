unit ContextCreateFormUnit;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  uniGUIBaseClasses, uniGUIClasses,uniGUITypes, uniGUIForm, uniPanel, uniButton,
  uniLabel, uniComboBox, uniEdit, System.UITypes,
  ContextTypeUnit,ContextUnit, uniMultiItem, Vcl.Controls, Vcl.Forms;

type


  TOnSaveContext = reference to procedure(const AResult: TContext);

  TContextCreateForm = class(TUniForm)
    pnlBody: TUniPanel;
    lblType: TUniLabel;
    cbType: TUniComboBox;
    lblIndex: TUniLabel;
    edIndex: TUniEdit;
    pnlFooter: TUniPanel;
    btnClose: TUniButton;
    btnSave: TUniButton;
    procedure UniFormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    FOnSave: TOnSaveContext;
    procedure PopulateTypes(const ATypes: TObjectList<TContextType>);
    function SelectedCtxtId(out ACtxtId: string): Boolean;
    function ValidateForm(out Err: string; out ACtxtId: string; out AIndex: string): Boolean;
  public
    procedure SetContextTypes(const ATypes: TObjectList<TContextType>);
    procedure OpenWithIndex(AIndex: string);

    property OnSave: TOnSaveContext read FOnSave write FOnSave;
  end;

implementation

{$R *.dfm}

procedure TContextCreateForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TContextCreateForm.btnSaveClick(Sender: TObject);
var
  Err: string;
  CtxtId: string;
  IndexValue: string;
  ResCtx: TContext;
begin
  if not ValidateForm(Err, CtxtId, IndexValue) then
  begin
    MessageDlg(Err, mtWarning, [mbOK], nil);
    Exit;
  end;
    ResCtx:= TContext.Create;
  try
    ResCtx.CtxtId := CtxtId;
    ResCtx.Index := IndexValue;

    if Assigned(FOnSave) then
      FOnSave(ResCtx);
  finally
    ResCtx.Free
  end;
  Close;
end;

procedure TContextCreateForm.OpenWithIndex(AIndex: string);
begin
  if not AIndex.IsEmpty then
    edIndex.Text := AIndex
  else
    edIndex.Text := '';
end;

procedure TContextCreateForm.PopulateTypes(const ATypes: TObjectList<TContextType>);
var
  ContextType: TContextType;
begin
  cbType.Items.BeginUpdate;
  try
    cbType.Items.Clear;
    if Assigned(ATypes) then
      for ContextType in ATypes do
        if Assigned(ContextType) then
          cbType.Items.AddObject(ContextType.Name, ContextType);
  finally
    cbType.Items.EndUpdate;
  end;

  if cbType.Items.Count > 0 then
    cbType.ItemIndex := 0
  else
    cbType.ItemIndex := -1;
end;

procedure TContextCreateForm.SetContextTypes(const ATypes: TObjectList<TContextType>);
begin
  PopulateTypes(ATypes);
end;

function TContextCreateForm.SelectedCtxtId(out ACtxtId: string): Boolean;
var
  ContextType: TContextType;
begin
  Result := False;
  ACtxtId := '';

  if cbType.ItemIndex < 0 then
    Exit;

  ContextType := TContextType(cbType.Items.Objects[cbType.ItemIndex]);
  if not Assigned(ContextType) then
    Exit;

  ACtxtId := ContextType.Ctxtid;
  Result := not ACtxtId.IsEmpty;
end;

procedure TContextCreateForm.UniFormCreate(Sender: TObject);
begin
  FreeOnClose := True;
  edIndex.Text := '';
end;

function TContextCreateForm.ValidateForm(out Err: string; out ACtxtId: string;
  out AIndex: string): Boolean;
begin
  Err := '';
  Result := False;

  if not SelectedCtxtId(ACtxtId) then
  begin
    Err := 'Выберите тип контекста.';
    Exit;
  end;

  AIndex := Trim(edIndex.Text);
  if AIndex = '' then
  begin
    Err := 'Укажите индекс контекста.';
    Exit;
  end;


  Result := True;
end;

end.
