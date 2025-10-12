unit MonitoringTasksBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  MainModule,
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
    class function ListClassType: TListClass; override;

  protected
    ///  ���������� ������� ���� �� API
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
