unit StripTasksBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  MainModule,
  LoggingUnit,
  EntityUnit, StripTaskUnit, ParentBrokerUnit;

type
  ///  ������ ��� API tasks
  TStripTasksBroker = class (TParentBroker)
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
    ///  ������ ���������� � �������� � �������
    ///  � ������ ������ ������������ nil
    function Info(AEntity: TEntity): TEntity; overload; override;
    ///  �������� ��������� �������� �� �������
    ///  � ������ ������ ������������ false
    function Update(AEntity: TEntity): Boolean; override;
    ///  ������� �������� �� ������� �� ��������������
    ///  � ������ ������ ������������ false
    function Remove(AId: String): Boolean; overload; override;
    ///  ������� �������� �� �������
    ///  � ������ ������ ������������ false
    function Remove(AEntity: TEntity): Boolean; overload; override;

  end;

implementation




uses
  System.SysUtils, System.Classes,
  FuncUnit;

const
  constURLStripTaskGetList = '/strip/api/v2/tasks/list';
  constURLStripTaskGetOneInfo = '/strip/api/v2/tasks/%s';
  constURLStripTaskNew = '/strip/api/v2/tasks/new';
  constURLStripTaskUpdate = '/strip/api/v2/tasks/%s/update';
  constURLStripTaskDelete = '/strip/api/v2/tasks/%s/remove';

{ TStripTasksBroker }

//function TStripTasksBroker.StripTaskGetList(
//  const APage, APageSize: Integer;
//  out APageCount: Integer;
//  const ASearchStr, ASearchBy, AOrder,
//  AOrderDir: String): TDataset;

//  function CreateJSONRequest: TJSONObject;
//  begin
//    Result := TJSONObject.Create;
//    Result.AddPair('page', APage);
//    Result.AddPair('pagesize', APageSize);
//    Result.AddPair('searchStr', ASearchStr);
//    Result.AddPair('searchBy', ASearchBy);
//    Result.AddPair('order', AOrder);
//    Result.AddPair('orderDir', AOrderDir);
//  end;
//
//var
//  URL: String;
//  JSONRequest: TJSONObject;
//  JSONResult: TJSONObject;
//  ResStr: String;

//begin
//  Result := TFDDataSet.Create(nil);
//  URL := constURLStripTaskGetList;
//  JSONRequest := CreateJSONRequest;
//  JSONResult := TJSONObject.Create;
//  try
//    Result.FieldDefs.Add('abid', ftGuid);
//    Result.FieldDefs.Add('name', ftString, 256);
//    Result.FieldDefs.Add('caption', ftString, 256);
//    Result.FieldDefs.Add('created', ftDateTime);
//    Result.FieldDefs.Add('updated', ftDateTime);
//
//    ResStr := MainModule.POST(constURLStripTaskGetList, JSONRequest.ToJSON);
//
//    JSONResult.ParseJSONValue(ResStr);
//
//  finally
//    JSONRequest.Free;
//    JSONResult.Free;
//  end;
//end;

