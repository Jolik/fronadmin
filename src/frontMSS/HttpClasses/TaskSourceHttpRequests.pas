unit TaskSourceHttpRequests;

interface

uses
  System.SysUtils,
  System.JSON,
  EntityUnit,
  HttpClientUnit,
  StringListUnit,
  BaseRequests,
  BaseResponses,
  TaskSourceUnit;

type
  // List response for task sources
  TTaskSourceListResponse = class(TFieldSetListResponse)
  private
    function GetTaskSourceList: TTaskSourceList;
  public
    constructor Create;
    property TaskSourceList: TTaskSourceList read GetTaskSourceList;
  end;

  // Info response for a single task source
  TTaskSourceInfoResponse = class(TFieldSetResponse)
  private
    function GetTaskSource: TTaskSource;
  public
    constructor Create;
    property TaskSource: TTaskSource read GetTaskSource;
  end;

  // Request descriptors
  // GET /tasks[/<tid>]/sources/list
  TTaskSourceReqList = class(TReqList)
  private
    FTid: string;
    procedure SetTid(const Value: string);
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    // Parent task identifier as a dedicated request property
    property Tid: string read FTid write SetTid;
  end;

  // GET /tasks[/<tid>]/sources/<sid>
  TTaskSourceReqInfo = class(TReqInfo)
  private
    FTid: string;
    procedure SetTid(const Value: string);
  public
    constructor Create; override;
    // Parent task identifier as a dedicated request property
    property Tid: string read FTid write SetTid;
  end;

  // POST /tasks[/<tid>]/sources/new with TTaskSource body
  TTaskSourceReqNew = class(TReqNew)
  private
    FTid: string;
    procedure SetTid(const Value: string);
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    // Parent task identifier as a dedicated request property
    property Tid: string read FTid write SetTid;
  end;

  // POST /tasks[/<tid>]/sources/<sid>/update with TTaskSource body
  TTaskSourceReqUpdate = class(TReqUpdate)
  private
    FTid: string;
    procedure SetTid(const Value: string);
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    procedure SetSourceId(const Value: string);
    // Parent task identifier as a dedicated request property
    property Tid: string read FTid write SetTid;
  end;

  // POST /tasks[/<tid>]/sources/<sid>/remove
  TTaskSourceReqRemove = class(TReqRemove)
  private
    FTid: string;
    procedure SetTid(const Value: string);
  public
    constructor Create; override;
    procedure SetSourceId(const Value: string);
    // Parent task identifier as a dedicated request property
    property Tid: string read FTid write SetTid;
  end;

implementation

{ TTaskSourceListResponse }

constructor TTaskSourceListResponse.Create;
begin
  inherited Create(TTaskSourceList, 'response', 'sources');
end;

function TTaskSourceListResponse.GetTaskSourceList: TTaskSourceList;
begin
  Result := FieldSetList as TTaskSourceList;
end;

{ TTaskSourceInfoResponse }

constructor TTaskSourceInfoResponse.Create;
begin
  inherited Create(TTaskSource, 'response', 'source');
end;

function TTaskSourceInfoResponse.GetTaskSource: TTaskSource;
begin
  Result := FieldSet as TTaskSource;
end;

{ Requests }

class function TTaskSourceReqList.BodyClassType: TFieldSetClass;
begin
  // No body needed for GET list
  Result := nil;
end;

constructor TTaskSourceReqList.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('sources/list');
end;

procedure TTaskSourceReqList.SetTid(const Value: string);
var
  N: string;
begin
  N := Value.Trim;
  FTid := N;
  if FTid.IsEmpty then
    SetEndpoint('sources/list')
  else
    SetEndpoint(Format('%s/%s', [FTid, 'sources/list']));
end;

constructor TTaskSourceReqInfo.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('sources');
end;

procedure TTaskSourceReqInfo.SetTid(const Value: string);
var
  N: string;
begin
  N := Value.Trim;
  FTid := N;
  if FTid.IsEmpty then
    SetEndpoint('sources')
  else
    SetEndpoint(Format('%s/%s', [FTid, 'sources']));
end;

class function TTaskSourceReqNew.BodyClassType: TFieldSetClass;
begin
  Result := TTaskSource;
end;

constructor TTaskSourceReqNew.Create;
begin
  inherited Create;
  Method := mPOST;
  SetEndpoint('sources/new');
end;

procedure TTaskSourceReqNew.SetTid(const Value: string);
var
  N: string;
begin
  N := Value.Trim;
  FTid := N;
  if FTid.IsEmpty then
    SetEndpoint('sources/new')
  else
    SetEndpoint(Format('%s/%s', [FTid, 'sources/new']));
end;

class function TTaskSourceReqUpdate.BodyClassType: TFieldSetClass;
begin
  Result := TTaskSource;
end;

constructor TTaskSourceReqUpdate.Create;
begin
  inherited Create;
  Method := mPOST;
  SetEndpoint('sources');
end;

procedure TTaskSourceReqUpdate.SetSourceId(const Value: string);
begin
  Id := Value;
end;

procedure TTaskSourceReqUpdate.SetTid(const Value: string);
var
  N: string;
begin
  N := Value.Trim;
  FTid := N;
  if FTid.IsEmpty then
    SetEndpoint('sources')
  else
    SetEndpoint(Format('%s/%s', [FTid, 'sources']));
end;

constructor TTaskSourceReqRemove.Create;
begin
  inherited Create;
  Method := mPOST;
  SetEndpoint('sources');
end;

procedure TTaskSourceReqRemove.SetSourceId(const Value: string);
begin
  Id := Value;
end;

procedure TTaskSourceReqRemove.SetTid(const Value: string);
var
  N: string;
begin
  N := Value.Trim;
  FTid := N;
  if FTid.IsEmpty then
    SetEndpoint('sources')
  else
    SetEndpoint(Format('%s/%s', [FTid, 'sources']));
end;

end.
