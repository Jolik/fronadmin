unit EntityUnit;

interface

uses
  System.SysUtils, System.Generics.Collections, System.JSON, System.DateUtils,
  FuncUnit,
  LoggingUnit;

type
  // Êëàññ-ññûëêà íà ëþáîé ïîòîìîê TFieldSet
  TFieldSetClass = class of TFieldSet;
  ///  àáñòðàêòðûé êëàññ - íàáîð ïîëåé
  ///  îáúÿâëÿåò ôóíêöèþ êîòîðàÿ ïîçâîëÿåò ïðîèíèöèëèàçèðîâàòü ïîëÿ
  ///  èç äðóãîãî òàêîãî æå îáúåêòà
  TFieldSet = class (TObject)
  private
  protected
    procedure RaiseInvalidObjects(o: TObject); overload;
    procedure RaiseInvalidObjects(o1, o2: TObject); overload;

  public
    constructor Create(); overload; virtual;
    ///  êîíñòðóêòîð ñðàçó èç JSON
    constructor Create(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; virtual;

    ///  óñòàíàâëèâàåì ïîëÿ ñ äðóãîãî îáúåêòà
    function Assign(ASource: TFieldSet): boolean; virtual;

    // ýòè òðåáóþò ñóùåñòâóþùåãî ïðàâèëüíîãî ýêçåìïëÿðà îáúåêòà. íà îøèáêè - ýêñåøàí
    ///  â ìàññèâå const APropertyNames ïåðåäàþòñÿ ïîëÿ, êîòîðûå íåîáõîäèìî èñïîëüçîâàòü
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); virtual; abstract;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; virtual; abstract;
    function Serialize(const APropertyNames: TArray<string> = nil): TJSONObject; overload;
    function JSON(const APropertyNames: TArray<string> = nil): string; overload;

  end;

  // Êëàññ-ññûëêà íà ëþáîé ïîòîìîê TFieldSetList
  TFieldSetListClass = class of TFieldSetList;
  ///  êëàññ - ñïèñîê êëàññîâ-íàáîðîâ ïîëåé
  TFieldSetList = class (TObjectList<TFieldSet>)
  private
  protected
    ///  ìåòîä âîçâðàùàåò êîíêðåòíûé òèï îáúåêòà ýëåìåíòà ñïèñêà
    ///  ïîòîìêè äîëæíû ïåðåîïðåäåëèòü åãî, ïîòîìó ÷òî îí ó âñåõ ðàçíûé
    class function ItemClassType: TFieldSetClass; virtual;

  public
    ///  êîíñòðóêòîð ñðàçó èç JSON
    constructor Create(src: TJSONArray; const APropertyNames: TArray<string> = nil); overload; virtual;

    ///  óñòàíàâëèâàåì ïîëÿ ñ äðóãîãî îáúåêòà
    function Assign(ASource: TFieldSetList): boolean; virtual;

    // ýòè òðåáóþò ñóùåñòâóþùåãî ïðàâèëüíîãî ýêçåìïëÿðà ñïèñêà. íà îøèáêè - ýêñåøàí
    ///  â APropertyNames ïåðåäàåòñÿ ñïèñîê ïîëåé êîòîðûå íåîáõîäèìî èñïîëüçîâàòü
    procedure ParseList(src: TJSONArray; const APropertyNames: TArray<string> = nil); overload; virtual;
    /// äîîáàâëÿåò íîâûå çàïèñè èç JSON ìàññèâà
    procedure AddList(src: TJSONArray; const APropertyNames: TArray<string> = nil); overload; virtual;
    procedure SerializeList(dst: TJSONArray; const APropertyNames: TArray<string> = nil); overload; virtual;
    function SerializeList(const APropertyNames: TArray<string> = nil): TJSONArray; overload; virtual;

  end;

type
  // Êëàññ-ññûëêà íà ëþáîé ïîòîìîê TSettings
  TSettingsClass = class of TSettings;
  ///  íàñòðîéêè ýòî òîæå íàáîð êàêèõ òî ïîëåé
  TSettings = class (TFieldSet)
  public
    // ýòè òðåáóþò ñóùåñòâóþùåãî ïðàâèëüíîãî ýêçåìïëÿðà îáúåêòà. íà îøèáêè - ýêñåøàí
    ///  â ìàññèâå const APropertyNames ïåðåäàþòñÿ ïîëÿ, êîòîðûå íåîáõîäèìî èñïîëüçîâàòü
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

  end;

