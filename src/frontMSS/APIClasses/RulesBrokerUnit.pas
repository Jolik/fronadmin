unit RulesBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit, RuleUnit, EntityBrokerUnit;

type
  /// <summary>
  ///   Broker for working with router rules API.
  /// </summary>
  TRulesBroker = class(TEntityBroker)
  protected
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
    function New(AEntity: TEntity): Boolean; override;
    function Info(AId: String): TEntity; overload; override;
    function Update(AEntity: TEntity): Boolean; override;
    function Remove(AId: String): Boolean; overload; override;
  end;

implementation

uses
  System.SysUtils, System.Classes,
  FuncUnit,
  APIConst;

const
  constURLRulesList = '/rules/list';
  constURLRulesInfo = '/rules/%s';
  constURLRulesNew = '/rules/new';
  constURLRulesUpdate = '/rules/%s/update';
  constURLRulesRemove = '/rules/%s/remove';

{ TRulesBroker }

function TRulesBroker.GetBasePath: string;
begin
  Result := constURLRouterBasePath;
end;

class function TRulesBroker.ClassType: TEntityClass;
begin
  Result := TRule;
end;

class function TRulesBroker.ListClassType: TEntityListClass;
begin
  Result := TRuleList;
end;

function TRulesBroker.List(
  out APageCount: Integer;
  const APage: Integer;
  const APageSize: Integer;
  const ASearchStr, ASearchBy, AOrder, AOrderDir: String): TEntityList;
var
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  RulesValue: TJSONValue;
  ItemsArray: TJSONArray;
  RequestStream: TStringStream;
  ResStr: String;
  InfoObject: TJSONObject;
  ItemsValue: TJSONValue;
  RequestObject: TJSONObject;
begin
  Result := nil;
  APageCount := 0;

  try
    JSONResult := nil;
    RequestObject := TJSONObject.Create;
    try
(*!!!      RequestObject.AddPair('page', TJSONNumber.Create(APage));
      RequestObject.AddPair('pagesize', TJSONNumber.Create(APageSize));
      if ASearchStr <> '' then
        RequestObject.AddPair('searchStr', ASearchStr);
      if ASearchBy <> '' then
        RequestObject.AddPair('searchBy', ASearchBy);
      if AOrder <> '' then
        RequestObject.AddPair('order', AOrder);
      if AOrderDir <> '' then
        RequestObject.AddPair('orderDir', AOrderDir);*)

      RequestStream := TStringStream.Create(RequestObject.ToJSON, TEncoding.UTF8);
      try
        ResStr := MainHttpModuleUnit.POST(GetBasePath + constURLRulesList, RequestStream);
        JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
        if not Assigned(JSONResult) then
          Exit;

        ResponseObject := JSONResult.GetValue('response') as TJSONObject;
        if not Assigned(ResponseObject) then
          Exit;

        InfoObject := ResponseObject.GetValue('info') as TJSONObject;
        if Assigned(InfoObject) then
          APageCount := GetValueIntDef(InfoObject, 'pagecount', 0);

        RulesValue := ResponseObject.GetValue('rules');
        ItemsArray := nil;

        if RulesValue is TJSONArray then
          ItemsArray := TJSONArray(RulesValue)
        else if RulesValue is TJSONObject then
        begin
          ItemsValue := TJSONObject(RulesValue).GetValue('items');
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
      Log('TRulesBroker.List ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TRulesBroker.CreateNew: TEntity;
begin
  Result := ClassType.Create();
end;

function TRulesBroker.Info(AId: String): TEntity;
var
  URL: String;
  ResStr: String;
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  RuleValue: TJSONValue;
begin
  Result := nil;

  if AId = '' then
    Exit;

  try
    URL := Format(GetBasePath + constURLRulesInfo, [AId]);

    ResStr := MainHttpModuleUnit.GET(URL);

    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;

    try
      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      if not Assigned(ResponseObject) then
        Exit;

      RuleValue := ResponseObject.GetValue('rule');

      if RuleValue is TJSONObject then
        Result := ClassType.Create(TJSONObject(RuleValue));

    finally
      JSONResult.Free;
    end;

  except on E: Exception do
    begin
      Log('TRulesBroker.Info ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TRulesBroker.New(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONRule: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;
begin
  Result := False;

  URL := GetBasePath + constURLRulesNew;

  JSONRule := AEntity.Serialize();

  JSONRequestStream := TStringStream.Create(JSONRule.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);
    Result := True;
  finally
    JSONRule.Free;
    JSONRequestStream.Free;
  end;
end;

function TRulesBroker.Update(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONRule: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;
begin
  Result := False;

  if not (AEntity is TRule) then
    Exit;

  URL := Format(GetBasePath + constURLRulesUpdate, [(AEntity as TRule).Ruid]);

  JSONRule := AEntity.Serialize();

  JSONRequestStream := TStringStream.Create(JSONRule.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);
    Result := True;
  finally
    JSONRule.Free;
    JSONRequestStream.Free;
  end;
end;

function TRulesBroker.Remove(AId: String): Boolean;
var
  URL: String;
  ResStr: String;
  JSONRequestStream: TStringStream;
begin
  Result := False;

  URL := Format(GetBasePath + constURLRulesRemove, [AId]);

  JSONRequestStream := TStringStream.Create('{}', TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);
    Result := True;
  finally
    JSONRequestStream.Free;
  end;
end;

end.
