unit TaskUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  LoggingUnit,
  EntityUnit;

type
  /// ����� ������ ������� (������ strip)
  TTask = class (TEntity)
  private
    FModule: string;
    function GetTid: string;
    procedure SetTid(const Value: string);

  protected
    ///  ����� ���������� ���������� ��� ������� Settings
    ///  ������� ������ �������������� ���, ������ ��� �� � ���� ������
    class function SettingsClassType: TSettingsClass; override;

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

type
  ///  ������ �����
  TTaskList = class (TEntityList)
    ///  ����� ���������� ���������� ��� ������� �������� ������
    ///  ������� ������ �������������� ���, ������ ��� �� � ���� ������
    class function ItemClassType: TEntityClass; override;

  end;

type
  ///  ������� ����� �������� ��� �����
  TTaskSettings = class(TSettings)
  public
    // ��� ������� ������������� ����������� ���������� �������. �� ������ - �������
    ///  � ������� const APropertyNames ���������� ����, ������� ���������� ������������
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

  end;


implementation

uses
  System.SysUtils,
  FuncUnit;

const
  TidKey = 'tid';

{ TTask }

function TTask.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;

  if not inherited Assign(ASource) then
    exit;

  if not (ASource is TTask) then
    exit;

  var src := ASource as TTask;

  Module := src.Module;

  ///  �������� ���� ��� ��������
  if not Settings.Assign(src.Settings) then exit;

  result := true;
end;

function TTask.GetTid: string;
begin
  Result := Id;
end;

procedure TTask.SetTid(const Value: string);
begin
  Id := Value;
end;

class function TTask.SettingsClassType: TSettingsClass;
begin
  Result := TTaskSettings;
end;

///  ����� ���������� ������������ ����� �������������� ������� ������������
///  ��� ������ �������� (� ������� �� ����� ���� ����)
function TTask.GetIdKey: string;
begin
  ///  ��� ���� �������������� tid
  Result := TidKey;
end;

procedure TTask.Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil);
begin
  inherited Parse(src);

  ///  ������ ���� module
  Module := GetValueStrDef(src, 'module', '');

end;

procedure TTask.Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil);

begin
  inherited Serialize(dst);

  dst.AddPair('module', Module);
end;

{ TTaskSettings }

procedure TTaskSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  ///  � ������� ������ �� ������ ������
end;

procedure TTaskSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  ///  � ������� ������ �� ������ ������
end;

{ TTaskList }

class function TTaskList.ItemClassType: TEntityClass;
begin
  Result := TTask;
end;

end.
