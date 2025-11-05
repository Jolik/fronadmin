unit DsGroupsRestBrokerUnit;

interface

uses
  RestEntityBrokerUnit,
  BaseRequests,
  BaseResponses,
  DsGroupHttpRequests,
  HttpClientUnit;

type
  // REST broker for dataserver groups API
  TDsGroupsRestBroker = class(TRestEntityBroker)
  public
    BasePath: string;
    constructor Create(const ATicket: string = ''); override;

    function List(AReq: TDsGroupReqList): TDsGroupListResponse; overload;
    function List(AReq: TReqList): TListResponse; overload; override;

    function ListAll(AReq: TDsGroupReqList): TDsGroupListResponse; overload;
    function ListAll(AReq: TReqList): TListResponse; overload; override;

    function Info(AReq: TDsGroupReqInfo): TDsGroupInfoResponse; overload;
    function Info(AReq: TReqInfo): TEntityResponse; overload; override;

    function New(AReq: TDsGroupReqNew): TJSONResponse; overload;
    function New(AReq: TReqNew; AResp: TEntityResponse): TEntityResponse; overload; override;

    function Update(AReq: TDsGroupReqUpdate): TJSONResponse; overload;
    function Update(AReq: TReqUpdate): TJSONResponse; overload; override;

    function Remove(AReq: TDsGroupReqRemove): TJSONResponse; overload;
    function Remove(AReq: TReqRemove): TJSONResponse; overload; override;

    function IncludeDataseries(AReq: TDsGroupReqInclude): TJSONResponse;
    function ExcludeDataseries(AReq: TDsGroupReqExclude): TJSONResponse;

    function CreateReqList: TReqList; override;
    function CreateReqInfo(id: string = ''): TReqInfo; override;
    function CreateReqNew: TReqNew; override;
    function CreateReqUpdate: TReqUpdate; override;
    function CreateReqRemove: TReqRemove; override;
    function CreateReqInclude(const AGroupId: string = ''): TDsGroupReqInclude;
    function CreateReqExclude(const AGroupId: string = ''): TDsGroupReqExclude;
  end;

implementation

uses
  System.Math,
  System.SysUtils,
  APIConst,
  DsGroupUnit;

{ TDsGroupsRestBroker }

constructor TDsGroupsRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  BasePath := constURLDataserverBasePath;
end;

function TDsGroupsRestBroker.CreateReqExclude(const AGroupId: string): TDsGroupReqExclude;
begin
  Result := TDsGroupReqExclude.Create;
  Result.BasePath := BasePath;
  if not AGroupId.IsEmpty then
    Result.SetGroupId(AGroupId);
end;

function TDsGroupsRestBroker.CreateReqInclude(const AGroupId: string): TDsGroupReqInclude;
begin
  Result := TDsGroupReqInclude.Create;
  Result.BasePath := BasePath;
  if not AGroupId.IsEmpty then
    Result.SetGroupId(AGroupId);
end;

function TDsGroupsRestBroker.CreateReqInfo(id: string): TReqInfo;
begin
  Result := TDsGroupReqInfo.CreateID(id);
  Result.BasePath := BasePath;
end;

function TDsGroupsRestBroker.CreateReqList: TReqList;
begin
  Result := TDsGroupReqList.Create;
  Result.BasePath := BasePath;
end;

function TDsGroupsRestBroker.CreateReqNew: TReqNew;
begin
  Result := TDsGroupReqNew.Create;
  Result.BasePath := BasePath;
end;

function TDsGroupsRestBroker.CreateReqRemove: TReqRemove;
begin
  Result := TDsGroupReqRemove.Create;
  Result.BasePath := BasePath;
end;

function TDsGroupsRestBroker.CreateReqUpdate: TReqUpdate;
begin
  Result := TDsGroupReqUpdate.Create;
  Result.BasePath := BasePath;
end;

function TDsGroupsRestBroker.ExcludeDataseries(AReq: TDsGroupReqExclude): TJSONResponse;
begin
  Result := TJSONResponse.Create;
  try
    ApplyTicket(AReq);
    HttpClient.Request(AReq, Result);
  except
    Result.Free;
    raise;
  end;
