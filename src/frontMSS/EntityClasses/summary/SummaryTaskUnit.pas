unit SummaryTaskUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  LoggingUnit,
  FuncUnit,
  EntityUnit, TaskUnit;

type
  /// Êëàññ çàäà÷è ïàðñåðà (ñåðâèñ summary)
  TSummaryTask = class (TTask)
  private

  protected
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

type
  ///  èíôîðìàöèÿ Custom èç Settings
  TCustom = record
    Meteo: boolean;
    AnyTime: integer;
    Separate: boolean;
  end;

  ///  ìàññèâ çíà÷åíèé ExcludeWeek èç Settings
  TExcludeWeek = array of integer;

  ///  íàñòðîéêè ñóùíîñòè SummaryTask
  TSummaryTaskSettings = class (TSettings)
  private
    FLatePeriod: integer;
    FCustom: TCustom;
    FExcludeWeek: TExcludeWeek;

  public
    // ýòè òðåáóþò ñóùåñòâóþùåãî ïðàâèëüíîãî ýêçåìïëÿðà îáúåêòà. íà îøèáêè - ýêñåøàí
    ///  â ìàññèâå const APropertyNames ïåðåäàþòñÿ ïîëÿ, êîòîðûå íåîáõîäèìî èñïîëüçîâàòü
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    // äëÿ ïîëÿ module - òèïà Çàäà÷è
    property LatePeriod: integer read FLatePeriod write FLatePeriod;
  ///  èíôîðìàöèÿ Custom èç Settings
    property Custom: TCustom read FCustom write FCustom;
    ///  ìàññèâ çíà÷åíèé ExcludeWeek èç Settings
    property ExcludeWeek: TExcludeWeek read FExcludeWeek write FExcludeWeek;

  end;


implementation

const
  LatePeriodKey = 'LatePeriod';

  CustomKey = 'Custom';
  MeteoKey = 'Meteo';
  AnyTimeKey = 'AnyTime';
  SeparateKey = 'Separate';


{ TSummaryTaskList }

class function TSummaryTaskList.ItemClassType: TEntityClass;
begin
  Result := TSummaryTask;
end;

{ TSummaryTaskSettings }

///   ôîðìàò Settings
///
///  "settings": {
///      "LatePeriod": 120,
///      "MonthDays": "1-32",
///      "Header2": "",
//      "Local": false,
//      "CheckLate": false,
//      "Custom": {
//          "Meteo": false,
//          "AnyTime": 0,
//          "Separate": false
//      },
//      "HeaderCorr": 0,
//      "LateEvery": 60,
//      "ExcludeWeek": [0,0,0,0,0,0,0],
//      "Time": "00:00/+5 00:10/* ",
//      "Header": "TTAA11 CXML"
//  }

procedure TSummaryTaskSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

  ///  ÷èòàåì ïîëå LatePeriod
  LatePeriod := GetValueIntDef(src, LatePeriodKey, 0);

  ///  äîáàâëÿåì ïîëÿ TCustom
  var CustomObject := src.GetValue(CustomKey) as TJSONObject;

  ///  Custom çàâèñèò îò ïîëÿ module
(*  FCustom.Meteo := GetValueBool(CustomObject, MeteoKey);
  FCustom.AnyTime := GetValueIntDef(CustomObject, AnyTimeKey, 0);
  FCustom.Separate := GetValueBool(CustomObject, SeparateKey); *)

  /// äîáàâëÿåì ìàñèèâ TExcludeWeek
  /// !!!
end;

procedure TSummaryTaskSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

  with dst do
  begin
    AddPair(LatePeriodKey, LatePeriod);

    ///  äîáàâëÿåì ïîëÿ TCustom
    var CustomObject := TJSONObject.Create();

(*    CustomObject.AddPair(MeteoKey, FCustom.Meteo);
    CustomObject.AddPair(AnyTimeKey, FCustom.AnyTime);
    CustomObject.AddPair(SeparateKey, FCustom.Separate); *)

    AddPair(CustomKey, CustomObject)

  end;
end;

{ TSummaryTask }

class function TSummaryTask.SettingsClassType: TSettingsClass;
begin
  Result := TSummaryTaskSettings;
end;

end.
