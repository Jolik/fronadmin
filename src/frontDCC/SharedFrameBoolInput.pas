unit SharedFrameBoolInput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, ParentFrameUnit, uniGUIBaseClasses, uniPanel,
  uniCheckBox;

type
  TFrameBoolInput = class(TParentFrame)
    PanelBoolInput: TUniPanel;
    PanelText: TUniPanel;
    CheckBox: TUniCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}



end.
