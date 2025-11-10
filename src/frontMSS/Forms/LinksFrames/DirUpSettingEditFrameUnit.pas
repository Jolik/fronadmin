unit DirUpSettingEditFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  LinkUnit,
  LinkSettingsUnit,
  KeyValUnit,
  uniGUIClasses, uniGUIFrame, ParentLinkSettingEditFrameUnit, uniSplitter,
  SharedFrameBoolInput, SharedFrameTextInput, uniGroupBox, uniGUIBaseClasses,
  uniPanel, SharedFrameQueue, SharedFrameCombobox, SharedFrameS3;

type
  TDirUpSettingEditFrame = class(TParentLinkSettingEditFrame)
    UniGroupBox1: TUniGroupBox;
    FrameFolder: TFrameTextInput;
    UniGroupBox2: TUniGroupBox;
    FrameSebaSortEnabled: TFrameBoolInput;
    FrameSebasortPathTemplate: TFrameTextInput;
    FrameQueue1: TFrameQueue;
    FrameOnConflict: TFrameCombobox;
    FrameS3: TFrameS3;
  private
    FSettings: TDirUpDataSettings;
    FComboIndex: TKeyValue<integer>;
  protected
    procedure SetLink(const Value: TLink); override;
    function Apply: boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation


{$R *.dfm}

{ TDirUpSettingEditFrame }


constructor TDirUpSettingEditFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FComboIndex := TKeyValue<integer>.Create;
  FComboIndex.Add('hold', 0);
  FComboIndex.Add('error', 1);
  FComboIndex.Add('rename', 2);
  FComboIndex.Add('accept', 3);
  FComboIndex.Add('overwrite', 4);
  FComboIndex.Add('overwrite_or_hold', 5);
end;

destructor TDirUpSettingEditFrame.Destroy;
begin
  FComboIndex.Free;
  inherited;
end;

procedure TDirUpSettingEditFrame.SetLink(const Value: TLink);
begin
  inherited;
  FSettings := DataSettings as TDirUpDataSettings;

  FrameFolder.SetData(FSettings.Folder);
  FrameSebaSortEnabled.SetData(FSettings.SebaSort.Enabled);
  FrameSebasortPathTemplate.SetData(FSettings.SebaSort.PathTemplate);
  FrameQueue1.SetData(FSettings.Queue);
  FrameOnConflict.SetDataIndex(FComboIndex.ValueByKey(FSettings.OnConflict, 0));
  FrameS3.SetData(FSettings.S3);
end;


function TDirUpSettingEditFrame.Apply: boolean;
begin
  result := inherited Apply;
  if not result then
    exit;

  FSettings.Folder := FrameFolder.GetDataStr;
  var ss: TSebaSort;
  ss.Enabled := FrameSebaSortEnabled.GetData;
  ss.PathTemplate := FrameSebasortPathTemplate.GetDataStr;
  FSettings.SebaSort := ss;
  FrameQueue1.GetData(FSettings.Queue);
  FSettings.OnConflict := FComboIndex.KeyByValue(FrameOnConflict.GetDataIndex());
  FrameS3.GetData(FSettings.S3);

  result := true;
end;

end.
