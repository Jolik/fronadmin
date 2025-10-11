unit StripTaskUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  LoggingUnit,
  EntityUnit;

type
  /// Класс задачи парсера (сервис strip)
  TStripTask = class (TEntity)
  private
    FModule: string;
    function GetTid: string;
    procedure SetTid(const Value: string);

  protected
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

  ///  настройки сущности StripTask
  TStripTaskSettings = class (TSettings)

  end;

  ///  список задач для сервиса стрип
  TStripTaskList = class (TEntityList)

  end;


implementation

uses
  System.SysUtils,
  FuncUnit;

{ TStripTask }

function TStripTask.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;

  if not inherited Assign(ASource) then
    exit;

  if not (ASource is TStripTask) then
    exit;

  var src := ASource as TStripTask;

  Module := src.Module;

  ///  копируем поля для настроек
  Settings.Assign(src.Settings);

  result := true;
end;

function TStripTask.GetTid: string;
begin
  Result := Id;
end;

procedure TStripTask.SetTid(const Value: string);
begin
  Id := Value;
end;

///  метод возвращает наименование ключа идентификатора который используется
///  для данной сущности (у каждого он может быть свой)
function TStripTask.GetIdKey: string;
begin
  ///  имя поля идентификатора tid
  Result := 'tid';
end;

procedure TStripTask.Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil);
begin
  inherited Parse(src);

  ///  читаем поле module
  Module := GetValueStrDef(src, 'module', '');

  ///  получаем ссылку на JSON-объект settings
  var settings := src.FindValue('data.settings');

  ///  зазписываем данные из JSON в поле settings
///  Settings.

end;

procedure TStripTask.Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil);

begin
  inherited Serialize(dst);

  dst.AddPair('module', Module);
end;

end.
