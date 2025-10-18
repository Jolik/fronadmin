unit AbonentsBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit, AbonentUnit, EntityBrokerUnit;

type
  /// <summary>
  ///   Broker for working with router abonents API.
  /// </summary>
  TAbonentsBroker = class(TEntityBroker)
  private
  protected
    ///  возвращает весь путь до API
    function GetBasePath: string; override;
    class function ClassType: TEntityClass; override;
    class function ListClassType: TEntityListClass; override;
    class function ResponseClassType: TResponseClass; override;
  public
    function List(
      out APageCount: Integer;
      const APage: Integer = 0;
      const APageSize: Integer = 50;
      const ASearchStr: String = '';
      const ASearchBy: String = '';
      const AOrder: String = 'name';
      const AOrderDir: String = 'asc'): TEntityList; override;

    function CreateNew(): TEntity; override;
    function New(AEntity: TEntity): Boolean; override;
    function Info(AId: String): TEntity; overload; override;
    function Update(AEntity: TEntity): Boolean; override;
    function Remove(AId: String): Boolean; overload; override;
  end;

implementation

uses
  System.SysUtils, System.Classes,
  FuncUnit,
  APIConst;

const
  constURLAbonentList = '/abonents/list';
  constURLAbonentInfo = '/abonents/%s';
  constURLAbonentNew = '/abonents/new';
  constURLAbonentUpdate = '/abonents/%s/update';
  constURLAbonentRemove = '/abonents/%s/remove';

type
  ///  класс - парсер ответа API TResponse
  TAbonentsResponse = class(TResponse)
  private
    FAbid: string;
  protected
  public
    ///  парсинг ответа
    function ParseResponse(AResStr: string): boolean; override;

    ///  идентификатор абонента в ответе АПИ
    property Abid: string read FAbid;

  end;

{ TAbonentsBroker }

class function TAbonentsBroker.ClassType: TEntityClass;
begin
  Result := TAbonent;
end;

class function TAbonentsBroker.ListClassType: TEntityListClass;
begin
  Result := TAbonentList;
end;

function TAbonentsBroker.List(
  out APageCount: Integer;
  const APage, APageSize: Integer;
  const ASearchStr, ASearchBy, AOrder, AOrderDir: String): TEntityList;
var
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  AbonentsValue: TJSONValue;
  ItemsArray: TJSONArray;
  RequestStream: TStringStream;
  ResStr: String;
  InfoObject: TJSONObject;
  ItemsValue: TJSONValue;
  RequestObject: TJSONObject;
