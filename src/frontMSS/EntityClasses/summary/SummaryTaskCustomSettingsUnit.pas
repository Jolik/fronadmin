unit SummaryTaskCustomSettingsUnit;

interface
uses
  System.jSON,
  Funcunit,
  EntityUnit,
  TaskSettingsUnit;

type
  /// TTaskCustomSettings настройка дл€ кастомных параметров адачи SummarySEBA
  ///  формат SummarySEBA такой
  (*

    "Custom": {
        "Meteo": false,
        "AnyTime": 0,
        "Separate": false
    },

  *)
  TSummaryCXMLCustomSettings = class(TTaskCustomSettings)
  private
    FMeteo: boolean;
    FAnyTime: integer;
    FSeparate: boolean;

  public
    ///  устанавливаем пол€ с другого объекта
    function Assign(ASource: TFieldSet): boolean; override;

    // эти требуют существующего правильного экземпл€ра объекта. на ошибки - эксешан
    ///  в массиве const APropertyNames передаютс€ пол€, которые необходимо использовать
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    /// поле Meteo
    property Meteo: boolean read FMeteo write FMeteo;
    ///  поле RepLang
    property AnyTime: integer read FAnyTime write FAnyTime;
    ///  поле MsrType
    property Separate: boolean read FSeparate write FSeparate;
   end;

  /// TTaskCustomSettings настройка дл€ кастомных параметров адачи SummarySEBA
  ///  формат SummarySEBA такой
  (*

    "Custom": {
        "MsrPeriod": 19,
        "MsrCaption": "metka",
        "RepLang": 1,
        "MsrType": 1
    }

  *)
  TSummarySEBACustomSettings = class(TTaskCustomSettings)
  private
    FMsrCaption: string;
    FMsrPeriod: integer;
    FMsrType: integer;
    FRepLang: integer;

  public
    ///  устанавливаем пол€ с другого объекта
    function Assign(ASource: TFieldSet): boolean; override;

    // эти требуют существующего правильного экземпл€ра объекта. на ошибки - эксешан
    ///  в массиве const APropertyNames передаютс€ пол€, которые необходимо использовать
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    ///  поле MsrPeriod
    property MsrPeriod: integer read FMsrPeriod write FMsrPeriod;
    /// поле MsrCaption
    property MsrCaption: string read FMsrCaption write FMsrCaption;
    ///  поле RepLang
    property RepLang: integer read FRepLang write FRepLang;
    ///  поле MsrType
    property MsrType: integer read FMsrType write FMsrType;
   end;

type
  /// TTaskCustomSettings настройка дл€ кастомных параметров адачи SummarySynop
  ///  формат SummarySynop такой
  (*

    "Custom": {
        "DataPercent": "75",
        "WindGustFrom": "12",
        "IsAutoStations": "1"
    },

  *)
  TSummarySynopCustomSettings = class(TTaskCustomSettings)
  private
    FDataPercent: integer;
    FIsAutoStations: integer;
    FWindGustFrom: integer;

  public
    ///  устанавливаем пол€ с другого объекта
    function Assign(ASource: TFieldSet): boolean; override;

    // эти требуют существующего правильного экземпл€ра объекта. на ошибки - эксешан
    ///  в массиве const APropertyNames передаютс€ пол€, которые необходимо использовать
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    ///  поле MsrPeriod
    property DataPercent: integer read FDataPercent write FDataPercent;
    ///  поле RepLang
    property WindGustFrom: integer read FWindGustFrom write FWindGustFrom;
    ///  поле MsrType
    property IsAutoStations: integer read FIsAutoStations write FIsAutoStations;
   end;

type
  /// TTaskCustomSettings настройка дл€ кастомных параметров адачи SummaryHydra
  ///  формат SummaryHydra такой
  (*

    "Custom": {
        "AllSection1": "1",
        "DaysAgo": 6
    },

  *)
  TSummaryHydraCustomSettings = class(TTaskCustomSettings)
  private
    FAllSection1: integer;
    FDaysAgo: integer;

  public
    ///  устанавливаем пол€ с другого объекта
    function Assign(ASource: TFieldSet): boolean; override;

    // эти требуют существующего правильного экземпл€ра объекта. на ошибки - эксешан
    ///  в массиве const APropertyNames передаютс€ пол€, которые необходимо использовать
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    ///  поле MsrPeriod
    property AllSection1: integer read FAllSection1 write FAllSection1;
    ///  поле RepLang
    property DaysAgo: integer read FDaysAgo write FDaysAgo;
   end;


