unit LinkSettingsUnit;

interface

uses
  System.JSON,
  ConnectionSettingsUnit,
  QueueSettingsUnit,
  DirSettingsUnit,
  S3SettingsUnit,
  ScheduleSettingsUnit,
  EntityUnit;



type
  ///  базовые настройки settings которые находятся в поле Data
  TDataSettings = class (TFieldSet)
  private
    FLastActivityTimeout: integer;
    FDump: boolean;
  public
    // эти требуют существующего правильного экземпляра объекта. на ошибки - эксешан
    ///  в массиве const APropertyNames передаются поля, которые необходимо использовать
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property LastActivityTimeout: integer read FLastActivityTimeout write FLastActivityTimeout;
    property Dump: boolean read FDump write FDump;
  end;


  // TSocketSpecialDataSettings SOCKET_SPECIAL
  TSocketSpecialDataSettings = class (TDataSettings)
  private
    FConnections: TConnectionSettingsList;
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

    property Connections: TConnectionSettingsList read FConnections write FConnections;
    property Queue: TQueueSettings read FQueueSettings write FQueueSettings;
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


  // TSocketSpecialDataSettings OPENMCEP
  TOpenMCEPDataSettings = class (TDataSettings)
  private
    FConnections: TConnectionSettingsList;
    FQueueSettings: TQueueSettings;
    FDirSettings: TDirSettings;
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
    property Connections: TConnectionSettingsList read FConnections write FConnections;
    property Queue: TQueueSettings read FQueueSettings write FQueueSettings;
    property Dir: TDirSettings read FDirSettings write FDirSettings;
    property AType: string read FType write FType;
    property PostponeTimeout: integer read FPostponeTimeout write FPostponeTimeout;
    property MaxPostponeMessages: integer read FMaxPostponeMessages write FMaxPostponeMessages;
    property ResendTimeoutSec: integer read FResendTimeoutSec write FResendTimeoutSec;
    property HeartbeatDelay: integer read FHeartbeatDelay write FHeartbeatDelay;
    property MaxFileSize: integer read FMaxFileSize write FMaxFileSize;
  end;

  // TDirDownDataSettings DIR_DOWN
  TDirDownDataSettings = class (TDataSettings)
  private
    FWork: TWorkSettings;
    FDirSettings: TDirSettings;
    FS3: TS3Settings;
    FSeekMetaFile: boolean;

  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Work: TWorkSettings read FWork write FWork;
    property Dir: TDirSettings read FDirSettings write FDirSettings;
    property S3: TS3Settings read FS3 write FS3;
    property SeekMetaFile: boolean read FSeekMetaFile write FSeekMetaFile;
  end;


  TSebaSort = record
    Enabled: boolean;
    PathTemplate: string;
  end;

  // TDirUpDataSettings DIR_UP
  TDirUpDataSettings = class (TDataSettings)
  private
    FFolder: string;
    FSebaSort: TSebaSort;
    FS3: TS3Settings;
    FQueueSettings: TQueueSettings;
    FOnConflict: string;
    FDisableTmp: boolean;

  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Folder: string read FFolder write FFolder;
    property SebaSort: TSebaSort read FSebaSort write FSebaSort;
    property Queue: TQueueSettings read FQueueSettings write FQueueSettings;
    property S3: TS3Settings read FS3 write FS3;
    property OnConflict: string read FOnConflict write FOnConflict;
    property DisableTmp: boolean read FDisableTmp write FDisableTmp;
  end;

  // TFtpCliDownDataSettings  FTP_CLIENT_DOWN
  TFtpCliDownDataSettings = class(TDataSettings)
  private
    FConnections: TConnectionSettingsList;
    FWork: TWorkSettings;
    FDirSettings: TDirSettings;
    FTracking: Boolean;
    FReplaceIp: Boolean; // TODO: убрать (часть FConnections. когда добавлю в датакоме)
    FDelete: boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Connections: TConnectionSettingsList read FConnections write FConnections;
    property Work: TWorkSettings read FWork write FWork;
    property Dir: TDirSettings read FDirSettings write FDirSettings;
    property Tracking: Boolean read FTracking write FTracking;
    property ReplaceIp: Boolean read FReplaceIp write FReplaceIp;
    property DeleteFiles: Boolean read FDelete write FDelete;
  end;

  // TFtpCliUpDataSettings  FTP_CLIENT_UP
  TFtpCliUpDataSettings = class(TDataSettings)
  private
    FFolder: string;
    FConnections: TConnectionSettingsList;
    FQueueSettings: TQueueSettings;

  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Connections: TConnectionSettingsList read FConnections write FConnections;
    property Queue: TQueueSettings read FQueueSettings write FQueueSettings;
    property Folder: string read FFolder write FFolder;
  end;

  // TFtpSrvDownDataSettings FTP_SERVER_DOWN
  TFtpSrvDownDataSettings = class(TDataSettings)
  private
    FConnections: TConnectionSettingsList;
    FPassivePorts: string;
    FPublicIP: string;

  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Connections: TConnectionSettingsList read FConnections write FConnections;
    property PassivePorts: string read FPassivePorts write FPassivePorts;
    property PublicIP: string read FPublicIP write FPublicIP;
  end;


  // TFtpSrvUpDataSettings FTP_SERVER_UP
  TFtpSrvUpDataSettings = class(TDataSettings)
  private
    FConnections: TConnectionSettingsList;
    FPassivePorts: string;
    FPublicIP: string;
    FDirSettings: TDirSettings;
    FQueueSettings: TQueueSettings;

  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Connections: TConnectionSettingsList read FConnections write FConnections;
    property PassivePorts: string read FPassivePorts write FPassivePorts;
    property PublicIP: string read FPublicIP write FPublicIP;
    property Dir: TDirSettings read FDirSettings write FDirSettings;
    property Queue: TQueueSettings read FQueueSettings write FQueueSettings;
  end;

  // TPop3CliDownDataSettings POP3_CLI_DOWN
  TPop3CliDownDataSettings = class(TDataSettings)
  private
    FConnections: TConnectionSettingsList;
    FWork: TWorkSettings;
    FDelete: boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Connections: TConnectionSettingsList read FConnections write FConnections;
    property Work: TWorkSettings read FWork write FWork;
    property DeleteFiles: Boolean read FDelete write FDelete;
  end;

  // TSmtpCliUpDataSettings SMTP_CLI_UP
  TSmtpCliUpDataSettings = class (TDataSettings)
  private
    FConnections: TConnectionSettingsList;
    FQueueSettings: TQueueSettings;
    FEmail: string;
    FMeteoAttachment: boolean;

  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Connections: TConnectionSettingsList read FConnections write FConnections;
    property Queue: TQueueSettings read FQueueSettings write FQueueSettings;
    property Email: string read FEmail write FEmail;
    property MeteoAttachment: boolean read FMeteoAttachment write FMeteoAttachment;
  end;

  // TSmtpSrvDownDataSettings SMTP_SRV_DOWN
  TSmtpSrvDownDataSettings = class (TDataSettings)
  private
    FConnections: TConnectionSettingsList;

  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Connections: TConnectionSettingsList read FConnections write FConnections;
  end;

  // THttpCliDownDataSettings  HTTP_CLIENT_DOWN
  THttpCliDownDataSettings = class(TDataSettings)
  private
    FConnections: TConnectionSettingsList;
    FWork: TWorkSettings;

  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Connections: TConnectionSettingsList read FConnections write FConnections;
    property Work: TWorkSettings read FWork write FWork;
  end;

  // TSebaSgsCliDownDataSettings SEBA_SGS_CLIENT_DOWN
  TSebaSgsCliDownDataSettings = class(TDataSettings)
  private
    FConnections: TConnectionSettingsList;
    FWork: TWorkSettings;

  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Connections: TConnectionSettingsList read FConnections write FConnections;
    property Work: TWorkSettings read FWork write FWork;
  end;

  // TSebaUsrCsdCliDownDataSettings SEBA_USR_CSD_CLIENT_DOWN
  TSebaUsrCsdCliDownDataSettings = class(TDataSettings)
  private
    FConnections: TConnectionSettingsList;
    FWork: TWorkSettings;

  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Connections: TConnectionSettingsList read FConnections write FConnections;
    property Work: TWorkSettings read FWork write FWork;
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
  FConnections := TConnectionSettingsList.Create;
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
  FConnections := TConnectionSettingsList.Create;
  FQueueSettings := TQueueSettings.Create;
  FDirSettings := TDirSettings.Create;
