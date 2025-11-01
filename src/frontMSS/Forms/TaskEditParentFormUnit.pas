unit TaskEditParentFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniButton,
  uniGUIBaseClasses, uniPanel, uniMemo, uniCheckBox,
  LoggingUnit,
  Data.DB, FireDAC.Comp.Client, uniDBGrid, uniBasicGrid, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, uniTimer,
  uniMultiItem, uniComboBox, Math,   uniListBox,
  EntityUnit, TaskSourceUnit, TaskTypesUnit,
  TaskSourcesRestBrokerUnit,
  ParentTaskCustomSettingsEditFrameUnit, SelectTaskSourcesFormUnit,
  TaskUnit;


type
  TTaskSourcesList = TTaskSourceList;

type
  TTaskEditParentForm = class(TParentEditForm)
    lModule: TUniLabel;
    teTid: TUniEdit;
    lTid: TUniLabel;
    teCompId: TUniEdit;
    lCompId: TUniLabel;
    teDepId: TUniEdit;
    lDepId: TUniLabel;
    meDef: TUniMemo;
    lDef: TUniLabel;
    cbEnabled: TUniCheckBox;
    cbModule: TUniComboBox;
    pnCustomSettings: TUniContainerPanel;
    pnSources: TUniContainerPanel;
    
    gridSources: TUniDBGrid;
    SourcesDS: TDataSource;
    SourcesMem: TFDMemTable;
    SourcesMemenabled: TBooleanField;
    SourcesMemsid: TStringField;
    SourcesMemname: TStringField;
    unbtnSrcDel1: TUniButton;

    procedure btnSourcesEditClick(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure unbtnSrcDel1Click(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
//    procedure lbTaskSourcesClick(Sender: TObject);
  protected
    FGrid: TUniDBGrid;
    FSourcesMem: TFDMemTable;
    FSourcesDS: TDataSource;
    FTaskSourcesBroker: TTaskSourcesRestBroker;
    FCustomSettingsFrame: TParentTaskCustomSettingsEditFrame;
    FTaskSourcesList: TTaskSourcesList;
    FTaskSourcesListOwned: Boolean;
    FTaskTypesList: TTaskTypesList;
    function ModuleIndex(module:string):integer;
    function GetCurrentModuleValues:string;
    function Apply: boolean; override;
    function DoCheck: Boolean; override;
    function GetSettings: TTaskSettings;
    function GetTask: TTask;
    procedure ClearCustomSettingsFrame;
    procedure SetTaskSourcesList(const Value: TTaskSourcesList);
    procedure RefreshTaskSourcesList;
//    procedure UpdateSourceItemsText;
    procedure AssignTaskSourcesFrom(const ASourceList: TTaskSourcesList);
    procedure SourcesEditCallback(ASender: TComponent; AResult: Integer);
    procedure SyncListFromMem;

    function CreateTaskSourceEditForm(taskSourcesList: TTaskSourcesList = nil): TSelectTaskSourcesForm; virtual;
    procedure SetEntity(AEntity : TFieldSet); override;
    procedure EnsureSourcesGrid;
    procedure FillMemFromList;
//    procedure GetTaskSources;

  public
    procedure SetTaskTypesList(list : TTaskTypesList);
    ///    FEntity     ""
    property Task : TTask read GetTask;
    property TaskSourcesList: TTaskSourcesList read FTaskSourcesList write SetTaskSourcesList;

  end;

function ParentTaskEditForm(taskSourceBroker: TTaskSourcesRestBroker = nil): TTaskEditParentForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, ConstsUnit, Common, StrUtils, TaskHttpRequests;

function ParentTaskEditForm(taskSourceBroker: TTaskSourcesRestBroker): TTaskEditParentForm;
begin
  Result := TTaskEditParentForm(UniMainModule.GetFormInstance(TTaskEditParentForm));
  Result.FTaskSourcesBroker:= taskSourceBroker;
end;

{ TTaskEditParentForm }

function TTaskEditParentForm.Apply: boolean;
begin
  Result := inherited Apply();

  if not Result then
    Exit;

  Task.Tid := teTid.Text;
  Task.CompId := teCompId.Text;
  Task.DepId := teDepId.Text;
  Task.Module := cbModule.Text;
  Task.Def := meDef.Lines.Text;
  Task.Enabled := cbEnabled.Checked;

  if Assigned(FCustomSettingsFrame) then
    Result := FCustomSettingsFrame.Apply() and Result;
end;

function TTaskEditParentForm.DoCheck: Boolean;
begin
  Result := inherited DoCheck();
  if not IsEdit and (teTid.Text<> '') and  not ValidateUUID(teTid.Text) then
  begin
    Result := false;
    MessageDlg(Format(rsWarningValueMustBeUUID, [lTid.Caption]), TMsgDlgType.mtWarning, [mbOK], nil)
  end;
end;

function TTaskEditParentForm.GetCurrentModuleValues: string;
begin
  if cbModule.ItemIndex <> -1 then
   result:= cbModule.Items.ValueFromIndex[cbModule.ItemIndex]
end;

function TTaskEditParentForm.GetSettings: TTaskSettings;
begin
  Result := nil;

  if Task = nil then
    Exit;

  if not (Task.Settings is TTaskSettings) then
  begin
    Log('TSummaryTaskEditForm.GetSummarySettings invalid settings type', lrtError);
    Exit;
  end;

  Result := Task.Settings as TTaskSettings;
end;

function TTaskEditParentForm.GetTask: TTask;
begin
  Result := nil;
  if not (FEntity is TTask) then
  begin
    Log('TSummaryTaskEditForm.GetSummaryTask error in FEntity type', lrtError);
    exit;
  end;
  Result := Entity as TTask;
end;

function TTaskEditParentForm.ModuleIndex(module: string): integer;
begin
  Result:=-1;
  for var I := 0 to cbModule.Items.Count-1 do
  begin
    if cbModule.Items.ValueFromIndex[i] = module then
    begin
       Result:= i;
       Exit;
    end;
  end;
end;

procedure TTaskEditParentForm.ClearCustomSettingsFrame;
begin
  if Assigned(FCustomSettingsFrame) then
  begin
    FCustomSettingsFrame.Parent := nil;
    FreeAndNil(FCustomSettingsFrame);
  end;
  pnCustomSettings.Visible := False;
end;

function TTaskEditParentForm.CreateTaskSourceEditForm(taskSourcesList: TTaskSourcesList): TSelectTaskSourcesForm;
begin
  Result := ShowSelectSourcesForm(taskSourcesList) as TSelectTaskSourcesForm;
end;

procedure TTaskEditParentForm.SetTaskSourcesList(const Value: TTaskSourcesList);
begin
  if FTaskSourcesListOwned and (FTaskSourcesList <> Value) then
  begin
    FreeAndNil(FTaskSourcesList);
    FTaskSourcesListOwned := False;
  end;

  FTaskSourcesList := Value;

  if not Assigned(Value) then
    FTaskSourcesListOwned := False;

  RefreshTaskSourcesList;
end;

procedure TTaskEditParentForm.SetTaskTypesList(list: TTaskTypesList);
begin
  FTaskTypesList := list;
  cbModule.Items.Clear;
 for var ttype in FTaskTypesList do
   cbModule.Items.AddPair((ttype as TTaskTypes).Caption,(ttype as TTaskTypes).Name)
end;

procedure TTaskEditParentForm.RefreshTaskSourcesList;
begin
  EnsureSourcesGrid;
  FillMemFromList;
//  if Assigned(lbTaskSources) then
//    lbTaskSources.Visible := False;
  if Assigned(gridSources) then
    gridSources.Visible := True;
end;

procedure TTaskEditParentForm.AssignTaskSourcesFrom(const ASourceList: TTaskSourcesList);
var
  Source: TTaskSource;
  NewSource: TTaskSource;
  CreatedList: Boolean;
begin
  CreatedList := False;
  if not Assigned(FTaskSourcesList) then
  begin
    FTaskSourcesList := TTaskSourcesList.Create(True);
    CreatedList := True;
  end;
  if CreatedList then
    FTaskSourcesListOwned := True;

  FTaskSourcesList.Clear;

  if Assigned(ASourceList) then
  begin
    for var I := 0 to ASourceList.Count - 1 do
    begin
      if not (ASourceList.Items[I] is TTaskSource) then
        Continue;

      Source := TTaskSource(ASourceList.Items[I]);
      if not Assigned(Source) then
        Continue;

      NewSource := TTaskSource.Create;
      try
        NewSource.Assign(Source);
        FTaskSourcesList.Add(NewSource);
      except
        NewSource.Free;
        raise;
      end;
    end;
  end;

  RefreshTaskSourcesList;
end;

procedure TTaskEditParentForm.btnOkClick(Sender: TObject);
begin
  SyncListFromMem;
  inherited;
end;

procedure TTaskEditParentForm.btnSourcesEditClick(Sender: TObject);
var
  SelectForm: TSelectTaskSourcesForm;
begin
  SelectForm := CreateTaskSourceEditForm(TaskSourcesList);
  if not Assigned(SelectForm) then
    Exit;

  SelectForm.ShowModal(SourcesEditCallback);
end;

procedure TTaskEditParentForm.SourcesEditCallback(ASender: TComponent; AResult: Integer);
var
  SelectForm: TSelectTaskSourcesForm;
begin
  if not (ASender is TSelectTaskSourcesForm) then
    Exit;

  SelectForm := TSelectTaskSourcesForm(ASender);

  if AResult = mrOk then
    AssignTaskSourcesFrom(SelectForm.TaskSourceList);
end;

procedure TTaskEditParentForm.UniFormShow(Sender: TObject);
begin
  inherited;
  EnsureSourcesGrid;
  RefreshTaskSourcesList;
  teTid.Enabled:= not IsEdit;
  cbModule.Enabled:= not IsEdit;
end;

procedure TTaskEditParentForm.SetEntity(AEntity: TFieldSet);
begin
  ClearCustomSettingsFrame;
  ///        -   !
  if not (AEntity is TTask) then
  begin
    Log('TTaskEditParentForm.SetEntity error in AEntity type', lrtError);
    exit;
  end;

  try
    inherited SetEntity(AEntity);

    ///
    teTid.Text         := Task.Tid;
    teCompId.Text      := Task.CompId;
    teDepId.Text       := Task.DepId;
    cbModule.ItemIndex := ModuleIndex(Task.Module);
    meDef.Lines.Text   := Task.Def;
    cbEnabled.Checked  := Task.Enabled;

  except
    Log('TTaskEditParentForm.SetEntity error', lrtError);
    ClearCustomSettingsFrame;
  end;
end;

procedure TTaskEditParentForm.EnsureSourcesGrid;
begin
  if Assigned(SourcesDS) and Assigned(SourcesMem) then
    SourcesDS.DataSet := SourcesMem;
  if Assigned(gridSources) then
    gridSources.DataSource := SourcesDS;
  if Assigned(SourcesMem) and (not SourcesMem.Active) then
  begin
    if SourcesMem.FieldDefs.Count = 0 then
    begin
      SourcesMem.FieldDefs.Add('enabled', ftBoolean);
      SourcesMem.FieldDefs.Add('name', ftString, 255);
      SourcesMem.FieldDefs.Add('sid', ftString, 120);
    end;
    SourcesMem.CreateDataSet;
  end;
end;

procedure TTaskEditParentForm.FillMemFromList;
begin
  if not Assigned(SourcesMem) then Exit;
  SourcesMem.DisableControls;
  try
    SourcesMem.EmptyDataSet;
    if Assigned(FTaskSourcesList) then
      for var I := 0 to FTaskSourcesList.Count - 1 do
      begin
        var S := TTaskSource(FTaskSourcesList.Items[I]);
        SourcesMem.Append;
        SourcesMem.FieldByName('enabled').AsBoolean := S.Enabled;
        SourcesMem.FieldByName('name').AsString := S.Name;
        SourcesMem.FieldByName('sid').AsString := S.Sid;
        SourcesMem.Post;
      end;
  finally
    SourcesMem.EnableControls;
  end;
end;

procedure TTaskEditParentForm.SyncListFromMem;
begin
  if not Assigned(FTaskSourcesList) or not Assigned(SourcesMem) then Exit;
  SourcesMem.DisableControls;
  FTaskSourcesList.Clear;
  try
    SourcesMem.First;
    while not SourcesMem.Eof do
    begin
      var Sid := SourcesMem.FieldByName('sid').AsString;
      var NewSrc := TTaskSource.Create;
      try
        NewSrc.Sid := SourcesMem.FieldByName('sid').AsString;
        NewSrc.Name := SourcesMem.FieldByName('name').AsString;
        NewSrc.Enabled := SourcesMem.FieldByName('enabled').AsBoolean;
        FTaskSourcesList.Add(NewSrc);
      except
        NewSrc.Free;
        raise;
      end;
    SourcesMem.Next;
    end;
  finally
    SourcesMem.EnableControls;
  end;
end;





procedure TTaskEditParentForm.unbtnSrcDel1Click(Sender: TObject);
begin
  inherited;
  SourcesMem.Delete;
end;

end.
