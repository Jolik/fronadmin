unit SelectTaskSourcesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniGUIBaseClasses, uniMultiItem, uniListBox,
  uniPanel, uniLabel, uniPageControl, uniButton, uniImageList, uniBitBtn,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, uniBasicGrid, uniDBGrid,
  TaskSourceUnit, SourceUnit, SourcesRestBrokerUnit, TaskSourceHttpRequests,
  uniEdit, uniTimer, uniGroupBox;

type
  TSelectTaskSourcesForm = class(TUniForm)
    pcEntityInfo: TUniPageControl;
    tsSourceInfo: TUniTabSheet;
    cpSourceInfo: TUniContainerPanel;
    cpSourceInfoID: TUniContainerPanel;
    lSourceInfoID: TUniLabel;
    lSourceInfoIDValue: TUniLabel;
    pSeparator1: TUniPanel;
    cpSourceInfoName: TUniContainerPanel;
    lSourceInfoName: TUniLabel;
    unlblregion: TUniLabel;
    pSeparator2: TUniPanel;
    lSourceCaption: TUniLabel;
    cpSourceInfoCreated: TUniContainerPanel;
    lSourceInfoCreated: TUniLabel;
    lSourceInfoCreatedValue: TUniLabel;
    pSeparator3: TUniPanel;
    uncntnrpnSourceInfoCoords: TUniGroupBox;
    uncntnrpnSourceInfoRegion: TUniContainerPanel;
    lSourceInfoModule: TUniLabel;
    lSourceInfoModuleValue: TUniLabel;
    pSeparator5: TUniPanel;
    dsSourcesDS: TDataSource;
    SourcesMem: TFDMemTable;
    SourcesMemselected: TBooleanField;
    SourcesMemsid: TStringField;
    SourcesMemname: TStringField;
    gridSources: TUniDBGrid;
    unpnlFilter: TUniPanel;
    undtSourceFilter: TUniEdit;
    unlblFilter: TUniLabel;
    FilterDebounceTimer: TUniTimer;
    unlbllat: TUniLabel;
    unlbllon: TUniLabel;
    unlbllat1: TUniLabel;
    unlblon: TUniLabel;
    uncntnrpnSourceInfoName: TUniContainerPanel;
    unlbl1: TUniLabel;
    unlblSourceInfoNameValue: TUniLabel;
    unpnl1: TUniPanel;
    uncntnrpnUpdate: TUniContainerPanel;
    unlblUpdate: TUniLabel;
    unlblUpdatedVal: TUniLabel;
    unpnl2: TUniPanel;
    pnBottom: TUniContainerPanel;
    btnOk: TUniButton;
    btnCancel: TUniButton;
    SourcesMemenabled: TBooleanField;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
    procedure lbAllSourcesClick(Sender: TObject);
    procedure lbAllSourcesChange(Sender: TObject);
    procedure undtSourceFilterChange(Sender: TObject);
    procedure FilterDebounceTimerTimer(Sender: TObject);
    procedure gridSourcesSelectionChange(Sender: TObject);
  private
    AllSourceList: TSourceList;
    FTaskSourceList: TTaskSourceList;
    FCurrentSourceSid: string;
    FSourcesBroker:TSourcesRestBroker;
    procedure LoadAllSources;
    function FindTaskSource(const ASid: string): TTaskSource;
    function FindSourceBySid(const ASid: string): TSource;
    procedure SetTaskSourceList(const Value: TTaskSourceList);
    procedure ClearSourceInfo;
    procedure UpdateSelectedSourceInfo;
    procedure UpdateSourceInfoDisplay(ASource: TSource);
    procedure ApplySourceFilter;
  protected
    function CreateSourcesBroker(): TSourcesRestBroker; virtual;
  public
    property TaskSourceList: TTaskSourceList read FTaskSourceList write SetTaskSourceList;
  end;

function ShowSelectSourcesForm(tasksourceList: TTaskSourceList = nil): TSelectTaskSourcesForm;

implementation
{$R *.dfm}

uses
  MainModule, uniGUIApplication, LoggingUnit, EntityUnit, SourceHttpRequests, IdHTTP,
  System.DateUtils;

function ShowSelectSourcesForm(tasksourceList: TTaskSourceList = nil): TSelectTaskSourcesForm;
begin
  Result := TSelectTaskSourcesForm(UniMainModule.GetFormInstance(TSelectTaskSourcesForm));
  Result.TaskSourceList:=tasksourceList;
  Result.LoadAllSources;

end;

procedure TSelectTaskSourcesForm.ClearSourceInfo;
begin
    lSourceInfoIDValue.Caption := '';
    unlblSourceInfoNameValue.Caption := '';
    lSourceInfoModuleValue.Caption := '';
    lSourceInfoCreatedValue.Caption := '';
    unlblUpdatedVal.Caption := '';
    unlbllat.Caption:='';
    unlbllon.Caption:='';
    unlblregion.Caption:='';
    tsSourceInfo.TabVisible := False;

  FCurrentSourceSid := '';