begin
  Result := nil;
  APageCount := 0;

  try
    JSONResult := nil;
    RequestObject := TJSONObject.Create;
    try
      RequestStream := TStringStream.Create(RequestObject.ToJSON, TEncoding.UTF8);
      try
        ResStr := MainHttpModuleUnit.POST(GetBasePath + constURLAbonentList, RequestStream);
        JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
        if not Assigned(JSONResult) then
          Exit;

        ResponseObject := JSONResult.GetValue('response') as TJSONObject;
        if not Assigned(ResponseObject) then
          Exit;

        InfoObject := ResponseObject.GetValue('info') as TJSONObject;
        if Assigned(InfoObject) then
          APageCount := GetValueIntDef(InfoObject, 'pagecount', 0);

        AbonentsValue := ResponseObject.GetValue('abonents');
        ItemsArray := nil;

        if AbonentsValue is TJSONArray then
          ItemsArray := TJSONArray(AbonentsValue)
        else if AbonentsValue is TJSONObject then
        begin
          ItemsValue := TJSONObject(AbonentsValue).GetValue('items');
          if ItemsValue is TJSONArray then
            ItemsArray := TJSONArray(ItemsValue);
        end;

        Result := ListClassType.Create(ItemsArray);

      finally
        RequestStream.Free;
      end;
    finally
      JSONResult.Free;
      RequestObject.Free;
    end;

  except on E: Exception do
    begin
      Log('TAbonentsBroker.List ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TAbonentsBroker.CreateNew: TEntity;
begin
  Result := ClassType.Create();
end;

function TAbonentsBroker.GetBasePath: string;
begin
  Result := constURLRouterBasePath;
end;

function TAbonentsBroker.Info(AId: String): TEntity;
var
  URL: String;
  ResStr: String;
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  AbonentValue: TJSONValue;
begin
  Result := nil;

  if AId = '' then
    Exit;

  try
    URL := Format(GetBasePath + constURLAbonentInfo, [AId]);

    ResStr := MainHttpModuleUnit.GET(URL);

    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;

    try
      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      if not Assigned(ResponseObject) then
        Exit;

      AbonentValue := ResponseObject.GetValue('abonent');

      if AbonentValue is TJSONObject then
        Result := ClassType.Create(TJSONObject(AbonentValue));

    finally
      JSONResult.Free;
    end;

  except on E: Exception do
    begin
      Log('TAbonentsBroker.Info ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TAbonentsBroker.New(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONAbonent: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;
begin
  Result := False;

  if not Assigned(AEntity) then
    Exit;

  try
    URL := GetBasePath + constURLAbonentNew;
    JSONAbonent := TJSONObject.Create;
    try
      AEntity.Serialize(JSONAbonent);

      JSONRequestStream := TStringStream.Create(JSONAbonent.ToJSON, TEncoding.UTF8);
      try
        ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);
        ///  парсим ответ
        var res := ResponseClassType.CreateWithResponse(ResStr);
        try
          Result := res.ResBool;
        finally
          res.Free;
        end;
      finally
        JSONRequestStream.Free;
      end;
    finally
      JSONAbonent.Free;
    end;
  except on E: Exception do
    begin
      Log('TAbonentsBroker.New ' + E.Message, lrtError);
      Result := False;
    end;
  end;
end;

function TAbonentsBroker.Remove(AId: String): Boolean;
var
  URL: String;
  ResStr: String;
begin
  Result := False;

  if AId = '' then
    Exit;

  try
    URL := Format(GetBasePath + constURLAbonentRemove, [AId]);

    ///  вызываем без параметров
    ResStr := MainHttpModuleUnit.POST(URL);
    ///  парсим ответ
    var res := ResponseClassType.CreateWithResponse(ResStr);
    try
      Result := res.ResBool;
    finally
      res.Free;
    end;
  except on E: Exception do
    begin
      Log('TAbonentsBroker.Remove ' + E.Message, lrtError);
      Result := False;
    end;
  end;
end;

class function TAbonentsBroker.ResponseClassType: TResponseClass;
begin
  Result := TAbonentsResponse;
end;

function TAbonentsBroker.Update(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONAbonent: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;
  AbonentId: string;
begin
  Result := False;

  if not Assigned(AEntity) then
    Exit;

  AbonentId := AEntity.Id;
  if AbonentId = '' then
    Exit;

  try
    URL := Format(GetBasePath + constURLAbonentUpdate, [AbonentId]);
    JSONAbonent := TJSONObject.Create;
    try
      AEntity.Serialize(JSONAbonent);

      JSONRequestStream := TStringStream.Create(JSONAbonent.ToJSON, TEncoding.UTF8);
      try
        ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);
        ///  парсим ответ
        var res := ResponseClassType.CreateWithResponse(ResStr);
        try
          /// получаем параметры ответа и устанавливаем идентификатор сущности
          (AEntity as TAbonent).Abid := (res as TAbonentsResponse).Abid;
          Result := res.ResBool;
        finally
          res.Free;
        end;
      finally
        JSONRequestStream.Free;
      end;
    finally
      JSONAbonent.Free;
    end;
  except on E: Exception do
    begin
      Log('TAbonentsBroker.Update ' + E.Message, lrtError);
      Result := False;
    end;
  end;
end;

{ TAbonentsResponse }

function TAbonentsResponse.ParseResponse(AResStr: string): boolean;
begin
  Result := inherited ParseResponse(AResStr);
end;

end.

