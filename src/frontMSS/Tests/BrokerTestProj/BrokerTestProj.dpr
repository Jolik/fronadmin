program BrokerTestProj;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  HttpClientUnit in '..\HttpClasses\HttpClientUnit.pas';

procedure ExecuteRequest;
var
  Request: THttpRequest;
  Response: TJSONResponse;
  StatusCode: Integer;
begin
  Request := THttpRequest.Create;
  Response := TJSONResponse.Create;
  try
    Request.Curl := 'curl --location ''http://213.167.42.170:8088/summary/api/v2/tasks/list?flags=verbose&options=1'' \' +
      sLineBreak +
      '--header ''X-Ticket: ST-Test''';

    StatusCode := HttpClient.Request(Request, Response);

    Writeln('Request CURL:');
    Writeln(Request.Curl);
    Writeln;
    Writeln(Format('Response (HTTP %d):', [StatusCode]));
    Writeln(Response.Response);
  finally
    Request.Free;
    Response.Free;
  end;
end;

begin
  try
    HttpClient.Addr := '213.167.42.170';
    HttpClient.Port := 8088;

    ExecuteRequest;
  except
    on E: Exception do
      Writeln(E.ClassName + ': ' + E.Message);
  end;
end.
