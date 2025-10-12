unit StripTaskUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  LoggingUnit,
  EntityUnit, TaskUnit;

type
  /// Класс задачи парсера (сервис strip)
  TStripTask = class (TTask)
  private

  protected

  public

  end;

type
  ///  настройки сущности StripTask
  TStripTaskSettings = class (TSettings)

  end;

type
  ///  список задач для сервиса стрип
  TStripTaskList = class (TEntityList)

  end;


implementation

uses
  System.SysUtils,
  FuncUnit;

end.
