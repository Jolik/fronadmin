unit ParentBrokerUnit;

interface

uses
  System.Generics.Collections,
  EntityUnit;

type
  ///  ������� ������ ��� ������� API
  TParentBroker = class(TObject)
  private
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
      const AOrderDir: String = 'asc'): TEntityList; virtual; abstract;

    ///  ������� ������ ����� ��������
    ///  � ������ ������ ������������ nil
    function CreateNew(): TEntity; virtual; abstract;
    ///  ������� �� ������� ����� ����� ��������
    ///  � ������ ������ ������������ true
    function New(AEntity: TEntity): boolean; virtual; abstract;
    ///  ������ ���������� � �������� � ������� �� ��������������
    ///  � ������ ������ ������������ nil
    function Info(AId: String): TEntity; overload;virtual; abstract;
    ///  ������ ���������� � �������� � �������
    ///  � ������ ������ ������������ nil
    function Info(AEntity: TEntity): TEntity; overload; virtual; abstract;
    ///  �������� ��������� �������� �� �������
    ///  � ������ ������ ������������ false
    function Update(AEntity: TEntity): Boolean; virtual; abstract;
    ///  ������� �������� �� ������� �� ��������������
    ///  � ������ ������ ������������ false
    function Remove(AId: String): Boolean; overload; virtual; abstract;
    ///  ������� �������� �� �������
    ///  � ������ ������ ������������ false
    function Remove(AEntity: TEntity): Boolean; overload; virtual; abstract;

  end;

implementation

end.
