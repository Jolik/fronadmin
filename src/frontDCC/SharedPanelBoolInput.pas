unit SharedPanelBoolInput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, ParentFrameUnit, uniGUIBaseClasses, uniPanel,
  uniCheckBox;

type
  TParentFrame1 = class(TParentFrame)
    PanelBoolInput: TUniPanel;
    PanelText: TUniPanel;
    CheckBoxInput: TUniCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}



end.
