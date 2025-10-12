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
  ///  ������ ����� ��� ������� �����
  TStripTaskList = class (TTaskList)
  protected
    ///  ����� ���������� ���������� ��� ������� �������� ������
    ///  ������� ������ �������������� ���, ������ ��� �� � ���� ������
    class function ItemClassType: TEntityClass; override;

  end;

type
  ///  ��������� �������� StripTask
  TStripTaskSettings = class (TSettings)

  end;


implementation

{ TStripTaskList }

class function TStripTaskList.ItemClassType: TEntityClass;
begin
  Result := TStripTask;
end;

end.
