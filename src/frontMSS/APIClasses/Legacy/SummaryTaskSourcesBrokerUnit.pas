unit SummaryTaskSourcesBrokerUnit;

interface

uses
  TaskSourcesBrokerUnit;

type
  TSummaryTaskSourcesBroker = class(TTaskSourcesBroker)
  protected
    function GetServicePath: string; override;
  end;

implementation

uses
  APIConst;

function TSummaryTaskSourcesBroker.GetServicePath: string;
begin
  Result := constURLSummaryBasePath;
end;

end.
