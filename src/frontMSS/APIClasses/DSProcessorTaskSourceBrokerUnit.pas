unit DSProcessorTaskSourceBrokerUnit;

interface

uses
  TaskSourcesBrokerUnit;

type
  TDSProcessorTaskSourcesBroker = class(TTaskSourcesBroker)
  protected
    function GetServicePath: string; override;
  end;

implementation

uses
  APIConst;

function TDSProcessorTaskSourcesBroker.GetServicePath: string;
begin
  Result := constURLDSProcessBasePath;
end;

end.
