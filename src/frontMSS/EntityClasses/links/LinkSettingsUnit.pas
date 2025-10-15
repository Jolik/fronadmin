unit LinkSettingsUnit;

interface

uses
  System.JSON,
  ConnectionUnit,
  QueueSettingsUnit,
  DirSettingsUnit,
  EntityUnit;

type
  TLinkType = (ltUnknown, ltOpenMCEP, ltSocketSpecial);

type
  ///  базовые настройки settings которые наход€тс€ в поле Data
  TDataSettings = class (TFieldSet)
  private
    FLastActivityTimeout: integer;
    FDump: boolean;
  public
    // эти требуют существующего правильного экземпл€ра объекта. на ошибки - эксешан
    ///  в массиве const APropertyNames передаютс€ пол€, которые необходимо использовать
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property LastActivityTimeout: integer read FLastActivityTimeout write FLastActivityTimeout;
    property Dump: boolean read FDump write FDump;
  end;

type
  // TSocketSpecialDataSettings настрокйи SOCKET_SPECIAL
  TSocketSpecialDataSettings = class (TDataSettings)
  private
    FConnections: TConnectionList;
    FQueueSettings: TQueueSettings;
    FType: string; // 'client'|'server'
    FAckTimeout: integer;
    FProtocolVer: string;
    FAckCount: integer;
    FInputTriggerSize: integer;
    FInputTriggerTime: integer;
    FMaxInputBufferSize: integer;
    FConfirmationMode: string;
    FInputTriggerCount: integer;
    FCompatibility: string;
    FKeepAlive: boolean;
  public
    constructor Create;  override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Connections: TConnectionList read FConnections write FConnections;
    property QueueSettings: TQueueSettings read FQueueSettings write FQueueSettings;
    property Atype: string read FType write FType;
    property ProtocolVer: string read FProtocolVer write FProtocolVer;
    property AckCount: integer read FAckCount write FAckCount;
    property AckTimeout: integer read FAckTimeout write FAckTimeout;
    property InputTriggerSize: integer read FInputTriggerSize write FInputTriggerSize;
    property InputTriggerTime: integer read FInputTriggerTime write FInputTriggerTime;
    property InputTriggerCount: integer read FInputTriggerCount write FInputTriggerCount;
    property MaxInputBufferSize: integer read FMaxInputBufferSize write FMaxInputBufferSize;
    property ConfirmationMode: string read FConfirmationMode write FConfirmationMode;
    property Compatibility: string read FCompatibility write FCompatibility;
    property KeepAlive: boolean read FKeepAlive write FKeepAlive;
  end;


  // TSocketSpecialDataSettings настрокйи OPENMCEP
  TOpenMCEPDataSettings = class (TDataSettings)
  private
    FConnections: TConnectionList;
    FQueue: TQueue;
    FDir: TDir;
    FType: string;  // 'client'|'server'
    FPostponeTimeout: integer;
    FMaxPostponeMessages: integer;
    FResendTimeoutSec: integer;
    FHeartbeatDelay: integer;
    FMaxFileSize: integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    property Connections: TConnectionList read FConnections write FConnections;
    property Queue: TQueue read FQueue write FQueue;
    property Dir: TDir read FDir write FDir;
    property AType: string read FType write FType;
    property PostponeTimeout: integer read FPostponeTimeout write FPostponeTimeout;
    property MaxPostponeMessages: integer read FMaxPostponeMessages write FMaxPostponeMessages;
    property ResendTimeoutSec: integer read FResendTimeoutSec write FResendTimeoutSec;
    property HeartbeatDelay: integer read FHeartbeatDelay write FHeartbeatDelay;
    property MaxFileSize: integer read FMaxFileSize write FMaxFileSize;
  end;

implementation

uses FuncUnit;

{ TDataSettings }

procedure TDataSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  LastActivityTimeout := GetValueIntDef(src, 'last_activity_timeout', 0);
  Dump := GetValueBool(src, 'dump');
end;

procedure TDataSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  dst.AddPair('last_activity_timeout', LastActivityTimeout);
  dst.AddPair('dump', Dump);
end;

{ TSocketSpecialDataSettings }

constructor TSocketSpecialDataSettings.Create;
begin
  inherited;
  FConnections := TConnectionList.Create;
  FQueueSettings := TQueueSettings.Create;
end;

destructor TSocketSpecialDataSettings.Destroy;
begin
  FConnections.Free;
  FQueueSettings.Free;
  inherited;
end;


