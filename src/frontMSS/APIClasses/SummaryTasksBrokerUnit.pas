unit SummaryTasksBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  MainModule,
  LoggingUnit,
  EntityUnit, SummaryTaskUnit, TasksBrokerUnit;

type
  ///  ������ ��� API tasks
  TSummaryTasksBroker = class (TTasksBroker)
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

