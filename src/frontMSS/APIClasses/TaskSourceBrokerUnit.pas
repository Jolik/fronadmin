unit TaskSourceBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit, TaskSourceUnit, EntityBrokerUnit;

type
  ///    API Task Sources
  TTaskSourceBroker = class(TEntityBroker)
  protected
    ///      API
    function GetBasePath: string; override;
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
  FuncUnit;

const
  constURLTaskSourceGetList = '/sources/list';
  constURLTaskSourceGetOneInfo = '/sources/%s';
  constURLTaskSourceNew = '/sources/new';
  constURLTaskSourceUpdate = '/sources/%s/update';
  constURLTaskSourceDelete = '/sources/%s/remove';
  constURLTaskSourceBasePath = '/api/v2/tasks';

{ TTaskSourceBroker }

function TTaskSourceBroker.GetBasePath: string;
begin
  Result := constURLTaskSourceBasePath;
end;

class function TTaskSourceBroker.ClassType: TEntityClass;
begin
  Result := TTaskSource;
end;

class function TTaskSourceBroker.ListClassType: TEntityListClass;
begin
  Result := TTaskSourceList;
end;

function TTaskSourceBroker.List(
  out APageCount: Integer;
  const APage: Integer;
  const APageSize: Integer;
  const ASearchStr, ASearchBy, AOrder, AOrderDir: String): TEntityList;
var
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  SourcesArray: TJSONArray;
  ResStr: String;
begin
  Result := nil;
  APageCount := 0;

  try
    JSONResult := nil;
    try
      ResStr := MainHttpModuleUnit.GET(GetPath + constURLTaskSourceGetList);
      JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
      if not Assigned(JSONResult) then
        exit;

      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      if not Assigned(ResponseObject) then
        exit;

      SourcesArray := ResponseObject.GetValue('sources') as TJSONArray;
      if not Assigned(SourcesArray) then
        exit;

      Result := ListClassType.Create(SourcesArray);
    finally
      JSONResult.Free;
    end;

  except on E: Exception do
    begin
      Log('TTaskSourceBroker.List ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TTaskSourceBroker.CreateNew: TEntity;
begin
  Result := ClassType.Create();
end;

function TTaskSourceBroker.Info(AId: String): TEntity;
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
    URL := Format(GetPath + constURLTaskSourceGetOneInfo, [AId]);

    ResStr := MainHttpModuleUnit.GET(URL);

    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;

    try
      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      if not Assigned(ResponseObject) then
        exit;

      SourceValue := ResponseObject.GetValue('source');

      if SourceValue is TJSONObject then
        Result := ClassType.Create(SourceValue as TJSONObject);

    finally
      JSONResult.Free;
    end;

  except on E: Exception do
    begin
      Log('TTaskSourceBroker.Info ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TTaskSourceBroker.New(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONSource: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;
begin
  Result := false;

  URL := GetPath + constURLTaskSourceNew;
  JSONSource := AEntity.Serialize();

  JSONRequestStream := TStringStream.Create(JSONSource.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);
    Result := true;
  finally
    JSONSource.Free;
    JSONRequestStream.Free;
  end;
end;

function TTaskSourceBroker.Update(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONSource: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;
begin
  Result := false;

  if not (AEntity is TTaskSource) then
    exit;

  URL := Format(GetPath + constURLTaskSourceUpdate, [(AEntity as TTaskSource).Sid]);

  JSONSource := AEntity.Serialize();

  JSONRequestStream := TStringStream.Create(JSONSource.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);
    Result := true;
  finally
    JSONSource.Free;
    JSONRequestStream.Free;
  end;
end;

function TTaskSourceBroker.Remove(AId: String): Boolean;
var
  URL: String;
  JSONRequestStream: TStringStream;
  ResStr: String;
begin
  Result := false;

  URL := Format(GetPath + constURLTaskSourceDelete, [AId]);

  JSONRequestStream := TStringStream.Create('{}', TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);
    Result := true;
  finally
    JSONRequestStream.Free;
  end;
end;

end.
