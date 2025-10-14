program EntityTestProj;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.JSON,
  APIConst in '..\APIClasses\APIConst.pas',
  ChannelsBrokerUnit in '..\APIClasses\ChannelsBrokerUnit.pas',
  LinksBrokerUnit in '..\APIClasses\LinksBrokerUnit.pas',
  MainHttpModuleUnit in '..\APIClasses\MainHttpModuleUnit.pas',
  MonitoringTasksBrokerUnit in '..\APIClasses\MonitoringTasksBrokerUnit.pas',
  ParentBrokerUnit in '..\APIClasses\ParentBrokerUnit.pas',
  QueuesBrokerUnit in '..\APIClasses\QueuesBrokerUnit.pas',
  UsersBrokerUnit in '..\APIClasses\UsersBrokerUnit.pas',
  SourceCredsBrokerUnit in '..\APIClasses\SourceCredsBrokerUnit.pas',
  DsGroupsBrokerUnit in '..\APIClasses\DsGroupsBrokerUnit.pas',
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
  GUIDListUnit in '..\EntityClasses\Common\GUIDListUnit.pas',
  LinkSettingsUnit in '..\EntityClasses\links\LinkSettingsUnit.pas',
  LinkUnit in '..\EntityClasses\links\LinkUnit.pas',
  MonitoringTaskUnit in '..\EntityClasses\monitoring\MonitoringTaskUnit.pas',
  ChannelUnit in '..\EntityClasses\router\ChannelUnit.pas',
  QueueUnit in '..\EntityClasses\router\QueueUnit.pas',
  RouterSourceUnit in '..\EntityClasses\router\RouterSourceUnit.pas',
  UserUnit in '..\EntityClasses\acl\UserUnit.pas',
  SourceCredsUnit in '..\EntityClasses\dataserver\SourceCredsUnit.pas',
  TDsGroupUnit in '..\EntityClasses\dataserver\TDsGroupUnit.pas',
  StripTaskUnit in '..\EntityClasses\strips\StripTaskUnit.pas',
  SummaryTaskUnit in '..\EntityClasses\summary\SummaryTaskUnit.pas';


procedure ListSourceCreds();
procedure ListRouterSource();
procedure ListUsers();
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


begin
  try
    try
//      ListSourceCreds();
//      ListRouterSource();
      ListDsGroups();
      ListUsers();

      // оставить консоль незакрытой до нажатия Enter
      Writeln('press enter to finish...');
      Readln;

    except
      on E: Exception do
        Writeln(E.ClassName, ': ', E.Message);
    end;

  finally
  end;
end;

end.
