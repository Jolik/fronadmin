unit SharedFrameIntegerInput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, ParentFrameUnit, uniEdit, uniGUIBaseClasses,
  uniPanel;

type
  TFrameIntegerInput = class(TParentFrame)
    PanelIntegerInput: TUniPanel;
    Edit: TUniEdit;
    PanelText: TUniPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}



end.
