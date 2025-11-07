unit SourceUnit;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.Generics.Collections,
  EntityUnit,
  FuncUnit,
  ContextUnit;

type
  // Основная сущность источника, соответствующая SourceDef
  TSource = class(TFieldSet)
  private
    Fsid: string;
    Fname: Nullable<string>;
    Fsrctid: string;
    Fpid: Nullable<string>;
    Fdepid: Nullable<string>;
    FownerOrg: Nullable<Integer>;
    FtimeShift: Int64;
    FmeteoRange: Integer;
    Fbegin_meteo_day: Nullable<Integer>;
    Flast_insert: Nullable<Int64>;
    Fshow_mon: Integer;
    Fenable_mon: Integer;

    Fcountry: Nullable<string>;
    Fregion: Nullable<string>;
    Fmunicipal: Nullable<string>;

    Flat: Nullable<Double>;
    Flon: Nullable<Double>;
    Felev: Nullable<Integer>;

    Farchived: Nullable<Int64>;
    Fupdated: Nullable<Int64>;
    Fcreated: Nullable<Int64>;
    Fstatus: string;

    Findex: Nullable<string>;
    Fnumber: Integer;
    Fgroup: Nullable<string>;
    FsrcTypeID: Nullable<Integer>;
    Fcontexts: TContextList;
    FContactOrg: Nullable<string>;
    FContactDirector: Nullable<string>;
    FContactPhone: Nullable<string>;
    FContactEmail: Nullable<string>;
    FContactMailAddr: Nullable<string>;

  public
    constructor Create; overload; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    function Assign(ASource: TFieldSet): boolean; override;

    // Все публичные свойства
    property Sid: string read Fsid write Fsid;
    property Name: Nullable<string> read Fname write Fname;
    property Srctid: string read Fsrctid write Fsrctid;
    property Pid: Nullable<string> read Fpid write Fpid;
    property Depid: Nullable<string> read Fdepid write Fdepid;
    property OwnerOrg: Nullable<Integer> read FownerOrg write FownerOrg;
    property TimeShift: Int64 read FtimeShift write FtimeShift;
    property MeteoRange: Integer read FmeteoRange write FmeteoRange;
    property BeginMeteoDay: Nullable<Integer> read Fbegin_meteo_day write Fbegin_meteo_day;
    property LastInsert: Nullable<Int64> read Flast_insert write Flast_insert;
    property ShowMon: Integer read Fshow_mon write Fshow_mon;
    property EnableMon: Integer read Fenable_mon write Fenable_mon;

    property Country: Nullable<string> read Fcountry write Fcountry;
    property Region: Nullable<string> read Fregion write Fregion;
    property Municipal: Nullable<string> read Fmunicipal write Fmunicipal;

    property Lat: Nullable<Double> read Flat write Flat;
    property Lon: Nullable<Double> read Flon write Flon;
    property Elev: Nullable<Integer> read Felev write Felev;

    property Archived: Nullable<Int64> read Farchived write Farchived;
    property Updated: Nullable<Int64> read Fupdated write Fupdated;
    property Created: Nullable<Int64> read Fcreated write Fcreated;
    property Status: string read Fstatus write Fstatus;

    property Index: Nullable<string> read Findex write Findex;
    property Number: Integer read Fnumber write Fnumber;
    property Group: Nullable<string> read Fgroup write Fgroup;
    property SrcTypeID: Nullable<Integer> read FsrcTypeID write FsrcTypeID;
    property Contexts: TContextList read Fcontexts;
    property ContactOrg: Nullable<string> read FContactOrg write FContactOrg;
    property ContactDirector: Nullable<string> read FContactDirector write FContactDirector;
    property ContactPhone: Nullable<string> read FContactPhone write FContactPhone;
    property ContactEmail: Nullable<string> read FContactEmail write FContactEmail;
    property ContactMailAddr: Nullable<string> read FContactMailAddr write FContactMailAddr;
  end;

  TSourceList = class(TFieldSetList)
  public
    class function ItemClassType: TFieldSetClass; override;
  end;

implementation

{ TSource }

constructor TSource.Create;
begin
  inherited Create;
  Fcontexts := TContextList.Create;
end;

destructor TSource.Destroy;
begin
  FreeAndNil(Fcontexts);
  inherited;
