program BrokerTest;

uses
  Forms,
  ServerModule in 'ServerModule.pas' {UniServerModule: TUniGUIServerModule},
  MainModule in 'MainModule.pas' {UniMainModule: TUniGUIMainModule},
  Main in 'Main.pas' {MainForm: TUniForm},
  ConstsUnit in '..\Common\ConstsUnit.pas',
  FuncUnit in '..\Common\FuncUnit.pas',
  ChannelsBrokerUnit in '..\APIClasses\ChannelsBrokerUnit.pas',
  LinksBrokerUnit in '..\APIClasses\LinksBrokerUnit.pas',
  ParentBrokerUnit in '..\APIClasses\ParentBrokerUnit.pas',
  QueuesBrokerUnit in '..\APIClasses\QueuesBrokerUnit.pas',
  ChannelUnit in '..\EntityClasses\router\ChannelUnit.pas',
  EntityUnit in '..\EntityClasses\Common\EntityUnit.pas',
  LinkUnit in '..\EntityClasses\links\LinkUnit.pas',
  QueueUnit in '..\EntityClasses\router\QueueUnit.pas',
  ConnectionUnit in '..\EntityClasses\Common\ConnectionUnit.pas',
  ScheduleUnit in '..\EntityClasses\Common\ScheduleUnit.pas',
  LoggingUnit in '..\Logging\LoggingUnit.pas',
  TextFileLoggerUnit in '..\Logging\TextFileLoggerUnit.pas',
  StripTaskUnit in '..\EntityClasses\strips\StripTaskUnit.pas',
  StripTasksBrokerUnit in '..\APIClasses\StripTasksBrokerUnit.pas',
  SummaryTaskUnit in '..\EntityClasses\summary\SummaryTaskUnit.pas',
  SummaryTasksBrokerUnit in '..\APIClasses\SummaryTasksBrokerUnit.pas',
  TaskUnit in '..\EntityClasses\Common\TaskUnit.pas',
  TasksBrokerUnit in '..\APIClasses\TasksBrokerUnit.pas',
  MonitoringTasksBrokerUnit in '..\APIClasses\MonitoringTasksBrokerUnit.pas',
  MonitoringTaskUnit in '..\EntityClasses\monitoring\MonitoringTaskUnit.pas',
  APIConst in '..\APIClasses\APIConst.pas',
  LinkSettingsUnit in '..\EntityClasses\links\LinkSettingsUnit.pas',
  UniLoggerUnit in '..\Logging\UniLoggerUnit.pas',
  QueueSettingsUnit in '..\EntityClasses\Common\QueueSettingsUnit.pas',
  RouterSourceUnit in '..\EntityClasses\router\RouterSourceUnit.pas',
  RouterSourceBrokerUnit in '..\APIClasses\RouterSourceBrokerUnit.pas',
  MainHttpModuleUnit in '..\APIClasses\MainHttpModuleUnit.pas',
  ParentFormUnit in '..\Forms\ParentFormUnit.pas' {ParentForm: TUniForm},
  ParentEditFormUnit in '..\Forms\ParentEditFormUnit.pas' {ParentEditForm: TUniForm},
  ListParentFormUnit in '..\Forms\ListParentFormUnit.pas' {ListParentForm: TUniForm},
  StripTaskEditFormUnit in '..\Forms\StripTaskEditFormUnit.pas' {StripTaskEditForm: TUniForm},
  StripTasksFormUnit in '..\Forms\StripTasksFormUnit.pas' {StripTasksForm: TUniForm},
  QueueSettingsUnit in '..\EntityClasses\links\QueueSettingsUnit.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  TUniServerModule.Create(Application);
  Application.Run;
end.
