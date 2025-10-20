unit ProfileFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  KeyValUnit,
  uniGUIClasses, uniGUIFrame, uniSplitter, uniMultiItem, uniListBox,
  uniGUIBaseClasses, uniGroupBox, ProfileUnit, SharedFrameTextInput, uniButton,
  uniPanel, uniComboBox, uniCheckBox;

type
  TProfileFrame = class(TUniFrame)
    UniGroupBox1: TUniGroupBox;
    UniSplitter1: TUniSplitter;
    UniGroupBox2: TUniGroupBox;
    PridFrame: TFrameTextInput;
    FtaGroupBox: TUniGroupBox;
    CheckBox_fta_XML: TUniCheckBox;
    CheckBox_fta_JSON: TUniCheckBox;
    CheckBox_fta_SIMPLE: TUniCheckBox;
    CheckBox_fta_GAO: TUniCheckBox;
    CheckBox_fta_TLG: TUniCheckBox;
    CheckBox_fta_TLF: TUniCheckBox;
    CheckBox_fta_FILE: TUniCheckBox;
    DescriptionFrame: TFrameTextInput;
  private
    FProfile: TProfile;
    FLid: string;
    FFTACheckboxes: TKeyValue<TUniCheckbox> ;

    procedure SetPrid(const Value: string);
    function GetPrid: string;

  protected
    procedure Clear; virtual;
    procedure Load(prid: string); virtual;
    function Save: boolean; virtual;
    function Delete: boolean; virtual;
    procedure DrawProfile;  virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Apply: boolean; virtual;
    property Lid: string read FLid write FLid;
    property Prid: string read GetPrid write SetPrid;

  end;

implementation
uses
  LoggingUnit,
  ProfilesBrokerUnit,
  uniGUIDialogs;

{$R *.dfm}



{ TProfileFrame }

constructor TProfileFrame.Create(AOwner: TComponent);
begin
  inherited;
  FFTACheckboxes := TKeyValue<TUniCheckbox>.Create;
  FFTACheckboxes.Add('fta_XML', CheckBox_fta_FILE);
  FFTACheckboxes.Add('fta_JSON', CheckBox_fta_FILE);
  FFTACheckboxes.Add('fta_SIMPLE', CheckBox_fta_FILE);
  FFTACheckboxes.Add('fta_GAO', CheckBox_fta_FILE);
  FFTACheckboxes.Add('fta_TLG', CheckBox_fta_FILE);
  FFTACheckboxes.Add('fta_TLF', CheckBox_fta_FILE);
  FFTACheckboxes.Add('fta_FILE', CheckBox_fta_FILE);
end;

destructor TProfileFrame.Destroy;
begin
  FFTACheckboxes.Free;
  inherited;
end;


function TProfileFrame.Apply: boolean;
begin
  FProfile.ProfileBody.Play.FTA.Clear;
  for var cb in FFTACheckboxes.Values do
    if cb.Checked then
      FProfile.ProfileBody.Play.FTA.Add( FFTACheckboxes.KeyByValue(cb) );



end;


function TProfileFrame.GetPrid: string;
begin
  if FProfile <> nil then
    result := FProfile.Id
  else
    result := ''
end;

procedure TProfileFrame.Load(prid: string);
begin
  FreeAndNil(FProfile);
  var broker := TProfilesBroker.Create;
  broker.Lid := Lid;
  try
    try
      var p := broker.Info(prid);
      if not (p is TProfile) then
        exit;
      FProfile := p as TProfile;
    except on e: exception do begin
      Log('TProfileFrame.Load ' + e.Message, lrtError);
    end; end;
  finally
    broker.free;
  end;
end;


function TProfileFrame.Save: boolean;
begin
  result := false;
  var broker := TProfilesBroker.Create;
  broker.Lid := Lid;
  try
    try
      if FProfile.IsNew then
      begin
        if not broker.New(FProfile) then
          exit;
        FProfile.IsNew := false;
      end
      else
        if not broker.Update(FProfile) then
          exit;
    except on e: exception do begin
      Log('TProfileFrame.Save ' + e.Message, lrtError);
      exit;
    end; end;
  finally
    broker.free;
  end;
  result := true;
end;




procedure TProfileFrame.SetPrid(const Value: string);
begin
  Load(Value);
  DrawProfile;
end;



function TProfileFrame.Delete: boolean;
begin
  result := false;
  if FProfile = nil then
    exit;
  var broker := TProfilesBroker.Create;
  broker.Lid := Lid;
  try
    try
      var p := broker.Info(prid);
      if not (p is TProfile) then
        exit;
      FProfile := p as TProfile;
    except on e: exception do begin
      Log('TProfileFrame.Delete ' + e.Message, lrtError);
      exit;
    end; end;
  finally
    broker.free;
  end;
  result := true;
end;



procedure TProfileFrame.Clear;
begin
  PridFrame.Edit.Text := '';
  DescriptionFrame.Edit.Text := '';
  for var checkbox in FFTACheckboxes.Values do
    checkbox.Checked := false;
end;



procedure TProfileFrame.DrawProfile;
begin
  Clear;
  if FProfile = nil then
    exit;
  PridFrame.Edit.Text := FProfile.Id;
  DescriptionFrame.Edit.Text := FProfile.Description;
  for var fta in FProfile.ProfileBody.Play.FTA.ToArray do
  begin
    var cb := FFTACheckboxes.ValueByKey(fta, nil);
    if cb <> nil then
      cb.Checked := true
    else
      Log('TProfileFrame.DrawProfile unknown FTA: '+fta, lrtError);
  end;
end;

end.
