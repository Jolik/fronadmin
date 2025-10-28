unit ChannelsBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit, ChannelUnit, EntityBrokerUnit;


type
  ///  ������ ��� API Channels
  TChannelsBroker = class (TEntityBroker)
  protected
    FCompid:string;
    FDeptid:string;
    function GetBasePath: string; override;
    class function ListClassType: TEntityListClass; override;
    class function ClassType: TEntityClass; override;
  public
    /// ���������� ������ �������
    ///  � ������ ������ ������������ nil
    function List(
      out APageCount: Integer;
      const APage: Integer = 0;
      const APageSize: Integer = 50;
      const ASearchStr: String = '';
      const ASearchBy: String = '';
      const AOrder: String = 'name';
      const AOrderDir: String = 'asc'): TEntityList; override;

    ///  ������� ������ ����� ��������
    ///  � ������ ������ ������������ nil
    function CreateNew(): TEntity; override;
    ///  ������� �� ������� ����� ����� ��������
    ///  � ������ ������ ������������ false
    function New(AEntity: TEntity): Boolean; override;
    ///  ������ ���������� � �������� � ������� �� ��������������
    ///  � ������ ������ ������������ nil
    function Info(AId: String): TEntity; overload; override;
    ///  ������ ���������� � �������� � �������
    ///  � ������ ������ ������������ nil
    function Info(AEntity: TEntity): TEntity; overload; override;
    ///  �������� ��������� �������� �� �������
    ///  � ������ ������ ������������ false
    function Update(AEntity: TEntity): Boolean; override;
    ///  ������� �������� �� ������� �� ��������������
    ///  � ������ ������ ������������ false
    function Remove(AId: String): Boolean; overload; override;
    ///  ������� �������� �� �������
    ///  � ������ ������ ������������ false
    function Remove(AEntity: TEntity): Boolean; overload; override;

    constructor Create(compid,deptid: string);
  end;

implementation

uses
  System.SysUtils, System.Classes,
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







/// ���������� ������ �������
///  � ������ ������ ������������ nil
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

///  ������ ���������� � �������� � �������
///  � ������ ������ ������������ nil
function TChannelsBroker.Info(AEntity: TEntity): TEntity;
begin

end;

///  ������ ���������� � �������� � ������� �� ��������������
///  � ������ ������ ������������ nil
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








///  ������� �� ������� ����� ����� ��������
///  � ������ ������ ������������ false
function TChannelsBroker.New(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONRequest: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;

begin
  (*!!! URL := constURLChannelInsert;
  AEntity.DataFromEntity(JSONChannel);
  JSONRequest := FuncUnit.ExtractJSONProperties(JSONChannel, ['name', 'caption','channels','attr']);
  JSONRequestStream := TStringStream.Create(JSONRequest.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModule.POST(URL, JSONRequestStream);
  finally
    JSONChannel.Free;
    JSONRequest.Free;
    JSONRequestStream.Free;
  end; *)
end;

///  �������� ��������� �������� �� �������
///  � ������ ������ ������������ false
function TChannelsBroker.Update(AEntity: TEntity): Boolean;
var
  URL: String;
  ResStr: String;
  JSONRequest: TJSONObject;
  JSONRequestStream: TStringStream;

begin
(*!!!  Result := False;
  URL := Format(constURLChannelUpdate, [AId]);
  JSONRequest := Common_Func.ExtractJSONProperties(JSONChannel, ['caption','channels','attr']);
  JSONRequestStream := TStringStream.Create(JSONRequest.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModule.POST(URL, JSONRequestStream);
  finally
    JSONRequest.Free;
    JSONRequestStream.Free;
  end; *)
end;

///  ������� �������� �� �������
///  � ������ ������ ������������ false
function TChannelsBroker.Remove(AEntity: TEntity): Boolean;
begin

end;

///  ������� �������� �� ������� �� ��������������
///  � ������ ������ ������������ false
function TChannelsBroker.Remove(AId: String): Boolean;
var
  URL: String;
  ResStr: String;
begin
  URL := Format(constURLChannelDelete, [AId]);
  ResStr := MainHttpModuleUnit.GET(URL)
end;

end.
