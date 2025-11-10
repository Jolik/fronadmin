unit SharedFrameBoolInput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, uniGUIBaseClasses, uniPanel,
  uniCheckBox;

type
  TFrameBoolInput = class(TUniFrame)
    PanelText: TUniPanel;
    CheckBox: TUniCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetData(src: bool);  virtual;
    function GetData: bool; virtual;
  end;

implementation

{$R *.dfm}



{ TFrameBoolInput }

function TFrameBoolInput.GetData: bool;
begin
  result := CheckBox.Checked;
end;

procedure TFrameBoolInput.SetData(src: bool);
begin
  CheckBox.Checked := src;
end;

end.
