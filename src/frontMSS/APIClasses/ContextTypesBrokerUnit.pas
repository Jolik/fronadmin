unit ContextTypesBrokerUnit;

interface

uses
  System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit,
  FieldSetBrokerUnit,
  ContextTypeUnit;

type
  /// <summary>Broker for dataserver context types API.</summary>
  TContextTypesBroker = class(TFieldSetBroker)
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
  constURLContextTypesList = '/sources/contexts/types/list';

{ TContextTypesBroker }

function TContextTypesBroker.BaseUrlPath: string;
begin
  Result := constURLDataserverBasePath;
end;

class function TContextTypesBroker.ClassType: TFieldSetClass;
begin
  Result := TContextType;
end;

class function TContextTypesBroker.ListClassType: TFieldSetListClass;
begin
  Result := TContextTypeList;
end;

function TContextTypesBroker.List(out APageCount: Integer; const APage,
  APageSize: Integer; const ASearchStr, ASearchBy, AOrder,
  AOrderDir: String): TFieldSetList;
var
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  ContextTypesValue: TJSONValue;
  ItemsValue: TJSONValue;
  ItemsArray: TJSONArray;
  ResStr: string;
begin
  Result := nil;
  APageCount := 0;

  try
    ResStr := MainHttpModuleUnit.GET(BaseUrlPath + constURLContextTypesList);

    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
    try
      if not Assigned(JSONResult) then
        Exit;

      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      if not Assigned(ResponseObject) then
        Exit;

      ContextTypesValue := ResponseObject.GetValue('ctxtypes');
      ItemsArray := nil;

      if ContextTypesValue is TJSONArray then
        ItemsArray := TJSONArray(ContextTypesValue)
      else if ContextTypesValue is TJSONObject then
      begin
        ItemsValue := TJSONObject(ContextTypesValue).GetValue('items');
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
      Log('TContextTypesBroker.List ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TContextTypesBroker.CreateNew: TFieldSet;
begin
  Result := ClassType.Create();
end;

function TContextTypesBroker.New(AFieldSet: TFieldSet): boolean;
begin
  Result := False;
end;

end.
