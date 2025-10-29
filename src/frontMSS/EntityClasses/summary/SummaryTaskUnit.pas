unit SummaryTaskUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections, System.SysUtils,
  LoggingUnit,
  FuncUnit, KeyValUnit,
  EntityUnit,
  TaskUnit, TaskSettingsUnit, SummaryTaskCustomSettingsUnit;

type
  ///  TaskTypes
  TSummaryTaskType = (
    sttUnknown,
    sttTaskSummaryCXML,
    sttTaskSummarySEBA,
    sttTaskSummarySynop,
    sttTaskSummaryHydra
    );

type
    ///  íàñòðîéêè ñóùíîñòè SummaryTask
  TSummaryTaskSettings = class (TTaskSettings)
  private
    FSummaryTaskType: TSummaryTaskType;
    FMonthDays: string;
    FHeader2: string;
    FLocal: Boolean;
    FCheckLate: Boolean;
    FHeaderCorr: Integer;
    FLateEvery: Integer;
    FTime: string;
    FHeader: string;
    procedure SetSummaryTaskType(const Value: TSummaryTaskType);
  protected
  public
    // SummaryTaskType example SummarySynop
    property SummaryTaskType: TSummaryTaskType read FSummaryTaskType write SetSummaryTaskType;

    ///  çíà÷åíèå MonthDays èç Settings
    property MonthDays: string read FMonthDays write FMonthDays;
    ///  çíà÷åíèå Header2 èç Settings
    property Header2: string read FHeader2 write FHeader2;
    ///  çíà÷åíèå Local èç Settings
    property Local: Boolean read FLocal write FLocal;
    ///  çíà÷åíèå CheckLate èç Settings
    property CheckLate: Boolean read FCheckLate write FCheckLate;
    ///  çíà÷åíèå HeaderCorr èç Settings
    property HeaderCorr: Integer read FHeaderCorr write FHeaderCorr;
    ///  çíà÷åíèå LateEvery èç Settings
    property LateEvery: Integer read FLateEvery write FLateEvery;
    ///  çíà÷åíèå Time èç Settings
    property Time: string read FTime write FTime;
    ///  çíà÷åíèå Header èç Settings
    property Header: string read FHeader write FHeader;

    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

  end;

type
  /// Êëàññ çàäà÷è ïàðñåðà (ñåðâèñ summary)
  TSummaryTask = class (TTask)
  private

  protected
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    ///  ìåòîä âîçâðàùàåò êîíêðåòíûé òèï îáúåêòà Settings
    ///  ïîòîìêè äîëæíû ïåðåîïðåäåëèòü åãî, ïîòîìó ÷òî îí ó âñåõ ðàçíûé
    class function SettingsClassType: TSettingsClass; override;
  public
    function TaskSettings:TSummaryTaskSettings;
  end;

type
  ///  ñïèñîê çàäà÷ äëÿ ñåðâèñà ñàììàðè
  TSummaryTaskList = class (TTaskList)
  protected
    ///  ìåòîä âîçâðàùàåò êîíêðåòíûé òèï îáúåêòà ýëåìåíòà ñïèñêà
    ///  ïîòîìêè äîëæíû ïåðåîïðåäåëèòü åãî, ïîòîìó ÷òî îí ó âñåõ ðàçíûé
    class function ItemClassType: TEntityClass; override;

  end;


implementation

var
  // SummaryTaskType2Str строка = TSummaryTaskType
  SummaryTaskType2Str: TKeyValue<TSummaryTaskType>;

{ TSummaryTaskList }

class function TSummaryTaskList.ItemClassType: TEntityClass;
begin
  Result := TSummaryTask;
end;

{ TSummaryTaskSettings }

