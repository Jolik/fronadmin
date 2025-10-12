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
  ChannelUnit in '..\EntityClasses\ChannelUnit.pas',
  EntityUnit in '..\EntityClasses\EntityUnit.pas',
  LinkUnit in '..\EntityClasses\LinkUnit.pas',
  QueueUnit in '..\EntityClasses\QueueUnit.pas',
  LinkSocketSpecialUnit in '..\EntityClasses\links\LinkSocketSpecialUnit.pas',
  ConnectionUnit in '..\EntityClasses\ConnectionUnit.pas',
  CommParsersUnit in '..\Parsers\CommParsersUnit.pas',
  ScheduleUnit in '..\EntityClasses\ScheduleUnit.pas',
  SocketSpecialLinkParserUnit in '..\Parsers\SocketSpecialLinkParserUnit.pas',
  LoggingUnit in '..\Logging\LoggingUnit.pas',
  TextFileLoggerUnit in '..\Logging\TextFileLoggerUnit.pas',
  StripTaskUnit in '..\EntityClasses\StripTaskUnit.pas',
  StripTasksBrokerUnit in '..\APIClasses\StripTasksBrokerUnit.pas',
  SummaryTaskUnit in '..\EntityClasses\SummaryTaskUnit.pas',
  SummaryTasksBrokerUnit in '..\APIClasses\SummaryTasksBrokerUnit.pas',
  EntityParsersUnit in '..\Parsers\EntityParsersUnit.pas',
  TaskUnit in '..\EntityClasses\TaskUnit.pas',
  TasksBrokerUnit in '..\APIClasses\TasksBrokerUnit.pas',
  MonitoringTasksBrokerUnit in '..\APIClasses\MonitoringTasksBrokerUnit.pas',
  MonitoringTaskUnit in '..\EntityClasses\MonitoringTaskUnit.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  TUniServerModule.Create(Application);
  Application.Run;
end.
