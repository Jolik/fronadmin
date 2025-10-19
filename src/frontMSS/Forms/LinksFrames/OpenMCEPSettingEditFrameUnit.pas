unit OpenMCEPSettingEditFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, ParentLinkSettingEditFrameUnit, uniCheckBox,
  LinkSettingsUnit, KeyValUnit,
  uniEdit, uniGroupBox, uniSplitter, uniGUIBaseClasses, uniPanel, uniButton,
  SharedFrameBoolInput, SharedFrameTextInput, SharedFrameConnections,
  SharedFrameQueue, SharedFrameCombobox;

type
  TOpenMCEPSettingEditFrame = class(TParentLinkSettingEditFrame)
    FrameConnections1: TFrameConnections;
    FrameQueue1: TFrameQueue;
    FrameAType: TFrameCombobox;
    FrameDir: TFrameTextInput;
    UniGroupBox1: TUniGroupBox;
    UniGroupBox2: TUniGroupBox;
    FramePostponeTimeout: TFrameTextInput;
  private
    { Private declarations }
    FSettings: TOpenMCEPDataSettings;
    FComboIndex: TKeyValue<integer>;
  protected
    procedure SetDataSettings(const Value: TDataSettings); override;
    function Apply: boolean; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}



{ TParentLinkSettingEditFrame1 }

function TOpenMCEPSettingEditFrame.Apply: boolean;
begin

end;

procedure TOpenMCEPSettingEditFrame.SetDataSettings(
  const Value: TDataSettings);
begin
  inherited;

end;

constructor TOpenMCEPSettingEditFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FComboIndex := TKeyValue<integer>.Create;
  FComboIndex.Add('server', 0);
  FComboIndex.Add('client', 1);
end;

destructor TOpenMCEPSettingEditFrame.Destroy;
begin
  FComboIndex.Free;
  inherited;
end;



end.
