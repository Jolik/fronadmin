program EntityTestProj;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.JSON,
  System.DateUtils,
  IdURI,
  APIConst in '..\APIClasses\APIConst.pas',
  ChannelsBrokerUnit in '..\APIClasses\ChannelsBrokerUnit.pas',
  AbonensBrokerUnit in '..\APIClasses\AbonensBrokerUnit.pas',
  LinksBrokerUnit in '..\APIClasses\LinksBrokerUnit.pas',
  ProfilesBrokerUnit in '..\APIClasses\ProfilesBrokerUnit.pas',
  MainHttpModuleUnit in '..\APIClasses\MainHttpModuleUnit.pas',
  MonitoringTasksBrokerUnit in '..\APIClasses\MonitoringTasksBrokerUnit.pas',
  EntityBrokerUnit in '..\APIClasses\EntityBrokerUnit.pas',
  QueuesBrokerUnit in '..\APIClasses\QueuesBrokerUnit.pas',
  AliasesBrokerUnit in '..\APIClasses\AliasesBrokerUnit.pas',
  RulesBrokerUnit in '..\APIClasses\RulesBrokerUnit.pas',
  UsersBrokerUnit in '..\APIClasses\UsersBrokerUnit.pas',
  SourceCredsBrokerUnit in '..\APIClasses\SourceCredsBrokerUnit.pas',
  ContextsBrokerUnit in '..\APIClasses\ContextsBrokerUnit.pas',
  ContextTypesBrokerUnit in '..\APIClasses\ContextTypesBrokerUnit.pas',
  SourceTypesBrokerUnit in '..\APIClasses\SourceTypesBrokerUnit.pas',
  BindingsBrokerUnit in '..\APIClasses\BindingsBrokerUnit.pas',
  DsGroupsBrokerUnit in '..\APIClasses\DsGroupsBrokerUnit.pas',
  RouterSourceBrokerUnit in '..\APIClasses\RouterSourceBrokerUnit.pas',
  DSProcessorTasksBrokerUnit in '..\APIClasses\DSProcessorTasksBrokerUnit.pas',
  StripTasksBrokerUnit in '..\APIClasses\StripTasksBrokerUnit.pas',
  SummaryTasksBrokerUnit in '..\APIClasses\SummaryTasksBrokerUnit.pas',
  TaskTypesBrokerUnit in '..\APIClasses\TaskTypesBrokerUnit.pas',
  TasksBrokerUnit in '..\APIClasses\TasksBrokerUnit.pas',
  TaskSourcesBrokerUnit in '..\APIClasses\TaskSourcesBrokerUnit.pas',
  DSProcessorTaskSourceBrokerUnit in '..\APIClasses\DSProcessorTaskSourceBrokerUnit.pas',
  StripTaskSourceBrokerUnit in '..\APIClasses\StripTaskSourceBrokerUnit.pas',
  SummaryTaskSourcesBrokerUnit in '..\APIClasses\SummaryTaskSourcesBrokerUnit.pas',
  MonitoringTaskSourceBrokerUnit in '..\APIClasses\MonitoringTaskSourceBrokerUnit.pas',
  LoggingUnit in '..\Logging\LoggingUnit.pas',
  TextFileLoggerUnit in '..\Logging\TextFileLoggerUnit.pas',
  ConstsUnit in '..\Common\ConstsUnit.pas',
  FuncUnit in '..\Common\FuncUnit.pas',
  LinkSettingsUnit in '..\EntityClasses\links\LinkSettingsUnit.pas',
  LinkUnit in '..\EntityClasses\links\LinkUnit.pas',
  MonitoringTaskUnit in '..\EntityClasses\monitoring\MonitoringTaskUnit.pas',
  ChannelUnit in '..\EntityClasses\router\ChannelUnit.pas',
  AbonentUnit in '..\EntityClasses\router\AbonentUnit.pas',
  QueueUnit in '..\EntityClasses\router\QueueUnit.pas',
  AliasUnit in '..\EntityClasses\router\AliasUnit.pas',
  RuleUnit in '..\EntityClasses\router\RuleUnit.pas',
  RouterSourceUnit in '..\EntityClasses\router\RouterSourceUnit.pas',
  UserUnit in '..\EntityClasses\acl\UserUnit.pas',
  SourceCredsUnit in '..\EntityClasses\dataserver\SourceCredsUnit.pas',
  ContextUnit in '..\EntityClasses\dataserver\ContextUnit.pas',
  ContextTypeUnit in '..\EntityClasses\dataserver\ContextTypeUnit.pas',
  SourceTypeUnit in '..\EntityClasses\dataserver\SourceTypeUnit.pas',
  DsGroupUnit in '..\EntityClasses\dataserver\DsGroupUnit.pas',
  DSProcessorTaskUnit in '..\EntityClasses\dsprocessor\DSProcessorTaskUnit.pas',
  StripTaskUnit in '..\EntityClasses\strips\StripTaskUnit.pas',
  SummaryTaskUnit in '..\EntityClasses\summary\SummaryTaskUnit.pas',
  DataserieUnit in '..\EntityClasses\dataserver\DataserieUnit.pas',
  BindingUnit in '..\EntityClasses\dataserver\BindingUnit.pas',
  QueueSettingsUnit in '..\EntityClasses\links\QueueSettingsUnit.pas',
  SmallRuleUnit in '..\EntityClasses\router\SmallRuleUnit.pas',
  ProfileUnit in '..\EntityClasses\datacomm\ProfileUnit.pas',
  ConnectionSettingsUnit in '..\EntityClasses\links\ConnectionSettingsUnit.pas',
  DirSettingsUnit in '..\EntityClasses\links\DirSettingsUnit.pas',
  ScheduleSettingsUnit in '..\EntityClasses\links\ScheduleSettingsUnit.pas',
  FieldSetBrokerUnit in '..\APIClasses\FieldSetBrokerUnit.pas',
  LogUnit in '..\EntityClasses\signals\LogUnit.pas',
  S3SettingsUnit in '..\EntityClasses\links\S3SettingsUnit.pas',
  KeyValUnit in '..\Common\KeyValUnit.pas',
  SummaryTaskCustomSettingsUnit in '..\EntityClasses\summary\SummaryTaskCustomSettingsUnit.pas',
  ConditionUnit in '..\EntityClasses\Common\ConditionUnit.pas',
  EntityUnit in '..\EntityClasses\Common\EntityUnit.pas',
  FilterUnit in '..\EntityClasses\Common\FilterUnit.pas',
  GeoTypeUnit in '..\EntityClasses\Common\GeoTypeUnit.pas',
  GUIDListUnit in '..\EntityClasses\Common\GUIDListUnit.pas',
  StringListUnit in '..\EntityClasses\Common\StringListUnit.pas',
  StringUnit in '..\EntityClasses\Common\StringUnit.pas',
  TaskSettingsUnit in '..\EntityClasses\Common\TaskSettingsUnit.pas',
  TaskSourceUnit in '..\EntityClasses\Common\TaskSourceUnit.pas',
  TaskTypesUnit in '..\EntityClasses\Common\TaskTypesUnit.pas',
  TaskUnit in '..\EntityClasses\Common\TaskUnit.pas';

procedure ListSummaryTaskTypes();
var
  TaskTypesBroker: TTaskTypesBroker;
  TaskTypesList: TFieldSetList;
  PageCount: Integer;
begin
  try
    TaskTypesBroker := TTaskTypesBroker.Create;
    try
      TaskTypesList := nil;
      try
        TaskTypesList := TaskTypesBroker.List(PageCount);

        Writeln('---------- Summary Task Types ----------');

        if Assigned(TaskTypesList) and (TaskTypesList.Count > 0) then
        begin
          for var FieldSet: TFieldSet in TaskTypesList do
          begin
            if not (FieldSet is TTaskTypes) then
              Continue;

            var TaskType := TTaskTypes(FieldSet);
            Writeln(Format('Class: %s | Address: %p', [TaskType.ClassName, Pointer(TaskType)]));
            Writeln('Name: ' + TaskType.Name);
            Writeln('Caption: ' + TaskType.Caption);

            Writeln('As JSON:');
            var Json := TaskType.Serialize();
            try
              if Json <> nil then
                Writeln(Json.Format);
            finally
              Json.Free;
            end;

            Writeln('----------');
          end;
        end
        else
          Writeln('Summary task types list is empty.');

      finally
        TaskTypesList.Free;
      end;
    finally
      TaskTypesBroker.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;

