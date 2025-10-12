unit QueueUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  EntityUnit;

type
  // TQueue настройки очереди. хранитс€ в роутере
  TQueue = class (TEntity)
  private
    FAllowPut: boolean;
    FUid: string;
    FDoubles: boolean;
    function GetQid: string;
    procedure SetQid(const Value: string);

  protected
    ///  потомок должен вернуть им€ пол€ дл€ идентификатора
    function GetIdKey: string; override;

  public
    function Assign(ASource: TFieldSet): boolean; override;

    // эти требуют существующего правильного экземпл€ра объекта. на ошибки - эксешан
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    // идентификатор очереди
    property Qid: string read GetQid write SetQid;
    property AllowPut: boolean read FAllowPut write FAllowPut;
    property Uid: string read FUid write FUid;
    property Doubles: boolean read FDoubles write FDoubles;

  end;

type
  ///  список задач
  TQueueList = class (TEntityList)
    ///  метод возвращает конкретный тип объекта элемента списка
    ///  потомки должны переопределить его, потому что он у всех разный
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

///  метод возвращает наименование ключа идентификатора который используетс€
///  дл€ данной сущности (у каждого он может быть свой)
function TQueue.GetIdKey: string;
begin
  ///  им€ пол€ идентификатора Lid
  Result := QidKey;
end;

procedure TQueue.Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil);
begin
  inherited Parse(src);

  ///  читаем поле Uid
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
