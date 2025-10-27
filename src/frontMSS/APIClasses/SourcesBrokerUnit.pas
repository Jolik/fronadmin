unit SourcesBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit, SourceUnit, EntityBrokerUnit;

type
  /// <summary>
  ///   Broker for working with dataserver sources API.
  /// </summary>
  TSourcesBroker = class(TEntityBroker)
  protected
    /// <summary>Base path for dataserver sources API.</summary>
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
    function Info(AId: String): TEntity; overload; override;
  end;

implementation

uses
  System.SysUtils, System.Classes,
  FuncUnit,
  APIConst;

const
  constURLSourcesList = '/list';
  constURLSourcesInfo = '/%s';
  constURLSourcesNew = '/new';
  constURLSourcesUpdate = '/%s/update';
  constURLSourcesRemove = '/%s/remove';

{ TSourcesBroker }

class function TSourcesBroker.ClassType: TEntityClass;
begin
  Result := TSource;
end;

function TSourcesBroker.CreateNew: TEntity;
begin
  Result := ClassType.Create();
end;

function TSourcesBroker.GetBasePath: string;
begin
  Result := constURLDataserverBasePath + '/sources';
end;

function TSourcesBroker.Info(AId: String): TEntity;
var
  URL: String;
  ResStr: String;
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  SourceValue: TJSONValue;
begin
  Result := nil;

  if AId = '' then
    Exit;

  try
    URL := Format(GetBasePath + constURLSourcesInfo, [AId]);

    ResStr := MainHttpModuleUnit.GET(URL);

    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;

    try
      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      if not Assigned(ResponseObject) then
        Exit;

      SourceValue := ResponseObject.GetValue('source');

      if SourceValue is TJSONObject then
        Result := ClassType.Create(TJSONObject(SourceValue));

    finally
      JSONResult.Free;
    end;

  except on E: Exception do
    begin
      Log('TSourcesBroker.Info ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TSourcesBroker.List(
  out APageCount: Integer;
  const APage, APageSize: Integer;
  const ASearchStr, ASearchBy, AOrder, AOrderDir: String): TEntityList;
var
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  SourcesValue: TJSONValue;
  ItemsArray: TJSONArray;
  ItemsValue: TJSONValue;
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
      RequestStream := TStringStream.Create(RequestObject.ToJSON, TEncoding.UTF8);
      try
        ResStr := MainHttpModuleUnit.POST(GetBasePath + constURLSourcesList, RequestStream);
        JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
        if not Assigned(JSONResult) then
          Exit;

        ResponseObject := JSONResult.GetValue('response') as TJSONObject;
        if not Assigned(ResponseObject) then
          Exit;

        InfoObject := ResponseObject.GetValue('info') as TJSONObject;
        if Assigned(InfoObject) then
          APageCount := GetValueIntDef(InfoObject, 'pagecount', 0);

        SourcesValue := ResponseObject.GetValue('sources');
        ItemsArray := nil;

        if SourcesValue is TJSONArray then
          ItemsArray := TJSONArray(SourcesValue)
        else if SourcesValue is TJSONObject then
        begin
          ItemsValue := TJSONObject(SourcesValue).GetValue('items');
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
      Log('TSourcesBroker.List ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

class function TSourcesBroker.ListClassType: TEntityListClass;
begin
  Result := TSourceList
end;


end.
