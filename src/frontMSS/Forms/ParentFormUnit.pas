unit ParentFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm,
  EntityUnit,
  ParentBrokerUnit,
  ParentEditFormUnit;

type
  ///  ������� ����� � ���������� � ��������
  TParentForm = class(TUniForm)
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
  private
    ///  ������ ��� ������� � API - ������� ������ ������������ ���� �� ��������������� �������
    FBroker: TParentBroker;
    ///  ����� ��� �������������� �������� - ����� ������ ������������ ���� �� �������������� �����
    FEditForm : TParentEditForm;

  protected
    procedure NewCallback(ASender: TComponent; AResult: Integer);
    procedure UpdateCallback(ASender: TComponent; AResult: Integer);

    ///  ������� ��� ���������� ��������� �� �����
    procedure Refresh(const AId: String = ''); virtual; abstract;

    ///  ������� ��� �������� ������� ������� ��������
    ///  ����� ������ �������������� ������� ����� ���������� ������ ������
    function CreateBroker(): TParentBroker; virtual; abstract;

    ///  ������� ��� �������� ������ ����� ��������������
    ///  ����� ������ �������������� ������� ����� ����������� ������ ����� ��������������
    function CreateEditForm(): TParentEditForm; virtual; abstract;

  public
    ///  ������ ��� ������� � API - ������� ������ � ������� ������ �� ������ ������
    ///  � ����������� ������� CreateBroker
    property Broker: TParentBroker read FBroker;
    ///  ����� ��� �������������� �������� - ������� ������ ������� � �������
    ///  ������ �� ������ ����� � ����������� ������� CreateEditForm
    property EditForm: TParentEditForm read FEditForm;
    procedure PrepareEditForm;
  end;

function ParentForm: TParentForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

{  TParentForm }

procedure TParentForm.NewCallback(ASender: TComponent;
  AResult: Integer);
var
  LId : string;
  res : boolean;

begin
  ///
  ///  ���� ��������� ���� ��������� ����� ��
  if AResult = mrOk then
  begin
    /// ��������� �� ���� ����������������� ����� ��������
    ///  � �������� ������� �� �������
    ///  ���� ��� ��, �� � ����� �������� ��������� ����� ��������
    res := Broker.New(EditForm.Entity);
    ///  ���� ������� �� ������� �� �������, �� �������� �� ����
    if not res then
    begin
/// !!!     ShowMessage()
      exit;
    end
    else
    begin
      ///  ���� �������� �� ������� ��������� ��
      ///  ������������ �����
      ///  ��������� ������� � ��������� ����� ��������
///!!!      Refresh(LEntity.Id);
        Refresh();
    end;
  end;
end;

procedure TParentForm.UpdateCallback(ASender: TComponent;
  AResult: Integer);
var
  LId : string;
  res : boolean;

begin
  ///  ���� ��������� ���� ��������� ����� ��
  if AResult = mrOk then
  begin
    /// ��������� �� ���� ����������������� ����� ��������
    ///  � �������� �������� �� �������
    ///  ���� ��� ��, �� � ����� �������� ���������� ����� ��������
    res := Broker.Update(EditForm.Entity);
    ///  ���� �������� �� ������� �� �������, �� �������� �� ����
    if not res then
    begin
/// !!!     ShowMessage()
      exit;
    end
    else
    begin
      ///  ���� �������� �� ������ ��������� ��
      ///  ������������ ���������
      ///  ��������� ������� � ��������� ����� ��������
///!!!      Refresh(LEntity.Id);
        Refresh();
    end;
  end;
end;

procedure TParentForm.UniFormCreate(Sender: TObject);
begin
  ///   ������� �������
  FBroker := CreateBroker();
  ///   ������� ����� ��������������
  /// 2025-10-16 ������ ���������. ��� �� ����� ��������� ����� ��������������
  /// �� ����� ��������� �� ����� ����������
  // FEditForm := CreateEditForm();
end;

procedure TParentForm.UniFormDestroy(Sender: TObject);
begin
  FreeAndNil(Broker);
// ���� ������� ��� �� �����? FreeAndNil(EditForm);
end;

procedure TParentForm.PrepareEditForm;
begin
  FEditForm := CreateEditForm();
end;

function ParentForm: TParentForm;
begin
  Result := TParentForm(UniMainModule.GetFormInstance(TParentForm));
end;

end.