end;

destructor TOpenMCEPDataSettings.Destroy;
begin
  FConnections.Free;
  FQueueSettings.Free;
  FDirSettings.Free;
  inherited;
end;

procedure TOpenMCEPDataSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

  var cs := src.FindValue('connections');
  if cs is TJSONArray then
    FConnections.ParseList(cs as TJSONArray);

  var qs := src.FindValue('queue');
  if qs is TJSONObject then
    FQueueSettings.Parse(qs as TJSONObject);

  var ds := src.FindValue('custom.dir');
  if ds is TJSONObject then
    FDirSettings.Parse(ds as TJSONObject);

  var custom := src.FindValue('custom');
  if (custom is TJSONObject) then
    Atype := GetValueStrDef(custom, 'type', '');

  var protocol := src.FindValue('custom.protocol');
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
  dst.AddPair('queue', FQueueSettings.Serialize());
  dst.AddPair('dir', FDirSettings.Serialize());
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

{ TDirDownDataSettings }

constructor TDirDownDataSettings.Create;
begin
  inherited;
  FWork := TWorkSettings.Create;
  FDirSettings := TDirSettings.Create;
  FS3 := TS3Settings.Create;
end;

destructor TDirDownDataSettings.Destroy;
begin
  FWork.Free;
  FDirSettings.Free;
  FS3.Free;
  inherited;
