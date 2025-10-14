{*******************************************************
* Project: MitraWebStandalone
* Unit: LoggingUnit.pas
* Description: ��������� ������� ��������� ������ ���������
*
* Created: 02.10.2025 12:54:42
* Copyright (C) 2025 ������������� (http://meteoctx.com)
*******************************************************}
unit LoggingUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants,
  System.StrUtils;

type
 /// <summary>
 /// ���� ������� ���������
 /// </summary>
 TLogRecordType = (lrtDebug, lrtInfo, lrtWarning, lrtError);

const
 LogRecordTypeName: array [Low(TLogRecordType) .. High(TLogRecordType)] of string =
  ('�������', '����������', '��������', '������');

type
 /// <summary>ILogger
 /// ��������� ������ ������� ��������� ������ ���������
 /// </summary>
 ILogger = interface
   ['{140DDEFF-B57B-49AA-A508-3AAEF0867839}']
   function GetSeverity: TLogRecordType; stdcall;
   procedure SetSeverity(const Value: TLogRecordType); stdcall;
    /// <summary>procedure Log
    /// �������� ������ ��������� ������ ���������
    /// </summary>
    /// <param name="AText"> (String) ������ ������ ����������� ������</param>
    /// <param name="AParams"> (array of const) ��������� ��� ���������� �������</param>
    /// <param name="AType"> (TLogRecordType) ��� ������</param>
   procedure Log(const AText: String; AParams: array of const; AType:
       TLogRecordType = lrtInfo); overload;
   /// <summary>ILogger.Severity
   /// ����������� ������� ������� ��� �����������
   /// </summary>
   /// type:TLogRecordType
   property Severity: TLogRecordType read GetSeverity write SetSeverity;
 end;

 /// <summary>IFileLogger
 /// ��������� ������ ������� ��������� � ��������� ������ ���� � �����
 /// </summary>
 IFileLogger = interface(ILogger)
   ['{7E3C04E5-8160-424F-9D87-061EB8D12A16}']
   function GetLogFileName: string; stdcall;
   procedure SetLogFileName(const Value: string); stdcall;
   /// <summary>IFileLogger.LogFileName
   /// ��� ����� ���������
   /// </summary>
   /// type:string
   property LogFileName: string read GetLogFileName write SetLogFileName;
 end;

 /// <summary>procedure Log
 /// �������� ������ ��������� ������ ���������
 /// </summary>
 /// <param name="AText"> (String) ������ ������ ����������� ������</param>
 /// <param name="AParams"> (array of const) ��������� ��� ���������� �������</param>
 /// <param name="AType"> (TLogRecordType) ��� ������</param>
 procedure Log(const AText: String; AParams: array of const; AType:
     TLogRecordType = lrtInfo); overload;

 /// <summary>procedure Log
 /// �������� ������ ��������� ������ ���������
 /// </summary>
 /// <param name="AText"> (String) ����� ������</param>
 /// <param name="AType"> (TLogRecordType) ��� ������</param>
 procedure Log(const AText: String; AType: TLogRecordType = lrtInfo); overload;


var
  /// <summary>
  /// singleton ������ ������� ���������
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