end;

function TDsGroupsRestBroker.IncludeDataseries(AReq: TDsGroupReqInclude): TJSONResponse;
begin
  Result := TJSONResponse.Create;
  try
    ApplyTicket(AReq);
    HttpClient.Request(AReq, Result);
  except
    Result.Free;
    raise;
  end;
end;

function TDsGroupsRestBroker.Info(AReq: TDsGroupReqInfo): TDsGroupInfoResponse;
begin
  Result := Info(AReq as TReqInfo) as TDsGroupInfoResponse;
end;

function TDsGroupsRestBroker.Info(AReq: TReqInfo): TEntityResponse;
begin
  Result := TDsGroupInfoResponse.Create;
  inherited Info(AReq, Result);
end;

function TDsGroupsRestBroker.List(AReq: TDsGroupReqList): TDsGroupListResponse;
begin
  Result := List(AReq as TReqList) as TDsGroupListResponse;
end;

function TDsGroupsRestBroker.List(AReq: TReqList): TListResponse;
begin
  Result := TDsGroupListResponse.Create;
  Result := inherited List(AReq, Result);
end;

function TDsGroupsRestBroker.ListAll(AReq: TDsGroupReqList): TDsGroupListResponse;
var
  Body: TReqListBody;
  OrigPage: Integer;
  First, Next: TDsGroupListResponse;
  Copy: TDsGroup;
begin
  Body := AReq.Body;
  OrigPage := 0;
  if Assigned(Body) then
    OrigPage := Body.Page;

  First := List(AReq);
  try
    Result := TDsGroupListResponse.Create;
    try
      Result.ItemsKey := First.ItemsKey;

      for var I := 0 to First.DsGroupList.Count - 1 do
      begin
        Copy := TDsGroup.Create;
        try
          Copy.Assign(First.DsGroupList[I]);
          Result.DsGroupList.Add(Copy);
        except
          Copy.Free;
          raise;
        end;
      end;

      if Assigned(Body) and (First.PageCount > 1) then
      begin
        for var P := Max(2, First.Page + 1) to First.PageCount do
        begin
          Body.Page := P;
          Next := List(AReq);
          try
            for var I := 0 to Next.DsGroupList.Count - 1 do
            begin
              Copy := TDsGroup.Create;
              try
                Copy.Assign(Next.DsGroupList[I]);
                Result.DsGroupList.Add(Copy);
              except
                Copy.Free;
                raise;
              end;
            end;
          finally
            Next.Free;
          end;
        end;
      end;
    except
      Result.Free;
      raise;
    end;
  finally
    if Assigned(Body) then
      Body.Page := OrigPage;
    First.Free;
  end;
end;

function TDsGroupsRestBroker.ListAll(AReq: TReqList): TListResponse;
begin
  if AReq is TDsGroupReqList then
    Exit(ListAll(TDsGroupReqList(AReq)));

  Result := inherited ListAll(AReq, TDsGroupList, 'dsgroups');
end;

function TDsGroupsRestBroker.New(AReq: TDsGroupReqNew): TJSONResponse;
begin
  Result := TJSONResponse.Create;
  try
    ApplyTicket(AReq);
    HttpClient.Request(AReq, Result);
  except
    Result.Free;
    raise;
  end;
end;

function TDsGroupsRestBroker.New(AReq: TReqNew; AResp: TEntityResponse): TEntityResponse;
begin
  Result := inherited New(AReq, AResp);
end;

function TDsGroupsRestBroker.Remove(AReq: TDsGroupReqRemove): TJSONResponse;
begin
  Result := Remove(AReq as TReqRemove);
end;

function TDsGroupsRestBroker.Remove(AReq: TReqRemove): TJSONResponse;
begin
  Result := inherited Remove(AReq);
end;

function TDsGroupsRestBroker.Update(AReq: TDsGroupReqUpdate): TJSONResponse;
begin
  Result := Update(AReq as TReqUpdate);
end;

function TDsGroupsRestBroker.Update(AReq: TReqUpdate): TJSONResponse;
begin
  Result := inherited Update(AReq);
end;

end.
