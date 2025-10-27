unit EntityBrokerUnit;

interface

uses
  System.Generics.Collections,
  EntityUnit;

type
  // Класс-ссылка на ответ API TResponse
  TResponseClass = class of TResponse;

  ///  базовый класс - парсер ответа API TResponse
  ///  класс парсит ответ и заполняет свои поля
  TResponse = class(TObject)
  private
    FResStr: string;
    FResBool: boolean;
  protected
  public
    ///  конструктор класса сразу с ответом
    constructor CreateWithResponse(AResStr: string); virtual;
    ///  парсинг ответа
    function ParseResponse(AResStr: string): boolean; virtual;

    ///  строка ответ
    property ResStr: string read FResStr;
    ///  результат в виде булева типа
    property ResBool: boolean read FResBool;
  end;


type
  // Класс-ссылка на брокер TEntityBroker
  TEntityBrokerClass = class of TEntityBroker;

  ///  базовый брокер для вызовов API
  TEntityBroker = class(TObject)
  private
    FAddPath: string;
  protected
    ///  метод возвращает конкретный тип сущности с которым работает брокер
    ///  потомки должны переопределить его, потому что он у всех разный
    class function ClassType: TEntityClass; virtual;
    ///  метод возвращает конкретный тип объекта элемента списка
    ///  потомки должны переопределить его, потому что он у всех разный
    class function ListClassType: TEntityListClass; virtual;
    ///  метод возвращает конкретный тип объекта обработчика ответа
    ///  потомки должны переопределить его, потому что он у всех разный
    class function ResponseClassType: TResponseClass; virtual;

    ///  возвращает базовый путь до API - потомок должен переопредеоить
    function GetBasePath: string; virtual; abstract;

    ///  возвращает весь путь до API
    function GetPath: string; virtual;

  public
    ///  возвращает список сущностей
    ///  в случае ошибки возвращается nil
    function List(
      out APageCount: Integer;
      const APage: Integer = 1;
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

    ///  дополнительная часть пути (в основном для добавления идентификатора ID)
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

  ///  парсим сразу ответ
  FResBool := ParseResponse(AResStr);
end;

function TResponse.ParseResponse(AResStr: string): boolean;
begin
  /// !!!
  Result := true;
end;

end.
