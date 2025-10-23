unit MonitoringTasksBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  EntityUnit, MonitoringTaskUnit, TasksBrokerUnit;

type
  ///  ������ ��� API tasks
  TMonitoringTasksBroker = class (TTasksBroker)
  private
  protected
    ///  ����� ���������� ���������� ��� �������� � ������� �������� ������
    ///  ������� ������ �������������� ���, ������ ��� �� � ���� ������
    class function ClassType: TEntityClass; override;
    ///  ����� ���������� ���������� ��� ������� �������� ������
    ///  ������� ������ �������������� ���, ������ ��� �� � ���� ������
    class function ListClassType: TEntityListClass; override;

  protected
    ///  ���������� ������� ���� �� API
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
