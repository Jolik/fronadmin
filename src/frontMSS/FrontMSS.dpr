program FrontMSS;

uses
  Forms,
  ServerModule in 'ServerModule.pas' {UniServerModule: TUniGUIServerModule},
  MainModule in 'MainModule.pas' {UniMainModule: TUniGUIMainModule},
  Main in 'Main.pas' {MainForm: TUniForm},
  ChannelUnit in 'EntityClasses\ChannelUnit.pas',
  ChannelsBrokerUnit in 'APIClasses\ChannelsBrokerUnit.pas',
  FuncUnit in 'Common\FuncUnit.pas',
  ConstsUnit in 'Common\ConstsUnit.pas',
  ParentBrokerUnit in 'APIClasses\ParentBrokerUnit.pas',
  EntityUnit in 'EntityClasses\EntityUnit.pas',
  ParentFormUnit in 'Forms\ParentFormUnit.pas' {ParentForm: TUniForm},
  ListParentFormUnit in 'Forms\ListParentFormUnit.pas' {ListParentForm: TUniForm},
  ParentEditFormUnit in 'Forms\ParentEditFormUnit.pas' {ParentEditForm: TUniForm},
  ChannelsFormUnit in 'Forms\ChannelsFormUnit.pas' {ChannelsForm: TUniForm},
  ChannelEditFormUnit in 'Forms\ChannelEditFormUnit.pas' {ChannelEditForm: TUniForm},
  LinksBrokerUnit in 'APIClasses\LinksBrokerUnit.pas',
  QueuesBrokerUnit in 'APIClasses\QueuesBrokerUnit.pas',
  LinkUnit in 'EntityClasses\LinkUnit.pas',
  QueueUnit in 'EntityClasses\QueueUnit.pas',
  LinkSocketSpecialUnit in 'EntityClasses\links\LinkSocketSpecialUnit.pas',
  ConnectionUnit in 'EntityClasses\ConnectionUnit.pas',
  ScheduleUnit in 'EntityClasses\ScheduleUnit.pas',
  LoggingUnit in 'Logging\LoggingUnit.pas',
  TextFileLoggerUnit in 'Logging\TextFileLoggerUnit.pas',
  StripTasksFormUnit in 'Forms\StripTasksFormUnit.pas' {StripTasksForm: TUniForm},
  StripTaskEditFormUnit in 'Forms\StripTaskEditFormUnit.pas' {StripTaskEditForm: TUniForm},
  TaskUnit in 'EntityClasses\TaskUnit.pas',
  MonitoringTaskUnit in 'EntityClasses\MonitoringTaskUnit.pas',
  StripTaskUnit in 'EntityClasses\StripTaskUnit.pas',
  SummaryTaskUnit in 'EntityClasses\SummaryTaskUnit.pas',
  MonitoringTasksBrokerUnit in 'APIClasses\MonitoringTasksBrokerUnit.pas',
  StripTasksBrokerUnit in 'APIClasses\StripTasksBrokerUnit.pas',
  SummaryTasksBrokerUnit in 'APIClasses\SummaryTasksBrokerUnit.pas',
  TasksBrokerUnit in 'APIClasses\TasksBrokerUnit.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  TUniServerModule.Create(Application);
  Application.Run;
end.
