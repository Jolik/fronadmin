unit StripTaskSourceBrokerUnit;

interface

uses
  TaskSourcesBrokerUnit;

type
  TStripTaskSourcesBroker = class(TTaskSourcesBroker)
  protected
    function GetServicePath: string; override;
  end;

implementation

uses
  APIConst;

function TStripTaskSourcesBroker.GetServicePath: string;
begin
  Result := constURLStripBasePath;
end;

end.
