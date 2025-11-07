unit ContextsHttpRequests;

interface

uses
  System.SysUtils,
  System.JSON,
  EntityUnit,
  HttpClientUnit,
  BaseRequests,
  BaseResponses,
  ContextUnit,
  ContextTypeUnit,
  SourceCredsUnit,
  StringListUnit;

type
  // Extended body for POST /sources/contexts/list with filtering arrays
  TContextReqListBody = class(TReqListBody)
  private
    FCtxtIds: TStringArray;
    FCtxIds: TStringArray;
    FCrids: TStringArray;
    FSids: TStringArray;
    FIndexes: TStringArray;
    procedure WriteArray(const Key: string; const Value: TStringArray; dst: TJSONObject);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property CtxtIds: TStringArray read FCtxtIds;
    property CtxIds: TStringArray read FCtxIds;
    property Crids: TStringArray read FCrids;
    property Sids: TStringArray read FSids;
    property Indexes: TStringArray read FIndexes;
  end;

  // Response wrapper for /sources/contexts/list
  TContextListResponse = class(TFieldSetListResponse)
  private
    function GetContextList: TContextList;
  public
    constructor Create;
    property ContextList: TContextList read GetContextList;
  end;

  // Response wrapper for /sources/contexts/types/list
  TContextTypeListResponse = class(TFieldSetListResponse)
  private
    function GetContextTypes: TContextTypeList;
  public
    constructor Create; override;
    property ContextTypesList: TContextTypeList read GetContextTypes;
  end;

  // Response wrapper for context credentials list
  TContextCredsListResponse = class(TFieldSetListResponse)
  private
    function GetCredentialList: TSourceCredsList;
  public
    constructor Create;
    property CredentialList: TSourceCredsList read GetCredentialList;
  end;

  // Response wrapper for single credential
  TContextCredInfoResponse = class(TFieldSetResponse)
  private
    function GetCredential: TSourceCred;
  public
    constructor Create;
    property Credential: TSourceCred read GetCredential;
  end;

  TContextReqList = class(TReqList)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    function Body: TContextReqListBody;
  end;

  // GET /sources/contexts/types/list
  TContextTypesReqList = class(TReqList)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TContextReqInfo = class(TReqInfo)
  public
    constructor Create; override;
    constructor CreateID(const AId: string);
  end;

  TContextReqNew = class(TReqNew)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TContextReqUpdate = class(TReqUpdate)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TContextReqRemove = class(TReqRemove)
  public
    constructor Create; override;
  end;

  // Body for POST /sources/contexts/creds/list
  TContextCredsReqListBody = class(TReqListBody)
  private
    FCtxIds: TStringArray;
    FCrids: TStringArray;
    FLids: TStringArray;
    FNames: TStringArray;
    FLogins: TStringArray;
    FUpdateFrom: Int64;
    FUpdateTo: Int64;
    FArchiveOnly: Boolean;
    FVerbose: Boolean;
    procedure WriteArray(const Key: string; const Value: TStringArray; dst: TJSONObject);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property CtxIds: TStringArray read FCtxIds;
    property Crids: TStringArray read FCrids;
    property Lids: TStringArray read FLids;
    property Names: TStringArray read FNames;
    property Logins: TStringArray read FLogins;
    property UpdateFrom: Int64 read FUpdateFrom write FUpdateFrom;
    property UpdateTo: Int64 read FUpdateTo write FUpdateTo;
    property ArchiveOnly: Boolean read FArchiveOnly write FArchiveOnly;
    property Verbose: Boolean read FVerbose write FVerbose;
  end;

  // POST /sources/contexts/creds/list
  TContextCredsReqList = class(TReqList)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    function Body: TContextCredsReqListBody;
  end;

  // GET /sources/contexts/creds/{crid}
  TContextCredReqInfo = class(TReqInfo)
  public
    constructor Create; override;
    constructor CreateID(const ACredId: string);
  end;

  // POST /sources/contexts/creds/new
  TContextCredReqNew = class(TReqNew)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  // POST /sources/contexts/creds/{crid}/update
  TContextCredReqUpdate = class(TReqUpdate)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  // POST /sources/contexts/creds/{crid}/remove
  TContextCredReqRemove = class(TReqRemove)
  public
    constructor Create; override;
  end;

implementation

{ TContextReqListBody }

constructor TContextReqListBody.Create;
begin
  inherited Create;
  FCtxtIds := TStringArray.Create;
  FCtxIds := TStringArray.Create;
  FCrids := TStringArray.Create;
  FSids := TStringArray.Create;
  FIndexes := TStringArray.Create;
end;

destructor TContextReqListBody.Destroy;
begin
  FCtxtIds.Free;
  FCtxIds.Free;
  FCrids.Free;
  FSids.Free;
  FIndexes.Free;
  inherited;
end;

procedure TContextReqListBody.WriteArray(const Key: string; const Value: TStringArray; dst: TJSONObject);
var
  Arr: TJSONArray;
begin
  if not Assigned(Value) or (Value.Count = 0) then
    Exit;

  Arr := TJSONArray.Create;
  try
    Value.Serialize(Arr);
    dst.AddPair(Key, Arr);
  except
    Arr.Free;
    raise;
  end;
end;

procedure TContextReqListBody.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Serialize(dst, APropertyNames);
  WriteArray('ctxtid', FCtxtIds, dst);
  WriteArray('ctxid', FCtxIds, dst);
  WriteArray('crid', FCrids, dst);
  WriteArray('sid', FSids, dst);
  WriteArray('index', FIndexes, dst);
end;

{ TContextListResponse }

constructor TContextListResponse.Create;
begin
  inherited Create(TContextList, 'response', 'contexts');
end;

