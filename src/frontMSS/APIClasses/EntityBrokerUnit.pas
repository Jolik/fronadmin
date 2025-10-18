unit EntityBrokerUnit;

interface

uses
  System.Generics.Collections,
  EntityUnit;

type
  // �����-������ �� ����� API TResponse
  TResponseClass = class of TResponse;

  ///  ������� ����� - ������ ������ API TResponse
  ///  ����� ������ ����� � ��������� ���� ����
  TResponse = class(TObject)
  private
    FResStr: string;
    FResBool: boolean;
  protected
  public
    ///  ����������� ������ ����� � �������
    constructor CreateWithResponse(AResStr: string); virtual;
    ///  ������� ������
    function ParseResponse(AResStr: string): boolean; virtual;

    ///  ������ �����
    property ResStr: string read FResStr;
    ///  ��������� � ���� ������ ����
    property ResBool: boolean read FResBool;
  end;


type
  // �����-������ �� ������ TEntityBroker
  TEntityBrokerClass = class of TEntityBroker;

  ///  ������� ������ ��� ������� API
  TEntityBroker = class(TObject)
  private
    FAddPath: string;
  protected
    ///  ����� ���������� ���������� ��� �������� � ������� �������� ������
    ///  ������� ������ �������������� ���, ������ ��� �� � ���� ������
    class function ClassType: TEntityClass; virtual;
    ///  ����� ���������� ���������� ��� ������� �������� ������
    ///  ������� ������ �������������� ���, ������ ��� �� � ���� ������
    class function ListClassType: TEntityListClass; virtual;
    ///  ����� ���������� ���������� ��� ������� ����������� ������
    ///  ������� ������ �������������� ���, ������ ��� �� � ���� ������
    class function ResponseClassType: TResponseClass; virtual;

    ///  ���������� ������� ���� �� API - ������� ������ ��������������
    function GetBasePath: string; virtual; abstract;

    ///  ���������� ���� ���� �� API
    function GetPath: string; virtual;

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

    ///  �������������� ����� ���� (� �������� ��� ���������� �������������� ID)
    property AddPath: string read FAddPath write FAddPath;

  end;

implementation

{ TEntityBroker }

class function TEntityBroker.ClassType: TEntityClass;
begin
  Result := TEntity;
end;

class function TEntityBroker.ListClassType: TEntityListClass;
begin
  Result := TEntityList;
end;

function TEntityBroker.GetPath: string;
begin
  Result := GetBasePath + AddPath;
end;

function TEntityBroker.Info(AEntity: TEntity): TEntity;
begin
  result := Info(AEntity.Id);
end;

function TEntityBroker.Remove(AEntity: TEntity): Boolean;
begin
  result := Remove(AEntity.Id);
end;

class function TEntityBroker.ResponseClassType: TResponseClass;
begin
  Result := TResponse;
end;

{ TResponse }

constructor TResponse.CreateWithResponse(AResStr: string);
begin
  inherited Create();

  ///  ������ ����� �����
  FResBool := ParseResponse(AResStr);
end;

function TResponse.ParseResponse(AResStr: string): boolean;
begin
  /// !!!
  Result := true;
end;

end.
