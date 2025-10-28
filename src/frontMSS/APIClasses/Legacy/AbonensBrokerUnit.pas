unit AbonensBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit, AbonentUnit, EntityBrokerUnit;

type
  /// <summary>
  ///   Router abonents API broker.
  /// </summary>
  TAbonentsBroker = class(TEntityBroker)
  protected
    /// <summary>
    ///   Returns the API base path for router requests.
    /// </summary>
    function GetBasePath: string; override;
    /// <summary>
    ///   Returns the entity class handled by this broker.
    /// </summary>
    class function ClassType: TEntityClass; override;
    /// <summary>
    ///   Returns the list class handled by this broker.
    /// </summary>
    class function ListClassType: TEntityListClass; override;

  public
    /// <summary>
    ///   Returns a list of abonents or nil on error.
    /// </summary>
    function List(
      out APageCount: Integer;
      const APage: Integer = 0;
      const APageSize: Integer = 50;
      const ASearchStr: String = '';
      const ASearchBy: String = '';
      const AOrder: String = 'name';
      const AOrderDir: String = 'asc'): TEntityList; override;

    /// <summary>
    ///   Creates an empty abonent entity.
    /// </summary>
    function CreateNew(): TEntity; override;
    /// <summary>
    ///   Sends a request to create a new abonent. Returns False on failure.
    /// </summary>
    function New(AEntity: TEntity): Boolean; override;
    /// <summary>
    ///   Returns abonent information by identifier or nil on error.
    /// </summary>
    function Info(AId: String): TEntity; overload; override;
    /// <summary>
    ///   Updates abonent data. Returns False on failure.
    /// </summary>
    function Update(AEntity: TEntity): Boolean; override;
    /// <summary>
    ///   Removes the abonent identified by <paramref name="AId"/>.
    /// </summary>
    function Remove(AId: String): Boolean; overload; override;
  end;

implementation

uses
  System.SysUtils, System.Classes,
  FuncUnit,
  APIConst;

const
  constURLAbonentsList = '/abonents/list';
  constURLAbonentsInfo = '/abonents/%s';
  constURLAbonentsNew = '/abonents/new';
  constURLAbonentsUpdate = '/abonents/%s/update';
  constURLAbonentsRemove = '/abonents/%s/remove';

{ TAbonentsBroker }

function TAbonentsBroker.GetBasePath: string;
begin
  Result := constURLRouterBasePath;
end;

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
  const APage: Integer;
  const APageSize: Integer;
  const ASearchStr, ASearchBy, AOrder, AOrderDir: String): TEntityList;

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
  AbonentsValue: TJSONValue;
  ItemsValue: TJSONValue;
  PageCountValue: TJSONValue;
  RequestJson: TJSONObject;
  RequestStream: TStringStream;
  ResStr: String;
begin
  Result := nil;
  APageCount := 0;

  try
    RequestJson := CreateJSONRequest;
//!!!    RequestStream := TStringStream.Create(RequestJson.ToJSON, TEncoding.UTF8);
    RequestStream := TStringStream.Create('{}', TEncoding.UTF8);
    try
      ResStr := MainHttpModuleUnit.POST(GetBasePath + constURLAbonentsList, RequestStream);
    finally
      RequestJson.Free;
      RequestStream.Free;
    end;

    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
    try
      if not Assigned(JSONResult) then
        Exit;

      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      if not Assigned(ResponseObject) then
        Exit;

      PageCountValue := ResponseObject.GetValue('pageCount');
      if PageCountValue is TJSONNumber then
        APageCount := TJSONNumber(PageCountValue).AsInt;

      AbonentsValue := ResponseObject.GetValue('abonents');
      if not Assigned(AbonentsValue) then
        Exit;

      if AbonentsValue is TJSONArray then
        Result := ListClassType.Create(AbonentsValue as TJSONArray)
      else if AbonentsValue is TJSONObject then
      begin
        var AbonentsObject := TJSONObject(AbonentsValue);

        PageCountValue := AbonentsObject.GetValue('pageCount');
        if PageCountValue is TJSONNumber then
          APageCount := TJSONNumber(PageCountValue).AsInt;

        ItemsValue := AbonentsObject.GetValue('items');
        if ItemsValue is TJSONArray then
          Result := ListClassType.Create(ItemsValue as TJSONArray);
      end;

    finally
      JSONResult.Free;
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
    URL := Format(GetBasePath + constURLAbonentsInfo, [AId]);

    ResStr := MainHttpModuleUnit.GET(URL);

    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;

    try
      if not Assigned(JSONResult) then
        Exit;

      ///   JSON  response
      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      if not Assigned(ResponseObject) then
        Exit;

      ///   JSON  response
      AbonentValue := ResponseObject.GetValue('abonent');

      if AbonentValue is TJSONObject then
        Result := ClassType.Create(AbonentValue as TJSONObject);

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

  URL := GetBasePath + constURLAbonentsNew;

  JSONAbonent := AEntity.Serialize();

  JSONRequestStream := TStringStream.Create(JSONAbonent.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);

    Result := True;

  finally
    JSONAbonent.Free;
    JSONRequestStream.Free;
  end;
end;

function TAbonentsBroker.Update(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONAbonent: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;
  Abonent: TAbonent;
begin
  Result := False;

  if not (AEntity is TAbonent) then
    Exit;

  Abonent := TAbonent(AEntity);

  if Abonent.Abid = '' then
    Exit;

  URL := Format(GetBasePath + constURLAbonentsUpdate, [Abonent.Abid]);

  JSONAbonent := AEntity.Serialize();

  JSONRequestStream := TStringStream.Create(JSONAbonent.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);

    Result := True;

  finally
    JSONAbonent.Free;
    JSONRequestStream.Free;
  end;
end;

function TAbonentsBroker.Remove(AId: String): Boolean;
var
  URL: String;
  ResStr: String;
  JSONRequestStream: TStringStream;
begin
  Result := False;

  if AId = '' then
    Exit;

  URL := Format(GetBasePath + constURLAbonentsRemove, [AId]);

  JSONRequestStream := TStringStream.Create('{}', TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);

    Result := True;
  finally
    JSONRequestStream.Free;
  end;
end;

end.
