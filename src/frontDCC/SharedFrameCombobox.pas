unit SharedFrameCombobox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, ParentFrameUnit, uniMultiItem, uniComboBox,
  uniGUIBaseClasses, uniPanel;

type
  TFrameCombobox = class(TParentFrame)
    PanelIntegerInput: TUniPanel;
    PanelText: TUniPanel;
    ComboBox: TUniComboBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}



end.
