unit QueueHttpRequests;

interface

uses
  System.SysUtils, System.JSON,
  EntityUnit, HttpClientUnit, BaseRequests, BaseResponses,
  QueueUnit;

type
  TQueueListResponse = class(TListResponse)
  private
    function GetQueueList: TQueueList;
  public
    constructor Create;
    property QueueList: TQueueList read GetQueueList;
  end;

  TQueueInfoResponse = class(TEntityResponse)
  private
    function GetQueue: TQueue;
  public
    constructor Create;
    property Queue: TQueue read GetQueue;
  end;

  TQueueReqList = class(TReqList)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TQueueReqInfo = class(TReqInfo)
  public
    constructor Create; override;
    constructor CreateID(const AId: string);
  end;

  TQueueReqNew = class(TReqNew)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

  TQueueReqUpdate = class(TReqUpdate)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
    procedure SetQueueId(const Value: string);
  end;

  TQueueReqRemove = class(TReqRemove)
  public
    constructor Create; override;
    procedure SetQueueId(const Value: string);
  end;

implementation

{ TQueueListResponse }

constructor TQueueListResponse.Create;
begin
  inherited Create(TQueueList, 'response', 'queues');
end;

function TQueueListResponse.GetQueueList: TQueueList;
begin
  Result := EntityList as TQueueList;
end;

{ TQueueInfoResponse }

constructor TQueueInfoResponse.Create;
begin
  inherited Create(TQueue, 'response', 'queue');
end;

function TQueueInfoResponse.GetQueue: TQueue;
begin
  Result := Entity as TQueue;
end;

{ Requests }

class function TQueueReqList.BodyClassType: TFieldSetClass;
begin
  Result := TReqListBody;
end;

constructor TQueueReqList.Create;
begin
  inherited Create;
  SetEndpoint('queues/list');
end;

constructor TQueueReqInfo.Create;
begin
  inherited Create;
  SetEndpoint('queues');
end;

constructor TQueueReqInfo.CreateID(const AId: string);
begin
  Create;
  Id := AId;
end;

class function TQueueReqNew.BodyClassType: TFieldSetClass;
begin
  Result := TQueue;
end;

constructor TQueueReqNew.Create;
begin
  inherited Create;
  SetEndpoint('queues/new');
end;

class function TQueueReqUpdate.BodyClassType: TFieldSetClass;
begin
  Result := TQueue;
end;

constructor TQueueReqUpdate.Create;
begin
  inherited Create;
  SetEndpoint('queues');
end;

procedure TQueueReqUpdate.SetQueueId(const Value: string);
begin
  Id := Value;
end;

constructor TQueueReqRemove.Create;
begin
  inherited Create;
  SetEndpoint('queues');
end;

procedure TQueueReqRemove.SetQueueId(const Value: string);
begin
  Id := Value;
end;

end.

