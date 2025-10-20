program SimpleEntityTest;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Math,
  System.JSON,
  System.DateUtils,
  SimpleEntityTest.Constants in 'SimpleEntityTest.Constants.pas',
  EntityUnit in '..\EntityClasses\Common\EntityUnit.pas',
  StringUnit in '..\EntityClasses\Common\StringUnit.pas',
  BindingUnit in '..\EntityClasses\dataserver\BindingUnit.pas',
  ContextUnit in '..\EntityClasses\dataserver\ContextUnit.pas',
  DataserieUnit in '..\EntityClasses\dataserver\DataserieUnit.pas',
  DsGroupUnit in '..\EntityClasses\dataserver\DsGroupUnit.pas',
  ProfileUnit in '..\EntityClasses\datacomm\ProfileUnit.pas',
  QueueUnit in '..\EntityClasses\router\QueueUnit.pas',
  RouterSourceUnit in '..\EntityClasses\router\RouterSourceUnit.pas',
  SourceCredsUnit in '..\EntityClasses\dataserver\SourceCredsUnit.pas',
  TaskUnit in '..\EntityClasses\Common\TaskUnit.pas',
  TaskSourceUnit in '..\EntityClasses\Common\TaskSourceUnit.pas',
  UserUnit in '..\EntityClasses\acl\UserUnit.pas',
  LoggingUnit in '..\Logging\LoggingUnit.pas',
  TextFileLoggerUnit in '..\Logging\TextFileLoggerUnit.pas',
  UniLoggerUnit in '..\Logging\UniLoggerUnit.pas',
  ConnectionSettingsUnit in '..\EntityClasses\links\ConnectionSettingsUnit.pas',
  DirSettingsUnit in '..\EntityClasses\links\DirSettingsUnit.pas',
  LinkSettingsUnit in '..\EntityClasses\links\LinkSettingsUnit.pas',
  LinkUnit in '..\EntityClasses\links\LinkUnit.pas',
  QueueSettingsUnit in '..\EntityClasses\links\QueueSettingsUnit.pas',
  S3SettingsUnit in '..\EntityClasses\links\S3SettingsUnit.pas',
  ScheduleSettingsUnit in '..\EntityClasses\links\ScheduleSettingsUnit.pas',
  ConstsUnit in '..\Common\ConstsUnit.pas',
  FuncUnit in '..\Common\FuncUnit.pas',
  KeyValUnit in '..\Common\KeyValUnit.pas',
  AbonentUnit in '..\EntityClasses\router\AbonentUnit.pas',
  AliasUnit in '..\EntityClasses\router\AliasUnit.pas',
  ChannelUnit in '..\EntityClasses\router\ChannelUnit.pas',
  RuleUnit in '..\EntityClasses\router\RuleUnit.pas',
  SmallRuleUnit in '..\EntityClasses\router\SmallRuleUnit.pas',
  FilterUnit in '..\EntityClasses\Common\FilterUnit.pas',
  ConditionUnit in '..\EntityClasses\Common\ConditionUnit.pas',
  GUIDListUnit in '..\EntityClasses\Common\GUIDListUnit.pas';

type
  ETestFailure = class(Exception);

function ParseJSONObject(const AJsonText: string): TJSONObject;
var
  Value: TJSONValue;
begin
  Value := TJSONObject.ParseJSONValue(AJsonText, False, True);
  if not Assigned(Value) then
    raise ETestFailure.Create('Не удалось разобрать JSON.');
  if not (Value is TJSONObject) then
  begin
    Value.Free;
    raise ETestFailure.Create('Ожидается JSON-объект.');
  end;
  Result := TJSONObject(Value);
end;

procedure Ensure(Condition: Boolean; const Msg: string);
begin
  try
    if not Condition then
      raise ETestFailure.Create(Msg);
  except on e:exception do
    begin
      Log('Ensure: '+ e.Message, lrtError);
      writeln('Ensure: '+ e.Message);
    end;
  end;
end;