end;

function TSelectTaskSourcesForm.CreateSourcesBroker: TSourcesRestBroker;
begin
  Result := TSourcesRestBroker.Create(UniMainModule.XTicket);
end;


procedure TSelectTaskSourcesForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TSelectTaskSourcesForm.btnOkClick(Sender: TObject);
var
  Bookmark: TBookmark;
begin
  if Assigned(FTaskSourceList) then
  begin
    FTaskSourceList.Clear;

    if Assigned(SourcesMem) and SourcesMem.Active then
    begin
      SourcesMem.DisableControls;
      Bookmark := nil;
      if not SourcesMem.IsEmpty then
        Bookmark := SourcesMem.GetBookmark;
      try
        SourcesMem.First;
        while not SourcesMem.Eof do
        begin
          if SourcesMemselected.AsBoolean then
          begin
            var NewSource := TTaskSource.Create;
            try
              NewSource.Sid := SourcesMemsid.AsString;
              NewSource.Name := SourcesMemname.AsString;
              NewSource.Enabled := SourcesMemenabled.AsBoolean;
              FTaskSourceList.Add(NewSource);
            except
              NewSource.Free;
              raise;
            end;
          end;
          SourcesMem.Next;
        end;
      finally
        if (Bookmark <> nil) and SourcesMem.BookmarkValid(Bookmark) then
          SourcesMem.GotoBookmark(Bookmark);
        if Bookmark <> nil then
          SourcesMem.FreeBookmark(Bookmark);
        SourcesMem.EnableControls;
      end;
    end;
  end;
  ModalResult := mrOk;
end;


procedure TSelectTaskSourcesForm.LoadAllSources;
var
  PageCount: Integer;
  tasksList: TTaskSourceList;
