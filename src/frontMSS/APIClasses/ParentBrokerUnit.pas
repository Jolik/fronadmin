unit ParentBrokerUnit;

interface

uses
  System.Generics.Collections,
  EntityUnit;

type
  ///  базовый брокер для вызовов API
  TParentBroker = class(TObject)
  private
  protected
    ///  метод возвращает конкретный тип сущности с которым работает брокер
    ///  потомки должны переопределить его, потому что он у всех разный
    class function ClassType: TEntityClass; virtual;
    ///  метод возвращает конкретный тип объекта элемента списка
    ///  потомки должны переопределить его, потому что он у всех разный
    class function ListClassType: TListClass; virtual;

    ///  возвращает базовый путь до API
    function BaseUrlPath: string; virtual; abstract;

  public
    ///  возвращает список сущностей
    ///  в случае ошибки возвращается nil
    function List(
      out APageCount: Integer;
      const APage: Integer = 0;
      const APageSize: Integer = 50;
      const ASearchStr: String = '';
      const ASearchBy: String = '';
      const AOrder: String = 'name';
      const AOrderDir: String = 'asc'): TEntityList; virtual; abstract;

    ///  создает нужный класс сущности
    ///  в случае ошибки возвращается nil
    function CreateNew(): TEntity; virtual; abstract;
    ///  создает на сервере новый класс сущности
    ///  в случае успеха возвращается true
    function New(AEntity: TEntity): boolean; virtual; abstract;
    ///  выдает информацию о сущности с сервера по идентификатору
    ///  в случае ошибки возвращается nil
    function Info(AId: String): TEntity; overload;virtual; abstract;
    ///  выдает информацию о сущности с сервера
    ///  в случае ошибки возвращается nil
    function Info(AEntity: TEntity): TEntity; overload; virtual;
    ///  обновить параметры сущности на сервере
    ///  в случае ошибки возвращается false
    function Update(AEntity: TEntity): Boolean; virtual; abstract;
    ///  удалить сущность на сервере по идентификатору
    ///  в случае ошибки возвращается false
    function Remove(AId: String): Boolean; overload; virtual; abstract;
    ///  удалить сущность на сервере
    ///  в случае ошибки возвращается false
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
