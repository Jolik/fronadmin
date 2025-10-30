unit RestEntityBrokerUnit;

interface

uses
  HttpClientUnit,
  BaseRequests,
  BaseResponses,
  RestBrokerBaseUnit,
  EntityUnit;

type
      // Base REST broker that operates on base request types
  TRestEntityBroker = class(TRestBrokerBase)
    function List(AReq: TReqList): TListResponse; overload; virtual;
    function List(AReq: TReqList; AResp: TListResponse): TListResponse; overload; virtual;
    // выборка сущностей с указанием типа списка и ключа массива
    function List(AReq: TReqList; AListClass: TEntityListClass; const AItemsKey: string = 'items'): TListResponse; overload; virtual;
    // выборка всех страниц с учетом info (page/pagecount/pagesize/total)
    function ListAll(AReq: TReqList): TListResponse; overload; virtual;
    function ListAll(AReq: TReqList; AListClass: TEntityListClass; const AItemsKey: string = 'items'): TListResponse; overload; virtual;
    // прямая, принимающая любой THttpRequest; создает подходящий ответ
    function ListRaw2(AReq: THttpRequest; AListClass: TEntityListClass; const AItemsKey: string = 'items'): TListResponse; virtual;
    // получение info: одного объекта по идентификатору
    function Info(AReq: TReqInfo; AResp: TEntityResponse): TEntityResponse; overload; virtual;
    function Info(AReq: TReqInfo): TEntityResponse; overload; virtual;
    function InfoEntity(AReq: TReqInfo; AEntityClass: TEntityClass; const AItemKey: string = 'item'): TEntityResponse; virtual;
    
    function New(AReq: TReqNew; AResp: TEntityResponse): TEntityResponse; overload; virtual;
  end;

implementation

uses System.Math;

function TRestEntityBroker.List(AReq: TReqList; AResp: TListResponse): TListResponse;
begin
  Result := AResp;
  ApplyTicket(AReq);
  HttpClient.Request(AReq, AResp);
end;

function TRestEntityBroker.List(AReq: TReqList; AListClass: TEntityListClass; const AItemsKey: string): TListResponse;
begin
  Result := TListResponse.Create(AListClass);
  ApplyTicket(AReq);
  Result.ItemsKey := AItemsKey;
  // выполняем запрос в HttpClient; разбор произойдет в SetResponse
  HttpClient.Request(AReq, Result);
end;

function TRestEntityBroker.Info(AReq: TReqInfo; AResp: TEntityResponse): TEntityResponse;
begin
  Result := AResp;
  ApplyTicket(AReq);
  HttpClient.Request(AReq, AResp);
end;

function TRestEntityBroker.Info(AReq: TReqInfo): TEntityResponse;
begin
  Result := TEntityResponse.Create();
  ApplyTicket(AReq);
  // выполняем запрос в HttpClient; разбор произойдет в SetResponse
  HttpClient.Request(AReq, Result);
end;

function TRestEntityBroker.InfoEntity(AReq: TReqInfo; AEntityClass: TEntityClass; const AItemKey: string): TEntityResponse;
begin
  Result := TEntityResponse.Create(AEntityClass, 'response', AItemKey);
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

function TRestEntityBroker.List(AReq: TReqList): TListResponse;
begin
  Result := TListResponse.Create(TEntityList, 'response', 'items');
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

function TRestEntityBroker.ListRaw2(AReq: THttpRequest; AListClass: TEntityListClass; const AItemsKey: string): TListResponse;
begin
  Result := TListResponse.Create(AListClass);
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result);
end;

function TRestEntityBroker.New(AReq: TReqNew; AResp: TEntityResponse): TEntityResponse;
begin
  Result := AResp;
  ApplyTicket(AReq);
  HttpClient.Request(AReq, Result as TJSONResponse);
end;



function TRestEntityBroker.ListAll(AReq: TReqList): TListResponse;
var
  First: TListResponse;
  Body: TReqListBody;
  OrigPage: Integer;
  ListCls: TEntityListClass;
begin
  Body := AReq.Body;
  OrigPage := 0;
  if Assigned(Body) then
    OrigPage := Body.Page;

  First := List(AReq);
  try
    ListCls := TEntityListClass(First.EntityList.ClassType);
    Result := TListResponse.Create(ListCls, 'response', First.ItemsKey);

    for var i := 0 to First.EntityList.Count - 1 do
    begin
      var Src := First.EntityList[i];
      var ItemCls := TEntityClass(Src.ClassType);
      var Copy := ItemCls.Create;
      Copy.Assign(Src);
      Result.EntityList.Add(Copy);
    end;

    if (First.PageCount <= 1) or (not Assigned(Body)) then Exit;

    for var P := Max(2, First.Page + 1) to First.PageCount do
    begin
      Body.Page := P;
      var Next := List(AReq, ListCls, First.ItemsKey);
      try
        for var j := 0 to Next.EntityList.Count - 1 do
        begin
          var Src2 := Next.EntityList[j];
          var ItemCls2 := TEntityClass(Src2.ClassType);
          var Copy2 := ItemCls2.Create;
          Copy2.Assign(Src2);
          Result.EntityList.Add(Copy2);
        end;
      finally
        Next.Free;
      end;
    end;
  finally
    if Assigned(Body) then Body.Page := OrigPage;
    First.Free;
  end;
end;

function TRestEntityBroker.ListAll(AReq: TReqList; AListClass: TEntityListClass; const AItemsKey: string): TListResponse;
var
  Body: TReqListBody;
  OrigPage: Integer;
  First: TListResponse;
begin
  Body := AReq.Body;
  OrigPage := 0;
  if Assigned(Body) then OrigPage := Body.Page;

  First := List(AReq, AListClass, AItemsKey);
  try
    Result := TListResponse.Create(AListClass, 'response', AItemsKey);

    for var i := 0 to First.EntityList.Count - 1 do
    begin
      var Src := First.EntityList[i];
      var ItemCls := TEntityClass(Src.ClassType);
      var Copy := ItemCls.Create;
      Copy.Assign(Src);
      Result.EntityList.Add(Copy);
    end;

    if (First.PageCount <= 1) or (not Assigned(Body)) then Exit;

    for var P := Max(2, First.Page + 1) to First.PageCount do
    begin
      Body.Page := P;
      var Next := List(AReq, AListClass, AItemsKey);
      try
        for var j := 0 to Next.EntityList.Count - 1 do
        begin
          var Src2 := Next.EntityList[j];
          var ItemCls2 := TEntityClass(Src2.ClassType);
          var Copy2 := ItemCls2.Create;
          Copy2.Assign(Src2);
          Result.EntityList.Add(Copy2);
        end;
      finally
        Next.Free;
      end;
    end;
  finally
    if Assigned(Body) then Body.Page := OrigPage;
    First.Free;
  end;
end;

end.
