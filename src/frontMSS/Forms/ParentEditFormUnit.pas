unit ParentEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm,
  uniButton, uniGUIBaseClasses, uniPanel, uniEdit, uniLabel,
  LoggingUnit,
  EntityUnit, ConstsUnit;

type
  TParentEditForm = class(TUniForm)
    pnBottom: TUniContainerPanel;
    btnOk: TUniButton;
    btnCancel: TUniButton;
    pnCaption: TUniContainerPanel;
    lCaption: TUniLabel;
    teCaption: TUniEdit;
    pnName: TUniContainerPanel;
    lName: TUniLabel;
    teName: TUniEdit;
    pnClient: TUniContainerPanel;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);

  private

  protected
    /// ����� ������� �������������
    FEntity: TEntity;

    ///  ������� ���������
    function Apply : boolean; virtual;
    /// ������� ��������� ��� ����������� � ���� ��, �� ������ true
    function DoCheck: Boolean; virtual;

    /// ����� ������� �������������
    procedure SetEntity(AEntity : TEntity); virtual;

  public
    ///  ����� ������� ����������� �����
    property Entity: TEntity read FEntity write SetEntity;

  end;

function ParentEditForm: TParentEditForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

resourcestring
  rsCaptionAdd = '�������...';
  rsCaptionEdit = '�������������...';

{ TParentEditForm }

procedure TParentEditForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TParentEditForm.btnOkClick(Sender: TObject);
begin
  if DoCheck then
    if Apply() then
      ModalResult := mrOk;
end;

procedure TParentEditForm.SetEntity(AEntity : TEntity);
begin
  if Assigned(FEntity) then
  begin
    try
      try
        FEntity.Free();
      except
        Log('TParentEditForm.SetEntity error! ', lrtError);

      end;
    finally
      FEntity := nil;
    end;
  end;

  FEntity := AEntity;

  teName.Text := AEntity.Name;
  teCaption.Text := AEntity.Caption;
end;

function TParentEditForm.Apply : boolean;
begin
  FEntity.Name := teName.Text;
  FEntity.Caption := teCaption.Text;

  Result := true;
end;

function TParentEditForm.DoCheck: Boolean;
begin
  Result := False;
  if teName.Text = '' then
    MessageDlg(Format(rsWarningValueNotSetInField, [lName.Caption]), TMsgDlgType.mtWarning, [mbOK], nil)
  else
    Result := True;
end;

function ParentEditForm: TParentEditForm;
begin
  Result := TParentEditForm(UniMainModule.GetFormInstance(TParentEditForm));
end;

end.
