unit QueuesBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  MainModule,
  LoggingUnit,
  EntityUnit, QueueUnit, ParentBrokerUnit;

type
  ///  брокер для API Queues
  TQueuesBroker = class (TParentBroker)
    /// возвращает список Абонентов
    ///  в случае ошибки возвращается nil
    function List(
      out APageCount: Integer;
      const APage: Integer = 0;
      const APageSize: Integer = 50;
      const ASearchStr: String = '';
      const ASearchBy: String = '';
      const AOrder: String = 'name';
      const AOrderDir: String = 'asc'): TEntityList; override;

    ///  создает нужный класс сущности
    ///  в случае ошибки возвращается nil
    function CreateNew(): TEntity; override;
    ///  создает на сервере новый класс сущности
    ///  в случае ошибки возвращается false
    function New(AEntity: TEntity): Boolean; override;
    ///  выдает информацию о сущности с сервера по идентификатору
    ///  в случае ошибки возвращается nil
    function Info(AId: String): TEntity; overload; override;
    ///  выдает информацию о сущности с сервера
    ///  в случае ошибки возвращается nil
    function Info(AEntity: TEntity): TEntity; overload; override;
    ///  обновить параметры сущности на сервере
    ///  в случае ошибки возвращается false
    function Update(AEntity: TEntity): Boolean; override;
    ///  удалить сущность на сервере по идентификатору
    ///  в случае ошибки возвращается false
    function Remove(AId: String): Boolean; overload; override;
    ///  удалить сущность на сервере
    ///  в случае ошибки возвращается false
    function Remove(AEntity: TEntity): Boolean; overload; override;

  end;

implementation

uses
  System.SysUtils, System.Classes,
  FuncUnit;

const
  constURLQueueGetList = '/router/api/v2/Queues/list';
  constURLQueueGetOneInfo = '/router/api/v2/Queues/%s';
  constURLQueueInsert = '/router/api/v2/Queues/new';
  constURLQueueUpdate = '/router/api/v2/Queues/%s/update';
  constURLQueueDelete = '/router/api/v2/rou/%s/remove';

{ TQueuesBroker }

//function TQueuesBroker.QueueGetList(
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
//  URL := constURLQueueGetList;
//  JSONRequest := CreateJSONRequest;
//  JSONResult := TJSONObject.Create;
//  try
//    Result.FieldDefs.Add('abid', ftGuid);
//    Result.FieldDefs.Add('name', ftString, 256);
//    Result.FieldDefs.Add('caption', ftString, 256);
//    Result.FieldDefs.Add('created', ftDateTime);
//    Result.FieldDefs.Add('updated', ftDateTime);
//
//    ResStr := MainModule.POST(constURLQueueGetList, JSONRequest.ToJSON);
//
//    JSONResult.ParseJSONValue(ResStr);
//
//  finally
//    JSONRequest.Free;
//    JSONResult.Free;
//  end;
//end;

/// возвращает список Абонентов
///  в случае ошибки возвращается nil
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
  URL: String;
  JSONRequest: TJSONObject;
  JSONRequestStream: TStringStream;
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  InfoObject: TJSONObject;
  ResStr: String;

begin
  Result := TQueueList.Create();

  URL := constURLQueueGetList;
  JSONRequest := CreateJSONRequest;
//  JSONRequestStream := TStringStream.Create(JSONRequest.ToJSON, TEncoding.UTF8);
  JSONRequestStream := TStringStream.Create('{}', TEncoding.UTF8);
  JSONResult := TJSONObject.Create;
  try
    ResStr := MainModule.POST(constURLQueueGetList, JSONRequestStream);
    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
    ResponseObject := JSONResult.GetValue('response') as TJSONObject;
    InfoObject := ResponseObject.GetValue('info') as TJSONObject;
    APageCount := InfoObject.GetValue<Integer>('pagecount');

//    JSONResult.GetValue
  finally
    JSONRequest.Free;
    JSONRequestStream.Free;
    if Assigned(JSONResult) then
      JSONResult.Free;
//    if Assigned(ResponseObject) then
//      ResponseObject.Free;
//    if Assigned(InfoObject) then
//      InfoObject.Free;
//    if Assigned(QueuesObjectArray) then
//      QueuesObjectArray.Free;
  end;
end;

function TQueuesBroker.CreateNew: TEntity;
begin
  Result := TQueue.Create();
end;

///  выдает информацию о сущности с сервера
///  в случае ошибки возвращается nil
function TQueuesBroker.Info(AEntity: TEntity): TEntity;
begin

end;

///  выдает информацию о сущности с сервера по идентификатору
///  в случае ошибки возвращается nil
function TQueuesBroker.Info(AId: String): TEntity;
var
  URL: String;
  ResStr: String;
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  QueueObject: TJSONObject;

begin
  Result := TQueue.Create;
  URL := Format(constURLQueueGetOneInfo, [AId]);
  ResStr := MainModule.GET(URL);
  JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
  try
    ResponseObject := JSONResult.GetValue('response') as TJSONObject;
    QueueObject := ResponseObject.GetValue('Queue') as TJSONObject;
///    Result.DataToEntity(QueueObject);
  finally
    JSONResult.Free;
//    if Assigned(ResponseObject) then
//      ResponseObject.Free;
//    if Assigned(QueueObject) then
//      QueueObject.Free;
  end;
end;

///  создает на сервере новый класс сущности
///  в случае ошибки возвращается false
function TQueuesBroker.New(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONQueue: TJSONObject;
  JSONRequest: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;
begin
  URL := constURLQueueInsert;
///  AEntity.DataFromEntity(JSONQueue);
  JSONRequest := FuncUnit.ExtractJSONProperties(JSONQueue, ['name', 'caption','Queues','attr']);
  JSONRequestStream := TStringStream.Create(JSONRequest.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainModule.POST(URL, JSONRequestStream);
  finally
    JSONQueue.Free;
    JSONRequest.Free;
    JSONRequestStream.Free;
  end;
end;

///  обновить параметры сущности на сервере
///  в случае ошибки возвращается false
function TQueuesBroker.Update(AEntity: TEntity): Boolean;
var
  URL: String;
  ResStr: String;
  JSONQueue: TJSONObject;
  JSONRequest: TJSONObject;
  JSONRequestStream: TStringStream;

begin
(*!!!  Result := False;
  URL := Format(constURLQueueUpdate, [AId]);
  JSONQueue := AQueue.ToJSON;
  JSONRequest := Common_Func.ExtractJSONProperties(JSONQueue, ['caption','Queues','attr']);
  JSONRequestStream := TStringStream.Create(JSONRequest.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainModule.POST(URL, JSONRequestStream);
  finally
    JSONQueue.Free;
    JSONRequest.Free;
    JSONRequestStream.Free;
  end; *)
end;

///  удалить сущность на сервере
///  в случае ошибки возвращается false
function TQueuesBroker.Remove(AEntity: TEntity): Boolean;
begin

end;

///  удалить сущность на сервере по идентификатору
///  в случае ошибки возвращается false
function TQueuesBroker.Remove(AId: String): Boolean;
var
  URL: String;
  ResStr: String;
begin
  URL := Format(constURLQueueDelete, [AId]);
  ResStr := MainModule.GET(URL)
end;

end.
