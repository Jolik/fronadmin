unit RuleUnit;

interface

uses
  System.JSON,
  EntityUnit,
  SmallRuleUnit;

type
  /// <summary>
  ///   Represents a router rule entity.
  /// </summary>
  TRule = class(TEntity)
  private
    FRule: TSmallRule;
    function GetRuid: string;
    procedure SetRuid(const Value: string);
  protected
    function GetIdKey: string; override;
  public
    constructor Create; overload; override;
    constructor Create(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): boolean; override;

    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Ruid: string read GetRuid write SetRuid;
    property Rule: TSmallRule read FRule;
  end;

  TRuleList = class(TEntityList)
  public
    class function ItemClassType: TEntityClass; override;
  end;

implementation

const
  RuidKey = 'ruid';
  RuleKey = 'rule';

{ TRule }

function TRule.Assign(ASource: TFieldSet): boolean;
var
  SourceRule: TRule;
begin
  Result := False;

  if not Assigned(ASource) then
    Exit;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TRule) then
    Exit;

  SourceRule := TRule(ASource);

  if not Assigned(FRule) then
    FRule := TSmallRule.Create;

  Result := FRule.Assign(SourceRule.Rule);
end;

constructor TRule.Create;
begin
  inherited Create;

  FRule := TSmallRule.Create;
end;

constructor TRule.Create(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  Create;

  Parse(src, APropertyNames);
end;

destructor TRule.Destroy;
begin
  FRule.Free;

  inherited;
end;

function TRule.GetIdKey: string;
begin
  Result := RuidKey;
end;

function TRule.GetRuid: string;
begin
  Result := Id;
end;

procedure TRule.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
var
  RuleValue: TJSONValue;
begin
  inherited Parse(src, APropertyNames);

  RuleValue := nil;
  if Assigned(src) then
    RuleValue := src.FindValue(RuleKey);

  if RuleValue is TJSONObject then
    FRule.Parse(TJSONObject(RuleValue))
  else
    FRule.Parse(nil);
end;

procedure TRule.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
var
  RuleObject: TJSONObject;
begin
  inherited Serialize(dst, APropertyNames);

  if Assigned(FRule) then
  begin
    RuleObject := FRule.Serialize();
    if Assigned(RuleObject) then
      dst.AddPair(RuleKey, RuleObject)
    else
      dst.AddPair(RuleKey, TJSONObject.Create);
  end
  else
    dst.AddPair(RuleKey, TJSONObject.Create);
end;

procedure TRule.SetRuid(const Value: string);
begin
  Id := Value;
end;

{ TRuleList }

class function TRuleList.ItemClassType: TEntityClass;
begin
  Result := TRule;
end;

end.