procedure ListSummaryTasks();
var
  SummaryTasksBroker: TSummaryTasksBroker;
  SummaryTaskList: TEntityList;
  SummaryTaskEntity: TEntity;
  PageCount: Integer;
begin
  try
    SummaryTasksBroker := TSummaryTasksBroker.Create;
    try
      SummaryTaskList := nil;
      try
        SummaryTaskList := SummaryTasksBroker.List(PageCount);

        Writeln('---------- Summary Tasks List ----------');

        if Assigned(SummaryTaskList) then
        begin
          var FirstSummaryTask: TSummaryTask := nil;

          if SummaryTaskList.Count > 0 then
            FirstSummaryTask := SummaryTaskList.Items[0] as TSummaryTask;

          for SummaryTaskEntity in SummaryTaskList do
          begin
            var SummaryTask := SummaryTaskEntity as TSummaryTask;
            Writeln(Format('Class: %s | Address: %p', [SummaryTask.ClassName, Pointer(SummaryTask)]));
            Writeln('Tid: ' + SummaryTask.Tid);
            Writeln('Name: ' + SummaryTask.Name);
            Writeln('Module: ' + SummaryTask.Module);
            Writeln('Enabled: ' + BoolToStr(SummaryTask.Enabled, True));

            if SummaryTask.Settings is TSummaryTaskSettings then
            begin
              var Settings := TSummaryTaskSettings(SummaryTask.Settings);
              Writeln('LatePeriod: ' + IntToStr(Settings.LatePeriod));
              Writeln('LateEvery: ' + IntToStr(Settings.LateEvery));
              Writeln('MonthDays: ' + Settings.MonthDays);
              Writeln('Header: ' + Settings.Header);
              Writeln('Header2: ' + Settings.Header2);
              Writeln('HeaderCorr: ' + IntToStr(Settings.HeaderCorr));
              Writeln('Local: ' + BoolToStr(Settings.Local, True));
              Writeln('CheckLate: ' + BoolToStr(Settings.CheckLate, True));
              Writeln('Time: ' + Settings.Time);

              var ExcludeWeekText := '';
              for var i := 0 to Length(Settings.ExcludeWeek) - 1 do
              begin
                if i > 0 then
                  ExcludeWeekText := ExcludeWeekText + ',';
                ExcludeWeekText := ExcludeWeekText + IntToStr(Settings.ExcludeWeek[i]);
              end;
              Writeln('ExcludeWeek: ' + ExcludeWeekText);

              if Assigned(Settings.TaskCustomSettings) then
                Writeln('Custom settings class: ' + Settings.TaskCustomSettings.ClassName);
            end;

            Writeln('As JSON:');
            var TaskJson := SummaryTask.Serialize();
            try
              if TaskJson <> nil then
                Writeln(TaskJson.Format);
            finally
              TaskJson.Free;
            end;

            Writeln('----------');
          end;

          if Assigned(FirstSummaryTask) then
          begin
            Writeln('---------- Summary Task Info ----------');
            Writeln('Requesting info for: ' + FirstSummaryTask.Tid);

            var InfoEntity: TEntity := nil;
            try
              InfoEntity := SummaryTasksBroker.Info(FirstSummaryTask.Tid);

              if Assigned(InfoEntity) then
              begin
                var InfoTask := InfoEntity as TSummaryTask;
                Writeln('Info result as JSON:');
                var InfoJson := InfoTask.Serialize();
                try
                  if InfoJson <> nil then
                    Writeln(InfoJson.Format);
                finally
                  InfoJson.Free;
                end;
              end
              else
                Writeln('Info request returned nil.');
            finally
              InfoEntity.Free;
            end;

            Writeln('----------');
          end;
        end
        else
          Writeln('Summary tasks list is empty.');

      finally
        SummaryTaskList.Free;
      end;
    finally
      SummaryTasksBroker.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;

procedure ListDSProcessorTasks();
var
  DSProcessorTasksBroker: TDSProcessorTasksBroker;
  DSProcessorTaskList: TEntityList;
  DSProcessorTaskEntity: TEntity;
  PageCount: Integer;
begin
  try
    DSProcessorTasksBroker := TDSProcessorTasksBroker.Create;
    try
      DSProcessorTaskList := nil;
      try
        DSProcessorTaskList := DSProcessorTasksBroker.List(PageCount);

        Writeln('---------- DSProcessor Tasks List ----------');

        if Assigned(DSProcessorTaskList) then
        begin
          var FirstDSProcessorTask: TDSProcessorTask := nil;

          if DSProcessorTaskList.Count > 0 then
            FirstDSProcessorTask := DSProcessorTaskList.Items[0] as TDSProcessorTask;

          for DSProcessorTaskEntity in DSProcessorTaskList do
          begin
            var DSProcessorTask := DSProcessorTaskEntity as TDSProcessorTask;
            Writeln(Format('Class: %s | Address: %p', [DSProcessorTask.ClassName, Pointer(DSProcessorTask)]));
            Writeln('Tid: ' + DSProcessorTask.Tid);
            Writeln('Name: ' + DSProcessorTask.Name);
            Writeln('Module: ' + DSProcessorTask.Module);
            Writeln('Enabled: ' + BoolToStr(DSProcessorTask.Enabled, True));

            Writeln('As JSON:');
            var TaskJson := DSProcessorTask.Serialize();
            try
              if TaskJson <> nil then
                Writeln(TaskJson.Format);
            finally
              TaskJson.Free;
            end;

            Writeln('----------');
          end;

          if Assigned(FirstDSProcessorTask) then
          begin
            Writeln('---------- DSProcessor Task Info ----------');
            Writeln('Requesting info for: ' + FirstDSProcessorTask.Tid);

            var InfoEntity: TEntity := nil;
            try
              InfoEntity := DSProcessorTasksBroker.Info(FirstDSProcessorTask.Tid);

              if Assigned(InfoEntity) then
              begin
                var InfoTask := InfoEntity as TDSProcessorTask;
                Writeln('Info result as JSON:');
                var InfoJson := InfoTask.Serialize();
                try
                  if InfoJson <> nil then
                    Writeln(InfoJson.Format);
                finally
                  InfoJson.Free;
                end;
              end
              else
                Writeln('Info request returned nil.');
            finally
              InfoEntity.Free;
            end;

            Writeln('----------');
          end;
        end
        else
          Writeln('DSProcessor tasks list is empty.');

      finally
        DSProcessorTaskList.Free;
      end;
    finally
      DSProcessorTasksBroker.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;

procedure ListStripTaskSources();
var
  StripTasksBroker: TStripTasksBroker;
  StripTaskSourcesBroker: TStripTaskSourcesBroker;
  StripTaskList: TEntityList;
  StripTaskEntity: TEntity;
  TaskSourceList: TEntityList;
  TaskSourceEntity: TEntity;
  StripTaskPageCount: Integer;
  TaskSourcePageCount: Integer;
  FirstStripTaskTid: string;
