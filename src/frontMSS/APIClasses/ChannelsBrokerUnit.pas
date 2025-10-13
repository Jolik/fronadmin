unit ChannelsBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit, ChannelUnit, ParentBrokerUnit;


type
  ///  брокер для API Channels
  TChannelsBroker = class (TParentBroker)
    /// возвращает список каналов
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
  constURLChannelGetList = '/router/api/v2/Channels/list';
  constURLChannelGetOneInfo = '/router/api/v2/Channels/%s';
  constURLChannelInsert = '/router/api/v2/Channels/new';
  constURLChannelUpdate = '/router/api/v2/Channels/%s/update';
  constURLChannelDelete = '/router/api/v2/rou/%s/remove';

{ TChannelsBroker }

//function TChannelsBroker.ChannelGetList(
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
//  URL := constURLChannelGetList;
//  JSONRequest := CreateJSONRequest;
//  JSONResult := TJSONObject.Create;
//  try
//    Result.FieldDefs.Add('abid', ftGuid);
//    Result.FieldDefs.Add('name', ftString, 256);
//    Result.FieldDefs.Add('caption', ftString, 256);
//    Result.FieldDefs.Add('created', ftDateTime);
//    Result.FieldDefs.Add('updated', ftDateTime);
//
//    ResStr := MainHttpModule.POST(constURLChannelGetList, JSONRequest.ToJSON);
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
function TChannelsBroker.List(
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
  Result := TChannelList.Create();

  URL := constURLChannelGetList;
  JSONRequest := CreateJSONRequest;
//  JSONRequestStream := TStringStream.Create(JSONRequest.ToJSON, TEncoding.UTF8);
  JSONRequestStream := TStringStream.Create('{}', TEncoding.UTF8);
  JSONResult := TJSONObject.Create;
  try
    ResStr := MainHttpModuleUnit.POST(constURLChannelGetList, JSONRequestStream);
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
//    if Assigned(ChannelsObjectArray) then
//      ChannelsObjectArray.Free;
  end;
end;

function TChannelsBroker.CreateNew: TEntity;
begin
  Result := TChannel.Create();
end;

///  выдает информацию о сущности с сервера
///  в случае ошибки возвращается nil
function TChannelsBroker.Info(AEntity: TEntity): TEntity;
begin

end;

///  выдает информацию о сущности с сервера по идентификатору
///  в случае ошибки возвращается nil
function TChannelsBroker.Info(AId: String): TEntity;
var
  URL: String;
  ResStr: String;
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;

begin
  Result := TChannel.Create;
  URL := Format(constURLChannelGetOneInfo, [AId]);
  ResStr := MainHttpModuleUnit.GET(URL);
  JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
  try
    ResponseObject := JSONResult.GetValue('response') as TJSONObject;

  finally
    JSONResult.Free;
//    if Assigned(ResponseObject) then
//      ResponseObject.Free;
//    if Assigned(ChannelObject) then
//      ChannelObject.Free;
  end;
end;

///  создает на сервере новый класс сущности
///  в случае ошибки возвращается false
function TChannelsBroker.New(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONRequest: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;

begin
  (*!!! URL := constURLChannelInsert;
  AEntity.DataFromEntity(JSONChannel);
  JSONRequest := FuncUnit.ExtractJSONProperties(JSONChannel, ['name', 'caption','channels','attr']);
  JSONRequestStream := TStringStream.Create(JSONRequest.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModule.POST(URL, JSONRequestStream);
  finally
    JSONChannel.Free;
    JSONRequest.Free;
    JSONRequestStream.Free;
  end; *)
end;

///  обновить параметры сущности на сервере
///  в случае ошибки возвращается false
function TChannelsBroker.Update(AEntity: TEntity): Boolean;
var
  URL: String;
  ResStr: String;
  JSONRequest: TJSONObject;
  JSONRequestStream: TStringStream;

begin
(*!!!  Result := False;
  URL := Format(constURLChannelUpdate, [AId]);
  JSONRequest := Common_Func.ExtractJSONProperties(JSONChannel, ['caption','channels','attr']);
  JSONRequestStream := TStringStream.Create(JSONRequest.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModule.POST(URL, JSONRequestStream);
  finally
    JSONRequest.Free;
    JSONRequestStream.Free;
  end; *)
end;

///  удалить сущность на сервере
///  в случае ошибки возвращается false
function TChannelsBroker.Remove(AEntity: TEntity): Boolean;
begin

end;

///  удалить сущность на сервере по идентификатору
///  в случае ошибки возвращается false
function TChannelsBroker.Remove(AId: String): Boolean;
var
  URL: String;
  ResStr: String;
begin
  URL := Format(constURLChannelDelete, [AId]);
  ResStr := MainHttpModuleUnit.GET(URL)
end;

end.
