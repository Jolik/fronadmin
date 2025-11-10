unit SharedFrameConnections;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, SharedFrameTextInput, uniGUIBaseClasses,
  uniGroupBox, SharedFrameBoolInput, ConnectionSettingsUnit;

type
  TFrameConnections = class(TUniFrame)
    UniGroupBox1: TUniGroupBox;
    FrameAddr: TFrameTextInput;
    FrameTimeout: TFrameTextInput;
    UniGroupBox3: TUniGroupBox;
    FrameLogin: TFrameTextInput;
    FramePassword: TFrameTextInput;
    UniGroupBox2: TUniGroupBox;
    FrameTLSEnable: TFrameBoolInput;
    UniGroupBox4: TUniGroupBox;
    FrameCRT: TFrameTextInput;
    FrameCertKey: TFrameTextInput;
    FrameCertCA: TFrameTextInput;
    FrameConnectionKey: TFrameTextInput;
    FrameReplaceIP: TFrameBoolInput;
  private
    function GetHasConnectionKey: boolean;
    procedure SetHasConnectionKey(const Value: boolean);
    { Private declarations }
  public
    { Public declarations }
    procedure SetData(src: TConnectionSettingsList); virtual;
    procedure GetData(dst: TConnectionSettingsList); virtual;
    // HasConnectionKey показывать настройку "ключ соединения"
    property HasConnectionKey: boolean read GetHasConnectionKey write SetHasConnectionKey;
  end;

implementation

{$R *.dfm}



{ TFrameConnections }

procedure TFrameConnections.GetData(dst: TConnectionSettingsList);
begin
  dst.Clear;
  var conn := TConnectionSettings.Create;
  dst.Add(conn);
  conn.Addr := FrameAddr.GetDataStr();
  conn.Timeout := FrameTimeout.GetDataInt();
  conn.ConnectionKey := FrameConnectionKey.GetDataStr();
  conn.ReplaceIP := FrameReplaceIP.GetData;
  var Secure: TSecure;
  Secure.Auth.Login := FrameLogin.GetDataStr();
  Secure.Auth.Password := FramePassword.GetDataStr();
  Secure.TLS.Enabled := FrameTLSEnable.GetData();
  Secure.TLS.Certificates.CRT := FrameCRT.GetDataStr();
  Secure.TLS.Certificates.Key := FrameCertKey.GetDataStr();
  Secure.TLS.Certificates.CA := FrameCertCA.GetDataStr();
  conn.Secure := Secure;
end;



procedure TFrameConnections.SetData(src: TConnectionSettingsList);
begin
  FrameAddr.SetData('');
  FrameTimeout.SetData(0);
  FrameLogin.SetData('');
  FramePassword.SetData('');
  FrameTLSEnable.SetData(false);
  FrameCRT.SetData('');
  FrameCertCA.SetData('');
  FrameCertKey.SetData('');
  FrameConnectionKey.SetData('');

  if src.Count = 0 then
    exit;

  var conn := src.Connections[0];
  FrameAddr.SetData(conn.Addr);
  FrameTimeout.SetData(conn.Timeout);
  FrameLogin.SetData(conn.Secure.Auth.Login);
  FramePassword.SetData(conn.Secure.Auth.Password);
  FrameTLSEnable.SetData(conn.Secure.TLS.Enabled);
  FrameCRT.SetData(conn.Secure.TLS.Certificates.CRT);
  FrameCertCA.SetData(conn.Secure.TLS.Certificates.CA);
  FrameCertKey.SetData(conn.Secure.TLS.Certificates.Key);
  FrameConnectionKey.SetData(conn.ConnectionKey);
  FrameReplaceIP.SetData(conn.ReplaceIP);
end;

procedure TFrameConnections.SetHasConnectionKey(const Value: boolean);
begin
  FrameConnectionKey.Enabled := Value;
end;

function TFrameConnections.GetHasConnectionKey: boolean;
begin
  result := FrameConnectionKey.Enabled;
end;

end.
