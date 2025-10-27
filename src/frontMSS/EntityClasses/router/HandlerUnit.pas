unit HandlerUnit;

interface

uses
  System.JSON,
  EntityUnit;

type
  /// <summary>
  ///   Represents a router handler entity.
  /// </summary>
  THandler = class(TEntity)
  private
    Fsvcid: string;
    Flid: string;
    function GetHid: string;
    procedure SetHid(const Value: string);
  protected
    function GetIdKey: string; override;
  public
    constructor Create; override;

    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Hid: string read GetHid write SetHid;
    property Svcid: string read Fsvcid write Fsvcid;
    property Lid: string read Flid write Flid;
  end;

  /// <summary>
  ///   List of router handler entities.
  /// </summary>
  THandlerList = class(TEntityList)
  public
    class function ItemClassType: TEntityClass; override;
  end;

implementation

uses
  FuncUnit;

const
  HidKey = 'hid';
  ServiceKey = 'service';
  ServiceIdKey = 'svcid';
  LinkKey = 'link';
  LinkIdKey = 'lid';

{ THandler }

function THandler.Assign(ASource: TFieldSet): boolean;
var
  SourceHandler: THandler;
begin
  Result := False;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is THandler) then
    Exit;

  SourceHandler := THandler(ASource);

  Fsvcid := SourceHandler.Svcid;
  Flid := SourceHandler.Lid;

  Result := True;
end;

constructor THandler.Create;
begin
  inherited Create;

  Fsvcid := '';
  Flid := '';
end;

function THandler.GetHid: string;
begin
  Result := Id;
end;

function THandler.GetIdKey: string;
begin
  Result := HidKey;
end;

procedure THandler.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Parse(src, APropertyNames);

  Fsvcid := '';
  Flid := '';

  if not Assigned(src) then
    Exit;

  Fsvcid := GetValueStrDef(src, ServiceKey + '.' + ServiceIdKey, '');
  Flid := GetValueStrDef(src, LinkKey + '.' + LinkIdKey, '');
end;

procedure THandler.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  ServiceObject: TJSONObject;
  LinkObject: TJSONObject;
begin
  if not Assigned(dst) then
    Exit;

  inherited Serialize(dst, APropertyNames);

  ServiceObject := TJSONObject.Create;
  try
    ServiceObject.AddPair(ServiceIdKey, Fsvcid);
    dst.AddPair(ServiceKey, ServiceObject);
  except
    ServiceObject.Free;
    raise;
  end;

  LinkObject := TJSONObject.Create;
  try
    LinkObject.AddPair(LinkIdKey, Flid);
    dst.AddPair(LinkKey, LinkObject);
  except
    LinkObject.Free;
    raise;
  end;
end;

procedure THandler.SetHid(const Value: string);
begin
  Id := Value;
end;

{ THandlerList }

class function THandlerList.ItemClassType: TEntityClass;
begin
  Result := THandler;
end;

end.
