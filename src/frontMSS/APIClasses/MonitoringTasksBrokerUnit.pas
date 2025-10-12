unit MonitoringTasksBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  MainModule,
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
    class function ListClassType: TListClass; override;

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

{ TMonitoringTasksBroker }

function TMonitoringTasksBroker.BaseUrlPath: string;
begin
  Result := constURLStripBasePath;
end;

class function TMonitoringTasksBroker.ClassType: TEntityClass;
begin
  Result := TMonitoringTask;
end;

class function TMonitoringTasksBroker.ListClassType: TListClass;
begin
  Result := TMonitoringTaskList;
end;

end.
