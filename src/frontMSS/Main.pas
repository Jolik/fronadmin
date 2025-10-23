unit Main;

interface

uses
  System.Generics.Collections, System.SysUtils, System.Variants, System.Classes,
  Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, uniGUIBaseClasses, uniLabel,
  uniButton, uniSplitter, uniPageControl, uniTreeView, uniTreeMenu, CompanyBrokerUnit, DepartmentBrokerUnit,
  uniMultiItem, uniComboBox, EntityUnit;

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
    UniButton1: TUniButton;
    cbCurDept: TUniComboBox;
    UniLabel1: TUniLabel;
    cbCurComp: TUniComboBox;
    UniLabel2: TUniLabel;
    procedure btnAbonentsClick(Sender: TObject);
    procedure btnChannelClick(Sender: TObject);
    procedure btnStripTasksClick(Sender: TObject);
    procedure btnLinksClick(Sender: TObject);
    procedure btnSummTaskClick(Sender: TObject);
    procedure btnRouterSourcesClick(Sender: TObject);
    procedure btnAliasesClick(Sender: TObject);
    procedure btnDSProcessorTasksClick(Sender: TObject);
    procedure btnRulesClick(Sender: TObject);
    procedure UniButton1Click(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
    procedure cbCurCompChange(Sender: TObject);
  private
    FDeps: TEntityList;
    FComps: TEntityList;
    FCompanyBroker : TCompanyBroker;
    FDepartmentBroker: TDepartmentBroker;
    function GetCompid:string;
    function GetDeptid:string;
    procedure UpdateDeptList;
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
  TasksParentFormUnit,
  CompanyUnit,
  DepartmentUnit,
  DSProcessorTasksFormUnit,
  MonitoringTasksFormUnit,
  RulesFormUnit;

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

//procedure TMainForm.btnHandlersClick(Sender: TObject);
//begin
//  HandlersForm.Show();
//end;
//
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

procedure TMainForm.cbCurCompChange(Sender: TObject);
begin
  UpdateDeptList;
end;

function TMainForm.GetCompid: string;
begin
  if cbCurComp.ItemIndex <> -1 then
    Result:= (cbCurComp.Items.Objects[cbCurComp.ItemIndex] as TCompany).Id;
end;

function TMainForm.GetDeptid: string;
begin
  if cbCurDept.ItemIndex <> -1 then
    Result:= (cbCurDept.Items.Objects[cbCurDept.ItemIndex] as TDepartment).Id;
end;

procedure TMainForm.UniButton1Click(Sender: TObject);
begin
 MonitoringTasksForm.Show();
end;

procedure TMainForm.UniFormCreate(Sender: TObject);
var
  ind, page: integer;
begin
  FCompanyBroker := TCompanyBroker.Create();
  FDepartmentBroker:= TDepartmentBroker.Create();
  FComps:= FCompanyBroker.List(page);
  FDeps:= FDepartmentBroker.List(page);
  for var comp in FComps do
     cbCurComp.Items.AddObject((comp as TCompany).Index,comp);
  if cbCurComp.Items.Count = 0 then
    exit;
  ind:= cbCurComp.Items.IndexOf('SYSTEM');
  if ind = -1  then
    ind := 0;
  cbCurComp.ItemIndex:= ind;
  UpdateDeptList;
  UniMainModule.CompID:= GetCompid;


end;

procedure TMainForm.UniFormDestroy(Sender: TObject);
begin
  FreeAndNil(FCompanyBroker);
  FreeAndNil(FDepartmentBroker);
end;

procedure TMainForm.UpdateDeptList;
var
  compid: string;
  ind: integer;
begin
  cbCurDept.Items.Clear;
  compid:=GetCompid;
  if compid='' then exit;

  for var dep in FDeps do
  if compid=dep.CompId then
    cbCurDept.Items.AddObject(dep.Name,dep);
  ind:= cbCurDept.Items.IndexOf('SYSTEM');
  if ind <> -1  then
    cbCurDept.ItemIndex:= ind;
  UniMainModule.DeptID:= GetDeptid;
end;

initialization
  RegisterAppFormClass(TMainForm);

end.

