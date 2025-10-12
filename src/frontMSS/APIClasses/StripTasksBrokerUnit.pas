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
  protected
    ///  ���������� ������� ���� �� API
    function BaseUrlPath: string; override;

    ///  ������� ������ ����� ��������
    ///  � ������ ������ ������������ nil
    function CreateNew(): TEntity; override;

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

function TStripTasksBroker.CreateNew: TEntity;
begin
  Result := TStripTask.Create();
end;

end.