/// ���������� ������ ���������
///  � ������ ������ ������������ nil
function TStripTasksBroker.List(
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
  StripTaskArray: TJSONArray;
  ResStr: String;

begin
  Result := TStripTaskList.Create();

  try

    JSONResult := TJSONObject.Create;
    try
      ///  ������ ������
      ResStr := MainModule.GET(constURLStripTaskGetList);
      ///  ������ ���������
      JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
      ///  ������ - �����
      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      ///  ������ ������
      StripTaskArray := ResponseObject.GetValue('tasks') as TJSONArray;

      ///  ��������� ���������
      ///  ���������� ������� � ������� /strip/tasks/list �� ��������������
      APageCount := 0;
      for var st in StripTaskArray do
      begin
        ///  ����������� ��������� ��� st ��� TJSONObject
        ///  ��� ��� ����������� ���� ������ JSON �������
        if st is TJSONObject then
        begin
          ///  ������� ������ ����� �� JSON
          var StripTask := TStripTask.Create(st as TJSONObject);
          ///  ������� ��� � ������
          result.Add(StripTask);
        end;
      end;

    finally
      JSONResult.Free;
    end;

  except on e:exception do
    begin
      Log('TStripTasksBroker.List '+ e.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TStripTasksBroker.CreateNew: TEntity;
begin
  Result := TStripTask.Create();
end;

///  ������ ���������� � �������� � �������
///  � ������ ������ ������������ nil
function TStripTasksBroker.Info(AEntity: TEntity): TEntity;
begin
  result := Info(AEntity.Id);
end;

///  ������ ���������� � �������� � ������� �� ��������������
///  � ������ ������ ������������ nil
function TStripTasksBroker.Info(AId: String): TEntity;
var
  URL: String;
  ResStr: String;
  JSONResult: TJSONObject;

begin

  if AId = '' then
    exit;

  Result := TStripTask.Create;
  try
    URL := Format(constURLStripTaskGetOneInfo, [AId]);

    ResStr := MainModule.GET(URL);

    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;

(*
    � ����� �������� ����� JSON

{
    "response": {
        "task": {
            "tid": "352890ab-bd9c-404c-9626-3a0c314ed7ac",
            "def": "",
            "module": "StripXML",
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

��. ��� http://dev.modext.ru:8929/dcc7/main/-/blob/main/API/strip/tasks.md?ref_type=heads#22-%D0%B8%D0%BD%D1%84%D0%BE%D1%80%D0%BC%D0%B0%D1%86%D0%B8%D1%8F-%D0%BF%D0%BE-%D1%83%D0%BA%D0%B0%D0%B7%D0%B0%D0%BD%D0%BD%D0%BE%D0%BC%D1%83-%D0%B7%D0%B0%D0%B4%D0%B0%D0%BD%D0%B8%D1%8E

*)

    try
      ///  ������� JSON ����� response
      var ResponseObject := JSONResult.GetValue('response') as TJSONObject;

      ///  ������� JSON ����� task
      var TaskObject := ResponseObject.GetValue('task') as TJSONObject;

      ///  ������ JSON ����� task
      Result := TStripTask.Create(TaskObject);

    finally
      JSONResult.Free;

    end;

  except on e:exception do
    begin
      Log('TStripTasksBroker.Info '+ e.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;

end;

///  ������� �� ������� ����� ����� ��������
///  � ������ ������ ������������ false
function TStripTasksBroker.New(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONStripTask: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;

begin
  ///  ������ ������
  URL := constURLStripTaskNew;
  ///  �������� �� �������� JSON
  JSONStripTask := AEntity.Serialize();

//  JSONRequest := FuncUnit.ExtractJSONProperties(JSONStripTask, ['name', 'caption','tasks','attr']);

  JSONRequestStream := TStringStream.Create(JSONStripTask.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainModule.POST(URL, JSONRequestStream);

    ////  !!! ������������ �����
    ///  ���� ���������� ������ true
    Result := true;

  finally
    JSONStripTask.Free;
    JSONRequestStream.Free;

  end;

end;

///  �������� ��������� �������� �� �������
///  � ������ ������ ������������ false
function TStripTasksBroker.Update(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONStripTask: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;

begin
  ///  ���� �������� �������� �� ��� ����� �� �� ������ ������!
  if not (AEntity is TStripTask) then
    exit;

  ///  ������ ������
  URL := Format(constURLStripTaskUpdate, [(AEntity as TStripTask).TId]);

  ///  �������� �� �������� JSON
  JSONStripTask := AEntity.Serialize();

//  JSONRequest := FuncUnit.ExtractJSONProperties(JSONStripTask, ['name', 'caption','tasks','attr']);

  JSONRequestStream := TStringStream.Create(JSONStripTask.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainModule.POST(URL, JSONRequestStream);

    ////  !!! ������������ �����
    ///  ���� ���������� ������ true
    Result := true;

  finally
    JSONStripTask.Free;
    JSONRequestStream.Free;

  end;

end;

///  ������� �������� �� �������
///  � ������ ������ ������������ false
function TStripTasksBroker.Remove(AEntity: TEntity): Boolean;
begin

end;

///  ������� �������� �� ������� �� ��������������
///  � ������ ������ ������������ false
function TStripTasksBroker.Remove(AId: String): Boolean;
var
  URL: String;
  ResStr: String;
  JSONRequestStream: TStringStream;

begin
  URL := Format(constURLStripTaskDelete, [AId]);

  JSONRequestStream := TStringStream.Create('{}', TEncoding.UTF8);

  ResStr := MainModule.POST(URL, JSONRequestStream)

end;

end.