end;

procedure TSource.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  ContextsValue: TJSONValue;
begin
  if Assigned(Fcontexts) then
    Fcontexts.Clear;

  Fsid := GetValueStrDef(src, 'sid', '');
  Fname := GetNullableStr(src, 'name');
  Fpid := GetNullableStr(src, 'pid');
  Fdepid := GetNullableStr(src, 'depid');
  FownerOrg := GetNullableInt(src, 'ownerOrg');
  FtimeShift := GetValueInt64Def(src, 'timeShift', 0);
  FmeteoRange := GetValueIntDef(src, 'meteoRange', 0);
  Fbegin_meteo_day := GetNullableInt(src, 'begin_meteo_day');
  Flast_insert := GetNullableInt64(src, 'last_insert');
  Fshow_mon := GetValueIntDef(src, 'show_mon', 0);
  Fenable_mon := GetValueIntDef(src, 'enable_mon', 0);

  // Территория
  Fcountry := GetNullableStr(src, 'ter.country');
  Fregion := GetNullableStr(src, 'ter.region');
  Fmunicipal := GetNullableStr(src, 'ter.municipal');

  // Координаты
  Flat := GetNullableFloat(src, 'loc.lat');
  Flon := GetNullableFloat(src, 'loc.lon');
  Felev := GetNullableInt(src, 'loc.elev');

  // Запись
  Farchived := GetNullableInt64(src, 'rec.archived');
  Fupdated := GetNullableInt64(src, 'rec.updated');
  Fcreated := GetNullableInt64(src, 'rec.created');
  Fstatus := GetValueStrDef(src, 'rec.status', '');

  // src.* поля
  Findex := GetNullableStr(src, 'src.index');
  Fnumber := GetValueIntDef(src, 'src.number', 0);
  Fgroup := GetNullableStr(src, 'src.group');
  FsrcTypeID := GetNullableInt(src, 'src.type');
  FContactOrg := GetNullableStr(src, 'contacts.org');
  FContactDirector := GetNullableStr(src, 'contacts.director');
  FContactPhone := GetNullableStr(src, 'contacts.phone');
  FContactEmail := GetNullableStr(src, 'contacts.email');
  FContactMailAddr := GetNullableStr(src, 'contacts.mail');

  ContextsValue := nil;
  if Assigned(src) then
    ContextsValue := src.FindValue('contexts');

  if ContextsValue is TJSONArray then
    Fcontexts.ParseList(ContextsValue as TJSONArray)
  else if ContextsValue is TJSONObject then
    Fcontexts.Parse(ContextsValue as TJSONObject);
end;

procedure TSource.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  dst.AddPair('sid', Fsid);
  if Fname.HasValue then
    dst.AddPair('name', Fname.Value);
