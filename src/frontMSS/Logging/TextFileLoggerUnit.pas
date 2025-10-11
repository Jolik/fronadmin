{*******************************************************
* Project: MitraWebStandalone
* Unit: TextFileLoggerUnit.pas
* Description: реализация службы ведения протокола работы программы
*    с сохранением записей в текстовом файле
*
* Created: 02.10.2025 15:52:45
* Copyright (C) 2025 МетеоКонтекст (http://meteoctx.com)
*******************************************************}
unit TextFileLoggerUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants,
  System.StrUtils, System.IOUtils, System.SyncObjs,
  LoggingUnit
  {$IFDEF MSWINDOWS}
  , Winapi.Windows
  {$ENDIF}
  ;

type
  /// <summary>TTextFileLogger
  /// реализация службы ведения протокола работы программы с сохранением записей в
  /// текстовом файле
  /// </summary>
  TTextFileLogger = class(TInterfacedObject, ILogger, IFileLogger)
  strict private
    FLock: TCriticalSection;
    FLogFileName: string;
    FSeverity: TLogRecordType;
    procedure EnsureLogDirExists;
    function GetComputerName: string;
    function GetLogFileName: string; stdcall;
    function GetLogRecordString(const AText: String; AParams: array of const;
        AType: TLogRecordType): string;
    function GetOsUserName: string;
    function GetProcessId: string;
    function GetSeverity: TLogRecordType; stdcall;
    /// <summary>procedure Log
    /// Добавить запись протокола работы программы
    /// </summary>
    /// <param name="AText"> (String) шаблон текста добавляемый записи</param>
    /// <param name="AParams"> (array of const) параметры для заполнения шаблона</param>
    /// <param name="AType"> (TLogRecordType) тип записи</param>
    procedure Log(const AText: String; AParams: array of const; AType:
        TLogRecordType = lrtInfo); overload;
    procedure SetLogFileName(const Value: string); stdcall;
    procedure SetSeverity(const Value: TLogRecordType); stdcall;
  public
    constructor Create(const ALogFileName: string = '');
    destructor Destroy; override;
    /// <summary>TTextFileLogger.LogFileName
    /// имя файла протокола
    /// </summary>
    /// type:string
    property LogFileName: string read FLogFileName write SetLogFileName;
    /// <summary>TTextFileLogger.Severity
    /// минимальный уровень записи протокола для регистрации
    /// </summary>
    /// type:TLogRecordType
    property Severity: TLogRecordType read FSeverity write SetSeverity;
  end;


implementation

{$IFDEF LINUX}
function gethostname(name: PChar; namelen: SizeInt): Integer; cdecl; external 'libc.so.6';
{$ENDIF}

constructor TTextFileLogger.Create(const ALogFileName: string = '');
begin
  inherited Create;
  FSeverity := lrtInfo;
  FLock := TCriticalSection.Create();
  FLogFileName := ALogFileName;
  if FLogFileName = string.Empty then
  begin
    var vLogDir := '';
    if TDirectory.Exists(TPath.GetHomePath) then
      vLogDir := TPath.Combine(TPath.GetHomePath, 'AppLogs')
    else
      {$IFDEF LINUX}
      vLogDir := TPath.Combine(TPath.GetTempPath, 'AppLogs');
      {$ELSE}
      vLogDir := TPath.Combine(TPath.GetPublicPath, 'AppLogs');
      {$ENDIF}

    FLogFileName := TPath.Combine(vLogDir,
      TPath.GetFileNameWithoutExtension(ParamStr(0)) + '.log');
  end;
end;

destructor TTextFileLogger.Destroy;
begin
  FLock.Free;
  inherited Destroy;
end;

procedure TTextFileLogger.EnsureLogDirExists;
begin
  var vLogFileDir := TPath.GetDirectoryName(LogFileName);
  if not TDirectory.Exists(vLogFileDir) then
    TDirectory.CreateDirectory(vLogFileDir);
end;

function TTextFileLogger.GetComputerName: string;
begin
  {$IFDEF LINUX}
  Len := MaxHostNameLen;
  if gethostname(Buffer, Len) = 0 then
  begin
    Result := StrPas(Buffer);
  end;
  {$ELSE}
  var n: DWORD := MAX_PATH;
  Result := StringOfChar(' ', n);
  Winapi.Windows.GetComputerName(PChar(Result), n);
  Result := Result.Trim();
  {$ENDIF}
end;

function TTextFileLogger.GetLogFileName: string;
begin
  Result := FLogFileName;
end;

function TTextFileLogger.GetLogRecordString(const AText: String; AParams: array
    of const; AType: TLogRecordType): string;
begin
  Result := FormatDateTime('dd/mm/yyyy hh:nn:ss.zzz', Now) + #9 +
    LogRecordTypeName[AType] + #9 +
    Format(AText, AParams) + #9 +
    GetProcessId() + #9 +
    GetComputerName()  + #9 +
    GetOsUserName();
end;

function TTextFileLogger.GetOsUserName: string;
begin
  Result := GetEnvironmentVariable('USERNAME');
  if Result = '' then
    Result := GetEnvironmentVariable('LOGNAME');
end;

function TTextFileLogger.GetProcessId: string;
begin
  Result := IntToStr(GetCurrentProcessId);
end;

function TTextFileLogger.GetSeverity: TLogRecordType;
begin
  Result := FSeverity;
end;

procedure TTextFileLogger.Log(const AText: String; AParams: array of const;
    AType: TLogRecordType = lrtInfo);
begin
  if AType < FSeverity then
    Exit;
  EnsureLogDirExists();
  var vLogRecord := GetLogRecordString(AText, AParams, AType);
  FLock.Enter;
  try
    TFile.AppendAllText(LogFileName, vLogRecord + #13#10, TEncoding.UTF8);
  finally
    FLock.Leave;
  end;
end;

procedure TTextFileLogger.SetLogFileName(const Value: string);
begin
  FLock.Enter;
  try
    if FLogFileName <> Value then
    begin
      FLogFileName := Value;
    end;
  finally
    FLock.Leave;
  end;
end;

procedure TTextFileLogger.SetSeverity(const Value: TLogRecordType);
begin
  FLock.Enter;
  try
    if FSeverity <> Value then
    begin
      FSeverity := Value;
    end;
  finally
    FLock.Leave;
  end;
end;


end.
