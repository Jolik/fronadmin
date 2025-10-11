unit SummaryTasksBrokerUnit;

interface

uses
  System.Classes, System.SysUtils, System.StrUtils,
  System.Generics.Collections, System.JSON,
  MainModule,
  LoggingUnit,
  ParentBrokerUnit, EntityUnit, SummaryTaskUnit;

type
  /// <summary>
  ///   Broker for working with summary task API endpoints.
  /// </summary>
  TSummaryTasksBroker = class(TParentBroker)
  public
    function List(
      out APageCount: Integer;
      const APage: Integer = 0;
      const APageSize: Integer = 50;
      const ASearchStr: String = '';
      const ASearchBy: String = '';
      const AOrder: String = 'name';
      const AOrderDir: String = 'asc'): TEntityList; override;

    function CreateNew: TEntity; override;
    function New(AEntity: TEntity): Boolean; override;
    function Info(AId: String): TEntity; overload; override;
    function Info(AEntity: TEntity): TEntity; overload; override;
    function Update(AEntity: TEntity): Boolean; override;
    function Remove(AId: String): Boolean; overload; override;
    function Remove(AEntity: TEntity): Boolean; overload; override;

    /// <summary>
    ///   Returns available summary task types.
    /// </summary>
    function GetTypes: TJSONArray;
  end;

  /// <summary>
  ///   Compatibility alias.
  /// </summary>
  TSummaryTaskBroker = class(TSummaryTasksBroker);

implementation

const
  constURLSummaryTaskGetList = '/api/v2/tasks/list';
  constURLSummaryTaskGetOneInfo = '/api/v2/tasks/%s';
  constURLSummaryTaskNew = '/api/v2/tasks/new';
  constURLSummaryTaskUpdate = '/api/v2/tasks/%s/update';
  constURLSummaryTaskDelete = '/api/v2/tasks/%s/remove';
  constURLSummaryTaskTypes = '/api/v2/tasks/types';

{ TSummaryTasksBroker }

function TSummaryTasksBroker.CreateNew: TEntity;
begin
  Result := TSummaryTask.Create;
end;

