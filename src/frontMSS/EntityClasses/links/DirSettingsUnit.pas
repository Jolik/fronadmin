unit DirSettingsUnit;


interface
uses
  System.Generics.Collections, System.JSON, SysUtils,
  FuncUnit,
  LoggingUnit,
  EntityUnit;

type

  // TDirSettings настройка папки на диске
  TDirSettings = class(TFieldSet)
  private
    FPath: string;
    FDepth: integer;
    FQuota: integer;

  public
    ///  устанавливаем пол€ с другого объекта
    function Assign(ASource: TFieldSet): boolean; override;

    // эти требуют существующего правильного экземпл€ра объекта. на ошибки - эксешан
    ///  в массиве const APropertyNames передаютс€ пол€, которые необходимо использовать
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Path: string read FPath write FPath;
    property Depth: integer read FDepth write FDepth;
    property Quota: integer read FQuota write FQuota;
   end;




implementation

{ TDirSettings }

function TDirSettings.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;
  if not inherited Assign(ASource) then
    exit;
  if not (ASource is TDirSettings) then
    exit;
  var src := ASource as TDirSettings;
  Path := src.Path;
  Depth := src.Depth;
  Quota := src.Quota;
  Result := true;
end;

procedure TDirSettings.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Path := GetValueStrDef(src, 'path', '');
  Depth := GetValueIntDef(src, 'depth', 0);
  Quota := GetValueIntDef(src, 'quota', 0);
end;

procedure TDirSettings.Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil);
begin
  dst.AddPair('path', Path);
  if Depth > 0 then
    dst.AddPair('depth', Depth);
  if Quota > 0 then
    dst.AddPair('quota', Quota);
end;


end.
