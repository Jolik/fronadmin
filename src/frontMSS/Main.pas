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
    btnAbonents: TUniButton;
    btnChannel: TUniButton;
    btnStripTasks: TUniButton;
    btnLinks: TUniButton;
    btnSummTask: TUniButton;
    btnRouterSources: TUniButton;
    btnAliases: TUniButton;
    procedure btnChannelClick(Sender: TObject);
    procedure btnStripTasksClick(Sender: TObject);
    procedure btnLinksClick(Sender: TObject);
    procedure btnSummTaskClick(Sender: TObject);
    procedure btnRouterSourcesClick(Sender: TObject);
    procedure btnAliasesClick(Sender: TObject);
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
  AliasesFormUnit,
  RouterSourcesFormUnit;

function MainForm: TMainForm;
begin
  Result := TMainForm(UniMainModule.GetFormInstance(TMainForm));
end;

{  TMainForm  }

procedure TMainForm.btnChannelClick(Sender: TObject);
begin
  ChannelsForm.Show();
end;

procedure TMainForm.btnAliasesClick(Sender: TObject);
begin
  AliasesForm.Show();
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
