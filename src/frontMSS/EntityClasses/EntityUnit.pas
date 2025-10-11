unit EntityUnit;

interface

uses
  System.SysUtils, System.Generics.Collections, System.JSON, System.DateUtils,
  FuncUnit,
  LoggingUnit;

type
  ///  абстрактрый класс - набор полей
  ///  объявляет функцию которая позволяет проиницилиазировать поля
  ///  из другого такого же объекта
  TFieldSet = class (TObject)
  private
  protected
    procedure RaiseInvalidObjects(o: TObject); overload;
    procedure RaiseInvalidObjects(o1, o2: TObject); overload;

  public
    ///  устанавливаем поля с другого объекта
    function Assign(ASource: TFieldSet): boolean; virtual; abstract;

    // эти требуют существующего правильного экземпляра объекта. на ошибки - эксешан
    ///  в массиве const APropertyNames передаются поля, которые необходимо использовать
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); virtual; abstract;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; virtual; abstract;
    function Serialize(const APropertyNames: TArray<string> = nil): TJSONObject; overload; virtual;

  end;

type
  ///  настройки это тоже набор каких то полей
  TSettings = class (TFieldSet)
  public
    // эти требуют существующего правильного экземпляра объекта. на ошибки - эксешан
    ///  в массиве const APropertyNames передаются поля, которые необходимо использовать
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

  end;

type
  ///  TData это тоже настройки и тоже набор каких то полей
  TData = class (TFieldSet)
  public
    // эти требуют существующего правильного экземпляра объекта. на ошибки - эксешан
    ///  в массиве const APropertyNames передаются поля, которые необходимо использовать
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

  end;

type
  ///  TBody это тоже настройки и это тоже набор каких то полей
  TBody = class (TFieldSet)
  public
    // эти требуют существующего правильного экземпляра объекта. на ошибки - эксешан
    ///  в массиве const APropertyNames передаются поля, которые необходимо использовать
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

  end;


type
  ///  Класс Сущность - потомок всех сущностей проекта
  TEntity = class (TFieldSet)
  private
    FId: String;
    FDepId: string;
    FName: String;
    FCompId: string;
    FCaption: String;
    FCreated: TDateTime;
    FUpdated: TDateTime;
    FEnabled: boolean;
    FDef: String;
    FSettings: TSettings;
    FBody: TBody;
    FData: TData;

  protected
    ///  потомок должен вернуть имя поля для идентификатора
    function GetIdKey: string; virtual;

  public
    constructor Create(); overload;
    ///  конструктор сразу из JSON
    constructor Create(src: TJSONObject); overload;

    destructor Destroy; override;

    ///  устанавливаем поля с другого объекта
    function Assign(ASource: TFieldSet): boolean; override;

    // эти требуют существующего правильного экземпляра объекта. на ошибки - эксешан
    ///  в const APropertyNames передается список полей которые необходимо использовать
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    function Serialize(const APropertyNames: TArray<string> = nil): TJSONObject; overload; override;

    ///  идентификатор сущности
    property Id: String read FId write FId;
    ///  идентификатор компании
    property CompId: string read FCompId write FCompId;
    ///  идентификатор департамента
    property DepId: string read FDepId write FDepId;
    ///  наименование сущности
    property Name: String read FName write FName;
    ///  заголовок сущности
    property Caption: String read FCaption write FCaption;
    ///  описание сущности
    property Def: String read FDef write FDef;
    ///  время создания сущности
    property Enabled: boolean read FEnabled write FEnabled;
    ///  настройки
    property Settings: TSettings read FSettings write FSettings;
    ///  данные сущности
    property Data: TData read FData write FData;
    ///  тело сущности
    property Body: TBody read FBody write FBody;
    ///  время создания сущности
    property Created: TDateTime read FCreated write FCreated;
    ///  время обновления сущности
    property Updated: TDateTime read FUpdated write FUpdated;
  end;

  ///  класс - список сущностей
  TEntityList = class (TObjectList<TEntity>)
  private
  protected
  public
    ///  устанавливаем поля с другого объекта
    function Assign(ASource: TEntityList): boolean; virtual;

    // эти требуют существующего правильного экземпляра списка. на ошибки - эксешан
    ///  в APropertyNames передается список полей которые необходимо использовать
    procedure ParseList(src: TJSONObject; const APropertyNames: TArray<string>); overload; virtual; abstract;
    procedure SerializeList(dst: TJSONObject; const APropertyNames: TArray<string>); overload; virtual; abstract;
    function SerializeList(const APropertyNames: TArray<string>): TJSONObject; overload; virtual; abstract;

  end;

