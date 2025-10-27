unit TaskSourceUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  EntityUnit;

type
  // TTaskSource .
  TTaskSource = class(TEntity)
  private
    FStationIndex: string;
    function GetSid: string;
    procedure SetSid(const Value: string);
  protected
    ///
    function GetIdKey: string; override;
  public
    function Assign(ASource: TFieldSet): boolean; override;

    //      .   -
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    //
    property Sid: string read GetSid write SetSid;
    property StationIndex: string read FStationIndex write FStationIndex;
  end;

type
  ///
  TTaskSourceList = class(TEntityList)
    ///
    ///     ,
    class function ItemClassType: TEntityClass; override;
  end;

implementation

uses
  System.SysUtils,
  FuncUnit;

const
  SidKey = 'sid';
  IndexKey = 'index';

{ TTaskSource }

function TTaskSource.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;

  if not inherited Assign(ASource) then
    exit;

  if not (ASource is TTaskSource) then
    exit;

  var src := ASource as TTaskSource;

  StationIndex := src.StationIndex;

  Result := true;
end;

function TTaskSource.GetIdKey: string;
begin
  Result := SidKey;
end;

function TTaskSource.GetSid: string;
begin
  Result := Id;
end;

procedure TTaskSource.SetSid(const Value: string);
begin
  Id := Value;
end;

procedure TTaskSource.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Parse(src, APropertyNames);

  StationIndex := GetValueStrDef(src, IndexKey, '');
end;

procedure TTaskSource.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited Serialize(dst, APropertyNames);

  dst.AddPair(IndexKey, StationIndex);
end;

{ TTaskSourceList }

class function TTaskSourceList.ItemClassType: TEntityClass;
begin
  Result := TTaskSource;
end;

end.
