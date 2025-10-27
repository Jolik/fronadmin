unit FieldSetBrokerUnit;

interface

uses
  System.Generics.Collections,
  EntityUnit;

type
  // Класс-ссылка на брокер TFieldSetBroker
  TFieldSetBrokerClass = class of TFieldSetBroker;

  ///  базовый брокер для вызовов API
  TFieldSetBroker = class(TObject)
  private
  protected
    ///  метод возвращает конкретный тип сущности с которым работает брокер
    ///  потомки должны переопределить его, потому что он у всех разный
    class function ClassType: TFieldSetClass; virtual;
    ///  метод возвращает конкретный тип объекта элемента списка
    ///  потомки должны переопределить его, потому что он у всех разный
    class function ListClassType: TFieldSetListClass; virtual;

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
      const AOrderDir: String = 'asc'): TFieldSetList; virtual; abstract;

    ///  создает нужный класс сущности
    ///  в случае ошибки возвращается nil
    function CreateNew(): TFieldSet; virtual; abstract;
    ///  создает на сервере новый класс сущности
    ///  в случае успеха возвращается true
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
