unit SharedFrameConnection;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, ParentFrameUnit, uniEdit, uniPanel,
  uniGUIBaseClasses, uniGroupBox,System.JSON, SharedFrameTextInput,
  SharedFrameIntegerInput, SharedFrameBoolInput, uniGUIForm, utils;

type
  TFrameConnection = class(TParentFrame)
    UniGroupBox1: TUniGroupBox;
    FrameAddr: TFrameTextInput;
    FrameTimeout: TFrameIntegerInput;
    UniGroupBox2: TUniGroupBox;
    UniGroupBox3: TUniGroupBox;
    UniGroupBox4: TUniGroupBox;
    FrameLogin: TFrameTextInput;
    FramePass: TFrameTextInput;
    FrameEnableTLS: TFrameBoolInput;
    UniGroupBox5: TUniGroupBox;
    FrameCertCrt: TFrameTextInput;
    FrameCertKey: TFrameTextInput;
    FrameCertCA: TFrameTextInput;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure DataToFrame(AData: TJSONObject); override;
    procedure DataFromFrame(AData: TJSONObject); override;
  end;

implementation

{$R *.dfm}



{ TParentFrame1 }

procedure TFrameConnection.DataFromFrame(AData: TJSONObject);
begin
  inherited;
  var connection := TJSONObject.Create;
  connection.AddPair('addr', FrameAddr.Edit.Text);
  connection.AddPair('timeout', StrToIntDef(FrameTimeout.Edit.Text, 0));
  var secure := TJSONObject.Create;
  connection.AddPair('secure', secure);
  var auth := TJSONObject.Create;
  secure.AddPair('auth', auth);
  auth.AddPair('login', FrameLogin.Edit.Text);
  auth.AddPair('password', FramePass.Edit.Text);
  var tls := TJSONObject.Create;
  secure.AddPair('tls', tls);
  tls.AddPair('enabled', FrameEnableTLS.CheckBox.Checked);
  var cert := TJSONObject.Create;
  tls.AddPair('certificates', cert);
  cert.AddPair('crt', FrameCertCrt.Edit.Text);
  cert.AddPair('key', FrameCertKey.Edit.Text);
  cert.AddPair('ca', FrameCertCA.Edit.Text);
  AData.AddPair('connections', TJSONArray.Create(connection));
end;

procedure TFrameConnection.DataToFrame(AData: TJSONObject);
begin
  inherited;
  var conn := AData.FindValue('main.tasks[0].connections[0]');
  if (conn = nil) or not (conn is TJSONObject) then
    exit;
  FrameAddr.Edit.Text := GetValueStrDef(conn, 'addr', '');
  FrameTimeout.Edit.Text := IntToStr(GetValueIntDef(conn, 'timeout', 0));
end;

end.
