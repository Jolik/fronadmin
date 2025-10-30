unit TasksRestBrokerUnit;

interface

uses
  RestEntityBrokerUnit,
  BaseRequests,
  BaseResponses,
  HttpClientUnit,
  TaskHttpRequests,
  TaskUnit;

 type
  TTasksRestBroker = class(TRestEntityBroker)
  public
    BasePath: string;
    function List(AReq: TTaskReqList): TTaskListResponse; overload;
    function List(AReq: TReqList): TListResponse; overload; override;
    function TypesList(AReq: TTaskTypesReqList): TTaskTypesListResponse;
    function Info(AReq: TTaskReqInfo): TTaskInfoResponse; overload;
    function Info(AReq: TReqInfo): TEntityResponse; overload; override;
    function New(AReq: TTaskReqNew): TTaskNewResponse; overload;
    function New(AReq: TReqNew; AResp: TEntityResponse): TEntityResponse; overload; override;
    function Update(AReq: TTaskReqUpdate): TJSONResponse; overload;
    function Update(AReq: TReqUpdate): TJSONResponse; overload; override;
    function Remove(AReq: TTaskReqRemove): TJSONResponse; overload;
    function Remove(AReq: TReqRemove): TJSONResponse; overload; override;
    function CreateReqList: TReqList; override;
    function CreateTypesReqList: TTaskTypesReqList;
    function CreateReqInfo(id:string=''): TReqInfo; override;
    function CreateReqNew: TReqNew; override;
    function CreateReqUpdate: TReqUpdate; override;
    function CreateReqRemove: TReqRemove; override;
  end;

implementation

{ TTasksRestBroker }

function TTasksRestBroker.List(AReq: TReqList): TListResponse;
begin
  Result := TTaskListResponse.Create;
  Result := inherited List(AReq, Result);
end;

function TTasksRestBroker.List(AReq: TTaskReqList): TTaskListResponse;
begin
  Result := List(AReq as TReqList) as TTaskListResponse;
end;

function TTasksRestBroker.New(AReq: TReqNew; AResp: TEntityResponse): TEntityResponse;
begin
  Result := TTaskNewResponse.Create;
  Result := inherited New(AReq, Result);
end;

function TTasksRestBroker.New(AReq: TTaskReqNew): TTaskNewResponse;
begin
  Result := TTaskNewResponse.Create;
  New(AReq as TReqNew, Result);
end;

function TTasksRestBroker.Remove(AReq: TReqRemove): TJSONResponse;
begin
  Result := inherited Remove(AReq);
end;

function TTasksRestBroker.TypesList(AReq: TTaskTypesReqList): TTaskTypesListResponse;
begin
  Result := TTaskTypesListResponse.Create;
  ExcuteRaw(AReq,Result);
end;

function TTasksRestBroker.Remove(AReq: TTaskReqRemove): TJSONResponse;
begin
  Result := Remove(AReq as TReqRemove);
end;

function TTasksRestBroker.Update(AReq: TTaskReqUpdate): TJSONResponse;
begin
  Result := Update(AReq as TReqUpdate);
end;

function TTasksRestBroker.CreateReqInfo(id:string=''): TReqInfo;
begin
  Result := TTaskReqInfo.CreateID(id);
  Result.BasePath := BasePath;
end;

function TTasksRestBroker.CreateReqList: TReqList;
begin
  Result := TTaskReqList.Create;
  Result.BasePath := BasePath;
end;

function TTasksRestBroker.CreateReqNew: TReqNew;
begin
  Result := TTaskReqNew.Create;
  Result.BasePath := BasePath;
end;

function TTasksRestBroker.CreateReqRemove: TReqRemove;
begin
  Result := TTaskReqRemove.Create;
  Result.BasePath := BasePath;
end;

function TTasksRestBroker.CreateReqUpdate: TReqUpdate;
begin
  Result := TTaskReqUpdate.Create;
  Result.BasePath := BasePath;
end;

function TTasksRestBroker.CreateTypesReqList: TTaskTypesReqList;
begin
  Result := TTaskTypesReqList.Create;
  Result.BasePath := BasePath;
end;

function TTasksRestBroker.Info(AReq: TTaskReqInfo): TTaskInfoResponse;
begin
  Result := Info(AReq as TReqInfo) as TTaskInfoResponse;
end;

function TTasksRestBroker.Info(AReq: TReqInfo): TEntityResponse;
begin
  Result := TTaskInfoResponse.Create;
  inherited Info(AReq, Result);
end;

function TTasksRestBroker.Update(AReq: TReqUpdate): TJSONResponse;
begin
  Result := inherited Update(AReq);
end;

end.


