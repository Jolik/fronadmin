unit SummaryTasksBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit, SummaryTaskUnit, TasksBrokerUnit;

type
  ///  ������ ��� API tasks
  TSummaryTasksBroker = class (TTasksBroker)
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
    /// ���������� ������ ��������� �����
    ///  � ������ ������ ������������ nil
    function Types: TJSONArray;
  end;

implementation

uses
  System.SysUtils, System.Classes,
  FuncUnit,
  APIConst;

const
  constURLTaskTypes = '/tasks/types';

{ TSummaryTasksBroker }

function TSummaryTasksBroker.BaseUrlPath: string;
begin
  Result := constURLStripBasePath;
end;

class function TSummaryTasksBroker.ClassType: TEntityClass;
begin
  Result := TSummaryTask;
end;

class function TSummaryTasksBroker.ListClassType: TEntityListClass;
begin
  Result := TSummaryTaskList;
end;

/// ���������� ������ ��������� �����
///  � ������ ������ ������������ nil
function TSummaryTasksBroker.Types: TJSONArray;
var
  JSONResult     : TJSONObject;
  ResponseObject : TJSONObject;
  Types          : TJSONArray;
  ResStr         : String;
begin
  Result := nil;

  try
    JSONResult := TJSONObject.Create;
    try
      ///  ������ ������
      ResStr := MainHttpModuleUnit.GET(BaseUrlPath + constURLTaskTypes);
      ///  ������ ���������
      JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
      ///  ������ - �����
      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      ///  ������ �����
      Types := ResponseObject.GetValue('types') as TJSONArray;

      Result := Types.Clone as TJSONArray;
    finally
      JSONResult.Free;
    end;

  except on e:exception do
    begin
      Log('TSummaryTasksBroker.Types ' + e.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

end.