procedure AssertJsonEqual(Expected, Actual: TJSONValue; const Path: string);
var
  I: Integer;
  Pair: TJSONPair;
  ActualValue: TJSONValue;
  NewPath: string;
  ExpectedNumber, ActualNumber: Double;
begin
  if not Assigned(Expected) then
  begin
    Ensure(not Assigned(Actual), Format('Ожидалось отсутствие значения в %s', [Path]));
    Exit;
  end;

  Ensure(Assigned(Actual), Format('Значение %s отсутствует', [Path]));

  if Expected is TJSONObject then
  begin
    Ensure(Actual is TJSONObject, Format('Ожидался объект в %s', [Path]));
    var ExpObj := TJSONObject(Expected);
    var ActObj := TJSONObject(Actual);
    Ensure(ExpObj.Count = ActObj.Count, Format('Количество полей в %s отличается', [Path]));
    for I := 0 to ExpObj.Count - 1 do
    begin
      Pair := ExpObj.Pairs[I];
      ActualValue := ActObj.GetValue(Pair.JsonString.Value);
      NewPath := Path;
      if NewPath <> '' then
        NewPath := NewPath + '.';
      NewPath := NewPath + Pair.JsonString.Value;
      Ensure(Assigned(ActualValue), Format('Поле %s отсутствует', [NewPath]));
      AssertJsonEqual(Pair.JsonValue, ActualValue, NewPath);
    end;
    Exit;
  end;

  if Expected is TJSONArray then
  begin
    Ensure(Actual is TJSONArray, Format('Ожидался массив в %s', [Path]));
    var ExpArr := TJSONArray(Expected);
    var ActArr := TJSONArray(Actual);
    Ensure(ExpArr.Count = ActArr.Count, Format('Количество элементов в %s отличается', [Path]));
    for I := 0 to ExpArr.Count - 1 do
    begin
      NewPath := Format('%s[%d]', [Path, I]);
      AssertJsonEqual(ExpArr.Items[I], ActArr.Items[I], NewPath);
    end;
    Exit;
  end;

  if (Expected is TJSONNumber) and (Actual is TJSONNumber) then
  begin
    ExpectedNumber := TJSONNumber(Expected).AsDouble;
    ActualNumber := TJSONNumber(Actual).AsDouble;
    Ensure(SameValue(ExpectedNumber, ActualNumber, 1E-6), Format('Числовое значение отличается в %s', [Path]));
    Exit;
  end;

  if (Expected is TJSONString) and (Actual is TJSONString) then
  begin
    Ensure(TJSONString(Expected).Value = TJSONString(Actual).Value,
      Format('Строковое значение отличается в %s', [Path]));
    Exit;
  end;

  if (Expected is TJSONBool) and (Actual is TJSONBool) then
  begin
    Ensure(TJSONBool(Expected).AsBoolean = TJSONBool(Actual).AsBoolean,
      Format('Логическое значение отличается в %s', [Path]));
    Exit;
  end;

  if (Expected is TJSONNull) and (Actual is TJSONNull) then
    Exit;

  Ensure(Expected.ToJSON = Actual.ToJSON, Format('Значение %s отличается', [Path]));
end;

procedure CompareSerialization(const EntityName: string; const Source: TJSONObject; const Entity: TEntity);
var
  Serialized: TJSONObject;
begin
  Serialized := Entity.Serialize;
  try
    AssertJsonEqual(Source, Serialized, EntityName);
  finally
    Serialized.Free;
  end;
end;

procedure AssertBaseScalars(const Entity: TEntity; const Json: TJSONObject;
  const IdKey, EntityName: string);
var
  CreatedValue, UpdatedValue, CommitedValue, ArchivedValue: Integer;
  ExpectedCreated, ExpectedUpdated, ExpectedCommited, ExpectedArchived: TDateTime;
