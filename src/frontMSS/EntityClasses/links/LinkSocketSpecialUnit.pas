unit LinkSocketSpecialUnit;

interface
uses
  EntityUnit, LinkUnit, ConnectionUnit, QueueUnit, System.JSON;


type
  TSocketSpecialLink = class(TLink)
  private
    FConnectionList: TConnectionList;
    FType: string;
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
    constructor Create;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): boolean; override;

    property ConnectionList: TConnectionList read FConnectionList write FConnectionList;
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


implementation

{ TSocketSpecialLink }

constructor TSocketSpecialLink.Create;
begin
  inherited;
  FConnectionList := TConnectionList.Create;
end;

destructor TSocketSpecialLink.Destroy;
begin
  FConnectionList.Free;
  inherited;
end;


function TSocketSpecialLink.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;

  if not inherited Assign(ASource) then
    exit;

  if not (ASource is TConnection) then
    exit;

  var src := ASource as TSocketSpecialLink;

  if not FConnectionList.Assign(src.ConnectionList) then
    exit;

  Atype := src.Atype;
  ProtocolVer := src.ProtocolVer;
  Qid := src.Qid;
  AckCount := src.AckCount;
  AckTimeout := src.AckTimeout;
  InputTriggerSize := src.InputTriggerSize;
  InputTriggerTime := src.InputTriggerTime;
  InputTriggerCount := src.InputTriggerCount;
  MaxInputBufferSize := src.MaxInputBufferSize;
  ConfirmationMode := src.ConfirmationMode;
  Compatibility := src.Compatibility;
  KeepAlive := src.KeepAlive;

  Result := true;
end;

end.
