unit ChannelUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  Data.DB,
  EntityUnit, QueueUnit, LinkUnit;


type
  TChannelService = class (TData)
    FSvcID: string;
  public
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    property SvcID: string read FSvcID write FSvcID;
  end;


  TChannel = class (TEntity)
  private
    /// очередь канала
    FQueue : TQueue;
    ///  линк канала
    FLink : TLink;
    FService: TChannelService;
    procedure SetService(const Value: TChannelService);
  protected
    function GetIdKey: string; override;
    procedure SetLink(const Value: TLink);
    procedure SetQueue(const Value: TQueue);
    function GetChid: string;
    procedure SetChid(const Value: string);

  public
    constructor Create; override;
    constructor Create(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    // идентификатор канала
    property Chid: string read GetChid write SetChid;
    /// очередь канала
    property Queue : TQueue read FQueue write SetQueue;
    ///  линк канала
    property Link : TLink read FLink write SetLink;

    property Service : TChannelService read FService write SetService;

  end;

  /// список каналов
  TChannelList = class (TEntityList)
    class function ItemClassType: TEntityClass; override;
  end;

implementation

uses
  System.SysUtils,
  FuncUnit;

const
  chidKey = 'chid';
  svcidDataKey = 'svcid';

{ TChannel }

constructor TChannel.Create;
begin
  inherited Create();

  ///  классы-поля всегда остаются одни и те же
  ///  при изменении только присваиваются поля и все
  FService := TChannelService.Create;
  FLink := TLink.Create;
  FQueue := TQueue.Create;
end;


constructor TChannel.Create(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  Create;
  Parse(src, APropertyNames);
end;

destructor TChannel.Destroy;
begin
  FLink.Free;
  FQueue.Free;

  inherited;
end;

procedure TChannel.SetLink(const Value: TLink);
begin
  ///  присваиваем все поля нашему линку
  FLink.Assign(Value);
end;

procedure TChannel.SetQueue(const Value: TQueue);
begin
  ///  присваиваем все поля нашей очереди
  FQueue.Assign(Value);
end;

procedure TChannel.SetService(const Value: TChannelService);
begin
  FService.Assign(Value);
end;

function TChannel.GetChid: string;
begin
  Result := Id;
end;

function TChannel.GetIdKey: string;
begin
  Result := chidKey;
end;

procedure TChannel.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  FService.Parse(src.GetValue('service') as TJSONObject);
  FQueue.Parse(src.GetValue('queue') as TJSONObject);
  FLink.Parse(src.GetValue('link') as TJSONObject);
end;

procedure TChannel.SetChid(const Value: string);
begin
  Id := Value;
end;

{ TChannelList }

class function TChannelList.ItemClassType: TEntityClass;
begin
  Result := TChannel;
end;

{ TChannelService }

procedure TChannelService.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  if not Assigned(src) then
    Exit;
  SvcID := GetValueStrDef(src, svcidDataKey, '');
end;

procedure TChannelService.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  if not Assigned(dst) then
  Exit;

  dst.AddPair(svcidDataKey, SvcID);
end;

end.
