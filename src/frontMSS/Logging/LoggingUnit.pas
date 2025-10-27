{*******************************************************
* Project: MitraWebStandalone
* Unit: LoggingUnit.pas
* Description: процедуры ведения протокола работы программы
*
* Created: 02.10.2025 12:54:42
* Copyright (C) 2025 МетеоКонтекст (http://meteoctx.com)
*******************************************************}
unit LoggingUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants,
  System.StrUtils;

type
 /// <summary>
 /// типы записей протокола
 /// </summary>
 TLogRecordType = (lrtDebug, lrtInfo, lrtWarning, lrtError);

const
 LogRecordTypeName: array [Low(TLogRecordType) .. High(TLogRecordType)] of string =
  ('Отладка', 'Информация', 'Внимание', 'ОШИБКА');

type
 /// <summary>ILogger
 /// интерфейс службы ведения протокола работы программы
 /// </summary>
 ILogger = interface
   ['{140DDEFF-B57B-49AA-A508-3AAEF0867839}']
   function GetSeverity: TLogRecordType; stdcall;
   procedure SetSeverity(const Value: TLogRecordType); stdcall;
    /// <summary>procedure Log
    /// Добавить запись протокола работы программы
    /// </summary>
    /// <param name="AText"> (String) шаблон текста добавляемый записи</param>
    /// <param name="AParams"> (array of const) параметры для заполнения шаблона</param>
    /// <param name="AType"> (TLogRecordType) тип записи</param>
   procedure Log(const AText: String; AParams: array of const; AType:
       TLogRecordType = lrtInfo); overload;
   /// <summary>ILogger.Severity
   /// минимальный уровень события для регистрации
   /// </summary>
   /// type:TLogRecordType
   property Severity: TLogRecordType read GetSeverity write SetSeverity;
 end;

 /// <summary>IFileLogger
 /// интерфейс службы ведения протокола с хранением данных Лога в файле
 /// </summary>
 IFileLogger = interface(ILogger)
   ['{7E3C04E5-8160-424F-9D87-061EB8D12A16}']
   function GetLogFileName: string; stdcall;
   procedure SetLogFileName(const Value: string); stdcall;
   /// <summary>IFileLogger.LogFileName
   /// имя файла протокола
   /// </summary>
   /// type:string
   property LogFileName: string read GetLogFileName write SetLogFileName;
 end;

 /// <summary>procedure Log
 /// Добавить запись протокола работы программы
 /// </summary>
 /// <param name="AText"> (String) шаблон текста добавляемый записи</param>
 /// <param name="AParams"> (array of const) параметры для заполнения шаблона</param>
 /// <param name="AType"> (TLogRecordType) тип записи</param>
 procedure Log(const AText: String; AParams: array of const; AType:
     TLogRecordType = lrtInfo); overload;

 /// <summary>procedure Log
 /// Добавить запись протокола работы программы
 /// </summary>
 /// <param name="AText"> (String) текст записи</param>
 /// <param name="AType"> (TLogRecordType) тип записи</param>
 procedure Log(const AText: String; AType: TLogRecordType = lrtInfo); overload;


var
  /// <summary>
  /// singleton службы ведения протокола
  /// </summary>
  AppLogger: ILogger = nil;

implementation


 procedure Log(const AText: String; AParams: array of const; AType:
     TLogRecordType = lrtInfo); overload;
 begin
   if Assigned(AppLogger) then
     AppLogger.Log(AText, AParams, AType);
 end;

 procedure Log(const AText: String; AType: TLogRecordType = lrtInfo); overload;
 begin
   Log(AText, [], AType)
 end;


end.
