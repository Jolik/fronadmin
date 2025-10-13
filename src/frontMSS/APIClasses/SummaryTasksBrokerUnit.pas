unit SummaryTasksBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  MainModule,
  LoggingUnit,
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

  end;

implementation

uses
  System.SysUtils, System.Classes,
  FuncUnit,
  APIConst;

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

end.

