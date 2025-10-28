unit HandlerHttpRequests;

interface

uses
  System.SysUtils,
  System.JSON,
  EntityUnit,
  HttpClientUnit,
  BaseRequests,
  BaseResponses,
  HandlerUnit;

type
  // List response for handlers
  THandlerListResponse = class(TListResponse)
  private
    function GetHandlerList: THandlerList;
  public
    constructor Create;
    property HandlerList: THandlerList read GetHandlerList;
  end;

  // Info response for a single handler
  THandlerInfoResponse = class(TEntityResponse)
  private
    function GetHandler: THandler;
  public
    constructor Create;
    property Handler: THandler read GetHandler;
  end;

  // Requests
  THandlerReqList = class(TReqList)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  THandlerReqInfo = class(TReqInfo)
  public
    constructor Create; override;
    constructor CreateID(const AHandlerId: string);
  end;

  THandlerReqNew = class(TReqNew)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  THandlerReqUpdate = class(TReqUpdate)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    procedure SetHandlerId(const Value: string);
  end;

  THandlerReqRemove = class(TReqRemove)
  public
    constructor Create; override;
    procedure SetHandlerId(const Value: string);
  end;

implementation

{ THandlerListResponse }

constructor THandlerListResponse.Create;
begin
  inherited Create(THandlerList, 'response', 'handlers');
end;

function THandlerListResponse.GetHandlerList: THandlerList;
begin
  Result := EntityList as THandlerList;
end;

{ THandlerInfoResponse }

constructor THandlerInfoResponse.Create;
begin
  inherited Create(THandler, 'response', 'handler');
end;

function THandlerInfoResponse.GetHandler: THandler;
begin
  Result := Entity as THandler;
end;

{ Requests }

class function THandlerReqList.BodyClassType: TFieldSetClass;
begin
  Result := TReqListBody;
end;

constructor THandlerReqList.Create;
begin
  inherited Create;
  Method:= mGET;
  SetEndpoint('handlers/list');
end;

constructor THandlerReqInfo.Create;
begin
  inherited Create;
  SetEndpoint('handlers');
end;

constructor THandlerReqInfo.CreateID(const AHandlerId: string);
begin
  Create;
  Id := AHandlerId;
end;

class function THandlerReqNew.BodyClassType: TFieldSetClass;
begin
  Result := THandler;
end;

constructor THandlerReqNew.Create;
begin
  inherited Create;
  SetEndpoint('handlers/new');
end;

class function THandlerReqUpdate.BodyClassType: TFieldSetClass;
begin
  Result := THandler;
end;

constructor THandlerReqUpdate.Create;
begin
  inherited Create;
  SetEndpoint('handlers');
end;

procedure THandlerReqUpdate.SetHandlerId(const Value: string);
begin
  Id := Value;
end;

constructor THandlerReqRemove.Create;
begin
  inherited Create;
  SetEndpoint('handlers');
end;

procedure THandlerReqRemove.SetHandlerId(const Value: string);
begin
  Id := Value;
end;

end.

