program EntityTestProj;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.JSON,
  RouterSourceUnit,
  RouterSourceBrokerUnit,
  EntityUnit;

var
  RouterSourceBroker: TRouterSourceBroker;
  RouterSourceList: TEntityList;
  RouterSourceEntity: TEntity;
  PageCount: Integer;

begin
  try
    RouterSourceBroker := TRouterSourceBroker.Create;
    try
      RouterSourceList := nil;
      try
        RouterSourceList := RouterSourceBroker.List(PageCount);

        Writeln('---------- Router Sources List ----------');

        if Assigned(RouterSourceList) then
        begin
          for RouterSourceEntity in RouterSourceList do
          begin
            var Source := RouterSourceEntity as TRouterSource;
            Writeln(Format('Class: %s | Address: %p', [Source.ClassName, Pointer(Source)]));
            Writeln('Who: ' + Source.Who);
            Writeln('SvcId: ' + Source.SvcId);
            Writeln('Lid: ' + Source.Lid);

            Writeln('As JSON:');
            var Json := Source.Serialize();
            try
              if Json <> nil then
                Writeln(Json.Format);
            finally
              Json.Free;
            end;

            Writeln('----------');
          end;
        end
        else
          Writeln('Router source list is empty.');

      finally
        RouterSourceList.Free;
      end;
    finally
      RouterSourceBroker.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
