unit Main;

interface

uses
  System.Generics.Collections, System.SysUtils, System.Variants, System.Classes,
  Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, uniGUIBaseClasses, uniLabel,
  uniButton, uniSplitter, uniPageControl, uniTreeView, uniTreeMenu;

type
  TMainForm = class(TUniForm)
    btnStripTasks: TUniButton;
    btnSummTask: TUniButton;
    btnMonitoringTasks: TUniButton;
    btnDSProcessorTasks: TUniButton;
    procedure btnStripTasksClick(Sender: TObject);
    procedure btnSummTaskClick(Sender: TObject);
    procedure btnMonitoringTasksClick(Sender: TObject);
    procedure btnDSProcessorTasksClick(Sender: TObject);
  private
  public
    { Public declarations }
  end;

function MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  uniGUIVars, uniGUIApplication,
  MainModule,
  ParentFormUnit, StripTasksFormUnit, SummaryTasksFormUnit,
  MonitoringTasksFormUnit, DSProcessorTasksFormUnit;

function MainForm: TMainForm;
begin
  Result := TMainForm(UniMainModule.GetFormInstance(TMainForm));
end;

{  TMainForm  }

procedure TMainForm.btnStripTasksClick(Sender: TObject);
begin
  StripTasksForm.Show();
end;

procedure TMainForm.btnSummTaskClick(Sender: TObject);
begin
  SummaryTasksForm.Show();
end;

procedure TMainForm.btnDSProcessorTasksClick(Sender: TObject);
begin
  DSProcessorTasksForm.Show();
end;

procedure TMainForm.btnMonitoringTasksClick(Sender: TObject);
begin
  MonitoringTasksForm.Show();
end;

initialization
  RegisterAppFormClass(TMainForm);

end.

