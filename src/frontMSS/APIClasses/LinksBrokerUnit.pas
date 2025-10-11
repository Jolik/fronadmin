unit LinksBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  MainModule,
  LoggingUnit,
  EntityUnit, LinkUnit, ParentBrokerUnit;


type
  ///  ������ ��� API Links
  TLinksBroker = class (TParentBroker)
    /// ���������� ������ ���������
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
    ///  � ������ ������ ������������ falsr
    function Update(AEntity: TEntity): Boolean; override;
    ///  ������� �������� �� ������� �� ��������������
    ///  � ������ ������ ������������ false
    function Remove(AId: String): Boolean; overload; override;
    ///  ������� �������� �� �������
    ///  � ������ ������ ������������ false
    function Remove(AEntity: TEntity): Boolean; overload; override;

  end;

implementation




uses
  System.SysUtils, System.Classes,
  FuncUnit;

const
  constURLLinkGetList = '/datacomm/api/v1/links/list';
  constURLLinkGetOneInfo = '/datacomm/api/v1/links/%s/info';
  constURLLinkInsert = '/datacomm/api/v1/links/new';
  constURLLinkUpdate = '/datacomm/api/v1/links/%s/update';
  constURLLinkDelete = '/datacomm/api/v1/links/%s/remove';

{ TLinksBroker }

//function TLinksBroker.LinkGetList(
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
//  URL := constURLLinkGetList;
//  JSONRequest := CreateJSONRequest;
//  JSONResult := TJSONObject.Create;
//  try
//    Result.FieldDefs.Add('abid', ftGuid);
//    Result.FieldDefs.Add('name', ftString, 256);
//    Result.FieldDefs.Add('caption', ftString, 256);
//    Result.FieldDefs.Add('created', ftDateTime);
//    Result.FieldDefs.Add('updated', ftDateTime);
//
//    ResStr := MainModule.POST(constURLLinkGetList, JSONRequest.ToJSON);
//
//    JSONResult.ParseJSONValue(ResStr);
//
//  finally
//    JSONRequest.Free;
//    JSONResult.Free;
//  end;
//end;

/// ���������� ������ ���������
///  � ������ ������ ������������ nil
function TLinksBroker.List(
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
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;
  LinkList: TJSONArray;
  ResStr: String;

begin
  Result := TLinkList.Create();
  try

    JSONResult := TJSONObject.Create;
    try
      ///  ������ ������
      ResStr := MainModule.GET(constURLLinkGetList);
      ///  ������ ���������
      JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
      ///  ������ - �����
      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      ///  ������ ������
      LinkList := ResponseObject.GetValue('links') as TJSONArray;

      ///  ��������� ���������
      ///  ���������� ������� �� ��������������
      APageCount := 0;
      for var l in LinkList do
      begin
        var link := Info(GetValueStrDef(l, 'lid', ''));
        if link = nil then
          continue;
        result.Add(link);
      end;
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

function TLinksBroker.CreateNew: TEntity;
begin
  Result := TLink.Create();
end;

///  ������ ���������� � �������� � �������
///  � ������ ������ ������������ nil
function TLinksBroker.Info(AEntity: TEntity): TEntity;
begin
  result := Info(AEntity.Id);
end;

///  ������ ���������� � �������� � ������� �� ��������������
///  � ������ ������ ������������ nil
function TLinksBroker.Info(AId: String): TEntity;
var
  URL: String;
  ResStr: String;
  JSONResult: TJSONObject;
  ResponseObject: TJSONObject;

begin
  if AId = '' then
    exit;
  Result := TLink.Create;
  try
    URL := Format(constURLLinkGetOneInfo, [AId]);
    ResStr := MainModule.GET(URL);
    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
    try
      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      var TypeStr := GetValueStrDef(ResponseObject, 'type', '');
(*!!!      var Parser: TLinkParser;
      if not ParsersMap.TryGetValue(TypeStr, Parser) then
        raise Exception.CreateFmt('TLinksBroker.Info parser for "%s" not found', [TypeStr]);
      Result := Parser.Parse(ResponseObject); *)
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
///  � ������ ������ ������������ nil
function TLinksBroker.New(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONLink: TJSONObject;
  JSONRequest: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;
begin
(*!!!  URL := constURLLinkInsert;
  AEntity.DataFromEntity(JSONLink);
  JSONRequest := FuncUnit.ExtractJSONProperties(JSONLink, ['name', 'caption','Links','attr']);
  JSONRequestStream := TStringStream.Create(JSONRequest.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainModule.POST(URL, JSONRequestStream);
  finally
    JSONLink.Free;
    JSONRequest.Free;
    JSONRequestStream.Free;
  end; *)
end;

///  �������� ��������� �������� �� �������
///  � ������ ������ ������������ nil
function TLinksBroker.Update(AEntity: TEntity): Boolean;
var
  URL: String;
  ResStr: String;
  JSONLink: TJSONObject;
  JSONRequest: TJSONObject;
  JSONRequestStream: TStringStream;

begin
(*!!!  Result := False;
  URL := Format(constURLLinkUpdate, [AId]);
  JSONLink := ALink.ToJSON;
  JSONRequest := Common_Func.ExtractJSONProperties(JSONLink, ['caption','Links','attr']);
  JSONRequestStream := TStringStream.Create(JSONRequest.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainModule.POST(URL, JSONRequestStream);
  finally
    JSONLink.Free;
    JSONRequest.Free;
    JSONRequestStream.Free;
  end; *)
end;

///  ������� �������� �� �������
///  � ������ ������ ������������ false
function TLinksBroker.Remove(AEntity: TEntity): Boolean;
begin

end;

///  ������� �������� �� ������� �� ��������������
///  � ������ ������ ������������ false
function TLinksBroker.Remove(AId: String): Boolean;
var
  URL: String;
  ResStr: String;
begin
  URL := Format(constURLLinkDelete, [AId]);
  ResStr := MainModule.GET(URL)
end;

end.
