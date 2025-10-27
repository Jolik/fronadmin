unit AliasesBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit, AliasUnit, EntityBrokerUnit;

type
  /// <summary>
  ///   Broker for working with router aliases API.
  /// </summary>
  TAliasesBroker = class(TEntityBroker)
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
  constURLAliasesList = '/aliases/list';
  constURLAliasesInfo = '/aliases/%s';
  constURLAliasesNew = '/aliases/new';
  constURLAliasesUpdate = '/aliases/%s/update';
  constURLAliasesRemove = '/aliases/%s/remove';

{ TAliasesBroker }

function TAliasesBroker.GetBasePath: string;
begin
  Result := constURLRouterBasePath;
end;

class function TAliasesBroker.ClassType: TEntityClass;
begin
  Result := TAlias;
end;

class function TAliasesBroker.ListClassType: TEntityListClass;
begin
  Result := TAliasList;
end;

function TAliasesBroker.List(
  out APageCount: Integer;
  const APage: Integer;
  const APageSize: Integer;
  const ASearchStr, ASearchBy, AOrder, AOrderDir: String): TEntityList;
var
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  AliasesValue: TJSONValue;
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
        ResStr := MainHttpModuleUnit.POST(GetBasePath + constURLAliasesList, RequestStream);
        JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
        if not Assigned(JSONResult) then
          Exit;

        ResponseObject := JSONResult.GetValue('response') as TJSONObject;
        if not Assigned(ResponseObject) then
          Exit;

        InfoObject := ResponseObject.GetValue('info') as TJSONObject;
        if Assigned(InfoObject) then
          APageCount := GetValueIntDef(InfoObject, 'pagecount', 0);

        AliasesValue := ResponseObject.GetValue('aliases');
        ItemsArray := nil;

        if AliasesValue is TJSONArray then
          ItemsArray := TJSONArray(AliasesValue)
        else if AliasesValue is TJSONObject then
        begin
          ItemsValue := TJSONObject(AliasesValue).GetValue('items');
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
      Log('TAliasesBroker.List ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TAliasesBroker.CreateNew: TEntity;
begin
  Result := ClassType.Create();
end;

function TAliasesBroker.Info(AId: String): TEntity;
var
  URL: String;
  ResStr: String;
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  AliasValue: TJSONValue;
begin
  Result := nil;

  if AId = '' then
    Exit;

  try
    URL := Format(GetBasePath + constURLAliasesInfo, [AId]);

    ResStr := MainHttpModuleUnit.GET(URL);

    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;

    try
      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      if not Assigned(ResponseObject) then
        Exit;

      AliasValue := ResponseObject.GetValue('alias');

      if AliasValue is TJSONObject then
        Result := ClassType.Create(TJSONObject(AliasValue));

    finally
      JSONResult.Free;
    end;

  except on E: Exception do
    begin
      Log('TAliasesBroker.Info ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TAliasesBroker.New(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONAlias: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;
begin
  Result := False;

  URL := GetBasePath + constURLAliasesNew;

  JSONAlias := AEntity.Serialize();

  JSONRequestStream := TStringStream.Create(JSONAlias.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);
    Result := True;
  finally
    JSONAlias.Free;
    JSONRequestStream.Free;
  end;
end;

function TAliasesBroker.Update(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONAlias: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;
begin
  Result := False;

  if not (AEntity is TAlias) then
    Exit;

  URL := Format(GetBasePath + constURLAliasesUpdate, [(AEntity as TAlias).Alid]);

  JSONAlias := AEntity.Serialize();

  JSONRequestStream := TStringStream.Create(JSONAlias.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);
    Result := True;
  finally
    JSONAlias.Free;
    JSONRequestStream.Free;
  end;
end;

function TAliasesBroker.Remove(AId: String): Boolean;
var
  URL: String;
  ResStr: String;
  JSONRequestStream: TStringStream;
begin
  Result := False;

  URL := Format(GetBasePath + constURLAliasesRemove, [AId]);

  JSONRequestStream := TStringStream.Create('{}', TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);
    Result := True;
  finally
    JSONRequestStream.Free;
  end;
end;

end.
