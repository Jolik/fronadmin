unit SocketSpecialLinkParserUnit;

interface
uses
  SysUtils, EntityUnit, System.Generics.Collections,
  System.JSON, FuncUnit, DateUtils, CommParsersUnit,
  LoggingUnit,
  ConnectionUnit, LinkUnit, QueueUnit, ScheduleUnit, uniGUIApplication;

type

  ///  TSocketSpecialLinkParser парсит линк SOCKET_SPECIAL
  TSocketSpecialLinkParser = class(TLinkParser)
  public
    procedure Parse(src: TJSONValue; dst: TEntity); override;
    function Parse(src: TJSONValue): TEntity; overload; override;
    procedure Serialize(src: TEntity; dst: TJSONValue); override;
    function Serialize(src: TEntity): TJSONValue; override;
  end;

implementation


{ TSocketSpecialLinkParser }

procedure TSocketSpecialLinkParser.Parse(src: TJSONValue; dst: TEntity);
begin
  inherited Parse(src, dst);

  if (not (src is TJSONObject)) or (not (dst is TSocketSpecialLink)) then
    RaiseInvalidObjects(src, dst);

  var d := (dst as TSocketSpecialLink);
  var connections := src.FindValue('data.settings.main.tasks[0].connections');
  var queue := src.FindValue('data.settings.main.tasks[0].queue');
  var custom := src.FindValue('data.settings.main.tasks[0].custom');
  var protocol := src.FindValue('data.settings.main.tasks[0].custom.protocol');

  var cp := TConnectionListParser.Create;

  try
    cp.ParseList(connections, d.ConnectionList);
  finally
    cp.Free;
  end;

  if (custom is TJSONObject) then
    d.Atype := GetValueStrDef(custom, 'type', '');

  if (protocol is TJSONObject) then
  begin
    d.ProtocolVer := GetValueStrDef(protocol, 'version', '');
    d.AckCount := GetValueIntDef(protocol, 'ack_count', 0);
    d.AckTimeout := GetValueIntDef(protocol, 'ack_timeout', 0);
    d.InputTriggerSize := GetValueIntDef(protocol, 'input_trigger_size', 0);
    d.InputTriggerTime := GetValueIntDef(protocol, 'input_trigger_time', 0);
    d.InputTriggerCount := GetValueIntDef(protocol, 'input_trigger_count', 0);
    d.MaxInputBufferSize := GetValueIntDef(protocol, 'max_input_buf_size', 0);
    d.ConfirmationMode := GetValueStrDef(protocol, 'confirmation_mode', '');
    d.Compatibility := GetValueStrDef(protocol, 'compatibility', '');
    d.KeepAlive := GetValueBool(protocol, 'keep_alive');
  end;

end;

function TSocketSpecialLinkParser.Parse(src: TJSONValue): TEntity;
begin
  Result := TSocketSpecialLink.Create;

  try
    Parse(src, Result);
  except on e:exception do
    begin
      Log('TSocketSpecialLinkParser.Parse '+ e.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

procedure TSocketSpecialLinkParser.Serialize(src: TEntity; dst: TJSONValue);
const
  linkSettingsStr = '{"settings":{"main":{"tasks": [{"connections":[], "queue":{}, "custom":{"protocol":{}}}]}}}';

begin
  inherited Serialize(src, dst);

  if (not (src is TSocketSpecialLink)) or (not (dst is TJSONObject)) then
    RaiseInvalidObjects(src, dst);

  var d := (dst as TJSONObject);
  var s := (src as TSocketSpecialLink);
  var ssSettings := TJSONObject.Create;

  ssSettings.Parse(TEncoding.UTF8.GetBytes(linkSettingsStr),0);
  d.AddPair('data', ssSettings);

  var connections := d.FindValue('data.settings.main.tasks[0].connections') as TJSONArray;
  var queue := d.FindValue('data.settings.main.tasks[0].queue') as TJSONObject;
  var custom := d.FindValue('data.settings.main.tasks[0].custom') as TJSONObject;
  var protocol := custom.FindValue('protocol') as TJSONObject;

  var cp := TConnectionListParser.Create;
  try
    cp.SerializeList(s.ConnectionList, connections);
  finally
    cp.Free;
  end;

  custom.AddPair('type', s.Atype);
  protocol.AddPair('version', s.ProtocolVer);
  protocol.AddPair('ack_count', s.AckCount);
  protocol.AddPair('ack_timeout', s.AckTimeout);
  protocol.AddPair('input_trigger_size', s.InputTriggerSize);
  protocol.AddPair('input_trigger_time', s.InputTriggerTime);
  protocol.AddPair('input_trigger_count', s.InputTriggerCount);
  protocol.AddPair('max_input_buf_size', s.MaxInputBufferSize);
  protocol.AddPair('confirmation_mode', s.ConfirmationMode);
  protocol.AddPair('compatibility', s.Compatibility);
  protocol.AddPair('keep_alive', s.KeepAlive);
end;

function TSocketSpecialLinkParser.Serialize(src: TEntity): TJSONValue;
begin
  result := TJSONObject.Create;
  try
    Serialize(src, result);
  except on e:exception do
    begin
      Log('TSocketSpecialLinkParser.Serialize '+ e.Message, lrtError);
      FreeAndNil(result);
    end;
  end;
end;

end.
