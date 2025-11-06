unit ContextsRestBrokerUnit;

interface

uses
  RestBrokerBaseUnit,
  BaseRequests,
  BaseResponses,
  RestFieldSetBrokerUnit,
  ContextsHttpRequests,
  HttpClientUnit;

type
  TContextsRestBroker = class(TRestFieldSetBroker)
  public
    BasePath: string;
    constructor Create(const ATicket: string = ''); override;
    function List(AReq: TContextReqList): TContextListResponse; overload;
    function List(AReq: TReqList): TFieldSetListResponse; overload; override;
    function ListAll(AReq: TContextReqList): TContextListResponse; overload;
    function ListAll(AReq: TReqList): TFieldSetListResponse; overload; override;


    function New(AReq: TContextReqNew): TIdNewResponse; overload;
    function Update(AReq: TContextReqUpdate): TJSONResponse; overload;
    function Update(AReq: TReqUpdate): TJSONResponse; overload; override;
    function Remove(AReq: TContextReqRemove): TJSONResponse; overload;
    function Remove(AReq: TReqRemove): TJSONResponse; overload; override;

    function ListTypes(AReq: TContextTypesReqList): TContextTypeListResponse; overload;
    function ListTypesAll(AReq: TContextTypesReqList): TContextTypeListResponse;overload;
    function ListTypesAll(AReq: TReqList): TFieldSetListResponse;overload;
    function ListTypes(AReq: TReqList): TFieldSetListResponse; overload;

    function ListCredentials(AReq: TContextCredsReqList): TContextCredsListResponse; overload;
    function ListCredentials(AReq: TReqList): TFieldSetListResponse; overload;
    function ListCredentialsAll(AReq: TContextCredsReqList): TContextCredsListResponse; overload;
    function ListCredentialsAll(AReq: TReqList): TFieldSetListResponse; overload;

    function CredentialInfo(AReq: TContextCredReqInfo): TContextCredInfoResponse; overload;
    function CredentialInfo(AReq: TReqInfo): TFieldSetResponse; overload;
    function NewCredential(AReq: TContextCredReqNew): TJSONResponse;
    function UpdateCredential(AReq: TContextCredReqUpdate): TJSONResponse;
    function RemoveCredential(AReq: TContextCredReqRemove): TJSONResponse;

    function CreateReqList: TReqList; override;
    function CreateReqInfo(id:string=''): TReqInfo; override;
    function CreateReqNew: TReqNew; override;
    function CreateReqUpdate: TReqUpdate; override;
    function CreateReqRemove: TReqRemove; override;

    function CreateReqContextTypes: TContextTypesReqList;
    function CreateReqCredList: TContextCredsReqList;
    function CreateReqCredInfo(const ACredId: string = ''): TContextCredReqInfo;
    function CreateReqCredNew: TContextCredReqNew;
    function CreateReqCredUpdate(const ACredId: string = ''): TContextCredReqUpdate;
    function CreateReqCredRemove(const ACredId: string = ''): TContextCredReqRemove;
  end;

implementation

uses APIConst, System.SysUtils;

constructor TContextsRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  BasePath := constURLDataserverBasePath;
end;

function TContextsRestBroker.List(AReq: TReqList): TFieldSetListResponse;
begin
  Result := TContextListResponse.Create;
  Result := inherited List(AReq, Result);
end;

function TContextsRestBroker.ListAll(AReq: TReqList): TFieldSetListResponse;
begin
  Result := TContextListResponse.Create;
  Result := inherited ListAll(AReq, Result);
end;

function TContextsRestBroker.ListAll(AReq: TContextReqList): TContextListResponse;
begin
   Result := ListAll(AReq as TReqList) as TContextListResponse;
end;

function TContextsRestBroker.List(AReq: TContextReqList): TContextListResponse;
begin
  Result := List(AReq as TReqList) as TContextListResponse;
end;

function TContextsRestBroker.ListTypes(AReq: TReqList): TFieldSetListResponse;
begin
  Result := TContextTypeListResponse.Create;
  Result := inherited List(AReq, Result);
end;

function TContextsRestBroker.ListTypesAll(AReq: TReqList): TFieldSetListResponse;
begin
  Result := TContextTypeListResponse.Create;
  Result := inherited ListAll(AReq, Result);
end;

function TContextsRestBroker.ListTypesAll(AReq: TContextTypesReqList): TContextTypeListResponse;
begin
  Result := ListTypesAll(AReq as TReqList) as TContextTypeListResponse;
end;

function TContextsRestBroker.ListTypes(AReq: TContextTypesReqList): TContextTypeListResponse;
begin
  Result := ListTypes(AReq as TReqList) as TContextTypeListResponse;
end;

function TContextsRestBroker.New(AReq: TContextReqNew): TIdNewResponse;
begin
  Result := TIdNewResponse.Create('ctxid');
  inherited New(AReq, Result);
end;