//  dst.AddPair(SrctidKey, Fsrctid);
  if Fpid.HasValue then
    dst.AddPair('pid', Fpid.Value);
  if Fdepid.HasValue then
    dst.AddPair('depid', Fdepid.Value);
  if FownerOrg.HasValue then
    dst.AddPair('ownerOrg', TJSONNumber.Create(FownerOrg.Value));
  dst.AddPair('timeShift', TJSONNumber.Create(FtimeShift));
  dst.AddPair('meteoRange', TJSONNumber.Create(FmeteoRange));
  if Fbegin_meteo_day.HasValue then
    dst.AddPair('begin_meteo_day', TJSONNumber.Create(Fbegin_meteo_day.Value));
  if Flast_insert.HasValue then
    dst.AddPair('last_insert', TJSONNumber.Create(Flast_insert.Value));
  dst.AddPair('show_mon', TJSONNumber.Create(Fshow_mon));
  dst.AddPair('enable_mon', TJSONNumber.Create(Fenable_mon));

  // Территория
  var ter := TJSONObject.Create;
  if Fcountry.HasValue then
    ter.AddPair('country', Fcountry.Value);
  if Fregion.HasValue then
    ter.AddPair('region', Fregion.Value);
  if Fmunicipal.HasValue then
    ter.AddPair('municipal', Fmunicipal.Value);
  dst.AddPair('ter', ter);

  // Координаты
  var loc := TJSONObject.Create;
  if Flat.HasValue then
    loc.AddPair('lat', TJSONNumber.Create(Flat.Value));
  if Flon.HasValue then
    loc.AddPair('lon', TJSONNumber.Create(Flon.Value));
  if Felev.HasValue then
    loc.AddPair('elev', TJSONNumber.Create(Felev.Value));
  dst.AddPair('loc', loc);

  // Запись
  var rec := TJSONObject.Create;
  rec.AddPair('status', Fstatus);
  if Farchived.HasValue then
    rec.AddPair('archived', TJSONNumber.Create(Farchived.Value));
  if Fupdated.HasValue then
    rec.AddPair('updated', TJSONNumber.Create(Fupdated.Value));
  if Fcreated.HasValue then
    rec.AddPair('created', TJSONNumber.Create(Fcreated.Value));
  dst.AddPair('rec', rec);

  // src.*
  var srcObj := TJSONObject.Create;
  if Findex.HasValue then
    srcObj.AddPair('index', Findex.Value);
  srcObj.AddPair('number', TJSONNumber.Create(Fnumber));
  if Fgroup.HasValue then
    srcObj.AddPair('group', Fgroup.Value);
  if FsrcTypeID.HasValue then
    srcObj.AddPair('type', TJSONNumber.Create(FsrcTypeID.Value));
  dst.AddPair('src', srcObj);

  if Assigned(Fcontexts) then
  begin
    if Fcontexts.Count > 0 then
      dst.AddPair('contexts', Fcontexts.SerializeList)
    else
      dst.AddPair('contexts', TJSONArray.Create);
  end;

  var contacts := TJSONObject.Create;
  try
    if FContactOrg.HasValue then
      contacts.AddPair('org', FContactOrg.Value);
    if FContactDirector.HasValue then
      contacts.AddPair('director', FContactDirector.Value);
    if FContactPhone.HasValue then
      contacts.AddPair('phone', FContactPhone.Value);
    if FContactEmail.HasValue then
      contacts.AddPair('email', FContactEmail.Value);
    if FContactMailAddr.HasValue then
      contacts.AddPair('mail', FContactMailAddr.Value);

    if contacts.Count > 0 then
      dst.AddPair('contacts', contacts)
    else
      contacts.Free;
  except
    contacts.Free;
    raise;
  end;
end;

function TSource.Assign(ASource: TFieldSet): boolean;
var
  Src: TSource;
begin
  if not Assigned(ASource) then
    Exit(False);

  if not (ASource is TSource) then
    Exit(inherited Assign(ASource));

  Src := TSource(ASource);

  Sid := Src.Sid;
  Name := Src.Name;
  Srctid := Src.Srctid;
  Pid := Src.Pid;
  Depid := Src.Depid;
  OwnerOrg := Src.OwnerOrg;
  TimeShift := Src.TimeShift;
  MeteoRange := Src.MeteoRange;
  BeginMeteoDay := Src.BeginMeteoDay;
  LastInsert := Src.LastInsert;
  ShowMon := Src.ShowMon;
  EnableMon := Src.EnableMon;
  Country := Src.Country;
  Region := Src.Region;
  Municipal := Src.Municipal;
  Lat := Src.Lat;
  Lon := Src.Lon;
  Elev := Src.Elev;
  Archived := Src.Archived;
  Updated := Src.Updated;
  Created := Src.Created;
  Status := Src.Status;
  Index := Src.Index;
  Number := Src.Number;
  Group := Src.Group;
  SrcTypeID := Src.SrcTypeID;
  FContactOrg := Src.ContactOrg;
  FContactDirector := Src.ContactDirector;
  FContactPhone := Src.ContactPhone;
  FContactEmail := Src.ContactEmail;
  FContactMailAddr := Src.ContactMailAddr;

  if Assigned(Fcontexts) then
  begin
    if Assigned(Src.Contexts) then
      Fcontexts.Assign(Src.Contexts)
    else
      Fcontexts.Clear;
  end
  else if Assigned(Src.Contexts) then
  begin
    Fcontexts := TContextList.Create;
    Fcontexts.Assign(Src.Contexts);
  end;

  Result := inherited Assign(ASource);
end;

{ TSourceList }

class function TSourceList.ItemClassType: TFieldSetClass;
begin
  Result := TSource;
end;

end.

