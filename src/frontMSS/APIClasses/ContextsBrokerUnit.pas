unit ContextsBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit, ContextUnit, EntityBrokerUnit;

type
  /// <summary>Broker for dataserver source contexts API.</summary>
  TContextsBroker = class(TEntityBroker)
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
  constURLContextsList = '/sources/contexts/list';
  constURLContextsInfo = '/sources/contexts/%s';
  constURLContextsNew = '/sources/contexts/new';
  constURLContextsUpdate = '/sources/contexts/%s/update';
  constURLContextsRemove = '/sources/contexts/%s/remove';

{ TContextsBroker }

function TContextsBroker.GetBasePath: string;
begin
  Result := constURLDataserverBasePath;
end;

class function TContextsBroker.ClassType: TEntityClass;
begin
  Result := TContext;
end;

class function TContextsBroker.ListClassType: TEntityListClass;
begin
  Result := TContextList;
end;

function TContextsBroker.List(out APageCount: Integer; const APage,
  APageSize: Integer; const ASearchStr, ASearchBy, AOrder,
  AOrderDir: String): TEntityList;
var
  JSONResult: TJSONObject;
  ResponseObject, ContextsObject
  : TJSONObject;
  ItemsValue: TJSONValue;
  ItemsArray: TJSONArray;
  RequestStream: TStringStream;
  ResStr: string;
  InfoObject: TJSONObject;
begin
  Result := nil;
  APageCount := 0;

  try
    JSONResult := nil;
    RequestStream := TStringStream.Create('{}', TEncoding.UTF8);
    try
      ResStr := MainHttpModuleUnit.POST(GetBasePath + constURLContextsList, RequestStream);
      JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
      if not Assigned(JSONResult) then
        Exit;

      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      if not Assigned(ResponseObject) then
        Exit;

      InfoObject := ResponseObject.GetValue('info') as TJSONObject;
      if Assigned(InfoObject) then
        APageCount := GetValueIntDef(InfoObject, 'pagecount', 0);

      ContextsObject := ResponseObject.GetValue('contexts') as TJSONObject;
      if not Assigned(ContextsObject) then
        Exit;

      ItemsValue := TJSONObject(ContextsObject).GetValue('items');

      if ItemsValue is TJSONArray then
        ItemsArray := ItemsValue as TJSONArray
      else
        ItemsArray := nil;

      Result := ListClassType.Create(ItemsArray);
    finally
      JSONResult.Free;
      RequestStream.Free;
    end;
  except
    on E: Exception do
    begin
      Log('TContextsBroker.List ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TContextsBroker.CreateNew: TEntity;
begin
  Result := ClassType.Create;
end;

function TContextsBroker.Info(AId: String): TEntity;
var
  URL: string;
  ResStr: string;
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  ContextValue: TJSONValue;
begin
  Result := nil;

  if AId = '' then
    Exit;

  try
    URL := Format(GetBasePath + constURLContextsInfo, [AId]);

    ResStr := MainHttpModuleUnit.GET(URL);

    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
    try
      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      if not Assigned(ResponseObject) then
        Exit;

      ContextValue := ResponseObject.GetValue('context');
      if ContextValue is TJSONObject then
        Result := ClassType.Create(ContextValue as TJSONObject);
    finally
      JSONResult.Free;
    end;
  except
    on E: Exception do
    begin
      Log('TContextsBroker.Info ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TContextsBroker.New(AEntity: TEntity): Boolean;
var
  URL: string;
  JSONContext: TJSONObject;
  JSONRequestStream: TStringStream;
begin
  Result := false;

  if not Assigned(AEntity) then
    Exit;

  URL := GetBasePath + constURLContextsNew;
  JSONContext := AEntity.Serialize();

  JSONRequestStream := TStringStream.Create(JSONContext.ToJSON, TEncoding.UTF8);
  try
    MainHttpModuleUnit.POST(URL, JSONRequestStream);
    Result := true;
  finally
    JSONContext.Free;
    JSONRequestStream.Free;
  end;
end;

function TContextsBroker.Update(AEntity: TEntity): Boolean;
var
  URL: string;
  JSONRequest: TJSONObject;
  JSONData: TJSONValue;
  Context: TContext;
  JSONRequestStream: TStringStream;
begin
  Result := false;

  if not Assigned(AEntity) then
    Exit;

  if AEntity.Id = '' then
    Exit;

  URL := Format(GetBasePath + constURLContextsUpdate, [AEntity.Id]);

  JSONRequest := TJSONObject.Create;
  try
    Context := AEntity as TContext;
    if Assigned(Context.Data) then
      JSONData := Context.Data.Clone as TJSONValue
    else
      JSONData := TJSONObject.Create;
    JSONRequest.AddPair('data', JSONData);

    JSONRequestStream := TStringStream.Create(JSONRequest.ToJSON, TEncoding.UTF8);
    try
      MainHttpModuleUnit.POST(URL, JSONRequestStream);
      Result := true;
    finally
      JSONRequestStream.Free;
    end;
  finally
    JSONRequest.Free;
  end;
end;

function TContextsBroker.Remove(AId: String): Boolean;
var
  URL: string;
  JSONRequestStream: TStringStream;
begin
  Result := false;

  if AId = '' then
    Exit;

  URL := Format(GetBasePath + constURLContextsRemove, [AId]);

  JSONRequestStream := TStringStream.Create('{}', TEncoding.UTF8);
  try
    MainHttpModuleUnit.POST(URL, JSONRequestStream);
    Result := true;
  finally
    JSONRequestStream.Free;
  end;
end;

end.
