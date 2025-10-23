program BrokerTestProj;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Generics.Collections,
  HttpClientUnit in '..\..\HttpClasses\HttpClientUnit.pas',
  EntityUnit in '..\..\EntityClasses\Common\EntityUnit.pas',
  FuncUnit in '..\..\Common\FuncUnit.pas',
  LoggingUnit in '..\..\Logging\LoggingUnit.pas',
  TextFileLoggerUnit in '..\..\Logging\TextFileLoggerUnit.pas',
  AbonentHttpRequests in '..\..\HttpClasses\AbonentHttpRequests.pas',
  AbonentUnit in '..\..\EntityClasses\router\AbonentUnit.pas';

procedure ExecuteRequest;
var
  Request: THttpRequest;
  Response: TJSONResponse;
  StatusCode: Integer;
begin
  Request := THttpRequest.Create;
  Response := TJSONResponse.Create;
  try
    Request.Curl := 'curl --location ''http://213.167.42.170:8088/summary/api/v2/tasks/list?flags=verbose&options=1'' --header ''X-Ticket: ST-Test''';

//    Request.Curl := 'curl --location ''http://213.167.42.170:8088/dataserver/api/v2/sources/list?searchStr=%D0%9C%D0%98%D0%9D%D0%98%D0%9C%D0%90%D0%9A%D0%A1&searchBy=name'' --header ''X-Ticket: ST-Test''';

    StatusCode := HttpClient.Request(Request, Response);

    Writeln('-----------------------------------------------------------------');
    Writeln('Request CURL:');
    Writeln(Request.Curl);
    Writeln;
    Writeln('-----------------------------------------------------------------');
    Writeln(Format('Response (HTTP %d):', [StatusCode]));
    Writeln(Response.Response);
    Writeln('-----------------------------------------------------------------');
    Readln;
  finally
    Request.Free;
    Response.Free;
  end;
end;

procedure TestAbonentListRequest;
var
  Request: TAbonentReqList;
  Response: TAbonentListResponse;
  StatusCode: Integer;
  Abonent: TAbonent;
  ChannelsText: string;
begin
  Request := TAbonentReqList.Create;
  Response := TAbonentListResponse.Create;
  try
    Request.Headers.AddOrSetValue('X-Ticket', 'ST-Test');

    if Assigned(Request.Body) then
      Request.Body.PageSize := 50;

    StatusCode := HttpClient.Request(Request, Response);

    Writeln('-----------------------------------------------------------------');
    Writeln('Request URL: ' + Request.GetURLWithParams);
    Writeln(Format('Request Body: %s', [Request.ReqBodyContent]));
    if Assigned(Request.Body) then
      Writeln(Format('Requested page size: %d', [Request.Body.PageSize]));
    Writeln('-----------------------------------------------------------------');
    Writeln(Format('Response (HTTP %d):', [StatusCode]));
    Writeln(Format('Abonent records: %d', [Response.AbonentList.Count]));
    if Response.AbonentList.Count = 0 then
      Writeln(' - No abonents returned in the response')
    else
      for Abonent in Response.AbonentList do
      begin
        ChannelsText := string.Join(', ', Abonent.Channels.ToStringArray);
        if ChannelsText.IsEmpty then
          ChannelsText := '(no channels)';

        Writeln(Format(' - %s (%s)', [Abonent.Name, Abonent.Abid]));
        Writeln(Format('   Caption: %s', [Abonent.Caption]));
        Writeln('   Channels: ' + ChannelsText);
      end;
    Writeln('-----------------------------------------------------------------');
    Readln;
  finally
    Request.Free;
    Response.Free;
  end;
end;

begin
  try
    HttpClient.Addr := '213.167.42.170';
    HttpClient.Port := 8088;

    //ExecuteRequest;
    TestAbonentListRequest;
  except
    on E: Exception do
      Writeln(E.ClassName + ': ' + E.Message);
  end;
end.
