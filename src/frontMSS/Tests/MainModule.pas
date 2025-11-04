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
  Result := TUniMainModule(UniApplication.UniMainModule);
  Result.CompID := '85697f9f-b80d-4668-8ed2-2f70ed825eee';
  Result.DeptID := '00000000-0000-0000-0000-000000000000';
  Result.EnableSynchronousOperations := true;
end;

initialization
  RegisterMainModuleClass(TUniMainModule);
end.
