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
    pnID: TUniContainerPanel;
    UniLabel1: TUniLabel;
    teID: TUniEdit;

    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure UniFormShow(Sender: TObject);

  private

  protected
    /// класс который редактируется
    FEntity: TEntity;
    FIsEdit: boolean;
    ///  функция применяет
    function Apply : boolean; virtual;
    /// функция проверяет все параметртры и если ок, то выдает true
    function DoCheck: Boolean; virtual;
    /// класс который редактируется
    procedure SetEntity(AEntity : TEntity); virtual;

  public
    ///  класс который редактирует форма
    property IsEdit: boolean read FIsEdit write FIsEdit;
    property Entity: TEntity read FEntity write SetEntity;

  end;

function ParentEditForm(editMode: boolean): TParentEditForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, StrUtils;

resourcestring
  rsCaptionAdd = 'Создать...';
  rsCaptionEdit = 'Редактировать...';

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
  teID.text := AEntity.Id;
end;

procedure TParentEditForm.UniFormShow(Sender: TObject);
begin
  Caption:= ifThen(FIsEdit,rsCaptionEdit, rsCaptionAdd)
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


function ParentEditForm(editMode: boolean): TParentEditForm;
begin
  Result := TParentEditForm(UniMainModule.GetFormInstance(TParentEditForm));
  Result.FIsEdit:= editMode;
end;

end.
