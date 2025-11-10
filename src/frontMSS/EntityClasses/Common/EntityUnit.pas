unit EntityUnit;

interface

uses
  System.SysUtils, System.Generics.Collections, System.JSON, System.DateUtils,
  FuncUnit,
  LoggingUnit;

type
  // Class reference to any TFieldSet descendant
  TFieldSetClass = class of TFieldSet;
  ///  Abstract class representing a set of fields
  ///  Declares a function that allows initializing fields
  ///  from another instance of the same object
  TFieldSet = class (TObject)
  private
    FObjectName: string;
  protected
    procedure RaiseInvalidObjects(o: TObject); overload;
    procedure RaiseInvalidObjects(o1, o2: TObject); overload;

  public
    constructor Create(); overload; virtual;
    ///  Constructor that parses JSON immediately
    constructor Create(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; virtual;

    ///  Assign fields from another object
    function Assign(ASource: TFieldSet): boolean; virtual;

    // These require an existing valid object instance. Errors raise exceptions
    ///  The const APropertyNames array specifies the fields that must be used
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); virtual;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; virtual;
    function Serialize(const APropertyNames: TArray<string> = nil): TJSONObject; overload;
    function JSON(const APropertyNames: TArray<string> = nil): string;

    ///  Object name from JSON (if is)
    property ObjectName : string read FObjectName write FObjectName;
  end;

  // Class reference to any TFieldSetList descendant
  TFieldSetListClass = class of TFieldSetList;
  ///  Class that represents a list of field set objects
  TFieldSetList = class (TObjectList<TFieldSet>)
  private
  protected
    ///  Returns the specific type of list element
    ///  Descendants must override because they use different types
    class function ItemClassType: TFieldSetClass; virtual;

  public
    ///  Constructor that parses JSON immediately
    constructor Create(src: TJSONArray; const APropertyNames: TArray<string> = nil); overload; virtual;
    constructor Create(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; virtual;

    ///  Assign fields from another object
    function Assign(ASource: TFieldSetList): boolean; virtual;

    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; virtual;
    procedure Add(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; virtual;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; virtual;
    function Serialize(const APropertyNames: TArray<string> = nil): TJSONObject; overload; virtual;
    function JSON(const APropertyNames: TArray<string> = nil): string;

    // These require an existing valid list instance. Errors raise exceptions
    ///  The APropertyNames parameter lists the fields that must be used
    procedure ParseList(src: TJSONArray; const APropertyNames: TArray<string> = nil); overload; virtual;
    ///  Adds new records from the JSON array
    procedure AddList(src: TJSONArray; const APropertyNames: TArray<string> = nil); overload; virtual;
    procedure SerializeList(dst: TJSONArray; const APropertyNames: TArray<string> = nil); overload; virtual;
    function SerializeList(const APropertyNames: TArray<string> = nil): TJSONArray; overload; virtual;
    ///  return result as JSON list
    function JSONList(const APropertyNames: TArray<string> = nil): string;

  end;

type
  // Class reference to any TSettings descendant
  TSettingsClass = class of TSettings;
  ///  Settings are also a collection of fields
  TSettings = class (TFieldSet)
  public
    // These require an existing valid object instance. Errors raise exceptions
    ///  The const APropertyNames array specifies the fields that must be used
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

  end;

type
  // Class reference to any TData descendant
  TDataClass = class of TData;
  ///  TData is also a configuration-like collection of fields
  TData = class (TFieldSet)
  public
    // These require an existing valid object instance. Errors raise exceptions
    ///  The const APropertyNames array specifies the fields that must be used
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

  end;

type
  // Class reference to any TBody descendant
  TBodyClass = class of TBody;
  ///  TBody is also a configuration-like collection of fields
  TBody = class (TFieldSet)
  public
    // These require an existing valid object instance. Errors raise exceptions
    ///  The const APropertyNames array specifies the fields that must be used
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

  end;

type
  // Class reference to any TEntity list descendant
  TEntityListClass = class of TEntityList;

  // Class reference to any TEntity descendant
  TEntityClass = class of TEntity;

  ///  Entity class - ancestor for every entity in the project
  TEntity = class (TFieldSet)
  private
    FId: String;
    FDepId: string;
    FName: String;
    FCompId: string;
    FOwner: string;
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
    ///  Returns the specific Settings object type
    ///  Descendants must override because their types differ
    class function SettingsClassType: TSettingsClass; virtual;
    ///  Returns the specific Data object type
    ///  Descendants must override because their types differ
    class function DataClassType: TDataClass; virtual;
    ///  Returns the specific Body object type
    ///  Descendants must override because their types differ
    class function BodyClassType: TBodyClass; virtual;

    ///  Returns the specific TEntityList object type
    ///  Descendants must override because their types differ
    class function ListClassType: TEntityListClass; virtual;

    ///  Descendants should return the identifier field name
    function GetIdKey: string; virtual;

  public
    constructor Create(); overload; override;
    ///  Constructor that parses JSON immediately
    constructor Create(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    destructor Destroy; override;

    ///  Assign fields from another object
    function Assign(ASource: TFieldSet): boolean; override;

    // These require an existing valid object instance. Errors raise exceptions
    ///  The const APropertyNames parameter lists the fields that must be used
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    ///  Entity identifier
    property Id: String read FId write FId;
    ///  Company identifier
    property CompId: string read FCompId write FCompId;
    ///  Owner identifier
    property Owner: string read FOwner write FOwner;
    ///  Department identifier
    property DepId: string read FDepId write FDepId;
    ///  Entity name
    property Name: String read FName write FName;
    ///  Entity caption
    property Caption: String read FCaption write FCaption;
    ///  Entity description
    property Def: String read FDef write FDef;
    ///  Entity enabled flag
    property Enabled: boolean read FEnabled write FEnabled;
    ///  Settings
    property Settings: TSettings read FSettings write FSettings;
    ///  Entity data
    property Data: TData read FData write FData;
    ///  Entity body
    property Body: TBody read FBody write FBody;
    ///  Entity creation time
    property Created: TDateTime read FCreated write FCreated;
    ///  Entity update time
    property Updated: TDateTime read FUpdated write FUpdated;
    ///  Entity commit time
    property Commited: TDateTime read FCommited write FCommited;
    ///  Entity archive time
    property Archived: TDateTime read FArchived write FArchived;
  end;

  ///  Class representing a list of entities
  TEntityList = class (TObjectList<TEntity>)
  private
  protected
    ///  Returns the specific type of list element
    ///  Descendants must override because their types differ
    class function ItemClassType: TEntityClass; virtual;

  public
    ///  Constructor that parses JSON immediately
    constructor Create(src: TJSONArray; const APropertyNames: TArray<string> = nil); overload;
    constructor Create(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; virtual;

    ///  Assign fields from another object
    function Assign(ASource: TEntityList): boolean; virtual;

    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; virtual;
    procedure Add(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; virtual;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; virtual;
    function Serialize(const APropertyNames: TArray<string> = nil): TJSONObject; overload; virtual;
    function JSON(const APropertyNames: TArray<string> = nil): string;

    // These require an existing valid list instance. Errors raise exceptions
    ///  The APropertyNames parameter lists the fields that must be used
    procedure ParseList(src: TJSONArray; const APropertyNames: TArray<string> = nil); overload; virtual;
    procedure AddList(src: TJSONArray; const APropertyNames: TArray<string> = nil); overload; virtual;
    procedure SerializeList(dst: TJSONArray; const APropertyNames: TArray<string> = nil); overload; virtual;
    function SerializeList(const APropertyNames: TArray<string> = nil): TJSONArray; overload; virtual;
    function JSONList(const APropertyNames: TArray<string> = nil): string;

  end;

implementation

const
  SettingsKey = 'settings';
  DataKey = 'data';
  BodyKey = 'body';

  NameKey = 'name';
  CaptionKey = 'caption';
  CompIdKey = 'compid';
  OwnerKey = 'owner';
  DepIdKey = 'depid';
  DefKey = 'def';
  EnabledKey = 'enabled';
  CreatedKey = 'created';
  UpdatedKey = 'updated';
  CommitedKey = 'commited';
  ArchivedKey = 'archived';

{ TFieldSet }

function TFieldSet.Assign(ASource: TFieldSet): boolean;
begin
  result := true;
end;

constructor TFieldSet.Create(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  Create();
  Parse(src, APropertyNames);
end;


constructor TFieldSet.Create;
begin
  inherited Create;
  // Do not remove! Required as is!
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

procedure TFieldSet.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin

end;

procedure TFieldSet.RaiseInvalidObjects(o1, o2: TObject);
begin
  raise exception.CreateFmt('invalid objects input: %s %s', [ClassNameSafe(o1), ClassNameSafe(o2)]);
end;

procedure TFieldSet.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin

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

///  Returns the specific Settings object type
class function TEntity.SettingsClassType: TSettingsClass;
begin
  Result := TSettings;
end;

///  Returns the specific Data object type
class function TEntity.DataClassType: TDataClass;
begin
  Result := TData;
end;
///  Returns the specific Body object type
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

  ///  Check compatibility with our type
  if ASource is TEntity then
    LSource := ASource as TEntity;

  try
    Self.Id := LSource.Id;
    Self.CompId := LSource.CompId;
    Self.Owner := LSource.Owner;
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
  ///  Return "id" by default
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
  Owner := GetValueStrDef(src, OwnerKey, '');
  DepId := GetValueStrDef(src, DepIdKey, '');
  Def := GetValueStrDef(src, DefKey, '');
  Enabled := GetValueBool(src, EnabledKey);
  Created := UnixToDateTime(GetValueIntDef(src, CreatedKey, 0));
  Updated := UnixToDateTime(GetValueIntDef(src, UpdatedKey, 0));
  Commited := UnixToDateTime(GetValueIntDef(src, CommitedKey, 0));
  Archived := UnixToDateTime(GetValueIntDef(src, ArchivedKey, 0));

  ///  Get a reference to the settings JSON object
  var s := src.FindValue(SettingsKey);

  ///  Parse only if settings exists and is actually an object
  if Assigned(s) and (s is TJSONObject) then
    Settings.Parse(s as TJSONObject);

  ///  Get a reference to the data JSON object
  var d := src.FindValue(DataKey);
  ///  Parse only if data exists and is actually an object
  if Assigned(d) and (d is TJSONObject) then
    Data.Parse(d as TJSONObject);

  ///  Get a reference to the body JSON object
  var b := src.FindValue(BodyKey);
  ///  Parse only if body exists and is actually an object
  if Assigned(b) and (b is TJSONObject) then
    Body.Parse(b as TJSONObject);
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
    AddPair(OwnerKey, Owner);
    AddPair(DepIdKey, DepId);
    AddPair(EnabledKey, Enabled);
    AddPair(CreatedKey, DateTimeToUnix(Created));
    AddPair(UpdatedKey, DateTimeToUnix(Updated));
    AddPair(CommitedKey, DateTimeToUnix(Commited));
    AddPair(ArchivedKey, DateTimeToUnix(Archived));
    ///  Append settings, body, and data
    if Settings <> nil then
      AddPair(SettingsKey, Settings.Serialize());
    if Data <> nil then
      AddPair(DataKey, Data.Serialize());
    if Body <> nil then
      AddPair(BodyKey, Body.Serialize());
  end;
end;

constructor TEntity.Create;
begin
  Settings := nil; Data := nil; Body := nil;

  inherited Create();

  ///  Instantiate the class provided by descendants
  Settings := SettingsClassType.Create();

  ///  Instantiate the class provided by descendants
  Data := DataClassType.Create();

  ///  Instantiate the class provided by descendants
  Body := BodyClassType.Create();
end;

constructor TEntity.Create(src: TJSONObject; const APropertyNames: TArray<string> = nil);
begin
  Create();

  Parse(src, APropertyNames);
end;

destructor TEntity.Destroy;
begin
  FreeAndNil(Settings);
  FreeAndNil(Data);
  FreeAndNil(Body);
  inherited;
end;

{ TEntityList }

function TEntityList.Assign(ASource: TEntityList): boolean;
begin
  Result := False;

  if not Assigned(ASource) then
    Exit;

  Clear;

  ///  Instantiate objects, copy fields, and add them to the list
  for var i := 0 to ASource.Count-1 do
  begin
    var es := ItemClassType.Create();
    es.Assign(ASource.Items[i]);
    inherited Add(es);
  end;

  Result := True;
end;

constructor TEntityList.Create(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited Create();

  Parse(src, APropertyNames);
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

function TEntityList.JSON(const APropertyNames: TArray<string>): string;
begin
  Result := '{}';
  var LObject := TJSONObject.Create;
  try
    try
      Serialize(LObject, APropertyNames);
      Result := LObject.ToJSON;
    except
      on e: exception do
        Log('TEntityList.JSON ' + e.Message, lrtError);
    end;
  finally
    LObject.Free;
  end;
end;

function TEntityList.JSONList(const APropertyNames: TArray<string>): string;
begin
  Result := '[]';
  var LArray := TJSONArray.Create;
  try
    try
      SerializeList(LArray, APropertyNames);
      Result := LArray.ToJSON;
    except
      on e: exception do
        Log('TEntityList.JSONList ' + e.Message, lrtError);
    end;
  finally
    LArray.Free;
  end;
end;

procedure TEntityList.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  if not Assigned(src) then
    Exit;

  Clear();

  for var Pair in src do
  begin
    if Pair.JsonValue is TJSONObject then
    begin
      var Item := ItemClassType.Create();
      try
        Item.ObjectName := Pair.JsonString.Value;
        Item.Parse(Pair.JsonValue as TJSONObject, APropertyNames);
        inherited Add(Item);
      except
        Item.Free;
        raise;
      end;
    end;
  end;
end;

procedure TEntityList.ParseList(src: TJSONArray;
  const APropertyNames: TArray<string>);
begin
  ///  Replace any previously parsed content with the incoming JSON payload
  Clear();

  if not Assigned(src) then exit;

  ///  Build the list from each element of the JSON array
  for var i in src do
  begin
    if i is TJSONObject then
    begin
      ///  Create the object directly from JSON
      var e:= ItemClassType.Create(i as TJSONObject, APropertyNames);
      ///  Push it into the list
      inherited Add(e);
    end;
  end;

end;

procedure TEntityList.Add(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  if not Assigned(src) then
    Exit;

  ///  Append new items without clearing previously parsed entities
  for var Pair in src do
  begin
    if Pair.JsonValue is TJSONObject then
    begin
      var Item := ItemClassType.Create();
      try
        Item.ObjectName := Pair.JsonString.Value;
        Item.Parse(Pair.JsonValue as TJSONObject, APropertyNames);
        inherited Add(Item);
      except
        Item.Free;
        raise;
      end;
    end;
  end;
end;

procedure TEntityList.AddList(src: TJSONArray;
  const APropertyNames: TArray<string>);
begin
  if not Assigned(src) then exit;

  ///  Append the JSON objects from the array to the existing list
  for var i in src do
  begin
    if i is TJSONObject then
    begin
      ///  Create the object directly from JSON
      var e:= ItemClassType.Create(i as TJSONObject, APropertyNames);
      ///  Push it into the list
      inherited Add(e);
    end;
  end;
end;

procedure TEntityList.SerializeList(dst: TJSONArray;
  const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then
    exit;

  ///  Convert the in-memory list to a JSON array representation
  for var i := 0 to Count - 1 do
  begin
    var LObject := TJSONObject.Create;
    try
      Items[i].Serialize(LObject, APropertyNames);
      dst.AddElement(LObject);
    except
      LObject.Free;
      raise;
    end;
  end;
end;

procedure TEntityList.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then
    Exit;

  ///  Materialize the list as a JSON object keyed by entity name
  for var i := 0 to Count - 1 do
  begin
    var Item := Items[i];
    var Name := Item.ObjectName;
    if Name = '' then
      Name := Format('Item%d', [i + 1]);

    var LObject := TJSONObject.Create;
    try
      Item.Serialize(LObject, APropertyNames);
      dst.AddPair(Name, LObject);
    except
      LObject.Free;
      raise;
    end;
  end;
end;

function TEntityList.Serialize(
  const APropertyNames: TArray<string>): TJSONObject;
begin
  result := TJSONObject.Create;

  try
    Serialize(result, APropertyNames);

  except on e:exception do
    begin
      Log('TEntityList.Serialize '+ e.Message, lrtError);
      FreeAndNil(result);
    end;
  end;
end;

function TEntityList.SerializeList(
  const APropertyNames: TArray<string>): TJSONArray;
begin
  result := TJSONArray.Create;

  try
    SerializeList(result, APropertyNames);

  except on e:exception do
    begin
      Log('TEntityList.SerializeList '+ e.Message, lrtError);
      FreeAndNil(result);
    end;
  end;
end;

{ TSettings }

procedure TSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  ///  Base class intentionally left blank
end;

procedure TSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  ///  Base class does nothing
end;

{ TData }

procedure TData.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  ///  Base class intentionally left blank
end;

procedure TData.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  ///  Base class does nothing
end;

{ TBody }

procedure TBody.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  ///  Base class intentionally left blank
end;

procedure TBody.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  ///  Base class does nothing
end;

{ TFieldSetList }

function TFieldSetList.Assign(ASource: TFieldSetList): boolean;
begin
  ///  Instantiate objects, copy fields, and add them to the list
  Clear;
  for var i := 0 to ASource.Count-1 do
  begin
    var es := ItemClassType.Create();
    es.Assign(ASource.Items[i]);
    Add(es);
  end;
end;

constructor TFieldSetList.Create(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited Create();

  Parse(src, APropertyNames);
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

function TFieldSetList.JSON(const APropertyNames: TArray<string>): string;
begin
  Result := '{}';
  var obj := TJSONObject.Create;
  try
    try
      Serialize(obj, APropertyNames);
      Result := obj.ToJSON;
    except
      on e: exception do
        Log('TFieldSetList.JSON ' + e.Message, lrtError);
    end;
  finally
    obj.Free;
  end;
end;

function TFieldSetList.JSONList(const APropertyNames: TArray<string>): string;
begin
  Result := '[]';
  var arr := TJSONArray.Create;
  try
    try
      SerializeList(arr, APropertyNames);
      Result := arr.ToJSON;
    except
      on e: exception do
        Log('TFieldSetList.JSONList ' + e.Message, lrtError);
    end;
  finally
    arr.Free;
  end;
end;

procedure TFieldSetList.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  if not Assigned(src) then
    Exit;

  Clear();

  for var Pair in src do
  begin
    if Pair.JsonValue is TJSONObject then
    begin
      var Item := ItemClassType.Create();
      try
        Item.ObjectName := Pair.JsonString.Value;
        Item.Parse(Pair.JsonValue as TJSONObject, APropertyNames);
        inherited Add(Item);
      except
        Item.Free;
        raise;
      end;
    end;
  end;
end;

procedure TFieldSetList.ParseList(src: TJSONArray;
  const APropertyNames: TArray<string>);
begin
  if not Assigned(src) then
    exit;

  ///  Drop previously cached field sets before loading fresh data
  Clear();

  ///  Build the list from each element of the JSON array
  for var i in src do
  begin
    if i is TJSONObject then
    begin
      ///  Create the object directly from JSON
      var e:= ItemClassType.Create(i as TJSONObject);
      ///  Push it into the list
      Add(e);
    end;
  end;

end;

procedure TFieldSetList.Add(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  if not Assigned(src) then
    Exit;

  ///  Append new items without removing the existing ones
  for var Pair in src do
  begin
    if Pair.JsonValue is TJSONObject then
    begin
      var Item := ItemClassType.Create();
      try
        Item.ObjectName := Pair.JsonString.Value;
        Item.Parse(Pair.JsonValue as TJSONObject, APropertyNames);
        inherited Add(Item);
      except
        Item.Free;
        raise;
      end;
    end;
  end;
end;

procedure TFieldSetList.AddList(src: TJSONArray;
  const APropertyNames: TArray<string>);
begin
  if not Assigned(src) then exit;

  ///  Append the JSON objects from the array to the existing list
  for var i in src do
  begin
    if i is TJSONObject then
    begin
      ///  Create the object directly from JSON
      var e:= ItemClassType.Create(i as TJSONObject);
      ///  Push it into the list
      Add(e);
    end;
  end;
end;

procedure TFieldSetList.SerializeList(dst: TJSONArray;
  const APropertyNames: TArray<string>);
begin
  for var i := 0 to Count-1 do
  begin
    ///  Serialize each item in sequence and place it into the JSON array
    var Obj := TJSONObject.Create;
    try
      Items[i].Serialize(Obj, APropertyNames);
      dst.AddElement(Obj);
    except
      Obj.Free;
      raise;
    end;
  end;
end;

procedure TFieldSetList.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then
    Exit;

  ///  Materialize the list as a JSON object keyed by field-set name
  for var i := 0 to Count - 1 do
  begin
    var Item := Items[i];
    var Name := Item.ObjectName;
    if Name = '' then
      Name := Format('Item%d', [i + 1]);

    var Obj := TJSONObject.Create;
    try
      Item.Serialize(Obj, APropertyNames);
      dst.AddPair(Name, Obj);
    except
      Obj.Free;
      raise;
    end;
  end;
end;

function TFieldSetList.Serialize(
  const APropertyNames: TArray<string>): TJSONObject;
begin
  result := TJSONObject.Create;
  try
    Serialize(result, APropertyNames);
  except on e:exception do
    begin
      Log('TFieldSetList.Serialize '+ e.Message, lrtError);
      FreeAndNil(result);
    end;
  end;
end;

function TFieldSetList.SerializeList(
  const APropertyNames: TArray<string>): TJSONArray;
begin
  result := TJSONArray.Create;
  try
    SerializeList(result, APropertyNames);
  except on e:exception do
    begin
      Log('TFieldSetList.SerializeList '+ e.Message, lrtError);
      FreeAndNil(result);
    end;
  end;
end;

end.



