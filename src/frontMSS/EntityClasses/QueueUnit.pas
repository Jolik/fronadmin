unit QueueUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  Data.DB,
  EntityUnit;

type
  // TQueue настройки очереди. хранится в роутере
  TQueue = class (TEntity)
  private
    FAllowPut: boolean;
    FUid: string;
    FDoubles: boolean;
    function GetQid: string;
    procedure SetQid(const Value: string);

  public
    function Assign(ASource: TFieldSet): boolean; override;

    // идентификатор очереди
    property Qid: string read GetQid write SetQid;
    property AllowPut: boolean read FAllowPut write FAllowPut;
    property Uid: string read FUid write FUid;
    property Doubles: boolean read FDoubles write FDoubles;
  end;

  ///  список очередей
  TQueueList = class (TEntityList)

  end;


implementation

uses
  System.SysUtils,
  FuncUnit;

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


end.
