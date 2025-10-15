unit DirSettingsUnit;


interface
uses
  System.Generics.Collections, System.JSON, SysUtils,
  FuncUnit,
  LoggingUnit,
  EntityUnit;

type

  // TDir настройка папки на диске
  TDir = class(TFieldSet)
  private
    FPath: string;
    FDepth: integer;


  public
    ///  устанавливаем пол€ с другого объекта
    function Assign(ASource: TFieldSet): boolean; override;

    // эти требуют существующего правильного экземпл€ра объекта. на ошибки - эксешан
    ///  в массиве const APropertyNames передаютс€ пол€, которые необходимо использовать
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Path: string read FPath write FPath;
    property Depth: integer read FDepth write FDepth;
   end;




implementation

{ TDir }

function TDir.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;
  if not inherited Assign(ASource) then
    exit;
  if not (ASource is TDir) then
    exit;
  var src := ASource as TDir;
  Path := src.Path;
  Depth := src.Depth;
  Result := true;
end;

procedure TDir.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Path := GetValueStrDef(src, 'path', '');
  Depth := GetValueIntDef(src, 'depth', 0);
end;

procedure TDir.Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil);
begin
  dst.AddPair('path', Path);
  dst.AddPair('depth', Depth);
end;


end.
