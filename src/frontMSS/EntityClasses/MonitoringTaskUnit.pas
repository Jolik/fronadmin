unit MonitoringTaskUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  LoggingUnit,
  FuncUnit,
  EntityUnit, TaskUnit;

type
  /// ����� ������ ������� (������ monitoring)
  TMonitoringTask = class (TTask)
  private

  protected
    ///  ����� ���������� ���������� ��� ������� Settings
    ///  ������� ������ �������������� ���, ������ ��� �� � ���� ������
    class function SettingsClassType: TSettingsClass; override;

  public

  end;

type
  ///  ������ ����� ��� ������� monitoring
  TMonitoringTaskList = class (TTaskList)
  protected
    ///  ����� ���������� ���������� ��� ������� �������� ������
    ///  ������� ������ �������������� ���, ������ ��� �� � ���� ������
    class function ItemClassType: TEntityClass; override;

  end;

type
  ///  ��������� �������� MonitoringTask
  TMonitoringTaskSettings = class (TSettings)
  private
    FLateSec: integer;
    FPeriodSec: integer;
    FTime: string;

  public
    // ��� ������� ������������� ����������� ���������� �������. �� ������ - �������
    ///  � ������� const APropertyNames ���������� ����, ������� ���������� ������������
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    // ��� ���� module - ���� ������
    property Time: string read FTime write FTime;
    property LateSec: integer read FLateSec write FLateSec;
//    property MonthDays: integer read FMonthDays write FMonthDays;
    property PeriodSec: integer read FPeriodSec write FPeriodSec;

  end;


implementation

const
  TimeKey = 'Time';
  LateSecKey = 'LateSec';
  PeriodSecKey = 'PeriodSec';

{ TMonitoringTaskList }

class function TMonitoringTaskList.ItemClassType: TEntityClass;
begin
  Result := TMonitoringTask;
end;

{ TMonitoringTaskSettings }

(* ������ settings

  "settings": {
      "Time": "00:00/+15 03:00/* 06:00/* 09:00/* 12:00/* 15:00/* 18:00/* 21:00/*",
      "LateSec": 900,
      "MonthDays": null,
      "PeriodSec": 10800
  },

*)

procedure TMonitoringTaskSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

  ///  ������ ���� Time
  Time := GetValueStrDef(src, TimeKey, '');
  ///  ������ ���� LateSec
  LateSec := GetValueIntDef(src, LateSecKey, 0);
  ///  ������ ���� PeriodSec
  PeriodSec := GetValueIntDef(src, PeriodSecKey, 0);

end;

procedure TMonitoringTaskSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

  with dst do
  begin
    AddPair(TimeKey, Time);
    AddPair(LateSecKey, LateSec);
    AddPair(PeriodSecKey, PeriodSec);
  end;
end;

{ TMonitoringTask }

class function TMonitoringTask.SettingsClassType: TSettingsClass;
begin
  Result := TMonitoringTaskSettings;
end;

end.
