unit DsGroupsBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit, DsGroupUnit, EntityBrokerUnit;

type
  ///  API broker for dataserver groups
  TDsGroupBroker = class(TEntityBroker)
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
  constURLDsGroupsList = '/dsgroups/list?flag=dataseries';
  constURLDsGroupsInfo = '/dsgroups/%s';
  constURLDsGroupsNew = '/dsgroups/new';
  constURLDsGroupsUpdate = '/dsgroups/%s/update';
  constURLDsGroupsRemove = '/dsgroups/%s/remove';

{ TDsGroupBroker }

function TDsGroupBroker.GetBasePath: string;
begin
  Result := constURLDataserverBasePath;
end;

class function TDsGroupBroker.ClassType: TEntityClass;
begin
  Result := TDsGroup;
end;

class function TDsGroupBroker.ListClassType: TEntityListClass;
begin
  Result := TDsGroupList;
end;

function TDsGroupBroker.List(out APageCount: Integer; const APage, APageSize: Integer;
  const ASearchStr, ASearchBy, AOrder, AOrderDir: String): TEntityList;
var
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  GroupsObject: TJSONObject;
  ItemsValue: TJSONValue;
  ItemsArray: TJSONArray;
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
      ResStr := MainHttpModuleUnit.POST(GetBasePath + constURLDsGroupsList, RequestStream);
      JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
      if not Assigned(JSONResult) then
        Exit;

      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      if not Assigned(ResponseObject) then
        Exit;

      GroupsObject := ResponseObject.GetValue('dsgroups') as TJSONObject;
      if not Assigned(GroupsObject) then
        Exit;

      InfoObject := GroupsObject.GetValue('info') as TJSONObject;
      if Assigned(InfoObject) then
        APageCount := GetValueIntDef(InfoObject, 'pagecount', 0);

      ItemsValue := GroupsObject.GetValue('items');
      if ItemsValue is TJSONArray then
        ItemsArray := ItemsValue as TJSONArray
      else
        ItemsArray := nil;

      Result := ListClassType.Create(ItemsArray);
    finally
      JSONResult.Free;
      RequestStream.Free;
    end;
  except
    on E: Exception do
    begin
      Log('TDsGroupBroker.List ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TDsGroupBroker.CreateNew: TEntity;
begin
  Result := ClassType.Create;
end;

function TDsGroupBroker.Info(AId: String): TEntity;
var
  URL: String;
  ResStr: String;
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  GroupValue: TJSONValue;
begin
  Result := nil;

  if AId = '' then
    Exit;

  try
    URL := Format(GetBasePath + constURLDsGroupsInfo, [AId]);

    ResStr := MainHttpModuleUnit.GET(URL);

    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
    try
      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      if not Assigned(ResponseObject) then
        Exit;

      GroupValue := ResponseObject.GetValue('dsgroup');
      if GroupValue is TJSONObject then
        Result := ClassType.Create(GroupValue as TJSONObject);
    finally
      JSONResult.Free;
    end;
  except
    on E: Exception do
    begin
      Log('TDsGroupBroker.Info ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TDsGroupBroker.New(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONGroup: TJSONObject;
  JSONRequestStream: TStringStream;
begin
  Result := false;

  URL := GetBasePath + constURLDsGroupsNew;
  JSONGroup := AEntity.Serialize();

  JSONRequestStream := TStringStream.Create(JSONGroup.ToJSON, TEncoding.UTF8);
  try
    MainHttpModuleUnit.POST(URL, JSONRequestStream);
    Result := true;
  finally
    JSONGroup.Free;
    JSONRequestStream.Free;
  end;
end;

function TDsGroupBroker.Remove(AId: String): Boolean;
var
  URL: String;
  JSONRequestStream: TStringStream;
begin
  Result := false;

  if AId = '' then
    Exit;

  URL := Format(GetBasePath + constURLDsGroupsRemove, [AId]);

  JSONRequestStream := TStringStream.Create('{}', TEncoding.UTF8);
  try
    MainHttpModuleUnit.POST(URL, JSONRequestStream);
    Result := true;
  finally
    JSONRequestStream.Free;
  end;
end;

function TDsGroupBroker.Update(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONGroup: TJSONObject;
  JSONRequestStream: TStringStream;
  Group: TDsGroup;
begin
  Result := false;

  if not (AEntity is TDsGroup) then
    Exit;

  Group := TDsGroup(AEntity);

  URL := Format(GetBasePath + constURLDsGroupsUpdate, [Group.Dsgid]);

  JSONGroup := AEntity.Serialize();
  JSONRequestStream := TStringStream.Create(JSONGroup.ToJSON, TEncoding.UTF8);
  try
    MainHttpModuleUnit.POST(URL, JSONRequestStream);
    Result := true;
  finally
    JSONGroup.Free;
    JSONRequestStream.Free;
  end;
end;

end.

