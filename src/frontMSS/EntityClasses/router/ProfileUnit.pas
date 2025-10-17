unit ProfileUnit;

interface

uses
  System.SysUtils, System.JSON,
  EntityUnit,
  SmallRuleUnit,
  StringUnit;

type
  /// <summary>
  ///   Представляет тело профиля маршрутизатора.
  /// </summary>
  TProfileBody = class(TBody)
  private
    FRule: TSmallRule;
    FPlay: TNamedStringListsObject;
  public
    constructor Create; overload; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Rule: TSmallRule read FRule;
    property Play: TNamedStringListsObject read FPlay;
  end;

  /// <summary>
  ///   Профиль маршрутизатора.
  /// </summary>
  TProfile = class(TEntity)
  private
    FOwner: string;
    FDescription: string;
    function GetProfileBody: TProfileBody;
  protected
    function GetIdKey: string; override;
    class function BodyClassType: TBodyClass; override;
  public
    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Owner: string read FOwner write FOwner;
    property Description: string read FDescription write FDescription;
    property ProfileBody: TProfileBody read GetProfileBody;
  end;

implementation

uses
  FuncUnit;

const
  RuleKey = 'rule';
  PlayKey = 'play';
  OwnerKey = 'owner';
  DescriptionKey = 'descr';
  ProfileIdKey = 'prid';

{ TProfileBody }

function TProfileBody.Assign(ASource: TFieldSet): boolean;
begin
  Result := False;

  if not Assigned(ASource) then
    Exit;

  if not (ASource is TProfileBody) then
    Exit;

  if Assigned(FRule) then
  begin
    if not FRule.Assign(TProfileBody(ASource).Rule) then
      Exit;
  end;

  if Assigned(FPlay) then
  begin
    if not FPlay.Assign(TProfileBody(ASource).Play) then
      Exit;
  end;

  Result := True;
end;

constructor TProfileBody.Create;
begin
  inherited Create;

  FRule := TSmallRule.Create;
  FPlay := TNamedStringListsObject.Create;
end;

destructor TProfileBody.Destroy;
begin
  FPlay.Free;
  FRule.Free;

  inherited;
end;

procedure TProfileBody.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  Value: TJSONValue;
begin
  if Assigned(FRule) then
    FRule.Parse(nil);

  if Assigned(FPlay) then
    FPlay.Parse(nil);

  if not Assigned(src) then
    Exit;

  Value := src.FindValue(RuleKey);
  if (Value is TJSONObject) and Assigned(FRule) then
    FRule.Parse(TJSONObject(Value));

  Value := src.FindValue(PlayKey);
  if (Value is TJSONObject) and Assigned(FPlay) then
    FPlay.Parse(TJSONObject(Value));
end;

procedure TProfileBody.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  RuleObject: TJSONObject;
  PlayObject: TJSONObject;
begin
  if not Assigned(dst) then
    Exit;

  RuleObject := nil;
  if Assigned(FRule) then
    RuleObject := FRule.Serialize();

  if Assigned(RuleObject) then
    dst.AddPair(RuleKey, RuleObject)
  else
    dst.AddPair(RuleKey, TJSONObject.Create);

  PlayObject := TJSONObject.Create;
  try
    if Assigned(FPlay) then
      FPlay.Serialize(PlayObject);

    dst.AddPair(PlayKey, PlayObject);
  except
    PlayObject.Free;
    raise;
  end;
end;

{ TProfile }

function TProfile.Assign(ASource: TFieldSet): boolean;
var
  SourceProfile: TProfile;
begin
  Result := False;

  if not Assigned(ASource) then
    Exit;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TProfile) then
    Exit;

  SourceProfile := TProfile(ASource);

  FOwner := SourceProfile.Owner;
  FDescription := SourceProfile.Description;

  Result := True;
end;

class function TProfile.BodyClassType: TBodyClass;
begin
  Result := TProfileBody;
end;

function TProfile.GetIdKey: string;
begin
  Result := ProfileIdKey;
end;

function TProfile.GetProfileBody: TProfileBody;
begin
  if Body is TProfileBody then
    Result := TProfileBody(Body)
  else
    Result := nil;
end;

procedure TProfile.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Parse(src, APropertyNames);

  FOwner := GetValueStrDef(src, OwnerKey, '');
  FDescription := GetValueStrDef(src, DescriptionKey, '');
end;

procedure TProfile.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Serialize(dst, APropertyNames);

  dst.AddPair(OwnerKey, FOwner);
  dst.AddPair(DescriptionKey, FDescription);
end;

end.
