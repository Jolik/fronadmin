unit SummaryTaskUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  LoggingUnit,
  EntityUnit, TaskUnit;

type
  ///    ( summary)
  TSummaryTask = class(TTask)

  end;

type
  ///    SummaryTask
  TSummaryTaskSettings = class(TSettings)

  end;

type
  ///
  TSummaryTaskList = class(TEntityList)

  end;

implementation

uses
  System.SysUtils,
  FuncUnit;

end.
