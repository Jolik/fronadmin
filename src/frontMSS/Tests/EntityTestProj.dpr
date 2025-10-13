program EntityTestProj;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DataserverAPIUnit in 'DataserverAPIUnit.pas';

var
  DataserverAPI: TDataServerApi;
  Body, Response: string;

begin
  DataserverAPI := TDataServerApi.Create('http://dcc5.modext.ru:8088/dataserver');

  try
    try
      // ����� ������� GET sources/list � ����������� ���������
      Response := DataserverAPI.GetSourcesList(1, 1);
      Writeln(Response);

      // ����� ������� POST sources/list � �������� �� sid
      Body := '{"sid": ["9999-012345-0017"]}';
      Response := DataserverAPI.PostSourcesList(0, 0, Body);
      Writeln(Response);

      // �������� ������� ���������� �� ������� Enter
      Writeln('press enter to finish...');
      Readln;

    except
      on E: Exception do
        Writeln(E.ClassName, ': ', E.Message);
    end;

  finally
    FreeAndNil(DataserverAPI);
  end;
end.
