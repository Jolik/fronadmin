unit RouterSourceHttpRequests;

interface

uses
  System.SysUtils, System.JSON,
  EntityUnit, HttpClientUnit, BaseRequests, BaseResponses,
  RouterSourceUnit;

type
  TRouterSourceListResponse = class(TListResponse)
  private
    function GetSourceList: TRouterSourceList;
  public
    constructor Create;
    property SourceList: TRouterSourceList read GetSourceList;
  end;

  TRouterSourceInfoResponse = class(TEntityResponse)
  private
    function GetSource: TRouterSource;
  public
    constructor Create;
    property Source: TRouterSource read GetSource;
  end;

  TRouterSourceReqList = class(TReqList)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TRouterSourceReqInfo = class(TReqInfo)
  public
    constructor Create; override;
    constructor CreateID(const AId: string);
  end;

  TRouterSourceReqNew = class(TReqNew)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TRouterSourceReqUpdate = class(TReqUpdate)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    procedure SetWho(const Value: string);
  end;

  TRouterSourceReqRemove = class(TReqRemove)
  public
    constructor Create; override;
    procedure SetWho(const Value: string);
  end;

implementation

{ TRouterSourceListResponse }

constructor TRouterSourceListResponse.Create;
begin
  inherited Create(TRouterSourceList, 'response', 'sources');
end;

function TRouterSourceListResponse.GetSourceList: TRouterSourceList;
begin
  Result := EntityList as TRouterSourceList;
end;

{ TRouterSourceInfoResponse }

constructor TRouterSourceInfoResponse.Create;
begin
  inherited Create(TRouterSource, 'response', 'source');
end;

function TRouterSourceInfoResponse.GetSource: TRouterSource;
begin
  Result := Entity as TRouterSource;
end;

{ Requests }

class function TRouterSourceReqList.BodyClassType: TFieldSetClass;
begin
  Result := TReqListBody;
end;

constructor TRouterSourceReqList.Create;
begin
  inherited Create;
  SetEndpoint('sources/list');
end;

constructor TRouterSourceReqInfo.Create;
begin
  inherited Create;
  SetEndpoint('sources');
end;

constructor TRouterSourceReqInfo.CreateID(const AId: string);
begin
  Create;
  Id := AId;
end;

class function TRouterSourceReqNew.BodyClassType: TFieldSetClass;
begin
  Result := TRouterSource;
end;

constructor TRouterSourceReqNew.Create;
begin
  inherited Create;
  SetEndpoint('sources/new');
end;

class function TRouterSourceReqUpdate.BodyClassType: TFieldSetClass;
begin
  Result := TRouterSource;
end;

constructor TRouterSourceReqUpdate.Create;
begin
  inherited Create;
  SetEndpoint('sources');
end;

procedure TRouterSourceReqUpdate.SetWho(const Value: string);
begin
  Id := Value;
end;

constructor TRouterSourceReqRemove.Create;
begin
  inherited Create;
  SetEndpoint('sources');
end;

procedure TRouterSourceReqRemove.SetWho(const Value: string);
begin
  Id := Value;
end;

end.

