unit BrokerIntfUnit;

interface

uses
  HttpClientUnit;

type
  IBroker = interface
    ['{7C2B3E8C-8F2B-4E06-A5B4-3B9B22F11916}']
    function List(AReq: THttpRequest): TJSONResponse;
    function Info(AReq: THttpRequest): TJSONResponse;
    function New(AReq: THttpRequest): TJSONResponse;
    function Update(AReq: THttpRequest): TJSONResponse;
    function Remove(AReq: THttpRequest): TJSONResponse;
  end;

implementation

end.

