unit SharedFrameS3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, S3SettingsUnit,
  uniGUIClasses, uniGUIFrame, SharedFrameBoolInput, uniGUIBaseClasses,
  uniGroupBox, SharedFrameTextInput;

type
  TFrameS3 = class(TUniFrame)
    UniGroupBox1: TUniGroupBox;
    FrameS3Enabled: TFrameBoolInput;
    FrameS3AccessKey: TFrameTextInput;
    FrameS3Endpoint: TFrameTextInput;
    FrameS3Secret: TFrameTextInput;
    FrameS3Bucket: TFrameTextInput;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetData(src: TS3Settings); virtual;
    procedure GetData(dst: TS3Settings); virtual;
  end;

implementation

{$R *.dfm}



{ TFrameS3 }

procedure TFrameS3.GetData(dst: TS3Settings);
begin
  dst.Enabled := FrameS3Enabled.GetData;
  dst.AccessKey := FrameS3AccessKey.GetDataStr;
  dst.Endpoint := FrameS3Endpoint.GetDataStr;
  dst.SecretKey := FrameS3Secret.GetDataStr;
  dst.BucketName  := FrameS3Bucket.GetDataStr;
end;

procedure TFrameS3.SetData(src: TS3Settings);
begin
  FrameS3Enabled.SetData(src.Enabled);
  FrameS3AccessKey.SetData(src.AccessKey);
  FrameS3Endpoint.SetData(src.Endpoint);
  FrameS3Secret.SetData(src.SecretKey);
  FrameS3Bucket.SetData(src.BucketName);
end;

end.
