unit SelectTaskSourcesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniGUIBaseClasses, uniMultiItem, uniListBox,
  uniPanel, uniLabel, uniPageControl, uniButton,
  TaskSourceUnit, SourceUnit, SourcesBrokerUnit;

type
  TSelectTaskSourcesForm = class(TUniForm)
    lbTaskSources: TUniListBox;
    lbAllSources: TUniListBox;
    pcEntityInfo: TUniPageControl;
    tsSourceInfo: TUniTabSheet;
    cpSourceInfo: TUniContainerPanel;
    cpSourceInfoID: TUniContainerPanel;
    lSourceInfoID: TUniLabel;
    lSourceInfoIDValue: TUniLabel;
    pSeparator1: TUniPanel;
    cpSourceInfoName: TUniContainerPanel;
    lSourceInfoName: TUniLabel;
    lSourceInfoNameValue: TUniLabel;
    pSeparator2: TUniPanel;
    lSourceCaption: TUniLabel;
    cpSourceInfoCreated: TUniContainerPanel;
    lSourceInfoCreated: TUniLabel;
    lSourceInfoCreatedValue: TUniLabel;
    pSeparator3: TUniPanel;
    cpSourceInfoUpdated: TUniContainerPanel;
    lTaskInfoUpdated: TUniLabel;
    lTaskInfoUpdatedValue: TUniLabel;
    pSeparator4: TUniPanel;
    cpSourceInfoModule: TUniContainerPanel;
    lSourceInfoModule: TUniLabel;
    lSourceInfoModuleValue: TUniLabel;
    pSeparator5: TUniPanel;
    btnAddSource: TUniButton;
    btnOk: TUniButton;
    btnCancel: TUniButton;
    procedure btnAddSourceClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
  private
    AllSourcesBroker: TSourcesBroker;
    AllSourceList: TSourceList;
    FTaskSourceList: TTaskSourceList;
    procedure AddSourceToTaskList(ASource: TSource);
    procedure LoadAllSources;
    procedure PopulateAllSources;
    procedure PopulateTaskSources;
    function TaskSourceExists(const ASid: string): Boolean;
    procedure SetTaskSourceList(const Value: TTaskSourceList);
  public
    property TaskSourceList: TTaskSourceList read FTaskSourceList write SetTaskSourceList;
  end;

function SelectTaskSourcesForm: TSelectTaskSourcesForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, LoggingUnit, EntityUnit;

function SelectTaskSourcesForm: TSelectTaskSourcesForm;
begin
  Result := TSelectTaskSourcesForm(UniMainModule.GetFormInstance(TSelectTaskSourcesForm));
end;

procedure TSelectTaskSourcesForm.AddSourceToTaskList(ASource: TSource);
var
  NewSource: TTaskSource;
begin
  if not Assigned(ASource) or not Assigned(FTaskSourceList) then
    Exit;

  if TaskSourceExists(ASource.Sid) then
    Exit;

  NewSource := TTaskSource.Create;
  try
    NewSource.Assign(ASource);
    NewSource.Enabled := ASource.Enabled;
    FTaskSourceList.Add(NewSource);
  except
    NewSource.Free;
    raise;
  end;
end;

procedure TSelectTaskSourcesForm.btnAddSourceClick(Sender: TObject);
var
  Added: Boolean;
begin
  Added := False;

  if Assigned(lbAllSources) then
  begin
    for var I := 0 to lbAllSources.Items.Count - 1 do
      if lbAllSources.Selected[I] then
        if lbAllSources.Items.Objects[I] is TSource then
        begin
          AddSourceToTaskList(TSource(lbAllSources.Items.Objects[I]));
          Added := True;
        end;

    if not Added then
      if (lbAllSources.ItemIndex >= 0) and (lbAllSources.ItemIndex < lbAllSources.Items.Count) then
        if lbAllSources.Items.Objects[lbAllSources.ItemIndex] is TSource then
        begin
          AddSourceToTaskList(TSource(lbAllSources.Items.Objects[lbAllSources.ItemIndex]));
          Added := True;
        end;
  end;

  if Added then
    PopulateTaskSources;
end;

procedure TSelectTaskSourcesForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TSelectTaskSourcesForm.btnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TSelectTaskSourcesForm.LoadAllSources;
var
  PageCount: Integer;
  EntityList: TEntityList;
