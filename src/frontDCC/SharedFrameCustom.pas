unit SharedFrameCustom;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, ParentFrameUnit, uniGUIBaseClasses, uniGroupBox;

type
  TFrameCustom = class(TParentFrame)
    UniGroupBox1: TUniGroupBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}



end.