procedure TSummaryTaskSettings.SetSummaryTaskType(const Value: TSummaryTaskType);
begin
  if Assigned(FTaskCustomSettings) then
    FreeAndNil(FTaskCustomSettings);

  FSummaryTaskType := Value;
  ///  в зависимости от типа устанавливаем различные настройки
  case Value of
    sttTaskSummaryCXML: FTaskCustomSettings := TSummaryCXMLCustomSettings.Create();
    sttTaskSummarySEBA: FTaskCustomSettings := TSummarySEBACustomSettings.Create();
    sttTaskSummarySynop: FTaskCustomSettings := TSummarySynopCustomSettings.Create();
    sttTaskSummaryHydra: FTaskCustomSettings := TSummaryHydraCustomSettings.Create();
    else FSummaryTaskType :=  sttUnknown;
  end;
end;


procedure TSummaryTaskSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited Parse(src, APropertyNames);

  MonthDays := GetValueStrDef(src, 'MonthDays', '');
  Header2 := GetValueStrDef(src, 'Header2', '');
  Local := GetValueBool(src, 'Local');
  CheckLate := GetValueBool(src, 'CheckLate');
  HeaderCorr := GetValueIntDef(src, 'HeaderCorr', 0);
  LateEvery := GetValueIntDef(src, 'LateEvery', 0);
  Time := GetValueStrDef(src, 'Time', '');
  Header := GetValueStrDef(src, 'Header', '');

  var ExcludeWeekValue := src.FindValue('ExcludeWeek');

  if ExcludeWeekValue is TJSONArray then
  begin
    var ExcludeWeekArray := TJSONArray(ExcludeWeekValue);
    SetLength(FExcludeWeek, ExcludeWeekArray.Count);
    for var i := 0 to ExcludeWeekArray.Count - 1 do
    begin
      var Item := ExcludeWeekArray.Items[i];
      if Item is TJSONNumber then
        FExcludeWeek[i] := TJSONNumber(Item).AsInt
      else
        FExcludeWeek[i] := StrToIntDef(Item.Value, 0);
    end;
  end
  else
    SetLength(FExcludeWeek, 0);
end;

procedure TSummaryTaskSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited Serialize(dst, APropertyNames);

  dst.AddPair('MonthDays', MonthDays);
  dst.AddPair('Header2', Header2);
  dst.AddPair('Local', Local);
  dst.AddPair('CheckLate', CheckLate);
  dst.AddPair('HeaderCorr', HeaderCorr);
  dst.AddPair('LateEvery', LateEvery);
  dst.AddPair('Time', Time);
  dst.AddPair('Header', Header);

  var ExcludeWeekArray := TJSONArray.Create;
  try
    for var Value in FExcludeWeek do
      ExcludeWeekArray.Add(Value);

    dst.AddPair('ExcludeWeek', ExcludeWeekArray);
  except
    ExcludeWeekArray.Free;
    raise;
  end;
end;


{ TSummaryTask }

procedure TSummaryTask.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  ///  определяем тип задачи до разбора настроек
  var ModuleName := GetValueStrDef(src, 'module', '');
  (Settings as TSummaryTaskSettings).SummaryTaskType := SummaryTaskType2Str.ValueByKey(ModuleName, sttUnknown);

  ///  сохраняем module до вызова базового парсера
  Module := ModuleName;

  ///  заполняем базовые поля задачи
  inherited Parse(src, APropertyNames);
end;

class function TSummaryTask.SettingsClassType: TSettingsClass;
begin
  Result := TSummaryTaskSettings;
end;

function TSummaryTask.TaskSettings: TSummaryTaskSettings;
begin
  Result := Settings as TSummaryTaskSettings;
end;

initialization
  SummaryTaskType2Str := TKeyValue<TSummaryTaskType>.Create;
  SummaryTaskType2Str.Add('SummaryCXML', sttTaskSummaryCXML);
  SummaryTaskType2Str.Add('SummarySEBA', sttTaskSummarySEBA);
  SummaryTaskType2Str.Add('SummarySynop', sttTaskSummarySynop);
  SummaryTaskType2Str.Add('SummaryHydra', sttTaskSummaryHydra);

finalization
  SummaryTaskType2Str.Free;

end.
