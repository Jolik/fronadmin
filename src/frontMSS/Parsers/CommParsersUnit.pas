unit CommParsersUnit;

{
  конвертаци€ json-TLink и наоборот
}

interface
uses
  System.SysUtils, System.Generics.Collections, System.JSON, System.DateUtils,
  LoggingUnit, FuncUnit,
  EntityUnit, EntityParsersUnit, LinkSocketSpecialUnit,
  ConnectionUnit, LinkUnit, QueueUnit, ScheduleUnit;

type
  // TConnectionListParser парсит объект TConnectionList
  TConnectionListParser = class(TEntityListParser)
  public
    // эти требуют существующего правильного экземпл€ра списка. на ошибки - эксешан
    procedure ParseList(src: TJSONValue; dst: TEntityList); override;
    procedure SerializeList(src: TEntityList; dst: TJSONValue); override;

    // эти сами создают список а в случае ошибки вернут nil и запишут в журнал
    function ParseList(src: TJSONValue): TEntityList; override;
    function SerializeList(src: TEntityList): TJSONValue; override;

  end;

  // TScheduleParser парсит объект TSheduleList
  TScheduleListParser = class(TEntityListParser)
  public
    procedure ParseList(src: TJSONValue; dst: TEntityList); override;
    function ParseList(src: TJSONValue): TEntityList; overload; override;
    procedure SerializeList(src: TEntityList; dst: TJSONValue); override;
    function SerializeList(src: TEntityList): TJSONValue; override;
  end;


  // TLinkParser парсит общие пол€ линков типа dir type ит
  TLinkParser = class(TEntityParser)
  public
    procedure Parse(src: TJSONValue; dst: TEntity); override;
    function Parse(src: TJSONValue): TEntity; overload; override;
    procedure Serialize(src: TEntity; dst: TJSONValue); override;
    function Serialize(src: TEntity): TJSONValue; override;
  end;



var
  // ParsersMap key=link type
  ParsersMap: TDictionary<string, TLinkParser>;

implementation
uses
  SocketSpecialLinkParserUnit;


procedure initParsersMap();
begin
  ParsersMap.Add('SOCKET_SPECIAL', TSocketSpecialLinkParser.Create);

end;

{ TConnectionListParser }

procedure TConnectionListParser.ParseList(src: TJSONValue; dst: TEntityList);
begin
  if (not (src is TJSONArray)) or (not (dst is TConnectionList)) then
    exit;

  var s := (src as TJSONArray);

  for var cj in s do
  begin
    var c := TConnection.Create;

    c.Addr := GetValueStrDef(cj, 'addr', '');
    c.Timeout := GetValueIntDef(cj, 'timeout', 0);
    c.Enabled := not GetValueBool(cj, 'disabled');

    var secure: TSecure;

    with secure.tls.Certificates do
    begin
      CRT := GetValueStrDef(cj, 'secure.tls.certificates.crt', '');
      Key := GetValueStrDef(cj, 'secure.tls.certificates.key', '');
      CA := GetValueStrDef(cj, 'secure.tls.certificates.ca', '');
    end;

    with secure.tls do
      Enabled := GetValueBool(cj, 'secure.tls.enabled');

    with secure.Auth do
    begin
      Login := GetValueStrDef(cj, 'secure.auth.login', '');
      Password := GetValueStrDef(cj, 'secure.auth.password', '');
    end;

    c.Secure := secure;

    (dst as TConnectionList).Add(c)
  end;
end;

