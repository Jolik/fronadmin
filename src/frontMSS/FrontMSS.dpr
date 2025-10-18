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
  AliasEditFormUnit in 'Forms\AliasEditFormUnit.pas' {AliasEditForm: TUniForm},
  AliasesFormUnit in 'Forms\AliasesFormUnit.pas' {AliasesForm: TUniForm},
  AbonentEditFormUnit in 'Forms\AbonentEditFormUnit.pas' {AbonentEditForm: TUniForm},
  AbonentsFormUnit in 'Forms\AbonentsFormUnit.pas' {AbonentsForm: TUniForm},
  APIConst in 'APIClasses\APIConst.pas',
  AbonentsBrokerUnit in 'APIClasses\AbonentsBrokerUnit.pas',
  AliasesBrokerUnit in 'APIClasses\AliasesBrokerUnit.pas',
  AliasUnit in 'EntityClasses\router\AliasUnit.pas',
  AbonentUnit in 'EntityClasses\router\AbonentUnit.pas',
  EntityBrokerUnit in 'APIClasses\EntityBrokerUnit.pas',
  EntityUnit in 'EntityClasses\Common\EntityUnit.pas',
  GUIDListUnit in 'EntityClasses\Common\GUIDListUnit.pas',
  StringUnit in 'EntityClasses\Common\StringUnit.pas',
  ConstsUnit in 'Common\ConstsUnit.pas',
  FuncUnit in 'Common\FuncUnit.pas',
  MainHttpModuleUnit in 'APIClasses\MainHttpModuleUnit.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  TUniServerModule.Create(Application);
  Application.Run;
end.
