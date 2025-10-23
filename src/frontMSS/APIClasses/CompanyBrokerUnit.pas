unit CompanyBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit, CompanyUnit, EntityBrokerUnit;

type
  ///  брокер для API Company
  TCompanyBroker = class(TEntityBroker)
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
//    function ListAll(const APageSize: Integer = 50): TEntityList;


    function CreateNew(): TEntity; override;
    function New(AEntity: TEntity): Boolean; override;
    function Info(AId: String): TEntity; overload; override;
    function Update(AEntity: TEntity): Boolean; override;
    function Remove(AId: String): Boolean; overload; override;
  end;

implementation

uses
  System.SysUtils, System.Classes,
  FuncUnit, APIConst;

const
  constURLCompanyGetList  = '/companies/list';
  constURLCompanyGetOne   = '/companies/%s/info';
  constURLCompanyNew      = '/companies/new';
  constURLCompanyUpdate   = '/companies/%s/update';
  constURLCompanyDelete   = '/companies/%s/remove';

{ TCompanyBroker }

function TCompanyBroker.GetBasePath: string;
begin
  Result := constURLAclBasePath;
end;

class function TCompanyBroker.ClassType: TEntityClass;
begin
  Result := TCompany;
end;

class function TCompanyBroker.ListClassType: TEntityListClass;
begin
  Result := TCompanyList;
end;

function TCompanyBroker.List(
  out APageCount: Integer;
  const APage, APageSize: Integer;
  const ASearchStr, ASearchBy, AOrder, AOrderDir: String): TEntityList;
var
  JSONResult, ResponseObject, CompObj: TJSONObject;
  CompanyArray: TJSONArray;
  JSONRequestStream : TStringStream;
  ResStr: String;
begin
  Result := nil;
  try
    JSONRequestStream := TStringStream.Create('{}', TEncoding.UTF8);
    ResStr := MainHttpModuleUnit.POST(GetBasePath + constURLCompanyGetList, JSONRequestStream);
    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
    try
      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      CompObj := ResponseObject.GetValue('companies') as TJSONObject;
      CompanyArray := CompObj.GetValue('items') as TJSONArray;
      Result := ListClassType.Create(CompanyArray);
    finally
      JSONResult.Free;
    end;
  except
    on E: Exception do
    begin
      Log('TCompanyBroker.List ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;


// function TCompanyBroker.ListAll(const APageSize: Integer = 50): TEntityList;
// var
//   PageCount, Page: Integer;
//   TempList, FullList: TEntityList;
// begin
//   FullList := TCompanyList.Create;
//   try
//     Page := 0;
//     repeat
//       TempList := List(PageCount, Page, APageSize);
//       try
//         if not Assigned(TempList) then
//           Break;

//         // добавляем в общий список
//         for var Entity in TempList do
//           FullList.Add(Entity);

//         Inc(Page);
//       finally
//         TempList.Free;
//       end;
//     until Page >= PageCount;

//     Result := FullList;
//   except
//     on E: Exception do
//     begin
//       Log('TCompanyBroker.ListAll ' + E.Message, lrtError);
//       FreeAndNil(FullList);
//       Result := nil;
//     end;
//   end;
// end;


function TCompanyBroker.CreateNew: TEntity;
begin
  Result := ClassType.Create();
end;

function TCompanyBroker.Info(AId: String): TEntity;
var
  URL, ResStr: String;
  JSONResult, ResponseObject: TJSONObject;
begin
  Result := nil;
  if AId = '' then Exit;

  try
    URL := Format(GetBasePath + constURLCompanyGetOne, [AId]);
    ResStr := MainHttpModuleUnit.GET(URL);
    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
    try
      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      Result := ClassType.Create(ResponseObject);
    finally
      JSONResult.Free;
    end;
  except
    on E: Exception do
    begin
      Log('TCompanyBroker.Info ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TCompanyBroker.New(AEntity: TEntity): Boolean;
var
  URL, ResStr: String;
  JSONObj: TJSONObject;
  Stream: TStringStream;
begin
  URL := GetBasePath + constURLCompanyNew;
  JSONObj := AEntity.Serialize();
  Stream := TStringStream.Create(JSONObj.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, Stream);
    Result := True;
  finally
    JSONObj.Free;
    Stream.Free;
  end;
end;

function TCompanyBroker.Update(AEntity: TEntity): Boolean;
var
  URL, ResStr: String;
  JSONObj: TJSONObject;
  Stream: TStringStream;
begin
  if not (AEntity is TCompany) then Exit(False);
  URL := Format(GetBasePath + constURLCompanyUpdate, [(AEntity as TCompany).CompId]);
  JSONObj := AEntity.Serialize();
  Stream := TStringStream.Create(JSONObj.ToJSON, TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, Stream);
    Result := True;
  finally
    JSONObj.Free;
    Stream.Free;
  end;
end;

function TCompanyBroker.Remove(AId: String): Boolean;
var
  URL, ResStr: String;
  Stream: TStringStream;
begin
  URL := Format(GetBasePath + constURLCompanyDelete, [AId]);
  Stream := TStringStream.Create('{}', TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, Stream);
    Result := True;
  finally
    Stream.Free;
  end;
end;

end.
