unit LinksHttpRequests;

interface

uses
  System.SysUtils, System.JSON,
  EntityUnit, HttpClientUnit, BaseRequests, BaseResponses,
  LinkUnit;

type
  TLinkListResponse = class(TListResponse)
  private
    function GetLinkList: TLinkList;
  public
    constructor Create;
    property LinkList: TLinkList read GetLinkList;
  end;

  TLinkInfoResponse = class(TEntityResponse)
  private
    function GetLink: TLink;
  public
    constructor Create;
    property Link: TLink read GetLink;
  end;

  TLinkReqList = class(TReqList)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TLinkReqInfo = class(TReqInfo)
  protected
    function BuildAddPath(const Id: string): string; override;
  public
    constructor Create; override;
    constructor CreateID(const AId: string);
  end;

  TLinkReqNew = class(TReqNew)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TLinkReqUpdate = class(TReqUpdate)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TLinkReqRemove = class(TReqRemove)
  public
    constructor Create; override;
  end;

implementation

{ TLinkListResponse }

constructor TLinkListResponse.Create;
begin
  inherited Create(TLinkList, 'response', 'links');
end;

function TLinkListResponse.GetLinkList: TLinkList;
begin
  Result := EntityList as TLinkList;
end;

{ TLinkInfoResponse }

constructor TLinkInfoResponse.Create;
begin
  inherited Create(TLink, 'response', '');
end;

function TLinkInfoResponse.GetLink: TLink;
begin
  Result := Entity as TLink;
end;

{ Requests }

class function TLinkReqList.BodyClassType: TFieldSetClass;
begin
  Result := TReqListBody;
end;

constructor TLinkReqList.Create;
begin
  inherited Create;
  SetEndpoint('links/list');
end;

constructor TLinkReqInfo.Create;
begin
  inherited Create;
  SetEndpoint('links');
end;

constructor TLinkReqInfo.CreateID(const AId: string);
begin
  Create;
  Id := AId;
end;

function TLinkReqInfo.BuildAddPath(const Id: string): string;
begin
  if Id.Trim.IsEmpty then
    Result := ''
  else
    Result := Format('%s/info', [Id.Trim]);
end;

class function TLinkReqNew.BodyClassType: TFieldSetClass;
begin
  Result := TLink;
end;

constructor TLinkReqNew.Create;
begin
  inherited Create;
  SetEndpoint('links/new');
end;

class function TLinkReqUpdate.BodyClassType: TFieldSetClass;
begin
  Result := TLink;
end;

constructor TLinkReqUpdate.Create;
begin
  inherited Create;
  SetEndpoint('links');
end;

constructor TLinkReqRemove.Create;
begin
  inherited Create;
  SetEndpoint('links');
end;

end.
