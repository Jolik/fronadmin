unit Main;

interface

uses
  Windows, Messages, System.SysUtils, Variants, Classes, Graphics,
  Generics.Collections, System.JSON,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, uniButton, uniGUIBaseClasses,
  uniMemo,
  LinksBrokerUnit, EntityUnit, LinkUnit,
  StripTasksBrokerUnit, StripTaskUnit,
  SummaryTasksBrokerUnit, SummaryTaskUnit,
  MonitoringTasksBrokerUnit, MonitoringTaskUnit,
  QueuesBrokerUnit, QueueUnit, uniPanel, uniSplitter, uniEdit, uniGroupBox,
  uniScrollBox;

type
  TMainForm = class(TUniForm)
    ShowMemo: TUniMemo;
    sbTestButtons: TUniScrollBox;
    gbLinks: TUniGroupBox;
    btnLinskList: TUniButton;
    btnLinkInfo: TUniButton;
    gbQueues: TUniGroupBox;
    btnQueuesList: TUniButton;
    btnQueuesInfo: TUniButton;
    gbStripTasks: TUniGroupBox;
    btnStripTaskList: TUniButton;
    btnStripTaskInfo: TUniButton;
    btnStripTaskNew: TUniButton;
    btnStripTaskUpdate: TUniButton;
    btnStripTaskRemove: TUniButton;
    gbSummaryTasks: TUniGroupBox;
    btnSummaryTaskList: TUniButton;
    btnSummaryTaskInfo: TUniButton;
    btnSummaryTaskNew: TUniButton;
    btnSummaryTaskUpdate: TUniButton;
    btnSummaryTaskRemove: TUniButton;
    btnSummaryTaskTypes: TUniButton;
    btnStripTasks: TUniButton;
    btnLinkSettings: TUniButton;
    btnSummaryTasks: TUniButton;
    procedure btnLinskListClick(Sender: TObject);
    procedure btnLinkInfoClick(Sender: TObject);
    procedure btnStripTaskListClick(Sender: TObject);
    procedure btnStripTaskInfoClick(Sender: TObject);
    procedure btnStripTaskNewClick(Sender: TObject);
    procedure btnStripTaskRemoveClick(Sender: TObject);
    procedure btnStripTaskUpdateClick(Sender: TObject);
    procedure btnSummaryTaskListClick(Sender: TObject);
    procedure btnSummaryTaskInfoClick(Sender: TObject);
    procedure btnSummaryTaskNewClick(Sender: TObject);
    procedure btnSummaryTaskUpdateClick(Sender: TObject);
    procedure btnSummaryTaskRemoveClick(Sender: TObject);
    procedure btnSummaryTaskTypesClick(Sender: TObject);
    procedure btnMonTaskListClick(Sender: TObject);
    procedure btnMonTaskInfoClick(Sender: TObject);
    procedure btnQueuesListClick(Sender: TObject);
    procedure btnQueuesInfoClick(Sender: TObject);
    procedure btnStripTasksClick(Sender: TObject);
    procedure btnLinkSettingsClick(Sender: TObject);
    procedure btnSummaryTasksClick(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure UpdateLinkSettingsCallback(ASender: TComponent; AResult: Integer);
  public
    { Public declarations }
  end;

function MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, uniGUIApplication,
  uniGUIVars, MainModule, uniGUIApplication, StripTasksFormUnit, SummaryTasksFormUnit;
  LinkSettingsUnit, ParentLinkSettingEditFrameUnit,
  ParentEditFormUnit, SocketSpecialSettingEditFrameUnit,
  StripTasksFormUnit;

function MainForm: TMainForm;
begin
  Result := TMainForm(UniMainModule.GetFormInstance(TMainForm));
end;

procedure TMainForm.btnMonTaskInfoClick(Sender: TObject);
const
  tid = '088a1eb4-85b4-11f0-ab53-02420a0001c1';
var
  MonitoringTask : TEntity;
  MonitoringTasksBroker : TMonitoringTasksBroker;
begin
  MonitoringTask := nil;
  MonitoringTasksBroker := nil;
  try
    MonitoringTasksBroker := TMonitoringTasksBroker.Create();

    ShowMemo.Lines.Add('----------  Monitoring.Info  ----------');
    ShowMemo.Lines.Add(Format('   %s:', [tid]));

    MonitoringTask := MonitoringTasksBroker.Info(tid);
    if MonitoringTask = nil then
    begin
      ShowMemo.Lines.Add('nil');
      Exit;
    end;

    var st := MonitoringTask as TMonitoringTask;
    ShowMemo.Lines.Add('Tid: ' + st.Tid);
    ShowMemo.Lines.Add('Name: ' + st.Name);
    ShowMemo.Lines.Add('Module: ' + st.Module);
    if st.Enabled then
      ShowMemo.Lines.Add('Enabled: true')
    else
      ShowMemo.Lines.Add('Enabled: false');
    ShowMemo.Lines.Add('Settings:');
    ShowMemo.Lines.Add(st.settings.JSON);

  finally
    MonitoringTask.Free;
    MonitoringTasksBroker.Free;
  end;
end;

procedure TMainForm.btnMonTaskListClick(Sender: TObject);
var
  MonitoringTask : TEntity;
  MonitoringTasksBroker : TMonitoringTasksBroker;
  MonitoringTaskList : TEntityList;
  Pages : integer;
begin
  try
    MonitoringTasksBroker := TMonitoringTasksBroker.Create();

    MonitoringTaskList := MonitoringTasksBroker.List(Pages);

    // Выводим информацию о каждом объекте в TMemo
    ShowMemo.Lines.Add('----------  List  ----------');
    ShowMemo.Lines.Add('Содержимое списка:');

    for MonitoringTask in MonitoringTaskList do
    begin
      var st := (MonitoringTask as TMonitoringTask);
      ShowMemo.Lines.Add(Format('Класс: %s  |  Адрес: %p', [MonitoringTask.ClassName, Pointer(MonitoringTask)]));
      ShowMemo.Lines.Add('Id '+ st.Id);
      ShowMemo.Lines.Add('Name '+ st.Name);
      ShowMemo.Lines.Add('Compid '+ (st.Compid));
      ShowMemo.Lines.Add('Depid '+ (st.Depid));

      ShowMemo.Lines.Add('as json:');

      var json := st.Serialize();

      if json <> nil then
        ShowMemo.Lines.Add(json.Format());

      ShowMemo.Lines.Add('----------');
    end;

  finally
    // Освобождаем список (все объекты освободятся автоматически)
    MonitoringTaskList.Free;

    MonitoringTasksBroker.Free;
  end;
end;

{$REGION 'Links'}


procedure TMainForm.btnLinskListClick(Sender: TObject);
var
  Link : TEntity;
  LinksBroker : TLinksBroker;
  LinksList : TEntityList;
  Pages : integer;
begin
  ShowMemo.Clear;

  try
    LinksBroker := TLinksBroker.Create();

    LinksList := LinksBroker.List(Pages);

    // Выводим информацию о каждом объекте в TMemo
    ShowMemo.Lines.Add('----------  List  ----------');
    ShowMemo.Lines.Add('Содержимое списка:');

    if not Assigned(LinksList) then
    begin
      ShowMemo.Lines.Add('пусто');
      Exit;
    end;

    for Link in LinksList do
    begin
      var l := (Link as TLink);
      ShowMemo.Lines.Add(Format('Класс: %s  |  Адрес: %p', [Link.ClassName, Pointer(Link)]));
      ShowMemo.Lines.Add('Id '+ l.Id);
      ShowMemo.Lines.Add('Name '+ l.Name);
      ShowMemo.Lines.Add('Compid '+ (l.Compid));
      ShowMemo.Lines.Add('Depid '+ (l.Depid));

      ShowMemo.Lines.Add('as json:');

      var json := l.Serialize();

      if json <> nil then
        ShowMemo.Lines.Add(json.Format());

      ShowMemo.Lines.Add('----------');
    end;

  finally
    // Освобождаем список (все объекты освободятся автоматически)
    LinksList.Free;

    LinksBroker.Free;
  end;
end;

procedure TMainForm.btnLinkInfoClick(Sender: TObject);
const
  lid = '83789614-a334-4953-afaf-34093c8b43e4';
var
  Link : TEntity;
  LinksBroker : TLinksBroker;
begin
  ShowMemo.Clear;
  LinksBroker := TLinksBroker.Create();
  try
    // Выводим информацию о линке в TMemo
    ShowMemo.Lines.Add(Format('Информация о линке %s:', [lid]));
    // получаем инфу о линке
    Link := LinksBroker.Info(lid);
    if Link = nil then
    begin
      ShowMemo.Lines.Add('link not found');
      exit;
    end;

    var l := Link as TLink;
    ShowMemo.Lines.Add('Id '+ l.Id);
    ShowMemo.Lines.Add('TypeStr '+ l.TypeStr);
    ShowMemo.Lines.Add('Name '+ l.Name);
    ShowMemo.Lines.Add('Dir '+ l.Dir);
    ShowMemo.Lines.Add('Status '+ l.Status);
    ShowMemo.Lines.Add('Comsts '+ l.Comsts);
    ShowMemo.Lines.Add('Compid '+ l.Compid);
    ShowMemo.Lines.Add('Depid '+ l.Depid);
    ShowMemo.Lines.Add('as json:');
    var json := l.Serialize();
    if json <> nil then
      ShowMemo.Lines.Add(json.Format());
  finally
    LinksBroker.Free;
  end;
end;

procedure TMainForm.btnLinkSettingsClick(Sender: TObject);
const
  lid = '83789614-a334-4953-afaf-34093c8b43e4';
var
  LinksBroker : TLinksBroker;
  SettingsFrame: TParentLinkSettingEditFrame;
begin
  LinksBroker := TLinksBroker.Create();
  try
    var entity := LinksBroker.Info(lid);
    if entity = nil then
    begin
      ShowMemo.Lines.Add('link not found');
      exit;
    end;

    ParentEditForm.Entity := entity;
    var link := entity as TLink;
    case Link.linkType of
      ltSocketSpecial:
        SettingsFrame := TSocketSpecialSettingEditFrame.Create(ParentEditForm);
      else exit;
    end;

    SettingsFrame.DataSettings := (Link.Data as TLinkData).DataSettings;
    SettingsFrame.Parent := ParentEditForm.pnClient;
    ParentEditForm.ShowModal(UpdateLinkSettingsCallback);

  finally
    LinksBroker.Free;
  end;
end;


procedure TMainForm.UpdateLinkSettingsCallback(ASender: TComponent;
  AResult: Integer);
begin
  ShowMemo.Clear;
  if AResult <> mrOk then
  begin
    ShowMemo.Lines.Add('canceled');
    exit;
  end;
  var e := (ASender as TParentEditForm).Entity;
  if not (e is TLink) then
    exit;

  var json := (e as TLink).Serialize();
  if json <> nil then
    ShowMemo.Lines.Add(json.Format());

end;



{$ENDREGION 'Links'}

{$REGION 'Queues'}

procedure TMainForm.btnQueuesListClick(Sender: TObject);
var
  Queue : TEntity;
  QueuesBroker : TQueuesBroker;
  QueueList : TEntityList;
  Pages : integer;
begin
  ShowMemo.Clear;

  try
    QueuesBroker := TQueuesBroker.Create();

    QueueList := QueuesBroker.List(Pages);

    // Выводим информацию о каждом объекте в TMemo
    ShowMemo.Lines.Add('----------  List  ----------');
    ShowMemo.Lines.Add('Содержимое списка:');

    if not Assigned(QueueList) then
    begin
      ShowMemo.Lines.Add('пусто');
      Exit;
    end;

    for Queue in QueueList do
    begin
      var st := (Queue as TQueue);
      ShowMemo.Lines.Add(Format('Класс: %s  |  Адрес: %p', [Queue.ClassName, Pointer(Queue)]));
      ShowMemo.Lines.Add('Id '+ st.Id);
      ShowMemo.Lines.Add('Name '+ st.Name);
      ShowMemo.Lines.Add('Compid '+ (st.Compid));
      ShowMemo.Lines.Add('Depid '+ (st.Depid));

      ShowMemo.Lines.Add('as json:');

      var json := st.Serialize();

      if json <> nil then
        ShowMemo.Lines.Add(json.Format());

      ShowMemo.Lines.Add('----------');
    end;

  finally
    // Освобождаем список (все объекты освободятся автоматически)
    QueueList.Free;

    QueuesBroker.Free;
  end;
end;

procedure TMainForm.btnQueuesInfoClick(Sender: TObject);
const
  qid = 'fbeca202-f844-11ef-bf6c-02420a000125';
var
  Queue : TEntity;
  QueuesBroker : TQueuesBroker;
begin
  ShowMemo.Clear;

  Queue := nil;
  QueuesBroker := nil;
  try
    QueuesBroker := TQueuesBroker.Create();

    ShowMemo.Lines.Add('----------  queue.Info  ----------');
    ShowMemo.Lines.Add(Format('   %s:', [qid]));

    Queue := QueuesBroker.Info(qid);
    if Queue = nil then
    begin
      ShowMemo.Lines.Add('nil');
      Exit;
    end;

    var q := Queue as TQueue;
    ShowMemo.Lines.Add('Qid: ' + q.qid);
    ShowMemo.Lines.Add('Name: ' + q.Name);
    ShowMemo.Lines.Add('Uid: ' + q.uid);
    if q.Enabled then
      ShowMemo.Lines.Add('Enabled: true')
    else
      ShowMemo.Lines.Add('Enabled: false');

  finally
    Queue.Free;
    QueuesBroker.Free;
  end;
end;

{$ENDREGION 'Queues'}

{$REGION 'Strip.Tasks'}

procedure TMainForm.btnStripTasksClick(Sender: TObject);
begin
  StripTasksForm.Show();
end;

procedure TMainForm.btnStripTaskListClick(Sender: TObject);
var
  StripTask : TEntity;
  StripTasksBroker : TStripTasksBroker;
  StripTaskList : TEntityList;
  Pages : integer;

begin
  ShowMemo.Clear;

  try
    StripTasksBroker := TStripTasksBroker.Create();

    StripTaskList := StripTasksBroker.List(Pages);

    // Выводим информацию о каждом объекте в TMemo
    ShowMemo.Lines.Add('----------  List  ----------');
    ShowMemo.Lines.Add('Содержимое списка:');

    if not Assigned(StripTaskList) then
    begin
      ShowMemo.Lines.Add('пусто');
      Exit;
    end;

    for StripTask in StripTaskList do
    begin
      var st := (StripTask as TStripTask);
      ShowMemo.Lines.Add(Format('Класс: %s  |  Адрес: %p', [StripTask.ClassName, Pointer(StripTask)]));
      ShowMemo.Lines.Add('Id '+ st.Id);
      ShowMemo.Lines.Add('Name '+ st.Name);
      ShowMemo.Lines.Add('Compid '+ (st.Compid));
      ShowMemo.Lines.Add('Depid '+ (st.Depid));

      ShowMemo.Lines.Add('as json:');

      var json := st.Serialize();

      if json <> nil then
        ShowMemo.Lines.Add(json.Format());

      ShowMemo.Lines.Add('----------');
    end;

  finally
    // Освобождаем список (все объекты освободятся автоматически)
    StripTaskList.Free;

    StripTasksBroker.Free;
  end;
end;

procedure TMainForm.btnStripTaskInfoClick(Sender: TObject);
const
  tid = 'aec62ec1-8869-4c78-8009-63fad7525c78';
var
  StripTask : TEntity;
  StripTasksBroker : TStripTasksBroker;
begin
  ShowMemo.Clear;

  try
    StripTasksBroker := TStripTasksBroker.Create();
    // Выводим информацию о таске в TMemo
    ShowMemo.Lines.Add('----------  Info  ----------');
    ShowMemo.Lines.Add(Format('Информация о Задаче %s:', [tid]));
    // получаем инфу о таске
    StripTask := StripTasksBroker.Info(tid);
    if StripTask = nil then
    begin
      ShowMemo.Lines.Add('nil');
      exit;
    end;

    var st := StripTask as TStripTask;

    ShowMemo.Lines.Add('Tid: '+ st.Tid);
    ShowMemo.Lines.Add('Name: '+ st.Name);
    ShowMemo.Lines.Add('Caption: '+ st.Caption);
    ShowMemo.Lines.Add('CompId: '+ st.CompId);
    ShowMemo.Lines.Add('DepId: '+ st.DepId);
    ShowMemo.Lines.Add('Def: '+ st.Def);
//    ShowMemo.Lines.Add('Enabled: '+ BoolToString(st.Enabled));
    ShowMemo.Lines.Add('Module: '+ st.Module);
//    ShowMemo.Lines.Add('Created: '+ DateTimeToString(st.Created));
 //   ShowMemo.Lines.Add('Updated: '+ DateTimeToString(st.Updated));

  finally
    StripTasksBroker.Free;
  end;
end;

procedure TMainForm.btnStripTaskNewClick(Sender: TObject);
var
  st : TStripTask;
  StripTasksBroker : TStripTasksBroker;
  res : boolean;
begin
  ShowMemo.Clear;

  try
    StripTasksBroker := TStripTasksBroker.Create();

    st := TStripTask.Create();
    with st do
    begin
      Name := 'First test';
      Caption := 'First test';
      Module := 'StripXML';
      Enabled := false;
    end;

    // Выводим информацию о таске в TMemo
    ShowMemo.Lines.Add('----------  New  ----------');
    ShowMemo.Lines.Add(Format('Информация о Задаче %s:', [st.tid]));

    // получаем инфу о таске
    res := StripTasksBroker.New(st);
    if not res  then
    begin
      ShowMemo.Lines.Add('Error to new!');
      exit;
    end;

    (*
    ///  получаем результат и запрашиваем информацию по tid из результата

    ShowMemo.Lines.Add('Tid: '+ st.Tid);
    ShowMemo.Lines.Add('Name: '+ st.Name);
    ShowMemo.Lines.Add('Caption: '+ st.Caption);
    ShowMemo.Lines.Add('CompId: '+ st.CompId);
    ShowMemo.Lines.Add('DepId: '+ st.DepId);
    ShowMemo.Lines.Add('Def: '+ st.Def);
//    ShowMemo.Lines.Add('Enabled: '+ BoolToString(st.Enabled));
    ShowMemo.Lines.Add('Module: '+ st.Module);
//    ShowMemo.Lines.Add('Created: '+ DateTimeToString(st.Created));
 //   ShowMemo.Lines.Add('Updated: '+ DateTimeToString(st.Updated));
 *)

  finally
    StripTasksBroker.Free;
  end;
end;

procedure TMainForm.btnStripTaskUpdateClick(Sender: TObject);
const
  uuid = 'aec62ec1-8869-4c78-8009-63fad7525c78';
var
  st : TStripTask;
  StripTasksBroker : TStripTasksBroker;
  res : boolean;
begin
  ShowMemo.Clear;

  try
    StripTasksBroker := TStripTasksBroker.Create();

    st := TStripTask.Create();
    with st do
    begin
      id := uuid;
      Name := 'First test update';
      Caption := 'First test update';
    end;

    // Выводим информацию о таске в TMemo
    ShowMemo.Lines.Add('----------  Update  ----------');
    ShowMemo.Lines.Add(Format('Информация о Задаче %s:', [st.tid]));

    // Обновлеем информацию
    res := StripTasksBroker.Update(st);
    if not res  then
    begin
      ShowMemo.Lines.Add('Error to Update!');
      exit;
    end;

    ///  получаем результат и запрашиваем информацию по tid из результата

    ShowMemo.Lines.Add('Tid: '+ st.Tid);
    ShowMemo.Lines.Add('Name: '+ st.Name);
    ShowMemo.Lines.Add('Caption: '+ st.Caption);
    ShowMemo.Lines.Add('CompId: '+ st.CompId);
    ShowMemo.Lines.Add('DepId: '+ st.DepId);
    ShowMemo.Lines.Add('Def: '+ st.Def);
//    ShowMemo.Lines.Add('Enabled: '+ BoolToString(st.Enabled));
    ShowMemo.Lines.Add('Module: '+ st.Module);
//    ShowMemo.Lines.Add('Created: '+ DateTimeToString(st.Created));
 //   ShowMemo.Lines.Add('Updated: '+ DateTimeToString(st.Updated));

  finally
    StripTasksBroker.Free;
  end;
end;

procedure TMainForm.btnStripTaskRemoveClick(Sender: TObject);
const
  tid = 'aec62ec1-8869-4c78-8009-63fad7525c78';
var
  StripTask : TEntity;
  StripTasksBroker : TStripTasksBroker;
begin
  ShowMemo.Clear;

  try
    StripTasksBroker := TStripTasksBroker.Create();
    // Выводим информацию о таске в TMemo
    ShowMemo.Lines.Add('----------  Remove  ----------');
    ShowMemo.Lines.Add(Format('Информация о Задаче %s:', [tid]));
    // удаляем таск таске
    var res := StripTasksBroker.Remove(tid);

    if not res then
    begin
      ShowMemo.Lines.Add('nil');
      exit;
    end;

  finally
    StripTasksBroker.Free;
  end;
end;

{$ENDREGION 'Strip.Tasks'}

{$REGION 'Summary.Tasks'}

procedure TMainForm.btnSummaryTasksClick(Sender: TObject);
begin
  SummaryTasksForm.Show();
end;

procedure TMainForm.btnSummaryTaskListClick(Sender: TObject);
var
  SummaryTask : TEntity;
  SummaryTasksBroker : TSummaryTasksBroker;
  SummaryTaskList : TEntityList;
  Pages : integer;

begin
  ShowMemo.Clear;

  try
    SummaryTasksBroker := TSummaryTasksBroker.Create();

    SummaryTaskList := SummaryTasksBroker.List(Pages);

    // Выводим информацию о каждом объекте в TMemo
    ShowMemo.Lines.Add('----------  List  ----------');
    ShowMemo.Lines.Add('Содержимое списка:');

    if not Assigned(SummaryTaskList) then
    begin
      ShowMemo.Lines.Add('пусто');
      Exit;
    end;

    for SummaryTask in SummaryTaskList do
    begin
      var st := (SummaryTask as TSummaryTask);
      ShowMemo.Lines.Add(Format('Класс: %s  |  Адрес: %p', [SummaryTask.ClassName, Pointer(SummaryTask)]));
      ShowMemo.Lines.Add('Id '+ st.Id);
      ShowMemo.Lines.Add('Name '+ st.Name);
      ShowMemo.Lines.Add('Compid '+ (st.Compid));
      ShowMemo.Lines.Add('Depid '+ (st.Depid));

      ShowMemo.Lines.Add('as json:');

      var json := st.Serialize();

      if json <> nil then
        ShowMemo.Lines.Add(json.Format());

      ShowMemo.Lines.Add('----------');
    end;

  finally
    // Освобождаем список (все объекты освободятся автоматически)
    SummaryTaskList.Free;

    SummaryTasksBroker.Free;
  end;
end;

procedure TMainForm.btnSummaryTaskInfoClick(Sender: TObject);
const
  tid = '352890ab-bd9c-404c-9626-3a0c314ed7ac';
var
  SummaryTask : TEntity;
  SummaryTasksBroker : TSummaryTasksBroker;
begin
  ShowMemo.Clear;

  SummaryTask := nil;
  SummaryTasksBroker := nil;
  try
    SummaryTasksBroker := TSummaryTasksBroker.Create();

    ShowMemo.Lines.Add('----------  Summary.Info  ----------');
    ShowMemo.Lines.Add(Format('   %s:', [tid]));

    SummaryTask := SummaryTasksBroker.Info(tid);
    if SummaryTask = nil then
    begin
      ShowMemo.Lines.Add('nil');
      Exit;
    end;

    var st := SummaryTask as TSummaryTask;
    ShowMemo.Lines.Add('Tid: ' + st.Tid);
    ShowMemo.Lines.Add('Name: ' + st.Name);
    ShowMemo.Lines.Add('Module: ' + st.Module);
    if st.Enabled then
      ShowMemo.Lines.Add('Enabled: true')
    else
      ShowMemo.Lines.Add('Enabled: false');
    ShowMemo.Lines.Add('Settings:');
    ShowMemo.Lines.Add(st.settings.JSON);

  finally
    SummaryTask.Free;
    SummaryTasksBroker.Free;
  end;
end;

procedure TMainForm.btnSummaryTaskNewClick(Sender: TObject);
var
  SummaryTask : TSummaryTask;
  SummaryTasksBroker : TSummaryTasksBroker;
  Settings : TJSONObject;
  Custom : TJSONObject;
  ExcludeWeek : TJSONArray;
  res : boolean;
begin
  ShowMemo.Clear;

  Settings := nil;
  SummaryTask := nil;
  SummaryTasksBroker := nil;
  try
    SummaryTasksBroker := TSummaryTasksBroker.Create();
    SummaryTask := TSummaryTask.Create();

    SummaryTask.Tid := TGUID.NewGuid.ToString;
    SummaryTask.Name := 'Summary test task';
    SummaryTask.Def := 'Summary task demo description';
    SummaryTask.Module := 'SummarySynop';
    SummaryTask.Enabled := true;
    SummaryTask.CompId := '85697f9f-b80d-4668-8ed2-2f70ed825eee';
    SummaryTask.DepId := '4cf0dbf0-820b-4e05-a819-d6d1ec5652f0';

    Settings := TJSONObject.Create;
    Settings.AddPair('Header', 'TTAA01 CCCC');
    Settings.AddPair('Time', '00:00/+15 03:00/* 06:00/* 09:00/* 12:00/* 15:00/* 18:00/* 21:00/*');
    Settings.AddPair('Local', TJSONBool.Create(false));
    Settings.AddPair('MonthDays', '1-32');
    Settings.AddPair('CheckLate', TJSONBool.Create(true));
    Settings.AddPair('LatePeriod', TJSONNumber.Create(120));
    Settings.AddPair('LateEvery', TJSONNumber.Create(60));

    Custom := TJSONObject.Create;
    Custom.AddPair('DaysAgo', TJSONNumber.Create(5));
    Settings.AddPair('Custom', Custom);

    ExcludeWeek := TJSONArray.Create;
    for var i := 0 to 6 do
      ExcludeWeek.Add(0);
    Settings.AddPair('ExcludeWeek', ExcludeWeek);

///!!!    SummaryTask.SettingsObject := Settings;

    ShowMemo.Lines.Add('----------  Summary.New  ----------');
    ShowMemo.Lines.Add(Format('   %s:', [SummaryTask.Tid]));

    res := SummaryTasksBroker.New(SummaryTask);
    if not res then
      ShowMemo.Lines.Add('Error to new summary task!')
    else
      ShowMemo.Lines.Add('Created Tid: ' + SummaryTask.Tid);
  finally
    Settings.Free;
    SummaryTask.Free;
    SummaryTasksBroker.Free;
  end;
end;

procedure TMainForm.btnSummaryTaskUpdateClick(Sender: TObject);
const
  tid = '352890ab-bd9c-404c-9626-3a0c314ed7ac';
var
  SummaryTask : TSummaryTask;
  SummaryTasksBroker : TSummaryTasksBroker;
  Settings : TJSONObject;
  res : boolean;
begin
  ShowMemo.Clear;

  Settings := nil;
  SummaryTask := nil;
  SummaryTasksBroker := nil;
  try
    SummaryTasksBroker := TSummaryTasksBroker.Create();
    SummaryTask := TSummaryTask.Create();

    SummaryTask.Tid := tid;
    SummaryTask.Name := 'Summary task updated';
    SummaryTask.Def := 'Summary task demo update';
    SummaryTask.Enabled := false;

    Settings := TJSONObject.Create;
    Settings.AddPair('Header', 'TTAA01 CCCC');
    Settings.AddPair('Time', '08:00/+30 20:00/*');
///!!!    SummaryTask.SettingsObject := Settings;

    ShowMemo.Lines.Add('----------  Summary.Update  ----------');
    ShowMemo.Lines.Add(Format('   %s:', [SummaryTask.Tid]));

    res := SummaryTasksBroker.Update(SummaryTask);
    if not res then
      ShowMemo.Lines.Add('Error to update summary task!')
    else
      ShowMemo.Lines.Add('Summary task updated');
  finally
    Settings.Free;
    SummaryTask.Free;
    SummaryTasksBroker.Free;
  end;
end;



procedure TMainForm.btnSummaryTaskRemoveClick(Sender: TObject);
const
  tid = '352890ab-bd9c-404c-9626-3a0c314ed7ac';
var
  SummaryTasksBroker : TSummaryTasksBroker;
  res : boolean;
begin
  ShowMemo.Clear;

  SummaryTasksBroker := nil;
  try
    SummaryTasksBroker := TSummaryTasksBroker.Create();

    ShowMemo.Lines.Add('----------  Summary.Remove  ----------');
    ShowMemo.Lines.Add(Format('   %s:', [tid]));

    res := SummaryTasksBroker.Remove(tid);
    if not res then
      ShowMemo.Lines.Add('Error to remove summary task!')
    else
      ShowMemo.Lines.Add('Summary task removed');
  finally
    SummaryTasksBroker.Free;
  end;
end;

procedure TMainForm.btnSummaryTaskTypesClick(Sender: TObject);
var
  SummaryTasksBroker : TSummaryTasksBroker;
  Types              : TJSONArray;
begin
  ShowMemo.Clear;

  try
    SummaryTasksBroker := TSummaryTasksBroker.Create();
    // Выводим список типов
    ShowMemo.Lines.Add('----------  Types  ----------');
    //  получаем список
    Types := SummaryTasksBroker.Types;
    if not Assigned(Types) then
    begin
      ShowMemo.Lines.Add('nil');
      Exit;
    end;

    for var t in Types do
    begin
      ShowMemo.Lines.Add('');
      ShowMemo.Lines.Add('name: ' + (t as TJSONObject).GetValue('name').AsType<string>);
      ShowMemo.Lines.Add('caption: ' + (t as TJSONObject).GetValue('caption').AsType<string>);
    end;
  finally
    if Assigned(Types) then FreeAndNil(Types);
    SummaryTasksBroker.Free;
  end;
end;

{$ENDREGION 'Summary.Tasks'}

initialization
  RegisterAppFormClass(TMainForm);

end.
