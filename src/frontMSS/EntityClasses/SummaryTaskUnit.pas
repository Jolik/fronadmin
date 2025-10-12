unit SummaryTaskUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  LoggingUnit,
  FuncUnit,
  EntityUnit, TaskUnit;

type
  /// ����� ������ ������� (������ summary)
  TSummaryTask = class (TTask)
  private

  protected
    ///  ����� ���������� ���������� ��� ������� Settings
    ///  ������� ������ �������������� ���, ������ ��� �� � ���� ������
    class function SettingsClassType: TSettingsClass; override;

  public

  end;

type
  ///  ������ ����� ��� ������� �������
  TSummaryTaskList = class (TTaskList)
  protected
    ///  ����� ���������� ���������� ��� ������� �������� ������
    ///  ������� ������ �������������� ���, ������ ��� �� � ���� ������
    class function ItemClassType: TEntityClass; override;

  end;

type
  ///  ���������� Custom �� Settings
  TCustom = record
    Meteo: boolean;
    AnyTime: integer;
    Separate: boolean;
  end;

  ///  ������ �������� ExcludeWeek �� Settings
  TExcludeWeek = array of integer;

  ///  ��������� �������� SummaryTask
  TSummaryTaskSettings = class (TSettings)
  private
    FLatePeriod: integer;
    FCustom: TCustom;
    FExcludeWeek: TExcludeWeek;

  public
    // ��� ������� ������������� ����������� ���������� �������. �� ������ - �������
    ///  � ������� const APropertyNames ���������� ����, ������� ���������� ������������
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    // ��� ���� module - ���� ������
    property LatePeriod: integer read FLatePeriod write FLatePeriod;
  ///  ���������� Custom �� Settings
    property Custom: TCustom read FCustom write FCustom;
    ///  ������ �������� ExcludeWeek �� Settings
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

///   ������ Settings
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

  ///  ������ ���� LatePeriod
  LatePeriod := GetValueIntDef(src, LatePeriodKey, 0);

  ///  ��������� ���� TCustom
  var CustomObject := src.GetValue(CustomKey) as TJSONObject;

  ///  Custom ������� �� ���� module
(*  FCustom.Meteo := GetValueBool(CustomObject, MeteoKey);
  FCustom.AnyTime := GetValueIntDef(CustomObject, AnyTimeKey, 0);
  FCustom.Separate := GetValueBool(CustomObject, SeparateKey); *)

  /// ��������� ������ TExcludeWeek
  /// !!!
end;

procedure TSummaryTaskSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

  with dst do
  begin
    AddPair(LatePeriodKey, LatePeriod);

    ///  ��������� ���� TCustom
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
