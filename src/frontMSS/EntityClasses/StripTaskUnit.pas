unit StripTaskUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  LoggingUnit,
  EntityUnit, TaskUnit;

type
  /// ����� ������ ������� (������ strip)
  TStripTask = class (TTask)
  private

  protected

  public

  end;

type
  ///  ��������� �������� StripTask
  TStripTaskSettings = class (TSettings)

  end;

type
  ///  ������ ����� ��� ������� �����
  TStripTaskList = class (TEntityList)

  end;


implementation

uses
  System.SysUtils,
  FuncUnit;

end.
