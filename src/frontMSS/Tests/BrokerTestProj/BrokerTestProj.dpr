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
  AbonentUnit in '..\..\EntityClasses\router\AbonentUnit.pas',
  StringListUnit in '..\..\EntityClasses\Common\StringListUnit.pas',
  StringUnit in '..\..\EntityClasses\Common\StringUnit.pas';

procedure ExecuteRequest;
var
  ListRequest: TAbonentReqList;
  ListResponse: TAbonentListResponse;
  InfoRequest: THttpRequest;
  InfoResponse: TAbonentInfoResponse;
  NewRequest: TAbonentReqNew;
  NewResponse: TAbonentNewResponse;
  StatusCode: Integer;
  Abonent: TAbonent;
  ChannelsText: string;
  NewAbonentId: string;
begin
  ListRequest := TAbonentReqList.Create;
  ListResponse := TAbonentListResponse.Create;
  InfoRequest := THttpRequest.Create;
  InfoResponse := TAbonentInfoResponse.Create;
  NewRequest := TAbonentReqNew.Create;
  NewResponse := TAbonentNewResponse.Create;
  try
    // Compose and send a sample request that demonstrates abonent creation through the broker.
    NewRequest.Headers.AddOrSetValue('X-Ticket', 'ST-Test');

    if Assigned(NewRequest.Body) then
    begin
      NewAbonentId := TGUID.NewGuid.ToString.Replace('{', '').Replace('}', '');

      with NewRequest.Body.Abonent do
      begin
        Abid := NewAbonentId;
        Name := 'AutoTest_' + Copy(NewAbonentId, 1, 8);
        Caption := 'Automatically created abonent for broker demo';

        Channels.ClearStrings;
        Channels.AddString('lch1');
        Channels.AddString('mitra');

        Attr.Clear;
        Attr.SetValue('name', 'TTAAii');
        Attr.SetValue('email', Format('first+%s@sample.com', [Copy(NewAbonentId, 1, 4)]));
      end;

      NewRequest.Body.UpdateRawContent;
    end;

    StatusCode := HttpClient.Request(NewRequest, NewResponse);

    Writeln('-----------------------------------------------------------------');
    Writeln('Create request URL: ' + NewRequest.GetURLWithParams);
    Writeln(Format('Create request body: %s', [NewRequest.ReqBodyContent]));
    Writeln(Format('Create response (HTTP %d):', [StatusCode]));
    if Assigned(NewResponse.AbonentNewRes) and not NewResponse.AbonentNewRes.Abid.IsEmpty then
      Writeln('Created abonent ID: ' + NewResponse.AbonentNewRes.Abid)
    else
      Writeln('Abonent identifier was not returned in the response.');

    // Authorize list request with a test ticket used across broker integration tests.
    ListRequest.Headers.AddOrSetValue('X-Ticket', 'ST-Test');

    if Assigned(ListRequest.Body) then
      // Limit the number of returned abonents to keep the output concise for the sample run.
      ListRequest.Body.PageSize := 5;

    // Perform the initial request to retrieve a collection of abonents.
    StatusCode := HttpClient.Request(ListRequest, ListResponse);

    Writeln('-----------------------------------------------------------------');
    Writeln('List request URL: ' + ListRequest.GetURLWithParams);
    Writeln(Format('List request body: %s', [ListRequest.ReqBodyContent]));
    Writeln(Format('List response (HTTP %d):', [StatusCode]));
    Writeln(Format('Abonent records: %d', [ListResponse.AbonentList.Count]));

    if ListResponse.AbonentList.Count > 0 then
    begin
      Abonent := TAbonent(ListResponse.AbonentList[0]);
      // Display basic information from the list response before requesting details.
      Writeln(Format('First abonent: %s (%s)', [Abonent.Name, Abonent.Abid]));

      // Prepare a generic GET request that will be reused for the abonent info endpoint.
      InfoRequest.URL := '/router/api/v2/abonents';
      InfoRequest.Method := mGET;
      InfoRequest.Headers.AddOrSetValue('X-Ticket', 'ST-Test');
      InfoRequest.Headers.AddOrSetValue('Accept', 'application/json');
      // AddPath holds the abonent identifier required by the API route `/api/v2/abonents/:abid`.
      InfoRequest.AddPath := Abonent.Abid;

      // Execute the request to fetch detailed abonent information.
      StatusCode := HttpClient.Request(InfoRequest, InfoResponse);

      Writeln('-----------------------------------------------------------------');
      Writeln('Info request URL: ' + InfoRequest.GetURLWithParams);
      Writeln(Format('Info response (HTTP %d):', [StatusCode]));

      if Assigned(InfoResponse.Abonent) then
      begin
        // Compose a readable representation of channels returned for the abonent.
        ChannelsText := string.Join(', ', InfoResponse.Abonent.Channels.ToStringArray);
        if ChannelsText.IsEmpty then
          ChannelsText := '(no channels)';

        Writeln(Format('Abonent: %s (%s)', [InfoResponse.Abonent.Name, InfoResponse.Abonent.Abid]));
        Writeln('Caption: ' + InfoResponse.Abonent.Caption);
        // Print the resolved channel list so operators can verify provisioning information.
        Writeln('Channels: ' + ChannelsText);
      end
      else
        // Highlight that the response failed to include an abonent object, which often indicates
        // a missing or incorrect identifier.
        Writeln('Abonent details were not returned in the response.');
    end
    else
      // Provide actionable message when the list request yields no records.
      Writeln('No abonents returned in the list response.');

    Writeln('-----------------------------------------------------------------');
    Readln;
  finally
    NewResponse.Free;
    NewRequest.Free;
    InfoResponse.Free;
    InfoRequest.Free;
    ListResponse.Free;
    ListRequest.Free;
  end;
end;


procedure TestAbonentListRequest;
var
  Request: TAbonentReqList;
  Response: TAbonentListResponse;
  StatusCode: Integer;
  Abonent: TEntity;
  ChannelsText: string;
begin
  Request := TAbonentReqList.Create;
  Response := TAbonentListResponse.Create;
  try
    Request.Headers.AddOrSetValue('X-Ticket', 'ST-Test');

    if Assigned(Request.Body) then
      // Narrow down the request payload to fetch a manageable amount of abonents for display.
      Request.Body.PageSize := 5;

    // Send the request to the HTTP broker and collect the resulting abonent list.
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
        // Convert abonent channels to a comma separated list for readability in the console.
        ChannelsText := string.Join(', ', TAbonent(Abonent).Channels.ToStringArray);
        if ChannelsText.IsEmpty then
          ChannelsText := '(no channels)';

        Writeln(Format(' - %s (%s)', [Abonent.Name, TAbonent(Abonent).Abid]));
        Writeln(Format('   Caption: %s', [Abonent.Caption]));
        // Output the channels for each abonent retrieved in the list response.
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

    ExecuteRequest;
    //TestAbonentListRequest;
  except
    on E: Exception do
      Writeln(E.ClassName + ': ' + E.Message);
  end;
end.
