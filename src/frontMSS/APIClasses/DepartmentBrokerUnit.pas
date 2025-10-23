unit DepartmentBrokerUnit;

interface

uses
  System.Generics.Collections, System.JSON,
  LoggingUnit,
  MainHttpModuleUnit,
  EntityUnit, DepartmentUnit, EntityBrokerUnit;

type
  ///  брокер для API Department
  TDepartmentBroker = class(TEntityBroker)
  protected
    function GetBasePath: string; override;
    class function ClassType: TEntityClass; override;
    class function ListClassType: TEntityListClass; override;
  public
    function List(
      out APageCount: Integer;
      const APage: Integer = 1;
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
  constURLDepartmentGetList  = '/departments/list';
  constURLDepartmentGetOne   = '/departments/%s/info';
  constURLDepartmentNew      = '/departments/new';
  constURLDepartmentUpdate   = '/departments/%s/update';
  constURLDepartmentDelete   = '/departments/%s/remove';

{ TDepartmentBroker }

function TDepartmentBroker.GetBasePath: string;
begin
  Result := constURLAclBasePath;
end;

class function TDepartmentBroker.ClassType: TEntityClass;
begin
  Result := TDepartment;
end;

class function TDepartmentBroker.ListClassType: TEntityListClass;
begin
  Result := TDepartmentList;
end;

function TDepartmentBroker.List(
  out APageCount: Integer;
  const APage, APageSize: Integer;
  const ASearchStr, ASearchBy, AOrder, AOrderDir: String): TEntityList;
var
  JSONResult, ResponseObject, DeptObj: TJSONObject;
  DeptArray: TJSONArray;
  JSONRequestStream : TStringStream;
  ResStr: String;
begin
  Result := nil;
  try
    JSONRequestStream := TStringStream.Create('{}', TEncoding.UTF8);
    ResStr := MainHttpModuleUnit.POST(GetBasePath + constURLDepartmentGetList,JSONRequestStream);
    JSONResult := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
    try
      ResponseObject := JSONResult.GetValue('response') as TJSONObject;
      DeptObj := ResponseObject.GetValue('departments') as TJSONObject;
      DeptArray := DeptObj.GetValue('items') as TJSONArray;
      Result := ListClassType.Create(DeptArray);
    finally
      JSONResult.Free;
      JSONRequestStream.Free;
    end;
  except
    on E: Exception do
    begin
      Log('TDepartmentBroker.List ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

// function TDepartmentBroker.ListAll(const APageSize: Integer = 50): TEntityList;
// var
//   PageCount, Page: Integer;
//   TempList, FullList: TEntityList;
// begin
//   FullList := TDepartmentList.Create;
//   try
//     Page := 0;
//     repeat
//       TempList := List(PageCount, Page, APageSize);
//       try
//         if not Assigned(TempList) then
//           Break;

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
//       Log('TDepartmentBroker.ListAll ' + E.Message, lrtError);
//       FreeAndNil(FullList);
//       Result := nil;
//     end;
//   end;
// end;


function TDepartmentBroker.CreateNew: TEntity;
begin
  Result := ClassType.Create();
end;

function TDepartmentBroker.Info(AId: String): TEntity;
var
  URL, ResStr: String;
  JSONResult, ResponseObject: TJSONObject;
begin
  Result := nil;
  if AId = '' then Exit;

  try
    URL := Format(GetBasePath + constURLDepartmentGetOne, [AId]);
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
      Log('TDepartmentBroker.Info ' + E.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

function TDepartmentBroker.New(AEntity: TEntity): Boolean;
var
  URL, ResStr: String;
  JSONObj: TJSONObject;
  Stream: TStringStream;
begin
  URL := GetBasePath + constURLDepartmentNew;
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

function TDepartmentBroker.Update(AEntity: TEntity): Boolean;
var
  URL, ResStr: String;
  JSONObj: TJSONObject;
  Stream: TStringStream;
begin
  if not (AEntity is TDepartment) then Exit(False);
  URL := Format(GetBasePath + constURLDepartmentUpdate, [(AEntity as TDepartment).DepId]);
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

function TDepartmentBroker.Remove(AId: String): Boolean;
var
  URL, ResStr: String;
  Stream: TStringStream;
begin
  URL := Format(GetBasePath + constURLDepartmentDelete, [AId]);
  Stream := TStringStream.Create('{}', TEncoding.UTF8);
  try
    ResStr := MainHttpModuleUnit.POST(URL, Stream);
    Result := True;
  finally
    Stream.Free;
  end;
end;

end.
