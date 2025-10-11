unit SummaryTaskUnit;

interface

uses
  System.Classes, System.SysUtils, System.JSON,
  EntityUnit;

type
  /// <summary>
  ///   Summary task entity representation.
  /// </summary>
  TSummaryTask = class(TEntity)
  private
    FModule: string;
    FSettings: TJSONObject;
    function GetSettingsObject: TJSONObject;
    function GetTid: string;
    procedure SetSettingsObject(const Value: TJSONObject);
    procedure SetTid(const Value: string);
  protected
    function GetIdKey: string; override;
  public
    constructor Create; reintroduce; overload;
    constructor Create(src: TJSONObject); reintroduce; overload;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): boolean; override;

    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Tid: string read GetTid write SetTid;
    property Module: string read FModule write FModule;
    property SettingsObject: TJSONObject read GetSettingsObject write SetSettingsObject;
  end;

  /// <summary>
  ///   Collection of summary tasks.
  /// </summary>
  TSummaryTaskList = class(TEntityList)
  end;

implementation

{ TSummaryTask }

function TSummaryTask.Assign(ASource: TFieldSet): boolean;
var
  LSource: TSummaryTask;
begin
  Result := false;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TSummaryTask) then
    Exit;

  LSource := ASource as TSummaryTask;

  Module := LSource.Module;
  SettingsObject := LSource.SettingsObject;

  Result := true;
end;

constructor TSummaryTask.Create;
begin
  inherited Create;
  FSettings := TJSONObject.Create;
end;

constructor TSummaryTask.Create(src: TJSONObject);
begin
  Create;
  Parse(src);
end;

destructor TSummaryTask.Destroy;
begin
  FreeAndNil(FSettings);
  inherited;
end;

function TSummaryTask.GetIdKey: string;
begin
  Result := 'tid';
end;

function TSummaryTask.GetSettingsObject: TJSONObject;
begin
  if FSettings = nil then
    FSettings := TJSONObject.Create;
  Result := FSettings;
end;

function TSummaryTask.GetTid: string;
begin
  Result := Id;
end;

procedure TSummaryTask.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  SettingsValue: TJSONValue;
begin
  inherited Parse(src, APropertyNames);

  Module := GetValueStrDef(src, 'module', '');

  SettingsValue := src.FindValue('settings');
  if (SettingsValue <> nil) and (SettingsValue is TJSONObject) then
    SettingsObject := SettingsValue as TJSONObject
  else
    SettingsObject := nil;
end;

procedure TSummaryTask.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  SettingsCopy: TJSONObject;
begin
  if dst = nil then
    Exit;

  if Tid <> '' then
    dst.AddPair('tid', Tid);

  if Name <> '' then
    dst.AddPair('name', Name);

  if Def <> '' then
    dst.AddPair('def', Def);

  if Module <> '' then
    dst.AddPair('module', Module);

  if CompId <> '' then
    dst.AddPair('compid', CompId);

  if DepId <> '' then
    dst.AddPair('depid', DepId);

  dst.AddPair('enabled', TJSONBool.Create(Enabled));

  if Caption <> '' then
    dst.AddPair('caption', Caption);

  SettingsCopy := nil;
  try
    if FSettings <> nil then
      SettingsCopy := FSettings.Clone as TJSONObject
    else
      SettingsCopy := TJSONObject.Create;
    dst.AddPair('settings', SettingsCopy);
    SettingsCopy := nil;
  finally
    SettingsCopy.Free;
  end;
end;

procedure TSummaryTask.SetSettingsObject(const Value: TJSONObject);
var
  NewObject: TJSONObject;
begin
  if Value <> nil then
    NewObject := Value.Clone as TJSONObject
  else
    NewObject := TJSONObject.Create;

  FreeAndNil(FSettings);
  FSettings := NewObject;
end;

procedure TSummaryTask.SetTid(const Value: string);
begin
  Id := Value;
end;

end.
