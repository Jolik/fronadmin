unit RuleHttpRequests;

interface

uses
  System.SysUtils,
  System.JSON,
  EntityUnit,
  HttpClientUnit,
  StringListUnit,
  BaseRequests,
  BaseResponses,
  RuleUnit;

type
  // List request body (base paging/search)
  TRuleReqListBody = class(TReqListBody)
  end;

  // Response: list of rules
  TRuleListResponse = class(TListResponse)
  private
    function GetRuleList: TRuleList;
  public
    constructor Create;
    property RuleList: TRuleList read GetRuleList;
  end;

  // Response: rule info
  TRuleInfoResponse = class(TEntityResponse)
  private
    function GetRule: TRule;
  public
    constructor Create;
    property Rule: TRule read GetRule;
  end;

  // Create: response for new rule (server may return payload without dedicated id wrapper)
  TRuleNewResponse = class(TFieldSetResponse)
  public
    constructor Create; virtual;
  end;

  // Requests
  TRuleReqList = class(TReqList)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    function Body: TRuleReqListBody;
  end;

  TRuleReqInfo = class(TReqInfo)
  public
    constructor Create; override;
    constructor CreateID(const ARuleId: string);
  end;

  TRuleReqNew = class(TReqNew)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TRuleReqUpdate = class(TReqUpdate)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    procedure SetRuleId(const Value: string);
  end;

  TRuleReqRemove = class(TReqRemove)
  public
    constructor Create; override;
    procedure SetRuleId(const Value: string);
  end;

implementation

uses
  APIConst;

{ TRuleListResponse }

constructor TRuleListResponse.Create;
begin
  inherited Create(TRuleList, 'response', 'rules');
end;

function TRuleListResponse.GetRuleList: TRuleList;
begin
  Result := EntityList as TRuleList;
end;

{ TRuleInfoResponse }

constructor TRuleInfoResponse.Create;
begin
  inherited Create(TRule, 'response', 'rule');
end;

function TRuleInfoResponse.GetRule: TRule;
begin
  Result := Entity as TRule;
end;

{ TRuleNewResponse }

constructor TRuleNewResponse.Create;
begin
  inherited Create(TFieldSet, 'response', '');
end;

{ TRuleReqList }

class function TRuleReqList.BodyClassType: TFieldSetClass;
begin
  Result := TRuleReqListBody;
end;

constructor TRuleReqList.Create;
begin
  inherited Create;
  SetEndpoint('rules/list');
end;

function TRuleReqList.Body: TRuleReqListBody;
begin
  if ReqBody is TRuleReqListBody then
    Result := TRuleReqListBody(ReqBody)
  else
    Result := nil;
end;

{ TRuleReqInfo }

constructor TRuleReqInfo.Create;
begin
  inherited Create;
  SetEndpoint('rules');
end;

constructor TRuleReqInfo.CreateID(const ARuleId: string);
begin
  Create;
  Id := ARuleId;
end;

{ TRuleReqNew }

class function TRuleReqNew.BodyClassType: TFieldSetClass;
begin
  Result := TRule; // send entity JSON
end;

constructor TRuleReqNew.Create;
begin
  inherited Create;
  SetEndpoint('rules/new');
end;

{ TRuleReqUpdate }

class function TRuleReqUpdate.BodyClassType: TFieldSetClass;
begin
  Result := TRule;
end;

constructor TRuleReqUpdate.Create;
begin
  inherited Create;
  SetEndpoint('rules');
end;

procedure TRuleReqUpdate.SetRuleId(const Value: string);
begin
  Id := Value;
end;

{ TRuleReqRemove }

constructor TRuleReqRemove.Create;
begin
  inherited Create;
  SetEndpoint('rules');
end;

procedure TRuleReqRemove.SetRuleId(const Value: string);
begin
  Id := Value;
end;

end.

