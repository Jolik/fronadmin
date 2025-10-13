unit QueuesBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit, QueueUnit, ParentBrokerUnit;

type
  ///  ������ ��� API Queues
  TQueuesBroker = class (TParentBroker)
  protected
    ///  ���������� ������� ���� �� API
    function BaseUrlPath: string; override;
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
  FuncUnit,
  APIConst;

const
  constURLQueuesList = '/queues/list';
  constURLQueuesInfo = '/queues/%s';
  constURLQueuesNew = '/queues/new';
  constURLQueuesUpdate = '/queues/%s/update';
  constURLQueuesRemove = '/queues/%s/remove';

{ TQueuesBroker }

function TQueuesBroker.BaseUrlPath: string;
begin
  Result := constURLRouterBasePath;
end;

class function TQueuesBroker.ClassType: TEntityClass;
begin
  Result := TQueue;
end;

class function TQueuesBroker.ListClassType: TEntityListClass;
begin
  Result := TQueueList;
end;

/// ���������� ������ �����
///  � ������ ������ ������������ nil
function TQueuesBroker.List(
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
  ResStr: String;

begin

  Result := nil;

  try

    JSONResult := TJSONObject.Create;
    try
      ///  ������ ������ - ���� ������
      ResStr := MainHttpModuleUnit.POST(BaseUrlPath + constURLQueuesList, TStringStream.Create('{}', TEncoding.UTF8));
      ///  ������ ���������
      JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
      ///  ������ - �����
      var ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      ///  ������ ��������
      var QueueObject := ResponseObject.GetValue('queues') as TJSONObject;
      ///  ������ ��������
      var ItemsArray := QueueObject.GetValue('items') as TJSONArray;

      Result := ListClassType.Create(ItemsArray);

    finally
      JSONResult.Free;
    end;

  except on e:exception do
    begin
      Log('TQueuesBroker.List '+ e.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TQueuesBroker.CreateNew: TEntity;
begin
  Result := ClassType.Create();
end;

///  ������ ���������� � �������� � ������� �� ��������������
///  � ������ ������ ������������ nil
function TQueuesBroker.Info(AId: String): TEntity;
var
  URL: String;
  ResStr: String;
  JSONResult: TJSONObject;

begin

  Result := nil;

  if AId = '' then
    exit;

  try
    URL := Format(BaseUrlPath + constURLQueuesInfo, [AId]);

    ResStr := MainHttpModuleUnit.GET(URL);

    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;

    try
      ///  ������� JSON ����� response
      var ResponseObject := JSONResult.GetValue('response') as TJSONObject;

      ///  ������� JSON ����� response
      var QueueObject := ResponseObject.GetValue('queue') as TJSONObject;

      ///  ������ JSON ����� Queue
      Result := ClassType.Create(QueueObject);

    finally
      JSONResult.Free;

    end;

  except on e:exception do
    begin
      Log('TQueuesBroker.Info '+ e.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;

end;

///  ������� �� ������� ����� ����� ��������
///  � ������ ������ ������������ false
function TQueuesBroker.New(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONQueue: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;

begin
  ///  ������ ������
  URL := BaseUrlPath + constURLQueuesNew;
  ///  �������� �� �������� JSON
  JSONQueue := AEntity.Serialize();

//  JSONRequest := FuncUnit.ExtractJSONProperties(JSONQueue, ['name', 'caption','Queues','attr']);

  JSONRequestStream := TStringStream.Create(JSONQueue.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);

    ////  !!! ������������ �����
    ///  ���� ���������� ������ true
    Result := true;

  finally
    JSONQueue.Free;
    JSONRequestStream.Free;

  end;

end;

///  �������� ��������� �������� �� �������
///  � ������ ������ ������������ false
function TQueuesBroker.Update(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONQueue: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;

begin
  ///  ���� �������� �������� �� ��� ����� �� �� ������ ������!
  if not (AEntity is TQueue) then
    exit;

  ///  ������ ������
  URL := Format(BaseUrlPath + constURLQueuesUpdate, [(AEntity as TQueue).QId]);

  ///  �������� �� �������� JSON
  JSONQueue := AEntity.Serialize();

//  JSONRequest := FuncUnit.ExtractJSONProperties(JSONQueue, ['name', 'caption','Queues','attr']);

  JSONRequestStream := TStringStream.Create(JSONQueue.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);

    ////  !!! ������������ �����
    ///  ���� ���������� ������ true
    Result := true;

  finally
    JSONQueue.Free;
    JSONRequestStream.Free;

  end;

end;

///  ������� �������� �� ������� �� ��������������
///  � ������ ������ ������������ false
function TQueuesBroker.Remove(AId: String): Boolean;
var
  URL: String;
  ResStr: String;
  JSONRequestStream: TStringStream;

begin
  URL := Format(BaseUrlPath + constURLQueuesRemove, [AId]);

  JSONRequestStream := TStringStream.Create('{}', TEncoding.UTF8);

  ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream)

end;

end.
