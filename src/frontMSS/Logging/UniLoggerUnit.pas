unit UniLoggerUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants,
  System.StrUtils, System.IOUtils, System.SyncObjs,
  uniMemo,
  LoggingUnit;

type
  // TUniLogger пишет в TUniMemo
  TUniLogger = class(TInterfacedObject, ILogger)
  private
    FLock: TCriticalSection;
    FSeverity: TLogRecordType;
    FMemo: TUniMemo;
    function GetSeverity: TLogRecordType; stdcall;
    procedure SetSeverity(const Value: TLogRecordType); stdcall;
    procedure Log(const AText: String; AParams: array of const; AType:
      TLogRecordType = lrtInfo); overload;
  public
    constructor Create(Memo: TUniMemo);
    destructor Destroy; override;
  end;



implementation

const
  LogTypeToStr: array [Low(TLogRecordType) .. High(TLogRecordType)] of string =
   ('DBG', 'INF', 'WRN', 'ERR');

{ TUniLogger }

constructor TUniLogger.Create(Memo: TUniMemo);
begin
  FLock := TCriticalSection.Create;
  FMemo := Memo;
end;

destructor TUniLogger.Destroy;
begin
  FLock.Free;
  inherited;
end;


procedure TUniLogger.SetSeverity(const Value: TLogRecordType);
begin
  FLock.Enter;
  FSeverity := Value;
  FLock.Leave;
end;

function TUniLogger.GetSeverity: TLogRecordType;
begin
  FLock.Enter;
  result := FSeverity;
  FLock.Leave;
end;

procedure TUniLogger.Log(const AText: String; AParams: array of const;
  AType: TLogRecordType);
begin
  var line := Format('%s [%s] %s', [
    FormatDateTime('hh:nn:ss.zzz', Now),
    LogTypeToStr[AType],
    Format(AText, AParams)
  ]);
  FMemo.Lines.Add(line);
end;

end.