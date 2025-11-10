unit SharedFrameQueue;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, QueueSettingsUnit,
  uniGUIClasses, uniGUIFrame, SharedFrameTextInput, SharedFrameBoolInput;

type
  TFrameQueue = class(TUniFrame)
    FrameQid: TFrameTextInput;
    FrameQueueEnable: TFrameBoolInput;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetData(src: TQueueSettings); virtual;
    procedure GetData(dst: TQueueSettings); virtual;
  end;

implementation

{$R *.dfm}



{ TQueueFrame }

procedure TFrameQueue.GetData(dst: TQueueSettings);
begin
  dst.ID := FrameQid.GetDataStr();
  dst.Disabled := not FrameQueueEnable.GetData();
end;

procedure TFrameQueue.SetData(src: TQueueSettings);
begin
  FrameQid.SetData(src.ID);
  FrameQueueEnable.SetData(not src.Disabled);
end;

end.
