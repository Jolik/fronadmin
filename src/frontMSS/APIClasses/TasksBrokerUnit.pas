unit TasksBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit, TaskUnit, EntityBrokerUnit;

type
  ///  ������ ��� API tasks
  TTasksBroker = class (TEntityBroker)
  private
  protected
    ///  ����� ���������� ���������� ��� �������� � ������� �������� ������
    ///  ������� ������ �������������� ���, ������ ��� �� � ���� ������
    class function ClassType: TEntityClass; override;
    ///  ����� ���������� ���������� ��� ������� �������� ������
    ///  ������� ������ �������������� ���, ������ ��� �� � ���� ������
    class function ListClassType: TEntityListClass; override;

  public
    /// ���������� ������ �����
    ///  � ������ ������ ������������ nil
    function List(
      out APageCount: Integer;
      const APage: Integer = 0;
      const APageSize: Integer = 50;
      const ASearchStr: String = '';
      const ASearchBy: String = '';
      const AOrder: String = 'name';
      const AOrderDir: String = 'asc'): TEntityList; override;

    ///  ������� ������ ����� ��������
    ///  � ������ ������ ������������ nil
    function CreateNew(): TEntity; override;
    ///  ������� �� ������� ����� ����� ��������
    ///  � ������ ������ ������������ false
    function New(AEntity: TEntity): Boolean; override;
    ///  ������ ���������� � �������� � ������� �� ��������������
    ///  � ������ ������ ������������ nil
    function Info(AId: String): TEntity; overload; override;
    ///  �������� ��������� �������� �� �������
    ///  � ������ ������ ������������ false
    function Update(AEntity: TEntity): Boolean; override;
    ///  ������� �������� �� ������� �� ��������������
    ///  � ������ ������ ������������ false
    function Remove(AId: String): Boolean; overload; override;

  end;

implementation

uses
  System.SysUtils, System.Classes,
  FuncUnit;

const
  constURLTaskGetList = '/tasks/list';
  constURLTaskGetOneInfo = '/tasks/%s';
  constURLTaskNew = '/tasks/new';
  constURLTaskUpdate = '/tasks/%s/update';
  constURLTaskDelete = '/tasks/%s/remove';

{ TTasksBroker }

/// ���������� ������ �����
///  � ������ ������ ������������ nil
function TTasksBroker.List(
  out APageCount: Integer;
  const APage: Integer = 0;
  const APageSize: Integer = 50;
  const ASearchStr: String = '';
  const ASearchBy: String = '';
  const AOrder: String = 'name';
  const AOrderDir: String = 'asc'): TEntityList;

  function CreateJSONRequest: TJSONObject;
  begin
    Result := TJSONObject.Create;
    Result.AddPair('page', APage);
    Result.AddPair('pagesize', APageSize);
    Result.AddPair('searchStr', ASearchStr);
    Result.AddPair('searchBy', ASearchBy);
    Result.AddPair('order', AOrder);
    Result.AddPair('orderDir', AOrderDir);
  end;

var
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  TaskArray: TJSONArray;
  ResStr: String;