begin
  Ensure(Entity.Id = GetValueStrDef(Json, IdKey, ''),
    Format('%s: неверное значение идентификатора', [EntityName]));
  Ensure(Entity.Name = GetValueStrDef(Json, 'name', ''),
    Format('%s: неверное поле name', [EntityName]));
  Ensure(Entity.Caption = GetValueStrDef(Json, 'caption', ''),
    Format('%s: неверное поле caption', [EntityName]));
  Ensure(Entity.Def = GetValueStrDef(Json, 'Def', ''),
    Format('%s: неверное поле Def', [EntityName]));
  Ensure(Entity.CompId = GetValueStrDef(Json, 'compid', ''),
    Format('%s: неверное поле compid', [EntityName]));
  Ensure(Entity.Owner = GetValueStrDef(Json, 'owner', ''),
    Format('%s: неверное поле owner', [EntityName]));
  Ensure(Entity.DepId = GetValueStrDef(Json, 'depid', ''),
    Format('%s: неверное поле depid', [EntityName]));
  Ensure(Entity.Enabled = GetValueBool(Json, 'enabled'),
    Format('%s: неверное поле enabled', [EntityName]));

  CreatedValue := GetValueIntDef(Json, 'created', 0);
  ExpectedCreated := UnixToDateTime(CreatedValue);
  Ensure(Abs(Entity.Created - ExpectedCreated) < (1 / 864000),
    Format('%s: неверное поле created', [EntityName]));

  UpdatedValue := GetValueIntDef(Json, 'updated', 0);
  ExpectedUpdated := UnixToDateTime(UpdatedValue);
  Ensure(Abs(Entity.Updated - ExpectedUpdated) < (1 / 864000),
    Format('%s: неверное поле updated', [EntityName]));

  CommitedValue := GetValueIntDef(Json, 'commited', 0);
  ExpectedCommited := UnixToDateTime(CommitedValue);
  Ensure(Abs(Entity.Commited - ExpectedCommited) < (1 / 864000),
    Format('%s: неверное поле commited', [EntityName]));

  ArchivedValue := GetValueIntDef(Json, 'archived', 0);
  ExpectedArchived := UnixToDateTime(ArchivedValue);
  Ensure(Abs(Entity.Archived - ExpectedArchived) < (1 / 864000),
    Format('%s: неверное поле archived', [EntityName]));
end;

procedure AssertStringListEquals(const List: TFieldSetStringList;
  const Expected: array of string; const Context: string);
var
  Values: TArray<string>;
  I: Integer;
begin
  Values := List.ToStringArray;
  Ensure(Length(Values) = Length(Expected),
    Format('%s: количество элементов %d вместо %d',
      [Context, Length(Values), Length(Expected)]));
  for I := 0 to High(Expected) do
    Ensure(Values[I] = Expected[I],
      Format('%s: значение[%d] = %s, ожидается %s',
      [Context, I, Values[I], Expected[I]]));
end;

procedure TestAbonent;
var
  Source, AttrExpected: TJSONObject;
  Entity: TAbonent;
  Channels: TArray<string>;
  SourceAttr: TJSONObject;
begin
  Writeln('--- Тест TAbonent ---');
  Source := ParseJSONObject(AbonentJson);
  try
    Entity := TAbonent.Create(Source);
    try
      AssertBaseScalars(Entity, Source, 'abid', 'TAbonent');
      Channels := Entity.Channels.ToStringArray;
      Ensure(Length(Channels) = 2, 'TAbonent: ожидаются два канала');
      Ensure(Channels[0] = 'channel-a', 'TAbonent: неверное значение первого канала');
      Ensure(Channels[1] = 'channel-b', 'TAbonent: неверное значение второго канала');

      AttrExpected := TJSONObject.Create;
      try
        Entity.Attr.Serialize(AttrExpected);
        SourceAttr := Source.GetValue('attr') as TJSONObject;
        Ensure(Assigned(SourceAttr), 'TAbonent: секция attr отсутствует');
        AssertJsonEqual(SourceAttr, AttrExpected, 'TAbonent.attr');
      finally
        AttrExpected.Free;
      end;

      CompareSerialization('TAbonent', Source, Entity);
    finally
      Entity.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestAlias;
var
  Source: TJSONObject;
  Entity: TAlias;
