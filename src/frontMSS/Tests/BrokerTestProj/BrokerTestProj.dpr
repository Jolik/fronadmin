program BrokerTestProj;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  HttpRequestUnit in '..\..\APIClasses\HttpRequestUnit.pas';

procedure ExecuteGetRequest;
var
  Broker: TBroker;
  Request: THttpRequest;
  Response: TJSONResponse;
begin
  Writeln('=== GET REQUEST ===');
  Broker := TBroker.Create('', 0);
  Request := THttpRequest.Create;
  Response := TJSONResponse.Create;
  try
    Request.URL := '/summary/api/v2/tasks/list';
    Request.Method := mGET;

    Broker.Request(Request, Response);

    if Assigned(Request) then
      Writeln(Request.Curl);

    if Assigned(Response) then
      Writeln(Response.Response);
  finally
    Response.Free;
    Request.Free;
    Broker.Free;
  end;
end;

begin
  ReportMemoryLeaksOnShutdown := True;
  try
    ExecuteGetRequest;
  except
    on E: Exception do
      Writeln('Error: ' + E.Message);
  end;
end.
