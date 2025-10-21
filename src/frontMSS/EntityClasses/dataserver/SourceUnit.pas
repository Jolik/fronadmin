unit SourceUnit;

interface

uses
  System.JSON,
  EntityUnit;

type
  /// <summary>
  ///   Dataserver source entity.
  /// </summary>
  TSource = class(TEntity)
  private
    function GetSid: string;
    procedure SetSid(const Value: string);
  protected
    function GetIdKey: string; override;
  public
    property Sid: string read GetSid write SetSid;
  end;

  /// <summary>
  ///   Collection of dataserver sources.
  /// </summary>
  TSourceList = class(TEntityList)
  public
    class function ItemClassType: TEntityClass; override;
  end;

implementation

const
  SidKey = 'sid';

function TSource.GetIdKey: string;
begin
  Result := SidKey;
end;

function TSource.GetSid: string;
begin
  Result := Id;
end;

procedure TSource.SetSid(const Value: string);
begin
  Id := Value;
end;

class function TSourceList.ItemClassType: TEntityClass;
begin
  Result := TSource;
end;

end.
