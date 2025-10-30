unit SummaryTasksFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ListParentFormUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniPageControl, uniSplitter, uniBasicGrid, uniDBGrid,
  uniToolBar, uniGUIBaseClasses,
   EntityUnit,
  ParentEditFormUnit,
  TasksParentFormUnit, RestEntityBrokerUnit, RestBrokerBaseUnit, SummaryTasksRestBrokerUnit,
  TaskSourcesRestBrokerUnit, TaskSourceUnit, uniPanel, uniLabel, APIConst,
  uniMultiItem, uniListBox, SummaryTaskUnit;

type
  TSummaryTasksForm = class(TTaskParentForm)
    UniContainerPanel1: TUniContainerPanel;
    UniPanel1: TUniPanel;
    lbSettings: TUniListBox;
    procedure btnNewClick(Sender: TObject);
  protected
    procedure OnCreate; override;
    procedure OnInfoUpdated(AEntity: TEntity);override;
    ///
//    procedure Refresh(const AId: String = ''); override;
    function CreateTaskSourcesBroker(): TTaskSourcesRestBroker; override;
    function CreateEditForm(): TParentEditForm; override;
    function CreateRestBroker(): TRestEntityBroker; override;

//    procedure UpdateCallback(ASender: TComponent; AResult: Integer);

  public

  end;

function SummaryTasksForm(): TSummaryTasksForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, SummaryTaskEditFormUnit, LoggingUnit, ParentFormUnit, TasksRestBrokerUnit, SummaryTasksHttpRequests;

function SummaryTasksForm(): TSummaryTasksForm;
begin
  Result := TSummaryTasksForm(UniMainModule.GetFormInstance(TSummaryTasksForm));
end;


procedure TSummaryTasksForm.btnNewClick(Sender: TObject);
begin
  PrepareEditForm;

  ///  создаем класс сущности от брокера
  var req := TSummaryTaskNewBody.Create;
  ///  устанавлаием сущность в окно редактирования
  EditForm.Entity := req;

  try
    EditForm.ShowModalEx(NewCallback);
  finally
///  удалять нельзя потому что класс переходит под управление форму редактирования
///    LEntity.Free;
  end;
end;

function TSummaryTasksForm.CreateEditForm: TParentEditForm;
begin
  var Res := SummaryTaskEditForm();
  res.SetTaskTypesList(FTaskTypesList);
  Result:= res;
end;

function TSummaryTasksForm.CreateRestBroker: TRestEntityBroker;
begin
  result:= TSummaryTasksRestBroker.Create(UniMainModule.XTicket);
end;

function TSummaryTasksForm.CreateTaskSourcesBroker: TTaskSourcesRestBroker;
begin
  Result := TTaskSourcesRestBroker.Create(UniMainModule.XTicket, APIConst.constURLSummaryBasePath);
end;

procedure TSummaryTasksForm.OnCreate;
begin
  FEnabledTaskTypes:= true;
  inherited;
end;

procedure TSummaryTasksForm.OnInfoUpdated(AEntity: TEntity);
begin
  inherited;
  lbSettings.Items.Clear;
  with FSelectedEntity as TSummaryTask do begin
    lbSettings.Items.AddPair('Сокращенный заголовок', TaskSettings.Header);
    lbSettings.Items.AddPair('Сокращенный заголовок 2', TaskSettings.Header2);
    lbSettings.Items.AddPair('Корректировка времени сокращенного заголовка', IntToStr(TaskSettings.HeaderCorr));
    lbSettings.Items.AddPair('Дни месяца', TaskSettings.MonthDays);
    lbSettings.Items.AddPair('Сроки подачи', TaskSettings.Time);
    lbSettings.Items.AddPair('Проверять опоздавшие наблюдения', BoolToStr(TaskSettings.CheckLate,true));
    lbSettings.Items.AddPair('каждые X секунд:', IntToStr(TaskSettings.LateEvery));
    lbSettings.Items.AddPair('каждые N минут:', IntToStr(TaskSettings.LatePeriod));
    var Ex:= TaskSettings.ExcludeWeek;

  end;
end;

end.
