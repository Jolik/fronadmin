unit ParentFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame,
  System.JSON, uniGUIBaseClasses, uniButton;

type
  TParentFrame = class(TUniFrame)
  private
    { Private declarations }
  public
    { Public declarations }
    ///  for write and read data to/from frame
    procedure DataToFrame(AData: TJSONObject); virtual;
    procedure DataFromFrame(AData: TJSONObject); virtual;
    ///  validate data on frame
    function Validate(): boolean; virtual;
  end;

implementation

{$R *.dfm}



{ TChannelEditFrame }

procedure TParentFrame.DataFromFrame;
begin

end;

procedure TParentFrame.DataToFrame;
begin

end;

function TParentFrame.Validate: boolean;
begin
  result := true;
end;

end.
