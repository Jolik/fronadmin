unit RouterSourceUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  EntityUnit;

type
  // TRouterSource .
  TRouterSource = class (TEntity)
  private
    FSvcId: string;
    FLid: string;
    function GetWho: string;
    procedure SetWho(const Value: string);
  protected
    ///
    function GetIdKey: string; override;
  public
    function Assign(ASource: TFieldSet): boolean; override;

    //      .   -
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    //
    property Who: string read GetWho write SetWho;
    property SvcId: string read FSvcId write FSvcId;
    property Lid: string read FLid write FLid;
  end;

type
  ///
  TRouterSourceList = class (TEntityList)
    ///
    ///     ,
    class function ItemClassType: TEntityClass; override;

  end;

implementation

uses
  System.SysUtils,
  FuncUnit;

const
  WhoKey = 'who';
  SvcIdKey = 'svcid';
  LidKey = 'lid';

{ TRouterSource }

function TRouterSource.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;

  if not inherited Assign(ASource) then
    exit;

  if not (ASource is TRouterSource) then
    exit;

  var src := ASource as TRouterSource;

  SvcId := src.SvcId;
  Lid := src.Lid;

  Result := true;
end;

function TRouterSource.GetIdKey: string;
begin
  Result := WhoKey;
end;

function TRouterSource.GetWho: string;
begin
  Result := Id;
end;

procedure TRouterSource.SetWho(const Value: string);
begin
  Id := Value;
end;

procedure TRouterSource.Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil);
begin
  inherited Parse(src, APropertyNames);

  SvcId := GetValueStrDef(src, SvcIdKey, '');
  Lid := GetValueStrDef(src, LidKey, '');
end;

procedure TRouterSource.Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil);
begin
  inherited Serialize(dst, APropertyNames);

  dst.AddPair(SvcIdKey, SvcId);
  dst.AddPair(LidKey, Lid);
end;

{ TRouterSourceList }

class function TRouterSourceList.ItemClassType: TEntityClass;
begin
  Result := TRouterSource;
end;

end.
