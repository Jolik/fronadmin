unit ChannelUnit;

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
  protected
     function GetIdKey: string; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;


    // идентификатор канала
    property Chid: string read GetChid write SetChid;
    /// очередь канала
    property Queue : TQueue read FQueue write SetQueue;
    ///  линк канала
    property Link : TLink read FLink write SetLink;

  end;

  /// список каналов
  TChannelList = class (TEntityList)
  protected
    class function ItemClassType: TEntityClass; override;
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

function TChannel.GetIdKey: string;
begin
  result := 'chid';
end;

procedure TChannel.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  inherited;
  var l := src.FindValue('link');
  if l is TJSONObject then
    FLink.Parse(l as TJSONObject, APropertyNames);

  var q := src.FindValue('queue');
  if q is TJSONObject then
    FQueue.Parse(q as TJSONObject, APropertyNames);
end;

procedure TChannel.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;
  dst.AddPair('link', FLink.Serialize(APropertyNames));
  dst.AddPair('queue', FQueue.Serialize(APropertyNames));
end;

procedure TChannel.SetChid(const Value: string);
begin
  Id := Value;
end;

{ TChannelList }

class function TChannelList.ItemClassType: TEntityClass;
begin
  result := TChannel;
end;

end.
