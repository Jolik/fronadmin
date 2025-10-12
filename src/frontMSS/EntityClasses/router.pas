unit router;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  Data.DB,
  EntityUnit, QueueUnit, LinkUnit;

type
  TChannel = class (TEntity)
  private
    /// ������� ������
    FQueue : TQueue;
    ///  ���� ������
    FLink : TLink;
    procedure SetLink(const Value: TLink);
    procedure SetQueue(const Value: TQueue);
    function GetChid: string;
    procedure SetChid(const Value: string);

  public
    constructor Create;
    destructor Destroy; override;

    // ������������� ������
    property Chid: string read GetChid write SetChid;
    /// ������� ������
    property Queue : TQueue read FQueue write SetQueue;
    ///  ���� ������
    property Link : TLink read FLink write SetLink;

  end;

  /// ������ �������
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

  ///  ������-���� ������ �������� ���� � �� ��
  ///  ��� ��������� ������ ������������� ���� � ���
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
  ///  ����������� ��� ���� ������ �����
  FLink.Assign(Value);
end;

procedure TChannel.SetQueue(const Value: TQueue);
begin
  ///  ����������� ��� ���� ����� �������
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
