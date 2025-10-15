unit SummaryTaskUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  System.SysUtils,
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
  ExcludeWeekKey = 'ExcludeWeek';
  if Assigned(CustomObject) then
  begin
    FCustom.Meteo := GetValueBool(CustomObject, MeteoKey);
    FCustom.AnyTime := GetValueIntDef(CustomObject, AnyTimeKey, 0);
    FCustom.Separate := GetValueBool(CustomObject, SeparateKey);
  end
  else
  begin
    FCustom.Meteo := False;
    FCustom.AnyTime := 0;
    FCustom.Separate := False;
  end;
  var ExcludeWeekArray := src.GetValue(ExcludeWeekKey) as TJSONArray;
  if Assigned(ExcludeWeekArray) then
  begin
    SetLength(FExcludeWeek, ExcludeWeekArray.Count);
    for var I := 0 to ExcludeWeekArray.Count - 1 do
      FExcludeWeek[I] := StrToIntDef(ExcludeWeekArray.Items[I].Value, 0);
  end
  else
    SetLength(FExcludeWeek, 0);

    CustomObject.AddPair(MeteoKey, FCustom.Meteo);
    CustomObject.AddPair(SeparateKey, FCustom.Separate);

    AddPair(CustomKey, CustomObject);

    var ExcludeWeekArray := TJSONArray.Create();
    try
      for var Value in FExcludeWeek do
        ExcludeWeekArray.AddElement(TJSONNumber.Create(Value));
      AddPair(ExcludeWeekKey, ExcludeWeekArray);
    except
      ExcludeWeekArray.Free();
      raise;
    end;
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