begin
  Writeln('--- Тест TAlias ---');
  Source := ParseJSONObject(AliasJson);
  try
    Entity := TAlias.Create(Source);
    try
      AssertBaseScalars(Entity, Source, 'alid', 'TAlias');
      Ensure(Entity.Channels.Count = 2, 'TAlias: ожидается два набора каналов');
      CompareSerialization('TAlias', Source, Entity);
    finally
      Entity.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestBinding;
var
  Source, DataObject, AttrObject: TJSONObject;
  Entity: TBinding;
  BindingData: TBindingData;
begin
  Writeln('--- Тест TBinding ---');
  Source := ParseJSONObject(BindingJson);
  try
    Entity := TBinding.Create(Source);
    try
      AssertBaseScalars(Entity, Source, 'bid', 'TBinding');
      Ensure(Entity.EntityId = 'entity-42', 'TBinding: неверное поле entity');
      Ensure(Entity.BindingType = 'meta', 'TBinding: неверное поле type');
      Ensure(Entity.Urn = 'urn:binding:42', 'TBinding: неверное поле urn');
      Ensure(Entity.Index = 'idx-1', 'TBinding: неверное поле index');

      BindingData := Entity.BindingData;
      Ensure(BindingData.Def = 'Binding definition', 'TBinding: неверное поле data.def');
      DataObject := Source.GetValue('data') as TJSONObject;
      Ensure(Assigned(DataObject), 'TBinding: отсутствует секция data');
      AttrObject := DataObject.GetValue('attr') as TJSONObject;
      Ensure(Assigned(AttrObject), 'TBinding: отсутствует секция data.attr');
      AssertJsonEqual(AttrObject, BindingData.Attr, 'TBinding.data.attr');

      CompareSerialization('TBinding', Source, Entity);
    finally
      Entity.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestChannel;
var
  Source: TJSONObject;
  Entity: TChannel;
begin
  Writeln('--- Тест TChannel ---');
  Source := ParseJSONObject(ChannelJson);
  try
    Entity := TChannel.Create(Source);
    try
      AssertBaseScalars(Entity, Source, 'id', 'TChannel');
      Ensure(Entity.Chid = 'channel-001', 'TChannel: неверное поле id');
      CompareSerialization('TChannel', Source, Entity);
    finally
      Entity.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestContext;
var
  Source, DataValue: TJSONObject;
  Entity: TContext;
begin
  Writeln('--- Тест TContext ---');
  Source := ParseJSONObject(ContextJson);
  try
    Entity := TContext.Create(Source);
    try
      AssertBaseScalars(Entity, Source, 'ctxid', 'TContext');
      Ensure(Entity.CtxtId = 'ctxt-001', 'TContext: неверное поле ctxtid');
      Ensure(Entity.Sid = 'source-01', 'TContext: неверное поле sid');
      Ensure(Entity.Index = 'index-01', 'TContext: неверное поле index');
      DataValue := Source.GetValue('data') as TJSONObject;
      Ensure(Assigned(DataValue), 'TContext: отсутствует секция data');
      AssertJsonEqual(DataValue, Entity.Data, 'TContext.data');
      CompareSerialization('TContext', Source, Entity);
    finally
      Entity.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestDataserie;
var
  Source, LastDataValue: TJSONObject;
  Entity: TDataserie;
begin
  Writeln('--- Тест TDataserie ---');
  Source := ParseJSONObject(DataserieJson);
  try
    Entity := TDataserie.Create(Source);
    try
      AssertBaseScalars(Entity, Source, 'dsid', 'TDataserie');
      Ensure(Entity.Mid = 'measure-1', 'TDataserie: неверное поле mid');
      Ensure(Abs(Entity.LastInsert - UnixToDateTime(1700001111)) < (1 / 864000),
        'TDataserie: неверное поле last_insert');
      LastDataValue := Source.GetValue('lastData') as TJSONObject;
      Ensure(Assigned(LastDataValue), 'TDataserie: отсутствует поле lastData');
      AssertJsonEqual(LastDataValue, Entity.LastData, 'TDataserie.lastData');
      CompareSerialization('TDataserie', Source, Entity);
    finally
      Entity.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestDsGroup;