implementation

{ TFieldSet }

procedure TFieldSet.RaiseInvalidObjects(o1, o2: TObject);
begin
  raise exception.CreateFmt('invalid objects input: %s %s', [ClassNameSafe(o1), ClassNameSafe(o2)]);
end;

function TFieldSet.Serialize(const APropertyNames: TArray<string>): TJSONObject;
begin
  result := TJSONObject.Create;
  try
    Serialize(result);
  except on e:exception do
    begin
      Log('TEntityParser.Serialize '+ e.Message, lrtError);
      FreeAndNil(result);
    end;
  end;
end;

procedure TFieldSet.RaiseInvalidObjects(o: TObject);
begin
  raise exception.CreateFmt('invalid object type: %s', [ClassNameSafe(o)]);
end;


{ TEntity }

function TEntity.Assign(ASource: TFieldSet) : boolean;
var
  LSource : TEntity;

begin
  Result := false;

  if not Assigned(ASource) then exit;

  if not inherited Assign(ASource) then
    exit;

  /// Проверяем на совместимость с нашим типом
  if ASource is TEntity then
    LSource := ASource as TEntity;

  try
    Self.Id := LSource.Id;
    Self.CompId := LSource.CompId;
    Self.DepId := LSource.DepId;
    Self.Name := LSource.Name;
    Self.Caption := LSource.Caption;
    Self.Def := LSource.Def;
    Self.Enabled := LSource.Enabled;
    Self.Settings.Assign(LSource.Settings);
    Self.Data.Assign(LSource.Data);
    Self.Body.Assign(LSource.Body);
    Self.Created := LSource.Created;
    Self.Updated := LSource.Updated;

    Result := true;
  finally

  end;

end;

function TEntity.GetIdKey: string;
begin
  ///  по умолчанию возвращаем id
  Result := 'id';
end;

procedure TEntity.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Id := GetValueStrDef(src, GetIdKey, '');
  Name := GetValueStrDef(src, 'name', '');
  Caption := GetValueStrDef(src, 'caption', '');
  CompId := GetValueStrDef(src, 'compid', '');
  DepId := GetValueStrDef(src, 'depid', '');
  Def := GetValueStrDef(src, 'def', '');
  Enabled := GetValueBool(src, 'enabled');
  Created := UnixToDateTime(GetValueIntDef(src, 'created', 0));
  Updated := UnixToDateTime(GetValueIntDef(src, 'updated', 0))
end;

procedure TEntity.Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil);
begin
  with dst do
  begin
    AddPair(GetIdKey, Id);
    AddPair('name', Name);
    AddPair('caption', Caption);
    AddPair('def', Def);
    AddPair('compid', CompId);
    AddPair('depid', DepId);
    AddPair('enabled', Enabled);
    AddPair('created', DateTimeToUnix(Created));
    AddPair('updated', DateTimeToUnix(Updated));
    ///  добавляем настройки, тело и данные
    dst.AddPair('settings', Settings.Serialize());
    dst.AddPair('data', Data.Serialize());
    dst.AddPair('body', Body.Serialize());
  end;
end;

function TEntity.Serialize(const APropertyNames: TArray<string>): TJSONObject;
begin
  result := TJSONObject.Create;
  try
    Serialize(result);
  except on e:exception do
    begin
      Log('TEntityParser.Serialize '+ e.Message, lrtError);
      FreeAndNil(result);
    end;
  end;
end;

constructor TEntity.Create;
begin
  Settings := nil; Data := nil; Body := nil;

  inherited Create();

  Settings := TSettings.Create();

  Data := TData.Create();

  Body := TBody.Create();
end;

constructor TEntity.Create(src: TJSONObject);
begin
  Create();

  Parse(src);
end;

destructor TEntity.Destroy;
begin

  try
    Settings.Free;
  except
    Settings := nil;
  end;

  try
    Data.Free;
  except
    Data := nil;
  end;

  try
    Body.Free;
  except
    Body := nil;
  end;

  inherited;
end;

{ TEntityList }

function TEntityList.Assign(ASource: TEntityList): boolean;
begin
  /// создаем классы и вызываем функцию копирования полей
  ///  и добавляем их в список
  for var i := 0 to ASource.Count-1 do
  begin
    var es := TEntity.Create();
    es.Assign(ASource.Items[i]);
    Add(es);
  end;
end;

{ TSettings }

procedure TSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  ///  у базового класса пусто
end;

{ TData }


procedure TData.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  ///  у базового класса пусто
end;

{ TBody }

procedure TBody.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  ///  у базового класса пусто
end;

end.


