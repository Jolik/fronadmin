unit FTPSRVDownFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, ParentFrameUnit,  System.JSON,
  uniGUIBaseClasses, uniLabel, Vcl.StdCtrls, SharedFrameConnection, uniGroupBox,
  uniEdit, SharedFrameTextInput, utils, SharedFrameCustom;

type
  TFTPSRVDownFrame = class(TParentFrame)
    FrameConnection1: TFrameConnection;
    UniGroupBox1: TUniGroupBox;
    FrameDataPorts: TFrameTextInput;
    FrameExternalIP: TFrameTextInput;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure DataToFrame(AData: TJSONObject); override;
    procedure DataFromFrame(AData: TJSONObject); override;
  end;

implementation

{$R *.dfm}



{ TFTPSRVDownFrame }

procedure TFTPSRVDownFrame.DataFromFrame(AData: TJSONObject);
begin
  inherited;
  var main := TJSONObject.Create;
  AData.AddPair('main', main);
  var tasks := TJSONArray.Create();
  main.AddPair('tasks', tasks);
  var task := TJSONObject.Create;
  tasks.AddElement(task);
  // connections
  FrameConnection1.DataFromFrame(task);
  // custom
  var custom := TJSONObject.Create;
  custom.AddPair('passive_ports', FrameDataPorts.Edit.Text);
  custom.AddPair('public_ip', FrameExternalIP.Edit.Text);
  task.AddPair('custom', custom);
end;

procedure TFTPSRVDownFrame.DataToFrame(AData: TJSONObject);
begin
  inherited;
  // connections
  FrameConnection1.DataToFrame(AData);
  // custom
  var custom := AData.FindValue('main.tasks[0].custom');
  if (custom = nil) or not (custom is TJSONObject) then
    exit;
  FrameDataPorts.Edit.Text := GetValueStrDef(custom, 'passive_ports', '');
  FrameExternalIP.Edit.Text := GetValueStrDef(custom, 'public_ip', '');
end;

end.