var
  Source, MetadataValue, DataseriesValue: TJSONObject;
  Entity: TDsGroup;
  Serie: TDataserie;
begin
  Writeln('--- Тест TDsGroup ---');
  Source := ParseJSONObject(DsGroupJson);
  try
    Entity := TDsGroup.Create(Source);
    try
      AssertBaseScalars(Entity, Source, 'dsgid', 'TDsGroup');
      Ensure(Entity.Pdsgid = 'parent-01', 'TDsGroup: неверное поле pdsgid');
      Ensure(Entity.Ctxid = 'ctx-001', 'TDsGroup: неверное поле ctxid');
      Ensure(Entity.Sid = 'source-01', 'TDsGroup: неверное поле sid');

      MetadataValue := Source.GetValue('metadata') as TJSONObject;
      Ensure(Assigned(MetadataValue), 'TDsGroup: отсутствует metadata');
      AssertJsonEqual(MetadataValue, Entity.Metadata, 'TDsGroup.metadata');

      DataseriesValue := Source.GetValue('dataseries') as TJSONObject;
      Ensure(Assigned(DataseriesValue), 'TDsGroup: отсутствует dataseries');
      Ensure(Entity.DataseriesCount = 1, 'TDsGroup: неверное поле dataseries.count');
      Ensure(Entity.Dataseries.Count = 1, 'TDsGroup: неверное количество элементов dataseries');
      if Entity.Dataseries.Count > 0 then
      begin
        Serie := Entity.Dataseries.Items[0] as TDataserie;
        Ensure(Assigned(Serie), 'TDsGroup: элемент dataseries[0] не загружен');
        Ensure(Serie.Dsid = 'ds-101', 'TDsGroup: неверное значение дочерней серии');
      end;

      CompareSerialization('TDsGroup', Source, Entity);
    finally
      Entity.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestLink;
var
  Source: TJSONObject;
  Entity: TLink;
  LinkData: TLinkData;
begin
  Writeln('--- Тест TLink ---');
  Source := ParseJSONObject(LinkJson);
  try
    Entity := TLink.Create(Source);
    try
      AssertBaseScalars(Entity, Source, 'lid', 'TLink');
      Ensure(Entity.LinkType = ltUnknown, 'TLink: неверный тип');
      Ensure(Entity.Dir = 'duplex', 'TLink: неверное поле dir');
      Ensure(Entity.Status = 'running', 'TLink: неверное поле status');
      Ensure(Entity.Comsts = 'connected', 'TLink: неверное поле comsts');
      Ensure(Entity.LastActivityTime = 1700000400, 'TLink: неверное поле last_activity_time');

      LinkData := Entity.Data as TLinkData;
      Ensure(LinkData.Autostart, 'TLink: неверное поле data.autostart');
      Ensure(LinkData.Snapshot = 'snapshot-data', 'TLink: неверное поле data.snapshot');
      Ensure(LinkData.LinkTypeStr = 'UNKNOWN', 'TLink: неверное текстовое представление типа');

      CompareSerialization('TLink', Source, Entity);
    finally
      Entity.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestProfile;
var
  Source: TJSONObject;
  Entity: TProfile;
  Body: TProfileBody;
  RuleObject, BodyObject: TJSONObject;
