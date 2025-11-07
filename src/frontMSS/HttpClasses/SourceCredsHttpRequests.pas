unit SourceCredsHttpRequests;

interface

uses
  System.SysUtils, System.JSON,
  EntityUnit, HttpClientUnit, BaseRequests, BaseResponses,
  SourceCredsUnit;

type
  TSourceCredsListResponse = class(TFieldSetListResponse)
  private
    function GetSourceCredsList: TSourceCredsList;
  public
    constructor Create;
    property SourceCredsList: TSourceCredsList read GetSourceCredsList;
  end;

  TSourceCredsInfoResponse = class(TFieldSetResponse)
  private
    function GetSourceCreds: TSourceCred;
  public
    constructor Create;
    property SourceCreds: TSourceCred read GetSourceCreds;
  end;

  TSourceCredsReqList = class(TReqList)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TSourceCredsReqInfo = class(TReqInfo)
  public
    constructor Create; override;
    constructor CreateID(const AId: string);
  end;

  TSourceCredsReqNew = class(TReqNew)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TSourceCredsReqUpdate = class(TReqUpdate)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TSourceCredsReqRemove = class(TReqRemove)
  public
    constructor Create; override;
  end;

implementation

{ TSourceCredsListResponse }

constructor TSourceCredsListResponse.Create;
begin
  inherited Create(TSourceCredsList, 'response', 'credentials');
end;

function TSourceCredsListResponse.GetSourceCredsList: TSourceCredsList;
begin
  Result := FieldSetList as TSourceCredsList;
end;

{ TSourceCredsInfoResponse }

constructor TSourceCredsInfoResponse.Create;
begin
  inherited Create(TSourceCred, 'response', 'credential');
end;

function TSourceCredsInfoResponse.GetSourceCreds: TSourceCred;
begin
  Result := FieldSet as TSourceCred;
end;

{ Requests }

class function TSourceCredsReqList.BodyClassType: TFieldSetClass;
begin
  Result := TReqListBody;
end;

constructor TSourceCredsReqList.Create;
begin
  inherited Create;
  SetEndpoint('sources/contexts/creds/list');
end;

constructor TSourceCredsReqInfo.Create;
begin
  inherited Create;
  SetEndpoint('sources/contexts/creds');
end;

constructor TSourceCredsReqInfo.CreateID(const AId: string);
begin
  Create;
  Id := AId;
end;

class function TSourceCredsReqNew.BodyClassType: TFieldSetClass;
begin
  Result := TSourceCred;
end;

constructor TSourceCredsReqNew.Create;
begin
  inherited Create;
  SetEndpoint('sources/contexts/creds/new');
end;

class function TSourceCredsReqUpdate.BodyClassType: TFieldSetClass;
begin
  Result := TSourceCred;
end;

constructor TSourceCredsReqUpdate.Create;
begin
  inherited Create;
  SetEndpoint('sources/contexts/creds');
end;

constructor TSourceCredsReqRemove.Create;
begin
  inherited Create;
  SetEndpoint('sources/contexts/creds');
end;

end.
