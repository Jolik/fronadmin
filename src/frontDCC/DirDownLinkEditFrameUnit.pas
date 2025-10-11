unit DirDownLinkEditFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, System.JSON,
  uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, ParentFrameUnit, uniGUIBaseClasses, uniPanel,
  uniCheckBox, uniEdit, uniLabel;

type
  TDirDownLinkEditFrame = class(TParentFrame)
    DirDownPanel: TUniPanel;
    DirPathLabel: TUniLabel;
    DirPathEdit: TUniEdit;
    DirDepthLabel: TUniLabel;
    DirDepthEdit: TUniEdit;
    ParseMeteoCheckBox: TUniCheckBox;
    DistributionKeyLabel: TUniLabel;
    DistributionKeyEdit: TUniEdit;
    FilterRegexCheckBox: TUniCheckBox;
    RegexPatternLabel: TUniLabel;
    RegexPatternEdit: TUniEdit;
    IgnoreTmpCheckBox: TUniCheckBox;
    SchedulePauseLabel: TUniLabel;
    SchedulePauseEdit: TUniEdit;
    procedure UniFrameCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure DataToFrame(AData: TJSONObject); override;
    procedure DataFromFrame(AData: TJSONObject); override;
    ///  validate data on frame
    function Validate(): boolean; override;

  end;

implementation

{$R *.dfm}

{  TDirDownLinkEditFrame  }

procedure TDirDownLinkEditFrame.DataFromFrame(AData: TJSONObject);
var
  ModeObj, MasterObj, SlaveObj: TJSONObject;

begin
  inherited;

  // Type-specific settings для master
  MasterObj := TJSONObject.Create;

  MasterObj.AddPair('path', DirPathEdit.Text);
  MasterObj.AddPair('depth', TJSONNumber.Create(StrToIntDef(DirDepthEdit.Text, 0)));
  // Для DirDown могут быть дополнительные поля
  if ParseMeteoCheckBox.Checked then
    MasterObj.AddPair('parse_meteo', TJSONBool.Create(True));
  if DistributionKeyEdit.Text <> '' then
    MasterObj.AddPair('key', DistributionKeyEdit.Text);
  if FilterRegexCheckBox.Checked then
  begin
    MasterObj.AddPair('filter_regular_active', TJSONBool.Create(True));
    MasterObj.AddPair('filter_regular_pattern', RegexPatternEdit.Text);
  end;
  if IgnoreTmpCheckBox.Checked then
    MasterObj.AddPair('filter_ignore_tmp', TJSONBool.Create(True));
  if StrToIntDef(SchedulePauseEdit.Text, 0) > 0 then
    MasterObj.AddPair('schedule_pause', TJSONNumber.Create(StrToIntDef(SchedulePauseEdit.Text, 0)));

  // Для slave создаем аналогичную структуру (может быть пустой или с дефолтными значениями)
  SlaveObj := TJSONObject.Create;

  // Можно скопировать настройки из master или оставить пустым
  SlaveObj.AddPair('path', DirPathEdit.Text);
  SlaveObj.AddPair('depth', TJSONNumber.Create(StrToIntDef(DirDepthEdit.Text, 0)));

  ModeObj := TJSONObject.Create;

  ModeObj.AddPair('master', MasterObj);
  ModeObj.AddPair('slave', SlaveObj);

  AData.AddPair('mode', ModeObj);
end;

procedure TDirDownLinkEditFrame.DataToFrame(AData: TJSONObject);
var
  ModeObj, MasterObj: TJSONObject;

begin
  inherited;
  exit;
  if Assigned(AData) then
  begin
    ModeObj := AData.GetValue<TJSONObject>('settings');
    if Assigned(ModeObj) then
    begin
      MasterObj := ModeObj.GetValue<TJSONObject>('mode').GetValue<TJSONObject>('master');
      if Assigned(MasterObj) then
      begin
        DirPathEdit.Text := MasterObj.GetValue<string>('dir_path', '');
        DirDepthEdit.Text := MasterObj.GetValue<Integer>('dir_depth', 0).ToString;
        ParseMeteoCheckBox.Checked := MasterObj.GetValue<Boolean>('parse_meteo', False);
        DistributionKeyEdit.Text := MasterObj.GetValue<string>('key', '');
        FilterRegexCheckBox.Checked := MasterObj.GetValue<Boolean>('filter_regular_active', False);
        RegexPatternEdit.Text := MasterObj.GetValue<string>('filter_regular_pattern', '');
        IgnoreTmpCheckBox.Checked := MasterObj.GetValue<Boolean>('filter_ignore_tmp', True);
        SchedulePauseEdit.Text := MasterObj.GetValue<Integer>('schedule_pause', 0).ToString;
      end;
    end;
  end;

end;

function TDirDownLinkEditFrame.Validate: boolean;
begin
  begin
    if Trim(DirPathEdit.Text) = '' then
    begin
      ShowMessage('Введите путь к директории');
      Exit;
    end;
  end;
end;

procedure TDirDownLinkEditFrame.UniFrameCreate(Sender: TObject);
begin
  inherited;

  SchedulePauseEdit.Text := '0';
end;

end.
