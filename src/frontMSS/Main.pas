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
    procedure btnChannelClick(Sender: TObject);
    procedure btnStripTasksClick(Sender: TObject);
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
  ParentFormUnit, ChannelsFormUnit, StripTasksFormUnit;

function MainForm: TMainForm;
begin
  Result := TMainForm(UniMainModule.GetFormInstance(TMainForm));
end;

{  TMainForm  }

procedure TMainForm.btnChannelClick(Sender: TObject);
begin
  ChannelsForm.Show();
end;

procedure TMainForm.btnStripTasksClick(Sender: TObject);
begin
  StripTasksForm.Show();
end;

initialization
  RegisterAppFormClass(TMainForm);

end.
