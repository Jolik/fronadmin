unit DSProcessorTaskUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  LoggingUnit,
  EntityUnit, TaskUnit;

type
  ///    ( dsprocessor)
  TDSProcessorTask = class (TTask)
  private

  protected

  public

  end;

type
  ///
  TDSProcessorTaskList = class (TTaskList)
  protected
    ///
    ///     ,
    class function ItemClassType: TEntityClass; override;

  end;

type
  ///    DSProcessorTask
  TDSProcessorTaskSettings = class (TSettings)

  end;


implementation

{ TDSProcessorTaskList }

class function TDSProcessorTaskList.ItemClassType: TEntityClass;
begin
  Result := TDSProcessorTask;
end;

end.
