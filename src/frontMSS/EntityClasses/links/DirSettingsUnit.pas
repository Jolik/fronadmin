unit DirSettingsUnit;


interface
uses
  System.Generics.Collections, System.JSON, SysUtils,
  FuncUnit,
  LoggingUnit,
  EntityUnit;

type

  // TDirSettings ��������� ����� �� �����
  TDirSettings = class(TFieldSet)
  private
    FPath: string;
    FDepth: integer;


  public
    ///  ������������� ���� � ������� �������
    function Assign(ASource: TFieldSet): boolean; override;

    // ��� ������� ������������� ����������� ���������� �������. �� ������ - �������
    ///  � ������� const APropertyNames ���������� ����, ������� ���������� ������������
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Path: string read FPath write FPath;
    property Depth: integer read FDepth write FDepth;
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
  Result := true;
end;

procedure TDirSettings.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Path := GetValueStrDef(src, 'path', '');
  Depth := GetValueIntDef(src, 'depth', 0);
end;

procedure TDirSettings.Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil);
begin
  dst.AddPair('path', Path);
  dst.AddPair('depth', Depth);
end;


end.
