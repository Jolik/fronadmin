program EntityTestProj;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  APIConst in '..\APIClasses\APIConst.pas',
  ChannelsBrokerUnit in '..\APIClasses\ChannelsBrokerUnit.pas',
  LinksBrokerUnit in '..\APIClasses\LinksBrokerUnit.pas',
  MainHttpModuleUnit in '..\APIClasses\MainHttpModuleUnit.pas',
  MonitoringTasksBrokerUnit in '..\APIClasses\MonitoringTasksBrokerUnit.pas',
  ParentBrokerUnit in '..\APIClasses\ParentBrokerUnit.pas',
  QueuesBrokerUnit in '..\APIClasses\QueuesBrokerUnit.pas',
  RouterSourceBrokerUnit in '..\APIClasses\RouterSourceBrokerUnit.pas',
  StripTasksBrokerUnit in '..\APIClasses\StripTasksBrokerUnit.pas',
  SummaryTasksBrokerUnit in '..\APIClasses\SummaryTasksBrokerUnit.pas',
  TasksBrokerUnit in '..\APIClasses\TasksBrokerUnit.pas',
  LoggingUnit in '..\Logging\LoggingUnit.pas',
  TextFileLoggerUnit in '..\Logging\TextFileLoggerUnit.pas',
  ConstsUnit in '..\Common\ConstsUnit.pas',
  FuncUnit in '..\Common\FuncUnit.pas',
  ConnectionUnit in '..\EntityClasses\Common\ConnectionUnit.pas',
  EntityUnit in '..\EntityClasses\Common\EntityUnit.pas',
  ScheduleUnit in '..\EntityClasses\Common\ScheduleUnit.pas',
  TaskUnit in '..\EntityClasses\Common\TaskUnit.pas',
  LinkSettingsUnit in '..\EntityClasses\links\LinkSettingsUnit.pas',
  LinkUnit in '..\EntityClasses\links\LinkUnit.pas',
  MonitoringTaskUnit in '..\EntityClasses\monitoring\MonitoringTaskUnit.pas',
  ChannelUnit in '..\EntityClasses\router\ChannelUnit.pas',
  QueueUnit in '..\EntityClasses\router\QueueUnit.pas',
  RouterSourceUnit in '..\EntityClasses\router\RouterSourceUnit.pas',
  StripTaskUnit in '..\EntityClasses\strips\StripTaskUnit.pas',
  SummaryTaskUnit in '..\EntityClasses\summary\SummaryTaskUnit.pas';

var
  Body, Response: string;

procedure List(BrokerType: TParentBrokerClass);
var
  Broker : TParentBroker;
  Entity : TEntity;
  EntityList : TEntityList;
  Pages : integer;

begin
  try
    Broker := BrokerType.Create();

    EntityList := Broker.List(Pages);

    writeln('----------  List  ----------');
    writeln('List test:');

    for Entity in EntityList do
    begin
      writeln(Format('ClassName: %s  |  Àäðåñ: %p', [Entity.ClassName, Pointer(Entity)]));
      writeln('Id '+ Entity.Id);
      writeln('Name '+ Entity.Name);
      writeln('Caption '+ Entity.Caption);
      writeln('Compid '+ (Entity.Compid));
      writeln('Depid '+ (Entity.Depid));

      writeln('as json:');

      var json := Entity.Serialize();

      if json <> nil then
        writeln(json.Format());

      writeln('----------');
    end;

  finally
    EntityList.Free;
    Broker.Free;
  end;
end;

begin
  try
    try
      List(TRouterSourceBroker);

      // оставить консоль незакрытой до нажатия Enter
      Writeln('press enter to finish...');
      Readln;

    except
      on E: Exception do
        Writeln(E.ClassName, ': ', E.Message);
    end;

  finally
  end;
end.
