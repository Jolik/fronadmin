unit LinkUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  Data.DB,
  EntityUnit;

type
  // TLink абстрактный
  TLink = class (TEntity)
  private
    FTypeStr: string;
    FDir: string;
    FCompid: string;
    FDepid: string;
    FStatus: string;
    FComsts: string;
    FLastActivityTime: int64;
    FSettings: TEntity;
    FQid: string;
    function GetLid: string;
    procedure SetLid(const Value: string);

  public
    constructor Create;
    destructor Destroy; override;

    function Assign(ASource: TFieldSet): boolean; override;

    // идентификатор линка
    property Lid: string read GetLid write SetLid;
    // TypeStr тип линка например SOCKET_SPECIAL
    property TypeStr: string read FTypeStr write FTypeStr;
    // Dir направление upload|download|duplex
    property Dir: string read FDir write FDir;
    // Идентификатор очереди к которой привязан Линкс
    property Qid: string read FQid write FQid;
    // Status unknown|starting|stopping|stopped|running|error|halt|unavailable
    property Status: string read FStatus write FStatus;
    // Comsts disconnected|connecting|connected|unknown
    property Comsts: string read FComsts write FComsts;
    // LastActivityTime послений раз когда была активность линка
    property LastActivityTime: int64 read FLastActivityTime write FLastActivityTime;
  end;

  /// список линков
  TLinkList = class (TEntityList)

  end;

implementation

uses
  System.SysUtils,
  FuncUnit;

{ TLink }

function TLink.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;

  if not inherited Assign(ASource) then
    exit;

  if not (ASource is TLink) then
    exit;

  var src := ASource as TLink;
  TypeStr := src.TypeStr;
  Dir := src.Dir;
  Compid := src.Compid;
  Depid := src.Depid;
  Status := src.Status;
  Comsts := src.Comsts;
  LastActivityTime := src.LastActivityTime;
  FreeAndNil(FSettings);
  result := true;
end;

constructor TLink.Create;
begin
  inherited Create();

end;

destructor TLink.Destroy;
begin

  inherited;
end;

function TLink.GetLid: string;
begin
  Result := Id;
end;

procedure TLink.SetLid(const Value: string);
begin
  Id := Value;
end;

end.
