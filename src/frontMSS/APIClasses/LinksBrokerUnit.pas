unit LinksBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit, LinkUnit, EntityBrokerUnit;


type
  ///  брокер для API Links
  TLinksBroker = class (TEntityBroker)
  protected
    ///  возвращает базовый путь до API
    function BaseUrlPath: string; override;
    ///  метод возвращает конкретный тип сущности с которым работает брокер
    ///  потомки должны переопределить его, потому что он у всех разный
    class function ClassType: TEntityClass; override;
    ///  метод возвращает конкретный тип объекта элемента списка
    ///  потомки должны переопределить его, потому что он у всех разный
    class function ListClassType: TEntityListClass; override;

  public
    /// возвращает список Задач
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

  end;

implementation

uses
  System.SysUtils, System.Classes,
  FuncUnit,
  APIConst;

const
  constURLLinkGetList = '/links/list';
  constURLLinkGetOneInfo = '/links/%s/info';
  constURLLinkNew = '/links/new';
  constURLLinkUpdate = '/links/%s/update';
  constURLLinkDelete = '/links/%s/remove';

{ TLinksBroker }

function TLinksBroker.BaseUrlPath: string;
begin
  Result := constURLDatacommBasePath;
end;

class function TLinksBroker.ClassType: TEntityClass;
begin
  Result := TLink;
end;

class function TLinksBroker.ListClassType: TEntityListClass;
begin
  Result := TLinkList;
end;

/// возвращает список задач
///  в случае ошибки возвращается nil
function TLinksBroker.List(
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
  LinkArray: TJSONArray;
  ResStr: String;

begin

  Result := nil;

  try

    JSONResult := TJSONObject.Create;
    try
      ///  делаем запрос
      ResStr := MainHttpModuleUnit.GET(BaseUrlPath + constURLLinkGetList);
      ///  парсим результат
      JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
      ///  объект - ответ
      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      ///  список линков
      LinkArray := ResponseObject.GetValue('links') as TJSONArray;

      Result := ListClassType.Create(LinkArray);

    finally
      JSONResult.Free;
    end;

  except on e:exception do
    begin
      Log('TLinksBroker.List '+ e.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TLinksBroker.CreateNew: TEntity;
begin
  Result := ClassType.Create();
end;

///  выдает информацию о сущности с сервера по идентификатору
///  в случае ошибки возвращается nil
function TLinksBroker.Info(AId: String): TEntity;
var
  URL: String;
  ResStr: String;
  JSONResult: TJSONObject;

begin

  Result := nil;

  if AId = '' then
    exit;

  try
    URL := Format(BaseUrlPath + constURLLinkGetOneInfo, [AId]);

    ResStr := MainHttpModuleUnit.GET(URL);

    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;

    try
      ///  находим JSON класс response
      var ResponseObject := JSONResult.GetValue('response') as TJSONObject;

      ///  парсим JSON класс Link
      Result := ClassType.Create(ResponseObject);

    finally
      JSONResult.Free;

    end;

  except on e:exception do
    begin
      Log('TLinksBroker.Info '+ e.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;

end;

///  создает на сервере новый класс сущности
///  в случае ошибки возвращается false
function TLinksBroker.New(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONLink: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;

begin
  ///  строим запрос
  URL := BaseUrlPath + constURLLinkNew;
  ///  получаем из сущности JSON
  JSONLink := AEntity.Serialize();

//  JSONRequest := FuncUnit.ExtractJSONProperties(JSONLink, ['name', 'caption','Links','attr']);

  JSONRequestStream := TStringStream.Create(JSONLink.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);

    ////  !!! обрабатываем ответ
    ///  пока возвращаем всегда true
    Result := true;

  finally
    JSONLink.Free;
    JSONRequestStream.Free;

  end;

end;

///  обновить параметры сущности на сервере
///  в случае ошибки возвращается false
function TLinksBroker.Update(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONLink: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;

begin
  ///  если пытаются передать не наш класс то не делаем ничего!
  if not (AEntity is TLink) then
    exit;

  ///  строим запрос
  URL := Format(BaseUrlPath + constURLLinkUpdate, [(AEntity as TLink).LId]);

  ///  получаем из сущности JSON
  JSONLink := AEntity.Serialize();

//  JSONRequest := FuncUnit.ExtractJSONProperties(JSONLink, ['name', 'caption','Links','attr']);

  JSONRequestStream := TStringStream.Create(JSONLink.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);

    ////  !!! обрабатываем ответ
    ///  пока возвращаем всегда true
    Result := true;

  finally
    JSONLink.Free;
    JSONRequestStream.Free;

  end;

end;

///  удалить сущность на сервере по идентификатору
///  в случае ошибки возвращается false
function TLinksBroker.Remove(AId: String): Boolean;
var
  URL: String;
  ResStr: String;
  JSONRequestStream: TStringStream;

begin
  URL := Format(BaseUrlPath + constURLLinkDelete, [AId]);

  JSONRequestStream := TStringStream.Create('{}', TEncoding.UTF8);

  ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream)

end;

end.