begin
  try
    StripTasksBroker := TStripTasksBroker.Create;
    try
      StripTaskList := nil;
      FirstStripTaskTid := '';
      try
        StripTaskList := StripTasksBroker.List(StripTaskPageCount);

        Writeln('---------- Strip Tasks List ----------');

        if Assigned(StripTaskList) and (StripTaskList.Count > 0) then
        begin
          for StripTaskEntity in StripTaskList do
          begin
            var StripTask := StripTaskEntity as TStripTask;
            Writeln(Format('Class: %s | Address: %p', [StripTask.ClassName, Pointer(StripTask)]));
            Writeln('Tid: ' + StripTask.Tid);
            Writeln('Name: ' + StripTask.Name);
            Writeln('Enabled: ' + BoolToStr(StripTask.Enabled, True));

            Writeln('As JSON:');
            var TaskJson := StripTask.Serialize();
            try
              if TaskJson <> nil then
                Writeln(TaskJson.Format);
            finally
              TaskJson.Free;
            end;

            Writeln('----------');
          end;

          FirstStripTaskTid := (StripTaskList.Items[0] as TStripTask).Tid;
        end
        else
          Writeln('Strip tasks list is empty.');

      finally
        StripTaskList.Free;
      end;
    finally
      StripTasksBroker.Free;
    end;

    if FirstStripTaskTid = '' then
    begin
      Writeln('No strip task available to request strip task sources.');
      Exit;
    end;

    StripTaskSourcesBroker := TStripTaskSourcesBroker.Create;
    try
      StripTaskSourcesBroker.AddPath := '/' + FirstStripTaskTid;

      TaskSourceList := nil;
      try
        TaskSourceList := StripTaskSourcesBroker.List(TaskSourcePageCount);

        Writeln('---------- Strip Task Sources List ----------');

        if Assigned(TaskSourceList) then
        begin
          var FirstSource: TTaskSource := nil;

          if TaskSourceList.Count > 0 then
            FirstSource := TaskSourceList.Items[0] as TTaskSource;

          for TaskSourceEntity in TaskSourceList do
          begin
            var Source := TaskSourceEntity as TTaskSource;
            Writeln(Format('Class: %s | Address: %p', [Source.ClassName, Pointer(Source)]));
            Writeln('Sid: ' + Source.Sid);
            Writeln('Name: ' + Source.Name);
            Writeln('Enabled: ' + BoolToStr(Source.Enabled, True));
            Writeln('Index: ' + Source.StationIndex);

            Writeln('As JSON:');
            var Json := Source.Serialize();
            try
              if Json <> nil then
                Writeln(Json.Format);
            finally
              Json.Free;
            end;

            Writeln('----------');
          end;

          if Assigned(FirstSource) then
          begin
            Writeln('---------- Strip Task Source Info ----------');
            Writeln('Requesting info for: ' + FirstSource.Sid);

            var InfoEntity: TEntity := nil;
            try
              InfoEntity := StripTaskSourcesBroker.Info(FirstSource.Sid);

              if Assigned(InfoEntity) then
              begin
                var InfoSource := InfoEntity as TTaskSource;
                Writeln('Info result as JSON:');
                var InfoJson := InfoSource.Serialize();
                try
                  if InfoJson <> nil then
                    Writeln(InfoJson.Format);
                finally
                  InfoJson.Free;
                end;
              end
              else
                Writeln('Info request returned nil.');
            finally
              InfoEntity.Free;
            end;
            Writeln('----------');
          end;
        end
        else
          Writeln('Strip task sources list is empty.');

      finally
        TaskSourceList.Free;
      end;
    finally
      StripTaskSourcesBroker.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;

procedure ListDSProcessorTaskSources();
var
  DSProcessorTasksBroker: TDSProcessorTasksBroker;
  DSProcessorTaskSourcesBroker: TDSProcessorTaskSourcesBroker;
  DSProcessorTaskList: TEntityList;
  DSProcessorTaskEntity: TEntity;
  TaskSourceList: TEntityList;
  TaskSourceEntity: TEntity;
  DSProcessorTaskPageCount: Integer;
  TaskSourcePageCount: Integer;
  FirstDSProcessorTaskTid: string;
begin
  try
    DSProcessorTasksBroker := TDSProcessorTasksBroker.Create;
    try
      DSProcessorTaskList := nil;
      FirstDSProcessorTaskTid := '';
      try
        DSProcessorTaskList := DSProcessorTasksBroker.List(DSProcessorTaskPageCount);

        Writeln('---------- DSProcessor Tasks List ----------');

        if Assigned(DSProcessorTaskList) and (DSProcessorTaskList.Count > 0) then
        begin
          for DSProcessorTaskEntity in DSProcessorTaskList do
          begin
            var DSProcessorTask := DSProcessorTaskEntity as TDSProcessorTask;
            Writeln(Format('Class: %s | Address: %p', [DSProcessorTask.ClassName, Pointer(DSProcessorTask)]));
            Writeln('Tid: ' + DSProcessorTask.Tid);
            Writeln('Name: ' + DSProcessorTask.Name);
            Writeln('Enabled: ' + BoolToStr(DSProcessorTask.Enabled, True));

            Writeln('As JSON:');
            var TaskJson := DSProcessorTask.Serialize();
            try
              if TaskJson <> nil then
                Writeln(TaskJson.Format);
            finally
              TaskJson.Free;
            end;

            Writeln('----------');
          end;

          FirstDSProcessorTaskTid := (DSProcessorTaskList.Items[0] as TDSProcessorTask).Tid;
        end
        else
          Writeln('DSProcessor tasks list is empty.');

      finally
        DSProcessorTaskList.Free;
      end;
    finally
      DSProcessorTasksBroker.Free;
    end;

    if FirstDSProcessorTaskTid = '' then
    begin
      Writeln('No DSProcessor task available to request DSProcessor task sources.');
      Exit;
    end;

    DSProcessorTaskSourcesBroker := TDSProcessorTaskSourcesBroker.Create;
    try
      DSProcessorTaskSourcesBroker.AddPath := '/' + FirstDSProcessorTaskTid;

      TaskSourceList := nil;
      try
        TaskSourceList := DSProcessorTaskSourcesBroker.List(TaskSourcePageCount);

        Writeln('---------- DSProcessor Task Sources List ----------');

        if Assigned(TaskSourceList) then
        begin
          var FirstSource: TTaskSource := nil;

          if TaskSourceList.Count > 0 then
            FirstSource := TaskSourceList.Items[0] as TTaskSource;

          for TaskSourceEntity in TaskSourceList do
          begin
            var Source := TaskSourceEntity as TTaskSource;
            Writeln(Format('Class: %s | Address: %p', [Source.ClassName, Pointer(Source)]));
            Writeln('Sid: ' + Source.Sid);
            Writeln('Name: ' + Source.Name);
            Writeln('Enabled: ' + BoolToStr(Source.Enabled, True));
            Writeln('Index: ' + Source.StationIndex);

            Writeln('As JSON:');
            var SourceJson := Source.Serialize();
            try
              if SourceJson <> nil then
                Writeln(SourceJson.Format);
            finally
              SourceJson.Free;
            end;

            Writeln('----------');
          end;

          if Assigned(FirstSource) then
          begin
            Writeln('---------- DSProcessor Task Source Info ----------');
            Writeln('Requesting info for: ' + FirstSource.Sid);

            var InfoEntity: TEntity := nil;
            try
              InfoEntity := DSProcessorTaskSourcesBroker.Info(FirstSource.Sid);

              if Assigned(InfoEntity) then
              begin
                var InfoSource := InfoEntity as TTaskSource;
                Writeln('Info result as JSON:');
                var InfoJson := InfoSource.Serialize();
                try
                  if InfoJson <> nil then
                    Writeln(InfoJson.Format);
                finally
                  InfoJson.Free;
                end;
              end
              else
                Writeln('Info request returned nil.');
            finally
              InfoEntity.Free;
            end;

            Writeln('----------');
          end;
        end
        else
          Writeln('DSProcessor task sources list is empty.');

      finally
        TaskSourceList.Free;
      end;
    finally
      DSProcessorTaskSourcesBroker.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;

procedure ListSummaryTaskSources();
var
  SummaryTasksBroker: TSummaryTasksBroker;
  SummaryTaskSourcesBroker: TSummaryTaskSourcesBroker;
  SummaryTaskList: TEntityList;
  SummaryTaskEntity: TEntity;
  TaskSourceList: TEntityList;
  TaskSourceEntity: TEntity;
  SummaryTaskPageCount: Integer;
  TaskSourcePageCount: Integer;
  FirstSummaryTaskTid: string;
