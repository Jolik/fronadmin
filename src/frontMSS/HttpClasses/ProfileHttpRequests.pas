unit ProfileHttpRequests;

interface

uses
  System.SysUtils, System.JSON,
  EntityUnit, HttpClientUnit, BaseRequests, BaseResponses,
  ProfileUnit;

type
  // profiles are under datacomm + '/links/<lid>/profiles/...'
  TProfileListResponse = class(TListResponse)
  private
    function GetProfileList: TProfileList;
  public
    constructor Create;
    property ProfileList: TProfileList read GetProfileList;
  end;

  TProfileInfoResponse = class(TEntityResponse)
  private
    function GetProfile: TProfile;
  public
    constructor Create;
    property Profile: TProfile read GetProfile;
  end;

  // List request
  TProfileReqList = class(TReqList)
  private
    FLid: string;
    FSuffix: string;
    procedure SetLid(const Value: string);
    procedure UpdateEndpoint;
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    property Lid: string read FLid write SetLid;
  end;

  // Info request
  TProfileReqInfo = class(TReqInfo)
  private
    FLid: string;
    FSuffix: string;
    procedure SetLid(const Value: string);
    procedure UpdateEndpoint;
  public
    constructor Create; override;
    property Lid: string read FLid write SetLid;
  end;

  // New request
  TProfileReqNew = class(TReqNew)
  private
    FLid: string;
    FSuffix: string;
    procedure SetLid(const Value: string);
    procedure UpdateEndpoint;
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    property Lid: string read FLid write SetLid;
  end;

  // Update request
  TProfileReqUpdate = class(TReqUpdate)
  private
    FLid: string;
    FSuffix: string;
    procedure SetLid(const Value: string);
    procedure UpdateEndpoint;
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    property Lid: string read FLid write SetLid;
  end;

  // Remove request
  TProfileReqRemove = class(TReqRemove)
  private
    FLid: string;
    FSuffix: string;
    procedure SetLid(const Value: string);
    procedure UpdateEndpoint;
  public
    constructor Create; override;
    property Lid: string read FLid write SetLid;
  end;

  // helper to build endpoint under 'links[/<lid>]/<suffix>'
  function BuildLinksPath(const Lid, Suffix: string): string;

implementation

{ TProfileListResponse }

constructor TProfileListResponse.Create;
begin
  inherited Create(TProfileList, 'response', 'profiles');
end;

function TProfileListResponse.GetProfileList: TProfileList;
begin
  Result := EntityList as TProfileList;
end;

{ TProfileInfoResponse }

constructor TProfileInfoResponse.Create;
begin
  inherited Create(TProfile, 'response', 'profile');
end;

function TProfileInfoResponse.GetProfile: TProfile;
begin
  Result := Entity as TProfile;
end;

function BuildLinksPath(const Lid, Suffix: string): string;
var
  Path: string;
begin
  Path := 'links';
  if not Lid.Trim.IsEmpty then
    Path := Format('%s/%s', [Path, Lid.Trim]);
  Result := Format('%s/%s', [Path, Suffix]);
end;

{ TProfileReqList }

class function TProfileReqList.BodyClassType: TFieldSetClass;
begin
  Result := TReqListBody;
end;

constructor TProfileReqList.Create;
begin
  inherited Create;
  FSuffix := 'profiles/list';
  SetEndpoint(BuildLinksPath(FLid, FSuffix));
end;

procedure TProfileReqList.SetLid(const Value: string);
begin
  FLid := Value.Trim;
  UpdateEndpoint;
end;

procedure TProfileReqList.UpdateEndpoint;
begin
  SetEndpoint(BuildLinksPath(FLid, FSuffix));
end;

{ TProfileReqInfo }

constructor TProfileReqInfo.Create;
begin
  inherited Create;
  FSuffix := 'profiles';
  SetEndpoint(BuildLinksPath(FLid, FSuffix));
end;

procedure TProfileReqInfo.SetLid(const Value: string);
begin
  FLid := Value.Trim;
  UpdateEndpoint;
end;

procedure TProfileReqInfo.UpdateEndpoint;
begin
  SetEndpoint(BuildLinksPath(FLid, FSuffix));
end;

{ TProfileReqNew }

class function TProfileReqNew.BodyClassType: TFieldSetClass;
begin
  Result := TProfile;
end;

constructor TProfileReqNew.Create;
begin
  inherited Create;
  FSuffix := 'profiles/new';
  SetEndpoint(BuildLinksPath(FLid, FSuffix));
end;

procedure TProfileReqNew.SetLid(const Value: string);
begin
  FLid := Value.Trim;
  UpdateEndpoint;
end;

procedure TProfileReqNew.UpdateEndpoint;
begin
  SetEndpoint(BuildLinksPath(FLid, FSuffix));
end;

{ TProfileReqUpdate }

class function TProfileReqUpdate.BodyClassType: TFieldSetClass;
begin
  Result := TProfile;
end;

constructor TProfileReqUpdate.Create;
begin
  inherited Create;
  FSuffix := 'profiles';
  SetEndpoint(BuildLinksPath(FLid, FSuffix));
end;

procedure TProfileReqUpdate.SetLid(const Value: string);
begin
  FLid := Value.Trim;
  UpdateEndpoint;
end;

procedure TProfileReqUpdate.UpdateEndpoint;
begin
  SetEndpoint(BuildLinksPath(FLid, FSuffix));
end;

{ TProfileReqRemove }

constructor TProfileReqRemove.Create;
begin
  inherited Create;
  FSuffix := 'profiles';
  SetEndpoint(BuildLinksPath(FLid, FSuffix));
end;

procedure TProfileReqRemove.SetLid(const Value: string);
begin
  FLid := Value.Trim;
  UpdateEndpoint;
end;

procedure TProfileReqRemove.UpdateEndpoint;
begin
  SetEndpoint(BuildLinksPath(FLid, FSuffix));
end;

end.
