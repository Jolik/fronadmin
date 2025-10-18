program EntityTestProj;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.JSON,
  System.DateUtils,
  IdURI,
  APIConst in '..\APIClasses\APIConst.pas',
  EntityBrokerUnit in '..\APIClasses\EntityBrokerUnit.pas',
  AliasesBrokerUnit in '..\APIClasses\AliasesBrokerUnit.pas',
  LoggingUnit in '..\Logging\LoggingUnit.pas',
  TextFileLoggerUnit in '..\Logging\TextFileLoggerUnit.pas',
  ConstsUnit in '..\Common\ConstsUnit.pas',
  FuncUnit in '..\Common\FuncUnit.pas',
  EntityUnit in '..\EntityClasses\Common\EntityUnit.pas',
  AbonentUnit in '..\EntityClasses\router\AbonentUnit.pas',
  AliasUnit in '..\EntityClasses\router\AliasUnit.pas',
  StringUnit in '..\EntityClasses\Common\StringUnit.pas',
  MainHttpModuleUnit in '..\APIClasses\MainHttpModuleUnit.pas',
  GUIDListUnit in '..\EntityClasses\Common\GUIDListUnit.pas',
  AbonentsBrokerUnit in '..\APIClasses\AbonentsBrokerUnit.pas';

procedure ListAliases();
var
  AliasesBroker: TAliasesBroker;
  AliasList: TEntityList;
  AliasEntity: TEntity;
  PageCount: Integer;
begin
  try
    AliasesBroker := TAliasesBroker.Create;
    try
      AliasList := nil;
      try
        AliasList := AliasesBroker.List(PageCount);

        Writeln('---------- Aliases List ----------');

        if Assigned(AliasList) then
        begin
          var FirstAlias: TAlias := nil;

          if AliasList.Count > 0 then
            FirstAlias := AliasList.Items[0] as TAlias;

          for AliasEntity in AliasList do
          begin
            var Alias := AliasEntity as TAlias;
            Writeln(Format('Class: %s | Address: %p', [Alias.ClassName, Pointer(Alias)]));
            Writeln('Alid: ' + Alias.Alid);
            Writeln('Name: ' + Alias.Name);
            Writeln('Caption: ' + Alias.Caption);
//            Writeln('Channels count: ' + IntToStr(Alias.Channels.Count));

            Writeln('As JSON:');
            var Json := Alias.Serialize();
            try
              if Json <> nil then
                Writeln(Json.Format);
            finally
              Json.Free;
            end;

            Writeln('----------');
          end;

          if Assigned(FirstAlias) then
          begin
            Writeln('---------- Alias Info ----------');
            Writeln('Requesting info for: ' + FirstAlias.Alid);

            var InfoEntity: TEntity := nil;
            try
              InfoEntity := AliasesBroker.Info(FirstAlias.Alid);

              if Assigned(InfoEntity) then
              begin
                var InfoAlias := InfoEntity as TAlias;
                Writeln('Info result as JSON:');
                var InfoJson := InfoAlias.Serialize();
                try
                  if InfoJson <> nil then
                    Writeln(InfoJson.Format);
                finally
                  InfoJson.Free;
                end;
              end
              else
                Writeln('Info request returned nil.');
            finally
              InfoEntity.Free;
            end;
            Writeln('----------');
          end;
        end
        else
          Writeln('Aliases list is empty.');

      finally
        AliasList.Free;
      end;
    finally
      AliasesBroker.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;

procedure ListAbonents();
var
  AbonentsBroker: TAbonentsBroker;
  AbonentList: TEntityList;
  AbonentEntity: TEntity;
  PageCount: Integer;
begin
  try
    AbonentsBroker := TAbonentsBroker.Create;
    try
      AbonentList := nil;
      try
        AbonentList := AbonentsBroker.List(PageCount);

        Writeln('---------- Abonents List ----------');

        if Assigned(AbonentList) then
        begin
          var FirstAbonent: TAbonent := nil;

          if AbonentList.Count > 0 then
            FirstAbonent := AbonentList.Items[0] as TAbonent;

          for AbonentEntity in AbonentList do
          begin
            var Abonent := AbonentEntity as TAbonent;
            Writeln(Format('Class: %s | Address: %p', [Abonent.ClassName, Pointer(Abonent)]));
            Writeln('Abid: ' + Abonent.Abid);
            Writeln('Name: ' + Abonent.Name);
            Writeln('Caption: ' + Abonent.Caption);
            Writeln('Channels count: ' + IntToStr(Abonent.Channels.Count));
            Writeln('Attr pairs count: ' + IntToStr(Abonent.Attr.Count));

            Writeln('As JSON:');
            var Json := Abonent.Serialize();
            try
              if Json <> nil then
                Writeln(Json.Format);
            finally
              Json.Free;
            end;

            Writeln('----------');
          end;

          if Assigned(FirstAbonent) then
          begin
            Writeln('---------- Abonent Info ----------');
            Writeln('Requesting info for: ' + FirstAbonent.Abid);

            var InfoEntity: TEntity := nil;
            try
              InfoEntity := AbonentsBroker.Info(FirstAbonent.Abid);

              if Assigned(InfoEntity) then
              begin
                var InfoAbonent := InfoEntity as TAbonent;
                Writeln('Info result as JSON:');
                var InfoJson := InfoAbonent.Serialize();
                try
                  if InfoJson <> nil then
                    Writeln(InfoJson.Format);
                finally
                  InfoJson.Free;
                end;
              end
              else
                Writeln('Info request returned nil.');
            finally
              InfoEntity.Free;
            end;
            Writeln('----------');
          end;
        end
        else
          Writeln('Abonents list is empty.');

      finally
        AbonentList.Free;
      end;
    finally
      AbonentsBroker.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;



begin
  try
    try
      ListAbonents();
      ListAliases();

      // keep the console open until Enter is pressed
      Writeln('press enter to finish...');
      Readln;

    except
      on E: Exception do
        Writeln(E.ClassName, ': ', E.Message);
    end;

  finally
  end;
end.