begin
  try
    SummaryTasksBroker := TSummaryTasksBroker.Create;
    try
      SummaryTaskList := nil;
      FirstSummaryTaskTid := '';
      try
        SummaryTaskList := SummaryTasksBroker.List(SummaryTaskPageCount);

        Writeln('---------- Summary Tasks List ----------');

        if Assigned(SummaryTaskList) and (SummaryTaskList.Count > 0) then
        begin
          for SummaryTaskEntity in SummaryTaskList do
          begin
            var SummaryTask := SummaryTaskEntity as TSummaryTask;
            Writeln(Format('Class: %s | Address: %p', [SummaryTask.ClassName, Pointer(SummaryTask)]));
            Writeln('Tid: ' + SummaryTask.Tid);
            Writeln('Name: ' + SummaryTask.Name);
            Writeln('Enabled: ' + BoolToStr(SummaryTask.Enabled, True));

            Writeln('As JSON:');
            var TaskJson := SummaryTask.Serialize();
            try
              if TaskJson <> nil then
                Writeln(TaskJson.Format);
            finally
              TaskJson.Free;
            end;

            Writeln('----------');
          end;

          FirstSummaryTaskTid := (SummaryTaskList.Items[0] as TSummaryTask).Tid;
        end
        else
          Writeln('Summary tasks list is empty.');

      finally
        SummaryTaskList.Free;
      end;
    finally
      SummaryTasksBroker.Free;
    end;

    if FirstSummaryTaskTid = '' then
    begin
      Writeln('No summary task available to request summary task sources.');
      Exit;
    end;

    SummaryTaskSourcesBroker := TSummaryTaskSourcesBroker.Create;
    try
      SummaryTaskSourcesBroker.AddPath := '/' + FirstSummaryTaskTid;

      TaskSourceList := nil;
      try
        TaskSourceList := SummaryTaskSourcesBroker.List(TaskSourcePageCount);

        Writeln('---------- Summary Task Sources List ----------');

        if Assigned(TaskSourceList) then
        begin
          var FirstSource: TTaskSource := nil;

          if TaskSourceList.Count > 0 then
            FirstSource := TaskSourceList.Items[0] as TTaskSource;

          for TaskSourceEntity in TaskSourceList do
          begin
            var Source := TaskSourceEntity as TTaskSource;
            Writeln(Format('Class: %s | Address: %p', [Source.ClassName, Pointer(Source)]));
            Writeln('Sid: ' + Source.Sid);
            Writeln('Name: ' + Source.Name);
            Writeln('Enabled: ' + BoolToStr(Source.Enabled, True));
            Writeln('Index: ' + Source.StationIndex);

            Writeln('As JSON:');
            var Json := Source.Serialize();
            try
              if Json <> nil then
                Writeln(Json.Format);
            finally
              Json.Free;
            end;

            Writeln('----------');
          end;

          if Assigned(FirstSource) then
          begin
            Writeln('---------- Summary Task Source Info ----------');
            Writeln('Requesting info for: ' + FirstSource.Sid);

            var InfoEntity: TEntity := nil;
            try
              InfoEntity := SummaryTaskSourcesBroker.Info(FirstSource.Sid);

              if Assigned(InfoEntity) then
              begin
                var InfoSource := InfoEntity as TTaskSource;
                Writeln('Info result as JSON:');
                var InfoJson := InfoSource.Serialize();
                try
                  if InfoJson <> nil then
                    Writeln(InfoJson.Format);
                finally
                  InfoJson.Free;
                end;
              end
              else
                Writeln('Info request returned nil.');
            finally
              InfoEntity.Free;
            end;
            Writeln('----------');
          end;
        end
        else
          Writeln('Summary task sources list is empty.');

      finally
        TaskSourceList.Free;
      end;
    finally
      SummaryTaskSourcesBroker.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;

procedure ListMonitoringTaskSources();
var
  MonitoringTasksBroker: TMonitoringTasksBroker;
  MonitoringTaskSourcesBroker: TMonitoringTaskSourcesBroker;
  MonitoringTaskList: TEntityList;
  MonitoringTaskEntity: TEntity;
  TaskSourceList: TEntityList;
  TaskSourceEntity: TEntity;
  MonitoringTaskPageCount: Integer;
  TaskSourcePageCount: Integer;
  FirstMonitoringTaskTid: string;
begin
  try
    MonitoringTasksBroker := TMonitoringTasksBroker.Create;
    try
      MonitoringTaskList := nil;
      FirstMonitoringTaskTid := '';
      try
        MonitoringTaskList := MonitoringTasksBroker.List(MonitoringTaskPageCount);

        Writeln('---------- Monitoring Tasks List ----------');

        if Assigned(MonitoringTaskList) and (MonitoringTaskList.Count > 0) then
        begin
          for MonitoringTaskEntity in MonitoringTaskList do
          begin
            var MonitoringTask := MonitoringTaskEntity as TMonitoringTask;
            Writeln(Format('Class: %s | Address: %p', [MonitoringTask.ClassName, Pointer(MonitoringTask)]));
            Writeln('Tid: ' + MonitoringTask.Tid);
            Writeln('Name: ' + MonitoringTask.Name);
            Writeln('Enabled: ' + BoolToStr(MonitoringTask.Enabled, True));

            Writeln('As JSON:');
            var TaskJson := MonitoringTask.Serialize();
            try
              if TaskJson <> nil then
                Writeln(TaskJson.Format);
            finally
              TaskJson.Free;
            end;

            Writeln('----------');
          end;

          FirstMonitoringTaskTid := (MonitoringTaskList.Items[0] as TMonitoringTask).Tid;
        end
        else
          Writeln('Monitoring tasks list is empty.');

      finally
        MonitoringTaskList.Free;
      end;
    finally
      MonitoringTasksBroker.Free;
    end;

    if FirstMonitoringTaskTid = '' then
    begin
      Writeln('No monitoring task available to request monitoring task sources.');
      Exit;
    end;

    MonitoringTaskSourcesBroker := TMonitoringTaskSourcesBroker.Create;
    try
      MonitoringTaskSourcesBroker.AddPath := '/' + FirstMonitoringTaskTid;

      TaskSourceList := nil;
      try
        TaskSourceList := MonitoringTaskSourcesBroker.List(TaskSourcePageCount);

        Writeln('---------- Monitoring Task Sources List ----------');

        if Assigned(TaskSourceList) then
        begin
          var FirstSource: TTaskSource := nil;

          if TaskSourceList.Count > 0 then
            FirstSource := TaskSourceList.Items[0] as TTaskSource;

          for TaskSourceEntity in TaskSourceList do
          begin
            var Source := TaskSourceEntity as TTaskSource;
            Writeln(Format('Class: %s | Address: %p', [Source.ClassName, Pointer(Source)]));
            Writeln('Sid: ' + Source.Sid);
            Writeln('Name: ' + Source.Name);
            Writeln('Enabled: ' + BoolToStr(Source.Enabled, True));
            Writeln('Index: ' + Source.StationIndex);

            Writeln('As JSON:');
            var Json := Source.Serialize();
            try
              if Json <> nil then
                Writeln(Json.Format);
            finally
              Json.Free;
            end;

            Writeln('----------');
          end;

          if Assigned(FirstSource) then
          begin
            Writeln('---------- Monitoring Task Source Info ----------');
            Writeln('Requesting info for: ' + FirstSource.Sid);

            var InfoEntity: TEntity := nil;
            try
              InfoEntity := MonitoringTaskSourcesBroker.Info(FirstSource.Sid);

              if Assigned(InfoEntity) then
              begin
                var InfoSource := InfoEntity as TTaskSource;
                Writeln('Info result as JSON:');
                var InfoJson := InfoSource.Serialize();
                try
                  if InfoJson <> nil then
                    Writeln(InfoJson.Format);
                finally
                  InfoJson.Free;
                end;
              end
              else
                Writeln('Info request returned nil.');
            finally
              InfoEntity.Free;
            end;
            Writeln('----------');
          end;
        end
        else
          Writeln('Monitoring task sources list is empty.');

      finally
        TaskSourceList.Free;
      end;
    finally
      MonitoringTaskSourcesBroker.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;

