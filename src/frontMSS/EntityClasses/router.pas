unit router;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  Data.DB,
  EntityUnit, QueueUnit, LinkUnit;

type
  TChannel = class (TEntity)
  private
    /// очередь канала
    FQueue : TQueue;
    ///  линк канала
    FLink : TLink;
    procedure SetLink(const Value: TLink);
    procedure SetQueue(const Value: TQueue);
    function GetChid: string;
    procedure SetChid(const Value: string);

  public
    constructor Create;
    destructor Destroy; override;

    // идентификатор канала
    property Chid: string read GetChid write SetChid;
    /// очередь канала
    property Queue : TQueue read FQueue write SetQueue;
    ///  линк канала
    property Link : TLink read FLink write SetLink;

  end;

  /// список каналов
  TChannelList = class (TEntityList)

  end;

implementation

uses
  System.SysUtils,
  FuncUnit;

{ TChannel }

constructor TChannel.Create;
begin
  inherited Create();

  ///  классы-поля всегда остаются одни и те же
  ///  при изменении только присваиваются поля и все
  FLink := TLink.Create;
  FQueue := TQueue.Create;
end;

destructor TChannel.Destroy;
begin
  FLink.Free;
  FQueue.Free;

  inherited;
end;

procedure TChannel.SetLink(const Value: TLink);
begin
  ///  присваиваем все поля нашему линку
  FLink.Assign(Value);
end;

procedure TChannel.SetQueue(const Value: TQueue);
begin
  ///  присваиваем все поля нашей очереди
  FQueue.Assign(Value);
end;

function TChannel.GetChid: string;
begin
  Result := Id;
end;

procedure TChannel.SetChid(const Value: string);
begin
  Id := Value;
end;

end.
