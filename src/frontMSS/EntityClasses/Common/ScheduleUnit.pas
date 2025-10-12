unit ScheduleUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  Data.DB,
  EntityUnit;

type
  // TShedule настройки расписания работы линка
  TShedule = class (TFieldSet)
  private
    FCronString: string;
    FPeriod: integer;
    FRetryCount: integer;
    FDelay: integer;

  public
    function Assign(ASource: TFieldSet): boolean; override;

    property CronString: string read FCronString write FCronString;
    property Period: integer read FPeriod write FPeriod;
    property RetryCount: integer read FRetryCount write FRetryCount;
    property Delay: integer read FDelay write FDelay;

  end;


  TSheduleList = class(TFieldSetList)
  private
    FDisabled: boolean;
    function GetShedule(Index: integer): TShedule;
    procedure SetShedule(Index: integer; const Value: TShedule);

  public
    property Disabled: boolean read FDisabled write FDisabled;
    ///  список расписаний
    property Shedules[Index : integer] : TShedule read GetShedule write SetShedule;
  end;



implementation

{ TShedule }

function TShedule.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;

  if not inherited Assign(ASource) then
    exit;

  if not (ASource is TShedule) then
    exit;

  var src := ASource as TShedule;

  CronString := src.CronString;
  Period := src.Period;
  RetryCount := src.RetryCount;
  Delay := src.Delay;

  Result := true;
end;

{ TSheduleList }

function TSheduleList.GetShedule(Index: integer): TShedule;
begin
  Result := nil;

  ///  обязательно проверяем соотвествие классов
  if Items[Index] is TShedule then
    Result := Items[Index] as TShedule;

end;

procedure TSheduleList.SetShedule(Index: integer;
  const Value: TShedule);
begin
  ///  обязательно проверяем соотвествие классов
  if not (Value is TShedule) then
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
