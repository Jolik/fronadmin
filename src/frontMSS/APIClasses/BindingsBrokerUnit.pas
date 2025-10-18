unit BindingsBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit, BindingUnit, EntityBrokerUnit;

type
  /// <summary>Broker for metadata bindings API.</summary>
  TBindingsBroker = class(TEntityBroker)
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
      const AOrder: String = 'created';
      const AOrderDir: String = 'asc'): TEntityList; override;

    function CreateNew(): TEntity; override;
    function New(AEntity: TEntity): Boolean; override;
    function Info(AId: String): TEntity; overload; override;
    function Update(AEntity: TEntity): Boolean; override;
    function Remove(AId: String): Boolean; overload; override;

    function NewGroup(ABindings: TBindingList; out ACreatedBids: TArray<string>): Boolean;
  end;

implementation

uses
  System.SysUtils, System.Classes,
  FuncUnit,
  APIConst;

const
  constURLBindingsBasePath = constURLMetadataBasePath;
  constURLBindingsList = '/bindings/list';
  constURLBindingsInfo = '/bindings/%s';
  constURLBindingsNew = '/bindings/new';
  constURLBindingsNewGroup = '/bindings/newgroup';
  constURLBindingsUpdate = '/bindings/%s/update';
  constURLBindingsRemove = '/bindings/%s/remove';
  ResponseKey = 'response';
  BindingsKey = 'bindings';
  BindingKey = 'binding';
  InfoKey = 'info';
  ItemsKey = 'items';
  PageCountKey = 'pagecount';
  BidKey = 'bid';
  CompIdKey = 'compid';
  EntityKey = 'entity';
  TypeKey = 'type';
  UrnKey = 'urn';
  IndexKey = 'index';
  DataKey = 'data';

{ TBindingsBroker }

class function TBindingsBroker.ClassType: TEntityClass;
begin
  Result := TBinding;
end;

function TBindingsBroker.CreateNew: TEntity;
begin
  Result := ClassType.Create;
end;

function TBindingsBroker.GetBasePath: string;
begin
  Result := constURLBindingsBasePath;
end;

function TBindingsBroker.Info(AId: String): TEntity;
var
  URL: string;
  ResStr: string;
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  BindingValue: TJSONValue;
begin
  Result := nil;

  if AId = '' then
    Exit;

  try
    URL := Format(GetBasePath + constURLBindingsInfo, [AId]);
    ResStr := MainHttpModuleUnit.GET(URL);

    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
    try
      ResponseObject := JSONResult.GetValue(ResponseKey) as TJSONObject;
      if not Assigned(ResponseObject) then
        Exit;

      BindingValue := ResponseObject.GetValue(BindingKey);
      if BindingValue is TJSONObject then
        Result := ClassType.Create(BindingValue as TJSONObject);
    finally
      JSONResult.Free;
    end;
  except
    on E: Exception do
    begin
      Log('TBindingsBroker.Info ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TBindingsBroker.List(out APageCount: Integer; const APage,
  APageSize: Integer; const ASearchStr, ASearchBy, AOrder,
  AOrderDir: String): TEntityList;
var
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  BindingsObject: TJSONObject;
  ItemsValue: TJSONValue;
  ItemsArray: TJSONArray;
  RequestStream: TStringStream;
  ResStr: string;
  InfoObject: TJSONObject;
