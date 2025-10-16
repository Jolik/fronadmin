unit StripTasksFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ListParentFormUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniPageControl, uniSplitter, uniBasicGrid, uniDBGrid,
  uniToolBar, uniGUIBaseClasses,
  //ParentBrokerUnit,
  ParentEditFormUnit,
  StripTasksBrokerUnit;

type
  TStripTasksForm = class(TListParentForm)
  private

  protected
    ///  ������� ���������� ��������� �� �����
    procedure Refresh(const AId: String = ''); override;

    ///  ������� ��� �������� ������� ������� �������
    //function CreateBroker(): TParentBroker; override;

    ///  ������� ��� �������� ������ ����� ��������������
    function CreateEditForm(): TParentEditForm; override;

  public

  end;

function StripTasksForm: TStripTasksForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, StripTaskEditFormUnit;

function StripTasksForm: TStripTasksForm;
begin
  Result := TStripTasksForm(UniMainModule.GetFormInstance(TStripTasksForm));
end;

{ TStripTasksForm }
    {
function TStripTasksForm.CreateBroker: TParentBroker;
begin
  ///  ������� "���" ������ ��� �����
  Result := TStripTasksBroker.Create();
end;
}

function TStripTasksForm.CreateEditForm: TParentEditForm;
begin
  ///  ������� "����" ����� �������������� ��� �����
  Result := StripTaskEditForm();
end;

procedure TStripTasksForm.Refresh(const AId: String = '');
begin
  inherited Refresh(AId)
end;

end.