end;

procedure TDirDownDataSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  var ws := src.FindValue('work');
  var custom := src.FindValue('custom');
  var ds := src.FindValue('custom.dir');
  var s3s := src.FindValue('custom.s3');

  if ws is TJSONObject then
    Work.Parse(ws as TJSONObject);

  if ds is TJSONObject then
    Dir.Parse(ds as TJSONObject);

  if s3s is TJSONObject then
    S3.Parse(s3s as TJSONObject);

  SeekMetaFile := GetValueBool(custom, 'seek_meta_file');
end;

procedure TDirDownDataSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  dst.AddPair('work', FWork.Serialize());
  var custom := TJSONObject.Create;
  dst.AddPair('custom', custom);
  custom.AddPair('seek_meta_file', FSeekMetaFile);
  custom.AddPair('dir', FDirSettings.Serialize());
  custom.AddPair('s3', FS3.Serialize());
end;

{ TDirUpDataSettings }

constructor TDirUpDataSettings.Create;
begin
  inherited;
  FQueueSettings := TQueueSettings.Create;
  FS3 := TS3Settings.Create
end;

destructor TDirUpDataSettings.Destroy;
begin
  FQueueSettings.Free;
  FS3.Free;
  inherited;
end;

procedure TDirUpDataSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  Folder := GetValueStrDef(src, 'default.folder', '');
  OnConflict := GetValueStrDef(src, 'custom.on_conflict', '');
  DisableTmp := GetValueBool(src, 'custom.disable_tmp');
  with FSebaSort do
  begin
    Enabled := GetValueBool(src, 'default.seba_sort.enabled');
    PathTemplate := GetValueStrDef(src, 'default.seba_sort.path_template', '');
  end;

  var s3s := src.FindValue('custom.s3');
  if s3s is TJSONObject then
    S3.Parse(s3s as TJSONObject);

  var qs := src.FindValue('queue');
  if qs is TJSONObject then
    FQueueSettings.Parse(qs as TJSONObject);
end;

procedure TDirUpDataSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

  var default := TJSONObject.Create;
  dst.AddPair('default', default);
  default.AddPair('folder', Folder);

  var ss := TJSONObject.Create;
  default.AddPair('seba_sort', ss);
  ss.AddPair('enabled', SebaSort.Enabled);
  ss.AddPair('path_template', SebaSort.PathTemplate);

  var custom := TJSONObject.Create;
  dst.AddPair('custom', custom);
  custom.AddPair('on_conflict', OnConflict);
  custom.AddPair('disable_tmp', DisableTmp);
  custom.AddPair('s3', S3.Serialize());

  dst.AddPair('queue', Queue.Serialize());
end;

{ TFtpCliDownDataSettings }

constructor TFtpCliDownDataSettings.Create;
begin
  inherited;
  FWork := TWorkSettings.Create;
  FDirSettings := TDirSettings.Create;
  FConnections := TConnectionSettingsList.Create;
end;

destructor TFtpCliDownDataSettings.Destroy;
begin
  FConnections.Free;
  FWork.Free;
  FDirSettings.Free;
  inherited;
end;

procedure TFtpCliDownDataSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

  var cs := src.FindValue('connections');
  if cs is TJSONArray then
    FConnections.ParseList(cs as TJSONArray);

  var ws := src.FindValue('work');
  if ws is TJSONObject then
    Work.Parse(ws as TJSONObject);

  var ds := src.FindValue('custom.dir');
  if ds is TJSONObject then
    FDirSettings.Parse(ds as TJSONObject);

  Tracking := GetValueBool(src, 'custom.tracking');
  ReplaceIp := GetValueBool(src, 'custom.replace_ip');
  DeleteFiles := GetValueBool(src, 'custom.delete');
end;

