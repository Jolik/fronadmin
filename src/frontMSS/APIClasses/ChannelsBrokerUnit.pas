unit ChannelsBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit, ChannelUnit, EntityBrokerUnit;


type
  ///  брокер для API Channels
  TChannelsBroker = class (TEntityBroker)
  protected
    function GetBasePath: string; override;
    class function ClassType: TEntityClass; override;
    class function ListClassType: TEntityListClass; override;
  public
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
  System.SysUtils, System.Classes, APIConst,
  FuncUnit;

const
  constURLChannelGetList = '/channels/list';
  constURLChannelGetOneInfo = '/channels/%s';
  constURLChannelInsert = '/channels/new';
  constURLChannelUpdate = '/channels/%s/update';
  constURLChannelDelete = '/channels/%s/remove';

{ TChannelsBroker }

class function TChannelsBroker.ClassType: TEntityClass;
begin
  Result:=  TChannel;
end;

class function TChannelsBroker.ListClassType: TEntityListClass;
begin
  Result:= TChannelList;
end;

function TChannelsBroker.CreateNew: TEntity;
begin
  Result := TChannel.Create();
end;

function TChannelsBroker.GetBasePath: string;
begin
  Result := constURLRouterBasePath;
end;




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

  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  InfoObject: TJSONObject;
  chArr:  TJSONArray;
  ResStr: String;

begin
  Result := TChannelList.Create();

  URL := GetBasePath+constURLChannelGetList;
  JSONRequest := CreateJSONRequest;
  JSONResult := TJSONObject.Create;
  try
    ResStr := MainHttpModuleUnit.GET(URL);
    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
    ResponseObject := JSONResult.GetValue('response') as TJSONObject;
    InfoObject := ResponseObject.GetValue('info') as TJSONObject;
    APageCount := InfoObject.GetValue<Integer>('pagecount');
    chArr := ResponseObject.GetValue('channels') as TJSONArray;
    Result := ListClassType.Create(chArr);
//    JSONResult.GetValue
  finally
    JSONRequest.Free;
    JSONResult.Free;
  end;
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
  URL := Format(GetBasePath+constURLChannelGetOneInfo, [AId]);
  ResStr := MainHttpModuleUnit.GET(URL);
  JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
  try
    ResponseObject := JSONResult.GetValue('response') as TJSONObject;
    Result := ClassType.Create(ResponseObject.GetValue('channel') as TJSONObject);
  finally
    JSONResult.Free;
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