(* !!!procedure ListProfiles();
var
  LinksBroker: TLinksBroker;
  ProfilesBroker: TProfilesBroker;
  LinksList: TEntityList;
  ProfilesList: TEntityList;
  LinkEntity: TEntity;
  ProfileEntity: TEntity;
  LinkPageCount: Integer;
  ProfilePageCount: Integer;
  FirstLinkLid: string;
begin
  try
    LinksBroker := TLinksBroker.Create;
    try
      LinksList := nil;
      FirstLinkLid := '';
      try
        LinksList := LinksBroker.List(LinkPageCount);

        Writeln('---------- Links List ----------');

        if Assigned(LinksList) and (LinksList.Count > 0) then
        begin
          for LinkEntity in LinksList do
          begin
            var Link := LinkEntity as TLink;
            Writeln(Format('Class: %s | Address: %p', [Link.ClassName, Pointer(Link)]));
            Writeln('Lid: ' + Link.Lid);
            Writeln('Name: ' + Link.Name);
            Writeln('Dir: ' + Link.Dir);
            Writeln('Status: ' + Link.Status);
            Writeln('Comsts: ' + Link.Comsts);
            Writeln('Last activity time: ' + IntToStr(Link.LastActivityTime));
            Writeln('----------');
          end;

          FirstLinkLid := (LinksList.Items[0] as TLink).Lid;
        end
        else
          Writeln('Links list is empty.');

      finally
        LinksList.Free;
      end;
    finally
      LinksBroker.Free;
    end;

    if FirstLinkLid = '' then
    begin
      Writeln('No link available to request profiles.');
      Exit;
    end;

    ProfilesBroker := TProfilesBroker.Create;
    try
      ProfilesBroker.AddPath := '/' + FirstLinkLid;

      ProfilesList := nil;
      try
        ProfilesList := ProfilesBroker.List(ProfilePageCount);

        Writeln('---------- Profiles List ----------');

        if Assigned(ProfilesList) and (ProfilesList.Count > 0) then
        begin
          for ProfileEntity in ProfilesList do
          begin
            var Profile := ProfileEntity as TProfile;
            Writeln(Format('Class: %s | Address: %p', [Profile.ClassName, Pointer(Profile)]));
            Writeln('Id: ' + Profile.Id);
            Writeln('Name: ' + Profile.Name);
            Writeln('Description: ' + Profile.Description);

            var Body := Profile.ProfileBody;
            if Assigned(Body) then
            begin
              var Rule := Body.Rule;
              if Assigned(Rule) then
              begin
                Writeln('Rule priority: ' + IntToStr(Rule.Priority));
                Writeln('Rule doubles: ' + BoolToStr(Rule.Doubles, True));
              end;

              var Play := Body.Play;
              if Assigned(Play) and Assigned(Play.FTA) then
              begin
                Writeln('FTA name: ' + Play.FTA.Name);
                Writeln('FTA values count: ' + IntToStr(Play.FTA.Values.Count));
              end;
            end;

            Writeln('As JSON:');
            var Json := Profile.Serialize();
            try
              if Json <> nil then
                Writeln(Json.Format);
            finally
              Json.Free;
            end;

            Writeln('----------');
          end;
        end
        else
          Writeln('Profiles list is empty.');

      finally
        ProfilesList.Free;
      end;
    finally
      ProfilesBroker.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;                *)

procedure ListRouterSource();
var
  RouterSourceBroker: TRouterSourceBroker;
  RouterSourceList: TEntityList;
  RouterSourceEntity: TEntity;
  PageCount: Integer;

var
  Body, Response: string;

begin
  try
    RouterSourceBroker := TRouterSourceBroker.Create;
    try
      RouterSourceList := nil;
      try
        RouterSourceList := RouterSourceBroker.List(PageCount);

        Writeln('---------- Router Sources List ----------');

        if Assigned(RouterSourceList) then
        begin
          var FirstSource: TRouterSource := nil;

          if RouterSourceList.Count > 0 then
            FirstSource := RouterSourceList.Items[0] as TRouterSource;

          for RouterSourceEntity in RouterSourceList do
          begin
            var Source := RouterSourceEntity as TRouterSource;
            Writeln(Format('Class: %s | Address: %p', [Source.ClassName, Pointer(Source)]));
            Writeln('Who: ' + Source.Who);
            Writeln('SvcId: ' + Source.SvcId);
            Writeln('Lid: ' + Source.Lid);

            Writeln('As JSON:');
            var Json := Source.Serialize();
            try
              if Json <> nil then
                Writeln(Json.Format);
            finally
              Json.Free;
            end;

            Writeln('----------');
          end;

          if Assigned(FirstSource) then
          begin
            Writeln('---------- Router Source Info ----------');
            Writeln('Requesting info for: ' + FirstSource.Who);

            var InfoEntity: TEntity := nil;
            try
              InfoEntity := RouterSourceBroker.Info(FirstSource.Who);

              if Assigned(InfoEntity) then
              begin
                var InfoSource := InfoEntity as TRouterSource;
                Writeln('Info result as JSON:');
                var InfoJson := InfoSource.Serialize();
                try
                  if InfoJson <> nil then
                    Writeln(InfoJson.Format);
                finally
                  InfoJson.Free;
                end;
              end
              else
                Writeln('Info request returned nil.');
            finally
              InfoEntity.Free;
            end;
            Writeln('----------');
          end;
        end
        else
          Writeln('Router source list is empty.');

      finally
        RouterSourceList.Free;
      end;
    finally
      RouterSourceBroker.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;

procedure ListAbonents();
var
  AbonentsBroker: TAbonentsBroker;
  AbonentList: TEntityList;
  AbonentEntity: TEntity;
  PageCount: Integer;
begin
  try
    AbonentsBroker := TAbonentsBroker.Create;
    try
      AbonentList := nil;
      try
        AbonentList := AbonentsBroker.List(PageCount);

        Writeln('---------- Abonents List ----------');

        if Assigned(AbonentList) then
        begin
          var FirstAbonent: TAbonent := nil;

          if AbonentList.Count > 0 then
            FirstAbonent := AbonentList.Items[0] as TAbonent;

          for AbonentEntity in AbonentList do
          begin
            var Abonent := AbonentEntity as TAbonent;
            Writeln(Format('Class: %s | Address: %p', [Abonent.ClassName, Pointer(Abonent)]));
            Writeln('Abid: ' + Abonent.Abid);
            Writeln('Name: ' + Abonent.Name);
            Writeln('Caption: ' + Abonent.Caption);
            Writeln('Channels count: ' + IntToStr(Abonent.Channels.Count));
            Writeln('Attr pairs count: ' + IntToStr(Abonent.Attr.Count));

            Writeln('As JSON:');
            var Json := Abonent.Serialize();
            try
              if Json <> nil then
                Writeln(Json.Format);
            finally
              Json.Free;
            end;

            Writeln('----------');
          end;

          if Assigned(FirstAbonent) then
          begin
            Writeln('---------- Abonent Info ----------');
            Writeln('Requesting info for: ' + FirstAbonent.Abid);

            var InfoEntity: TEntity := nil;
            try
              InfoEntity := AbonentsBroker.Info(FirstAbonent.Abid);

              if Assigned(InfoEntity) then
              begin
                var InfoAbonent := InfoEntity as TAbonent;
                Writeln('Info result as JSON:');
                var InfoJson := InfoAbonent.Serialize();
                try
                  if InfoJson <> nil then
                    Writeln(InfoJson.Format);
                finally
                  InfoJson.Free;
                end;
              end
              else
                Writeln('Info request returned nil.');
            finally
              InfoEntity.Free;
            end;
            Writeln('----------');
          end;
        end
        else
          Writeln('Abonents list is empty.');

        if Assigned(AbonentList) then
        begin
          Writeln('---------- Abonents Info ----------');
          var InfoJson := AbonentList.Serialize();
          try
            if InfoJson <> nil then
              Writeln(InfoJson.Format);
          finally
            InfoJson.Free;
          end;
        end;

      finally
        AbonentList.Free;
      end;
    finally
      AbonentsBroker.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;

