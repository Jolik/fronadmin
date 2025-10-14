unit SummaryTasksBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit, SummaryTaskUnit, TasksBrokerUnit;

type
  ///  брокер для API tasks
  TSummaryTasksBroker = class (TTasksBroker)
  private
  protected
    ///  метод возвращает конкретный тип сущности с которым работает брокер
    ///  потомки должны переопределить его, потому что он у всех разный
    class function ClassType: TEntityClass; override;
    ///  метод возвращает конкретный тип объекта элемента списка
    ///  потомки должны переопределить его, потому что он у всех разный
    class function ListClassType: TEntityListClass; override;

  protected
    ///  возвращает базовый путь до API
    function BaseUrlPath: string; override;

  public
    /// возвращает список доступных типов
    ///  в случае ошибки возвращается nil
    function Types: TJSONArray;
  end;

implementation

uses
  System.SysUtils, System.Classes,
  FuncUnit,
  APIConst;

const
  constURLTaskTypes = '/tasks/types';

{ TSummaryTasksBroker }

function TSummaryTasksBroker.BaseUrlPath: string;
begin
  Result := constURLStripBasePath;
end;

class function TSummaryTasksBroker.ClassType: TEntityClass;
begin
  Result := TSummaryTask;
end;

class function TSummaryTasksBroker.ListClassType: TEntityListClass;
begin
  Result := TSummaryTaskList;
end;

/// возвращает список доступных типов
///  в случае ошибки возвращается nil
function TSummaryTasksBroker.Types: TJSONArray;
var
  JSONResult     : TJSONObject;
  ResponseObject : TJSONObject;
  Types          : TJSONArray;
  ResStr         : String;
begin
  Result := nil;

  try
    JSONResult := TJSONObject.Create;
    try
      ///  делаем запрос
      ResStr := MainHttpModuleUnit.GET(BaseUrlPath + constURLTaskTypes);
      ///  парсим результат
      JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
      ///  объект - ответ
      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      ///  список типов
      Types := ResponseObject.GetValue('types') as TJSONArray;

      Result := Types.Clone as TJSONArray;
    finally
      JSONResult.Free;
    end;

  except on e:exception do
    begin
      Log('TSummaryTasksBroker.Types ' + e.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

end.

