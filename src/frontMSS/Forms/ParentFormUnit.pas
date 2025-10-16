unit ParentFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm,
  EntityUnit,
  ParentBrokerUnit,
  ParentEditFormUnit;

type
  ///  базовая форма с редактором и брокером
  TParentForm = class(TUniForm)
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
  private
    ///  брокер для доступа к API - потомок должен инициировать поле на функционального брокера
    FBroker: TParentBroker;
    ///  форма для редактирования сущности - потом должен инициировать поле на функциональный класс
    FEditForm : TParentEditForm;

  protected
    procedure NewCallback(ASender: TComponent; AResult: Integer);
    procedure UpdateCallback(ASender: TComponent; AResult: Integer);

    ///  функция для обновления компонент на форме
    procedure Refresh(const AId: String = ''); virtual; abstract;

    ///  функция для создания нужного брокера потомком
    ///  поток должен переопределить функцию чтобы создавался нужный брокер
    function CreateBroker(): TParentBroker; virtual; abstract;

    ///  функиця для создания нужной формы редактирвоания
    ///  поток должен переопределить функцию чтобы создавалась нужная форма редактирвоания
    function CreateEditForm(): TParentEditForm; virtual; abstract;

  public
    ///  брокер для доступа к API - потомок содать и вернуть ссылку на нужный брокер
    ///  в наследуемой функции CreateBroker
    property Broker: TParentBroker read FBroker;
    ///  форма для редактирования сущности - потомок должен создать и вернуть
    ///  ссылку на нужную форму в наследуемой функции CreateEditForm
    property EditForm: TParentEditForm read FEditForm;
    procedure PrepareEditForm;
  end;

function ParentForm: TParentForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

{  TParentForm }

procedure TParentForm.NewCallback(ASender: TComponent;
  AResult: Integer);
var
  LId : string;
  res : boolean;

begin
  ///
  ///  если модальное окно закрылось через ОК
  if AResult = mrOk then
  begin
    /// считываем из окна отредатикрованный класс сущности
    ///  и пытаемся создать на сервере
    ///  если все ок, то в ответ вернется созданный класс сущности
    res := Broker.New(EditForm.Entity);
    ///  если создать на сервере не удалось, то сообщаем об этом
    if not res then
    begin
/// !!!     ShowMessage()
      exit;
    end
    else
    begin
      ///  если сущность на сервере создалась то
      ///  обрабатываем ответ
      ///  обновляем таблицу с указанием новой сущности
///!!!      Refresh(LEntity.Id);
        Refresh();
    end;
  end;
end;

procedure TParentForm.UpdateCallback(ASender: TComponent;
  AResult: Integer);
var
  LId : string;
  res : boolean;

begin
  ///  если модальное окно закрылось через ОК
  if AResult = mrOk then
  begin
    /// считываем из окна отредатикрованный класс сущности
    ///  и пытаемся обновить на сервере
    ///  если все ок, то в ответ вернется обноленный класс сущности
    res := Broker.Update(EditForm.Entity);
    ///  если обновить на сервере не удалось, то сообщаем об этом
    if not res then
    begin
/// !!!     ShowMessage()
      exit;
    end
    else
    begin
      ///  если сущность на сервре создалась то
      ///  обрабатываем результат
      ///  обновляем таблицу с указанием новой сущности
///!!!      Refresh(LEntity.Id);
        Refresh();
    end;
  end;
end;

procedure TParentForm.UniFormCreate(Sender: TObject);
begin
  ///   создаем брокера
  FBroker := CreateBroker();
  ///   создаем форму редактирования
  /// 2025-10-16 Папков Александр. Тут не нужно создавать форму редактирования
  /// Ее нужно создавать по месту применения
  // FEditForm := CreateEditForm();
end;

procedure TParentForm.UniFormDestroy(Sender: TObject);
begin
  FreeAndNil(Broker);
// надо удалять или не нужнО? FreeAndNil(EditForm);
end;

procedure TParentForm.PrepareEditForm;
begin
  FEditForm := CreateEditForm();
end;

function ParentForm: TParentForm;
begin
  Result := TParentForm(UniMainModule.GetFormInstance(TParentForm));
end;

end.
