unit ChannelsBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit, IdHTTP,
  MainHttpModuleUnit, uniGUIDialogs,
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, LinkUnit,
  uniGUIClasses, uniGUIFrame, uniGUIBaseClasses, uniTabControl, uniPanel,
  uniButton, uniPageControl, ProfileUnit, uniBitBtn, uniMultiItem, uniListBox,
  uniLabel, ProfileFrameUnit, uniComboBox, ProfilesBrokerUnit,
  EntityUnit, ChannelUnit, EntityBrokerUnit;


type
  ///  брокер для API Channels
  TChannelsBroker = class (TEntityBroker)
  protected
    FCompid:string;
    FDeptid:string;
    function GetBasePath: string; override;
    class function ListClassType: TEntityListClass; override;
    class function ClassType: TEntityClass; override;
  public
    /// возвращает список каналов
    ///  в случае ошибки возвращается nil
    function List(
      out APageCount: Integer;
      const APage: Integer = 0;
      const APageSize: Integer = 50;
      const ASearchStr: String = '';
      const ASearchBy: String = '';
      const AOrder: String = 'name';
      const AOrderDir: String = 'asc'): TEntityList; override;

    ///  создает нужный класс сущности
    ///  в случае ошибки возвращается nil
    function CreateNew(): TEntity; override;
    ///  создает на сервере новый класс сущности
    ///  в случае ошибки возвращается false
    function New(AEntity: TEntity): Boolean; override;
    ///  выдает информацию о сущности с сервера по идентификатору
    ///  в случае ошибки возвращается nil
    function Info(AId: String): TEntity; overload; override;
    ///  выдает информацию о сущности с сервера
    ///  в случае ошибки возвращается nil
    function Info(AEntity: TEntity): TEntity; overload; override;
    ///  обновить параметры сущности на сервере
    ///  в случае ошибки возвращается false
    function Update(AEntity: TEntity): Boolean; override;
    ///  удалить сущность на сервере по идентификатору
    ///  в случае ошибки возвращается false
    function Remove(AId: String): Boolean; overload; override;

    constructor Create(compid,deptid: string);
  end;

implementation

uses
  FuncUnit, APIConst;

const
  constURLChannelGetList = '/router/api/v2/channels/list';
  constURLChannelGetOneInfo = '/router/api/v2/channels/%s';
  constURLChannelInsert = '/router/api/v2/channels/new';
  constURLChannelUpdate = '/router/api/v2/channels/%s/update';
  constURLChannelDelete = '/router/api/v2/rou/%s/remove';

{ TChannelsBroker }


function TChannelsBroker.GetBasePath: string;
begin
   result := constURLRouterBasePath;
end;


//function TChannelsBroker.ChannelGetList(
//  const APage, APageSize: Integer;
//  out APageCount: Integer;
//  const ASearchStr, ASearchBy, AOrder,
//  AOrderDir: String): TDataset;

//  function CreateJSONRequest: TJSONObject;
//  begin
//    Result := TJSONObject.Create;
//    Result.AddPair('page', APage);
//    Result.AddPair('pagesize', APageSize);
//    Result.AddPair('searchStr', ASearchStr);
//    Result.AddPair('searchBy', ASearchBy);
//    Result.AddPair('order', AOrder);
//    Result.AddPair('orderDir', AOrderDir);
//  end;
//
//var
//  URL: String;
//  JSONRequest: TJSONObject;
//  JSONResult: TJSONObject;
//  ResStr: String;

//begin
//  Result := TFDDataSet.Create(nil);
//  URL := constURLChannelGetList;
//  JSONRequest := CreateJSONRequest;
//  JSONResult := TJSONObject.Create;
//  try
//    Result.FieldDefs.Add('abid', ftGuid);
//    Result.FieldDefs.Add('name', ftString, 256);
//    Result.FieldDefs.Add('caption', ftString, 256);
//    Result.FieldDefs.Add('created', ftDateTime);
//    Result.FieldDefs.Add('updated', ftDateTime);
//
//    ResStr := MainHttpModule.POST(constURLChannelGetList, JSONRequest.ToJSON);
//
//    JSONResult.ParseJSONValue(ResStr);
//
//  finally
//    JSONRequest.Free;
//    JSONResult.Free;
//  end;
//end;







