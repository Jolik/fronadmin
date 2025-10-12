unit SummaryTasksBrokerUnit;

interface

uses
  System.Classes, System.SysUtils, System.StrUtils,
  System.Generics.Collections, System.JSON,
  MainModule,
  LoggingUnit,
  EntityUnit, SummaryTaskUnit, TasksBrokerUnit;

type
  ///    Summary API
  TSummaryTasksBroker = class(TTasksBroker)
  protected
    ///      API
    function BaseUrlPath: string; override;

    ///
    ///      nil
    function CreateNew(): TEntity; override;

  public
    function List(
      out APageCount: Integer;
      const APage: Integer = 0;
      const APageSize: Integer = 50;
      const ASearchStr: String = '';
      const ASearchBy: String = '';
      const AOrder: String = 'name';
      const AOrderDir: String = 'asc'): TEntityList; override;

    function Info(AId: String): TEntity; overload; override;
    function New(AEntity: TEntity): Boolean; override;
    function Update(AEntity: TEntity): Boolean; override;
    function Remove(AId: String): Boolean; overload; override;

    ///
    ///      summary
    function GetTypes: TJSONArray;
  end;

  ///
  ///
  TSummaryTaskBroker = class(TSummaryTasksBroker);

  TSummaryTaskList = class(TEntityList);

implementation

const
  constURLSummaryBasePath = '/api/v2';
  constURLSummaryTaskGetList = '/tasks/list';
  constURLSummaryTaskGetOneInfo = '/tasks/%s';
  constURLSummaryTaskNew = '/tasks/new';
  constURLSummaryTaskUpdate = '/tasks/%s/update';
  constURLSummaryTaskDelete = '/tasks/%s/remove';
  constURLSummaryTaskTypes = '/tasks/types';

{ TSummaryTasksBroker }

function TSummaryTasksBroker.BaseUrlPath: string;
begin
  Result := constURLSummaryBasePath;
end;

function TSummaryTasksBroker.CreateNew: TEntity;
begin
  Result := TSummaryTask.Create();
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
    ResStr := MainModule.GET(BaseUrlPath + constURLSummaryTaskTypes);
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
  end;
  FreeAndNil(JSONResult);
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
    URL := Format(BaseUrlPath + constURLSummaryTaskGetOneInfo, [AId]);
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
  end;
  FreeAndNil(JSONResult);
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
  TaskItem: TJSONValue;
  ResStr: string;
begin
  Result := TSummaryTaskList.Create;
  APageCount := 0;
  JSONRequest := nil;
  JSONRequestStream := nil;
  JSONResult := nil;
  try
    JSONRequest := CreateJSONRequest;
    JSONRequestStream := TStringStream.Create(JSONRequest.ToJSON, TEncoding.UTF8);
    ResStr := MainModule.POST(BaseUrlPath + constURLSummaryTaskGetList, JSONRequestStream);
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
  end;
  FreeAndNil(JSONResult);
  FreeAndNil(JSONRequestStream);
  FreeAndNil(JSONRequest);
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

  URL := BaseUrlPath + constURLSummaryTaskNew;
  JSONTask := AEntity.Serialize();
  JSONRequestStream := nil;
  JSONResult := nil;
  try
    JSONRequestStream := TStringStream.Create(JSONTask.ToJSON, TEncoding.UTF8);
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
  end;
  FreeAndNil(JSONResult);
  FreeAndNil(JSONRequestStream);
  JSONTask.Free;
end;

function TSummaryTasksBroker.Remove(AId: String): Boolean;
var
  URL: string;
  JSONRequestStream: TStringStream;
  ResStr: string;
begin
  Result := false;
  if AId = '' then
    Exit;

  JSONRequestStream := nil;
  try
    URL := Format(BaseUrlPath + constURLSummaryTaskDelete, [AId]);
    JSONRequestStream := TStringStream.Create('{}', TEncoding.UTF8);
    ResStr := MainModule.POST(URL, JSONRequestStream);
    Result := true;
  except
    on E: Exception do
    begin
      Log('TSummaryTasksBroker.Remove ' + E.Message, lrtError);
      Result := false;
    end;
  end;
  FreeAndNil(JSONRequestStream);
end;

function TSummaryTasksBroker.Update(AEntity: TEntity): Boolean;
var
  URL: string;
  JSONTask: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: string;
begin
  Result := false;
  if not (AEntity is TSummaryTask) then
    Exit;

  URL := Format(BaseUrlPath + constURLSummaryTaskUpdate, [(AEntity as TSummaryTask).Tid]);
  JSONTask := AEntity.Serialize();
  JSONRequestStream := nil;
  try
    JSONRequestStream := TStringStream.Create(JSONTask.ToJSON, TEncoding.UTF8);
    ResStr := MainModule.POST(URL, JSONRequestStream);
    Result := true;
  except
    on E: Exception do
    begin
      Log('TSummaryTasksBroker.Update ' + E.Message, lrtError);
      Result := false;
    end;
  end;
  FreeAndNil(JSONRequestStream);
  JSONTask.Free;
end;

end.