begin
  Writeln('--- Тест TProfile ---');
  Source := ParseJSONObject(ProfileJson);
  try
    Entity := TProfile.Create(Source);
    try
      AssertBaseScalars(Entity, Source, 'prid', 'TProfile');
      Ensure(Entity.Description = 'Profile description', 'TProfile: неверное поле descr');

      Body := Entity.ProfileBody;
      Ensure(Assigned(Body), 'TProfile: тело профиля не создано');
      Ensure(Assigned(Body.Rule), 'TProfile: правило отсутствует');
      Ensure(not Body.Rule.Doubles, 'TProfile: неверное поле rule.doubles');
      Ensure(Body.Rule.Priority = 2, 'TProfile: неверное поле rule.priority');
      AssertStringListEquals(Body.Rule.Handlers, ['handler1'], 'TProfile: rule.handlers');
      Ensure(Assigned(Body.Play), 'TProfile: блок воспроизведения отсутствует');
      Ensure(Body.Play.FTA.Name = 'day', 'TProfile: неверное имя FTA');
      AssertStringListEquals(Body.Play.FTA.Values, ['mon', 'tue'], 'TProfile: FTA.values');

      BodyObject := Source.GetValue('body') as TJSONObject;
      Ensure(Assigned(BodyObject), 'TProfile: отсутствует секция body');
      RuleObject := BodyObject.GetValue('rule') as TJSONObject;
      Ensure(Assigned(RuleObject), 'TProfile: отсутствует секция body.rule');
      var RuleSerialized := Body.Rule.Serialize;
      try
        AssertJsonEqual(RuleObject, RuleSerialized, 'TProfile.body.rule');
      finally
        RuleSerialized.Free;
      end;

      CompareSerialization('TProfile', Source, Entity);
    finally
      Entity.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestQueue;
var
  Source: TJSONObject;
  Entity: TQueue;
begin
  Writeln('--- Тест TQueue ---');
  Source := ParseJSONObject(QueueJson);
  try
    Entity := TQueue.Create(Source);
    try
      AssertBaseScalars(Entity, Source, 'qid', 'TQueue');
      Ensure(Entity.Uid = 'uid-001', 'TQueue: неверное поле uid');
      CompareSerialization('TQueue', Source, Entity);
    finally
      Entity.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestRouterSource;
var
  Source: TJSONObject;
  Entity: TRouterSource;
begin
  Writeln('--- Тест TRouterSource ---');
  Source := ParseJSONObject(RouterSourceJson);
  try
    Entity := TRouterSource.Create(Source);
    try
      AssertBaseScalars(Entity, Source, 'who', 'TRouterSource');
      Ensure(Entity.SvcId = 'svc-001', 'TRouterSource: неверное поле svcid');
      Ensure(Entity.Lid = 'lid-001', 'TRouterSource: неверное поле lid');
      CompareSerialization('TRouterSource', Source, Entity);
    finally
      Entity.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestRule;
var
  Source, RuleValue: TJSONObject;
  Entity: TRule;
begin
  Writeln('--- Тест TRule ---');
  Source := ParseJSONObject(RuleJson);
  try
    Entity := TRule.Create(Source);
    try
      AssertBaseScalars(Entity, Source, 'ruid', 'TRule');
      RuleValue := Source.GetValue('rule') as TJSONObject;
      Ensure(Assigned(RuleValue), 'TRule: отсутствует секция rule');
      var RuleSerialized := Entity.Rule.Serialize;
      try
        AssertJsonEqual(RuleValue, RuleSerialized, 'TRule.rule');
      finally
        RuleSerialized.Free;
      end;
      CompareSerialization('TRule', Source, Entity);
    finally
      Entity.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestSourceCreds;
var
  Source, DataObject: TJSONObject;
  Entity: TSourceCreds;
  SourceData: TJSONObject;
begin
  Writeln('--- Тест TSourceCreds ---');
  Source := ParseJSONObject(SourceCredsJson);
  try
    Entity := TSourceCreds.Create(Source);
    try
      AssertBaseScalars(Entity, Source, 'crid', 'TSourceCreds');
      Ensure(Entity.CtxId = 'ctx-777', 'TSourceCreds: неверное поле ctxid');
      Ensure(Entity.Lid = 'link-777', 'TSourceCreds: неверное поле lid');
      Ensure(Entity.Login = 'user', 'TSourceCreds: неверное поле login');
      Ensure(Entity.Pass = 'secret', 'TSourceCreds: неверное поле pass');

      SourceData := Source.GetValue('data') as TJSONObject;
      Ensure(Assigned(SourceData), 'TSourceCreds: отсутствует секция data');
      Ensure(Entity.SourceData.Def = 'Credentials definition', 'TSourceCreds: неверное поле data.def');

      CompareSerialization('TSourceCreds', Source, Entity);
    finally
      Entity.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestTask;
