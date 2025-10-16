unit LinksBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit, LinkUnit, EntityBrokerUnit;


type
  ///  ������ ��� API Links
  TLinksBroker = class (TEntityBroker)
  protected
    ///  ���������� ������� ���� �� API
    function BaseUrlPath: string; override;
    ///  ����� ���������� ���������� ��� �������� � ������� �������� ������
    ///  ������� ������ �������������� ���, ������ ��� �� � ���� ������
    class function ClassType: TEntityClass; override;
    ///  ����� ���������� ���������� ��� ������� �������� ������
    ///  ������� ������ �������������� ���, ������ ��� �� � ���� ������
    class function ListClassType: TEntityListClass; override;

  public
    /// ���������� ������ �����
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
    ///  �������� ��������� �������� �� �������
    ///  � ������ ������ ������������ false
    function Update(AEntity: TEntity): Boolean; override;
    ///  ������� �������� �� ������� �� ��������������
    ///  � ������ ������ ������������ false
    function Remove(AId: String): Boolean; overload; override;

  end;

implementation

uses
  System.SysUtils, System.Classes,
  FuncUnit,
  APIConst;

const
  constURLLinkGetList = '/links/list';
  constURLLinkGetOneInfo = '/links/%s/info';
  constURLLinkNew = '/links/new';
  constURLLinkUpdate = '/links/%s/update';
  constURLLinkDelete = '/links/%s/remove';

{ TLinksBroker }

function TLinksBroker.BaseUrlPath: string;
begin
  Result := constURLDatacommBasePath;
end;

class function TLinksBroker.ClassType: TEntityClass;
begin
  Result := TLink;
end;

class function TLinksBroker.ListClassType: TEntityListClass;
begin
  Result := TLinkList;
end;

/// ���������� ������ �����
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
  LinkArray: TJSONArray;
  ResStr: String;

begin

  Result := nil;

  try

    JSONResult := TJSONObject.Create;
    try
      ///  ������ ������
      ResStr := MainHttpModuleUnit.GET(BaseUrlPath + constURLLinkGetList);
      ///  ������ ���������
      JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
      ///  ������ - �����
      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      ///  ������ ������
      LinkArray := ResponseObject.GetValue('links') as TJSONArray;

      Result := ListClassType.Create(LinkArray);

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
  Result := ClassType.Create();
end;

///  ������ ���������� � �������� � ������� �� ��������������
///  � ������ ������ ������������ nil
function TLinksBroker.Info(AId: String): TEntity;
var
  URL: String;
  ResStr: String;
  JSONResult: TJSONObject;

begin

  Result := nil;

  if AId = '' then
    exit;

  try
    URL := Format(BaseUrlPath + constURLLinkGetOneInfo, [AId]);

    ResStr := MainHttpModuleUnit.GET(URL);

    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;

    try
      ///  ������� JSON ����� response
      var ResponseObject := JSONResult.GetValue('response') as TJSONObject;

      ///  ������ JSON ����� Link
      Result := ClassType.Create(ResponseObject);

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
function TLinksBroker.New(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONLink: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;

begin
  ///  ������ ������
  URL := BaseUrlPath + constURLLinkNew;
  ///  �������� �� �������� JSON
  JSONLink := AEntity.Serialize();

//  JSONRequest := FuncUnit.ExtractJSONProperties(JSONLink, ['name', 'caption','Links','attr']);

  JSONRequestStream := TStringStream.Create(JSONLink.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);

    ////  !!! ������������ �����
    ///  ���� ���������� ������ true
    Result := true;

  finally
    JSONLink.Free;
    JSONRequestStream.Free;

  end;

end;

///  �������� ��������� �������� �� �������
///  � ������ ������ ������������ false
function TLinksBroker.Update(AEntity: TEntity): Boolean;
var
  URL: String;
  JSONLink: TJSONObject;
  JSONRequestStream: TStringStream;
  ResStr: String;

begin
  ///  ���� �������� �������� �� ��� ����� �� �� ������ ������!
  if not (AEntity is TLink) then
    exit;

  ///  ������ ������
  URL := Format(BaseUrlPath + constURLLinkUpdate, [(AEntity as TLink).LId]);

  ///  �������� �� �������� JSON
  JSONLink := AEntity.Serialize();

//  JSONRequest := FuncUnit.ExtractJSONProperties(JSONLink, ['name', 'caption','Links','attr']);

  JSONRequestStream := TStringStream.Create(JSONLink.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream);

    ////  !!! ������������ �����
    ///  ���� ���������� ������ true
    Result := true;

  finally
    JSONLink.Free;
    JSONRequestStream.Free;

  end;

end;

///  ������� �������� �� ������� �� ��������������
///  � ������ ������ ������������ false
function TLinksBroker.Remove(AId: String): Boolean;
var
  URL: String;
  ResStr: String;
  JSONRequestStream: TStringStream;

begin
  URL := Format(BaseUrlPath + constURLLinkDelete, [AId]);

  JSONRequestStream := TStringStream.Create('{}', TEncoding.UTF8);

  ResStr := MainHttpModuleUnit.POST(URL, JSONRequestStream)

end;

end.
