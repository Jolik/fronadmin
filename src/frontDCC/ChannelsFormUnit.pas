unit ChannelsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniPanel, uniButton, uniLabel, 
  uniDBGrid, uniGUIBaseClasses, Data.DB, Datasnap.DBClient,
  uniEdit, uniComboBox, uniMemo, uniBasicGrid, System.JSON, uniTimer, uniCheckBox,
  MainModule, ChannelEditFormUnit, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  LoggingUnit;

type
  TChannelsForm = class(TUniForm)
    // Top toolbar panel
    ToolbarPanel: TUniPanel;
    SearchEdit: TUniEdit;
    SearchButton: TUniButton;
    AddButton: TUniButton;
    EditButton: TUniButton;
    DeleteButton: TUniButton;
    RefreshButton: TUniButton;

    // Main content container
    MainPanel: TUniPanel;

    // Left panel for channels list
    ChannelsPanel: TUniPanel;
    ChannelsLabel: TUniLabel;
    ChannelsGrid: TUniDBGrid;

    // Right panel for information
    InfoPanel: TUniPanel;
    InfoLabel: TUniLabel;
    InfoMemo: TUniMemo;
    ChannelsDataSource: TDataSource;
    RefreshTimer: TUniTimer;
    AutoUpdateChannelsList: TUniCheckBox;
    ChannelsDataSet: TFDMemTable;

    procedure UniFormCreate(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure RefreshButtonClick(Sender: TObject);
    procedure SearchButtonClick(Sender: TObject);
    procedure ChannelsGridCellClick(Column: TUniDBGridColumn);
    procedure UniFormDestroy(Sender: TObject);
    procedure RefreshTimerTimer(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure EditButtonClick(Sender: TObject);

  private
    procedure SetupLayout;
    procedure SetupChannelsData;
    procedure SetupGrid;
    procedure ShowChannelInfo(const ChannelID: string);

    procedure LoadChannelsFromAPI;
    function ParseJSONResponse(const JSONString: string): Boolean;
    procedure UpdateChannelsDataSet(JSONArray: TJSONArray);
    function GetQueueState(Counters: TJSONObject): string;

    function GetChannelDetails(const ChannelID: string): TJSONObject;

    function DeleteChannel(const ChannelID: string): Boolean;
    function CreateChannel(const JSONData: string): Boolean;
    function UpdateChannel(const ChannelID, JSONData: string): Boolean;

  public
    { Public declarations }
  end;

    function ChannelsForm: TChannelsForm;

implementation

{$R *.dfm}

function IfThen(exp: Boolean; v1, v2: Variant): Variant;
begin
 if exp then
   Result := v1
  else
   Result := v2;
end;

procedure TChannelsForm.UniFormCreate(Sender: TObject);
begin
  SetupLayout;
  SetupChannelsData;
  SetupGrid;
//  InitializeHTTPClient;

  // Load data immediately when form is ready
  LoadChannelsFromAPI;

  // Start timer for auto-refresh every 3 seconds
  RefreshTimer.Interval := 3000;
  RefreshTimer.Enabled := True;

  Log(llInfo, 'Programm started!');
end;

procedure TChannelsForm.UniFormDestroy(Sender: TObject);
begin
  // Cleanup
(*  if Assigned(FIdSSLIOHandler) then
    FreeAndNil(FIdSSLIOHandler);
  if Assigned(FIdHTTP) then
    FreeAndNil(FIdHTTP); *)
end;

function TChannelsForm.UpdateChannel(const ChannelID,
  JSONData: string): Boolean;
var
  Response: string;
  JSONValue, Meta: TJSONValue;
  Code: Integer;
begin
  Result := False;
  try
//    FIdHTTP.Request.ContentType := 'application/json';
    Response := POST(API_BASE_ROUTER_URL + API_CHANNELS_URL + '/' + ChannelID + '/update', JSONData);

    JSONValue := TJSONObject.ParseJSONValue(Response);
    if not Assigned(JSONValue) then Exit;

    try
      Meta := (JSONValue as TJSONObject).GetValue('meta');
      if Assigned(Meta) then
      begin
        Code := (Meta as TJSONObject).GetValue<Integer>('code');
        Result := (Code = 0);
      end;
    finally
      JSONValue.Free;
    end;
  except
    on E: Exception do
      ShowMessage('Ошибка обновления канала: ' + E.Message);
  end;
end;

procedure TChannelsForm.UpdateChannelsDataSet(JSONArray: TJSONArray);
var
  I: Integer;
  ChannelObj, ServiceObj, QueueObj, LinkObj, CountersObj: TJSONObject;
  ChannelName, ServiceName, ChannelType, QueueState, Status, Direction: string;
begin
  ChannelsDataSet.DisableControls;
  try
    ChannelsDataSet.Close;
    ChannelsDataSet.Open;

    ChannelsDataSet.EmptyDataSet;

    for I := 0 to JSONArray.Count - 1 do
    begin
      ChannelObj := JSONArray.Items[I] as TJSONObject;

      // Extract basic channel information
      ChannelName := ChannelObj.GetValue<string>('name', '');
      ServiceObj := ChannelObj.GetValue<TJSONObject>('service');
      if Assigned(ServiceObj) then
        ServiceName := ServiceObj.GetValue<string>('svcid', '')
      else
        ServiceName := '';

      // Extract link information
      LinkObj := ChannelObj.GetValue<TJSONObject>('link');
      if Assigned(LinkObj) then
      begin
        ChannelType := LinkObj.GetValue<string>('type', '');
        Status := LinkObj.GetValue<string>('status', '');
        Direction := LinkObj.GetValue<string>('dir', '');
      end
      else
      begin
        ChannelType := '';
        Status := '';
        Direction := '';
      end;

      // Extract queue information
      QueueObj := ChannelObj.GetValue<TJSONObject>('queue');
      if Assigned(QueueObj) then
      begin
        CountersObj := QueueObj.GetValue<TJSONObject>('counters');
        if Assigned(CountersObj) then
          QueueState := GetQueueState(CountersObj)
        else
          QueueState := 'ВЫКЛ';
      end
      else
        QueueState := 'ВЫКЛ';

      // Add record to dataset
      ChannelsDataSet.Append;
      ChannelsDataSet.FieldByName('Channel').AsString := ChannelName;
      ChannelsDataSet.FieldByName('Name').AsString := ChannelObj.GetValue<string>('caption', '');
      ChannelsDataSet.FieldByName('Service').AsString := ServiceName;
      ChannelsDataSet.FieldByName('Type').AsString := ChannelType;
      ChannelsDataSet.FieldByName('Queue').AsString := QueueState;
      ChannelsDataSet.FieldByName('Status').AsString := Status;
      ChannelsDataSet.FieldByName('Direction').AsString := Direction;
      ChannelsDataSet.FieldByName('ChID').AsString := ChannelObj.GetValue<string>('chid', '');
      ChannelsDataSet.Post;
    end;

  finally
    ChannelsDataSet.EnableControls;
  end;
end;

procedure TChannelsForm.SetupLayout;
begin
  // Убрать установку WindowState и Layout
  //Self.Align := alClient;
  Self.Color := clWindow;

  // Toolbar panel setup - использовать Align вместо фиксированных координат
  ToolbarPanel.Align := alTop;
  ToolbarPanel.Height := 40;
  ToolbarPanel.Color := $F0F0F0;
  ToolbarPanel.BorderStyle := ubsNone;

  // Position toolbar buttons относительно панели
  SearchEdit.Left := 10;
  SearchEdit.Top := 8;
  SearchEdit.Width := 200;
  SearchEdit.EmptyText := 'Поиск каналов...';

  SearchButton.Left := 220;
  SearchButton.Top := 8;
  SearchButton.Width := 70;
  SearchButton.Caption := 'Найти';

  AddButton.Left := 300;
  AddButton.Top := 8;
  AddButton.Width := 70;
  AddButton.Caption := 'Добавить';

  EditButton.Left := 380;
  EditButton.Top := 8;
  EditButton.Width := 70;
  EditButton.Caption := 'Изменить';

  DeleteButton.Left := 460;
  DeleteButton.Top := 8;
  DeleteButton.Width := 70;
  DeleteButton.Caption := 'Удалить';

  RefreshButton.Left := 540;
  RefreshButton.Top := 8;
  RefreshButton.Width := 70;
  RefreshButton.Caption := 'Обновить';

  // Main panel setup - занять всё доступное пространство
  MainPanel.Align := alClient;
  MainPanel.BorderStyle := ubsNone;
end;

procedure TChannelsForm.SetupChannelsData;
begin
  // Define dataset structure
  with ChannelsDataSet do
  begin
    Close;
    FieldDefs.Clear;
    FieldDefs.Add('Channel', ftString, 100);
    FieldDefs.Add('Name', ftString, 100);
    FieldDefs.Add('Service', ftString, 50);
    FieldDefs.Add('Type', ftString, 50);
    FieldDefs.Add('Queue', ftString, 20);
    FieldDefs.Add('Status', ftString, 50);
    FieldDefs.Add('Direction', ftString, 20);
    FieldDefs.Add('ChID', ftString, 50);
    CreateDataSet;
    Open;
  end;

  ChannelsDataSource.DataSet := ChannelsDataSet;
end;

procedure TChannelsForm.SetupGrid;
begin
  ChannelsGrid.DataSource := ChannelsDataSource;

  // Configure grid columns
  with ChannelsGrid.Columns do
  begin
    Clear;

    with Add do
    begin
      FieldName := 'Channel';
      Title.Caption := 'Канал';
      Width := 120;
    end;

    with Add do
    begin
      FieldName := 'Name';
      Title.Caption := 'Имя';
      Width := 120;
    end;

    with Add do
    begin
      FieldName := 'Service';
      Title.Caption := 'Сервис';
      Width := 80;
    end;

    with Add do
    begin
      FieldName := 'Type';
      Title.Caption := 'Тип';
      Width := 60;
    end;

    with Add do
    begin
      FieldName := 'Queue';
      Title.Caption := 'Очередь';
      Width := 60;
    end;

    with Add do
    begin
      FieldName := 'Status';
      Title.Caption := 'Статус';
      Width := 60;
    end;

    with Add do
    begin
      FieldName := 'Direction';
      Title.Caption := 'Направление';
      Width := 80;
    end;
  end;

  ChannelsGrid.Options := ChannelsGrid.Options + [dgRowSelect];
  ChannelsGrid.ReadOnly := True;
end;

procedure TChannelsForm.ShowChannelInfo(const ChannelID: string);
var
  ChannelDetails: TJSONObject;
  QueueObj, LinkObj, CountersObj: TJSONObject;
  InfoText: string;
begin
  ChannelDetails := GetChannelDetails(ChannelID);
  if not Assigned(ChannelDetails) then
  begin
    InfoMemo.Text := 'Не удалось загрузить информацию о канале';
    Exit;
  end;

  try
    InfoText := '=== ОСНОВНАЯ ИНФОРМАЦИЯ ===' + #13#10;
    InfoText := InfoText + 'ID: ' + ChannelDetails.GetValue<string>('chid', '') + #13#10;
    InfoText := InfoText + 'Название: ' + ChannelDetails.GetValue<string>('caption', '') + #13#10;
    InfoText := InfoText + 'Имя: ' + ChannelDetails.GetValue<string>('name', '') + #13#10;

    // Информация об очереди
    QueueObj := ChannelDetails.GetValue<TJSONObject>('queue');
    if Assigned(QueueObj) then
    begin
      InfoText := InfoText + #13#10 + '=== ОЧЕРЕДЬ ===' + #13#10;
      InfoText := InfoText + 'ID: ' + QueueObj.GetValue<string>('qid', '') + #13#10;
      InfoText := InfoText + 'Разрешить накопление: ' + IfThen(QueueObj.GetValue<Boolean>('allow_put', False), 'Да', 'Нет') + #13#10;
      InfoText := InfoText + 'Разрешить дубли: ' + IfThen(QueueObj.GetValue<Boolean>('doubles', False), 'Да', 'Нет') + #13#10;

      CountersObj := QueueObj.GetValue<TJSONObject>('counters');
      if Assigned(CountersObj) then
      begin
        InfoText := InfoText + 'Всего сообщений: ' + CountersObj.GetValue<Integer>('total', 0).ToString + #13#10;
        InfoText := InfoText + 'Приоритет 1: ' + CountersObj.GetValue<Integer>('prio1', 0).ToString + #13#10;
        InfoText := InfoText + 'Приоритет 2: ' + CountersObj.GetValue<Integer>('prio2', 0).ToString + #13#10;
        InfoText := InfoText + 'Приоритет 3: ' + CountersObj.GetValue<Integer>('prio3', 0).ToString + #13#10;
        InfoText := InfoText + 'Приоритет 4: ' + CountersObj.GetValue<Integer>('prio4', 0).ToString + #13#10;
        InfoText := InfoText + 'Заблокировано: ' + CountersObj.GetValue<Integer>('held', 0).ToString + #13#10;
      end;
    end;

    // Информация о линке
    LinkObj := ChannelDetails.GetValue<TJSONObject>('link');
    if Assigned(LinkObj) then
    begin
      InfoText := InfoText + #13#10 + '=== ЛИНК ===' + #13#10;
      InfoText := InfoText + 'ID: ' + LinkObj.GetValue<string>('lid', '') + #13#10;
      InfoText := InfoText + 'Тип: ' + LinkObj.GetValue<string>('type', '') + #13#10;
      InfoText := InfoText + 'Направление: ' + LinkObj.GetValue<string>('dir', '') + #13#10;
      InfoText := InfoText + 'Статус: ' + LinkObj.GetValue<string>('status', '') + #13#10;
      InfoText := InfoText + 'Состояние соединения: ' + LinkObj.GetValue<string>('comsts', '') + #13#10;
      InfoText := InfoText + 'Отправлено: ' + LinkObj.GetValue<Integer>('sent', 0).ToString + #13#10;
      InfoText := InfoText + 'Получено: ' + LinkObj.GetValue<Integer>('recv', 0).ToString + #13#10;
    end;

    InfoMemo.Text := InfoText;
  finally
    ChannelDetails.Free;
  end;
end;

procedure TChannelsForm.AddButtonClick(Sender: TObject);
begin
  if ChannelEditFormUnit.CreateChannel then
    LoadChannelsFromAPI; // Refresh after creation
end;

procedure TChannelsForm.ChannelsGridCellClick(Column: TUniDBGridColumn);
begin
  if not ChannelsDataSet.IsEmpty then
  begin
    ShowChannelInfo(ChannelsDataSet.FieldByName('ChID').AsString);
  end;
end;

function TChannelsForm.CreateChannel(const JSONData: string): Boolean;
var
  Response: string;
  JSONValue, Meta: TJSONValue;
  Code: Integer;
begin
  Result := False;
  try
    Response := POST(API_BASE_ROUTER_URL + API_CHANNELS_URL + '/new', JSONData);

    JSONValue := TJSONObject.ParseJSONValue(Response);
    if not Assigned(JSONValue) then Exit;

    try
      Meta := (JSONValue as TJSONObject).GetValue('meta');
      if Assigned(Meta) then
      begin
        Code := (Meta as TJSONObject).GetValue<Integer>('code');
        Result := (Code = 0);
      end;
    finally
      JSONValue.Free;
    end;
  except
    on E: Exception do
      ShowMessage('Ошибка создания канала: ' + E.Message);
  end;
end;

procedure TChannelsForm.DeleteButtonClick(Sender: TObject);
begin
  if not ChannelsDataSet.IsEmpty then
  begin
    if DeleteChannel(ChannelsDataSet.FieldByName('ChID').AsString) then
      begin
        ShowMessage('Канал успешно удален');
        LoadChannelsFromAPI; // Обновляем список
      end;
  end
  else
    ShowMessage('Выберите канал для удаления');
end;

function TChannelsForm.DeleteChannel(const ChannelID: string): Boolean;
var
  Response: string;
  JSONValue, Meta: TJSONValue;
  Code: Integer;
//  Stream: TStringStream;
  Stream: string;

begin
  Result := False;
  try

//    if not Assigned(FIdHTTP) then
//      InitializeHTTPClient;

  //  Stream := TStringStream.Create('');

    try
     Response := POST(API_BASE_ROUTER_URL + API_CHANNELS_URL + '/' + ChannelID + '/remove', Stream);
    finally
//     Stream.Free;
    end;

    JSONValue := TJSONObject.ParseJSONValue(Response);
    if not Assigned(JSONValue) then Exit;

    try
      Meta := (JSONValue as TJSONObject).GetValue('meta');
      if Assigned(Meta) then
      begin
        Code := (Meta as TJSONObject).GetValue<Integer>('code');
        Result := (Code = 0);
      end;
    finally
      JSONValue.Free;
    end;
  except
    on E: Exception do
      ShowMessage('Ошибка удаления канала: ' + E.Message);
  end;
end;

procedure TChannelsForm.EditButtonClick(Sender: TObject);
begin
  if not ChannelsDataSet.IsEmpty then
  begin
    var ChannelDetails := GetChannelDetails(ChannelsDataSet.FieldByName('ChID').AsString);
    try
      if ChannelEditFormUnit.EditChannel(ChannelsDataSet.FieldByName('ChID').AsString, ChannelDetails) then
        LoadChannelsFromAPI; // Refresh after edit
    finally
      if Assigned(ChannelDetails) then
        ChannelDetails.Free;
    end;
  end
  else
    ShowMessage('Выберите канал для редактирования');
end;

function TChannelsForm.GetChannelDetails(const ChannelID: string): TJSONObject;
var
  Response: string;
  JSONValue, Meta, ResponseObj, ChannelObj: TJSONValue;
  Code: Integer;
begin
  Result := nil;
  try

    Response := GET(API_BASE_ROUTER_URL + API_CHANNELS_URL + '/' + ChannelID);

    JSONValue := TJSONObject.ParseJSONValue(Response);
    if not Assigned(JSONValue) then Exit;

    try
      Meta := (JSONValue as TJSONObject).GetValue('meta');
      if Assigned(Meta) then
      begin
        Code := (Meta as TJSONObject).GetValue<Integer>('code');
        if Code <> 0 then Exit;
      end;

      ResponseObj := (JSONValue as TJSONObject).GetValue('response');
      if Assigned(ResponseObj) then
      begin
        ChannelObj := (ResponseObj as TJSONObject).GetValue('channel');
        if Assigned(ChannelObj) then
          Result := ChannelObj.Clone as TJSONObject;
      end;
    finally
      JSONValue.Free;
    end;
  except
    on E: Exception do
      ShowMessage('Ошибка получения деталей канала: ' + E.Message);
  end;
end;

function TChannelsForm.GetQueueState(Counters: TJSONObject): string;
var
  Total: Integer;
begin
  Total := Counters.GetValue<Integer>('total', 0);
  if Total > 0 then
    Result := 'ВКЛ'
  else
    Result := 'ВЫКЛ';
end;


procedure TChannelsForm.LoadChannelsFromAPI;
var
  Response: string;
begin
  try
    // Make GET request to API
    Response := GET(API_BASE_ROUTER_URL + API_CHANNELS_URL + '/list');

    // Parse JSON response
    if not ParseJSONResponse(Response) then
      ShowMessage('Ошибка при разборе данных от сервера');

  except
    on E: Exception do
    begin
      ShowMessage('Ошибка при загрузке данных: ' + E.Message);
      // You might want to log this error in production
    end;
  end;
end;

function TChannelsForm.ParseJSONResponse(const JSONString: string): Boolean;
var
  JSONValue, Meta, Response, Info, ChannelsArray: TJSONValue;
  Code: Integer;
begin
  Result := False;
  try
    JSONValue := TJSONObject.ParseJSONValue(JSONString);
    if not Assigned(JSONValue) then Exit;

    try
      // Check meta code
      Meta := (JSONValue as TJSONObject).GetValue('meta');
      if Assigned(Meta) then
      begin
        Code := (Meta as TJSONObject).GetValue<Integer>('code');
        if Code <> 0 then
        begin
          ShowMessage('Ошибка API: код ' + IntToStr(Code));
          Exit;
        end;
      end;

      // Get channels array
      Response := (JSONValue as TJSONObject).GetValue('response');
      if Assigned(Response) then
      begin
        ChannelsArray := (Response as TJSONObject).GetValue('channels');
        if Assigned(ChannelsArray) and (ChannelsArray is TJSONArray) then
        begin
          UpdateChannelsDataSet(ChannelsArray as TJSONArray);
          Result := True;
        end;
      end;

    finally
      JSONValue.Free;
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Ошибка парсинга JSON: ' + E.Message);
    end;
  end;
end;

procedure TChannelsForm.RefreshButtonClick(Sender: TObject);
begin
  LoadChannelsFromAPI;
  ShowMessage('Данные обновлены');
end;

procedure TChannelsForm.RefreshTimerTimer(Sender: TObject);
begin
  if AutoUpdateChannelsList.Checked then
    // Auto-refresh data every 3 seconds
    LoadChannelsFromAPI;
end;

procedure TChannelsForm.SearchButtonClick(Sender: TObject);
var
  SearchText: string;
begin
  SearchText := Trim(SearchEdit.Text);
  if SearchText <> '' then
  begin
    if ChannelsDataSet.Locate('Channel', SearchText, [loPartialKey, loCaseInsensitive]) or
       ChannelsDataSet.Locate('Name', SearchText, [loPartialKey, loCaseInsensitive]) then
    begin
      ShowChannelInfo(ChannelsDataSet.FieldByName('Channel').AsString);
    end
    else
    begin
      ShowMessage('Канал не найден: ' + SearchText);
    end;
  end;
end;

function ChannelsForm: TChannelsForm;
begin
  Result := TChannelsForm(UniMainModule.GetFormInstance(TChannelsForm));
end;

end.
