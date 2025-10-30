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
    function ListAll(AReq: TReqList): TFieldSetListResponse; overload; virtual;
    function ListAll(AReq: TReqList; AListClass: TFieldSetListClass; const AItemsKey: string = 'items'): TFieldSetListResponse; overload; virtual;
    // прямая, принимающая любой THttpRequest; создает подходящий ответ
    function ListRaw2(AReq: THttpRequest; AListClass: TFieldSetListClass; const AItemsKey: string = 'items'): TFieldSetListResponse; virtual;
    // получение info: одного объекта по идентификатору
    function Info(AReq: TReqInfo; AResp: TFieldSetResponse): TFieldSetResponse; overload; virtual;
    function InfoRaw(AReq: TReqInfo; AFieldSetClass: TFieldSetClass; const AItemKey: string = 'item'): TFieldSetResponse; virtual;
    function New(AReq: TReqNew; AResp: TIdNewResponse): TIdNewResponse; overload; virtual;

  end;

implementation

uses System.Math;


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
  Body := AReq.Body;
  OrigPage := 0;
  if Assigned(Body) then
    OrigPage := Body.Page;

  First := List(AReq);
  try
    ListCls := TFieldSetListClass(First.FieldSetList.ClassType);
    Result := TFieldSetListResponse.Create(ListCls, 'response', First.ItemsKey);

    for var i := 0 to First.FieldSetList.Count - 1 do
    begin
      var Src := First.FieldSetList[i];
      var ItemCls := TFieldSetClass(Src.ClassType);
      var Copy := ItemCls.Create;
      Copy.Assign(Src);
      Result.FieldSetList.Add(Copy);
    end;

    if (First.PageCount <= 1) or (not Assigned(Body)) then Exit;

    for var P := Max(2, First.Page + 1) to First.PageCount do
    begin
      Body.Page := P;
      var Next := List(AReq, ListCls, First.ItemsKey);
      try
        for var j := 0 to Next.FieldSetList.Count - 1 do
        begin
          var Src2 := Next.FieldSetList[j];
          var ItemCls2 := TFieldSetClass(Src2.ClassType);
          var Copy2 := ItemCls2.Create;
          Copy2.Assign(Src2);
          Result.FieldSetList.Add(Copy2);
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

function TRestFieldSetBroker.ListAll(AReq: TReqList; AListClass: TFieldSetListClass; const AItemsKey: string): TFieldSetListResponse;
var
  Body: TReqListBody;
  OrigPage: Integer;
  First: TFieldSetListResponse;
begin
  Body := AReq.Body;
  OrigPage := 0;
  if Assigned(Body) then OrigPage := Body.Page;

  First := List(AReq, AListClass, AItemsKey);
  try
    Result := TFieldSetListResponse.Create(AListClass, 'response', AItemsKey);

    for var i := 0 to First.FieldSetList.Count - 1 do
    begin
      var Src := First.FieldSetList[i];
      var ItemCls := TFieldSetClass(Src.ClassType);
      var Copy := ItemCls.Create;
      Copy.Assign(Src);
      Result.FieldSetList.Add(Copy);
    end;

    if (First.PageCount <= 1) or (not Assigned(Body)) then Exit;

    for var P := Max(2, First.Page + 1) to First.PageCount do
    begin
      Body.Page := P;
      var Next := List(AReq, AListClass, AItemsKey);
      try
        for var j := 0 to Next.FieldSetList.Count - 1 do
        begin
          var Src2 := Next.FieldSetList[j];
          var ItemCls2 := TFieldSetClass(Src2.ClassType);
          var Copy2 := ItemCls2.Create;
          Copy2.Assign(Src2);
          Result.FieldSetList.Add(Copy2);
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
