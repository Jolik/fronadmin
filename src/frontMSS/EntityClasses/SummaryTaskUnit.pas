unit SummaryTaskUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  LoggingUnit,
  FuncUnit,
  EntityUnit, TaskUnit;

type
  /// Класс задачи парсера (сервис summary)
  TSummaryTask = class (TTask)
  private

  protected
    ///  метод возвращает конкретный тип объекта Settings
    ///  потомки должны переопределить его, потому что он у всех разный
    class function SettingsClassType: TSettingsClass; override;

  public

  end;

type
  ///  список задач для сервиса саммари
  TSummaryTaskList = class (TTaskList)
  protected
    ///  метод возвращает конкретный тип объекта элемента списка
    ///  потомки должны переопределить его, потому что он у всех разный
    class function ItemClassType: TEntityClass; override;

  end;

type
  ///  информация Custom из Settings
  TCustom = record
    Meteo: boolean;
    AnyTime: integer;
    Separate: boolean;
  end;

  ///  массив значений ExcludeWeek из Settings
  TExcludeWeek = array of integer;

  ///  настройки сущности SummaryTask
  TSummaryTaskSettings = class (TSettings)
  private
    FLatePeriod: integer;
    FCustom: TCustom;
    FExcludeWeek: TExcludeWeek;

  public
    // эти требуют существующего правильного экземпляра объекта. на ошибки - эксешан
    ///  в массиве const APropertyNames передаются поля, которые необходимо использовать
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    // для поля module - типа Задачи
    property LatePeriod: integer read FLatePeriod write FLatePeriod;
  ///  информация Custom из Settings
    property Custom: TCustom read FCustom write FCustom;
    ///  массив значений ExcludeWeek из Settings
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

///   формат Settings
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

  ///  читаем поле LatePeriod
  LatePeriod := GetValueIntDef(src, LatePeriodKey, 0);

  ///  добавляем поля TCustom
  var CustomObject := src.GetValue(CustomKey) as TJSONObject;

  ///  Custom зависит от поля module
(*  FCustom.Meteo := GetValueBool(CustomObject, MeteoKey);
  FCustom.AnyTime := GetValueIntDef(CustomObject, AnyTimeKey, 0);
  FCustom.Separate := GetValueBool(CustomObject, SeparateKey); *)

  /// добавляем масиив TExcludeWeek
  /// !!!
end;

procedure TSummaryTaskSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

  with dst do
  begin
    AddPair(LatePeriodKey, LatePeriod);

    ///  добавляем поля TCustom
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
