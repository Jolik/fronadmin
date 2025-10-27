unit SourceTypesBrokerUnit;

interface

uses
  System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit,
  FieldSetBrokerUnit,
  SourceTypeUnit;

type
  /// <summary>Broker for dataserver source types API.</summary>
  TSourceTypesBroker = class(TFieldSetBroker)
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
    function New(AFieldSet: TFieldSet): boolean; override;
  end;

implementation

uses
  System.SysUtils,
  APIConst;

const
  constURLSourceTypesList = '/sources/types/list';

{ TSourceTypesBroker }

function TSourceTypesBroker.BaseUrlPath: string;
begin
  Result := constURLDataserverBasePath;
end;

class function TSourceTypesBroker.ClassType: TFieldSetClass;
begin
  Result := TSourceType;
end;

class function TSourceTypesBroker.ListClassType: TFieldSetListClass;
begin
  Result := TSourceTypeList;
end;

function TSourceTypesBroker.List(out APageCount: Integer; const APage,
  APageSize: Integer; const ASearchStr, ASearchBy, AOrder,
  AOrderDir: String): TFieldSetList;
var
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  SourceTypesValue: TJSONValue;
  ItemsValue: TJSONValue;
  ItemsArray: TJSONArray;
  ResStr: string;
begin
  Result := nil;
  APageCount := 0;

  try
    ResStr := MainHttpModuleUnit.GET(BaseUrlPath + constURLSourceTypesList);

    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
    try
      if not Assigned(JSONResult) then
        Exit;

      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      if not Assigned(ResponseObject) then
        Exit;

      SourceTypesValue := ResponseObject.GetValue('srctypes');
      ItemsArray := nil;

      if SourceTypesValue is TJSONArray then
        ItemsArray := SourceTypesValue as TJSONArray
      else if SourceTypesValue is TJSONObject then
      begin
        ItemsValue := TJSONObject(SourceTypesValue).GetValue('items');
        if ItemsValue is TJSONArray then
          ItemsArray := TJSONArray(ItemsValue);
      end;

      Result := ListClassType.Create(ItemsArray);
    finally
      JSONResult.Free;
    end;
  except
    on E: Exception do
    begin
      Log('TSourceTypesBroker.List ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TSourceTypesBroker.CreateNew: TFieldSet;
begin
  Result := ClassType.Create();
end;

function TSourceTypesBroker.New(AFieldSet: TFieldSet): boolean;
begin
  Result := False;
end;

end.