procedure TSocketSpecialDataSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  FConnections.Clear;
  var cs := src.FindValue('connections');
  var qs := src.FindValue('QueueSettings');
  var custom := src.FindValue('custom');
  var protocol := src.FindValue('custom.protocol');

  if cs is TJSONArray then
    FConnections.ParseList(cs as TJSONArray);

  if qs is TJSONObject then
    FQueueSettings.Parse(qs as TJSONObject);

  if (custom is TJSONObject) then
    Atype := GetValueStrDef(custom, 'type', '');

  if (protocol is TJSONObject) then
  begin
    ProtocolVer := GetValueStrDef(protocol, 'version', '');
    AckCount := GetValueIntDef(protocol, 'ack_count', 0);
    AckTimeout := GetValueIntDef(protocol, 'ack_timeout', 0);
    InputTriggerSize := GetValueIntDef(protocol, 'input_trigger_size', 0);
    InputTriggerTime := GetValueIntDef(protocol, 'input_trigger_time', 0);
    InputTriggerCount := GetValueIntDef(protocol, 'input_trigger_count', 0);
    MaxInputBufferSize := GetValueIntDef(protocol, 'max_input_buf_size', 0);
    ConfirmationMode := GetValueStrDef(protocol, 'confirmation_mode', '');
    Compatibility := GetValueStrDef(protocol, 'compatibility', '');
    KeepAlive := GetValueBool(protocol, 'keep_alive');
  end;
end;


procedure TSocketSpecialDataSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  dst.AddPair('connections', FConnections.SerializeList());
  dst.AddPair('QueueSettings', FQueueSettings.Serialize());
  var custom := TJSONObject.Create;
  dst.AddPair('custom', custom);
  custom.AddPair('type', AType);
  var protocol := TJSONObject.Create;
  custom.AddPair('protocol', protocol);
  protocol.AddPair('version', ProtocolVer);
  protocol.AddPair('ack_count', AckCount);
  protocol.AddPair('ack_timeout', AckTimeout);
  protocol.AddPair('input_trigger_size', InputTriggerSize);
  protocol.AddPair('input_trigger_time', InputTriggerTime);
  protocol.AddPair('input_trigger_count', InputTriggerCount);
  protocol.AddPair('max_input_buf_size', MaxInputBufferSize);
  protocol.AddPair('confirmation_mode', ConfirmationMode);
  protocol.AddPair('compatibility', Compatibility);
  protocol.AddPair('keep_alive', KeepAlive);
end;

{ TOpenMCEPDataSettings }

constructor TOpenMCEPDataSettings.Create;
begin
  inherited;
  FConnections := TConnectionList.Create;
  FQueue := TQueue.Create;
  FDir := TDir.Create;
end;

destructor TOpenMCEPDataSettings.Destroy;
begin
  FConnections.Free;
  FQueue.Free;
  FDir.Free;
  inherited;
end;

procedure TOpenMCEPDataSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  FConnections.Clear;
  var cs := src.FindValue('connections');
  var qs := src.FindValue('queue');
  var custom := src.FindValue('custom');
  var protocol := src.FindValue('custom.protocol');
  var ds := src.FindValue('custom.dir');

  if cs is TJSONArray then
    FConnections.ParseList(cs as TJSONArray);

  if qs is TJSONObject then
    FQueue.Parse(qs as TJSONObject);

  if ds is TJSONObject then
    FDir.Parse(ds as TJSONObject);

  if (custom is TJSONObject) then
    Atype := GetValueStrDef(custom, 'type', '');

  if (protocol is TJSONObject) then
  begin
    PostponeTimeout := GetValueIntDef(protocol, 'postpone_timeout', 0);
    MaxPostponeMessages := GetValueIntDef(protocol, 'max_postpone_messages', 0);
    ResendTimeoutSec := GetValueIntDef(protocol, 'resend_timeout_sec', 0);
    HeartbeatDelay := GetValueIntDef(protocol, 'heartbeat_delay', 0);
    MaxFileSize := GetValueIntDef(protocol, 'max_file_size', 0);
  end;
end;

procedure TOpenMCEPDataSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  dst.AddPair('connections', FConnections.SerializeList());
  dst.AddPair('queue', FQueue.Serialize());
  dst.AddPair('dir', FDir.Serialize());
  var custom := TJSONObject.Create;
  dst.AddPair('custom', custom);
  custom.AddPair('type', AType);
  var protocol := TJSONObject.Create;
  custom.AddPair('protocol', protocol);
  protocol.AddPair('postpone_timeout', PostponeTimeout);
  protocol.AddPair('max_postpone_messages', MaxPostponeMessages);
  protocol.AddPair('resend_timeout_sec', ResendTimeoutSec);
  protocol.AddPair('heartbeat_delay', HeartbeatDelay);
  protocol.AddPair('max_file_size', MaxFileSize);
end;

end.
