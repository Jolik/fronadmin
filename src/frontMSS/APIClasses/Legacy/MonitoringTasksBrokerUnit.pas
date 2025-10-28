unit MonitoringTasksBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  EntityUnit, MonitoringTaskUnit, TasksBrokerUnit;

type
  ///  брокер для API tasks
  TMonitoringTasksBroker = class (TTasksBroker)
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
    function GetBasePath: string; override;

  public

  end;

implementation

uses
  System.SysUtils, System.Classes,
  FuncUnit,
  APIConst;

{ TMonitoringTasksBroker }

function TMonitoringTasksBroker.GetBasePath: string;
begin
  Result := constURLMonitoringBasePath;
end;

class function TMonitoringTasksBroker.ClassType: TEntityClass;
begin
  Result := TMonitoringTask;
end;

class function TMonitoringTasksBroker.ListClassType: TEntityListClass;
begin
  Result := TMonitoringTaskList;
end;

end.