implementation

{ TSummarySEBACustomSettings }

function TSummarySEBACustomSettings.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;
  if not inherited Assign(ASource) then
    exit;
  if not (ASource is TSummarySEBACustomSettings) then
    exit;
  var src := ASource as TSummarySEBACustomSettings;
  MsrPeriod := src.MsrPeriod;
  MsrCaption := src.MsrCaption;
  MsrType := src.MsrType;
  RepLang := src.RepLang;
  Result := true;
end;

procedure TSummarySEBACustomSettings.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited;

  MsrPeriod := GetValueIntDef(src, 'MsrPeriod', 0);
  MsrCaption := GetValueStrDef(src, 'MsrCaption', '');
  MsrType := GetValueIntDef(src, 'MsrType', 0);
  RepLang := GetValueIntDef(src, 'RepLang', 0);
end;

procedure TSummarySEBACustomSettings.Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil);
begin
  inherited;
  dst.AddPair('MsrPeriod', MsrPeriod);
  dst.AddPair('MsrCaption', MsrCaption);
  dst.AddPair('MsrType', MsrType);
  dst.AddPair('RepLang', RepLang);
end;


{ TSummarySynopCustomSettings }

function TSummarySynopCustomSettings.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;
  if not inherited Assign(ASource) then
    exit;
  if not (ASource is TSummarySynopCustomSettings) then
    exit;
  var src := ASource as TSummarySynopCustomSettings;
  DataPercent := src.DataPercent;
  IsAutoStations := src.IsAutoStations;
  WindGustFrom := src.WindGustFrom;

  Result := true;
end;

procedure TSummarySynopCustomSettings.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited;

  DataPercent := GetValueIntDef(src, 'DataPercent', 0);
  IsAutoStations := GetValueIntDef(src, 'IsAutoStations', 0);
  WindGustFrom := GetValueIntDef(src, 'WindGustFrom', 0);
end;

procedure TSummarySynopCustomSettings.Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil);
begin
  inherited;
  dst.AddPair('DataPercent', DataPercent);
  dst.AddPair('IsAutoStations', IsAutoStations);
  dst.AddPair('WindGustFrom', WindGustFrom);
end;

{ TSummaryHydraCustomSettings }

function TSummaryHydraCustomSettings.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;
  if not inherited Assign(ASource) then
    exit;
  if not (ASource is TSummaryHydraCustomSettings) then
    exit;
  var src := ASource as TSummaryHydraCustomSettings;
  AllSection1 := src.AllSection1;
  DaysAgo := src.DaysAgo;

  Result := true;
end;

procedure TSummaryHydraCustomSettings.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited;

  AllSection1 := GetValueIntDef(src, 'AllSection1', 0);
  DaysAgo := GetValueIntDef(src, 'DaysAgo', 0);
end;

procedure TSummaryHydraCustomSettings.Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil);
begin
  inherited;
  dst.AddPair('AllSection1', AllSection1);
  dst.AddPair('DaysAgo', DaysAgo);
end;

{ TSummaryCXMLCustomSettings }

function TSummaryCXMLCustomSettings.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;
  if not inherited Assign(ASource) then
    exit;
  if not (ASource is TSummaryCXMLCustomSettings) then
    exit;
  var src := ASource as TSummaryCXMLCustomSettings;
  Meteo := src.Meteo;
  AnyTime := src.AnyTime;
  Separate := src.Separate;

  Result := true;
end;

procedure TSummaryCXMLCustomSettings.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited;

  Meteo := GetValueBool(src, 'Meteo');
  AnyTime := GetValueIntDef(src, 'AnyTime', 0);
  Separate := GetValueBool(src, 'Separate');
end;

procedure TSummaryCXMLCustomSettings.Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil);
begin
  inherited;
  dst.AddPair('Meteo', Meteo);
  dst.AddPair('AnyTime', AnyTime);
  dst.AddPair('Separate', Separate);
end;


end.
