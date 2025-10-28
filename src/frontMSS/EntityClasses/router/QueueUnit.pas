unit QueueUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  FilterUnit,
  EntityUnit;

type
  // TQueue ��������� �������. �������� � �������
  TQueue = class (TEntity)
  private
    FAllowPut: boolean;
    FUid: string;
    FDoubles: boolean;
    FFilters: TQueueFilterList;
    function GetQid: string;
    procedure SetQid(const Value: string);

  protected
    ///  ������� ������ ������� ��� ���� ��� ��������������
    function GetIdKey: string; override;

  public
    constructor Create; override;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): boolean; override;

    // ��� ������� ������������� ����������� ���������� �������. �� ������ - �������
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property Qid: string read GetQid write SetQid;
    property AllowPut: boolean read FAllowPut write FAllowPut;
    property Uid: string read FUid write FUid;
    property Doubles: boolean read FDoubles write FDoubles;
    property Filters: TQueueFilterList read FFilters write FFilters;
  end;


  ///  ������ �����
  TQueueList = class (TEntityList)
    ///  ����� ���������� ���������� ��� ������� �������� ������
    ///  ������� ������ �������������� ���, ������ ��� �� � ���� ������
    class function ItemClassType: TEntityClass; override;

  end;

implementation

uses
  System.SysUtils,
  FuncUnit;

const
  QidKey = 'qid';
  UidKey = 'uid';

{ TQueue }

function TQueue.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;

  if not inherited Assign(ASource) then
    exit;

  if not (ASource is TQueue) then
    exit;

  var src := ASource as TQueue;

  AllowPut := src.AllowPut;
  Uid := src.Uid;
  Doubles := src.Doubles;
  FFilters.Assign(src.Filters);
  Result := true;
end;

function TQueue.GetQid: string;
begin
  Result := Id;
end;

procedure TQueue.SetQid(const Value: string);
begin
  Id := Value;
end;

constructor TQueue.Create;
begin
  inherited;
  FFilters := TQueueFilterList.Create;
end;

destructor TQueue.Destroy;
begin
  FFilters.Free;
  inherited;
end;

///  ����� ���������� ������������ ����� �������������� ������� ������������
///  ��� ������ �������� (� ������� �� ����� ���� ����)
function TQueue.GetIdKey: string;
begin
  ///  ��� ���� �������������� Lid
  Result := QidKey;
end;

procedure TQueue.Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil);
begin
  inherited Parse(src);

  Uid := GetValueStrDef(src, UidKey, '');
  AllowPut := GetValueBool(src, 'allow_put');
  Doubles := GetValueBool(src, 'doubles');

  var f := src.FindValue('filters');
  if not (f is TJSONArray) then
    exit;
  FFilters.ParseList((f as TJSONArray));
end;

procedure TQueue.Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil);

begin
  inherited Serialize(dst);

  dst.AddPair(UidKey, Uid);
  dst.AddPair('allow_put', AllowPut);
  dst.AddPair('doubles', Doubles);

  var f := TJSONArray.Create;
  FFilters.SerializeList(f);
  dst.AddPair('filters', f);
end;

{ TQueueList }

class function TQueueList.ItemClassType: TEntityClass;
begin
  Result := TQueue;
end;

end.
