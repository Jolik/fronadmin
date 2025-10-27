unit ScheduleSettingsUnit;

interface

uses
  sysutils, System.Classes, System.JSON, System.Generics.Collections,
  Data.DB,
  FuncUnit,
  EntityUnit;

type
  // TSheduleSettings настройки одного расписания работы линка
  TSheduleSettings = class (TFieldSet)
  private
    FCronString: string;
    FPeriod: integer;
    FRetryCount: integer;
    FDisabled: boolean;
    FDelay: integer;

  public
    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property CronString: string read FCronString write FCronString;
    property Period: integer read FPeriod write FPeriod;
    property Disabled: boolean read FDisabled write FDisabled;
    property RetryCount: integer read FRetryCount write FRetryCount;
    property Delay: integer read FDelay write FDelay;

  end;

  // TSheduleSettingsList массив настроек расписания
  TSheduleSettingsList = class(TFieldSetList)
  private
    function GeTSheduleSettings(Index: integer): TSheduleSettings;
    procedure SeTSheduleSettings(Index: integer; const Value: TSheduleSettings);
  protected
    class function ItemClassType: TFieldSetClass; override;
  public
    ///  список расписаний
    property Shedules[Index : integer] : TSheduleSettings read GeTSheduleSettings write SeTSheduleSettings;
  end;


  // TWorkSettings массив настроек расписания и флаг Disabled
  TWorkSettings = class (TFieldSet)
  private
    FDisabled: boolean;
    FList: TSheduleSettingsList;
  public
    constructor Create(); override;
    destructor Destroy; override;
    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Disabled: boolean read FDisabled write FDisabled;
    property List: TSheduleSettingsList read FList write FList;
  end;


implementation

{ TSheduleSettings }

function TSheduleSettings.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;
  if not inherited Assign(ASource) then
    exit;
  if not (ASource is TSheduleSettings) then
    exit;
  var src := ASource as TSheduleSettings;
  CronString := src.CronString;
  Period := src.Period;
  Disabled := src.Disabled;
  RetryCount := src.RetryCount;
  Delay := src.Delay;
  Result := true;
end;

procedure TSheduleSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  CronString := GetValueStrDef(src, 'cron_string', '');
  Period := GetValueIntDef(src, 'period', 0);
  Disabled := GetValueBool(src, 'disabled');
  RetryCount := GetValueIntDef(src, 'retry_count',  0);
  Delay := GetValueIntDef(src, 'delay',  0);
end;

procedure TSheduleSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  dst.AddPair('cron_string', CronString);
  dst.AddPair('period', Period);
  dst.AddPair('disabled', Disabled);
  dst.AddPair('retry_count', RetryCount);
  dst.AddPair('delay', Delay);
end;

{ TSheduleSettingsList }


function TSheduleSettingsList.GeTSheduleSettings(Index: integer): TSheduleSettings;
begin
  Result := nil;
  ///  обязательно проверяем соотвествие классов
  if Items[Index] is TSheduleSettings then
    Result := Items[Index] as TSheduleSettings;
end;


procedure TSheduleSettingsList.SeTSheduleSettings(Index: integer;
  const Value: TSheduleSettings);
begin
  ///  обязательно проверяем соотвествие классов
  if not (Value is TSheduleSettings) then
    exit;

  ///  если в этой позиции есть объект - удаляем его
  if Assigned(Items[Index]) then
    FreeAndNil(Items[Index]);

  Items[Index] := Value;
end;

class function TSheduleSettingsList.ItemClassType: TFieldSetClass;
begin
  result := TSheduleSettings;
end;




{ TWorkSettings }

function TWorkSettings.Assign(ASource: TFieldSet): boolean;
begin
  Result := False;
  if not inherited Assign(ASource) then
    exit;

  if not (ASource is TWorkSettings) then
    Exit;
  var src := (ASource as TWorkSettings);

  List.Assign(src.List);
  Disabled := src.Disabled;
  Result := True;
end;


constructor TWorkSettings.Create;
begin
  inherited;
  FList := TSheduleSettingsList.Create();
end;

destructor TWorkSettings.Destroy;
begin
  FList.Free;
  inherited;
end;

procedure TWorkSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  var schedules := src.FindValue('schedules');

  if not (schedules is TJSONArray) then
    exit;

  List.ParseList(schedules as TJSONArray);
  Disabled := GetValueBool(src, 'disabled');
end;


procedure TWorkSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  dst.AddPair('disabled', Disabled);
  var schedules := TJSONArray.Create;
  List.SerializeList(schedules);
  dst.AddPair('schedules', schedules);
end;

end.
