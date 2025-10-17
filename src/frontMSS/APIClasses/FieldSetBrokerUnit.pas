unit FieldSetBrokerUnit;

interface

uses
  System.Generics.Collections,
  EntityUnit;

type
  // �����-������ �� ������ TFieldSetBroker
  TFieldSetBrokerClass = class of TFieldSetBroker;

  ///  ������� ������ ��� ������� API
  TFieldSetBroker = class(TObject)
  private
  protected
    ///  ����� ���������� ���������� ��� �������� � ������� �������� ������
    ///  ������� ������ �������������� ���, ������ ��� �� � ���� ������
    class function ClassType: TFieldSetClass; virtual;
    ///  ����� ���������� ���������� ��� ������� �������� ������
    ///  ������� ������ �������������� ���, ������ ��� �� � ���� ������
    class function ListClassType: TFieldSetListClass; virtual;

    ///  ���������� ������� ���� �� API
    function BaseUrlPath: string; virtual; abstract;

  public
    ///  ���������� ������ ���������
    ///  � ������ ������ ������������ nil
    function List(
      out APageCount: Integer;
      const APage: Integer = 0;
      const APageSize: Integer = 50;
      const ASearchStr: String = '';
      const ASearchBy: String = '';
      const AOrder: String = 'name';
      const AOrderDir: String = 'asc'): TFieldSetList; virtual; abstract;

    ///  ������� ������ ����� ��������
    ///  � ������ ������ ������������ nil
    function CreateNew(): TFieldSet; virtual; abstract;
    ///  ������� �� ������� ����� ����� ��������
    ///  � ������ ������ ������������ true
    function New(AFieldSet: TFieldSet): boolean; virtual; abstract;

  end;

implementation

{ TFieldSetBroker }

class function TFieldSetBroker.ClassType: TFieldSetClass;
begin
  Result := TFieldSet;
end;

class function TFieldSetBroker.ListClassType: TFieldSetListClass;
begin
  Result := TFieldSetList;
end;

end.
