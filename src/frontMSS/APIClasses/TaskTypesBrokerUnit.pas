unit TaskTypesBrokerUnit;

interface

uses
  System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit,
  TaskTypesUnit,
  FieldSetBrokerUnit;

type
  /// <summary>Брокер API типов задач summary.</summary>
  TTaskTypesBroker = class(TFieldSetBroker)
  protected
    function BaseUrlPath: string; override;
    class function ClassType: TFieldSetClass; override;
    class function ListClassType: TFieldSetListClass; override;
  public
    function List(
      out APageCount: Integer;
      const APage: Integer = 0;
      const APageSize: Integer = 50;
      const ASearchStr: String = '';
      const ASearchBy: String = '';
      const AOrder: String = 'name';
      const AOrderDir: String = 'asc'): TFieldSetList; override;

    function CreateNew(): TFieldSet; override;
  end;

implementation

uses
  System.SysUtils,
  APIConst;

const
  constURLTaskTypes = '/tasks/types';

{ TTaskTypesBroker }

function TTaskTypesBroker.BaseUrlPath: string;
begin
  Result := constURLSummaryBasePath;
end;

class function TTaskTypesBroker.ClassType: TFieldSetClass;
begin
  Result := TTaskTypes;
end;

class function TTaskTypesBroker.ListClassType: TFieldSetListClass;
begin
  Result := TTaskTypesList;
end;

function TTaskTypesBroker.List(
  out APageCount: Integer;
  const APage: Integer;
  const APageSize: Integer;
  const ASearchStr, ASearchBy, AOrder, AOrderDir: String): TFieldSetList;
var
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  TypesArray: TJSONArray;
  ResStr: String;
begin
  Result := nil;
  APageCount := 0;

  try
    ResStr := MainHttpModuleUnit.GET(BaseUrlPath + constURLTaskTypes);

    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
    try
      if not Assigned(JSONResult) then
        Exit;

      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      if not Assigned(ResponseObject) then
        Exit;

      TypesArray := ResponseObject.GetValue('types') as TJSONArray;
      if not Assigned(TypesArray) then
        Exit;

      Result := ListClassType.Create(TypesArray);
      APageCount := 1;
    finally
      JSONResult.Free;
    end;
  except
    on E: Exception do
    begin
      Log('TTaskTypesBroker.List ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TTaskTypesBroker.CreateNew: TFieldSet;
begin
  Result := ClassType.Create();
end;

end.

