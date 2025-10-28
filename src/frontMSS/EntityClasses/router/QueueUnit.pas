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
    FCmpid: string;
    FCountersColor: string;
    FCountersHeld: Integer;
    FCountersPrio1: Integer;
    FCountersPrio2: Integer;
    FCountersPrio3: Integer;
    FCountersPrio4: Integer;
    FCountersTotal: Integer;
    FLimitCritical: Integer;
    FLimitMax: Integer;
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
    // Extra fields
    property Cmpid: string read FCmpid write FCmpid;
    property CountersColor: string read FCountersColor write FCountersColor;
    property CountersHeld: Integer read FCountersHeld write FCountersHeld;
    property CountersPrio1: Integer read FCountersPrio1 write FCountersPrio1;
    property CountersPrio2: Integer read FCountersPrio2 write FCountersPrio2;
    property CountersPrio3: Integer read FCountersPrio3 write FCountersPrio3;
    property CountersPrio4: Integer read FCountersPrio4 write FCountersPrio4;
    property CountersTotal: Integer read FCountersTotal write FCountersTotal;
    property LimitCritical: Integer read FLimitCritical write FLimitCritical;
    property LimitMax: Integer read FLimitMax write FLimitMax;

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
  CmpidKey = 'cmpid';
  CountersKey = 'counters';
  ColorKey = 'color';
  HeldKey = 'held';
  Prio1Key = 'prio1';
  Prio2Key = 'prio2';
  Prio3Key = 'prio3';
  Prio4Key = 'prio4';
  TotalKey = 'total';
  LimitsKey = 'limits';
  CriticalKey = 'critical';
  MaxKey = 'max';

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
  Cmpid := GetValueStrDef(src, CmpidKey, '');

  var C := src.GetValue(CountersKey) as TJSONObject;
  if Assigned(C) then
  begin
    FCountersColor := GetValueStrDef(C, ColorKey, '');
    FCountersHeld  := GetValueIntDef(C, HeldKey, 0);
    FCountersPrio1 := GetValueIntDef(C, Prio1Key, 0);
    FCountersPrio2 := GetValueIntDef(C, Prio2Key, 0);
    FCountersPrio3 := GetValueIntDef(C, Prio3Key, 0);
    FCountersPrio4 := GetValueIntDef(C, Prio4Key, 0);
    FCountersTotal := GetValueIntDef(C, TotalKey, 0);
  end
  else
  begin
    FCountersColor := '';
    FCountersHeld := 0; FCountersPrio1 := 0; FCountersPrio2 := 0; FCountersPrio3 := 0; FCountersPrio4 := 0; FCountersTotal := 0;
  end;

  var L := src.GetValue(LimitsKey) as TJSONObject;
  if Assigned(L) then
  begin
    FLimitCritical := GetValueIntDef(L, CriticalKey, 0);
    FLimitMax := GetValueIntDef(L, MaxKey, 0);
  end
  else
  begin
    FLimitCritical := 0;
    FLimitMax := 0;
  end;


end;

procedure TQueue.Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil);

begin
  inherited Serialize(dst);

  dst.AddPair(UidKey, Uid);
  dst.AddPair(CmpidKey, Cmpid);
  // counters summary
  var C := TJSONObject.Create;
  C.AddPair(ColorKey, FCountersColor);
  C.AddPair(HeldKey, TJSONNumber.Create(FCountersHeld));
  C.AddPair(Prio1Key, TJSONNumber.Create(FCountersPrio1));
  C.AddPair(Prio2Key, TJSONNumber.Create(FCountersPrio2));
  C.AddPair(Prio3Key, TJSONNumber.Create(FCountersPrio3));
  C.AddPair(Prio4Key, TJSONNumber.Create(FCountersPrio4));
  C.AddPair(TotalKey, TJSONNumber.Create(FCountersTotal));
  dst.AddPair(CountersKey, C);

  var L := TJSONObject.Create;
  L.AddPair(CriticalKey, TJSONNumber.Create(FLimitCritical));
  L.AddPair(MaxKey, TJSONNumber.Create(FLimitMax));
  dst.AddPair(LimitsKey, L);

end;

{ TQueueList }

class function TQueueList.ItemClassType: TEntityClass;
begin
  Result := TQueue;
end;

end.