procedure ListBindings();
var
  BindingsBroker: TBindingsBroker;
  BindingList: TEntityList;
  BindingEntity: TEntity;
  PageCount: Integer;
begin
  try
    BindingsBroker := TBindingsBroker.Create;
    try
      BindingList := nil;
      try
        BindingList := BindingsBroker.List(PageCount);

        Writeln('---------- Metadata Bindings ----------');

        if Assigned(BindingList) then
        begin
          var FirstBinding: TBinding := nil;

          if BindingList.Count > 0 then
            FirstBinding := BindingList.Items[0] as TBinding;

          for BindingEntity in BindingList do
          begin
            var Binding := BindingEntity as TBinding;
            Writeln(Format('Class: %s | Address: %p', [Binding.ClassName, Pointer(Binding)]));
            Writeln('Bid: ' + Binding.Bid);
            Writeln('CompId: ' + Binding.CompId);
            Writeln('Entity: ' + Binding.EntityId);
            Writeln('Type: ' + Binding.BindingType);
            Writeln('Urn: ' + Binding.Urn);
            Writeln('Index: ' + Binding.Index);
            Writeln('Created: ' + DateTimeToStr(Binding.Created));
            Writeln('Updated: ' + DateTimeToStr(Binding.Updated));

            if Assigned(Binding.BindingData) then
            begin
              Writeln('Data.Def: ' + Binding.BindingData.Def);
              if Assigned(Binding.BindingData.Attr) then
                Writeln('Data.Attr: ' + Binding.BindingData.Attr.ToJSON)
              else
                Writeln('Data.Attr: {}');
            end;

            Writeln('As JSON:');
            var Json := Binding.Serialize();
            try
              if Json <> nil then
                Writeln(Json.Format);
            finally
              Json.Free;
            end;

            Writeln('----------');
          end;

          if Assigned(FirstBinding) then
          begin
            Writeln('---------- Binding Info ----------');
            Writeln('Requesting info for: ' + FirstBinding.Bid);

            var InfoEntity: TEntity := nil;
            try
              InfoEntity := BindingsBroker.Info(FirstBinding.Bid);

              if Assigned(InfoEntity) then
              begin
                var InfoBinding := InfoEntity as TBinding;
                Writeln('Info result as JSON:');
                var InfoJson := InfoBinding.Serialize();
                try
                  if InfoJson <> nil then
                    Writeln(InfoJson.Format);
                finally
                  InfoJson.Free;
                end;
              end
              else
                Writeln('Info request returned nil.');
            finally
              InfoEntity.Free;
            end;
            Writeln('----------');
          end;
        end
        else
          Writeln('Bindings list is empty.');

        if Assigned(BindingList) then
        begin
          Writeln('---------- Bindings List JSON ----------');
          var InfoJson := BindingList.Serialize();
          try
            if InfoJson <> nil then
              Writeln(InfoJson.Format);
          finally
            InfoJson.Free;
          end;
        end;

      finally
        BindingList.Free;
      end;
    finally
      BindingsBroker.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;

procedure ListContexts();
var
  ContextsBroker: TContextsBroker;
  ContextList: TEntityList;
  ContextEntity: TEntity;
  PageCount: Integer;
begin
  try
    ContextsBroker := TContextsBroker.Create;
    try
      ContextList := nil;
      try
        ContextList := ContextsBroker.List(PageCount);

        Writeln('---------- Dataserver Contexts ----------');

        if Assigned(ContextList) then
        begin
          var FirstContext: TContext := nil;

          if ContextList.Count > 0 then
            FirstContext := ContextList.Items[0] as TContext;

          for ContextEntity in ContextList do
          begin
            var Context := ContextEntity as TContext;
            Writeln(Format('Class: %s | Address: %p', [Context.ClassName, Pointer(Context)]));
            Writeln('CtxId: ' + Context.CtxId);
            Writeln('CtxtId: ' + Context.CtxtId);
            Writeln('Sid: ' + Context.Sid);
            Writeln('Index: ' + Context.Index);
            if Assigned(Context.Data) then
              Writeln('Data: ' + Context.Data.ToJSON)
            else
              Writeln('Data: {}');

            Writeln('As JSON:');
            var Json := Context.Serialize();
            try
              if Json <> nil then
                Writeln(Json.Format);
            finally
              Json.Free;
            end;

            Writeln('----------');
          end;

          if Assigned(FirstContext) then
          begin
            Writeln('---------- Context Info ----------');
            Writeln('Requesting info for: ' + FirstContext.CtxId);

            var InfoEntity: TEntity := nil;
            try
              InfoEntity := ContextsBroker.Info(FirstContext.CtxId);

              if Assigned(InfoEntity) then
              begin
                var InfoContext := InfoEntity as TContext;
                Writeln('Info result as JSON:');
                var InfoJson := InfoContext.Serialize();
                try
                  if InfoJson <> nil then
                    Writeln(InfoJson.Format);
                finally
                  InfoJson.Free;
                end;
              end
              else
                Writeln('Info request returned nil.');
            finally
              InfoEntity.Free;
            end;
            Writeln('----------');
          end;
        end
        else
          Writeln('Contexts list is empty.');

      finally
        ContextList.Free;
      end;
    finally
      ContextsBroker.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;

procedure ListSourceTypes();
var
  SourceTypesBroker: TSourceTypesBroker;
  SourceTypesList: TFieldSetList;
  PageCount: Integer;
begin
  try
    SourceTypesBroker := TSourceTypesBroker.Create;
    try
      SourceTypesList := nil;
      try
        SourceTypesList := SourceTypesBroker.List(PageCount);

        Writeln('---------- Dataserver Source Types ----------');

        if Assigned(SourceTypesList) then
        begin
          if SourceTypesList.Count = 0 then
            Writeln('Source types list is empty.')
          else
          begin
            for var FieldSet in SourceTypesList do
            begin
              if not (FieldSet is TSourceType) then
                Continue;

              var SourceType := TSourceType(FieldSet);
              Writeln(Format('Class: %s | Address: %p', [SourceType.ClassName, Pointer(SourceType)]));
              Writeln('Srctid: ' + SourceType.Srctid);
              Writeln('SrcType: ' + IntToStr(SourceType.SrcType));
              Writeln('Name: ' + SourceType.Name);
              if Assigned(SourceType.Def) then
                Writeln('Def: ' + SourceType.Def.ToJSON)
              else
                Writeln('Def: {}');

              Writeln('As JSON:');
              var Json := SourceType.Serialize();
              try
                if Json <> nil then
                  Writeln(Json.Format);
              finally
                Json.Free;
              end;

              Writeln('----------');
            end;

            Writeln('List as JSON:');
            var ListJson := SourceTypesList.SerializeList();
            try
              if ListJson <> nil then
                Writeln(ListJson.Format);
            finally
              ListJson.Free;
            end;
          end;
        end
        else
          Writeln('Source types list is empty.');

      finally
        SourceTypesList.Free;
      end;
    finally
      SourceTypesBroker.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;

procedure ListContextTypes();
var
  ContextTypesBroker: TContextTypesBroker;
  ContextTypesList: TFieldSetList;
  PageCount: Integer;
