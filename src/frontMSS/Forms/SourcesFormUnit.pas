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
  SourceEditFormUnit;

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
  public
    property SelectedSource:TSource read FSelectedSource write FSelectedSource;
  end;

function ShowSourcesForm: TSourcesForm;

implementation
{$R *.dfm}

uses
  MainModule, uniGUIApplication, LoggingUnit, EntityUnit, SourceHttpRequests, IdHTTP, System.DateUtils;

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
      var Req := FSourcesBroker.CreateReqList();
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
            SourcesMem.FieldByName('name').AsString := src.Name;
            SourcesMem.FieldByName('sid').AsString := src.Sid;
//            if (src.Lat <> 0) and (src.Lon <> 0) then
//            with unmpSource1.Markers.Add do begin
//              Latitude:= src.Lat;
//              Longitude:= src.Lon;
//              Title:= Format('%s(%s)', [src.Name,src.Sid]);
//            end;

            if src.LastInsert <> 0 then
              SourcesMem.FieldByName('last_insert').AsDateTime := UnixToDateTime(src.LastInsert, true)
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
      FloatToStr(ASource.Lat, fs),
      FloatToStr(ASource.Lon, fs),
      StringReplace(ASource.Name, '"', '\"', [rfReplaceAll])
    ]
  ));



  lSourceInfoIDValue.Caption := ASource.Sid;
  unlblSourceInfoNameValue.Caption := ASource.Name;
  lSourceInfoModuleValue.Caption := ASource.Index;
  unlblregion.Caption := ASource.Region;
  unlbllat.Caption := FloatToStr(ASource.Lat);
  unlbllon.Caption := FloatToStr(ASource.Lon);


  if ASource.Created > 0 then
  begin
    DateTimeToString(DateText, DateFormat, ASource.Created);
    lSourceInfoCreatedValue.Caption := DateText;
  end
  else
    lSourceInfoCreatedValue.Caption := '';

  if ASource.Updated > 0 then
  begin
    DateTimeToString(DateText, DateFormat, ASource.Updated);
    unlblUpdatedVal.Caption := DateText;
  end
  else
    unlblUpdatedVal.Caption := '';

  tsSourceInfo.TabVisible := True;
  FCurrentSourceSid := ASource.Sid;

end;

procedure TSourcesForm.UniFormAjaxEvent(Sender: TComponent; EventName: string;
  Params: TUniStrings);
begin
  if EventName = 'marker_click' then
  begin
    ShowMessage('Клик по маркеру: ' + Params.Values['id']);
    // Тут можно сделать всё, что угодно
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
var
  src: TSource;
begin
  var fs := TFormatSettings.Create; fs.DecimalSeparator := '.'; // используем точку для JS
  var mapName := unmpSource1.JSName + '.uniMap';

    // invalidateSize
  UniSession.AddJS(Format(
    'if(%s) {%s.invalidateSize();}', [mapName, mapName]
  ));

  // маркеры добавляем напрямую в JS
  for var srcP in SourceList do
  with srcP as TSource do
    if (Lat <> 0) and (Lon <> 0) then
      UniSession.AddJS(Format(
        'L.marker([%.6f,%.6f]).addTo(%s).bindPopup("%s");',
        [Lat, Lon, mapName, StringReplace(Name, '"', '\"', [rfReplaceAll])],
        fs
      ));

  // центрируем карту
  if SourceList.Count = 0 then Exit;

  with SourceList[0] as TSource do
    unmpSource1.SetView(Lat, Lon, 8)

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
