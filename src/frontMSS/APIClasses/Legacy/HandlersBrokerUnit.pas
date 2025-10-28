unit HandlersBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit, HandlerUnit, EntityBrokerUnit;

type
  /// <summary>
  ///   Broker for working with router handlers API.
  /// </summary>
  THandlersBroker = class(TEntityBroker)
  protected
    function GetBasePath: string; override;
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
  constURLHandlersList = '/handlers/list';
  constURLHandlersInfo = '/handlers/%s';
  constURLHandlersNew = '/handlers/new';
  constURLHandlersUpdate = '/handlers/%s/update';
  constURLHandlersRemove = '/handlers/%s/remove';

{ THandlersBroker }

function THandlersBroker.GetBasePath: string;
begin
  Result := constURLRouterBasePath;
end;

class function THandlersBroker.ClassType: TEntityClass;
begin
  Result := THandler;
end;

class function THandlersBroker.ListClassType: TEntityListClass;
begin
  Result := THandlerList;
end;

function THandlersBroker.List(
  out APageCount: Integer;
  const APage: Integer;
  const APageSize: Integer;
  const ASearchStr, ASearchBy, AOrder, AOrderDir: String): TEntityList;
var
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  HandlersValue: TJSONValue;
  ItemsArray: TJSONArray;
  RequestStream: TStringStream;
  ResStr: String;
  InfoObject: TJSONObject;
  RequestObject: TJSONObject;

begin
  Result := nil;
  APageCount := 0;

  try
    JSONResult := nil;
    RequestObject := TJSONObject.Create;
    try
(*!!!      RequestObject.AddPair('page', TJSONNumber.Create(APage));
      RequestObject.AddPair('pagesize', TJSONNumber.Create(APageSize));
      if ASearchStr <> '' then
        RequestObject.AddPair('searchStr', ASearchStr);
      if ASearchBy <> '' then
        RequestObject.AddPair('searchBy', ASearchBy);
      if AOrder <> '' then
        RequestObject.AddPair('order', AOrder);
      if AOrderDir <> '' then
        RequestObject.AddPair('orderDir', AOrderDir);*)

      RequestStream := TStringStream.Create(RequestObject.ToJSON, TEncoding.UTF8);
      try
        ResStr := MainHttpModuleUnit.GET(GetBasePath + constURLHandlersList);
        JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
        if not Assigned(JSONResult) then
          Exit;

        ResponseObject := JSONResult.GetValue('response') as TJSONObject;
        if not Assigned(ResponseObject) then
          Exit;

        InfoObject := ResponseObject.GetValue('info') as TJSONObject;
        if Assigned(InfoObject) then
          APageCount := GetValueIntDef(InfoObject, 'pagecount', 0);

        HandlersValue := ResponseObject.GetValue('handlers');
        ItemsArray := nil;

        if HandlersValue is TJSONArray then
        begin
          ItemsArray := TJSONArray(HandlersValue);
          Result := ListClassType.Create(ItemsArray);
        end;


      finally
        RequestStream.Free;
      end;
    finally
      JSONResult.Free;
      RequestObject.Free;
    end;

  except on E: Exception do
    begin
      Log('THandlersBroker.List ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function THandlersBroker.CreateNew: TEntity;
begin
  Result := ClassType.Create();
end;

function THandlersBroker.Info(AId: String): TEntity;
var
  URL: String;
  ResStr: String;
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  HandlerValue: TJSONValue;
begin
  Result := nil;

  if AId = '' then
    Exit;

  try
    URL := Format(GetBasePath + constURLHandlersInfo, [AId]);

    ResStr := MainHttpModuleUnit.GET(URL);

    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;

    try
      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      if not Assigned(ResponseObject) then
        Exit;

      HandlerValue := ResponseObject.GetValue('handler');

      if HandlerValue is TJSONObject then
        Result := ClassType.Create(TJSONObject(HandlerValue));

    finally
      JSONResult.Free;
    end;

  except on E: Exception do
    begin
      Log('THandlersBroker.Info ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function THandlersBroker.New(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONHandler: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;
begin
  Result := False;

  URL := GetBasePath + constURLHandlersNew;

  JSONHandler := AEntity.Serialize();

  JSONRequestStream := TStringStream.Create(JSONHandler.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);
    Result := True;
  finally
    JSONHandler.Free;
    JSONRequestStream.Free;
  end;
end;

function THandlersBroker.Update(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONHandler: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;
begin
  Result := False;

  if not (AEntity is THandler) then
    Exit;

  URL := Format(GetBasePath + constURLHandlersUpdate, [(AEntity as THandler).Hid]);

  JSONHandler := AEntity.Serialize();

  JSONRequestStream := TStringStream.Create(JSONHandler.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);
    Result := True;
  finally
    JSONHandler.Free;
    JSONRequestStream.Free;
  end;
end;

function THandlersBroker.Remove(AId: String): Boolean;
var
  URL: String;
  ResStr: String;
  JSONRequestStream: TStringStream;
begin
  Result := False;

  URL := Format(GetBasePath + constURLHandlersRemove, [AId]);

  JSONRequestStream := TStringStream.Create('{}', TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);
    Result := True;
  finally
    JSONRequestStream.Free;
  end;
end;

end.
