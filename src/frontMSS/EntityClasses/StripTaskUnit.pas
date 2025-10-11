unit StripTaskUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  LoggingUnit,
  EntityUnit;

type
  /// ����� ������ ������� (������ strip)
  TStripTask = class (TEntity)
  private
    FModule: string;
    function GetTid: string;
    procedure SetTid(const Value: string);

  protected
    ///  ������� ������ ������� ��� ���� ��� ��������������
    function GetIdKey: string; override;

  public
    function Assign(ASource: TFieldSet): boolean; override;

    // ��� ������� ������������� ����������� ���������� �������. �� ������ - �������
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    // ������������� ������
    property Tid: string read GetTid write SetTid;
    // ��� ���� module - ���� ������
    property Module: string read FModule write FModule;

  end;

  ///  ��������� �������� StripTask
  TStripTaskSettings = class (TSettings)

  end;

  ///  ������ ����� ��� ������� �����
  TStripTaskList = class (TEntityList)

  end;


implementation

uses
  System.SysUtils,
  FuncUnit;

{ TStripTask }

function TStripTask.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;

  if not inherited Assign(ASource) then
    exit;

  if not (ASource is TStripTask) then
    exit;

  var src := ASource as TStripTask;

  Module := src.Module;

  ///  �������� ���� ��� ��������
  Settings.Assign(src.Settings);

  result := true;
end;

function TStripTask.GetTid: string;
begin
  Result := Id;
end;

procedure TStripTask.SetTid(const Value: string);
begin
  Id := Value;
end;

///  ����� ���������� ������������ ����� �������������� ������� ������������
///  ��� ������ �������� (� ������� �� ����� ���� ����)
function TStripTask.GetIdKey: string;
begin
  ///  ��� ���� �������������� tid
  Result := 'tid';
end;

procedure TStripTask.Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil);
begin
  inherited Parse(src);

  ///  ������ ���� module
  Module := GetValueStrDef(src, 'module', '');

  ///  �������� ������ �� JSON-������ settings
  var settings := src.FindValue('data.settings');

  ///  ����������� ������ �� JSON � ���� settings
///  Settings.

end;

procedure TStripTask.Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil);

begin
  inherited Serialize(dst);

  dst.AddPair('module', Module);
end;

end.
