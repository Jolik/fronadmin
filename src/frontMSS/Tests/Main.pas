unit Main;

interface

uses
  Windows, Messages, System.SysUtils, Variants, Classes, Graphics,
  Generics.Collections, System.JSON, CommParsersUnit,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, uniButton, uniGUIBaseClasses,
  uniMemo,
  LinksBrokerUnit, EntityUnit, LinkUnit,
  StripTasksBrokerUnit, StripTaskUnit;

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
    procedure btnLinkListTestClick(Sender: TObject);
    procedure btnLinkInfoClick(Sender: TObject);
    procedure btnTaskListClick(Sender: TObject);
    procedure btnTaskInfoClick(Sender: TObject);
    procedure btnStripTaskNewClick(Sender: TObject);
    procedure btnStripTaskRemoveClick(Sender: TObject);
    procedure btnStripTaskUpdateClick(Sender: TObject);
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
    // Выводим информацию о линке в TMemo
    ShowMemo.Lines.Add(Format('Информация о линке %s:', [lid]));
    //  получаем инфу о линке
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

    // Выводим информацию о каждом объекте в TMemo
    ShowMemo.Lines.Add('----------  List  ----------');
    ShowMemo.Lines.Add('Содержимое списка:');
    for Link in LinksList do
    begin
      var l := (Link as TLink);
      ShowMemo.Lines.Add(Format('Класс: %s  |  Адрес: %p', [Link.ClassName, Pointer(Link)]));
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
    // Освобождаем список (все объекты освободятся автоматически)
    LinksList.Free;

    LinksBroker.Free;
  end;
end;

procedure TMainForm.btnStripTaskNewClick(Sender: TObject);
var
  st : TStripTask;
  StripTasksBroker : TStripTaskBroker;
  res : boolean;

begin
  try

    StripTasksBroker := TStripTaskBroker.Create();

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

    //  получаем инфу о таске
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

procedure TMainForm.btnStripTaskRemoveClick(Sender: TObject);
const
  tid = 'aec62ec1-8869-4c78-8009-63fad7525c78';

var
  StripTask : TEntity;
  StripTasksBroker : TStripTaskBroker;

begin

  try

    StripTasksBroker := TStripTaskBroker.Create();
    // Выводим информацию о таске в TMemo
    ShowMemo.Lines.Add('----------  Remove  ----------');
    ShowMemo.Lines.Add(Format('Информация о Задаче %s:', [tid]));
    //  удаляем таск таске
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
  StripTasksBroker : TStripTaskBroker;
  res : boolean;

const
  uuid = 'aec62ec1-8869-4c78-8009-63fad7525c78';

begin
  try

    StripTasksBroker := TStripTaskBroker.Create();

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

    //  Обновлеем информацию
    res := StripTasksBroker.Update(st);
    if not res  then
    begin
      ShowMemo.Lines.Add('Error to Update!');
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

procedure TMainForm.btnTaskInfoClick(Sender: TObject);
const
  tid = 'aec62ec1-8869-4c78-8009-63fad7525c78';

var
  StripTask : TEntity;
  StripTasksBroker : TStripTaskBroker;

begin

  try

    StripTasksBroker := TStripTaskBroker.Create();
    // Выводим информацию о таске в TMemo
    ShowMemo.Lines.Add('----------  Info  ----------');
    ShowMemo.Lines.Add(Format('Информация о Задаче %s:', [tid]));
    //  получаем инфу о таске
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
  StripTasksBroker : TStripTaskBroker;
  StripTaskList : TEntityList;
  Pages : integer;

begin
  try
    StripTasksBroker := TStripTaskBroker.Create();

    StripTaskList := StripTasksBroker.List(Pages);

    // Выводим информацию о каждом объекте в TMemo
    ShowMemo.Lines.Add('----------  List  ----------');
    ShowMemo.Lines.Add('Содержимое списка:');

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

initialization
  RegisterAppFormClass(TMainForm);

end.
