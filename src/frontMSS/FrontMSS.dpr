program FrontMSS;

uses
  Forms,
  ServerModule in 'ServerModule.pas' {UniServerModule: TUniGUIServerModule},
  MainModule in 'MainModule.pas' {UniMainModule: TUniGUIMainModule},
  Main in 'Main.pas' {MainForm: TUniForm},
  FuncUnit in 'Common\FuncUnit.pas',
  ConstsUnit in 'Common\ConstsUnit.pas',
  LoggingUnit in 'Logging\LoggingUnit.pas',
  TextFileLoggerUnit in 'Logging\TextFileLoggerUnit.pas',
  ChannelEditFormUnit in 'Forms\ChannelEditFormUnit.pas' {ChannelEditForm: TUniForm},
  ChannelsFormUnit in 'Forms\ChannelsFormUnit.pas' {ChannelsForm: TUniForm},
  ListParentFormUnit in 'Forms\ListParentFormUnit.pas' {ListParentForm: TUniForm},
  ParentEditFormUnit in 'Forms\ParentEditFormUnit.pas' {ParentEditForm: TUniForm},
  ParentFormUnit in 'Forms\ParentFormUnit.pas' {ParentForm: TUniForm},
  StripTaskEditFormUnit in 'Forms\StripTaskEditFormUnit.pas' {StripTaskEditForm: TUniForm},
  StripTasksFormUnit in 'Forms\StripTasksFormUnit.pas' {StripTasksForm: TUniForm},
  APIConst in 'APIClasses\APIConst.pas',
  ChannelsBrokerUnit in 'APIClasses\ChannelsBrokerUnit.pas',
  LinksBrokerUnit in 'APIClasses\LinksBrokerUnit.pas',
  MonitoringTasksBrokerUnit in 'APIClasses\MonitoringTasksBrokerUnit.pas',
  ParentBrokerUnit in 'APIClasses\ParentBrokerUnit.pas',
  QueuesBrokerUnit in 'APIClasses\QueuesBrokerUnit.pas',
  RouterSourceBrokerUnit in 'APIClasses\RouterSourceBrokerUnit.pas',
  StripTasksBrokerUnit in 'APIClasses\StripTasksBrokerUnit.pas',
  SummaryTasksBrokerUnit in 'APIClasses\SummaryTasksBrokerUnit.pas',
  TasksBrokerUnit in 'APIClasses\TasksBrokerUnit.pas',
  ConnectionUnit in 'EntityClasses\Common\ConnectionUnit.pas',
  EntityUnit in 'EntityClasses\Common\EntityUnit.pas',
  ScheduleUnit in 'EntityClasses\Common\ScheduleUnit.pas',
  TaskUnit in 'EntityClasses\Common\TaskUnit.pas',
  MonitoringTaskUnit in 'EntityClasses\monitoring\MonitoringTaskUnit.pas',
  StripTaskUnit in 'EntityClasses\strips\StripTaskUnit.pas',
  SummaryTaskUnit in 'EntityClasses\summary\SummaryTaskUnit.pas',
  ChannelUnit in 'EntityClasses\router\ChannelUnit.pas',
  QueueUnit in 'EntityClasses\router\QueueUnit.pas',
  RouterSourceUnit in 'EntityClasses\router\RouterSourceUnit.pas',
  LinkSettingsUnit in 'EntityClasses\links\LinkSettingsUnit.pas',
  LinkUnit in 'EntityClasses\links\LinkUnit.pas',
  MainHttpModuleUnit in 'APIClasses\MainHttpModuleUnit.pas',
  ParentChannelSettingEditFrameUnit in 'Forms\ChannelFrames\ParentChannelSettingEditFrameUnit.pas' {ParentChannelSettingEditFrame: TUniFrame},
  QueueSettingsUnit in 'EntityClasses\links\QueueSettingsUnit.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  TUniServerModule.Create(Application);
  Application.Run;
end.