type
  // Êëàññ-ññûëêà íà ëþáîé ïîòîìîê TData
  TDataClass = class of TData;
  ///  TData ýòî òîæå íàñòðîéêè è òîæå íàáîð êàêèõ òî ïîëåé
  TData = class (TFieldSet)
  public
    // ýòè òðåáóþò ñóùåñòâóþùåãî ïðàâèëüíîãî ýêçåìïëÿðà îáúåêòà. íà îøèáêè - ýêñåøàí
    ///  â ìàññèâå const APropertyNames ïåðåäàþòñÿ ïîëÿ, êîòîðûå íåîáõîäèìî èñïîëüçîâàòü
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

  end;

type
  // Êëàññ-ññûëêà íà ëþáîé ïîòîìîê TBody
  TBodyClass = class of TBody;
    FOwner: string;
    ///
    property Owner: string read FOwner write FOwner;
  ///  TBody ýòî òîæå íàñòðîéêè è ýòî òîæå íàáîð êàêèõ òî ïîëåé
  TBody = class (TFieldSet)
  public
    // ýòè òðåáóþò ñóùåñòâóþùåãî ïðàâèëüíîãî ýêçåìïëÿðà îáúåêòà. íà îøèáêè - ýêñåøàí
    ///  â ìàññèâå const APropertyNames ïåðåäàþòñÿ ïîëÿ, êîòîðûå íåîáõîäèìî èñïîëüçîâàòü
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

  end;


