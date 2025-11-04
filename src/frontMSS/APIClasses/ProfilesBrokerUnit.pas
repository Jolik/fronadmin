unit ProfilesBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit, ProfileUnit, EntityBrokerUnit;

/// <summary>
///   API broker for working with router profiles.
/// </summary>
type
  TProfilesBroker = class(TEntityBroker)
  private
    FLid: string;
  protected
    /// <summary>
    ///   Base path for all broker requests.
    /// </summary>
    function GetBasePath: string; override;
    /// <summary>
    ///   Entity class handled by the broker.
    /// </summary>
    class function ClassType: TEntityClass; override;
    /// <summary>
    ///   Entity list class used by the broker.
    /// </summary>
    class function ListClassType: TEntityListClass; override;
  public
    /// <summary>
    ///   Requests a list of profiles.
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
    ///   Creates an empty profile.
    /// </summary>
    function CreateNew(): TEntity; override;
    /// <summary>
    ///   Sends a new profile to the server.
    /// </summary>
    function New(AEntity: TEntity): Boolean; override;
    /// <summary>
    ///   Returns profile information.
    /// </summary>
    function Info(AId: String): TEntity; overload; override;
    /// <summary>
    ///   Updates an existing profile.
    /// </summary>
    function Update(AEntity: TEntity): Boolean; override;
    /// <summary>
    ///   Deletes a profile.
    /// </summary>
    function Remove(AId: String): Boolean; overload; override;

    //
    function Synchronize(src: TProfileList): boolean;
    // Lid link id
    property Lid: string read FLid write FLid;

  end;

implementation

uses
  System.SysUtils, System.Classes,
  FuncUnit,
  APIConst;

const
  constURLProfileBaseSuffix = '/links';

{ TProfilesBroker }

function TProfilesBroker.GetBasePath: string;
begin
  Result := constURLDatacommBasePath + constURLProfileBaseSuffix;
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
  ProfilesObject: TJSONObject;
  ItemsArray: TJSONArray;
  ResStr: String;
begin
  Result := nil;
  APageCount := 0;

  JSONResult := nil;
  try
    var url := Format('%s/%s/profiles/list', [GetPath, FLid]);
    ResStr := MainHttpModuleUnit.GET(url);
    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
    if not Assigned(JSONResult) then
      Exit;


    if GetValueStrDef(JSONResult, 'meta.error', '') = 'not found' then
    begin
      Result := ListClassType.Create;
      exit;
    end;


    ResponseObject := JSONResult.GetValue('response') as TJSONObject;
    if not Assigned(ResponseObject) then
      Exit;

    ProfilesObject := ResponseObject.GetValue('profiles') as TJSONObject;
    if not Assigned(ProfilesObject) then
      Exit;

    ItemsArray := ProfilesObject.GetValue('items') as TJSONArray;
    if not Assigned(ItemsArray) then
      Exit;

    Result := ListClassType.Create(ItemsArray);
  finally
    JSONResult.Free;
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
    URL := Format('%s/%s/profiles/%s', [GetPath, FLid, AId]);

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

  URL := Format('%s/%s/profiles/new', [GetPath, FLid]);

  JSONProfile := AEntity.Serialize();

  JSONRequestStream := TStringStream.Create(JSONProfile.ToJSON, TEncoding.UTF8);
  try
Log(JSONRequestStream.DataString);
//exit;
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

  URL := Format('%s/%s/profiles/%s/update', [GetPath, FLid, (AEntity as TProfile).Id ]);

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

  URL := Format('%s/%s/profiles/%s/remove', [GetPath, FLid, AId ]);

  JSONRequestStream := TStringStream.Create('{}', TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);
    Result := True;
  finally
    JSONRequestStream.Free;
  end;
end;

// Synchronize заменит все профили линка на src
function TProfilesBroker.Synchronize(src: TProfileList): boolean;
var
  Pages : integer;
begin
  result := false;
  var lst := List(Pages);
  for var l in lst do
    if not Remove(l.Id) then
      exit;
  for var p in src do
    if not New(p) then
      exit;
  result := true;
end;

end.
