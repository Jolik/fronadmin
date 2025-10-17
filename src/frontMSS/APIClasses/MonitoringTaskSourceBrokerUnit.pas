unit MonitoringTaskSourceBrokerUnit;

interface

uses
  APIConst,
  TaskSourcesBrokerUnit;

type
  TMonitoringTaskSourcesBroker = class(TTaskSourcesBroker)
  protected
    function GetServicePath: string; override;
  end;

implementation

function TMonitoringTaskSourcesBroker.GetServicePath: string;
begin
  Result := constURLMonitoringBasePath;
end;

end.
