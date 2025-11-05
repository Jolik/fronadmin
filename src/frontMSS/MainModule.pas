unit MainModule;

interface

uses
  System.Generics.Collections,
  uniGUIMainModule,
  OrganizationUnit,
  ContextTypeUnit,
  LocationUnit;

type
  TUniMainModule = class(TUniGUIMainModule)
  private
    FCompID: string;
    FDeptID: string;
    FXTicket: string;
    FOrganizationsCache: TObjectList<TOrganization>;
    FOrganizationsTypesCache: TObjectList<TOrgType>;
    FLocationsCache: TObjectList<TLocation>;
    FContextTypesCache: TObjectList<TContextType>;

  public
    procedure AfterConstruction; override;
    destructor Destroy; override;

    property CompID: string read FCompID write FCompID;
    property DeptID: string read FDeptID write FDeptID;
    property XTicket: string read FXTicket write FXTicket;

    procedure AssignOrganizationsTo(Dest: TObjectList<TOrganization>);
    procedure UpdateOrganizationsCache(Src: TObjectList<TOrganization>);

    procedure AssignOrgTypesTo(Dest: TObjectList<TOrgType>);
    procedure UpdateOrgTypesCache(Src: TObjectList<TOrgType>);


    procedure AssignLocationsTo(Dest: TObjectList<TLocation>);
    procedure UpdateLocationsCache(Src: TObjectList<TLocation>);

    procedure AssignContextTypesTo(Dest: TObjectList<TContextType>);
    procedure UpdateContextTypesCache(Src: TObjectList<TContextType>);
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

procedure TUniMainModule.AfterConstruction;
begin
  inherited;
  FOrganizationsCache := TObjectList<TOrganization>.Create(True);
  FLocationsCache := TObjectList<TLocation>.Create(True);
  FOrganizationsTypesCache:= TObjectList<TOrgType>.Create(true);
  FContextTypesCache:= TObjectList<TContextType>.Create(true);
end;

procedure TUniMainModule.AssignContextTypesTo(Dest: TObjectList<TContextType>);
begin
   if not Assigned(Dest) then Exit;
  if not Assigned(FContextTypesCache) then Exit;
  Dest.AddRange(FContextTypesCache);
end;

procedure TUniMainModule.AssignLocationsTo(Dest: TObjectList<TLocation>);
begin
  if not Assigned(Dest) then Exit;
  if not Assigned(FLocationsCache) then Exit;
  Dest.AddRange(FLocationsCache);
end;

procedure TUniMainModule.AssignOrganizationsTo(Dest: TObjectList<TOrganization>);
begin
  if not Assigned(Dest) then Exit;
  Dest.Clear;
  if not Assigned(FOrganizationsCache) then Exit;
  Dest.OwnsObjects:= false;
  Dest.AddRange(FOrganizationsCache);

end;

procedure TUniMainModule.AssignOrgTypesTo(Dest: TObjectList<TOrgType>);
begin
    if not Assigned(Dest) then Exit;
  Dest.Clear;
  if not Assigned(FOrganizationsTypesCache) then Exit;
  Dest.OwnsObjects:= false;
  Dest.AddRange(FOrganizationsTypesCache);
end;

destructor TUniMainModule.Destroy;
begin
  FLocationsCache.Free;
  FOrganizationsCache.Free;
  FOrganizationsTypesCache.Free;
  inherited;
end;

procedure TUniMainModule.UpdateContextTypesCache(Src: TObjectList<TContextType>);
begin
  if not Assigned(FContextTypesCache) then Exit;
  FContextTypesCache.Clear;
  if not Assigned(Src) then Exit;
  Src.OwnsObjects:= false;
  FContextTypesCache.AddRange(Src);
end;

procedure TUniMainModule.UpdateLocationsCache(Src: TObjectList<TLocation>);
var
  Loc: TLocation;
  Copy: TLocation;
begin
  if not Assigned(FLocationsCache) then Exit;
  FLocationsCache.Clear;
  if not Assigned(Src) then Exit;
  Src.OwnsObjects := false;
  FLocationsCache.AddRange(Src);
end;

procedure TUniMainModule.UpdateOrganizationsCache(Src: TObjectList<TOrganization>);
begin
  if not Assigned(FOrganizationsCache) then Exit;
  FOrganizationsCache.Clear;
  if not Assigned(Src) then Exit;
  Src.OwnsObjects:= false;
  FOrganizationsCache.AddRange(Src);
end;

procedure TUniMainModule.UpdateOrgTypesCache(Src: TObjectList<TOrgType>);
begin
  if not Assigned(FOrganizationsTypesCache) then Exit;
  FOrganizationsTypesCache.Clear;
  if not Assigned(Src) then Exit;
  Src.OwnsObjects:= false;
  FOrganizationsTypesCache.AddRange(Src);
end;

initialization
  RegisterMainModuleClass(TUniMainModule);
end.
