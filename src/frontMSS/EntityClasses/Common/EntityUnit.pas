unit EntityUnit;

interface

uses
  System.SysUtils, System.Generics.Collections, System.JSON, System.DateUtils,
  FuncUnit,
  LoggingUnit;

type
  // Класс-ссылка на любой потомок TSettings
  TFieldSetClass = class of TFieldSet;
  ///  абстрактрый класс - набор полей
  ///  объявляет функцию которая позволяет проиницилиазировать поля
  ///  из другого такого же объекта
  TFieldSet = class (TObject)
  private
  protected
    procedure RaiseInvalidObjects(o: TObject); overload;
    procedure RaiseInvalidObjects(o1, o2: TObject); overload;

  public
    constructor Create(); overload; virtual;
    ///  конструктор сразу из JSON
    constructor Create(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; virtual;

    destructor Destroy; override;

    ///  устанавливаем поля с другого объекта
    function Assign(ASource: TFieldSet): boolean; virtual; abstract;

    // эти требуют существующего правильного экземпляра объекта. на ошибки - эксешан
    ///  в массиве const APropertyNames передаются поля, которые необходимо использовать
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); virtual; abstract;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; virtual; abstract;
    function Serialize(const APropertyNames: TArray<string> = nil): TJSONObject; overload;
    function JSON(const APropertyNames: TArray<string> = nil): string; overload;

  end;

  ///  класс - список классов-наборов полей
  TFieldSetList = class (TObjectList<TFieldSet>)
  private
  protected
    ///  метод возвращает конкретный тип объекта элемента списка
    ///  потомки должны переопределить его, потому что он у всех разный
    class function ItemClassType: TFieldSetClass; virtual;

  public
    ///  конструктор сразу из JSON
    constructor Create(src: TJSONArray; const APropertyNames: TArray<string> = nil); overload;

    ///  устанавливаем поля с другого объекта
    function Assign(ASource: TFieldSetList): boolean; virtual;

    // эти требуют существующего правильного экземпляра списка. на ошибки - эксешан
    ///  в APropertyNames передается список полей которые необходимо использовать
    procedure ParseList(src: TJSONArray; const APropertyNames: TArray<string> = nil); overload; virtual;
    /// дообавляет новые записи из JSON массива
    procedure AddList(src: TJSONArray; const APropertyNames: TArray<string> = nil); overload; virtual;
    procedure SerializeList(dst: TJSONArray; const APropertyNames: TArray<string> = nil); overload; virtual;
    function SerializeList(const APropertyNames: TArray<string> = nil): TJSONArray; overload; virtual;

  end;

type
  // Класс-ссылка на любой потомок TSettings
  TSettingsClass = class of TSettings;
  ///  настройки это тоже набор каких то полей
  TSettings = class (TFieldSet)
  public
    // эти требуют существующего правильного экземпляра объекта. на ошибки - эксешан
    ///  в массиве const APropertyNames передаются поля, которые необходимо использовать
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

  end;

type
  // Класс-ссылка на любой потомок TData
  TDataClass = class of TData;
  ///  TData это тоже настройки и тоже набор каких то полей
  TData = class (TFieldSet)
  public
    // эти требуют существующего правильного экземпляра объекта. на ошибки - эксешан
    ///  в массиве const APropertyNames передаются поля, которые необходимо использовать
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

  end;

type
  // Класс-ссылка на любой потомок TBody
  TBodyClass = class of TBody;
  ///  TBody это тоже настройки и это тоже набор каких то полей
  TBody = class (TFieldSet)
  public
    // эти требуют существующего правильного экземпляра объекта. на ошибки - эксешан
    ///  в массиве const APropertyNames передаются поля, которые необходимо использовать
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

  end;


