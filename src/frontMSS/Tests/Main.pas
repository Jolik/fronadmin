unit Main;

interface

uses
  Windows, Messages, System.SysUtils, Variants, Classes, Graphics,
  Generics.Collections, System.JSON, CommParsersUnit,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, uniButton, uniGUIBaseClasses,
  uniMemo,
  LinksBrokerUnit, EntityUnit, LinkUnit,
  StripTasksBrokerUnit, StripTaskUnit,
  SummaryTasksBrokerUnit, SummaryTaskUnit;

type
  TMainForm = class(TUniForm)
    btnLinkListTest: TUniButton;
    btnLinkInfo: TUniButton;
    ShowMemo: TUniMemo;
    btnTaskList: TUniButton;
    btnTaskInfo: TUniButton;
    btnStripTaskNew: TUniButton;
    btnStripTaskRemove: TUniButton;
    btnStripTaskUpdate: TUniButton;
    btnSummaryTaskList: TUniButton;
    btnSummaryTaskInfo: TUniButton;
    btnSummaryTaskNew: TUniButton;
    btnSummaryTaskUpdate: TUniButton;
    btnSummaryTaskRemove: TUniButton;
    btnSummaryTaskTypes: TUniButton;
    procedure btnLinkListTestClick(Sender: TObject);
    procedure btnLinkInfoClick(Sender: TObject);
    procedure btnTaskListClick(Sender: TObject);
    procedure btnTaskInfoClick(Sender: TObject);
    procedure btnStripTaskNewClick(Sender: TObject);
    procedure btnStripTaskRemoveClick(Sender: TObject);
    procedure btnStripTaskUpdateClick(Sender: TObject);
    procedure btnSummaryTaskListClick(Sender: TObject);
    procedure btnSummaryTaskInfoClick(Sender: TObject);
    procedure btnSummaryTaskNewClick(Sender: TObject);
    procedure btnSummaryTaskUpdateClick(Sender: TObject);
    procedure btnSummaryTaskRemoveClick(Sender: TObject);
    procedure btnSummaryTaskTypesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, uniGUIApplication;

function MainForm: TMainForm;
begin
  Result := TMainForm(UniMainModule.GetFormInstance(TMainForm));
end;

procedure TMainForm.btnLinkInfoClick(Sender: TObject);
const
  lid = 'aec62ec1-8869-4c78-8009-63fad7525c78';
var
  Link : TEntity;
  LinksBroker : TLinksBroker;
begin
  try
    LinksBroker := TLinksBroker.Create();
    // Âûâîäèì èíôîðìàöèþ î ëèíêå â TMemo
    ShowMemo.Lines.Add(Format('Èíôîðìàöèÿ î ëèíêå %s:', [lid]));
    //  ïîëó÷àåì èíôó î ëèíêå
    Link := LinksBroker.Info(lid);
    if Link = nil then
    begin
      ShowMemo.Lines.Add('nil');
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
  finally
    LinksBroker.Free;
  end;
end;


procedure TMainForm.btnLinkListTestClick(Sender: TObject);
var
  Link : TEntity;
  LinksBroker : TLinksBroker;
  LinksList : TObjectList<TEntity>;
  Pages : integer;

begin
  try
    LinksBroker := TLinksBroker.Create();
    LinksList := TObjectList<TEntity>.Create(true);

    LinksList := LinksBroker.List(Pages);

    // Âûâîäèì èíôîðìàöèþ î êàæäîì îáúåêòå â TMemo
    ShowMemo.Lines.Add('----------  List  ----------');
    ShowMemo.Lines.Add('Ñîäåðæèìîå ñïèñêà:');
    for Link in LinksList do
    begin
      var l := (Link as TLink);
      ShowMemo.Lines.Add(Format('Êëàññ: %s  |  Àäðåñ: %p', [Link.ClassName, Pointer(Link)]));
      ShowMemo.Lines.Add('Id '+ l.Id);
      ShowMemo.Lines.Add('TypeStr '+ l.TypeStr);
      ShowMemo.Lines.Add('Name '+ l.Name);
      ShowMemo.Lines.Add('Dir '+ l.Dir);
      ShowMemo.Lines.Add('Status '+ l.Status);
      ShowMemo.Lines.Add('Comsts '+ l.Comsts);
      ShowMemo.Lines.Add('Compid '+ l.Compid);
      ShowMemo.Lines.Add('Depid '+ l.Depid);

      var parser: TLinkParser;
      if ParsersMap.TryGetValue(l.TypeStr, parser) then
      begin
        ShowMemo.Lines.Add('as json:');
        var json := parser.Serialize(l);
        if json <> nil then
          ShowMemo.Lines.Add(json.Format());
      end;
      ShowMemo.Lines.Add('----------');
    end;

  finally
    // Îñâîáîæäàåì ñïèñîê (âñå îáúåêòû îñâîáîäÿòñÿ àâòîìàòè÷åñêè)
    LinksList.Free;

    LinksBroker.Free;
  end;