begin
  try
    ContextTypesBroker := TContextTypesBroker.Create;
    try
      ContextTypesList := nil;
      try
        ContextTypesList := ContextTypesBroker.List(PageCount);

        Writeln('---------- Dataserver Context Types ----------');

        if Assigned(ContextTypesList) then
        begin
          if ContextTypesList.Count = 0 then
            Writeln('Context types list is empty.')
          else
          begin
            for var FieldSet in ContextTypesList do
            begin
              if not (FieldSet is TContextType) then
                Continue;

              var ContextType := TContextType(FieldSet);
              Writeln(Format('Class: %s | Address: %p', [ContextType.ClassName, Pointer(ContextType)]));
              Writeln('Ctxtid: ' + ContextType.Ctxtid);
              Writeln('Name: ' + ContextType.Name);
              if Assigned(ContextType.Def) then
                Writeln('Def: ' + ContextType.Def.ToJSON)
              else
                Writeln('Def: {}');

              Writeln('As JSON:');
              var Json := ContextType.Serialize();
              try
                if Json <> nil then
                  Writeln(Json.Format);
              finally
                Json.Free;
              end;

              Writeln('----------');
            end;

            Writeln('List as JSON:');
            var ListJson := ContextTypesList.SerializeList();
            try
              if ListJson <> nil then
                Writeln(ListJson.Format);
            finally
              ListJson.Free;
            end;
          end;
        end
        else
          Writeln('Context types list is empty.');

      finally
        ContextTypesList.Free;
      end;
    finally
      ContextTypesBroker.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;

procedure ListAliases();
var
  AliasesBroker: TAliasesBroker;
  AliasList: TEntityList;
  AliasEntity: TEntity;
  PageCount: Integer;
begin
  try
    AliasesBroker := TAliasesBroker.Create;
    try
      AliasList := nil;
      try
        AliasList := AliasesBroker.List(PageCount);

        Writeln('---------- Aliases List ----------');

        if Assigned(AliasList) then
        begin
          var FirstAlias: TAlias := nil;

          if AliasList.Count > 0 then
            FirstAlias := AliasList.Items[0] as TAlias;

          for AliasEntity in AliasList do
          begin
            var Alias := AliasEntity as TAlias;
            Writeln(Format('Class: %s | Address: %p', [Alias.ClassName, Pointer(Alias)]));
            Writeln('Alid: ' + Alias.Alid);
            Writeln('Name: ' + Alias.Name);
            Writeln('Caption: ' + Alias.Caption);
//            Writeln('Channels count: ' + IntToStr(Alias.Channels.Count));

            Writeln('As JSON:');
            var Json := Alias.Serialize();
            try
              if Json <> nil then
                Writeln(Json.Format);
            finally
              Json.Free;
            end;

            Writeln('----------');
          end;

          if Assigned(FirstAlias) then
          begin
            Writeln('---------- Alias Info ----------');
            Writeln('Requesting info for: ' + FirstAlias.Alid);

            var InfoEntity: TEntity := nil;
            try
              InfoEntity := AliasesBroker.Info(FirstAlias.Alid);

              if Assigned(InfoEntity) then
              begin
                var InfoAlias := InfoEntity as TAlias;
                Writeln('Info result as JSON:');
                var InfoJson := InfoAlias.Serialize();
                try
                  if InfoJson <> nil then
                    Writeln(InfoJson.Format);
                finally
                  InfoJson.Free;
                end;
              end
              else
                Writeln('Info request returned nil.');
            finally
              InfoEntity.Free;
            end;
            Writeln('----------');
          end;
        end
        else
          Writeln('Aliases list is empty.');

      finally
        AliasList.Free;
      end;
    finally
      AliasesBroker.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;

procedure ListRules();
var
  RulesBroker: TRulesBroker;
  RulesList: TEntityList;
  RulesEntity: TEntity;
  PageCount: Integer;
begin
  try
    RulesBroker := TRulesBroker.Create;
    try
      RulesList := nil;
      try
        RulesList := RulesBroker.List(PageCount);

        Writeln('---------- Rules List ----------');

        if Assigned(RulesList) then
        begin
          var FirstRule: TRule := nil;

          if RulesList.Count > 0 then
            FirstRule := RulesList.Items[0] as TRule;

          for RulesEntity in RulesList do
          begin
            var Rule := RulesEntity as TRule;
            Writeln(Format('Class: %s | Address: %p', [Rule.ClassName, Pointer(Rule)]));
            Writeln('Ruid: ' + Rule.Ruid);
            Writeln('Caption: ' + Rule.Caption);
            Writeln('Rule priority: ' + IntToStr(Rule.Rule.Priority));
            Writeln('Rule position: ' + IntToStr(Rule.Rule.Position));
            Writeln('Rule doubles: ' + BoolToStr(Rule.Rule.Doubles, True));
            Writeln('Rule break: ' + BoolToStr(Rule.Rule.BreakRule, True));
            Writeln('Handlers count: ' + IntToStr(Rule.Rule.Handlers.Count));
            Writeln('Channels count: ' + IntToStr(Rule.Rule.Channels.Count));
            Writeln('Inc filters count: ' + IntToStr(Rule.Rule.IncFilters.Count));
            Writeln('Exc filters count: ' + IntToStr(Rule.Rule.ExcFilters.Count));

            Writeln('As JSON:');
            var Json := Rule.Serialize();
            try
              if Json <> nil then
                Writeln(Json.Format);
            finally
              Json.Free;
            end;

            Writeln('----------');
          end;

          if Assigned(FirstRule) then
          begin
            Writeln('---------- Rule Info ----------');
            Writeln('Requesting info for: ' + FirstRule.Ruid);

            var InfoEntity: TEntity := nil;
            try
              InfoEntity := RulesBroker.Info(FirstRule.Ruid);

              if Assigned(InfoEntity) then
              begin
                var InfoRule := InfoEntity as TRule;
                Writeln('Info result as JSON:');
                var InfoJson := InfoRule.Serialize();
                try
                  if InfoJson <> nil then
                    Writeln(InfoJson.Format);
                finally
                  InfoJson.Free;
                end;
              end
              else
                Writeln('Info request returned nil.');
            finally
              InfoEntity.Free;
            end;
            Writeln('----------');
          end;
        end
        else
          Writeln('Rules list is empty.');

      finally
        RulesList.Free;
      end;
    finally
      RulesBroker.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;

procedure ListSourceCreds();
var
  SourceCredsBroker: TSourceCredsBroker;
  SourceCredsList: TEntityList;
  SourceCredsEntity: TEntity;
  PageCount: Integer;
begin
  try
    SourceCredsBroker := TSourceCredsBroker.Create;
    try
      SourceCredsList := nil;
      try
        SourceCredsList := SourceCredsBroker.List(PageCount);

        Writeln('---------- Source Creds List ----------');

        if Assigned(SourceCredsList) then
        begin
          var FirstCreds: TSourceCreds := nil;

          if SourceCredsList.Count > 0 then
            FirstCreds := SourceCredsList.Items[0] as TSourceCreds;

          for SourceCredsEntity in SourceCredsList do
          begin
            var Creds := SourceCredsEntity as TSourceCreds;
            Writeln(Format('Class: %s | Address: %p', [Creds.ClassName, Pointer(Creds)]));
            Writeln('Crid: ' + Creds.Crid);
            Writeln('Name: ' + Creds.Name);
            Writeln('CtxId: ' + Creds.CtxId);
            Writeln('Lid: ' + Creds.Lid);
            Writeln('Login: ' + Creds.Login);
            Writeln('Pass: ' + Creds.Pass);
            Writeln('Data.Def: ' + Creds.SourceData.Def);

            Writeln('As JSON:');
            var Json := Creds.Serialize();
            try
              if Json <> nil then
                Writeln(Json.Format);
            finally
              Json.Free;
            end;

            Writeln('----------');
          end;

          if Assigned(FirstCreds) then
          begin
            Writeln('---------- Source Creds Info ----------');
            Writeln('Requesting info for: ' + FirstCreds.Crid);

            var InfoEntity: TEntity := nil;
            try
              InfoEntity := SourceCredsBroker.Info(FirstCreds.Crid);

              if Assigned(InfoEntity) then
              begin
                var InfoCreds := InfoEntity as TSourceCreds;
                Writeln('Info result as JSON:');
                Writeln('Info Data.Def: ' + InfoCreds.SourceData.Def);
                var InfoJson := InfoCreds.Serialize();
                try
                  if InfoJson <> nil then
                    Writeln(InfoJson.Format);
                finally
                  InfoJson.Free;
                end;
              end
              else
                Writeln('Info request returned nil.');
            finally
              InfoEntity.Free;
            end;
            Writeln('----------');
          end;
        end
        else
          Writeln('Source creds list is empty.');

      finally
        SourceCredsList.Free;
      end;
    finally
      SourceCredsBroker.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;