type
  // Класс-ссылка на любой список сущностей TEntity
  TEntityListClass = class of TEntityList;

  // Класс-ссылка на любой список сущностей TEntity
  TEntityClass = class of TEntity;

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
    FArchived: TDateTime;
    FCommited: TDateTime;

  protected
    ///  метод возвращает конкретный тип объекта Settings
    ///  потомки должны переопределить его, потому что он у всех разный
    class function SettingsClassType: TSettingsClass; virtual;
    ///  метод возвращает конкретный тип объекта Data
    ///  потомки должны переопределить его, потому что он у всех разный
    class function DataClassType: TDataClass; virtual;
    ///  метод возвращает конкретный тип объекта Body
    ///  потомки должны переопределить его, потому что он у всех разный
    class function BodyClassType: TBodyClass; virtual;

    ///  метод возвращает конкретный тип объекта TEntityList
    ///  потомки должны переопределить его, потому что он у всех разный
    class function ListClassType: TEntityListClass; virtual;

    ///  потомок должен вернуть имя поля для идентификатора
    function GetIdKey: string; virtual;

  public
    constructor Create(); overload; override;
    ///  конструктор сразу из JSON
    constructor Create(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    destructor Destroy; override;

    ///  устанавливаем поля с другого объекта
    function Assign(ASource: TFieldSet): boolean; override;

    // эти требуют существующего правильного экземпляра объекта. на ошибки - эксешан
    ///  в const APropertyNames передается список полей которые необходимо использовать
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

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
    ///  время коммита сущности
    property Commited: TDateTime read FCommited write FCommited;
    ///  время архивации сущности
    property Archived: TDateTime read FArchived write FArchived;
  end;

  ///  класс - список сущностей
  TEntityList = class (TObjectList<TEntity>)
  private
  protected
    ///  метод возвращает конкретный тип объекта элемента списка
    ///  потомки должны переопределить его, потому что он у всех разный
    class function ItemClassType: TEntityClass; virtual;

  public
    ///  конструктор сразу из JSON
    constructor Create(src: TJSONArray; const APropertyNames: TArray<string> = nil); overload;

    ///  устанавливаем поля с другого объекта
    function Assign(ASource: TEntityList): boolean; virtual;

    // эти требуют существующего правильного экземпляра списка. на ошибки - эксешан
    ///  в APropertyNames передается список полей которые необходимо использовать
    procedure ParseList(src: TJSONArray; const APropertyNames: TArray<string> = nil); overload; virtual;
    procedure AddList(src: TJSONArray; const APropertyNames: TArray<string> = nil); overload; virtual;
    procedure SerializeList(dst: TJSONArray; const APropertyNames: TArray<string> = nil); overload; virtual;
    function SerializeList(const APropertyNames: TArray<string> = nil): TJSONArray; overload; virtual;

  end;

implementation

const
  SettingsKey = 'settings';
  DataKey = 'data';
  BodyKey = 'body';

  NameKey = 'name';
  CaptionKey = 'caption';
  CompIdKey = 'compid';
  DepIdKey = 'depid';
  DefKey = 'Def';
  EnabledKey = 'enabled';
  CreatedKey = 'created';
  UpdatedKey = 'updated';
  CommitedKey = 'commited';
  ArchivedKey = 'archived';

{ TFieldSet }

constructor TFieldSet.Create(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  Create();

  Parse(src, APropertyNames);
end;

constructor TFieldSet.Create;
begin
  inherited Create();

end;

destructor TFieldSet.Destroy;
begin

  inherited;
end;

function TFieldSet.JSON(const APropertyNames: TArray<string>): string;
begin
  Result := '{}';
  var j := TJSONObject.Create;
  try
    try
      Serialize(j);
      Result := j.ToJSON;
    except on e:exception do
      begin
        Log('TFieldSet.Serialize '+ e.Message, lrtError);
      end;
    end;
  finally
    j.Free();
  end;
end;

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
      Log('TFieldSet.Serialize '+ e.Message, lrtError);
      FreeAndNil(result);
    end;
  end;
end;

procedure TFieldSet.RaiseInvalidObjects(o: TObject);
begin
  raise exception.CreateFmt('invalid object type: %s', [ClassNameSafe(o)]);
end;


{ TEntity }

///  метод возвращает конкретный тип объекта Settings
class function TEntity.SettingsClassType: TSettingsClass;
begin
  Result := TSettings;
end;

///  метод возвращает конкретный тип объекта Data
class function TEntity.DataClassType: TDataClass;
begin
  Result := TData;
end;

///  метод возвращает конкретный тип объекта Body
class function TEntity.BodyClassType: TBodyClass;
begin
  Result := TBody;
end;

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
    if not Self.Settings.Assign(LSource.Settings) then exit;
    if not Self.Data.Assign(LSource.Data) then exit;
    if not Self.Body.Assign(LSource.Body) then exit;
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

class function TEntity.ListClassType: TEntityListClass;
begin
  Result := TEntityList;
end;

procedure TEntity.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Id := GetValueStrDef(src, GetIdKey, '');
  Name := GetValueStrDef(src, NameKey, '');
  Caption := GetValueStrDef(src, CaptionKey, '');
  CompId := GetValueStrDef(src, CompIdKey, '');
  DepId := GetValueStrDef(src, DepIdKey, '');
  Def := GetValueStrDef(src, DefKey, '');
  Enabled := GetValueBool(src, EnabledKey);
  Created := UnixToDateTime(GetValueIntDef(src, CreatedKey, 0));
  Updated := UnixToDateTime(GetValueIntDef(src, UpdatedKey, 0));
  Commited := UnixToDateTime(GetValueIntDef(src, CommitedKey, 0));
  Archived := UnixToDateTime(GetValueIntDef(src, ArchivedKey, 0));

  ///  получаем ссылку на JSON-объект settings
  var s := src.FindValue(SettingsKey);
  ///  парсим только если setting существует и это действительно объект
  if Assigned(s) and (s is TJSONObject) then Settings.Parse(s as TJSONObject);

  ///  получаем ссылку на JSON-объект settings
  var d := src.FindValue(DataKey);
  ///  парсим только если data существует и это действительно объект
  if Assigned(d) and (d is TJSONObject) then Data.Parse(d as TJSONObject);

  ///  получаем ссылку на JSON-объект settings
  var b := src.FindValue(BodyKey);
  ///  парсим только если body существует и это действительно объект
  if Assigned(b) and (b is TJSONObject) then Body.Parse(b as TJSONObject);
end;

procedure TEntity.Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil);
begin
  with dst do
  begin
    AddPair(GetIdKey, Id);
    AddPair(NameKey, Name);
    AddPair(CaptionKey, Caption);
    AddPair(DefKey, Def);
    AddPair(CompIdKey, CompId);
    AddPair(DepIdKey, DepId);
    AddPair(EnabledKey, Enabled);
    AddPair(CreatedKey, DateTimeToUnix(Created));
    AddPair(UpdatedKey, DateTimeToUnix(Updated));
    AddPair(CommitedKey, DateTimeToUnix(Commited));
    AddPair(ArchivedKey, DateTimeToUnix(Archived));
    ///  добавляем настройки, тело и данные
    dst.AddPair(SettingsKey, Settings.Serialize());
    dst.AddPair(DataKey, Data.Serialize());
    dst.AddPair(BodyKey, Body.Serialize());
  end;
end;

constructor TEntity.Create;
begin
  Settings := nil; Data := nil; Body := nil;

  inherited Create();

  ///  создаем класс в зависимости от того что выдадут потомки
  Settings := SettingsClassType.Create();

  ///  создаем класс в зависимости от того что выдадут потомки
  Data := DataClassType.Create();

  ///  создаем класс в зависимости от того что выдадут потомки
  Body := BodyClassType.Create();
end;

constructor TEntity.Create(src: TJSONObject; const APropertyNames: TArray<string> = nil);
begin
  Create();

  Parse(src, APropertyNames);
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

constructor TEntityList.Create(src: TJSONArray;
  const APropertyNames: TArray<string>);
begin
  inherited Create();

  ParseList(src, APropertyNames);
end;

class function TEntityList.ItemClassType: TEntityClass;
begin
  Result := TEntity;
end;

procedure TEntityList.ParseList(src: TJSONArray;
  const APropertyNames: TArray<string>);
begin
  Clear();

  if not Assigned(src) then exit;

  ///  формируем список
  for var i in src do
  begin
    if i is TJSONObject then
    begin
      ///  создаем объект сразу из JSON
      var e:= ItemClassType.Create(i as TJSONObject);
      ///  толкаем его в список
      Add(e);
    end;
  end;

end;

procedure TEntityList.AddList(src: TJSONArray;
  const APropertyNames: TArray<string>);
begin
  if not Assigned(src) then exit;

  ///  добавляем список
  for var i in src do
  begin
    if i is TJSONObject then
    begin
      ///  создаем объект сразу из JSON
      var e:= ItemClassType.Create(i as TJSONObject);
      ///  толкаем его в список
      Add(e);
    end;
  end;
end;

procedure TEntityList.SerializeList(dst: TJSONArray;
  const APropertyNames: TArray<string>);
begin
  ///  пока этот метод и не нужен нам - ничего не делаем
end;

function TEntityList.SerializeList(
  const APropertyNames: TArray<string>): TJSONArray;
begin
  result := TJSONArray.Create;

  try
    SerializeList(result);

  except on e:exception do
    begin
      Log('TEntityList.Serialize '+ e.Message, lrtError);
      FreeAndNil(result);
    end;
  end;
end;

{ TSettings }

procedure TSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  ///  у базового класса пусто
end;

procedure TSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  ///  базовый класс не делеает ничего
end;

{ TData }

procedure TData.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  ///  у базового класса пусто
end;

procedure TData.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  ///  базовый класс не делеает ничего
end;

{ TBody }

procedure TBody.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  ///  у базового класса пусто
end;

procedure TBody.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  ///  базовый класс не делеает ничего
end;

{ TFieldSetList }

function TFieldSetList.Assign(ASource: TFieldSetList): boolean;
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

constructor TFieldSetList.Create(src: TJSONArray;
  const APropertyNames: TArray<string>);
begin
  inherited Create();

  ParseList(src, APropertyNames);
end;

class function TFieldSetList.ItemClassType: TFieldSetClass;
begin
  Result := TFieldSet;
end;

procedure TFieldSetList.ParseList(src: TJSONArray;
  const APropertyNames: TArray<string>);
begin
  Clear();

  if not Assigned(src) then exit;

  ///  формируем список
  for var i in src do
  begin
    if i is TJSONObject then
    begin
      ///  создаем объект сразу из JSON
      var e:= ItemClassType.Create(i as TJSONObject);
      ///  толкаем его в список
      Add(e);
    end;
  end;

end;

procedure TFieldSetList.AddList(src: TJSONArray;
  const APropertyNames: TArray<string>);
begin
  if not Assigned(src) then exit;

  ///  добавляем список
  for var i in src do
  begin
    if i is TJSONObject then
    begin
      ///  создаем объект сразу из JSON
      var e:= ItemClassType.Create(i as TJSONObject);
      ///  толкаем его в список
      Add(e);
    end;
  end;
end;

procedure TFieldSetList.SerializeList(dst: TJSONArray;
  const APropertyNames: TArray<string>);
begin
  ///  пока этот метод и не нужен нам - ничего не делаем
end;

function TFieldSetList.SerializeList(
  const APropertyNames: TArray<string>): TJSONArray;
begin
  result := TJSONArray.Create;

  try
    SerializeList(result);

  except on e:exception do
    begin
      Log('TFieldSetList.Serialize '+ e.Message, lrtError);
      FreeAndNil(result);
    end;
  end;
end;

end.