function TSummaryTasksBroker.GetTypes: TJSONArray;
var
  ResStr: string;
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  TypesValue: TJSONValue;
begin
  Result := nil;
  JSONResult := nil;
  try
    ResStr := MainModule.GET(constURLSummaryTaskTypes);
    if ResStr <> '' then
    begin
      JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
      if Assigned(JSONResult) then
      begin
        ResponseObject := JSONResult.GetValue('response') as TJSONObject;
        if Assigned(ResponseObject) then
        begin
          TypesValue := ResponseObject.GetValue('types');
          if (TypesValue is TJSONArray) then
            Result := (TypesValue as TJSONArray).Clone as TJSONArray;
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      Log('TSummaryTasksBroker.GetTypes ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  finally
    JSONResult.Free;
  end;
end;

function TSummaryTasksBroker.Info(AEntity: TEntity): TEntity;
begin
  if not Assigned(AEntity) then
    Exit(nil);
  Result := Info(AEntity.Id);
end;

function TSummaryTasksBroker.Info(AId: String): TEntity;
var
  URL: string;
  ResStr: string;
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  TaskObject: TJSONObject;
begin
  Result := nil;
  if AId = '' then
    Exit;

  JSONResult := nil;
  try
    URL := Format(constURLSummaryTaskGetOneInfo, [AId]);
    ResStr := MainModule.GET(URL);
    if ResStr <> '' then
    begin
      JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
      if Assigned(JSONResult) then
      begin
        ResponseObject := JSONResult.GetValue('response') as TJSONObject;
        if Assigned(ResponseObject) then
        begin
          TaskObject := ResponseObject.GetValue('task') as TJSONObject;
          if Assigned(TaskObject) then
            Result := TSummaryTask.Create(TaskObject);
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      Log('TSummaryTasksBroker.Info ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  finally
    JSONResult.Free;
  end;
end;

function TSummaryTasksBroker.List(out APageCount: Integer; const APage,
  APageSize: Integer; const ASearchStr, ASearchBy, AOrder,
  AOrderDir: String): TEntityList;

  function CreateJSONRequest: TJSONObject;
  var
    FilterArray: TJSONArray;
  begin
    Result := TJSONObject.Create;
    Result.AddPair('tid', TJSONArray.Create);
    Result.AddPair('compid', TJSONArray.Create);
    Result.AddPair('depid', TJSONArray.Create);

    if ASearchStr <> '' then
    begin
      if SameText(ASearchBy, 'compid') then
        FilterArray := Result.GetValue('compid') as TJSONArray
      else if SameText(ASearchBy, 'depid') then
        FilterArray := Result.GetValue('depid') as TJSONArray
      else
        FilterArray := Result.GetValue('tid') as TJSONArray;

      FilterArray.Add(ASearchStr);
    end;
  end;

var
  JSONRequest: TJSONObject;
  JSONRequestStream: TStringStream;
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  TasksValue: TJSONValue;
  ResStr: string;
  TaskItem: TJSONValue;
begin
  Result := TSummaryTaskList.Create;
  APageCount := 0;
  JSONRequest := nil;
  JSONRequestStream := nil;
  JSONResult := nil;
  try
    JSONRequest := CreateJSONRequest;
    JSONRequestStream := TStringStream.Create(JSONRequest.ToJSON, TEncoding.UTF8);
    ResStr := MainModule.POST(constURLSummaryTaskGetList, JSONRequestStream);
    if ResStr <> '' then
    begin
      JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
      if Assigned(JSONResult) then
      begin
        ResponseObject := JSONResult.GetValue('response') as TJSONObject;
        if Assigned(ResponseObject) then
        begin
          TasksValue := ResponseObject.GetValue('tasks');
          if (TasksValue is TJSONArray) then
            for TaskItem in (TasksValue as TJSONArray) do
              if TaskItem is TJSONObject then
                Result.Add(TSummaryTask.Create(TaskItem as TJSONObject));
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      Log('TSummaryTasksBroker.List ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  finally
    JSONResult.Free;
    JSONRequestStream.Free;
    JSONRequest.Free;
  end;
end;

function TSummaryTasksBroker.New(AEntity: TEntity): Boolean;
var
  URL: string;
  JSONTask: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: string;
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  TidValue: string;
begin
  Result := false;
  if not (AEntity is TSummaryTask) then
    Exit;

  URL := constURLSummaryTaskNew;
  JSONTask := AEntity.Serialize();
  JSONRequestStream := TStringStream.Create(JSONTask.ToJSON, TEncoding.UTF8);
  JSONResult := nil;
  try
    ResStr := MainModule.POST(URL, JSONRequestStream);
    Result := true;

    if ResStr <> '' then
    begin
      JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
      if Assigned(JSONResult) then
      begin
        ResponseObject := JSONResult.GetValue('response') as TJSONObject;
        if Assigned(ResponseObject) and ResponseObject.TryGetValue<string>('tid', TidValue) then
          (AEntity as TSummaryTask).Tid := TidValue;
      end;
    end;
  except
    on E: Exception do
    begin
      Log('TSummaryTasksBroker.New ' + E.Message, lrtError);
      Result := false;
    end;
  finally
    JSONResult.Free;
    JSONTask.Free;
    JSONRequestStream.Free;
  end;
end;

function TSummaryTasksBroker.Remove(AEntity: TEntity): Boolean;
begin
  if not Assigned(AEntity) then
    Exit(false);
  Result := Remove(AEntity.Id);
end;

function TSummaryTasksBroker.Remove(AId: String): Boolean;
var
  URL: string;
  ResStr: string;
  JSONRequestStream: TStringStream;
begin
  Result := false;
  if AId = '' then
    Exit;

  URL := Format(constURLSummaryTaskDelete, [AId]);
  JSONRequestStream := TStringStream.Create('{}', TEncoding.UTF8);
  try
    ResStr := MainModule.POST(URL, JSONRequestStream);
    Result := ResStr <> '';
  except
    on E: Exception do
    begin
      Log('TSummaryTasksBroker.Remove ' + E.Message, lrtError);
      Result := false;
    end;
  finally
    JSONRequestStream.Free;
  end;
end;

function TSummaryTasksBroker.Update(AEntity: TEntity): Boolean;
var
  URL: string;
  JSONTask: TJSONObject;
  JSONRequestStream: TStringStream;
  Pair: TJSONPair;
begin
  Result := false;
  if not (AEntity is TSummaryTask) then
    Exit;

  URL := Format(constURLSummaryTaskUpdate, [(AEntity as TSummaryTask).Tid]);
  JSONTask := AEntity.Serialize();

  Pair := JSONTask.RemovePair('tid');
  Pair.Free;
  Pair := JSONTask.RemovePair('module');
  Pair.Free;

  JSONRequestStream := TStringStream.Create(JSONTask.ToJSON, TEncoding.UTF8);
  try
    MainModule.POST(URL, JSONRequestStream);
    Result := true;
  except
    on E: Exception do
    begin
      Log('TSummaryTasksBroker.Update ' + E.Message, lrtError);
      Result := false;
    end;
  finally
    JSONTask.Free;
    JSONRequestStream.Free;
  end;
end;

end.
