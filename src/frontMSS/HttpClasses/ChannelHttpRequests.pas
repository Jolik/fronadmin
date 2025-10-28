unit ChannelHttpRequests;

interface

uses
  System.SysUtils, System.JSON,
  EntityUnit, HttpClientUnit, BaseRequests, BaseResponses,
  ChannelUnit;

type
  TChannelListResponse = class(TListResponse)
  private
    function GetChannelList: TChannelList;
  public
    constructor Create;
    property ChannelList: TChannelList read GetChannelList;
  end;

  TChannelInfoResponse = class(TEntityResponse)
  private
    function GetChannel: TChannel;
  public
    constructor Create;
    property Channel: TChannel read GetChannel;
  end;

  TChannelReqList = class(TReqList)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TChannelReqInfo = class(TReqInfo)
  public
    constructor Create; override;
    constructor CreateID(const AId: string);
  end;

  TChannelReqNew = class(TReqNew)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TChannelReqUpdate = class(TReqUpdate)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    procedure SetChannelId(const Value: string);
  end;

  TChannelReqRemove = class(TReqRemove)
  public
    constructor Create; override;
    procedure SetChannelId(const Value: string);
  end;

implementation

{ TChannelListResponse }

constructor TChannelListResponse.Create;
begin
  inherited Create(TChannelList, 'response', 'channels');
end;

function TChannelListResponse.GetChannelList: TChannelList;
begin
  Result := EntityList as TChannelList;
end;

{ TChannelInfoResponse }

constructor TChannelInfoResponse.Create;
begin
  inherited Create(TChannel, 'response', 'channel');
end;

function TChannelInfoResponse.GetChannel: TChannel;
begin
  Result := Entity as TChannel;
end;

{ Requests }

class function TChannelReqList.BodyClassType: TFieldSetClass;
begin
  Result := TReqListBody;
end;

constructor TChannelReqList.Create;
begin
  inherited Create;
  SetEndpoint('channels/list');
  Method := mGET;
end;

constructor TChannelReqInfo.Create;
begin
  inherited Create;
  SetEndpoint('channels');
end;

constructor TChannelReqInfo.CreateID(const AId: string);
begin
  Create;
  Id := AId;
end;

class function TChannelReqNew.BodyClassType: TFieldSetClass;
begin
  Result := TChannel;
end;

constructor TChannelReqNew.Create;
begin
  inherited Create;
  SetEndpoint('channels/new');
end;

class function TChannelReqUpdate.BodyClassType: TFieldSetClass;
begin
  Result := TChannel;
end;

constructor TChannelReqUpdate.Create;
begin
  inherited Create;
  SetEndpoint('channels');
end;

procedure TChannelReqUpdate.SetChannelId(const Value: string);
begin
  Id := Value;
end;

constructor TChannelReqRemove.Create;
begin
  inherited Create;
  SetEndpoint('channels');
end;

procedure TChannelReqRemove.SetChannelId(const Value: string);
begin
  Id := Value;
end;

end.

