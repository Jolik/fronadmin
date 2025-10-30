unit TaskUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  LoggingUnit,
  EntityUnit;

type
  /// Класс задачи парсера (сервис strip)
  TTask = class (TEntity)
  private
    FModule: string;
    function GetTid: string;
    procedure SetTid(const Value: string);

  protected
    ///  метод возвращает конкретный тип объекта Settings
    ///  потомки должны переопределить его, потому что он у всех разный
    class function SettingsClassType: TSettingsClass; override;

    ///  потомок должен вернуть имя поля для идентификатора
    function GetIdKey: string; override;

  public
    function Assign(ASource: TFieldSet): boolean; override;

    // эти требуют существующего правильного экземпляра объекта. на ошибки - эксешан
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    // идентификатор задачи
    property Tid: string read GetTid write SetTid;
    // для поля module - типа Задачи
    property Module: string read FModule write FModule;

  end;

type
  ///  список задач
  TTaskList = class (TEntityList)
    ///  метод возвращает конкретный тип объекта элемента списка
    ///  потомки должны переопределить его, потому что он у всех разный
    class function ItemClassType: TEntityClass; override;

  end;

type
  ///  базовый класс настроек для Задач
  TTaskSettings = class(TSettings)
  public
    // эти требуют существующего правильного экземпляра объекта. на ошибки - эксешан
    ///  в массиве const APropertyNames передаются поля, которые необходимо использовать
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

  end;


implementation

uses
  System.SysUtils,
  FuncUnit;

const
  TidKey = 'tid';

{ TTask }

function TTask.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;

  if not inherited Assign(ASource) then
    exit;

  if not (ASource is TTask) then
    exit;

  var src := ASource as TTask;

  Module := src.Module;

  ///  копируем поля для настроек
  Settings:= src.Settings;

  result := true;
end;

function TTask.GetTid: string;
begin
  Result := Id;
end;

procedure TTask.SetTid(const Value: string);
begin
  Id := Value;
end;

class function TTask.SettingsClassType: TSettingsClass;
begin
  Result := TTaskSettings;
end;

///  метод возвращает наименование ключа идентификатора который используется
///  для данной сущности (у каждого он может быть свой)
function TTask.GetIdKey: string;
begin
  ///  имя поля идентификатора tid
  Result := TidKey;
end;

procedure TTask.Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil);
begin
  inherited Parse(src);

  ///  читаем поле module
  Module := GetValueStrDef(src, 'module', '');

end;

procedure TTask.Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil);

begin
  inherited Serialize(dst);

  dst.AddPair('module', Module);
end;

{ TTaskSettings }

procedure TTaskSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  ///  в базовом классе не делаем ничего
end;

procedure TTaskSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  ///  в базовом классе не делаем ничего
end;

{ TTaskList }

class function TTaskList.ItemClassType: TEntityClass;
begin
  Result := TTask;
end;

end.
