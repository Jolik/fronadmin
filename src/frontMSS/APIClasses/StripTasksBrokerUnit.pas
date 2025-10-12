unit StripTasksBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  MainModule,
  LoggingUnit,
  EntityUnit, StripTaskUnit, TasksBrokerUnit;

type
  ///  брокер для API tasks
  TStripTasksBroker = class (TTasksBroker)
  protected
    ///  возвращает базовый путь до API
    function BaseUrlPath: string; override;

    ///  создает нужный класс сущности
    ///  в случае ошибки возвращается nil
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
