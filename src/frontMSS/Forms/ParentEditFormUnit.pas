unit ParentEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm,
  uniButton, uniGUIBaseClasses, uniPanel, uniEdit, uniLabel,
  LoggingUnit,
  EntityUnit, ConstsUnit, uniTimer;

type
  TOKCallBackFunc = function(const ID:string; FEntity: TFieldSet): Boolean of object;

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
    UniTimer1: TUniTimer;

    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure UniTimer1Timer(Sender: TObject);

  private

  protected
    FOnOkCalback: TOKCallBackFunc;
    /// класс который редактируется
    FEntity: TFieldSet;
    FIsEdit: boolean;
    FId: string;
    ///  функция применяет
    function Apply : boolean; virtual;
    /// функция проверяет все параметртры и если ок, то выдает true
    function DoCheck: Boolean; virtual;
    /// класс который редактируется
    procedure SetEntity(AEntity : TFieldSet); virtual;

  public
    procedure ShowModalEx(okCallBack:TOKCallBackFunc);
    ///  класс который редактирует форма
    property IsEdit: boolean read FIsEdit write FIsEdit;
    property Entity: TFieldSet read FEntity write SetEntity;
    property Id: string read FId write FId;
    property OnOkCalback: TOKCallBackFunc read FOnOkCalback write FOnOkCalback;

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
  JSInterface.JSCall('setLoading', ['Обработка...']);
  if DoCheck then
    if Apply() then
       UniTimer1.Enabled:= true;
end;

procedure TParentEditForm.SetEntity(AEntity : TFieldSet);
begin
  FEntity := AEntity;
  if FEntity is TEntity then
  with  FEntity as TEntity do
  begin
    teName.Text := Name;
    teCaption.Text := Caption;
  end;
end;

procedure TParentEditForm.ShowModalEx(okCallBack: TOKCallBackFunc);
begin
  OnOkCalback:=okCallBack;
  inherited ShowModal();
end;

procedure TParentEditForm.UniFormShow(Sender: TObject);
begin
  Caption:= ifThen(FIsEdit,rsCaptionEdit, rsCaptionAdd)
end;

procedure TParentEditForm.UniTimer1Timer(Sender: TObject);
begin
  JSInterface.JSCall('setLoading', [False]);
  if not assigned(FOnOkCalback) then
  begin
    ShowMessage('Обработчик не присвоен');
    exit;
  end;
  if FOnOkCalback(FId, FEntity) then
    ModalResult := mrOk;
end;

function TParentEditForm.Apply : boolean;
begin
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


