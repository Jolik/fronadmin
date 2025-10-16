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
  AliasEditFormUnit in 'Forms\AliasEditFormUnit.pas' {AliasEditForm: TUniForm},
  AliasesFormUnit in 'Forms\AliasesFormUnit.pas' {AliasesForm: TUniForm},
  RouterSourceEditFormUnit in 'Forms\RouterSourceEditFormUnit.pas' {RouterSourceEditForm: TUniForm},
  RouterSourcesFormUnit in 'Forms\RouterSourcesFormUnit.pas' {RouterSourcesForm: TUniForm},
  APIConst in 'APIClasses\APIConst.pas',
  ChannelsBrokerUnit in 'APIClasses\ChannelsBrokerUnit.pas',
  LinksBrokerUnit in 'APIClasses\LinksBrokerUnit.pas',
  MonitoringTasksBrokerUnit in 'APIClasses\MonitoringTasksBrokerUnit.pas',
  ParentBrokerUnit in 'APIClasses\ParentBrokerUnit.pas',
  QueuesBrokerUnit in 'APIClasses\QueuesBrokerUnit.pas',
  RouterSourceBrokerUnit in 'APIClasses\RouterSourceBrokerUnit.pas',
  AliasesBrokerUnit in 'APIClasses\AliasesBrokerUnit.pas',
  StripTasksBrokerUnit in 'APIClasses\StripTasksBrokerUnit.pas',
  SummaryTasksBrokerUnit in 'APIClasses\SummaryTasksBrokerUnit.pas',
  TasksBrokerUnit in 'APIClasses\TasksBrokerUnit.pas',
  EntityUnit in 'EntityClasses\Common\EntityUnit.pas',
  TaskUnit in 'EntityClasses\Common\TaskUnit.pas',
  MonitoringTaskUnit in 'EntityClasses\monitoring\MonitoringTaskUnit.pas',
  StripTaskUnit in 'EntityClasses\strips\StripTaskUnit.pas',
  SummaryTaskUnit in 'EntityClasses\summary\SummaryTaskUnit.pas',
  ChannelUnit in 'EntityClasses\router\ChannelUnit.pas',
  AliasUnit in 'EntityClasses\router\AliasUnit.pas',
  QueueUnit in 'EntityClasses\router\QueueUnit.pas',
  RouterSourceUnit in 'EntityClasses\router\RouterSourceUnit.pas',
  MainHttpModuleUnit in 'APIClasses\MainHttpModuleUnit.pas',
  LinksFormUnit in 'Forms\LinksFormUnit.pas' {LinksForm: TUniForm},
  LinkEditFormUnit in 'Forms\LinkEditFormUnit.pas' {LinkEditForm: TUniForm},
  ParentLinkSettingEditFrameUnit in 'Forms\LinksFrames\ParentLinkSettingEditFrameUnit.pas' {ParentLinkSettingEditFrame: TUniFrame},
  ConnectionSettingsUnit in 'EntityClasses\links\ConnectionSettingsUnit.pas',
  DirSettingsUnit in 'EntityClasses\links\DirSettingsUnit.pas',
  LinkSettingsUnit in 'EntityClasses\links\LinkSettingsUnit.pas',
  LinkUnit in 'EntityClasses\links\LinkUnit.pas',
  QueueSettingsUnit in 'EntityClasses\links\QueueSettingsUnit.pas',
  ScheduleSettingsUnit in 'EntityClasses\links\ScheduleSettingsUnit.pas',
  SummaryTaskEditFormUnit in 'Forms\SummaryTaskEditFormUnit.pas',
  SummaryTasksFormUnit in 'Forms\SummaryTasksFormUnit.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  TUniServerModule.Create(Application);
  Application.Run;
end.
