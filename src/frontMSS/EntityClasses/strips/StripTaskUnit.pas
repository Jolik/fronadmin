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
  ///  список задач для сервиса стрип
  TStripTaskList = class (TTaskList)
  protected
    ///  метод возвращает конкретный тип объекта элемента списка
    ///  потомки должны переопределить его, потому что он у всех разный
    class function ItemClassType: TEntityClass; override;

  end;

type
  ///  настройки сущности StripTask
  TStripTaskSettings = class (TSettings)

  end;


implementation

{ TStripTaskList }

class function TStripTaskList.ItemClassType: TEntityClass;
begin
  Result := TStripTask;
end;

end.
