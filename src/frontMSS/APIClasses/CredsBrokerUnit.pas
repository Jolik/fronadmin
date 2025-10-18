unit CredsBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit, CredUnit, EntityBrokerUnit;

type
  /// <summary>
  ///   Broker for dataserver credentials API.
  /// </summary>
  TCredsBroker = class(TEntityBroker)
  protected
    function GetBasePath: string; override;
    class function ClassType: TEntityClass; override;
    class function ListClassType: TEntityListClass; override;
    class function ResponseClassType: TResponseClass; override;
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

  /// <summary>
  ///   Response helper for credential API calls.
  /// </summary>
  TCredsResponse = class(TResponse)
  private
    FCrid: string;
  public
    function ParseResponse(AResStr: string): boolean; override;
    property Crid: string read FCrid;
  end;

implementation

uses
  System.SysUtils, System.Classes,
  FuncUnit,
  APIConst;

const
  constURLCredsList = '/sources/contexts/creds/list';
  constURLCredsInfo = '/sources/contexts/creds/%s';
  constURLCredsNew = '/sources/contexts/creds/new';
  constURLCredsUpdate = '/sources/contexts/creds/%s/update';
  constURLCredsRemove = '/sources/contexts/creds/%s/remove';

{ TCredsBroker }

class function TCredsBroker.ClassType: TEntityClass;
begin
  Result := TCred;
end;

function TCredsBroker.CreateNew: TEntity;
begin
  Result := ClassType.Create();
end;

function TCredsBroker.GetBasePath: string;
begin
  Result := constURLDataserverBasePath;
end;

function TCredsBroker.Info(AId: String): TEntity;
var
  URL: string;
  ResStr: string;
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  CredentialValue: TJSONValue;
begin
  Result := nil;

  if AId = '' then
    Exit;

  try
    URL := Format(GetBasePath + constURLCredsInfo, [AId]);

    ResStr := MainHttpModuleUnit.GET(URL);

    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
    try
      if not Assigned(JSONResult) then
        Exit;

      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      if not Assigned(ResponseObject) then
        Exit;

      CredentialValue := ResponseObject.GetValue('credential');
      if CredentialValue is TJSONObject then
        Result := ClassType.Create(CredentialValue as TJSONObject);
    finally
      JSONResult.Free;
    end;
  except
    on E: Exception do
    begin
      Log('TCredsBroker.Info ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TCredsBroker.List(out APageCount: Integer; const APage,
  APageSize: Integer; const ASearchStr, ASearchBy, AOrder,
  AOrderDir: String): TEntityList;
var
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  CredsObject: TJSONObject;
  ItemsValue: TJSONValue;
  ItemsArray: TJSONArray;
  RequestObject: TJSONObject;
  RequestStream: TStringStream;
  ResStr: string;
  InfoObject: TJSONObject;
begin
  Result := nil;
  APageCount := 0;

  try
    JSONResult := nil;
    RequestObject := TJSONObject.Create;
    try
      RequestStream := TStringStream.Create(RequestObject.ToJSON, TEncoding.UTF8);
      try
        ResStr := MainHttpModuleUnit.POST(GetBasePath + constURLCredsList, RequestStream);
        JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
        if not Assigned(JSONResult) then
          Exit;

        ResponseObject := JSONResult.GetValue('response') as TJSONObject;
        if not Assigned(ResponseObject) then
          Exit;

        CredsObject := ResponseObject.GetValue('credentials') as TJSONObject;
        if not Assigned(CredsObject) then
          Exit;

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
        RequestStream.Free;
      end;
    finally
      JSONResult.Free;
      RequestObject.Free;
    end;
  except
    on E: Exception do
    begin
      Log('TCredsBroker.List ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TCredsBroker.New(AEntity: TEntity): Boolean;
var
  URL: string;
  JSONCredential: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: string;
  Response: TResponse;
  Credential: TCred;
begin
  Result := False;

  if not Assigned(AEntity) then
    Exit;

  Credential := nil;
  if AEntity is TCred then
    Credential := TCred(AEntity);

  if Assigned(Credential) then
  begin
    if (Credential.Name = '') and (Credential.Login <> '') then
      Credential.Name := Credential.Login;
  end;

  try
    URL := GetBasePath + constURLCredsNew;
    JSONCredential := TJSONObject.Create;
    try
      AEntity.Serialize(JSONCredential);

      JSONRequestStream := TStringStream.Create(JSONCredential.ToJSON, TEncoding.UTF8);
      try
        ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);

        Response := ResponseClassType.CreateWithResponse(ResStr);
        try
          Result := Response.ResBool;
          if Result and Assigned(Credential) and (Response is TCredsResponse) then
            Credential.Crid := TCredsResponse(Response).Crid;
        finally
          Response.Free;
        end;
      finally
        JSONRequestStream.Free;
      end;
    finally
      JSONCredential.Free;
    end;
  except
    on E: Exception do
    begin
      Log('TCredsBroker.New ' + E.Message, lrtError);
      Result := False;
    end;
  end;
