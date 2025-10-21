unit SourceUnit;

interface

uses
  System.JSON,
  FuncUnit,
  EntityUnit;

type
  /// <summary>
  ///   Dataserver source entity.
  /// </summary>
  TSource = class(TEntity)
  private
    FModule: string;
    function GetSid: string;
    procedure SetSid(const Value: string);
  protected
    function GetIdKey: string; override;
  public
    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    property Sid: string read GetSid write SetSid;
    property Module: string read FModule write FModule;
  end;

  /// <summary>
  ///   Collection of dataserver sources.
  /// </summary>
  TSourceList = class(TEntityList)
  public
    class function ItemClassType: TEntityClass; override;
  end;

implementation

const
  SidKey = 'sid';
  ModuleKey = 'module';

function TSource.Assign(ASource: TFieldSet): boolean;
begin
  Result := False;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TSource) then
    Exit;

  Module := TSource(ASource).Module;

  Result := True;
end;

function TSource.GetIdKey: string;
begin
  Result := SidKey;
end;

function TSource.GetSid: string;
begin
  Result := Id;
end;

procedure TSource.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Parse(src, APropertyNames);

  Module := GetValueStrDef(src, ModuleKey, '');
end;

procedure TSource.SetSid(const Value: string);
begin
  Id := Value;
end;

procedure TSource.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Serialize(dst, APropertyNames);

  if Assigned(dst) then
    dst.AddPair(ModuleKey, Module);
end;

class function TSourceList.ItemClassType: TEntityClass;
begin
  Result := TSource;
end;

end.