begin

  Result := nil;

  try

    JSONResult := TJSONObject.Create;
    try
      ///  ������ ������
      ResStr := MainHttpModuleUnit.GET(BaseUrlPath + constURLTaskGetList);
      ///  ������ ���������
      JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
      ///  ������ - �����
      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      ///  ������ ������
      TaskArray := ResponseObject.GetValue('tasks') as TJSONArray;

      Result := ListClassType.Create(TaskArray);

    finally
      JSONResult.Free;
    end;

  except on e:exception do
    begin
      Log('TTasksBroker.List '+ e.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

class function TTasksBroker.ClassType: TEntityClass;
begin
  Result := TTask;
end;

class function TTasksBroker.ListClassType: TEntityListClass;
begin
  Result := TTaskList;
end;

function TTasksBroker.CreateNew: TEntity;
begin
  Result := ClassType.Create();
end;

///  ������ ���������� � �������� � ������� �� ��������������
///  � ������ ������ ������������ nil
function TTasksBroker.Info(AId: String): TEntity;
var
  URL: String;
  ResStr: String;
  JSONResult: TJSONObject;

begin

  Result := nil;

  if AId = '' then
    exit;

  try
    URL := Format(BaseUrlPath + constURLTaskGetOneInfo, [AId]);

    ResStr := MainHttpModuleUnit.GET(URL);

    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;

(*
    � ����� �������� ����� JSON

{
    "response": {
        "task": {
            "tid": "352890ab-bd9c-404c-9626-3a0c314ed7ac",
            "def": "",
            "module": "XML",
            "compid": "85697f9f-b80d-4668-8ed2-2f70ed825eee",
            "depid": "4cf0dbf0-820b-4e05-a819-d6d1ec5652f0",
            "name": "XML",
            "enabled": true,
            "settings": {}
        }
    },
    "meta": {
        "rid": "8dc8a6ce-254f-4cfe-8586-46a85a177fa0",
        "time": "0ms",
        "code": 200
    }
}

��. ��� http://dev.modext.ru:8929/dcc7/main/-/blob/main/API//tasks.md?ref_type=heads#22-%D0%B8%D0%BD%D1%84%D0%BE%D1%80%D0%BC%D0%B0%D1%86%D0%B8%D1%8F-%D0%BF%D0%BE-%D1%83%D0%BA%D0%B0%D0%B7%D0%B0%D0%BD%D0%BD%D0%BE%D0%BC%D1%83-%D0%B7%D0%B0%D0%B4%D0%B0%D0%BD%D0%B8%D1%8E

*)

    try
      ///  ������� JSON ����� response
      var ResponseObject := JSONResult.GetValue('response') as TJSONObject;

      ///  ������� JSON ����� task
      var TaskObject := ResponseObject.GetValue('task') as TJSONObject;

      ///  ������ JSON ����� task
      Result := ClassType.Create(TaskObject);

    finally
      JSONResult.Free;

    end;

  except on e:exception do
    begin
      Log('TTasksBroker.Info '+ e.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;

end;

///  ������� �� ������� ����� ����� ��������
///  � ������ ������ ������������ false
function TTasksBroker.New(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONTask: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;

begin
  ///  ������ ������
  URL := BaseUrlPath + constURLTaskNew;
  ///  �������� �� �������� JSON
  JSONTask := AEntity.Serialize();

//  JSONRequest := FuncUnit.ExtractJSONProperties(JSONTask, ['name', 'caption','tasks','attr']);

  JSONRequestStream := TStringStream.Create(JSONTask.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);

    ////  !!! ������������ �����
    ///  ���� ���������� ������ true
    Result := true;

  finally
    JSONTask.Free;
    JSONRequestStream.Free;

  end;

end;

///  �������� ��������� �������� �� �������
///  � ������ ������ ������������ false
function TTasksBroker.Update(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONTask: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;

begin
  ///  ���� �������� �������� �� ��� ����� �� �� ������ ������!
  if not (AEntity is TTask) then
    exit;

  ///  ������ ������
  URL := Format(BaseUrlPath + constURLTaskUpdate, [(AEntity as TTask).TId]);

  ///  �������� �� �������� JSON
  JSONTask := AEntity.Serialize();

//  JSONRequest := FuncUnit.ExtractJSONProperties(JSONTask, ['name', 'caption','tasks','attr']);

  JSONRequestStream := TStringStream.Create(JSONTask.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);

    ////  !!! ������������ �����
    ///  ���� ���������� ������ true
    Result := true;

  finally
    JSONTask.Free;
    JSONRequestStream.Free;

  end;

end;

///  ������� �������� �� ������� �� ��������������
///  � ������ ������ ������������ false
function TTasksBroker.Remove(AId: String): Boolean;
var
  URL: String;
  ResStr: String;
  JSONRequestStream: TStringStream;

begin
  URL := Format(BaseUrlPath + constURLTaskDelete, [AId]);

  JSONRequestStream := TStringStream.Create('{}', TEncoding.UTF8);

  ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream)

end;

end.
