unit ParentBrokerUnit;

interface

uses
  System.Generics.Collections,
  EntityUnit;

type
  ///  ������� ������ ��� ������� API
  TParentBroker = class(TObject)
  private
  protected
    ///  ����� ���������� ���������� ��� �������� � ������� �������� ������
    ///  ������� ������ �������������� ���, ������ ��� �� � ���� ������
    class function ClassType: TEntityClass; virtual;
    ///  ����� ���������� ���������� ��� ������� �������� ������
    ///  ������� ������ �������������� ���, ������ ��� �� � ���� ������
    class function ListClassType: TListClass; virtual;

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
    function Info(AEntity: TEntity): TEntity; overload; virtual;
    ///  �������� ��������� �������� �� �������
    ///  � ������ ������ ������������ false
    function Update(AEntity: TEntity): Boolean; virtual; abstract;
    ///  ������� �������� �� ������� �� ��������������
    ///  � ������ ������ ������������ false
    function Remove(AId: String): Boolean; overload; virtual; abstract;
    ///  ������� �������� �� �������
    ///  � ������ ������ ������������ false
    function Remove(AEntity: TEntity): Boolean; overload; virtual;

  end;

implementation

{ TParentBroker }

class function TParentBroker.ClassType: TEntityClass;
begin
  Result := TEntity;
end;

class function TParentBroker.ListClassType: TListClass;
begin
  Result := TEntityList;
end;

function TParentBroker.Info(AEntity: TEntity): TEntity;
begin
  result := Info(AEntity.Id);
end;

function TParentBroker.Remove(AEntity: TEntity): Boolean;
begin
  result := Remove(AEntity.Id);
end;

end.
