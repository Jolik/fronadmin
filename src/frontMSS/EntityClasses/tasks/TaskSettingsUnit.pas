unit TaskSettingsUnit;

interface
uses
  System.JSON, System.SysUtils,
  FuncUnit,
  EntityUnit;

type
  /// TCustomSettings настройка для кастомных параметров (которые зависят от типа задачи)
  /// базовый класс не содержит никаких параметров
  TTaskCustomSettings = class(TFieldSet)
  private
  public
  end;

type
  ///  ìàññèâ çíà÷åíèé ExcludeWeek èç Settings
  TExcludeWeek = array of integer;

  ///  íàñòðîéêè ñóùíîñòè SummaryTask
  TTaskSettings = class (TSettings)
  private
  protected
    FLatePeriod: integer;
    FTaskCustomSettings: TTaskCustomSettings;
    FExcludeWeek: TExcludeWeek;

  public
    // ýòè òðåáóþò ñóùåñòâóþùåãî ïðàâèëüíîãî ýêçåìïëÿðà îáúåêòà. íà îøèáêè - ýêñåøàí
    ///  â ìàññèâå const APropertyNames ïåðåäàþòñÿ ïîëÿ, êîòîðûå íåîáõîäèìî èñïîëüçîâàòü
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    // äëÿ ïîëÿ module - òèïà Çàäà÷è
    property LatePeriod: integer read FLatePeriod write FLatePeriod;
  ///  èíôîðìàöèÿ TaskCustomSettings èç Settings
    property TaskCustomSettings: TTaskCustomSettings read FTaskCustomSettings write FTaskCustomSettings;
    ///  ìàññèâ çíà÷åíèé ExcludeWeek èç Settings
    property ExcludeWeek: TExcludeWeek read FExcludeWeek write FExcludeWeek;

  end;


implementation

const
  LatePeriodKey = 'LatePeriod';

  CustomKey = 'Custom';

procedure TTaskSettings.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited;

  ///  ÷èòàåì ïîëå LatePeriod
  LatePeriod := GetValueIntDef(src, LatePeriodKey, 0);

  ///  äîáàâëÿåì ïîëÿ TTaskCustomSettings
  var TaskCustomSettingsValue := src.FindValue(CustomKey);

  ///  TaskCustomSettings çàâèñèò îò ïîëÿ module
  if Assigned(TaskCustomSettings) and (TaskCustomSettingsValue is TJSONObject) then
    TaskCustomSettings.Parse(TaskCustomSettingsValue as TJSONObject);

end;

procedure TTaskSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

  with dst do
  begin
    AddPair(LatePeriodKey, LatePeriod);

    ///  äîáàâëÿåì ïîëÿ TTaskCustomSettings
    var TaskCustomSettingsObject := TJSONObject.Create();

  ///  TaskCustomSettings çàâèñèò îò ïîëÿ module
    if Assigned(TaskCustomSettings) then TaskCustomSettings.Serialize(TaskCustomSettingsObject);

    AddPair(CustomKey, TaskCustomSettingsObject)

  end;
end;

end.