procedure ListUsers();
var
  UsersBroker: TUsersBroker;
  UsersList: TEntityList;
  UsersEntity: TEntity;
  PageCount: Integer;
begin
  try
    UsersBroker := TUsersBroker.Create;
    try
      UsersList := nil;
      try
        UsersList := UsersBroker.List(PageCount);

        Writeln('---------- Users List ----------');

        if Assigned(UsersList) then
        begin
          var FirstUser: TUser := nil;

          if UsersList.Count > 0 then
            FirstUser := UsersList.Items[0] as TUser;

          for UsersEntity in UsersList do
          begin
            var User := UsersEntity as TUser;
            Writeln(Format('Class: %s | Address: %p', [User.ClassName, Pointer(User)]));
            Writeln('Usid: ' + User.Usid);
            Writeln('Name: ' + User.Name);
            Writeln('Email: ' + User.Email);
            Writeln('AllowComp count: ' + IntToStr(User.AllowComp.Count));
            Writeln('Body Roles count: ' + IntToStr(User.UserBody.Roles.Count));
            Writeln('Group Body Levels count: ' + IntToStr(User.GroupBody.Levels.Count));

            Writeln('As JSON:');
            var Json := User.Serialize();
            try
              if Json <> nil then
                Writeln(Json.Format);
            finally
              Json.Free;
            end;

            Writeln('----------');
          end;

          if Assigned(FirstUser) then
          begin
            Writeln('---------- User Info ----------');
            Writeln('Requesting info for: ' + FirstUser.Usid);

            var InfoEntity: TEntity := nil;
            try
              InfoEntity := UsersBroker.Info(FirstUser.Usid);

              if Assigned(InfoEntity) then
              begin
                var InfoUser := InfoEntity as TUser;
                Writeln('Info result as JSON:');
                var InfoJson := InfoUser.Serialize();
                try
                  if InfoJson <> nil then
                    Writeln(InfoJson.Format);
                finally
                  InfoJson.Free;
                end;
              end
              else
                Writeln('Info request returned nil.');
            finally
              InfoEntity.Free;
            end;
            Writeln('----------');
          end;
        end
        else
          Writeln('Users list is empty.');

      finally
        UsersList.Free;
      end;
    finally
      UsersBroker.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;

procedure ListDsGroups();
var
  DsGroupBroker: TDsGroupBroker;
  DsGroupList: TEntityList;
  DsGroupEntity: TEntity;
  PageCount: Integer;
begin
  try
    DsGroupBroker := TDsGroupBroker.Create;
    try
      DsGroupList := nil;
      try
        DsGroupList := DsGroupBroker.List(PageCount);

        Writeln('---------- DS Groups List ----------');

        if Assigned(DsGroupList) then
        begin
          var FirstGroup: TDsGroup := nil;

          if DsGroupList.Count > 0 then
            FirstGroup := DsGroupList.Items[0] as TDsGroup;

          for DsGroupEntity in DsGroupList do
          begin
            var Group := DsGroupEntity as TDsGroup;
            Writeln(Format('Class: %s | Address: %p', [Group.ClassName, Pointer(Group)]));
            Writeln('Dsgid: ' + Group.Dsgid);
            Writeln('Name: ' + Group.Name);
            Writeln('Pdsgid: ' + Group.Pdsgid);
            Writeln('Ctxid: ' + Group.Ctxid);
            Writeln('Sid: ' + Group.Sid);
            Writeln('Dataseries reported count: ' + IntToStr(Group.DataseriesCount));
            Writeln('Dataseries parsed count: ' + IntToStr(Group.Dataseries.Count));

            Writeln('As JSON:');
            var Json := Group.Serialize();
            try
              if Json <> nil then
                Writeln(Json.Format);
            finally
              Json.Free;
            end;

            Writeln('----------');
          end;

          if Assigned(FirstGroup) then
          begin
            Writeln('---------- DS Group Info ----------');
            Writeln('Requesting info for: ' + FirstGroup.Dsgid);

            var InfoEntity: TEntity := nil;
            try
              InfoEntity := DsGroupBroker.Info(FirstGroup.Dsgid);

              if Assigned(InfoEntity) then
              begin
                var InfoGroup := InfoEntity as TDsGroup;
                Writeln('Info result as JSON:');
                var InfoJson := InfoGroup.Serialize();
                try
                  if InfoJson <> nil then
                    Writeln(InfoJson.Format);
                finally
                  InfoJson.Free;
                end;
              end
              else
                Writeln('Info request returned nil.');
            finally
              InfoEntity.Free;
            end;
            Writeln('----------');
          end;
        end
        else
          Writeln('DS groups list is empty.');

      finally
        DsGroupList.Free;
      end;
    finally
      DsGroupBroker.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;


procedure GetLogs();

var
  StartTimeISO, EndTimeISO: string;
  QueryParam, Url, Response: string;
  JsonValue: TJSONValue;
  Logs: TLogs;
begin
  try
    EndTimeISO := DateToISO8601(Now, False);
    StartTimeISO := DateToISO8601(IncMinute(Now, -10), False);

    QueryParam := '{level="error"}';
    Url := Format('/signals/logs/query_range?query=%s&start=%s&end=%s', [
      TIdURI.ParamsEncode(QueryParam),
      TIdURI.ParamsEncode(StartTimeISO),
      TIdURI.ParamsEncode(EndTimeISO)
    ]);

    Url := '/signals/api/v1/logs/query_range?query={level="error"}&start=2025-10-15T00:40:51.781Z&end=2025-10-16T23:40:51.781Z';

    try
      Response := GET(Url);
    except
      on E: Exception do
      begin
        Writeln('Failed to query logs from API: ' + E.Message);
        Response := '{}';
      end;
    end;

    JsonValue := TJSONObject.ParseJSONValue(Response);
    try
      if JsonValue is TJSONObject then
      begin
        Logs := TLogs.Create(TJSONObject(JsonValue));
        try
          Writeln('---------- Logs ----------');
          Writeln('Status: ' + Logs.Status);
          Writeln('Result type: ' + Logs.ResultType);
          Writeln('Request query: ' + Logs.RequestQuery);
          Writeln('Request limit: ' + IntToStr(Logs.RequestLimit));
          Writeln('Request start: ' + Logs.RequestStart);
          Writeln('Request end: ' + Logs.RequestEnd);
          Writeln('Streams count: ' + IntToStr(Logs.Results.Count));
          if Logs.StatisticsJson <> '' then
            Writeln('Statistics: ' + Logs.StatisticsJson);

          if Logs.Results.Count > 0 then
          begin
            var FirstResult := Logs.Results[0];
            Writeln('First stream host: ' + FirstResult.Host);
            Writeln('First stream container: ' + FirstResult.ContainerName);
            Writeln('First stream entries: ' + IntToStr(Length(FirstResult.Entries)));
          end;
          Writeln('----------');
        finally
          Logs.Free;
        end;
      end
      else
        Writeln('Logs response is not a JSON object.');
    finally
      JsonValue.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;

begin
  try
    try
//      ListSourceCreds();
//      ListRouterSource();
//    ListSummaryTaskTypes();
//    ListSummaryTasks();
    ListDSProcessorTasks();
    ListDSProcessorTaskSources();
//    ListStripTaskSources();
//    ListSummaryTaskSources();
//    ListMonitoringTaskSources();
//      ListProfiles();
//      ListContexts();
//      ListBindings();
//      ListAbonents();
//      ListAliases();
//      ListRules();
//      ListDsGroups();
//      ListUsers();

      // keep the console open until Enter is pressed
      Writeln('press enter to finish...');
      Readln;

    except
      on E: Exception do
        Writeln(E.ClassName, ': ', E.Message);
    end;

  finally
  end;
end.
