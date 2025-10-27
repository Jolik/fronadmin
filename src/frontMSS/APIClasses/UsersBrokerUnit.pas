unit UsersBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit, UserUnit, EntityBrokerUnit;

type
  ///    API Users
  TUsersBroker = class(TEntityBroker)
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
  APIConst;

const
  constURLUsersList = '/users/list';
  constURLUsersInfo = '/users/%s';
  constURLUsersNew = '/users/new';
  constURLUsersUpdate = '/users/%s/update';
  constURLUsersRemove = '/users/%s/remove';

{ TUsersBroker }

function TUsersBroker.GetBasePath: string;
begin
  Result := constURLAclBasePath;
end;

class function TUsersBroker.ClassType: TEntityClass;
begin
  Result := TUser;
end;

class function TUsersBroker.ListClassType: TEntityListClass;
begin
  Result := TUserList;
end;

function TUsersBroker.List(
  out APageCount: Integer;
  const APage: Integer;
  const APageSize: Integer;
  const ASearchStr, ASearchBy, AOrder, AOrderDir: String): TEntityList;

var
  JSONResult: TJSONObject;
  ResStr: String;
  RequestStream: TStringStream;
begin
  Result := nil;
  APageCount := 0;

  try
    RequestStream := TStringStream.Create('{}', TEncoding.UTF8);
    try
      ResStr := MainHttpModuleUnit.POST(GetBasePath + constURLUsersList, RequestStream);
    finally
      RequestStream.Free;
    end;

    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
    try
      var ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      var UsersObject := ResponseObject.GetValue('users') as TJSONObject;
      var ItemsArray := UsersObject.GetValue('items') as TJSONArray;

      Result := ListClassType.Create(ItemsArray);
    finally
      JSONResult.Free;
    end;
  except
    on e: exception do
    begin
      Log('TUsersBroker.List ' + e.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TUsersBroker.CreateNew: TEntity;
begin
  Result := ClassType.Create();
end;

function TUsersBroker.Info(AId: String): TEntity;
var
  URL: String;
  ResStr: String;
  JSONResult: TJSONObject;
begin
  Result := nil;

  if AId = '' then
    Exit;

  try
    URL := Format(GetBasePath + constURLUsersInfo, [AId]);
    ResStr := MainHttpModuleUnit.GET(URL);

    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
    try
      var ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      var UserObject := ResponseObject.GetValue('user') as TJSONObject;
      Result := ClassType.Create(UserObject);
    finally
      JSONResult.Free;
    end;
  except
    on e: exception do
    begin
      Log('TUsersBroker.Info ' + e.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TUsersBroker.New(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONUser: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;
begin
  URL := GetBasePath + constURLUsersNew;
  JSONUser := AEntity.Serialize();
  JSONRequestStream := TStringStream.Create(JSONUser.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);
    Result := true;
  finally
    JSONUser.Free;
    JSONRequestStream.Free;
  end;
end;

function TUsersBroker.Update(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONUser: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;
begin
  if not (AEntity is TUser) then
    Exit(false);

  URL := Format(GetBasePath + constURLUsersUpdate, [(AEntity as TUser).Usid]);
  JSONUser := AEntity.Serialize();
  JSONRequestStream := TStringStream.Create(JSONUser.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);
    Result := true;
  finally
    JSONUser.Free;
    JSONRequestStream.Free;
  end;
end;

function TUsersBroker.Remove(AId: String): Boolean;
var
  URL: String;
  ResStr: String;
  JSONRequestStream: TStringStream;
begin
  URL := Format(GetBasePath + constURLUsersRemove, [AId]);
  JSONRequestStream := TStringStream.Create('{}', TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);
  finally
    JSONRequestStream.Free;
  end;
  Result := ResStr <> '';
end;

end.

