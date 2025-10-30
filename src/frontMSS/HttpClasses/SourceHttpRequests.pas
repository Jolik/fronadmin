unit SourceHttpRequests;

interface

uses
  System.SysUtils,
  System.JSON,
  EntityUnit,
  HttpClientUnit,
  StringListUnit,
  BaseRequests,
  BaseResponses,
  SourceUnit;

type
  // List response for sources
  TSourceListResponse = class(TFieldSetListResponse)
  private
    function GetSourceList: TSourceList;
  public
    constructor Create;
    property SourceList: TSourceList read GetSourceList;
  end;

  // Info response for a single source
  TSourceInfoResponse = class(TFieldSetResponse)
  private
    function GetSource: TSource;
  public
    constructor Create;
    property Source: TSource read GetSource;
  end;

  // GET /sources/list
  TSourceReqList = class(TReqList)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  // GET /sources/<sid>
  TSourceReqInfo = class(TReqInfo)
  public
    constructor Create; override;
    procedure SetSourceId(const Value: string);
  end;

  // POST /sources/new
  TSourceReqNew = class(TReqNew)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  // POST /sources/<sid>/update
  TSourceReqUpdate = class(TReqUpdate)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    procedure SetSourceId(const Value: string);
  end;

  // POST /sources/rem?sid=<sid>
  TSourceReqRemove = class(TReqRemove)
  public
    constructor Create; override;
    procedure SetSourceId(const Value: string);
  end;

implementation

{ TSourceListResponse }

constructor TSourceListResponse.Create;
begin
  inherited Create(TSourceList, 'response', 'sources');
end;

function TSourceListResponse.GetSourceList: TSourceList;
begin
  Result := FieldSetList as TSourceList;
end;

{ TSourceInfoResponse }

constructor TSourceInfoResponse.Create;
begin
  inherited Create(TSource, 'response', 'source');
end;

function TSourceInfoResponse.GetSource: TSource;
begin
  Result := FieldSet as TSource;
end;

{ Requests }

class function TSourceReqList.BodyClassType: TFieldSetClass;
begin
  Result := nil;
end;

constructor TSourceReqList.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('sources/list');
end;

constructor TSourceReqInfo.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('sources');
end;

procedure TSourceReqInfo.SetSourceId(const Value: string);
begin
  Id := Value;
  if Value <> '' then
    SetEndpoint(Format('sources/%s', [Value]))
  else
    SetEndpoint('sources');
end;

class function TSourceReqNew.BodyClassType: TFieldSetClass;
begin
  Result := TSource;
end;

constructor TSourceReqNew.Create;
begin
  inherited Create;
  Method := mPOST;
  SetEndpoint('sources/new');
end;

class function TSourceReqUpdate.BodyClassType: TFieldSetClass;
begin
  Result := TSource;
end;

constructor TSourceReqUpdate.Create;
begin
  inherited Create;
  Method := mPOST;
  SetEndpoint('sources');
end;

procedure TSourceReqUpdate.SetSourceId(const Value: string);
begin
  Id := Value;
  if Value <> '' then
    SetEndpoint(Format('sources/%s/update', [Value]))
  else
    SetEndpoint('sources/update');
end;

constructor TSourceReqRemove.Create;
begin
  inherited Create;
  Method := mPOST;
  SetEndpoint('sources/rem');
end;

procedure TSourceReqRemove.SetSourceId(const Value: string);
begin
  Id := Value;
  if Value <> '' then
    Params.AddOrSetValue('sid', Value);
end;

end.
