unit LoggingUnit;

interface

uses
  Winapi.Windows;

type
  TLogLevel = (llError, llWartning, llDebug, llInfo);

procedure Log(ALevel: TLogLevel; ALogString: string);

implementation

procedure Log(ALevel: TLogLevel; ALogString: string);
begin
  OutputDebugString(PChar(ALogString));
end;

end.
