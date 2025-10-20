program BrokerTestProj;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  ConsoleAliasesBrokerUnit in 'ConsoleAliasesBrokerUnit.pas',
  AliasUnit in '..\..\EntityClasses\router\AliasUnit.pas',
  EntityUnit in '..\..\EntityClasses\Common\EntityUnit.pas',
  EntityBrokerUnit in '..\..\APIClasses\EntityBrokerUnit.pas',
  HttpRequestUnit in '..\..\APIClasses\HttpRequestUnit.pas',
  FuncUnit in '..\..\Common\FuncUnit.pas';

procedure ExecuteListRequest(Broker: TConsoleAliasesBroker; out AliasId: string);
var
  PageCount: Integer;
  Entities: TAliasList;
  AliasEntity: TAlias;
begin
  AliasId := '';
  Writeln('=== LIST REQUEST ===');
  Entities := TAliasList(Broker.List(PageCount));
  try
    if Assigned(Broker.LastRequest) then
      Writeln(Broker.LastRequest.Curl);
    if Assigned(Broker.LastResponse) then
      Writeln(Broker.LastResponse.Response);

    if Assigned(Entities) and (Entities.Count > 0) then
    begin
      AliasEntity := TAlias(Entities[0]);
      AliasId := AliasEntity.Id;
    end;
  finally
    Entities.Free;
  end;
end;

procedure ExecuteInfoRequest(Broker: TConsoleAliasesBroker; const AliasId: string);
var
  Entity: TAlias;
begin
  if AliasId = '' then
  begin
    Writeln('Alias identifier is not available. Skipping info request.');
    Exit;
  end;

  Writeln('=== INFO REQUEST ===');
  Entity := TAlias(Broker.Info(AliasId));
  try
    if Assigned(Broker.LastRequest) then
      Writeln(Broker.LastRequest.Curl);
    if Assigned(Broker.LastResponse) then
      Writeln(Broker.LastResponse.Response);

    if Assigned(Entity) then
      Writeln(Format('Alias %s loaded successfully.', [Entity.Id]));
  finally
    Entity.Free;
  end;
end;

var
  Broker: TConsoleAliasesBroker;
  AliasId: string;
begin
  ReportMemoryLeaksOnShutdown := True;
  Broker := TConsoleAliasesBroker.Create;
  try
    try
      ExecuteListRequest(Broker, AliasId);
      ExecuteInfoRequest(Broker, AliasId);
    except
      on E: Exception do
        Writeln('Error: ' + E.Message);
    end;
  finally
    Broker.Free;
  end;
end.

