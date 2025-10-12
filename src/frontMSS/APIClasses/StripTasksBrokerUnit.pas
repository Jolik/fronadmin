unit StripTasksBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  MainModule,
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
    class function ListClassType: TListClass; override;

  protected
    ///  ���������� ������� ���� �� API
    function BaseUrlPath: string; override;

  public

  end;

implementation

uses
  System.SysUtils, System.Classes,
  FuncUnit;

const
  constURLStripBasePath = '/strip/api/v2';

{ TStripTasksBroker }

function TStripTasksBroker.BaseUrlPath: string;
begin
  Result := constURLStripBasePath;
end;

class function TStripTasksBroker.ClassType: TEntityClass;
begin
  Result := TStripTask;
end;

class function TStripTasksBroker.ListClassType: TListClass;
begin
  Result := TStripTaskList;
end;

end.
