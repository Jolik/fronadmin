unit ParentFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm,
  EntityUnit,
  ParentEditFormUnit,
  RestEntityBrokerUnit, BaseRequests, BaseResponses;

type
  ///  базовая форма с редактором и брокером
  TParentForm = class(TUniForm)
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
  private
    ///  REST‑брокер для доступа к API
    FRestBroker: TRestEntityBroker;
    ///  форма для редактирования сущности — потомок должен создать функциональный класс
    FEditForm: TParentEditForm;

  protected
    procedure OnCreate; virtual;
    function NewCallback(const AID: string; AEntity: TFieldSet):boolean;
    function UpdateCallback(const AID: string; AEntity: TFieldSet):boolean;

    ///  вернуть текущий идентификатор редактируемой сущности
    function GetCurrentEntityId: string; virtual;

    ///  функция для обновления компонент на форме
    procedure Refresh(const AId: String = ''); virtual; abstract;

    // фабрика REST брокера (запросы создаёт брокер)
    function CreateRestBroker(): TRestEntityBroker; virtual;

    ///  функция для создания нужной формы редактирования
    function CreateEditForm(): TParentEditForm; virtual; abstract;

  public
    ///  доступ к REST‑брокеру и форме редактирования
    property RestBroker: TRestEntityBroker read FRestBroker;
    property EditForm: TParentEditForm read FEditForm;

    ///  создать форму редактирования и задать режим
    procedure PrepareEditForm(isEditMode: boolean = false);
  end;

function ParentForm: TParentForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, HttpClientUnit, IdHTTP;

{ TParentForm }

function TParentForm.NewCallback(const AID: string;AEntity: TFieldSet):boolean;
var
  ReqNew: TReqNew;
  JsonRes: TJSONResponse;
begin
  Result := False;
  // если модальное окно закрылось через ОК
  if Assigned(FRestBroker) then
  begin
    ReqNew := FRestBroker.CreateReqNew();
    if not Assigned(AEntity) then
      Exit;

    ReqNew.ApplyBody(AEntity);
    JsonRes := nil;
    try
      try
        JsonRes := FRestBroker.New(ReqNew);

        if not JsonRes.StatusCode in [201,200] then
        begin
          MessageDlg(Format('Создание не удалось. HTTP %d'#13#10'%s',
            [JsonRes.StatusCode, JsonRes.Response]), TMsgDlgType.mtWarning, [mbOK], nil);
          Exit;
        end
        else
        Result := True;
      except
        on E: EIdHTTPProtocolException do
          MessageDlg(Format('Создание не удалось. HTTP %d'#13#10'%s',
            [E.ErrorCode, E.ErrorMessage]), TMsgDlgType.mtWarning, [mbOK], nil);
        on E: Exception do
          MessageDlg(Format('Создание не удалось. %s',
            [e.Message]), TMsgDlgType.mtWarning, [mbOK], nil);
      end;
    finally
      JsonRes.Free;
    end;
  end;
  if Result then
    Refresh();
end;

procedure TParentForm.OnCreate;
begin
  //
end;

function TParentForm.UpdateCallback(const AID: string; AEntity: TFieldSet):boolean;
var
  ReqUpd: TReqUpdate;
  JsonRes: TJSONResponse;
  LEditedId: string;
begin
  Result := False;

  FEditForm.ScreenMask.Enabled := True;
  FEditForm.ScreenMask.Message := 'Обновление...';
  UniSession.Synchronize;
  try
  // считываем из окна отредактированные данные и пытаемся обновить на сервере
  // если всё ок, то в ответ вернётся обновлённая сущность
  if Assigned(FRestBroker) then
  begin

    ReqUpd := FRestBroker.CreateReqUpdate();
    if Assigned(ReqUpd) then
    begin
      try
        LEditedId := AID;
        if not LEditedId.Trim.IsEmpty then
          ReqUpd.Id := LEditedId;

        if Assigned(ReqUpd.ReqBody) and Assigned(AEntity) then
          TFieldSet(ReqUpd.ReqBody).Assign(TFieldSet(EditForm.Entity));

        JsonRes := FRestBroker.Update(ReqUpd);
        try
          if Assigned(JsonRes) and (JsonRes.StatusCode = 200) then
            Result := True
          else
          begin
            if Assigned(JsonRes) then
              MessageDlg(Format('Обновление не удалось. HTTP %d'#13#10'%s',
                [JsonRes.StatusCode, JsonRes.Response]), TMsgDlgType.mtWarning, [mbOK], nil)
            else
              MessageDlg('Обновление не удалось: пустой ответ', TMsgDlgType.mtWarning, [mbOK], nil);
          end;
        finally
          JsonRes.Free;
        end;
      except
        on E: Exception do
          Result := False;
      end;
    end
    else
      Result := False;
  end;

  // если обновить на сервере не удалось, то сообщаем об этом
  if not Result then
    Exit
  else
  begin
    // если сущность на сервере обновилась — обновляем таблицу
    Refresh();
  end;
  finally
    FEditForm.ScreenMask.Enabled := false;
    FEditForm.ScreenMask.Message := '';
  end;

end;

function TParentForm.GetCurrentEntityId: string;
begin
  Result := '';
  if Assigned(EditForm) then
  begin
    // предпочитаем явный Id, сохранённый в форме
    if (EditForm is TParentEditForm) and not TParentEditForm(EditForm).Id.Trim.IsEmpty then
      Exit(TParentEditForm(EditForm).Id);
    // запасной вариант — Id из сущности, если это TEntity
    if Assigned(EditForm.Entity) and (EditForm.Entity is TEntity) then
      Exit(TEntity(EditForm.Entity).Id);
  end;
end;

procedure TParentForm.UniFormCreate(Sender: TObject);
begin
  // создаем брокера
  FRestBroker := CreateRestBroker();
  OnCreate;
  // форму редактирования создаём по месту использования
  // FEditForm := CreateEditForm();
end;

procedure TParentForm.UniFormDestroy(Sender: TObject);
begin
  FreeAndNil(FRestBroker);
  // нужно удалять или нет? FreeAndNil(EditForm);
end;

procedure TParentForm.PrepareEditForm(isEditMode: boolean);
begin
  FEditForm := CreateEditForm();
  FEditForm.IsEdit := isEditMode;
end;


function ParentForm: TParentForm;
begin
  Result := TParentForm(UniMainModule.GetFormInstance(TParentForm));
end;

{ Default implementations for REST factories }

function TParentForm.CreateRestBroker: TRestEntityBroker;
begin
  Result := nil;
end;

end.