type
  // Êëàññ-ññûëêà íà ëþáîé ñïèñîê ñóùíîñòåé TEntity
  TEntityListClass = class of TEntityList;

  // Êëàññ-ññûëêà íà ëþáîé ñïèñîê ñóùíîñòåé TEntity
  TEntityClass = class of TEntity;

  ///  Êëàññ Ñóùíîñòü - ïîòîìîê âñåõ ñóùíîñòåé ïðîåêòà
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
    ///  ìåòîä âîçâðàùàåò êîíêðåòíûé òèï îáúåêòà Settings
    ///  ïîòîìêè äîëæíû ïåðåîïðåäåëèòü åãî, ïîòîìó ÷òî îí ó âñåõ ðàçíûé
    class function SettingsClassType: TSettingsClass; virtual;
    ///  ìåòîä âîçâðàùàåò êîíêðåòíûé òèï îáúåêòà Data
    ///  ïîòîìêè äîëæíû ïåðåîïðåäåëèòü åãî, ïîòîìó ÷òî îí ó âñåõ ðàçíûé
    class function DataClassType: TDataClass; virtual;
    ///  ìåòîä âîçâðàùàåò êîíêðåòíûé òèï îáúåêòà Body
    ///  ïîòîìêè äîëæíû ïåðåîïðåäåëèòü åãî, ïîòîìó ÷òî îí ó âñåõ ðàçíûé
    class function BodyClassType: TBodyClass; virtual;

    ///  ìåòîä âîçâðàùàåò êîíêðåòíûé òèï îáúåêòà TEntityList
    ///  ïîòîìêè äîëæíû ïåðåîïðåäåëèòü åãî, ïîòîìó ÷òî îí ó âñåõ ðàçíûé
    class function ListClassType: TEntityListClass; virtual;

    ///  ïîòîìîê äîëæåí âåðíóòü èìÿ ïîëÿ äëÿ èäåíòèôèêàòîðà
    function GetIdKey: string; virtual;

  public
    constructor Create(); overload; override;
    ///  êîíñòðóêòîð ñðàçó èç JSON
    constructor Create(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    destructor Destroy; override;

    ///  óñòàíàâëèâàåì ïîëÿ ñ äðóãîãî îáúåêòà
    function Assign(ASource: TFieldSet): boolean; override;

    // ýòè òðåáóþò ñóùåñòâóþùåãî ïðàâèëüíîãî ýêçåìïëÿðà îáúåêòà. íà îøèáêè - ýêñåøàí
    ///  â const APropertyNames ïåðåäàåòñÿ ñïèñîê ïîëåé êîòîðûå íåîáõîäèìî èñïîëüçîâàòü
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    ///  èäåíòèôèêàòîð ñóùíîñòè
    property Id: String read FId write FId;
    ///  èäåíòèôèêàòîð êîìïàíèè
    property CompId: string read FCompId write FCompId;
    ///  èäåíòèôèêàòîð äåïàðòàìåíòà
    property DepId: string read FDepId write FDepId;
    ///  íàèìåíîâàíèå ñóùíîñòè
    property Name: String read FName write FName;
    ///  çàãîëîâîê ñóùíîñòè
    property Caption: String read FCaption write FCaption;
    ///  îïèñàíèå ñóùíîñòè
    property Def: String read FDef write FDef;
    ///  âðåìÿ ñîçäàíèÿ ñóùíîñòè
    property Enabled: boolean read FEnabled write FEnabled;
    ///  íàñòðîéêè
    property Settings: TSettings read FSettings write FSettings;
    ///  äàííûå ñóùíîñòè
    property Data: TData read FData write FData;
    ///  òåëî ñóùíîñòè
    property Body: TBody read FBody write FBody;
    ///  âðåìÿ ñîçäàíèÿ ñóùíîñòè
    property Created: TDateTime read FCreated write FCreated;
    ///  âðåìÿ îáíîâëåíèÿ ñóùíîñòè
    property Updated: TDateTime read FUpdated write FUpdated;
    ///  âðåìÿ êîììèòà ñóùíîñòè
    property Commited: TDateTime read FCommited write FCommited;
    ///  âðåìÿ àðõèâàöèè ñóùíîñòè
    property Archived: TDateTime read FArchived write FArchived;
  end;

  ///  êëàññ - ñïèñîê ñóùíîñòåé
  TEntityList = class (TObjectList<TEntity>)
  private
  protected
    ///  ìåòîä âîçâðàùàåò êîíêðåòíûé òèï îáúåêòà ýëåìåíòà ñïèñêà
    ///  ïîòîìêè äîëæíû ïåðåîïðåäåëèòü åãî, ïîòîìó ÷òî îí ó âñåõ ðàçíûé
    class function ItemClassType: TEntityClass; virtual;

  public
  OwnerKey = 'owner';
    ///  êîíñòðóêòîð ñðàçó èç JSON
    constructor Create(src: TJSONArray; const APropertyNames: TArray<string> = nil); overload;

    ///  óñòàíàâëèâàåì ïîëÿ ñ äðóãîãî îáúåêòà
    function Assign(ASource: TEntityList): boolean; virtual;

    // ýòè òðåáóþò ñóùåñòâóþùåãî ïðàâèëüíîãî ýêçåìïëÿðà ñïèñêà. íà îøèáêè - ýêñåøàí
    ///  â APropertyNames ïåðåäàåòñÿ ñïèñîê ïîëåé êîòîðûå íåîáõîäèìî èñïîëüçîâàòü
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
  //íå óäàëÿòü! òàê íàäî!
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

///  ìåòîä âîçâðàùàåò êîíêðåòíûé òèï îáúåêòà Settings
class function TEntity.SettingsClassType: TSettingsClass;
begin
  Result := TSettings;
end;

///  ìåòîä âîçâðàùàåò êîíêðåòíûé òèï îáúåêòà Data
class function TEntity.DataClassType: TDataClass;
begin
  Result := TData;
end;

    Self.Owner := LSource.Owner;
  Owner := GetValueStrDef(src, OwnerKey, '');
    AddPair(OwnerKey, Owner);
///  ìåòîä âîçâðàùàåò êîíêðåòíûé òèï îáúåêòà Body
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

  /// Ïðîâåðÿåì íà ñîâìåñòèìîñòü ñ íàøèì òèïîì
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
  ///  ïî óìîë÷àíèþ âîçâðàùàåì id
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

  ///  ïîëó÷àåì ññûëêó íà JSON-îáúåêò settings
  var s := src.FindValue(SettingsKey);

  ///  ïàðñèì òîëüêî åñëè setting ñóùåñòâóåò è ýòî äåéñòâèòåëüíî îáúåêò
  if Assigned(s) and (s is TJSONObject) then
    Settings.Parse(s as TJSONObject);

  ///  ïîëó÷àåì ññûëêó íà JSON-îáúåêò data
  var d := src.FindValue(DataKey);
  ///  ïàðñèì òîëüêî åñëè data ñóùåñòâóåò è ýòî äåéñòâèòåëüíî îáúåêò
  if Assigned(d) and (d is TJSONObject) then
    Data.Parse(d as TJSONObject);

  ///  ïîëó÷àåì ññûëêó íà JSON-îáúåêò body
  var b := src.FindValue(BodyKey);
  ///  ïàðñèì òîëüêî åñëè body ñóùåñòâóåò è ýòî äåéñòâèòåëüíî îáúåêò
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
    AddPair(DepIdKey, DepId);
    AddPair(EnabledKey, Enabled);
    AddPair(CreatedKey, DateTimeToUnix(Created));
    AddPair(UpdatedKey, DateTimeToUnix(Updated));
    AddPair(CommitedKey, DateTimeToUnix(Commited));
    AddPair(ArchivedKey, DateTimeToUnix(Archived));
    ///  äîáàâëÿåì íàñòðîéêè, òåëî è äàííûå
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

  ///  ñîçäàåì êëàññ â çàâèñèìîñòè îò òîãî ÷òî âûäàäóò ïîòîìêè
  Settings := SettingsClassType.Create();

  ///  ñîçäàåì êëàññ â çàâèñèìîñòè îò òîãî ÷òî âûäàäóò ïîòîìêè
  Data := DataClassType.Create();

  ///  ñîçäàåì êëàññ â çàâèñèìîñòè îò òîãî ÷òî âûäàäóò ïîòîìêè
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
  /// ñîçäàåì êëàññû è âûçûâàåì ôóíêöèþ êîïèðîâàíèÿ ïîëåé
  ///  è äîáàâëÿåì èõ â ñïèñîê
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

  ///  ôîðìèðóåì ñïèñîê
  for var i in src do
  begin
    if i is TJSONObject then
    begin
      ///  ñîçäàåì îáúåêò ñðàçó èç JSON
      var e:= ItemClassType.Create(i as TJSONObject);
      ///  òîëêàåì åãî â ñïèñîê
      Add(e);
    end;
  end;

end;

procedure TEntityList.AddList(src: TJSONArray;
  const APropertyNames: TArray<string>);
begin
  if not Assigned(src) then exit;

  ///  äîáàâëÿåì ñïèñîê
  for var i in src do
  begin
    if i is TJSONObject then
    begin
      ///  ñîçäàåì îáúåêò ñðàçó èç JSON
      var e:= ItemClassType.Create(i as TJSONObject);
      ///  òîëêàåì åãî â ñïèñîê
      Add(e);
    end;
  end;
end;

procedure TEntityList.SerializeList(dst: TJSONArray;
  const APropertyNames: TArray<string>);
begin
  ///  ïîêà ýòîò ìåòîä è íå íóæåí íàì - íè÷åãî íå äåëàåì
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
  ///  ó áàçîâîãî êëàññà ïóñòî
end;

procedure TSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  ///  áàçîâûé êëàññ íå äåëåàåò íè÷åãî
end;

{ TData }

procedure TData.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  ///  ó áàçîâîãî êëàññà ïóñòî
end;

procedure TData.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  ///  áàçîâûé êëàññ íå äåëåàåò íè÷åãî
end;

{ TBody }

procedure TBody.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  ///  ó áàçîâîãî êëàññà ïóñòî
end;

procedure TBody.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  ///  áàçîâûé êëàññ íå äåëåàåò íè÷åãî
end;

{ TFieldSetList }

function TFieldSetList.Assign(ASource: TFieldSetList): boolean;
begin
  /// ñîçäàåì êëàññû è âûçûâàåì ôóíêöèþ êîïèðîâàíèÿ ïîëåé
  ///  è äîáàâëÿåì èõ â ñïèñîê
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

  if not Assigned(src) then
    exit;

  ///  ôîðìèðóåì ñïèñîê
  for var i in src do
  begin
    if i is TJSONObject then
    begin
      ///  ñîçäàåì îáúåêò ñðàçó èç JSON
      var e:= ItemClassType.Create(i as TJSONObject);
      ///  òîëêàåì åãî â ñïèñîê
      Add(e);
    end;
  end;

end;

procedure TFieldSetList.AddList(src: TJSONArray;
  const APropertyNames: TArray<string>);
begin
  if not Assigned(src) then exit;

  ///  äîáàâëÿåì ñïèñîê
  for var i in src do
  begin
    if i is TJSONObject then
    begin
      ///  ñîçäàåì îáúåêò ñðàçó èç JSON
      var e:= ItemClassType.Create(i as TJSONObject);
      ///  òîëêàåì åãî â ñïèñîê
      Add(e);
    end;
  end;
end;

procedure TFieldSetList.SerializeList(dst: TJSONArray;
  const APropertyNames: TArray<string>);
begin
  for var i := 0 to Count-1 do
    dst.AddElement(Items[i].Serialize());
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


