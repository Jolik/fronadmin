unit RestFieldSetBrokerUnit;

interface

uses
  HttpClientUnit,
  EntityUnit,
  BaseRequests,
  BaseResponses,
  RestBrokerBaseUnit;

type
      // Base REST broker that operates on base request types
  TRestFieldSetBroker = class(TRestBrokerBase)
    function List(AReq: TReqList): TFieldSetListResponse; overload; virtual;
    function List(AReq: TReqList; AResp: TFieldSetListResponse): TFieldSetListResponse; overload; virtual;
    // выборка сущностей с указанием типа списка и ключа массива
    function List(AReq: TReqList; AListClass: TFieldSetListClass; const AItemsKey: string = 'items'): TFieldSetListResponse; overload; virtual;
    // выборка всех страниц с учетом info (page/pagecount/pagesize/total)
    function ListAll(AReq: TReqList; AResp: TFieldSetListResponse):TFieldSetListResponse;overload; virtual;
    function ListAll(AReq: TReqList): TFieldSetListResponse;overload; virtual;
    function ListAll(AReq: TReqList; AListClass: TFieldSetListClass; const AItemsKey: string = 'items'): TFieldSetListResponse; overload; virtual;
    // прямая, принимающая любой THttpRequest; создает подходящий ответ
    function ListRaw2(AReq: THttpRequest; AListClass: TFieldSetListClass; const AItemsKey: string = 'items'): TFieldSetListResponse; virtual;
    // получение info: одного объекта по идентификатору
    function Info(AReq: TReqInfo; AResp: TFieldSetResponse): TFieldSetResponse; overload; virtual;
    function InfoRaw(AReq: TReqInfo; AFieldSetClass: TFieldSetClass; const AItemKey: string = 'item'): TFieldSetResponse; virtual;
    function New(AReq: TReqNew; AResp: TIdNewResponse): TIdNewResponse; overload; virtual;

  end;

implementation

uses System.Math, System.SysUtils;


function TRestFieldSetBroker.List(AReq: TReqList; AResp: TFieldSetListResponse): TFieldSetListResponse;
begin
  Result := AResp;
  ApplyTicket(AReq);
  HttpClient.Request(AReq, AResp);
end;

function TRestFieldSetBroker.List(AReq: TReqList; AListClass: TFieldSetListClass; const AItemsKey: string): TFieldSetListResponse;
begin
  Result := TFieldSetListResponse.Create(AListClass);
  ApplyTicket(AReq);
  Result.ItemsKey := AItemsKey;
  // выполняем запрос в HttpClient; разбор произойдет в SetResponse
  HttpClient.Request(AReq, Result);
end;

function TRestFieldSetBroker.Info(AReq: TReqInfo; AResp: TFieldSetResponse): TFieldSetResponse;
begin
  Result := AResp;
  ApplyTicket(AReq);
  HttpClient.Request(AReq, AResp);
end;


function TRestFieldSetBroker.InfoRaw(AReq: TReqInfo; AFieldSetClass: TFieldSetClass; const AItemKey: string): TFieldSetResponse;
begin
  Result := TFieldSetResponse.Create(AFieldSetClass, 'response', AItemKey);
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

function TRestFieldSetBroker.List(AReq: TReqList): TFieldSetListResponse;
begin
  Result := TFieldSetListResponse.Create(TFieldSetList, 'response', 'items');
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

function TRestFieldSetBroker.ListRaw2(AReq: THttpRequest; AListClass: TFieldSetListClass; const AItemsKey: string): TFieldSetListResponse;
begin
  Result := TFieldSetListResponse.Create(AListClass);
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

function TRestFieldSetBroker.New(AReq: TReqNew; AResp: TIdNewResponse): TIdNewResponse;
begin
  Result := AResp;
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result as TJSONResponse);
end;


function TRestFieldSetBroker.ListAll(AReq: TReqList): TFieldSetListResponse;
var
  First: TFieldSetListResponse;
  Body: TReqListBody;
  OrigPage: Integer;
  ListCls: TFieldSetListClass;
begin
  raise Exception.Create('Not Implemented');
end;

function TRestFieldSetBroker.ListAll(AReq: TReqList; AListClass: TFieldSetListClass; const AItemsKey: string): TFieldSetListResponse;
var
  Next: TFieldSetListResponse;
  Body: TReqListBody;
  startPage: Integer;
  First: TFieldSetListResponse;
begin
  startPage := 1;
  if Assigned(Body) then
    startPage := Body.Page;
  result:= List(AReq, AListClass, AItemsKey);
  if (Result.PageCount <= 1)then Exit;
  for var P := Max(2, Result.Page + 1) to Result.PageCount do
  begin
    AReq.Body.Page := P;
    Next:= List(AReq, AListClass, Result.ItemsKey);
    Next.FieldSetList.OwnsObjects:=False;
    try
      for var j := 0 to Next.FieldSetList.Count - 1 do
        Result.FieldSetList.Add(Next.FieldSetList[j]);
    finally
      Next.Free;
    end;
  end;
end;

function TRestFieldSetBroker.ListAll(AReq: TReqList; AResp: TFieldSetListResponse): TFieldSetListResponse;
var
  Body: TReqListBody;
  startPage: Integer;
  Next: TFieldSetListResponse;
  ListClass: TFieldSetListClass;
begin
  Result := AResp;
  startPage := 1;
  if Assigned(Body) then
    startPage := Body.Page;
  List(AReq, Result);
  if (Result.PageCount <= 1)then Exit;
  for var P := Max(2, Result.Page + 1) to Result.PageCount do
  begin
    AReq.Body.Page := P;
    if Assigned(Result.FieldSetList) then
      ListClass := TFieldSetListClass(Result.FieldSetList.ClassType)
    else
      ListClass := TFieldSetList;
    Next:= List(AReq, ListClass, Result.ItemsKey);
    Next.FieldSetList.OwnsObjects:=False;
    try
      for var j := 0 to Next.FieldSetList.Count - 1 do
        Result.FieldSetList.Add(Next.FieldSetList[j]);
    finally
      Next.Free;
    end;
  end;
end;

end.
