unit MainModule;

interface

uses
  uniGUIMainModule;

type
  TUniMainModule = class(TUniGUIMainModule)
  private
    FCompID: string;
    FDeptID: string;
  public
    property CompID: string read FCompID write FCompID;
    property DeptID: string read FDeptID write FDeptID;
  end;

function UniMainModule: TUniMainModule;

implementation

{$R *.dfm}

uses
  UniGUIVars, uniGUIApplication;

function UniMainModule: TUniMainModule;
begin
  Result := TUniMainModule(UniApplication.UniMainModule)
end;

initialization
  RegisterMainModuleClass(TUniMainModule);
end.
