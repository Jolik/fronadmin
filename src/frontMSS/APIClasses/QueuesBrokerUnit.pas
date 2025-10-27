unit QueuesBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit, QueueUnit, EntityBrokerUnit;

type
  ///  брокер для API Queues
  TQueuesBroker = class (TEntityBroker)
  protected
    ///  возвращает базовый путь до API
    function GetBasePath: string; override;
    ///  метод возвращает конкретный тип сущности с которым работает брокер
    ///  потомки должны переопределить его, потому что он у всех разный
    class function ClassType: TEntityClass; override;
    ///  метод возвращает конкретный тип объекта элемента списка
    ///  потомки должны переопределить его, потому что он у всех разный
    class function ListClassType: TEntityListClass; override;

  public
    /// возвращает список Задач
    ///  в случае ошибки возвращается nil
    function List(
      out APageCount: Integer;
      const APage: Integer = 0;
      const APageSize: Integer = 50;
      const ASearchStr: String = '';
      const ASearchBy: String = '';
      const AOrder: String = 'name';
      const AOrderDir: String = 'asc'): TEntityList; override;

    ///  создает нужный класс сущности
    ///  в случае ошибки возвращается nil
    function CreateNew(): TEntity; override;
    ///  создает на сервере новый класс сущности
    ///  в случае ошибки возвращается false
    function New(AEntity: TEntity): Boolean; override;
    ///  выдает информацию о сущности с сервера по идентификатору
    ///  в случае ошибки возвращается nil
    function Info(AId: String): TEntity; overload; override;
    ///  обновить параметры сущности на сервере
    ///  в случае ошибки возвращается false
    function Update(AEntity: TEntity): Boolean; override;
    ///  удалить сущность на сервере по идентификатору
    ///  в случае ошибки возвращается false
    function Remove(AId: String): Boolean; overload; override;

  end;

implementation

uses
  System.SysUtils, System.Classes,
  FuncUnit,
  APIConst;

const
  constURLQueuesList = '/queues/list';
  constURLQueuesInfo = '/queues/%s';
  constURLQueuesNew = '/queues/new';
  constURLQueuesUpdate = '/queues/%s/update';
  constURLQueuesRemove = '/queues/%s/remove';

{ TQueuesBroker }

function TQueuesBroker.GetBasePath: string;
begin
  Result := constURLRouterBasePath;
end;

class function TQueuesBroker.ClassType: TEntityClass;
begin
  Result := TQueue;
end;

class function TQueuesBroker.ListClassType: TEntityListClass;
begin
  Result := TQueueList;
end;

/// возвращает список задач
///  в случае ошибки возвращается nil
function TQueuesBroker.List(
  out APageCount: Integer;
  const APage: Integer = 0;
  const APageSize: Integer = 50;
  const ASearchStr: String = '';
  const ASearchBy: String = '';
  const AOrder: String = 'name';
  const AOrderDir: String = 'asc'): TEntityList;

  function CreateJSONRequest: TJSONObject;
  begin
    Result := TJSONObject.Create;
    Result.AddPair('page', APage);
    Result.AddPair('pagesize', APageSize);
    Result.AddPair('searchStr', ASearchStr);
    Result.AddPair('searchBy', ASearchBy);
    Result.AddPair('order', AOrder);
    Result.AddPair('orderDir', AOrderDir);
  end;

var
  JSONResult: TJSONObject;
  ResStr: String;

begin

  Result := nil;

  try

    JSONResult := TJSONObject.Create;
    try
      ///  делаем запрос - тело пустое
      ResStr := MainHttpModuleUnit.POST(GetBasePath + constURLQueuesList, TStringStream.Create('{}', TEncoding.UTF8));
      ///  парсим результат
      JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
      ///  объект - ответ
      var ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      ///  список очередей
      var QueueObject := ResponseObject.GetValue('queues') as TJSONObject;
      ///  список очередей
      var ItemsArray := QueueObject.GetValue('items') as TJSONArray;

      Result := ListClassType.Create(ItemsArray);

    finally
      JSONResult.Free;
    end;

  except on e:exception do
    begin
      Log('TQueuesBroker.List '+ e.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TQueuesBroker.CreateNew: TEntity;
begin
  Result := ClassType.Create();
end;

///  выдает информацию о сущности с сервера по идентификатору
///  в случае ошибки возвращается nil
function TQueuesBroker.Info(AId: String): TEntity;
var
  URL: String;
  ResStr: String;
  JSONResult: TJSONObject;

begin

  Result := nil;

  if AId = '' then
    exit;

  try
    URL := Format(GetBasePath + constURLQueuesInfo, [AId]);

    ResStr := MainHttpModuleUnit.GET(URL);

    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;

    try
      ///  находим JSON класс response
      var ResponseObject := JSONResult.GetValue('response') as TJSONObject;

      ///  находим JSON класс response
      var QueueObject := ResponseObject.GetValue('queue') as TJSONObject;

      ///  парсим JSON класс Queue
      Result := ClassType.Create(QueueObject);

    finally
      JSONResult.Free;

    end;

  except on e:exception do
    begin
      Log('TQueuesBroker.Info '+ e.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;

end;

///  создает на сервере новый класс сущности
///  в случае ошибки возвращается false
function TQueuesBroker.New(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONQueue: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;

begin
  ///  строим запрос
  URL := GetBasePath + constURLQueuesNew;
  ///  получаем из сущности JSON
  JSONQueue := AEntity.Serialize();

//  JSONRequest := FuncUnit.ExtractJSONProperties(JSONQueue, ['name', 'caption','Queues','attr']);

  JSONRequestStream := TStringStream.Create(JSONQueue.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);

    ////  !!! обрабатываем ответ
    ///  пока возвращаем всегда true
    Result := true;

  finally
    JSONQueue.Free;
    JSONRequestStream.Free;

  end;

end;

///  обновить параметры сущности на сервере
///  в случае ошибки возвращается false
function TQueuesBroker.Update(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONQueue: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;

begin
  ///  если пытаются передать не наш класс то не делаем ничего!
  if not (AEntity is TQueue) then
    exit;

  ///  строим запрос
  URL := Format(GetBasePath + constURLQueuesUpdate, [(AEntity as TQueue).QId]);

  ///  получаем из сущности JSON
  JSONQueue := AEntity.Serialize();

//  JSONRequest := FuncUnit.ExtractJSONProperties(JSONQueue, ['name', 'caption','Queues','attr']);

  JSONRequestStream := TStringStream.Create(JSONQueue.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);

    ////  !!! обрабатываем ответ
    ///  пока возвращаем всегда true
    Result := true;

  finally
    JSONQueue.Free;
    JSONRequestStream.Free;

  end;

end;

///  удалить сущность на сервере по идентификатору
///  в случае ошибки возвращается false
function TQueuesBroker.Remove(AId: String): Boolean;
var
  URL: String;
  ResStr: String;
  JSONRequestStream: TStringStream;

begin
  URL := Format(GetBasePath + constURLQueuesRemove, [AId]);

  JSONRequestStream := TStringStream.Create('{}', TEncoding.UTF8);

  ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream)

end;

end.
