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
    ///  метод возвращает конкретный тип объекта Settings
    ///  потомки должны переопределить его, потому что он у всех разный
    class function SettingsClassType: TSettingsClass; override;

  public
    // эти требуют существующего правильного экземпл€ра объекта. на ошибки - эксешан
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

  end;

  /// <summary>
  ///   Class Settings for TSummaryTask
  /// </summary>
  TSummaryTaskSettings = class(TSettings)
  public
    // эти требуют существующего правильного экземпл€ра объекта. на ошибки - эксешан
    ///  в массиве const APropertyNames передаютс€ пол€, которые необходимо использовать
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