function TContextsRestBroker.Remove(AReq: TReqRemove): TJSONResponse;
begin
  Result := inherited Remove(AReq);
end;

function TContextsRestBroker.Remove(AReq: TContextReqRemove): TJSONResponse;
begin
  Result := Remove(AReq as TReqRemove);
end;

function TContextsRestBroker.Update(AReq: TContextReqUpdate): TJSONResponse;
begin
  Result := Update(AReq as TReqUpdate);
end;


function TContextsRestBroker.ListCredentialsAll(AReq: TReqList): TFieldSetListResponse;
begin
  Result := TContextCredsListResponse.Create;
  Result := inherited ListAll(AReq, Result);
end;

function TContextsRestBroker.ListCredentialsAll(AReq: TContextCredsReqList): TContextCredsListResponse;
begin
  Result := ListCredentialsAll(AReq as TReqList) as TContextCredsListResponse;
end;

function TContextsRestBroker.ListCredentials(AReq: TReqList): TFieldSetListResponse;
begin
  Result := TContextCredsListResponse.Create;
  Result := inherited List(AReq, Result);
end;

function TContextsRestBroker.ListCredentials(AReq: TContextCredsReqList): TContextCredsListResponse;
begin
  Result := ListCredentials(AReq as TReqList) as TContextCredsListResponse;
end;

function TContextsRestBroker.CredentialInfo(AReq: TReqInfo): TFieldSetResponse;
begin
  Result := TContextCredInfoResponse.Create;
  try
    ApplyTicket(AReq);
    HttpClient.Request(AReq, Result);
  except
    Result.Free;
    raise;
  end;
end;

function TContextsRestBroker.CredentialInfo(AReq: TContextCredReqInfo): TContextCredInfoResponse;
begin
  Result := CredentialInfo(AReq as TReqInfo) as TContextCredInfoResponse;
end;

function TContextsRestBroker.NewCredential(AReq: TContextCredReqNew): TJSONResponse;
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

function TContextsRestBroker.UpdateCredential(AReq: TContextCredReqUpdate): TJSONResponse;
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

function TContextsRestBroker.RemoveCredential(AReq: TContextCredReqRemove): TJSONResponse;
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

function TContextsRestBroker.CreateReqInfo(id:string=''): TReqInfo;
begin
  Result := TContextReqInfo.CreateID(id);
  Result.BasePath := BasePath;
end;

function TContextsRestBroker.CreateReqList: TReqList;
begin
  Result := TContextReqList.Create;
  Result.BasePath := BasePath;
end;

function TContextsRestBroker.CreateReqNew: TReqNew;
begin
  Result := TContextReqNew.Create;
  Result.BasePath := BasePath;
end;

function TContextsRestBroker.CreateReqRemove: TReqRemove;
begin
  Result := TContextReqRemove.Create;
  Result.BasePath := BasePath;
end;

function TContextsRestBroker.CreateReqUpdate: TReqUpdate;
begin
  Result := TContextReqUpdate.Create;
  Result.BasePath := BasePath;
end;

function TContextsRestBroker.CreateReqContextTypes: TContextTypesReqList;
begin
  Result := TContextTypesReqList.Create;
  Result.BasePath := BasePath;
end;

function TContextsRestBroker.CreateReqCredList: TContextCredsReqList;
begin
  Result := TContextCredsReqList.Create;
  Result.BasePath := BasePath;
end;

function TContextsRestBroker.CreateReqCredInfo(const ACredId: string): TContextCredReqInfo;
begin
  Result := TContextCredReqInfo.CreateID(ACredId);
  Result.BasePath := BasePath;
end;

function TContextsRestBroker.CreateReqCredNew: TContextCredReqNew;
begin
  Result := TContextCredReqNew.Create;
  Result.BasePath := BasePath;
end;

function TContextsRestBroker.CreateReqCredUpdate(const ACredId: string): TContextCredReqUpdate;
begin
  Result := TContextCredReqUpdate.Create;
  Result.BasePath := BasePath;
  if not ACredId.IsEmpty then
    Result.Id := ACredId;
end;

function TContextsRestBroker.CreateReqCredRemove(const ACredId: string): TContextCredReqRemove;
begin
  Result := TContextCredReqRemove.Create;
  Result.BasePath := BasePath;
  if not ACredId.IsEmpty then
    Result.Id := ACredId;
end;

//function TContextsRestBroker.Info(AReq: TReqInfo): TEntityResponse;
//begin
//  Result := TContextInfoResponse.Create;
//  inherited Info(AReq, Result);
//end;

//function TContextsRestBroker.Info(AReq: TContextReqInfo): TContextInfoResponse;
//begin
//  Result := Info(AReq as TReqInfo) as TContextInfoResponse;
//end;

function TContextsRestBroker.Update(AReq: TReqUpdate): TJSONResponse;
begin
  Result := inherited Update(AReq);
end;

end.
