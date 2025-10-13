program EntityTestProj;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

begin
  try

  ///  делаем запрос
  ///
  ///  выводим в консоль ответ
  ///
  ///
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
