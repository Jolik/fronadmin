unit OpenMCEPSettingEditFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, ParentLinkSettingEditFrameUnit, uniCheckBox,
  LinkSettingsUnit, KeyValUnit, LinkUnit,
  uniEdit, uniGroupBox, uniSplitter, uniGUIBaseClasses, uniPanel, uniButton,
  SharedFrameBoolInput, SharedFrameTextInput, SharedFrameConnections,
  SharedFrameQueue, SharedFrameCombobox;

type
  TOpenMCEPSettingEditFrame = class(TParentLinkSettingEditFrame)
    FrameConnections1: TFrameConnections;
    FrameQueue1: TFrameQueue;
    FrameAType: TFrameCombobox;
    FrameDir: TFrameTextInput;
    UniGroupBox2: TUniGroupBox;
    FramePostponeTimeout: TFrameTextInput;
  private
    { Private declarations }
    FSettings: TOpenMCEPDataSettings;
    FComboIndex: TKeyValue<integer>;
  protected
    procedure SetLink(const Value: TLink); override;
    function Apply: boolean; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}



{ TParentLinkSettingEditFrame1 }


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


procedure TOpenMCEPSettingEditFrame.SetLink(const Value: TLink);
begin
  inherited;
  FSettings := DataSettings as TOpenMCEPDataSettings;
end;

function TOpenMCEPSettingEditFrame.Apply: boolean;
begin

end;




end.
