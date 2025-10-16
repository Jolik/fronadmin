unit MonitoringTaskSourceUnit;

interface

uses
  TaskSourcesBrokerUnit;

type
  TMonitoringTaskSourcesBroker = class(TTaskSourcesBroker)
  protected
    function GetServicePath: string; override;
  end;

implementation

function TMonitoringTaskSourcesBroker.GetServicePath: string;
begin
  Result := '/monitoring/api/v2';
end;

end.
