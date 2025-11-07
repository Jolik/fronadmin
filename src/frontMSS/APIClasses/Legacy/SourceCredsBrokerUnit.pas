unit SourceCredsBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit, SourceCredsUnit, FieldSetBrokerUnit;

type
  ///    API Source Credentials
  TSourceCredsBroker = class (TFieldSetBroker)
  protected
    ///      API
    function BaseUrlPath: string; override;
    ///
    ///     ,
    class function ClassType: TFieldSetClass; override;
    ///
    ///     ,
    class function ListClassType: TFieldSetListClass; override;

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
      const AOrderDir: String = 'asc'): TFieldSetList; override;

    ///
    ///      nil
    function CreateNew(): TFieldSet; override;
    ///
    ///      false
    function New(AFieldSet: TFieldSet): Boolean; override;
    ///
    ///      nil
    function Info(AId: String): TFieldSet;
    ///
    ///      false
    function Update(AFieldSet: TSourceCred): Boolean;
    ///
    ///      false
    function Remove(AId: String): Boolean; overload;

  end;

implementation

uses
  System.SysUtils, System.Classes,
  FuncUnit,
  APIConst;

const
  constURLSourceCredsList = '/sources/contexts/creds/list';
  constURLSourceCredsInfo = '/sources/contexts/creds/%s';
  constURLSourceCredsNew = '/sources/contexts/creds/new';
  constURLSourceCredsUpdate = '/sources/contexts/creds/%s/update';
  constURLSourceCredsRemove = '/sources/contexts/creds/%s/remove';

{ TSourceCredsBroker }

function TSourceCredsBroker.BaseUrlPath: string;
begin
  Result := constURLDataserverBasePath;
end;

class function TSourceCredsBroker.ClassType: TFieldSetClass;
begin
  Result := TSourceCred;
end;

class function TSourceCredsBroker.ListClassType: TFieldSetListClass;
begin
  Result := TSourceCredsList;
end;

///
///      nil
function TSourceCredsBroker.List(
  out APageCount: Integer;
  const APage: Integer = 0;
  const APageSize: Integer = 50;
  const ASearchStr: String = '';
  const ASearchBy: String = '';
  const AOrder: String = 'name';
  const AOrderDir: String = 'asc'): TFieldSetList;
var
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  CredsObject: TJSONObject;
  ItemsArray: TJSONArray;
  ItemsValue: TJSONValue;
  RequestStream: TStringStream;
  ResStr: String;
  InfoObject: TJSONObject;
begin

  Result := nil;
  APageCount := 0;

  try

    JSONResult := nil;
    RequestStream := TStringStream.Create('{}', TEncoding.UTF8);
    try
      ///    -
      ResStr := MainHttpModuleUnit.POST(BaseUrlPath + constURLSourceCredsList, RequestStream);
      ///
      JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
      if not Assigned(JSONResult) then
        exit;
      ///   -
      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      if not Assigned(ResponseObject) then
        exit;
      ///
      CredsObject := ResponseObject.GetValue('credentials') as TJSONObject;
      if not Assigned(CredsObject) then
        exit;
      ///
      InfoObject := CredsObject.GetValue('info') as TJSONObject;
      if Assigned(InfoObject) then
        APageCount := GetValueIntDef(InfoObject, 'pagecount', 0);

      ItemsValue := CredsObject.GetValue('items');
      if ItemsValue is TJSONArray then
        ItemsArray := ItemsValue as TJSONArray
      else
        ItemsArray := nil;

      Result := ListClassType.Create(ItemsArray);

    finally
      JSONResult.Free;
      RequestStream.Free;
    end;

  except on e:exception do
    begin
      Log('TSourceCredsBroker.List '+ e.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TSourceCredsBroker.CreateNew: TFieldSet;
begin
  Result := ClassType.Create();
end;

///
///      nil
function TSourceCredsBroker.Info(AId: String): TFieldSet;
var
  URL: String;
  ResStr: String;
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  CredsValue: TJSONValue;
begin

  Result := nil;

  if AId = '' then
    exit;

  try
    URL := Format(BaseUrlPath + constURLSourceCredsInfo, [AId]);

    ResStr := MainHttpModuleUnit.GET(URL);

    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;

    try
      ///   JSON  response
      ResponseObject := JSONResult.GetValue('response') as TJSONObject;

      ///   JSON  response
      CredsValue := ResponseObject.GetValue('credential');

      if CredsValue is TJSONObject then
        Result := ClassType.Create(CredsValue as TJSONObject);

    finally
      JSONResult.Free;

    end;

  except on e:exception do
    begin
      Log('TSourceCredsBroker.Info '+ e.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;

end;

///
///      false
function TSourceCredsBroker.New(AFieldSet: TFieldSet): Boolean;
var
  URL: String;
  JSONCreds: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;
begin
  Result := false;

  ///
  URL := BaseUrlPath + constURLSourceCredsNew;
  ///     JSON
  JSONCreds := AFieldSet.Serialize();

  JSONRequestStream := TStringStream.Create(JSONCreds.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);

    ////  !!!
    ///     true
    Result := true;

  finally
    JSONCreds.Free;
    JSONRequestStream.Free;

  end;

end;

///
///      false
function TSourceCredsBroker.Update(AFieldSet: TSourceCred): Boolean;
var
  URL: String;
  JSONCreds: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;
begin
  Result := false;

  if not Assigned(AFieldSet) then
    Exit;

  URL := Format(BaseUrlPath + constURLSourceCredsUpdate, [AFieldSet.Crid]);

  JSONCreds := AFieldSet.Serialize();

  JSONRequestStream := TStringStream.Create(JSONCreds.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);

    ////  !!!
    ///     true
    Result := true;

  finally
    JSONCreds.Free;
    JSONRequestStream.Free;

  end;

end;

///
///      false
function TSourceCredsBroker.Remove(AId: String): Boolean;
var
  URL: String;
  ResStr: String;
  JSONRequestStream: TStringStream;
begin
  Result := false;

  URL := Format(BaseUrlPath + constURLSourceCredsRemove, [AId]);

  JSONRequestStream := TStringStream.Create('{}', TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);
    Result := true;
  finally
    JSONRequestStream.Free;
  end;
end;

end.