var
  Source: TJSONObject;
  Entity: TTask;
begin
  Writeln('--- Тест TTask ---');
  Source := ParseJSONObject(TaskJson);
  try
    Entity := TTask.Create(Source);
    try
      AssertBaseScalars(Entity, Source, 'tid', 'TTask');
      Ensure(Entity.Module = 'task.module', 'TTask: неверное поле module');
      CompareSerialization('TTask', Source, Entity);
    finally
      Entity.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestTaskSource;
var
  Source: TJSONObject;
  Entity: TTaskSource;
begin
  Writeln('--- Тест TTaskSource ---');
  Source := ParseJSONObject(TaskSourceJson);
  try
    Entity := TTaskSource.Create(Source);
    try
      AssertBaseScalars(Entity, Source, 'sid', 'TTaskSource');
      Ensure(Entity.StationIndex = 'station-01', 'TTaskSource: неверное поле index');
      CompareSerialization('TTaskSource', Source, Entity);
    finally
      Entity.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TestUser;
var
  Source, GroupBodyValue: TJSONObject;
  Entity: TUser;
  GuidValue: TGUID;
  BodyObj: TJSONObject;
begin
  Writeln('--- Тест TUser ---');
  Source := ParseJSONObject(UserJson);
  try
    Entity := TUser.Create(Source);
    try
      AssertBaseScalars(Entity, Source, 'usid', 'TUser');
      Ensure(Entity.Gid = 'group-01', 'TUser: неверное поле gid');
      Ensure(Entity.Email = 'user@example.com', 'TUser: неверное поле email');
      Ensure(Entity.Country = 'Wonderland', 'TUser: неверное поле country');
      Ensure(Entity.Org = 'Example Org', 'TUser: неверное поле org');
      Ensure(Entity.UserData.Def = 'User data definition', 'TUser: неверное поле data.def');

      Ensure(Entity.AllowComp.Count = 1, 'TUser: неверное количество allowcomp');
      if Entity.AllowComp.Count > 0 then
      begin
        GuidValue := Entity.AllowComp[0];
        Ensure(SameText(GUIDToString(GuidValue), '{12345678-1234-1234-1234-1234567890AB}'),
          'TUser: неверное значение allowcomp[0]');
      end;

      AssertStringListEquals(Entity.UserBody.Roles, ['user'], 'TUser.body.roles');
      AssertStringListEquals(Entity.UserBody.Datasets, ['dataset-a'], 'TUser.body.datasets');
      AssertStringListEquals(Entity.UserBody.Levels, ['level-a'], 'TUser.body.levels');

      GroupBodyValue := Source.GetValue('group.body') as TJSONObject;
      Ensure(Assigned(GroupBodyValue), 'TUser: отсутствует секция group.body');
      BodyObj := Entity.GroupBody.Serialize;
      try
        AssertJsonEqual(GroupBodyValue, BodyObj, 'TUser.group.body');
      finally
        BodyObj.Free;
      end;

      CompareSerialization('TUser', Source, Entity);
    finally
      Entity.Free;
    end;
  finally
    Source.Free;
  end;
end;

begin
  ReportMemoryLeaksOnShutdown := True;
  try
    TestAbonent;
    TestAlias;
    TestBinding;
    TestChannel;
    TestContext;
    TestDataserie;
    TestDsGroup;
    TestLink;
    TestProfile;
    TestQueue;
    TestRouterSource;
    TestRule;
    TestSourceCreds;
    TestTask;
    TestTaskSource;
    TestUser;
    Writeln('Все тесты успешно выполнены. Нажмите Enter.');
    Readln;
  except
    on E: Exception do
    begin
      Writeln(E.ClassName + ': ' + E.Message);
      Halt(1);
    end;
  end;
end.