function TContextListResponse.GetContextList: TContextList;
begin
  Result := FieldSetList as TContextList;
end;

{ TContextTypeListResponse }

constructor TContextTypeListResponse.Create;
begin
  inherited Create(TContextTypeList, 'response', 'ctxtypes');
end;

function TContextTypeListResponse.GetContextTypes: TContextTypeList;
begin
  Result := FieldSetList as TContextTypeList;
end;

{ TContextCredsListResponse }

constructor TContextCredsListResponse.Create;
begin
  inherited Create(TSourceCredsList, 'response', 'credentials');
end;

function TContextCredsListResponse.GetCredentialList: TSourceCredsList;
begin
  Result := FieldSetList as TSourceCredsList;
end;

{ TContextCredInfoResponse }

constructor TContextCredInfoResponse.Create;
begin
  inherited Create(TSourceCred, 'response', 'credential');
end;

function TContextCredInfoResponse.GetCredential: TSourceCred;
begin
  Result := FieldSet as TSourceCred;
end;

{ TContextReqList }

class function TContextReqList.BodyClassType: TFieldSetClass;
begin
  Result := TContextReqListBody;
end;

function TContextReqList.Body: TContextReqListBody;
begin
  Result := inherited Body as TContextReqListBody;
end;

constructor TContextReqList.Create;
begin
  inherited Create;
  SetEndpoint('sources/contexts/list');
end;

{ TContextTypesReqList }

class function TContextTypesReqList.BodyClassType: TFieldSetClass;
begin
  Result := nil;
end;

constructor TContextTypesReqList.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('sources/contexts/types/list');
end;

{ TContextReqInfo }

constructor TContextReqInfo.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('sources/contexts');
end;

constructor TContextReqInfo.CreateID(const AId: string);
begin
  Create;
  Id := AId;
end;

{ TContextReqNew }

class function TContextReqNew.BodyClassType: TFieldSetClass;
begin
  Result := TContext;
end;

constructor TContextReqNew.Create;
begin
  inherited Create;
  SetEndpoint('sources/contexts/new');
end;

{ TContextReqUpdate }

class function TContextReqUpdate.BodyClassType: TFieldSetClass;
begin
  Result := TContext;
end;

constructor TContextReqUpdate.Create;
begin
  inherited Create;
  SetEndpoint('sources/contexts');
end;

{ TContextReqRemove }

constructor TContextReqRemove.Create;
begin
  inherited Create;
  SetEndpoint('sources/contexts');
end;

{ TContextCredsReqListBody }

constructor TContextCredsReqListBody.Create;
begin
  inherited Create;
  FCtxIds := TStringArray.Create;
  FCrids := TStringArray.Create;
  FLids := TStringArray.Create;
  FNames := TStringArray.Create;
  FLogins := TStringArray.Create;
  FUpdateFrom := 0;
  FUpdateTo := 0;
  FArchiveOnly := False;
  FVerbose := False;
end;

destructor TContextCredsReqListBody.Destroy;
begin
  FCtxIds.Free;
  FCrids.Free;
  FLids.Free;
  FNames.Free;
  FLogins.Free;
  inherited;
end;

procedure TContextCredsReqListBody.WriteArray(const Key: string; const Value: TStringArray; dst: TJSONObject);
var
  Arr: TJSONArray;
begin
  if not Assigned(Value) or (Value.Count = 0) then
    Exit;

  Arr := TJSONArray.Create;
  try
    Value.Serialize(Arr);
    dst.AddPair(Key, Arr);
  except
    Arr.Free;
    raise;
  end;
end;

procedure TContextCredsReqListBody.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Serialize(dst, APropertyNames);
  WriteArray('ctxid', FCtxIds, dst);
  WriteArray('crid', FCrids, dst);
  WriteArray('lid', FLids, dst);
  WriteArray('name', FNames, dst);
  WriteArray('login', FLogins, dst);

  if FUpdateFrom <> 0 then
    dst.AddPair('updateFrom', TJSONNumber.Create(FUpdateFrom));
  if FUpdateTo <> 0 then
    dst.AddPair('updateTo', TJSONNumber.Create(FUpdateTo));
  if FArchiveOnly then
    dst.AddPair('archiveonly', TJSONBool.Create(True));
  if FVerbose then
    dst.AddPair('verbose', TJSONBool.Create(True));
end;

{ TContextCredsReqList }

class function TContextCredsReqList.BodyClassType: TFieldSetClass;
begin
  Result := TContextCredsReqListBody;
end;

constructor TContextCredsReqList.Create;
begin
  inherited Create;
  SetEndpoint('sources/contexts/creds/list');
end;

function TContextCredsReqList.Body: TContextCredsReqListBody;
begin
  Result := inherited Body as TContextCredsReqListBody;
end;

{ TContextCredReqInfo }

constructor TContextCredReqInfo.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('sources/contexts/creds');
end;

constructor TContextCredReqInfo.CreateID(const ACredId: string);
begin
  Create;
  Id := ACredId;
end;

{ TContextCredReqNew }

class function TContextCredReqNew.BodyClassType: TFieldSetClass;
begin
  Result := TSourceCred;
end;

constructor TContextCredReqNew.Create;
begin
  inherited Create;
  SetEndpoint('sources/contexts/creds/new');
end;

{ TContextCredReqUpdate }

class function TContextCredReqUpdate.BodyClassType: TFieldSetClass;
begin
  Result := TSourceCred;
end;

constructor TContextCredReqUpdate.Create;
begin
  inherited Create;
  SetEndpoint('sources/contexts/creds');
end;

{ TContextCredReqRemove }

constructor TContextCredReqRemove.Create;
begin
  inherited Create;
  SetEndpoint('sources/contexts/creds');
end;

end.
