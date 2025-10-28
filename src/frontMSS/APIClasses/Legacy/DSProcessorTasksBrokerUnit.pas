unit DSProcessorTasksBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  EntityUnit, DSProcessorTaskUnit, TasksBrokerUnit;

type
  ///    API tasks
  TDSProcessorTasksBroker = class (TTasksBroker)
  private
  protected
    ///
    ///     ,
    class function ClassType: TEntityClass; override;
    ///
    ///     ,
    class function ListClassType: TEntityListClass; override;

  protected
    ///      API
    function GetBasePath: string; override;

  public

  end;

implementation

uses
  System.SysUtils, System.Classes,
  FuncUnit,
  APIConst;

{ TDSProcessorTasksBroker }

function TDSProcessorTasksBroker.GetBasePath: string;
begin
  Result := constURLDSProcessBasePath;
end;

class function TDSProcessorTasksBroker.ClassType: TEntityClass;
begin
  Result := TDSProcessorTask;
end;

class function TDSProcessorTasksBroker.ListClassType: TEntityListClass;
begin
  Result := TDSProcessorTaskList;
end;

end.
