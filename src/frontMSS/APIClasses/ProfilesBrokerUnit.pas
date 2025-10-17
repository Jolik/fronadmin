unit ProfilesBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit, ProfileUnit, EntityBrokerUnit;

/// <summary>
///   API брокер для работы с профилями маршрутизатора.
/// </summary>
type
  TProfilesBroker = class(TEntityBroker)
  protected
    /// <summary>
    ///   Базовый путь для всех запросов брокера.
    /// </summary>
    function GetBasePath: string; override;
    /// <summary>
    ///   Класс сущности, с которой работает брокер.
    /// </summary>
    class function ClassType: TEntityClass; override;
    /// <summary>
    ///   Класс списка сущностей, используемый брокером.
    /// </summary>
    class function ListClassType: TEntityListClass; override;
  public
    /// <summary>
    ///   Запрашивает список профилей.
    /// </summary>
    function List(
      out APageCount: Integer;
      const APage: Integer = 0;
      const APageSize: Integer = 50;
      const ASearchStr: String = '';
      const ASearchBy: String = '';
      const AOrder: String = 'name';
      const AOrderDir: String = 'asc'): TEntityList; override;

    /// <summary>
    ///   Создает пустой профиль.
    /// </summary>
    function CreateNew(): TEntity; override;
    /// <summary>
    ///   Отправляет новый профиль на сервер.
    /// </summary>
    function New(AEntity: TEntity): Boolean; override;
    /// <summary>
    ///   Возвращает информацию о профиле.
    /// </summary>
    function Info(AId: String): TEntity; overload; override;
    /// <summary>
    ///   Обновляет существующий профиль.
    /// </summary>
    function Update(AEntity: TEntity): Boolean; override;
    /// <summary>
    ///   Удаляет профиль.
    /// </summary>
    function Remove(AId: String): Boolean; overload; override;
  end;

implementation

uses
  System.SysUtils, System.Classes,
  FuncUnit,
  APIConst;

const
  constURLProfilesList = '/profiles/list';
  constURLProfileInfo = '/profiles/%s';
  constURLProfileNew = '/profiles/new';
  constURLProfileUpdate = '/profiles/%s/update';
  constURLProfileDelete = '/profiles/%s/remove';

{ TProfilesBroker }

function TProfilesBroker.GetBasePath: string;
begin
  Result := constURLDatacommBasePath;
end;

class function TProfilesBroker.ClassType: TEntityClass;
begin
  Result := TProfile;
end;

class function TProfilesBroker.ListClassType: TEntityListClass;
begin
  Result := TProfileList;
end;

function TProfilesBroker.List(
  out APageCount: Integer;
  const APage: Integer;
  const APageSize: Integer;
  const ASearchStr, ASearchBy, AOrder, AOrderDir: String): TEntityList;
var
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  ProfilesArray: TJSONArray;
  ResStr: String;
begin
  Result := nil;
  APageCount := 0;

  try
    JSONResult := nil;
    try
      ResStr := MainHttpModuleUnit.GET(GetPath + constURLProfilesList);
      JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
      if not Assigned(JSONResult) then
        Exit;

      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      if not Assigned(ResponseObject) then
        Exit;

      ProfilesArray := ResponseObject.GetValue('profiles') as TJSONArray;
      if not Assigned(ProfilesArray) then
        Exit;

      Result := ListClassType.Create(ProfilesArray);
    finally
      JSONResult.Free;
    end;

  except on E: Exception do
    begin
      Log('TProfilesBroker.List ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TProfilesBroker.CreateNew: TEntity;
begin
  Result := ClassType.Create();
end;

function TProfilesBroker.Info(AId: String): TEntity;
var
  URL: String;
  ResStr: String;
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  ProfileValue: TJSONValue;
begin
  Result := nil;

  if AId = '' then
    Exit;

  try
    URL := Format(GetPath + constURLProfileInfo, [AId]);

    ResStr := MainHttpModuleUnit.GET(URL);

    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;

    try
      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      if not Assigned(ResponseObject) then
        Exit;

      ProfileValue := ResponseObject.GetValue('profile');

      if ProfileValue is TJSONObject then
        Result := ClassType.Create(ProfileValue as TJSONObject);

    finally
      JSONResult.Free;
    end;

  except on E: Exception do
    begin
      Log('TProfilesBroker.Info ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TProfilesBroker.New(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONProfile: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;
begin
  Result := False;

  URL := GetPath + constURLProfileNew;
  JSONProfile := AEntity.Serialize();

  JSONRequestStream := TStringStream.Create(JSONProfile.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);
    Result := True;
  finally
    JSONProfile.Free;
    JSONRequestStream.Free;
  end;
end;

function TProfilesBroker.Update(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONProfile: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;
begin
  Result := False;

  if not (AEntity is TProfile) then
    Exit;

  URL := Format(GetPath + constURLProfileUpdate, [(AEntity as TProfile).Id]);

  JSONProfile := AEntity.Serialize();

  JSONRequestStream := TStringStream.Create(JSONProfile.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);
    Result := True;
  finally
    JSONProfile.Free;
    JSONRequestStream.Free;
  end;
end;

function TProfilesBroker.Remove(AId: String): Boolean;
var
  URL: String;
  JSONRequestStream: TStringStream;
  ResStr: String;
begin
  Result := False;

  URL := Format(GetPath + constURLProfileDelete, [AId]);

  JSONRequestStream := TStringStream.Create('{}', TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);
    Result := True;
  finally
    JSONRequestStream.Free;
  end;
end;

end.