end;

function TCredsBroker.Remove(AId: String): Boolean;
var
  URL: string;
  ResStr: string;
  Response: TResponse;
begin
  Result := False;

  if AId = '' then
    Exit;

  try
    URL := Format(GetBasePath + constURLCredsRemove, [AId]);
    ResStr := MainHttpModuleUnit.POST(URL);

    Response := ResponseClassType.CreateWithResponse(ResStr);
    try
      Result := Response.ResBool;
    finally
      Response.Free;
    end;
  except
    on E: Exception do
    begin
      Log('TCredsBroker.Remove ' + E.Message, lrtError);
      Result := False;
    end;
  end;
end;

class function TCredsBroker.ResponseClassType: TResponseClass;
begin
  Result := TCredsResponse;
end;

function TCredsBroker.Update(AEntity: TEntity): Boolean;
var
  URL: string;
  JSONCredential: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: string;
  Response: TResponse;
  Credential: TCred;
begin
  Result := False;

  if not Assigned(AEntity) then
    Exit;

  if AEntity.Id = '' then
    Exit;

  Credential := nil;
  if AEntity is TCred then
    Credential := TCred(AEntity);

  if Assigned(Credential) then
  begin
    if (Credential.Name = '') and (Credential.Login <> '') then
      Credential.Name := Credential.Login;
  end;

  try
    URL := Format(GetBasePath + constURLCredsUpdate, [AEntity.Id]);
    JSONCredential := TJSONObject.Create;
    try
      AEntity.Serialize(JSONCredential);

      JSONRequestStream := TStringStream.Create(JSONCredential.ToJSON, TEncoding.UTF8);
      try
        ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);

        Response := ResponseClassType.CreateWithResponse(ResStr);
        try
          Result := Response.ResBool;
          if Result and Assigned(Credential) and (Response is TCredsResponse) and
            (TCredsResponse(Response).Crid <> '') then
            Credential.Crid := TCredsResponse(Response).Crid;
        finally
          Response.Free;
        end;
      finally
        JSONRequestStream.Free;
      end;
    finally
      JSONCredential.Free;
    end;
  except
    on E: Exception do
    begin
      Log('TCredsBroker.Update ' + E.Message, lrtError);
      Result := False;
    end;
  end;
end;

{ TCredsResponse }

function TCredsResponse.ParseResponse(AResStr: string): boolean;
var
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  CredentialObject: TJSONObject;
begin
  Result := False;
  FCrid := '';

  if AResStr = '' then
    Exit;

  JSONResult := TJSONObject.ParseJSONValue(AResStr) as TJSONObject;
  try
    if not Assigned(JSONResult) then
      Exit;

    ResponseObject := JSONResult.GetValue('response') as TJSONObject;
    if not Assigned(ResponseObject) then
    begin
      Result := True;
      Exit;
    end;

    CredentialObject := ResponseObject.GetValue('credential') as TJSONObject;
    if not Assigned(CredentialObject) then
    begin
      Result := True;
      Exit;
    end;

    FCrid := GetValueStrDef(CredentialObject, 'crid', '');
    Result := True;
  finally
    JSONResult.Free;
  end;
end;

end.

