unit SourcesFormUnit;

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
  uniEdit, uniTimer, uniGroupBox, uniHTMLFrame, uniMap, uniSpeedButton,
  SourceEditFormUnit, uniCheckBox, uniMainMenu, Vcl.Menus;

type
  TSourcesForm = class(TUniForm)
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
    SourcesMemsid: TStringField;
    SourcesMemname: TStringField;
    gridSources: TUniDBGrid;
    unpnlFilter: TUniContainerPanel;
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
    unpnl2: TUniContainerPanel;
    pnBottom: TUniContainerPanel;
    btnOk: TUniButton;
    btnCancel: TUniButton;
    SourcesMemlast_insert1: TDateTimeField;
    untbshtMap1: TUniTabSheet;
    unmpSource1: TUniMap;
    uncntnrpnBtns: TUniContainerPanel;
    uncntnrpnBtns1: TUniContainerPanel;
    unspdbtnCreate1: TUniSpeedButton;
    unspdbtnEdit: TUniSpeedButton;
    unchckbxShowArchived: TUniCheckBox;
    unspdbtnRefresh: TUniSpeedButton;
    pmGridSources: TUniPopupMenu;
    miCreateSource: TUniMenuItem;
    miEditSource: TUniMenuItem;
    miArchiveSource: TUniMenuItem;
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
    procedure lbAllSourcesClick(Sender: TObject);
    procedure lbAllSourcesChange(Sender: TObject);
    procedure undtSourceFilterChange(Sender: TObject);
    procedure FilterDebounceTimerTimer(Sender: TObject);
    procedure gridSourcesSelectionChange(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure UniFormAjaxEvent(Sender: TComponent; EventName: string;
      Params: TUniStrings);
    procedure unmpSource1MarkerClick(Sender: TObject; const Lat, Lng: Double;
      const Zoom, X, Y, Id: Integer);
    procedure unmpSource1MapReady(Sender: TObject);
    procedure unspdbtnEditClick(Sender: TObject);
    procedure unspdbtnCreate1Click(Sender: TObject);
    procedure unchckbxShowArchivedChange(Sender: TObject);
    procedure unspdbtnRefreshClick(Sender: TObject);
    procedure miCreateSourceClick(Sender: TObject);
    procedure miEditSourceClick(Sender: TObject);
    procedure miArchiveSourceClick(Sender: TObject);
    procedure pmGridSourcesPopup(Sender: TObject);
  protected
    SourceList: TSourceList;
    FCurrentSourceSid: string;
    FSelectedSource: TSource;
    FSourcesBroker:TSourcesRestBroker;
    FsourceEditForm:TSourceEditForm;
    procedure LoadSources;
    function FindSourceBySid(const ASid: string): TSource;
    procedure ClearSourceInfo;
    procedure UpdateSelectedSourceInfo;
    procedure UpdateSourceInfoDisplay(ASource: TSource);
    procedure ApplySourceFilter;
    function CreateSourcesBroker(): TSourcesRestBroker; virtual;
    procedure ArchiveSelectedSource;
  public
    property SelectedSource:TSource read FSelectedSource write FSelectedSource;
  end;

function ShowSourcesForm: TSourcesForm;

implementation
{$R *.dfm}

uses
  MainModule, uniGUIApplication, System.DateUtils, IdHTTP, LoggingUnit,
  EntityUnit, SourceHttpRequests, HttpClientUnit, BaseResponses;

function ShowSourcesForm: TSourcesForm;
begin
  Result := TSourcesForm(UniMainModule.GetFormInstance(TSourcesForm));
  Result.LoadSources;

end;

procedure TSourcesForm.btnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TSourcesForm.ClearSourceInfo;
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

function TSourcesForm.CreateSourcesBroker: TSourcesRestBroker;
begin
  Result := TSourcesRestBroker.Create(UniMainModule.XTicket);
end;


procedure TSourcesForm.LoadSources;
var
  PageCount: Integer;
  tasksList: TTaskSourceList;
begin
  ClearSourceInfo;
  SourcesMem.EmptyDataSet;
  if not Assigned(FSourcesBroker) then
    Exit;
  SourcesMem.Active:= true;
  SourcesMem.DisableControls;
  try
    FreeAndNil(SourceList);
    SourceList := TSourceList.Create;
//    unmpSource1.Markers.Clear;
    PageCount := 0;
    tasksList := nil;

    try
      var Req := FSourcesBroker.CreateReqList() as TSourceReqList;
      if unchckbxShowArchived.Checked then
        Req.SetFlags(['archiveonly']);
      var Resp := FSourcesBroker.ListAll(Req as TSourceReqList);
      try
        if Assigned(Resp) then
          for var srcf in Resp.SourceList do
          begin
            var src := srcf as TSource;
            var Copy := TSource.Create;
            Copy.Assign(src);
            SourceList.Add(Copy);
            SourcesMem.Append;
            SourcesMem.FieldByName('name').AsString := src.Name.ValueOrDefault('');
            SourcesMem.FieldByName('sid').AsString := src.Sid;
//            if (src.Lat <> 0) and (src.Lon <> 0) then
//            with unmpSource1.Markers.Add do begin
//              Latitude:= src.Lat;
//              Longitude:= src.Lon;
//              Title:= Format('%s(%s)', [src.Name,src.Sid]);
//            end;

            if src.LastInsert.HasValue then
              SourcesMem.FieldByName('last_insert').AsDateTime := UnixToDateTime(src.LastInsert.Value, True)
            else
              SourcesMem.FieldByName('last_insert').Clear;
            SourcesMem.Post;
          end;
      finally
        unmpSource1.Refresh;
        Resp.Free;
        Req.Free;
      end;
    except
      on E: EIdHTTPProtocolException do begin
        var msg := Format('LoadSources failed. HTTP %d'#13#10'%s', [E.ErrorCode, E.ErrorMessage]);
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
procedure TSourcesForm.lbAllSourcesChange(Sender: TObject);
begin
  UpdateSelectedSourceInfo;
end;

procedure TSourcesForm.lbAllSourcesClick(Sender: TObject);
begin
  UpdateSelectedSourceInfo;
end;


function TSourcesForm.FindSourceBySid(const ASid: string): TSource;
begin
  Result := nil;

  if ASid.IsEmpty or not Assigned(SourceList) then
    Exit;

  for var Item in SourceList do
    if (Item is TSource) and SameText(TSource(Item).Sid, ASid) then
      Exit(TSource(Item));
end;

procedure TSourcesForm.unchckbxShowArchivedChange(Sender: TObject);
begin
 LoadSources;
end;

procedure TSourcesForm.undtSourceFilterChange(Sender: TObject);
begin
  FilterDebounceTimer.Enabled := False;
  FilterDebounceTimer.Enabled := True;
end;

procedure TSourcesForm.UpdateSelectedSourceInfo;
var
  resp: TSourceInfoResponse;
  CurrentSid: string;
begin
  FreeAndNil(SelectedSource);

  if Assigned(SourcesMem) and SourcesMem.Active and not SourcesMem.IsEmpty then
  begin
    CurrentSid := SourcesMem.FieldByName('sid').AsString;
    var req := FSourcesBroker.CreateReqInfo(CurrentSid) as TSourceReqInfo;
    req.SetFlags(['contacts']);
    try
      resp := FSourcesBroker.Info(req);
      SelectedSource := TSource.Create;
      SelectedSource.Assign(resp.Source);
    finally
      req.Free;
      resp.Free;
    end;
  end;

  UpdateSourceInfoDisplay(SelectedSource);
end;

procedure TSourcesForm.UpdateSourceInfoDisplay(ASource: TSource);
var
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

  var fs := TFormatSettings.Create;
  fs.DecimalSeparator := '.';
  var mapName := unmpSource1.JSName + '.uniMap';
  var HasCoords := ASource.Lat.HasValue and ASource.Lon.HasValue;
  if HasCoords then
    UniSession.AddJS(Format(
      '(function tryCenterAndPopup(){' +
      '  if(window.%0:s){' +
      '    %0:s.invalidateSize();' +
      '    %0:s.flyTo([%1:s,%2:s], 9, {animate:true, duration:0.7});' +
      '    %0:s.eachLayer(function(l){' +
      '      if(l instanceof L.Marker && l.getPopup && l.getPopup().getContent()=="%3:s"){' +
      '        l.openPopup();' +
      '      }' +
      '    });' +
      '  } else {' +
      '    setTimeout(tryCenterAndPopup,300);' +
      '  }' +
      '})();',
      [
        mapName,
        FloatToStr(ASource.Lat.Value, fs),
        FloatToStr(ASource.Lon.Value, fs),
        StringReplace(ASource.Name.ValueOrDefault(''), '"', '\"', [rfReplaceAll])
      ]
    ));

  lSourceInfoIDValue.Caption := ASource.Sid;
  unlblSourceInfoNameValue.Caption := ASource.Name.ValueOrDefault('');
  lSourceInfoModuleValue.Caption := ASource.Index.ValueOrDefault('');
  unlblregion.Caption := ASource.Region.ValueOrDefault('');
  if HasCoords then
  begin
    unlbllat.Caption := FloatToStr(ASource.Lat.Value);
    unlbllon.Caption := FloatToStr(ASource.Lon.Value);
  end
  else
  begin
    unlbllat.Caption := '';
    unlbllon.Caption := '';
  end;


  if ASource.Created.HasValue then
  begin
    DateTimeToString(DateText, DateFormat, UnixToDateTime(ASource.Created.Value, True));
    lSourceInfoCreatedValue.Caption := DateText;
  end
  else
    lSourceInfoCreatedValue.Caption := '';

  if ASource.Updated.HasValue then
  begin
    DateTimeToString(DateText, DateFormat, UnixToDateTime(ASource.Updated.Value, True));
    unlblUpdatedVal.Caption := DateText;
  end
  else
    unlblUpdatedVal.Caption := '';

  tsSourceInfo.TabVisible := True;
  FCurrentSourceSid := ASource.Sid;

end;

procedure TSourcesForm.UniFormAjaxEvent(Sender: TComponent; EventName: string;
  Params: TUniStrings);
var
  ScreenX, ScreenY: Integer;
begin
  if EventName = 'marker_click' then
  begin
    ShowMessage('Marker clicked: ' + Params.Values['id']);
    // Placeholder for handling map marker clicks
  end
  else if EventName = 'ShowGridPopup' then
  begin
    ScreenX := StrToIntDef(Params.Values['x'], 0);
    ScreenY := StrToIntDef(Params.Values['y'], 0);
    pmGridSources.Popup(ScreenX, ScreenY);
  end;
end;


procedure TSourcesForm.UniFormCreate(Sender: TObject);
begin
  FSourcesBroker:= CreateSourcesBroker();
  ClearSourceInfo;
end;

procedure TSourcesForm.UniFormDestroy(Sender: TObject);
begin
  FreeAndNil(SourceList);
  FreeAndNil(FSourcesBroker)
end;

procedure TSourcesForm.unmpSource1MapReady(Sender: TObject);
begin
  var fs := TFormatSettings.Create; fs.DecimalSeparator := '.';
  var mapName := unmpSource1.JSName + '.uniMap';

    // invalidateSize
  UniSession.AddJS(Format(
    'if(%s) {%s.invalidateSize();}', [mapName, mapName]
  ));

  for var srcP in SourceList do
  begin
    var Source := TSource(srcP);
    if Source.Lat.HasValue and Source.Lon.HasValue then
      UniSession.AddJS(Format(
        'L.marker([%.6f,%.6f]).addTo(%s).bindPopup("%s");',
        [Source.Lat.Value, Source.Lon.Value, mapName, StringReplace(Source.Name.ValueOrDefault(''), '"', '\"', [rfReplaceAll])],
        fs
      ));
  end;

  if SourceList.Count = 0 then Exit;

  for var srcP in SourceList do
  begin
    var Source := TSource(srcP);
    if Source.Lat.HasValue and Source.Lon.HasValue then
    begin
      unmpSource1.SetView(Source.Lat.Value, Source.Lon.Value, 8);
      Break;
    end;
  end;

end;


procedure TSourcesForm.unmpSource1MarkerClick(Sender: TObject; const Lat,
  Lng: Double; const Zoom, X, Y, Id: Integer);
begin
//
end;

procedure TSourcesForm.unspdbtnCreate1Click(Sender: TObject);
begin
  FsourceEditForm:=SourceEditForm(false, TSource.Create);
end;

procedure TSourcesForm.unspdbtnEditClick(Sender: TObject);
begin
  FsourceEditForm:=SourceEditForm(true, FSelectedSource);
end;

procedure TSourcesForm.unspdbtnRefreshClick(Sender: TObject);
begin
 LoadSources;
end;

procedure TSourcesForm.miCreateSourceClick(Sender: TObject);
begin
  unspdbtnCreate1Click(Sender);
end;

procedure TSourcesForm.miEditSourceClick(Sender: TObject);
begin
  unspdbtnEditClick(Sender);
end;

procedure TSourcesForm.miArchiveSourceClick(Sender: TObject);
begin
  ArchiveSelectedSource;
end;

procedure TSourcesForm.pmGridSourcesPopup(Sender: TObject);
var
  HasSelection: Boolean;
begin
  HasSelection := Assigned(FSelectedSource);
  miEditSource.Enabled := HasSelection;
  miArchiveSource.Enabled := HasSelection;
end;

procedure TSourcesForm.ArchiveSelectedSource;
var
  ConfirmText: string;

begin
  if not Assigned(FSelectedSource) then
    Exit;
  if not Assigned(FSourcesBroker) then
    Exit;

  ConfirmText := Format('Archive source %s (%s)?', [
    FSelectedSource.Name.ValueOrDefault(''),
    FSelectedSource.Sid
  ]);

  MessageDlg(ConfirmText, mtConfirmation, [mbYes, mbNo],
    procedure(Sender: TComponent; Res: Integer)
    var
    Req: TSourceReqArchive;
    Resp: TJSONResponse;
    begin
      if Res <> mrYes then exit;
      Req := nil;
      Resp := nil;
      try
        try
          Req := FSourcesBroker.CreateReqArchive as TSourceReqArchive;
          if not Assigned(Req) then
            Exit;
          Req.SetSourceId(FSelectedSource.Sid);
          Resp := FSourcesBroker.Archive(Req);
          if Assigned(Resp) and (Resp.StatusCode in [200, 204]) then
          begin
            MessageDlg('Source archived successfully.', mtInformation, [mbOK], nil);
            LoadSources;
          end
          else
            MessageDlg(Format('Unable to archive the source. HTTP %d'#13#10'%s',
              [Resp.StatusCode, Resp.Response]), mtWarning, [mbOK], nil);
        except
          on E: EIdHTTPProtocolException do
            MessageDlg(Format('Unable to archive the source. HTTP %d'#13#10'%s',
              [E.ErrorCode, E.ErrorMessage]), mtWarning, [mbOK], nil);
          on E: Exception do
            MessageDlg('Unable to archive the source: ' + E.Message, mtWarning, [mbOK], nil);
        end
      finally
        Resp.Free;
        Req.Free;
      end;
    end);
end;
procedure TSourcesForm.ApplySourceFilter;
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

procedure TSourcesForm.FilterDebounceTimerTimer(Sender: TObject);
begin
  if Assigned(FilterDebounceTimer) then
    FilterDebounceTimer.Enabled := False;
  ApplySourceFilter;
  UpdateSelectedSourceInfo;
end;

procedure TSourcesForm.gridSourcesSelectionChange(Sender: TObject);
begin
  UpdateSelectedSourceInfo;
end;

end.