procedure TFtpCliDownDataSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  dst.AddPair('connections', FConnections.SerializeList());
  dst.AddPair('work', FWork.Serialize());

  var custom := TJSONObject.Create;
  dst.AddPair('custom', custom);
  custom.AddPair('tracking', Tracking);
  custom.AddPair('replace_ip', ReplaceIp);
  custom.AddPair('delete', DeleteFiles);
  custom.AddPair('dir', FDirSettings.Serialize());
end;

{ TFtpCliUpDataSettings }

constructor TFtpCliUpDataSettings.Create;
begin
  inherited;
  FConnections := TConnectionSettingsList.Create();
  FQueueSettings := TQueueSettings.Create;
end;

destructor TFtpCliUpDataSettings.Destroy;
begin
  FConnections.Free;
  FQueueSettings.Free;
  inherited;
end;

procedure TFtpCliUpDataSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

  var cs := src.FindValue('connections');
  if cs is TJSONArray then
    FConnections.ParseList(cs as TJSONArray);

  var qs := src.FindValue('queue');
  if qs is TJSONObject then
    FQueueSettings.Parse(qs as TJSONObject);

  Folder := GetValueStrDef(src, 'default.folder', '');
end;

procedure TFtpCliUpDataSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  dst.AddPair('connections', FConnections.SerializeList());
  dst.AddPair('queue', FQueueSettings.Serialize());

  var default := TJSONObject.Create;
  dst.AddPair('default', default);
  default.AddPair('folder', Folder);
end;

{ TFtpSrvDownDataSettings }

constructor TFtpSrvDownDataSettings.Create;
begin
  inherited;
  FConnections := TConnectionSettingsList.Create();
end;

destructor TFtpSrvDownDataSettings.Destroy;
begin
  FConnections.Free;
  inherited;
end;

procedure TFtpSrvDownDataSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

  var cs := src.FindValue('connections');
  if cs is TJSONArray then
    FConnections.ParseList(cs as TJSONArray);

  PassivePorts := GetValueStrDef(src, 'custom.passive_ports', '');
  PublicIP := GetValueStrDef(src, 'custom.public_ip', '');
end;

procedure TFtpSrvDownDataSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  dst.AddPair('connections', FConnections.SerializeList());

  var custom := TJSONObject.Create;
  dst.AddPair('custom', custom);
  custom.AddPair('passive_ports', PassivePorts);
  custom.AddPair('public_ip', PublicIP);
end;

{ TFtpSrvUpDataSettings }

constructor TFtpSrvUpDataSettings.Create;
begin
  inherited;
  FConnections := TConnectionSettingsList.Create();
  FDirSettings := TDirSettings.Create();
  FQueueSettings := TQueueSettings.Create();
end;

destructor TFtpSrvUpDataSettings.Destroy;
begin
  FConnections.Free;
  FDirSettings.Free;
  FQueueSettings.Free;
  inherited;
end;

procedure TFtpSrvUpDataSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

  var cs := src.FindValue('connections');
  if cs is TJSONArray then
    FConnections.ParseList(cs as TJSONArray);

  var qs := src.FindValue('queue');
  if qs is TJSONObject then
    FQueueSettings.Parse(qs as TJSONObject);

  var ds := src.FindValue('custom.dir');
  if ds is TJSONObject then
    FDirSettings.Parse(ds as TJSONObject);

  PassivePorts := GetValueStrDef(src, 'custom.passive_ports', '');
  PublicIP := GetValueStrDef(src, 'custom.public_ip', '');
end;

procedure TFtpSrvUpDataSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  dst.AddPair('connections', FConnections.SerializeList());
  dst.AddPair('queue', FQueueSettings.Serialize());

  var custom := TJSONObject.Create;
  dst.AddPair('custom', custom);
  custom.AddPair('passive_ports', PassivePorts);
  custom.AddPair('public_ip', PublicIP);
  custom.AddPair('dir', FDirSettings.Serialize());
end;

{ TPop3CliDownDataSettings }

constructor TPop3CliDownDataSettings.Create;
begin
  inherited;
  FConnections := TConnectionSettingsList.Create;
  FWork := TWorkSettings.Create;
end;

destructor TPop3CliDownDataSettings.Destroy;
begin
  FConnections.Free;
  FWork.Free;
  inherited;
end;

procedure TPop3CliDownDataSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

  var cs := src.FindValue('connections');
  if cs is TJSONArray then
    FConnections.ParseList(cs as TJSONArray);

  var ws := src.FindValue('work');
  if ws is TJSONObject then
    Work.Parse(ws as TJSONObject);

  DeleteFiles := GetValueBool(src, 'custom.delete');
end;

