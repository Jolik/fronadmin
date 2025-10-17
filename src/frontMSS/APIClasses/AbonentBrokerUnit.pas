unit AbonentBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit, AbonentUnit, ParentBrokerUnit;

type
  /// <summary>
  ///   Broker for working with router abonents API.
  /// </summary>
  TAbonentBroker = class(TParentBroker)
  protected
    function BaseUrlPath: string; override;
    class function ClassType: TEntityClass; override;
    class function ListClassType: TEntityListClass; override;
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

{ TAbonentBroker }

function TAbonentBroker.BaseUrlPath: string;
begin
  Result := constURLRouterBasePath;
end;

class function TAbonentBroker.ClassType: TEntityClass;
begin
  Result := TAbonent;
end;

class function TAbonentBroker.ListClassType: TEntityListClass;
begin
  Result := TAbonentList;
end;

function TAbonentBroker.List(
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
        ResStr := MainHttpModuleUnit.POST(BaseUrlPath + constURLAbonentList, RequestStream);
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
      Log('TAbonentBroker.List ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TAbonentBroker.CreateNew: TEntity;
begin
  Result := ClassType.Create();
end;

function TAbonentBroker.Info(AId: String): TEntity;
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
    URL := Format(BaseUrlPath + constURLAbonentInfo, [AId]);

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
      Log('TAbonentBroker.Info ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TAbonentBroker.New(AEntity: TEntity): Boolean;
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
    URL := BaseUrlPath + constURLAbonentNew;
    JSONAbonent := TJSONObject.Create;
    try
      AEntity.Serialize(JSONAbonent);

      JSONRequestStream := TStringStream.Create(JSONAbonent.ToJSON, TEncoding.UTF8);
      try
        ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);
        Result := CheckResponseResult(ResStr);
      finally
        JSONRequestStream.Free;
      end;
    finally
      JSONAbonent.Free;
    end;
  except on E: Exception do
    begin
      Log('TAbonentBroker.New ' + E.Message, lrtError);
      Result := False;
    end;
  end;
end;

function TAbonentBroker.Remove(AId: String): Boolean;
var
  URL: String;
  ResStr: String;
begin
  Result := False;

  if AId = '' then
    Exit;

  try
    URL := Format(BaseUrlPath + constURLAbonentRemove, [AId]);
    ResStr := MainHttpModuleUnit.DELETE(URL);
    Result := CheckResponseResult(ResStr);
  except on E: Exception do
    begin
      Log('TAbonentBroker.Remove ' + E.Message, lrtError);
      Result := False;
    end;
  end;
end;

function TAbonentBroker.Update(AEntity: TEntity): Boolean;
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
    URL := Format(BaseUrlPath + constURLAbonentUpdate, [AbonentId]);
    JSONAbonent := TJSONObject.Create;
    try
      AEntity.Serialize(JSONAbonent);

      JSONRequestStream := TStringStream.Create(JSONAbonent.ToJSON, TEncoding.UTF8);
      try
        ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);
        Result := CheckResponseResult(ResStr);
      finally
        JSONRequestStream.Free;
      end;
    finally
      JSONAbonent.Free;
    end;
  except on E: Exception do
    begin
      Log('TAbonentBroker.Update ' + E.Message, lrtError);
      Result := False;
    end;
  end;
end;

end.

