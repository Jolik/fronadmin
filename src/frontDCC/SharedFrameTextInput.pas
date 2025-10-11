unit SharedFrameTextInput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, uniEdit, uniGUIBaseClasses, uniPanel;

type
  TFrameTextInput = class(TUniFrame)
    PanelTextInput: TUniPanel;
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
