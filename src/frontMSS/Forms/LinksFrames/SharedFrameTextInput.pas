unit SharedFrameTextInput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, uniEdit, uniGUIBaseClasses, uniPanel;

type
  TFrameTextInput = class(TUniFrame)
    PanelText: TUniPanel;
    Edit: TUniEdit;
    PanelUnits: TUniPanel;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetData(src: string); overload; virtual;
    procedure SetData(src: integer); overload; virtual;
    function GetDataStr: string; virtual;
    function GetDataInt(default: integer = 0): integer; virtual;
  end;

implementation

{$R *.dfm}




{ TFrameTextInput }



function TFrameTextInput.GetDataInt(default: integer = 0): integer;
begin
  result := StrToIntDef(Edit.Text, default);
end;

function TFrameTextInput.GetDataStr: string;
begin
  result := Edit.Text;
end;

procedure TFrameTextInput.SetData(src: integer);
begin
  Edit.Text := IntTostr(src);
end;

procedure TFrameTextInput.SetData(src: string);
begin
  Edit.Text := src;
end;

end.
