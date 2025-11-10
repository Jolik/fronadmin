unit ProfileUnit;

interface

uses
  System.SysUtils, System.JSON, System.Generics.Collections,
  EntityUnit,
  StringListUnit,
  ProfileRuleUnit,
  StringUnit;

type
  /// <summary>
  ///   Настройки воспроизведения профиля маршрутизатора.
  /// </summary>                                                                                                          и
  TProfilePlay = class(TFieldSet)
  private
    FFta: TStringArray;
  public
    constructor Create; overload; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property FTA: TStringArray read FFta;
  end;

  /// <summary>
  ///   Представляет тело профиля маршрутизатора.
  /// </summary>
  TProfileBody = class(TBody)
  private
    FRule: TProfileRule;
    FPlay: TProfilePlay;
  public
    constructor Create; overload; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Rule: TProfileRule read FRule;
    property Play: TProfilePlay read FPlay;
  end;

  /// <summary>
  ///   Профиль маршрутизатора.
  /// </summary>
  TProfile = class(TEntity)
  private
    FDescription: string;
    FIsNew: boolean;
    function GetProfileBody: TProfileBody;
  protected
    function GetIdKey: string; override;
    class function BodyClassType: TBodyClass; override;
  public
    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Description: string read FDescription write FDescription;
    property ProfileBody: TProfileBody read GetProfileBody;

    // IsNew флаг для внутрифронтового использования
    // означает что этого профиля ешё нет в ACL
    property IsNew: boolean read FIsNew write FIsNew;
  end;

  /// <summary>
  ///   Список профилей маршрутизатора.
  /// </summary>
  TProfileList = class(TEntityList)
  public
    class function ItemClassType: TEntityClass; override;
  end;

implementation

uses
  FuncUnit, loggingUnit;

const
  RuleKey = 'rule';
  PlayKey = 'play';
  FtaKey = 'fta';
  DescriptionKey = 'descr';
  ProfileIdKey = 'prid';

{ TProfilePlay }

function TProfilePlay.Assign(ASource: TFieldSet): boolean;
var
  SourcePlay: TProfilePlay;
begin
  Result := False;

  if not Assigned(ASource) then
    Exit;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TProfilePlay) then
    Exit;

  SourcePlay := TProfilePlay(ASource);

  if Assigned(FFta) then
  begin
    FFta.Clear;
    FFta.Parse(SourcePlay.FTA.Serialize)
  end;

  Result := True;
end;

constructor TProfilePlay.Create;
begin
  inherited Create;
  FFta := TStringArray.Create;
end;

destructor TProfilePlay.Destroy;
begin
  FFta.Free;
  inherited;
end;

procedure TProfilePlay.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  Value: TJSONValue;
begin
  if Assigned(FFta) then
    FFta.Clear;

  if not Assigned(src) then
    Exit;

  Value := src.FindValue(FtaKey);
  if (Value is TJSONArray) and Assigned(FFta) then
    FFta.Parse(TJSONArray(Value));
end;

procedure TProfilePlay.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then
    Exit;

  var jArr := TJSONArray.Create;

  if Assigned(FFta) then
    FFta.Serialize(jArr);

  dst.AddPair(FtaKey, jArr);
end;

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

  FRule := TProfileRule.Create;
  FPlay := TProfilePlay.Create;
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

  FDescription := SourceProfile.Description;
  FIsNew := SourceProfile.IsNew;

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

  FDescription := GetValueStrDef(src, DescriptionKey, '');
end;

procedure TProfile.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Serialize(dst, APropertyNames);

  dst.AddPair(DescriptionKey, FDescription);
end;

{ TProfileList }

class function TProfileList.ItemClassType: TEntityClass;
begin
  Result := TProfile;
end;

end.
