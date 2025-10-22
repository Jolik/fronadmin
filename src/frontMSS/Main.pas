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
    btnChannel: TUniButton;
    btnStripTasks: TUniButton;
    btnLinks: TUniButton;
    btnSummTask: TUniButton;
    btnRouterSources: TUniButton;
    btnAliases: TUniButton;
    btnAbonents: TUniButton;
    btnDSProcessorTasks: TUniButton;
    btnRules: TUniButton;
    btnHandlers: TUniButton;
    procedure btnAbonentsClick(Sender: TObject);
    procedure btnChannelClick(Sender: TObject);
    procedure btnStripTasksClick(Sender: TObject);
    procedure btnLinksClick(Sender: TObject);
    procedure btnSummTaskClick(Sender: TObject);
    procedure btnRouterSourcesClick(Sender: TObject);
    procedure btnAliasesClick(Sender: TObject);
    procedure btnDSProcessorTasksClick(Sender: TObject);
    procedure btnRulesClick(Sender: TObject);
    procedure btnHandlersClick(Sender: TObject);
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
  ParentFormUnit, ChannelsFormUnit, StripTasksFormUnit, SummaryTasksFormUnit, LinksFormUnit,
  AliasesFormUnit, AbonentsFormUnit,
  RouterSourcesFormUnit,
  DSProcessorTasksFormUnit,
  RulesFormUnit,
  HandlersFormUnit;

function MainForm: TMainForm;
begin
  Result := TMainForm(UniMainModule.GetFormInstance(TMainForm));
end;

{  TMainForm  }

procedure TMainForm.btnChannelClick(Sender: TObject);
begin
  ChannelsForm.Show();
end;

procedure TMainForm.btnDSProcessorTasksClick(Sender: TObject);
begin
  DSProcessorTasksForm.Show();
end;

procedure TMainForm.btnRulesClick(Sender: TObject);
begin
  RulesForm.Show();
end;

procedure TMainForm.btnHandlersClick(Sender: TObject);
begin
  HandlersForm.Show();
end;

procedure TMainForm.btnAbonentsClick(Sender: TObject);
begin
  AbonentsForm.Show();
end;

procedure TMainForm.btnAliasesClick(Sender: TObject);
begin
  AbonentsForm.Show();
end;

procedure TMainForm.btnRouterSourcesClick(Sender: TObject);
begin
  RouterSourcesForm.Show();
end;

procedure TMainForm.btnLinksClick(Sender: TObject);
begin
  LinksForm.Show();
end;

procedure TMainForm.btnStripTasksClick(Sender: TObject);
begin
  StripTasksForm.Show();
end;

procedure TMainForm.btnSummTaskClick(Sender: TObject);
begin
  SummaryTasksForm.Show();
end;

initialization
  RegisterAppFormClass(TMainForm);

end.

