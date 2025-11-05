unit SourceUnit;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.Generics.Collections,
  EntityUnit,
  ContextUnit;

type
  // Основная сущность источника, соответствующая SourceDef
  TSource = class(TFieldSet)
  private
    Fsid: string;
    Fname: string;
    Fsrctid: string;
    Fpid: string;
    Fdepid: string;
    FownerOrg: Integer;
    FtimeShift: Int64;
    FmeteoRange: Integer;
    Fbegin_meteo_day: Integer;
    Flast_insert: Int64;
    Fshow_mon: Integer;
    Fenable_mon: Integer;

    Fcountry: string;
    Fregion: string;
    Fmunicipal: string;

    Flat: Double;
    Flon: Double;
    Felev: Integer;

    Farchived: Int64;
    Fupdated: Int64;
    Fcreated: Int64;
    Fstatus: string;

    Findex: string;
    Fnumber: Integer;
    Fgroup: string;
    FsrcTypeID: integer;
    Fcontexts: TContextList;

  public
    constructor Create; overload; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    function Assign(ASource: TFieldSet): boolean; override;

    // Все публичные свойства
    property Sid: string read Fsid write Fsid;
    property Name: string read Fname write Fname;
    property Srctid: string read Fsrctid write Fsrctid;
    property Pid: string read Fpid write Fpid;
    property Depid: string read Fdepid write Fdepid;
    property OwnerOrg: Integer read FownerOrg write FownerOrg;
    property TimeShift: Int64 read FtimeShift write FtimeShift;
    property MeteoRange: Integer read FmeteoRange write FmeteoRange;
    property BeginMeteoDay: Integer read Fbegin_meteo_day write Fbegin_meteo_day;
    property LastInsert: Int64 read Flast_insert write Flast_insert;
    property ShowMon: Integer read Fshow_mon write Fshow_mon;
    property EnableMon: Integer read Fenable_mon write Fenable_mon;

    property Country: string read Fcountry write Fcountry;
    property Region: string read Fregion write Fregion;
    property Municipal: string read Fmunicipal write Fmunicipal;

    property Lat: Double read Flat write Flat;
    property Lon: Double read Flon write Flon;
    property Elev: Integer read Felev write Felev;

    property Archived: Int64 read Farchived write Farchived;
    property Updated: Int64 read Fupdated write Fupdated;
    property Created: Int64 read Fcreated write Fcreated;
    property Status: string read Fstatus write Fstatus;

    property Index: string read Findex write Findex;
    property Number: Integer read Fnumber write Fnumber;
    property Group: string read Fgroup write Fgroup;
    property SrcTypeID: Integer read FsrcTypeID write FsrcTypeID;
    property Contexts: TContextList read Fcontexts;
  end;

  TSourceList = class(TFieldSetList)
  public
    class function ItemClassType: TFieldSetClass; override;
  end;

implementation

uses
  FuncUnit;

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
  Fname := GetValueStrDef(src, 'name', '');
  Fsrctid := GetValueStrDef(src, 'srctid', '');
  Fpid := GetValueStrDef(src, 'pid', '');
  Fdepid := GetValueStrDef(src, 'depid', '');
  FownerOrg := GetValueIntDef(src, 'ownerOrg', 0);
  FtimeShift := GetValueInt64Def(src, 'timeShift', 0);
  FmeteoRange := GetValueIntDef(src, 'meteoRange', 0);
  Fbegin_meteo_day := GetValueIntDef(src, 'begin_meteo_day', 0);
  Flast_insert := GetValueInt64Def(src, 'last_insert', 0);
  Fshow_mon := GetValueIntDef(src, 'show_mon', 0);
  Fenable_mon := GetValueIntDef(src, 'enable_mon', 0);

  // Территория
  Fcountry := GetValueStrDef(src, 'ter.country', '');
  Fregion := GetValueStrDef(src, 'ter.region', '');
  Fmunicipal := GetValueStrDef(src, 'ter.municipal', '');

  // Координаты
  Flat := GetValueFloatDef(src, 'loc.lat', 0);
  Flon := GetValueFloatDef(src, 'loc.lon', 0);
  Felev := GetValueIntDef(src, 'loc.elev', 0);

  // Запись
  Farchived := GetValueInt64Def(src, 'rec.archived', 0);
  Fupdated := GetValueInt64Def(src, 'rec.updated', 0);
  Fcreated := GetValueInt64Def(src, 'rec.created', 0);
  Fstatus := GetValueStrDef(src, 'rec.status', '');

  // src.* поля
  Findex := GetValueStrDef(src, 'src.index', '');
  Fnumber := GetValueIntDef(src, 'src.number', 0);
  Fgroup := GetValueStrDef(src, 'src.group', '');
  FsrcTypeID := GetValueIntDef(src, 'src.type', -1);

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
  dst.AddPair('name', Fname);
  dst.AddPair('srctid', Fsrctid);
  dst.AddPair('pid', Fpid);
  dst.AddPair('depid', Fdepid);
  dst.AddPair('ownerOrg', TJSONNumber.Create(FownerOrg));
  dst.AddPair('timeShift', TJSONNumber.Create(FtimeShift));
  dst.AddPair('meteoRange', TJSONNumber.Create(FmeteoRange));
  dst.AddPair('begin_meteo_day', TJSONNumber.Create(Fbegin_meteo_day));
  dst.AddPair('last_insert', TJSONNumber.Create(Flast_insert));
  dst.AddPair('show_mon', TJSONNumber.Create(Fshow_mon));
  dst.AddPair('enable_mon', TJSONNumber.Create(Fenable_mon));

  // Территория
  var ter := TJSONObject.Create;
  ter.AddPair('country', Fcountry);
  ter.AddPair('region', Fregion);
  ter.AddPair('municipal', Fmunicipal);
  dst.AddPair('ter', ter);

  // Координаты
  var loc := TJSONObject.Create;
  loc.AddPair('lat', TJSONNumber.Create(Flat));
  loc.AddPair('lon', TJSONNumber.Create(Flon));
  loc.AddPair('elev', TJSONNumber.Create(Felev));
  dst.AddPair('loc', loc);

  // Запись
  var rec := TJSONObject.Create;
  rec.AddPair('status', Fstatus);
  rec.AddPair('archived', TJSONNumber.Create(Farchived));
  rec.AddPair('updated', TJSONNumber.Create(Fupdated));
  rec.AddPair('created', TJSONNumber.Create(Fcreated));
  dst.AddPair('rec', rec);

  // src.*
  var srcObj := TJSONObject.Create;
  srcObj.AddPair('index', Findex);
  srcObj.AddPair('number', TJSONNumber.Create(Fnumber));
  srcObj.AddPair('group', Fgroup);
  if FsrcTypeID <> -1 then
    srcObj.AddPair('type', TJSONNumber.Create(FsrcTypeID));
  dst.AddPair('src', srcObj);

  if Assigned(Fcontexts) then
  begin
    if Fcontexts.Count > 0 then
      dst.AddPair('contexts', Fcontexts.SerializeList)
    else
      dst.AddPair('contexts', TJSONArray.Create);
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