begin
  Result := nil;
  APageCount := 0;

  try
    JSONResult := nil;
    RequestStream := TStringStream.Create('{}', TEncoding.UTF8);
    try
      ResStr := MainHttpModuleUnit.POST(GetBasePath + constURLBindingsList, RequestStream);
      JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
      if not Assigned(JSONResult) then
        Exit;

      ResponseObject := JSONResult.GetValue(ResponseKey) as TJSONObject;
      if not Assigned(ResponseObject) then
        Exit;

      BindingsObject := ResponseObject.GetValue(BindingsKey) as TJSONObject;
      if not Assigned(BindingsObject) then
        Exit;

      InfoObject := BindingsObject.GetValue(InfoKey) as TJSONObject;
      if Assigned(InfoObject) then
        APageCount := GetValueIntDef(InfoObject, PageCountKey, 0);

      ItemsValue := BindingsObject.GetValue(ItemsKey);
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
      Log('TBindingsBroker.List ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TBindingsBroker.New(AEntity: TEntity): Boolean;
var
  URL: string;
  Binding: TBinding;
  RequestObject: TJSONObject;
  RequestStream: TStringStream;
  ResStr: string;
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  BidValue: TJSONValue;
  DataObject: TJSONObject;
begin
  Result := false;

  if not (AEntity is TBinding) then
    Exit;

  Binding := TBinding(AEntity);

  URL := GetBasePath + constURLBindingsNew;

  RequestObject := TJSONObject.Create;
  try
    if Binding.Bid <> '' then
      RequestObject.AddPair(BidKey, Binding.Bid);
    if Binding.CompId <> '' then
      RequestObject.AddPair(CompIdKey, Binding.CompId);
    if Binding.EntityId <> '' then
      RequestObject.AddPair(EntityKey, Binding.EntityId);
    if Binding.BindingType <> '' then
      RequestObject.AddPair(TypeKey, Binding.BindingType);
    if Binding.Urn <> '' then
      RequestObject.AddPair(UrnKey, Binding.Urn);
    if Binding.Index <> '' then
      RequestObject.AddPair(IndexKey, Binding.Index);

    DataObject := Binding.BindingData.Serialize();
    if Assigned(DataObject) then
      RequestObject.AddPair(DataKey, DataObject);

    RequestStream := TStringStream.Create(RequestObject.ToJSON, TEncoding.UTF8);
    try
      ResStr := MainHttpModuleUnit.POST(URL, RequestStream);
      Result := true;
    finally
      RequestStream.Free;
    end;
  finally
    RequestObject.Free;
  end;

  if not Result then
    Exit;

  if ResStr = '' then
    Exit;

  JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
  try
    if not Assigned(JSONResult) then
      Exit;

    ResponseObject := JSONResult.GetValue(ResponseKey) as TJSONObject;
    if not Assigned(ResponseObject) then
      Exit;

    BidValue := ResponseObject.GetValue(BidKey);
    if Assigned(BidValue) then
      Binding.Bid := BidValue.Value;
  finally
    JSONResult.Free;
  end;
end;

function TBindingsBroker.NewGroup(ABindings: TBindingList;
  out ACreatedBids: TArray<string>): Boolean;
var
  URL: string;
  RequestObject: TJSONObject;
  BindingsArray: TJSONArray;
  Binding: TBinding;
  BindingJson: TJSONObject;
  RequestStream: TStringStream;
  ResStr: string;
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  BidsValue: TJSONValue;
  BidsArray: TJSONArray;
  I: Integer;
begin
  Result := false;
  SetLength(ACreatedBids, 0);

  if not Assigned(ABindings) then
    Exit;

  URL := GetBasePath + constURLBindingsNewGroup;

  RequestObject := TJSONObject.Create;
  try
    BindingsArray := TJSONArray.Create;
    RequestObject.AddPair(BindingsKey, BindingsArray);

    for Binding in ABindings do
    begin
      BindingJson := TJSONObject.Create;
      try
        if Binding.Bid <> '' then
          BindingJson.AddPair(BidKey, Binding.Bid);
        if Binding.CompId <> '' then
          BindingJson.AddPair(CompIdKey, Binding.CompId);
        if Binding.EntityId <> '' then
          BindingJson.AddPair(EntityKey, Binding.EntityId);
        if Binding.BindingType <> '' then
          BindingJson.AddPair(TypeKey, Binding.BindingType);
        if Binding.Urn <> '' then
          BindingJson.AddPair(UrnKey, Binding.Urn);
        if Binding.Index <> '' then
          BindingJson.AddPair(IndexKey, Binding.Index);

        var DataObject := Binding.BindingData.Serialize();
        if Assigned(DataObject) then
          BindingJson.AddPair(DataKey, DataObject);

        BindingsArray.AddElement(BindingJson);
      except
        BindingJson.Free;
        raise;
      end;
    end;

    RequestStream := TStringStream.Create(RequestObject.ToJSON, TEncoding.UTF8);
    try
      ResStr := MainHttpModuleUnit.POST(URL, RequestStream);
      Result := true;
    finally
      RequestStream.Free;
    end;
  finally
    RequestObject.Free;
  end;

  if not Result then
    Exit;

  JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
  try
    if not Assigned(JSONResult) then
      Exit;

    ResponseObject := JSONResult.GetValue(ResponseKey) as TJSONObject;
    if not Assigned(ResponseObject) then
      Exit;

    BidsValue := ResponseObject.GetValue(BindingsKey);
    if not (BidsValue is TJSONArray) then
      Exit;

    BidsArray := TJSONArray(BidsValue);
    SetLength(ACreatedBids, BidsArray.Count);
    for I := 0 to BidsArray.Count - 1 do
      ACreatedBids[I] := BidsArray.Items[I].Value;
  finally
    JSONResult.Free;
  end;
end;

function TBindingsBroker.Remove(AId: String): Boolean;
var
  URL: string;
  RequestObject: TJSONObject;
  RequestStream: TStringStream;
begin
  Result := false;

  if AId = '' then
    Exit;

  URL := Format(GetBasePath + constURLBindingsRemove, [AId]);

  RequestObject := TJSONObject.Create;
  try
    RequestObject.AddPair(BidKey, AId);
    RequestStream := TStringStream.Create(RequestObject.ToJSON, TEncoding.UTF8);
    try
      MainHttpModuleUnit.POST(URL, RequestStream);
      Result := true;
    finally
      RequestStream.Free;
    end;
  finally
    RequestObject.Free;
  end;
end;

function TBindingsBroker.Update(AEntity: TEntity): Boolean;
var
  Binding: TBinding;
  URL: string;
  RequestObject: TJSONObject;
  RequestStream: TStringStream;
  DataObject: TJSONObject;
begin
  Result := false;

  if not (AEntity is TBinding) then
    Exit;

  Binding := TBinding(AEntity);
  if Binding.Bid = '' then
    Exit;

  URL := Format(GetBasePath + constURLBindingsUpdate, [Binding.Bid]);

  RequestObject := TJSONObject.Create;
  try
    if Binding.EntityId <> '' then
      RequestObject.AddPair(EntityKey, Binding.EntityId);
    if Binding.Urn <> '' then
      RequestObject.AddPair(UrnKey, Binding.Urn);
    if Binding.Index <> '' then
      RequestObject.AddPair(IndexKey, Binding.Index);

    DataObject := Binding.BindingData.Serialize();
    if Assigned(DataObject) and (DataObject.Count > 0) then
      RequestObject.AddPair(DataKey, DataObject)
    else
      DataObject.Free;

    RequestStream := TStringStream.Create(RequestObject.ToJSON, TEncoding.UTF8);
    try
      MainHttpModuleUnit.POST(URL, RequestStream);
      Result := true;
    finally
      RequestStream.Free;
    end;
  finally
    RequestObject.Free;
  end;
end;

end.

