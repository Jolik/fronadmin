unit RulesRestBrokerUnit;

interface

uses
  RestBrokerBaseUnit,
  BaseRequests,
  BaseResponses,
  HttpClientUnit,
  RuleHttpRequests,
  RuleUnit;

type
  TRulesRestBroker = class(TRestBrokerBase)
  public
    BasePath: string;
    constructor Create(const ATicket: string = ''); override;

    function List(AReq: TRuleReqList): TRuleListResponse; overload;
    function List(AReq: TReqList): TListResponse; overload; override;

    function Info(AReq: TRuleReqInfo): TRuleInfoResponse; overload;
    function Info(AReq: TReqInfo): TEntityResponse; overload; override;

    function New(AReq: TRuleReqNew): TRuleNewResponse; overload;
    function New(AReq: TReqNew; AResp: TFieldSetResponse): TFieldSetResponse; overload; override;

    function Update(AReq: TRuleReqUpdate): TJSONResponse; overload;
    function Update(AReq: TReqUpdate): TJSONResponse; overload; override;

    function Remove(AReq: TRuleReqRemove): TJSONResponse; overload;
    function Remove(AReq: TReqRemove): TJSONResponse; overload; override;

    function CreateReqList: TReqList; override;
    function CreateReqInfo: TReqInfo; override;
    function CreateReqNew: TReqNew; override;
    function CreateReqUpdate: TReqUpdate; override;
    function CreateReqRemove: TReqRemove; override;
  end;

implementation

uses
  APIConst;

{ TRulesRestBroker }

constructor TRulesRestBroker.Create(const ATicket: string);
begin
  inherited Create(ATicket);
  BasePath := constURLRouterBasePath;
end;

function TRulesRestBroker.List(AReq: TReqList): TListResponse;
begin
  Result := TRuleListResponse.Create;
  Result := inherited List(AReq, Result);
end;

function TRulesRestBroker.List(AReq: TRuleReqList): TRuleListResponse;
begin
  Result := List(AReq as TReqList) as TRuleListResponse;
end;

function TRulesRestBroker.New(AReq: TReqNew; AResp: TFieldSetResponse): TFieldSetResponse;
begin
  Result := TRuleNewResponse.Create;
  Result := inherited New(AReq, Result);
end;

function TRulesRestBroker.New(AReq: TRuleReqNew): TRuleNewResponse;
begin
  Result := TRuleNewResponse.Create;
  New(AReq, Result);
end;

function TRulesRestBroker.Remove(AReq: TReqRemove): TJSONResponse;
begin
  Result := inherited Remove(AReq);
end;

function TRulesRestBroker.Remove(AReq: TRuleReqRemove): TJSONResponse;
begin
  Result := Remove(AReq as TReqRemove);
end;

function TRulesRestBroker.Update(AReq: TRuleReqUpdate): TJSONResponse;
begin
  Result := Update(AReq as TReqUpdate);
end;

function TRulesRestBroker.CreateReqInfo: TReqInfo;
begin
  Result := TRuleReqInfo.Create;
  Result.BasePath := BasePath;
end;

function TRulesRestBroker.CreateReqList: TReqList;
begin
  Result := TRuleReqList.Create;
  Result.BasePath := BasePath;
end;

function TRulesRestBroker.CreateReqNew: TReqNew;
begin
  Result := TRuleReqNew.Create;
  Result.BasePath := BasePath;
end;

function TRulesRestBroker.CreateReqRemove: TReqRemove;
begin
  Result := TRuleReqRemove.Create;
  Result.BasePath := BasePath;
end;

function TRulesRestBroker.CreateReqUpdate: TReqUpdate;
begin
  Result := TRuleReqUpdate.Create;
  Result.BasePath := BasePath;
end;

function TRulesRestBroker.Info(AReq: TRuleReqInfo): TRuleInfoResponse;
begin
  Result := Info(AReq as TReqInfo) as TRuleInfoResponse;
end;

function TRulesRestBroker.Info(AReq: TReqInfo): TEntityResponse;
begin
  Result := TRuleInfoResponse.Create;
  inherited Info(AReq, Result);
end;

function TRulesRestBroker.Update(AReq: TReqUpdate): TJSONResponse;
begin
  Result := inherited Update(AReq);
end;

end.

