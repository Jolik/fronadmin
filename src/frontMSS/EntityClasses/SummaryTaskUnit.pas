unit SummaryTaskUnit;

interface

uses
  System.Classes, System.SysUtils, System.JSON,
  FuncUnit,
  EntityUnit, TaskUnit;

type
  /// <summary>
  ///   Summary task entity representation.
  /// </summary>
  TSummaryTask = class(TTask)
  private
  protected
    ///  ����� ���������� ���������� ��� ������� Settings
    ///  ������� ������ �������������� ���, ������ ��� �� � ���� ������
    class function SettingsClassType: TSettingsClass; override;

  public
    // ��� ������� ������������� ����������� ���������� �������. �� ������ - �������
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

  end;

  /// <summary>
  ///   Class Settings for TSummaryTask
  /// </summary>
  TSummaryTaskSettings = class(TSettings)
  public
    // ��� ������� ������������� ����������� ���������� �������. �� ������ - �������
    ///  � ������� const APropertyNames ���������� ����, ������� ���������� ������������
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

  end;

implementation

{ TSummaryTask }

procedure TSummaryTask.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

end;

procedure TSummaryTask.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

end;

class function TSummaryTask.SettingsClassType: TSettingsClass;
begin
  Result := TSummaryTaskSettings;
end;

{ TSummaryTaskSettings }

procedure TSummaryTaskSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

end;

procedure TSummaryTaskSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

end;

end.
