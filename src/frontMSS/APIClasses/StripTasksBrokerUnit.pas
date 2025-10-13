unit StripTasksBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  EntityUnit, StripTaskUnit, TasksBrokerUnit;

type
  ///  ������ ��� API tasks
  TStripTasksBroker = class (TTasksBroker)
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

{ TStripTasksBroker }

function TStripTasksBroker.BaseUrlPath: string;
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
