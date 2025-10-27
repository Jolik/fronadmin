unit ServerModule;

interface

uses
  Classes, SysUtils, uniGUIServer, uniGUIMainModule, uniGUIApplication, uIdCustomHTTPServer,
  uniGUITypes, uIdContext;

type
  TUniServerModule = class(TUniGUIServerModule)
  private
    { Private declarations }
  protected
    procedure FirstInit; override;
  public
    { Public declarations }
  end;

function UniServerModule: TUniServerModule;

implementation

{$R *.dfm}

uses
  uniGUIVars;

function UniServerModule: TUniServerModule;
begin
  Result := TUniServerModule(UniGUIServerInstance);
  Result.SetTcpPort(8080);
end;

procedure TUniServerModule.FirstInit;
begin
  Self.Title := 'ЦСДН коммутация';
  InitServerModule(Self);
end;

initialization
  RegisterServerModuleClass(TUniServerModule);
end.
