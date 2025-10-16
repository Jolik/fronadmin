unit StripTasksBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  EntityUnit, StripTaskUnit, TasksBrokerUnit;

type
  ///  брокер для API tasks
  TStripTasksBroker = class (TTasksBroker)
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

{ TStripTasksBroker }

function TStripTasksBroker.GetBasePath: string;
begin
  Result := constURLStripBasePath;
end;

class function TStripTasksBroker.ClassType: TEntityClass;
begin
  Result := TStripTask;
end;

class function TStripTasksBroker.ListClassType: TEntityListClass;
begin
  Result := TStripTaskList;
end;

end.
