unit ParentFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm,
  EntityUnit,
  ParentEditFormUnit,
  RestBrokerBaseUnit, BaseRequests, BaseResponses;

type
  ///  базовая форма с редактором и брокером
  TParentForm = class(TUniForm)
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
  private
    ///  REST‑брокер для доступа к API
    FRestBroker: TRestBrokerBase;
    ///  форма для редактирования сущности — потомок должен создать функциональный класс
    FEditForm: TParentEditForm;

  protected
    procedure NewCallback(ASender: TComponent; AResult: Integer);
    procedure UpdateCallback(ASender: TComponent; AResult: Integer);

    ///  вернуть текущий идентификатор редактируемой сущности
    function GetCurrentEntityId: string; virtual;

    ///  функция для обновления компонент на форме
    procedure Refresh(const AId: String = ''); virtual; abstract;

    // фабрика REST‑брокера (запросы создаёт брокер)
    function CreateRestBroker(): TRestBrokerBase; virtual;

    ///  функция для создания нужной формы редактирования
    function CreateEditForm(): TParentEditForm; virtual; abstract;

  public
    ///  доступ к REST‑брокеру и форме редактирования
    property RestBroker: TRestBrokerBase read FRestBroker;
    property EditForm: TParentEditForm read FEditForm;

    ///  создать форму редактирования и задать режим
    procedure PrepareEditForm(isEditMode: boolean = false);
  end;

function ParentForm: TParentForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, HttpClientUnit;

{ TParentForm }

procedure TParentForm.NewCallback(ASender: TComponent; AResult: Integer);
var
  res: boolean;
  ReqNew: TReqNew;
  JsonRes: TJSONResponse;
begin
  // если модальное окно закрылось через ОК
  if AResult <> mrOk then
    Exit;

  if Assigned(FRestBroker) then
  begin
    res := False;
    ReqNew := FRestBroker.CreateReqNew();
    if not Assigned(EditForm) or not Assigned(EditForm.Entity) then
      Exit;

    ReqNew.ApplyBody(EditForm.Entity);
    JsonRes := nil;
    try
      JsonRes := FRestBroker.New(ReqNew);
      if not Assigned(JsonRes) then
        Exit;

      if JsonRes.StatusCode <> 201 then
      begin
        MessageDlg(Format('Создание не удалось. HTTP %d'#13#10'%s',
          [JsonRes.StatusCode, JsonRes.Response]), TMsgDlgType.mtWarning, [mbOK], nil);
        res := False;
        Exit;
      end
      else
        res := True;
    finally
      JsonRes.Free;
    end;
  end;
end;

procedure TParentForm.UpdateCallback(ASender: TComponent; AResult: Integer);
var
  res: boolean;
  ReqUpd: TReqUpdate;
  JsonRes: TJSONResponse;
  LEditedId: string;
begin
  // если модальное окно закрылось через ОК
  if AResult = mrOk then
  begin
    // считываем из окна отредактированные данные и пытаемся обновить на сервере
    // если всё ок, то в ответ вернётся обновлённая сущность
    if Assigned(FRestBroker) then
    begin
      res := False;
      ReqUpd := FRestBroker.CreateReqUpdate();
      if Assigned(ReqUpd) then
      begin
        try
          LEditedId := GetCurrentEntityId();
          if not LEditedId.Trim.IsEmpty then
            ReqUpd.Id := LEditedId;

          if Assigned(ReqUpd.ReqBody) and Assigned(EditForm) and Assigned(EditForm.Entity) and (EditForm.Entity is TFieldSet) then
            TFieldSet(ReqUpd.ReqBody).Assign(TFieldSet(EditForm.Entity));

          JsonRes := FRestBroker.Update(ReqUpd);
          try
            if Assigned(JsonRes) and (JsonRes.StatusCode = 200) then
              res := True
            else
            begin
              if Assigned(JsonRes) then
                MessageDlg(Format('Обновление не удалось. HTTP %d'#13#10'%s',
                  [JsonRes.StatusCode, JsonRes.Response]), TMsgDlgType.mtWarning, [mbOK], nil)
              else
                MessageDlg('Обновление не удалось: пустой ответ', TMsgDlgType.mtWarning, [mbOK], nil);
              res := False;
            end;
          finally
            JsonRes.Free;
          end;
        except
          on E: Exception do
            res := False;
        end;
      end
      else
        res := False;
    end;

    // если обновить на сервере не удалось, то сообщаем об этом
    if not res then
      Exit
    else
    begin
      // если сущность на сервере обновилась — обновляем таблицу
      Refresh();
    end;
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

function TParentForm.CreateRestBroker: TRestBrokerBase;
begin
  Result := nil;
end;

end.