end;

procedure TMainForm.btnStripTaskNewClick(Sender: TObject);
var
  st : TStripTask;
  StripTasksBroker : TStripTasksBroker;
  res : boolean;

begin
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

    // Âûâîäèì èíôîðìàöèþ î òàñêå â TMemo
    ShowMemo.Lines.Add('----------  New  ----------');
    ShowMemo.Lines.Add(Format('Èíôîðìàöèÿ î Çàäà÷å %s:', [st.tid]));

    //  ïîëó÷àåì èíôó î òàñêå
    res := StripTasksBroker.New(st);
    if not res  then
    begin
      ShowMemo.Lines.Add('Error to new!');
      exit;
    end;

    (*
    ///  ïîëó÷àåì ðåçóëüòàò è çàïðàøèâàåì èíôîðìàöèþ ïî tid èç ðåçóëüòàòà

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

procedure TMainForm.btnStripTaskRemoveClick(Sender: TObject);
const
  tid = 'aec62ec1-8869-4c78-8009-63fad7525c78';

var
  StripTask : TEntity;
  StripTasksBroker : TStripTasksBroker;

begin

  try

    StripTasksBroker := TStripTasksBroker.Create();
    // Âûâîäèì èíôîðìàöèþ î òàñêå â TMemo
    ShowMemo.Lines.Add('----------  Remove  ----------');
    ShowMemo.Lines.Add(Format('Èíôîðìàöèÿ î Çàäà÷å %s:', [tid]));
    //  óäàëÿåì òàñê òàñêå
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

procedure TMainForm.btnStripTaskUpdateClick(Sender: TObject);
var
  st : TStripTask;
  StripTasksBroker : TStripTasksBroker;
  res : boolean;

const
  uuid = 'aec62ec1-8869-4c78-8009-63fad7525c78';

begin
  try

    StripTasksBroker := TStripTasksBroker.Create();

    st := TStripTask.Create();
    with st do
    begin
      id := uuid;
      Name := 'First test update';
      Caption := 'First test update';
    end;

    // Âûâîäèì èíôîðìàöèþ î òàñêå â TMemo
    ShowMemo.Lines.Add('----------  Update  ----------');
    ShowMemo.Lines.Add(Format('Èíôîðìàöèÿ î Çàäà÷å %s:', [st.tid]));

    //  Îáíîâëååì èíôîðìàöèþ
    res := StripTasksBroker.Update(st);
    if not res  then
    begin
      ShowMemo.Lines.Add('Error to Update!');
      exit;
    end;

    ///  ïîëó÷àåì ðåçóëüòàò è çàïðàøèâàåì èíôîðìàöèþ ïî tid èç ðåçóëüòàòà

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



procedure TMainForm.btnSummaryTaskListClick(Sender: TObject);
var
  SummaryTask : TEntity;
  SummaryTasksBroker : TSummaryTasksBroker;
  SummaryTaskList : TEntityList;
  Pages : integer;
begin
  SummaryTasksBroker := nil;
  SummaryTaskList := nil;
  try
    SummaryTasksBroker := TSummaryTasksBroker.Create();
    SummaryTaskList := SummaryTasksBroker.List(Pages);

    ShowMemo.Lines.Add('----------  Summary.List  ----------');
    ShowMemo.Lines.Add(' :');

    for SummaryTask in SummaryTaskList do
    begin
      var st := SummaryTask as TSummaryTask;
      ShowMemo.Lines.Add(Format(': %s  |  : %p', [SummaryTask.ClassName, Pointer(SummaryTask)]));
      ShowMemo.Lines.Add('Tid ' + st.Tid);
      ShowMemo.Lines.Add('Name ' + st.Name);
      ShowMemo.Lines.Add('Module ' + st.Module);

      var json := st.Serialize();
      try
        if json <> nil then
          ShowMemo.Lines.Add(json.Format());
      finally
        json.Free;
      end;

      ShowMemo.Lines.Add('----------');
    end;
  finally
    SummaryTaskList.Free;
    SummaryTasksBroker.Free;
  end;
end;

procedure TMainForm.btnSummaryTaskInfoClick(Sender: TObject);
const
  tid = '48332ad5-55c1-4e64-b2ea-e99d0c78f900';
var
  SummaryTask : TEntity;
  SummaryTasksBroker : TSummaryTasksBroker;
begin
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
///!!!    ShowMemo.Lines.Add(st.SettingsObject.ToJSON);
///
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
var
  SummaryTask : TSummaryTask;
  SummaryTasksBroker : TSummaryTasksBroker;
  Settings : TJSONObject;
  res : boolean;
const
  tid = '48332ad5-55c1-4e64-b2ea-e99d0c78f900';
begin
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
  tid = '1631cd00-d431-4152-8b0e-2887e1200747';
var
  SummaryTasksBroker : TSummaryTasksBroker;
  res : boolean;
begin
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
  TypesArray : TJSONArray;
begin
  TypesArray := nil;
  SummaryTasksBroker := nil;
  try
    SummaryTasksBroker := TSummaryTasksBroker.Create();

    ShowMemo.Lines.Add('----------  Summary.Types  ----------');

    TypesArray := SummaryTasksBroker.GetTypes();
    if TypesArray = nil then
      ShowMemo.Lines.Add('nil')
    else
      ShowMemo.Lines.Add(TypesArray.Format());
  finally
    TypesArray.Free;
    SummaryTasksBroker.Free;
  end;
end;

procedure TMainForm.btnTaskInfoClick(Sender: TObject);
const
  tid = 'aec62ec1-8869-4c78-8009-63fad7525c78';

var
  StripTask : TEntity;
  StripTasksBroker : TStripTasksBroker;

begin

  try

    StripTasksBroker := TStripTasksBroker.Create();
    // Âûâîäèì èíôîðìàöèþ î òàñêå â TMemo
    ShowMemo.Lines.Add('----------  Info  ----------');
    ShowMemo.Lines.Add(Format('Èíôîðìàöèÿ î Çàäà÷å %s:', [tid]));
    //  ïîëó÷àåì èíôó î òàñêå
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

procedure TMainForm.btnTaskListClick(Sender: TObject);
var
  StripTask : TEntity;
  StripTasksBroker : TStripTasksBroker;
  StripTaskList : TEntityList;
  Pages : integer;

begin
  try
    StripTasksBroker := TStripTasksBroker.Create();

    StripTaskList := StripTasksBroker.List(Pages);

    // Âûâîäèì èíôîðìàöèþ î êàæäîì îáúåêòå â TMemo
    ShowMemo.Lines.Add('----------  List  ----------');
    ShowMemo.Lines.Add('Ñîäåðæèìîå ñïèñêà:');

    for StripTask in StripTaskList do
    begin
      var st := (StripTask as TStripTask);
      ShowMemo.Lines.Add(Format('Êëàññ: %s  |  Àäðåñ: %p', [StripTask.ClassName, Pointer(StripTask)]));
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
    // Îñâîáîæäàåì ñïèñîê (âñå îáúåêòû îñâîáîäÿòñÿ àâòîìàòè÷åñêè)
    StripTaskList.Free;

    StripTasksBroker.Free;
  end;
end;

initialization
  RegisterAppFormClass(TMainForm);

end.