begin
  ClearSourceInfo;
  SourcesMem.EmptyDataSet;
  if not Assigned(FSourcesBroker) then
    Exit;

  SourcesMem.DisableControls;
  try
    FreeAndNil(AllSourceList);
    AllSourceList := TSourceList.Create;

    PageCount := 0;
    tasksList := nil;

    try
      var Req := FSourcesBroker.CreateReqList();
      var Resp := FSourcesBroker.ListAll(Req as TSourceReqList);
      try
        if Assigned(Resp) then
          for var srcf in Resp.SourceList do begin
            var src := srcf as TSource;
            var Copy := TSource.Create;
            Copy.Assign(src);
            AllSourceList.Add(Copy);
            SourcesMem.Append;
            var tsrc := FindTaskSource(src.Sid);
            SourcesMem.FieldByName('selected').AsBoolean := tsrc <> nil;
            SourcesMem.FieldByName('name').AsString := src.Name.ValueOrDefault('');
            SourcesMem.FieldByName('sid').AsString := src.Sid;
            SourcesMem.FieldByName('enabled').AsBoolean := (tsrc <> nil) and tsrc.Enabled;

            SourcesMem.Post;
          end;
      finally
        Resp.Free;
        Req.Free;
      end;
    except
      on E: EIdHTTPProtocolException do begin
        var msg := Format('LoadAllSources failed. HTTP %d'#13#10'%s', [E.ErrorCode, E.ErrorMessage]);
        Log(msg, lrtError);
        MessageDlg(msg, TMsgDlgType.mtWarning, [mbOK], nil);
      end;

      on E: Exception do begin
        var msg := Format('Failed to fetch sources. %s', [e.Message]);
        Log(msg, lrtError);
        MessageDlg(msg, TMsgDlgType.mtWarning, [mbOK], nil);
      end;
    end;
  finally
    SourcesMem.EnableControls;
  end;

  if SourcesMem.Active and not SourcesMem.IsEmpty then
    SourcesMem.First;

  UpdateSelectedSourceInfo;
end;
procedure TSelectTaskSourcesForm.lbAllSourcesChange(Sender: TObject);
begin
  UpdateSelectedSourceInfo;
end;

procedure TSelectTaskSourcesForm.lbAllSourcesClick(Sender: TObject);
begin
  UpdateSelectedSourceInfo;
end;


function TSelectTaskSourcesForm.FindTaskSource(const ASid: string): TTaskSource;
begin
  Result := nil;

  if not Assigned(FTaskSourceList) then
    Exit;

  for var I := 0 to FTaskSourceList.Count - 1 do
  begin
    if not (FTaskSourceList.Items[I] is TTaskSource) then
      Continue;

    if SameText(TTaskSource(FTaskSourceList.Items[I]).Sid, ASid) then
      Exit(TTaskSource(FTaskSourceList.Items[I]));
  end;
end;

function TSelectTaskSourcesForm.FindSourceBySid(const ASid: string): TSource;
begin
  Result := nil;

  if ASid.IsEmpty or not Assigned(AllSourceList) then
    Exit;

  for var Item in AllSourceList do
    if (Item is TSource) and SameText(TSource(Item).Sid, ASid) then
      Exit(TSource(Item));
end;

procedure TSelectTaskSourcesForm.undtSourceFilterChange(Sender: TObject);
begin
  FilterDebounceTimer.Enabled := False;
  FilterDebounceTimer.Enabled := True;
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

  ApplySourceFilter;
  UpdateSelectedSourceInfo;
end;

procedure TSelectTaskSourcesForm.UpdateSelectedSourceInfo;
var
  SelectedSource: TSource;
  CurrentSid: string;
begin
  SelectedSource := nil;

  if Assigned(SourcesMem) and SourcesMem.Active and not SourcesMem.IsEmpty then
  begin
    CurrentSid := SourcesMem.FieldByName('sid').AsString;
    SelectedSource := FindSourceBySid(CurrentSid);
  end;

  UpdateSourceInfoDisplay(SelectedSource);
end;

procedure TSelectTaskSourcesForm.UpdateSourceInfoDisplay(ASource: TSource);
var
  InfoEntity: TEntity;
  InfoSource: TSource;
  OwnsInfoSource: Boolean;
  DateText: string;
const
  DateFormat = 'dd.mm.yyyy HH:nn';
begin
  if not Assigned(ASource) then
  begin
    ClearSourceInfo;
    Exit;
  end;

  if SameText(FCurrentSourceSid, ASource.Sid) and tsSourceInfo.TabVisible then
    Exit;

  InfoEntity := nil;
  InfoSource := ASource;
  OwnsInfoSource := False;


  lSourceInfoIDValue.Caption := InfoSource.Sid;
  unlblSourceInfoNameValue.Caption := InfoSource.Name.ValueOrDefault('');
  lSourceInfoModuleValue.Caption := InfoSource.Index.ValueOrDefault('');
  unlblregion.Caption := InfoSource.Region.ValueOrDefault('');
  if InfoSource.Lat.HasValue then
    unlbllat.Caption := FloatToStr(InfoSource.Lat.Value)
  else
    unlbllat.Caption := '';
  if InfoSource.Lon.HasValue then
    unlbllon.Caption := FloatToStr(InfoSource.Lon.Value)
  else
    unlbllon.Caption := '';


  if InfoSource.Created.HasValue then
  begin
    DateTimeToString(DateText, DateFormat, UnixToDateTime(InfoSource.Created.Value, True));
    lSourceInfoCreatedValue.Caption := DateText;
  end
  else
    lSourceInfoCreatedValue.Caption := '';

  if InfoSource.Updated.HasValue then
  begin
    DateTimeToString(DateText, DateFormat, UnixToDateTime(InfoSource.Updated.Value, True));
    unlblUpdatedVal.Caption := DateText;
  end
  else
    unlblUpdatedVal.Caption := '';

  tsSourceInfo.TabVisible := True;

  FCurrentSourceSid := InfoSource.Sid;

  if OwnsInfoSource then
    InfoSource.Free;
end;

procedure TSelectTaskSourcesForm.UniFormCreate(Sender: TObject);
begin
  FTaskSourceList := TTaskSourceList.Create(True);
  FSourcesBroker:= CreateSourcesBroker();
  ClearSourceInfo;
end;

procedure TSelectTaskSourcesForm.UniFormDestroy(Sender: TObject);
begin
  FreeAndNil(AllSourceList);
  FreeAndNil(FTaskSourceList);
end;

procedure TSelectTaskSourcesForm.ApplySourceFilter;
var
  FilterText: string;
  Escaped: string;
  Mask: string;
begin
  if not Assigned(SourcesMem) then
    Exit;

  FilterText := Trim(undtSourceFilter.Text);
  SourcesMem.DisableControls;
  try
    SourcesMem.Filtered := False;

    if FilterText.IsEmpty then
    begin
      SourcesMem.Filter := '';
      SourcesMem.Filtered := False;
    end
    else
    begin
      Escaped := StringReplace(FilterText, '''', '''''', [rfReplaceAll]);
      Mask := '%' + Escaped + '%';

      SourcesMem.FilterOptions := [foCaseInsensitive];
      SourcesMem.Filter := Format('(name LIKE ''%s'') OR (sid LIKE ''%s'')', [Mask, Mask]);
      SourcesMem.Filtered := True;
    end;

    if not SourcesMem.IsEmpty then
      SourcesMem.First;
  finally
    SourcesMem.EnableControls;
  end;

  gridSources.Refresh;
end;

procedure TSelectTaskSourcesForm.FilterDebounceTimerTimer(Sender: TObject);
begin
  if Assigned(FilterDebounceTimer) then
    FilterDebounceTimer.Enabled := False;
  ApplySourceFilter;
  UpdateSelectedSourceInfo;
end;

procedure TSelectTaskSourcesForm.gridSourcesSelectionChange(Sender: TObject);
begin
  UpdateSelectedSourceInfo;
end;

end.