function TConnectionListParser.ParseList(src: TJSONValue): TEntityList;
begin
  Result := TConnectionList.Create;

  try
    ParseList(src, Result);

  except on e:exception do
    begin
      Log('TConnectionListParser.Parse '+ e.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

procedure TConnectionListParser.SerializeList(src: TEntityList; dst: TJSONValue);
const
  connectionStr = '{"secure":{"auth":{},"tls":{"certificates":{}}}}';

begin
  if (not (dst is TJSONArray)) or (not (src is TConnectionList)) then
    exit;

  for var i := 0 to (src as TConnectionList).Count-1 do
  begin
     var cj := TJSONObject.Create;
     var c := (src as TConnectionList).Connections[i];

     (dst as TJSONArray).AddElement(cj);

     cj.Parse(TEncoding.UTF8.GetBytes(connectionStr),0);
     cj.AddPair('addr', c.Addr);
     cj.AddPair('timeout', c.Timeout);
     cj.AddPair('disabled', not c.Enabled);

     var secure := cj.FindValue('secure.auth') as TJSONObject;

     secure.AddPair('login', c.Secure.Auth.Login);
     secure.AddPair('password', c.Secure.Auth.Password);
     var tls := cj.FindValue('secure.tls') as TJSONObject;
     tls.AddPair('enabled', c.Secure.TLS.Enabled);
     var certificates := cj.FindValue('secure.tls.certificates') as TJSONObject;
     certificates.AddPair('crt', c.Secure.TLS.Certificates.CRT);
     certificates.AddPair('key', c.Secure.TLS.Certificates.Key);
     certificates.AddPair('ca', c.Secure.TLS.Certificates.CA);
  end;
end;

function TConnectionListParser.SerializeList(src: TEntityList): TJSONValue;
begin
  result := TJSONArray.Create;

  try
    SerializeList(src, result);

  except on e:exception do
    begin
      Log('TConnectionListParser.Serialize '+ e.Message, lrtError);
      FreeAndNil(result);
    end;
  end;
end;

{ TScheduleParser }

procedure TScheduleListParser.ParseList(src: TJSONValue; dst: TEntityList);
begin
  if (not (src is TJSONObject)) or (not (dst is TSheduleList)) then
    exit;

  var d := (dst as TSheduleList);
  var work := (src as TJSONObject).FindValue('work');

  if (not (work is TJSONObject)) then
    exit;

  d.Disabled := not GetValueBool(work, 'disabled');
  var schedules := work.FindValue('schedules');
  if (not (schedules is TJSONArray)) then
    exit;
  for var s in (schedules as TJSONArray) do
  begin
    var schedule := TShedule.Create;
    schedule.CronString := GetValueStrDef(src, 'cron_string', '');
    schedule.Period := GetValueIntDef(src, 'period', 0);
    schedule.Enabled := not GetValueBool(src, 'disabled');
    schedule.RetryCount := GetValueIntDef(src, 'retry_count', 0);
    schedule.Delay := GetValueIntDef(src, 'delay', 0);
    d.Add(schedule);
  end;
end;

function TScheduleListParser.ParseList(src: TJSONValue): TEntityList;
begin
  Result := TSheduleList.Create;

  try
    ParseList(src, Result);

  except on e:exception do
    begin
      Log('TScheduleListParser.Parse '+ e.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

procedure TScheduleListParser.SerializeList(src: TEntityList; dst: TJSONValue);
begin
  if (not (src is TSheduleList)) or (not (dst is TJSONObject)) then
    exit;

  var schedules := (src as TSheduleList);
  var work := TJSONObject.Create;

  (dst as TJSONObject).AddPair('work', work);
  work.AddPair('disabled', schedules.Disabled);

  var schedulesJson := TJSONArray.Create;

  work.AddPair('schedules', schedulesJson);

  for var i := 0 to schedules.Count-1 do
  begin
    var sj := TJSONObject.Create;
    var schedule := schedules.Shedules[i];

    schedulesJson.AddElement(sj);
    sj.AddPair('cron_string', schedule.CronString);
    sj.AddPair('period', schedule.Period);
    sj.AddPair('disabled', not schedule.Enabled);
    sj.AddPair('retry_count', schedule.RetryCount);
    sj.AddPair('delay', schedule.Delay);
  end;
end;

function TScheduleListParser.SerializeList(src: TEntityList): TJSONValue;
begin
  result := TJSONObject.Create;

  try
    SerializeList(src, result);

  except on e:exception do
    begin
      Log('TScheduleListParser.Serialize '+ e.Message, lrtError);
      FreeAndNil(result);
    end;
  end;
end;



{ TLinkParser }


function TLinkParser.Parse(src: TJSONValue): TEntity;
begin
  Result := TLink.Create;
  try
    Parse(src, Result);
  except on e:exception do
    begin
      Log('TLinkParser.Parse '+ e.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;


procedure TLinkParser.Parse(src: TJSONValue; dst: TEntity);
begin
  inherited Parse(src, dst);

  if (not (src is TJSONObject)) or (not (dst is TLink)) then
    exit;

  var d := (dst as TLink);

  d.TypeStr := GetValueStrDef(src, 'type', '');
  d.Dir := GetValueStrDef(src, 'dir', '');
  d.Status := GetValueStrDef(src, 'status', '');
  d.Comsts := GetValueStrDef(src, 'comsts', '');
  d.LastActivityTime := GetValueIntDef(src, 'last_activity_time',0);
end;

function TLinkParser.Serialize(src: TEntity): TJSONValue;
begin
  result := TJSONObject.Create;
  try
    Serialize(src, result);
  except on e:exception do
    begin
      Log('TLinkParser.Serialize '+ e.Message, lrtError);
      FreeAndNil(result);
    end;
  end;
end;

procedure TLinkParser.Serialize(src: TEntity; dst: TJSONValue);
begin
  inherited Serialize(src, dst);

  if (not (src is TLink)) or (not (dst is TJSONObject)) then
    exit;

  var d := (dst as TJSONObject);
  var s := (src as TLink);

  d.AddPair('type', s.TypeStr);
  d.AddPair('dir', s.Dir);
  d.AddPair('status', s.Status);
  d.AddPair('comsts', s.Comsts);
  d.AddPair('last_activity_time', s.LastActivityTime);
end;






initialization
  ParsersMap := TDictionary<string, TLinkParser>.create;
  initParsersMap();

finalization
  freeAndNil(ParsersMap);

end.