/// возвращает список каналов
///  в случае ошибки возвращается nil
function TChannelsBroker.List(
  out APageCount: Integer;
  const APage: Integer = 0;
  const APageSize: Integer = 50;
  const ASearchStr: String = '';
  const ASearchBy: String = '';
  const AOrder: String = 'name';
  const AOrderDir: String = 'asc'): TEntityList;

  function CreateJSONRequest: TJSONObject;
  begin
    Result := TJSONObject.Create;
    Result.AddPair('page', APage);
    Result.AddPair('pagesize', APageSize);
    Result.AddPair('searchStr', ASearchStr);
    Result.AddPair('searchBy', ASearchBy);
    Result.AddPair('order', AOrder);
    Result.AddPair('orderDir', AOrderDir);
  end;

var
  URL: String;
  JSONRequest: TJSONObject;
  JSONRequestStream: TStringStream;
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  InfoObject: TJSONObject;
  ResStr: String;

begin
  Result := nil;
  try

    JSONResult := TJSONObject.Create;
    try
      ResStr := MainHttpModuleUnit.GET(constURLChannelGetList);
      JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      var channelsArray := ResponseObject.GetValue('channels') as TJSONArray;
      Result := ListClassType.Create(channelsArray);
    finally
      JSONResult.Free;
    end;

  except on e:exception do
    begin
      Log('TLinksBroker.List '+ e.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

class function TChannelsBroker.ListClassType: TEntityListClass;
begin
  result := TChannelList;
end;

class function TChannelsBroker.ClassType: TEntityClass;
begin
  result := TChannel;
end;

constructor TChannelsBroker.Create(compid, deptid: string);
begin
  inherited Create;
  FCompid:= compid;
  FDeptid:= deptid;
end;

function TChannelsBroker.CreateNew: TEntity;
begin
  Result := TChannel.Create();
end;

///  выдает информацию о сущности с сервера
///  в случае ошибки возвращается nil
function TChannelsBroker.Info(AEntity: TEntity): TEntity;
begin

end;

///  выдает информацию о сущности с сервера по идентификатору
///  в случае ошибки возвращается nil
function TChannelsBroker.Info(AId: String): TEntity;
var
  URL: String;
  ResStr: String;
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;

begin
   Result := nil;
  try

    JSONResult := TJSONObject.Create;
    try
      URL := Format(constURLChannelGetOneInfo, [AId]);
      ResStr := MainHttpModuleUnit.GET(URL);
      JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      var channel := ResponseObject.FindValue('channel');
      if not (channel is TJSONObject) then
        exit;
      Result := TChannel.Create(channel as TJSONObject);
    finally
      JSONResult.Free;
    end;

  except on e:exception do
    begin
      Log('TLinksBroker.Info '+ e.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;








///  создает на сервере новый класс сущности
///  в случае ошибки возвращается false
function TChannelsBroker.New(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONLink: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;

begin
  ///  строим запрос
  URL := GetBasePath +  '/channels/new';
  ///  получаем из сущности JSON
  JSONLink := AEntity.Serialize();

  JSONRequestStream := TStringStream.Create(JSONLink.ToJSON, TEncoding.UTF8);
  try

    try
      ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);
      Result := true;
    except
      on E:EIdHTTPProtocolException do
      begin
        Log('TChannelsBroker.New: ' + E.ErrorMessage, lrtError);
        Log('TChannelsBroker.New request:'+JSONRequestStream.DataString);
        MessageDlg(Format('TChannelsBroker.New: ' + E.ErrorMessage, []), TMsgDlgType.mtError, [mbOK], nil)
      end;
    end;

  finally
    JSONLink.Free;
    JSONRequestStream.Free;
  end;

end;



///  обновить параметры сущности на сервере
///  в случае ошибки возвращается false
function TChannelsBroker.Update(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONLink: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;

begin
  ///  если пытаются передать не наш класс то не делаем ничего!
  if not (AEntity is TChannel) then
    exit;

  ///  строим запрос
  URL := Format(GetBasePath + '/channels/%s/update', [AEntity.Id]);

  ///  получаем из сущности JSON
  JSONLink := AEntity.Serialize();

  JSONRequestStream := TStringStream.Create(JSONLink.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);

    ////  !!! обрабатываем ответ
    ///  пока возвращаем всегда true
    Result := true;

  finally
    JSONLink.Free;
    JSONRequestStream.Free;
  end;

end;


///  удалить сущность на сервере по идентификатору
///  в случае ошибки возвращается false
function TChannelsBroker.Remove(AId: String): Boolean;
var
  URL: String;
  ResStr: String;
  JSONRequestStream: TStringStream;

begin
  URL := Format(GetBasePath +  '/channels/%s/remove', [AId]);
  JSONRequestStream := TStringStream.Create('{}', TEncoding.UTF8);
  ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);
end;

end.
