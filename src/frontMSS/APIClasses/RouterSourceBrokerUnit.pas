unit RouterSourceBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  MainModule,
  LoggingUnit,
  EntityUnit, RouterSourceUnit, ParentBrokerUnit;

type
  ///    API Sources
  TRouterSourceBroker = class (TParentBroker)
  protected
    ///      API
    function BaseUrlPath: string; override;
    ///
    ///     ,
    class function ClassType: TEntityClass; override;
    ///
    ///     ,
    class function ListClassType: TEntityListClass; override;

  public
    ///
    ///      nil
    function List(
      out APageCount: Integer;
      const APage: Integer = 0;
      const APageSize: Integer = 50;
      const ASearchStr: String = '';
      const ASearchBy: String = '';
      const AOrder: String = 'name';
      const AOrderDir: String = 'asc'): TEntityList; override;

    ///
    ///      nil
    function CreateNew(): TEntity; override;
    ///
    ///      false
    function New(AEntity: TEntity): Boolean; override;
    ///
    ///      nil
    function Info(AId: String): TEntity; overload; override;
    ///
    ///      false
    function Update(AEntity: TEntity): Boolean; override;
    ///
    ///      false
    function Remove(AId: String): Boolean; overload; override;

  end;

implementation

uses
  System.SysUtils, System.Classes,
  FuncUnit,
  APIConst;

const
  constURLSourcesList = '/sources/list';
  constURLSourcesInfo = '/sources/%s';
  constURLSourcesNew = '/sources/new';
  constURLSourcesUpdate = '/sources/%s/update';
  constURLSourcesRemove = '/sources/%s/remove';

{ TRouterSourceBroker }

function TRouterSourceBroker.BaseUrlPath: string;
begin
  Result := constURLRouterBasePath;
end;

class function TRouterSourceBroker.ClassType: TEntityClass;
begin
  Result := TRouterSource;
end;

class function TRouterSourceBroker.ListClassType: TEntityListClass;
begin
  Result := TRouterSourceList;
end;

///
///      nil
function TRouterSourceBroker.List(
  out APageCount: Integer;
  const APage: Integer = 0;
  const APageSize: Integer = 50;
  const ASearchStr: String = '';
  const ASearchBy: String = '';
  const AOrder: String = 'name';
  const AOrderDir: String = 'asc'): TEntityList;
var
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  SourcesValue: TJSONValue;
  RequestStream: TStringStream;
  ResStr: String;
begin

  Result := nil;

  try

    JSONResult := nil;
    RequestStream := TStringStream.Create('{}', TEncoding.UTF8);
    try
      ///    -
      ResStr := MainModule.POST(BaseUrlPath + constURLSourcesList, RequestStream);
      ///
      JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
      if not Assigned(JSONResult) then
        exit;
      ///   -
      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      if not Assigned(ResponseObject) then
        exit;
      ///
      SourcesValue := ResponseObject.GetValue('sources');
      if not Assigned(SourcesValue) then
        exit;

      if SourcesValue is TJSONArray then
        Result := ListClassType.Create(SourcesValue as TJSONArray)
      else if SourcesValue is TJSONObject then
      begin
        var ItemsArray := (SourcesValue as TJSONObject).GetValue('items') as TJSONArray;
        Result := ListClassType.Create(ItemsArray);
      end;

    finally
      JSONResult.Free;
      RequestStream.Free;
    end;

  except on e:exception do
    begin
      Log('TRouterSourceBroker.List '+ e.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TRouterSourceBroker.CreateNew: TEntity;
begin
  Result := ClassType.Create();
end;

///
///      nil
function TRouterSourceBroker.Info(AId: String): TEntity;
var
  URL: String;
  ResStr: String;
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  SourceValue: TJSONValue;
begin

  Result := nil;

  if AId = '' then
    exit;

  try
    URL := Format(BaseUrlPath + constURLSourcesInfo, [AId]);

    ResStr := MainModule.GET(URL);

    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;

    try
      ///   JSON  response
      ResponseObject := JSONResult.GetValue('response') as TJSONObject;

      ///   JSON  response
      SourceValue := ResponseObject.GetValue('source');

      if SourceValue is TJSONObject then
        Result := ClassType.Create(SourceValue as TJSONObject);

    finally
      JSONResult.Free;

    end;

  except on e:exception do
    begin
      Log('TRouterSourceBroker.Info '+ e.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;

end;

///
///      false
function TRouterSourceBroker.New(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONSource: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;
begin
  Result := false;

  ///
  URL := BaseUrlPath + constURLSourcesNew;
  ///     JSON
  JSONSource := AEntity.Serialize();

  JSONRequestStream := TStringStream.Create(JSONSource.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainModule.POST(URL, JSONRequestStream);

    ////  !!!
    ///     true
    Result := true;

  finally
    JSONSource.Free;
    JSONRequestStream.Free;

  end;

end;

///
///      false
function TRouterSourceBroker.Update(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONSource: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;
begin
  Result := false;

  ///           !
  if not (AEntity is TRouterSource) then
    exit;

  ///
  URL := Format(BaseUrlPath + constURLSourcesUpdate, [(AEntity as TRouterSource).Who]);

  ///     JSON
  JSONSource := AEntity.Serialize();

  JSONRequestStream := TStringStream.Create(JSONSource.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainModule.POST(URL, JSONRequestStream);

    ////  !!!
    ///     true
    Result := true;

  finally
    JSONSource.Free;
    JSONRequestStream.Free;

  end;

end;

///
///      false
function TRouterSourceBroker.Remove(AId: String): Boolean;
var
  URL: String;
  ResStr: String;
  JSONRequestStream: TStringStream;
begin
  Result := false;

  URL := Format(BaseUrlPath + constURLSourcesRemove, [AId]);

  JSONRequestStream := TStringStream.Create('{}', TEncoding.UTF8);
  try
    ResStr := MainModule.POST(URL, JSONRequestStream);

    Result := true;
  finally
    JSONRequestStream.Free;
  end;
end;

end.