procedure TPop3CliDownDataSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  dst.AddPair('connections', FConnections.SerializeList());
  dst.AddPair('work', Work.Serialize());

  var custom := TJSONObject.Create;
  dst.AddPair('custom', custom);
  custom.AddPair('delete', DeleteFiles);
end;

{ TSmtpCliUpDataSettings }

constructor TSmtpCliUpDataSettings.Create;
begin
  inherited;
  FConnections := TConnectionSettingsList.Create;
  FQueueSettings := TQueueSettings.Create;
end;

destructor TSmtpCliUpDataSettings.Destroy;
begin
  FConnections.Free;
  FQueueSettings.Free;
  inherited;
end;

procedure TSmtpCliUpDataSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

  var cs := src.FindValue('connections');
  if cs is TJSONArray then
    FConnections.ParseList(cs as TJSONArray);

  var qs := src.FindValue('queue');
  if qs is TJSONObject then
    FQueueSettings.Parse(qs as TJSONObject);

  Email := GetValueStrDef(src, 'default.email', '');
  MeteoAttachment := GetValueBool(src, 'custom.meteo_attachment');
end;


procedure TSmtpCliUpDataSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  dst.AddPair('connections', FConnections.SerializeList());
  dst.AddPair('queue', FQueueSettings.Serialize());

  var custom := TJSONObject.Create;
  dst.AddPair('custom', custom);
  custom.AddPair('meteo_attachment', MeteoAttachment);

  var default := TJSONObject.Create;
  dst.AddPair('default', default);
  default.AddPair('email', Email);
end;


{ TSmtpSrvDownDataSettings }

constructor TSmtpSrvDownDataSettings.Create;
begin
  inherited;
  FConnections := TConnectionSettingsList.Create();
end;

destructor TSmtpSrvDownDataSettings.Destroy;
begin
  FConnections.Free;
  inherited;
end;

procedure TSmtpSrvDownDataSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  var cs := src.FindValue('connections');
  if cs is TJSONArray then
    FConnections.ParseList(cs as TJSONArray);
end;

procedure TSmtpSrvDownDataSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  dst.AddPair('connections', FConnections.SerializeList());
end;

{ THttpCliDownDataSettings }

constructor THttpCliDownDataSettings.Create;
begin
  inherited;
  FConnections := TConnectionSettingsList.Create();
  FWork := TWorkSettings.Create;
end;

destructor THttpCliDownDataSettings.Destroy;
begin
  FConnections.Free;
  FWork.Free;
  inherited;
end;

procedure THttpCliDownDataSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

  var cs := src.FindValue('connections');
  if cs is TJSONArray then
    FConnections.ParseList(cs as TJSONArray);

  var ws := src.FindValue('work');
  if ws is TJSONObject then
    Work.Parse(ws as TJSONObject);
end;

procedure THttpCliDownDataSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  dst.AddPair('connections', FConnections.SerializeList());
  dst.AddPair('work', Work.Serialize());
end;

{ TSebaSgsCliDownDataSettings }

constructor TSebaSgsCliDownDataSettings.Create;
begin
  inherited;
  FConnections := TConnectionSettingsList.Create();
  FWork := TWorkSettings.Create;
end;

destructor TSebaSgsCliDownDataSettings.Destroy;
begin
  FConnections.Free;
  FWork.Free;
  inherited;
end;

procedure TSebaSgsCliDownDataSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

  var cs := src.FindValue('connections');
  if cs is TJSONArray then
    FConnections.ParseList(cs as TJSONArray);

  var ws := src.FindValue('work');
  if ws is TJSONObject then
    Work.Parse(ws as TJSONObject);
end;

procedure TSebaSgsCliDownDataSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  dst.AddPair('connections', FConnections.SerializeList());
  dst.AddPair('work', Work.Serialize());
end;

{ TSebaUsrCsdCliDownDataSettings }

constructor TSebaUsrCsdCliDownDataSettings.Create;
begin
  inherited;
  FConnections := TConnectionSettingsList.Create();
  FWork := TWorkSettings.Create;
end;

destructor TSebaUsrCsdCliDownDataSettings.Destroy;
begin
  FConnections.Free;
  FWork.Free;
  inherited;
end;

procedure TSebaUsrCsdCliDownDataSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  var cs := src.FindValue('connections');
  if cs is TJSONArray then
    FConnections.ParseList(cs as TJSONArray);

  var ws := src.FindValue('work');
  if ws is TJSONObject then
    Work.Parse(ws as TJSONObject);
end;

procedure TSebaUsrCsdCliDownDataSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  dst.AddPair('connections', FConnections.SerializeList());
  dst.AddPair('work', Work.Serialize());
end;

end.
