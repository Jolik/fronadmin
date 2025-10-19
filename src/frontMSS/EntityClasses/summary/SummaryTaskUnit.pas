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
    procedure SetSummaryTaskType(const Value: TSummaryTaskType);
  protected
  public
    // SummaryTaskType example SummarySynop
    property SummaryTaskType: TSummaryTaskType read FSummaryTaskType write SetSummaryTaskType;

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


{ TSummaryTask }

procedure TSummaryTask.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  ///  заполняем базовые поля задачи
  inherited Parse(src, APropertyNames);

  ///  в зависимости от типа задачи выбираем класс настроек Settings
  (Settings as TSummaryTaskSettings).SummaryTaskType := SummaryTaskType2Str.ValueByKey(Module, sttUnknown);

end;

class function TSummaryTask.SettingsClassType: TSettingsClass;
begin
  Result := TSummaryTaskSettings;
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