begin
  if Assigned(lbAllSources) then
    lbAllSources.Items.Clear;

  if not Assigned(AllSourcesBroker) then
    Exit;

  PageCount := 0;
  EntityList := nil;

  try
    try
      EntityList := AllSourcesBroker.List(PageCount);
    except
      on E: Exception do
      begin
        Log('TSelectTaskSourcesForm.LoadAllSources list error: ' + E.Message, lrtError);
        EntityList := nil;
      end;
    end;

    FreeAndNil(AllSourceList);

    if not Assigned(EntityList) then
      Exit;

    if EntityList is TSourceList then
    begin
      AllSourceList := TSourceList(EntityList);
      EntityList := nil;
    end;
  finally
    EntityList.Free;
  end;

  PopulateAllSources;
end;

procedure TSelectTaskSourcesForm.PopulateAllSources;
var
  Source: TSource;
  DisplayName: string;
begin
  if not Assigned(lbAllSources) then
    Exit;

  lbAllSources.Items.BeginUpdate;
  try
    lbAllSources.Items.Clear;

    if not Assigned(AllSourceList) then
      Exit;

    for var I := 0 to AllSourceList.Count - 1 do
    begin
      if not (AllSourceList.Items[I] is TSource) then
        Continue;

      Source := TSource(AllSourceList.Items[I]);
      if not Assigned(Source) then
        Continue;

      DisplayName := Source.Name;
      if DisplayName = '' then
        DisplayName := Source.Sid;

      lbAllSources.Items.AddObject(DisplayName, Source);
    end;
  finally
    lbAllSources.Items.EndUpdate;
  end;
end;

procedure TSelectTaskSourcesForm.PopulateTaskSources;
var
  Source: TTaskSource;
  Index: Integer;
begin
  if not Assigned(lbTaskSources) then
    Exit;

  lbTaskSources.Items.BeginUpdate;
  try
    lbTaskSources.Items.Clear;

    if not Assigned(FTaskSourceList) then
      Exit;

    for var I := 0 to FTaskSourceList.Count - 1 do
    begin
      if not (FTaskSourceList.Items[I] is TTaskSource) then
        Continue;

      Source := TTaskSource(FTaskSourceList.Items[I]);
      if not Assigned(Source) then
        Continue;

      Index := lbTaskSources.Items.AddObject(Source.Name, Source);
      if (Index >= 0) and (Index < lbTaskSources.Items.Count) then
        lbTaskSources.Selected[Index] := Source.Enabled;
    end;
  finally
    lbTaskSources.Items.EndUpdate;
  end;
end;

function TSelectTaskSourcesForm.TaskSourceExists(const ASid: string): Boolean;
begin
  Result := False;

  if not Assigned(FTaskSourceList) then
    Exit;

  for var I := 0 to FTaskSourceList.Count - 1 do
  begin
    if not (FTaskSourceList.Items[I] is TTaskSource) then
      Continue;

    if SameText(TTaskSource(FTaskSourceList.Items[I]).Sid, ASid) then
      Exit(True);
  end;
end;

procedure TSelectTaskSourcesForm.SetTaskSourceList(const Value: TTaskSourceList);
var
  Source: TTaskSource;
  NewSource: TTaskSource;
begin
  if not Assigned(FTaskSourceList) then
    Exit;

  FTaskSourceList.Clear;

  if Assigned(Value) then
  begin
    for var I := 0 to Value.Count - 1 do
    begin
      if not (Value.Items[I] is TTaskSource) then
        Continue;

      Source := TTaskSource(Value.Items[I]);
      if not Assigned(Source) then
        Continue;

      NewSource := TTaskSource.Create;
      try
        NewSource.Assign(Source);
        FTaskSourceList.Add(NewSource);
      except
        NewSource.Free;
        raise;
      end;
    end;
  end;

  PopulateTaskSources;
end;

procedure TSelectTaskSourcesForm.UniFormCreate(Sender: TObject);
begin
  FTaskSourceList := TTaskSourceList.Create(True);
  AllSourceList := nil;
  AllSourcesBroker := TSourcesBroker.Create;

  LoadAllSources;
  PopulateTaskSources;
end;

procedure TSelectTaskSourcesForm.UniFormDestroy(Sender: TObject);
begin
  FreeAndNil(AllSourceList);
  FreeAndNil(AllSourcesBroker);
  FreeAndNil(FTaskSourceList);
end;

end.
