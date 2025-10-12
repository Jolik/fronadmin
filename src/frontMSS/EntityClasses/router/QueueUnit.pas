unit QueueUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  EntityUnit;

type
  // TQueue ��������� �������. �������� � �������
  TQueue = class (TEntity)
  private
    FAllowPut: boolean;
    FUid: string;
    FDoubles: boolean;
    function GetQid: string;
    procedure SetQid(const Value: string);

  protected
    ///  ������� ������ ������� ��� ���� ��� ��������������
    function GetIdKey: string; override;

  public
    function Assign(ASource: TFieldSet): boolean; override;

    // ��� ������� ������������� ����������� ���������� �������. �� ������ - �������
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    // ������������� �������
    property Qid: string read GetQid write SetQid;
    property AllowPut: boolean read FAllowPut write FAllowPut;
    property Uid: string read FUid write FUid;
    property Doubles: boolean read FDoubles write FDoubles;

  end;

type
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

  ///  ������ ���� Uid
  Uid := GetValueStrDef(src, UidKey, '');

end;

procedure TQueue.Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil);

begin
  inherited Serialize(dst);

  dst.AddPair(UidKey, Uid);
end;

{ TQueueList }

class function TQueueList.ItemClassType: TEntityClass;
begin
  Result := TQueue;
end;

end.
