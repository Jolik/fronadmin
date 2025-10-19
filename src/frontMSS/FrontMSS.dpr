program FrontMSS;

uses
  Forms,
  ServerModule in 'ServerModule.pas' {UniServerModule: TUniGUIServerModule},
  MainModule in 'MainModule.pas' {UniMainModule: TUniGUIMainModule},
  Main in 'Main.pas' {MainForm: TUniForm},
  LoggingUnit in 'Logging\LoggingUnit.pas',
  TextFileLoggerUnit in 'Logging\TextFileLoggerUnit.pas',
  ListParentFormUnit in 'Forms\ListParentFormUnit.pas' {ListParentForm: TUniForm},
  ParentEditFormUnit in 'Forms\ParentEditFormUnit.pas' {ParentEditForm: TUniForm},
  ParentFormUnit in 'Forms\ParentFormUnit.pas' {ParentForm: TUniForm},
  StripTaskEditFormUnit in 'Forms\StripTaskEditFormUnit.pas' {StripTaskEditForm: TUniForm},
  StripTasksFormUnit in 'Forms\StripTasksFormUnit.pas' {StripTasksForm: TUniForm},
  APIConst in 'APIClasses\APIConst.pas',
  MonitoringTasksBrokerUnit in 'APIClasses\MonitoringTasksBrokerUnit.pas',
  StripTasksBrokerUnit in 'APIClasses\StripTasksBrokerUnit.pas',
  SummaryTasksBrokerUnit in 'APIClasses\SummaryTasksBrokerUnit.pas',
  TasksBrokerUnit in 'APIClasses\TasksBrokerUnit.pas',
  MonitoringTaskUnit in 'EntityClasses\monitoring\MonitoringTaskUnit.pas',
  StripTaskUnit in 'EntityClasses\strips\StripTaskUnit.pas',
  MainHttpModuleUnit in 'APIClasses\MainHttpModuleUnit.pas',
  SummaryTaskEditFormUnit in 'Forms\SummaryTaskEditFormUnit.pas',
  SummaryTasksFormUnit in 'Forms\SummaryTasksFormUnit.pas',
  EntityBrokerUnit in 'APIClasses\EntityBrokerUnit.pas',
  ConstsUnit in 'Common\ConstsUnit.pas',
  FuncUnit in 'Common\FuncUnit.pas',
  KeyValUnit in 'Common\KeyValUnit.pas',
  ParentTaskCustomSettingsEditFrameUnit in 'Forms\TasksFrames\ParentTaskCustomSettingsEditFrameUnit.pas' {ParentTaskCustomSettingsEditFrame: TUniFrame},
  ConditionUnit in 'EntityClasses\Common\ConditionUnit.pas',
  EntityUnit in 'EntityClasses\Common\EntityUnit.pas',
  FilterUnit in 'EntityClasses\Common\FilterUnit.pas',
  GeoTypeUnit in 'EntityClasses\Common\GeoTypeUnit.pas',
  GUIDListUnit in 'EntityClasses\Common\GUIDListUnit.pas',
  StringListUnit in 'EntityClasses\Common\StringListUnit.pas',
  StringUnit in 'EntityClasses\Common\StringUnit.pas',
  TaskSettingsUnit in 'EntityClasses\tasks\TaskSettingsUnit.pas',
  TaskSourceUnit in 'EntityClasses\tasks\TaskSourceUnit.pas',
  TaskTypesUnit in 'EntityClasses\tasks\TaskTypesUnit.pas',
  TaskUnit in 'EntityClasses\tasks\TaskUnit.pas',
  SummaryTaskCustomSettingsUnit in 'EntityClasses\summary\SummaryTaskCustomSettingsUnit.pas',
  SummaryTaskUnit in 'EntityClasses\summary\SummaryTaskUnit.pas',
  SummaryCXMTaskCustomSettingsEditFrameUnit in 'Forms\TasksFrames\SummaryCXMTaskCustomSettingsEditFrameUnit.pas' {SummaryCXMTaskCustomSettingsEditFrame: TUniFrame},
  SummarySynopTaskCustomSettingsEditFrameUnit in 'Forms\TasksFrames\SummarySynopTaskCustomSettingsEditFrameUnit.pas' {SummarySynopTaskCustomSettingsEditFrame: TUniFrame},
  SummaryHydraTaskCustomSettingsEditFrameUnit in 'Forms\TasksFrames\SummaryHydraTaskCustomSettingsEditFrameUnit.pas' {SummaryHydraTaskCustomSettingsEditFrame: TUniFrame},
  SummarySEBATaskCustomSettingsEditFrameUnit in 'Forms\TasksFrames\SummarySEBATaskCustomSettingsEditFrameUnit.pas' {SummarySEBATaskCustomSettingsEditFrame: TUniFrame};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  TUniServerModule.Create(Application);
  Application.Run;
end.
