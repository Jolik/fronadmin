unit ScheduleSettingsUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  Data.DB,
  EntityUnit;

type
  // TSheduleSettings настройки расписания работы линка
  TSheduleSettings = class (TFieldSet)
  private
    FCronString: string;
    FPeriod: integer;
    FRetryCount: integer;
    FDisabled: boolean;
    FDelay: integer;

  public
    function Assign(ASource: TFieldSet): boolean; override;

    property CronString: string read FCronString write FCronString;
    property Period: integer read FPeriod write FPeriod;
    property Disabled: boolean read FDisabled write FDisabled;
    property RetryCount: integer read FRetryCount write FRetryCount;
    property Delay: integer read FDelay write FDelay;

  end;


  TSheduleSettingsList = class(TFieldSetList)
  private
    FDisabled: boolean;
    function GeTSheduleSettings(Index: integer): TSheduleSettings;
    procedure SeTSheduleSettings(Index: integer; const Value: TSheduleSettings);

  public
    property Disabled: boolean read FDisabled write FDisabled;
    ///  список расписаний
    property Shedules[Index : integer] : TSheduleSettings read GeTSheduleSettings write SeTSheduleSettings;
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
  RetryCount := src.RetryCount;
  Delay := src.Delay;

  Result := true;
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
  begin
    try
      Items[Index].Free();
    finally
      Items[Index] := nil;
    end;
  end;

  Items[Index] := Value;

end;

end.
