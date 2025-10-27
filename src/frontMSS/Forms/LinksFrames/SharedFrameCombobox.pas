unit SharedFrameCombobox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame,  uniMultiItem, uniComboBox,
  uniGUIBaseClasses, uniPanel, KeyValUnit;

type
  TFrameCombobox = class(TUniFrame)
    PanelText: TUniPanel;
    ComboBox: TUniComboBox;
    PanelUnits: TUniPanel;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetDataStr(s: string); virtual;
    function GetDataStr: string; virtual;
    procedure SetDataIndex(idx: integer); virtual;
    function GetDataIndex: integer; virtual;
  end;

implementation

{$R *.dfm}



{ TFrameCombobox }

function TFrameCombobox.GetDataIndex: integer;
begin
  result := ComboBox.ItemIndex;
end;

procedure TFrameCombobox.SetDataIndex(idx: integer);
begin
  ComboBox.ItemIndex := idx;
end;

function TFrameCombobox.GetDataStr: string;
begin
  result := ComboBox.Text;
end;

procedure TFrameCombobox.SetDataStr(s: string);
begin
  ComboBox.ItemIndex := ComboBox.Items.IndexOf(s);
end;

end.
