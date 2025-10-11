unit DirUpLinkEditFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, System.JSON, System.StrUtils,
  uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, ParentFrameUnit, uniLabel, uniEdit,
  uniGUIBaseClasses, uniPanel, uniMultiItem, uniComboBox;

type
  TDirUpLinkEditFrame = class(TParentFrame)
    DirUpPanel: TUniPanel;
    FolderPathEdit: TUniEdit;
    FolderPathLabel: TUniLabel;
    OnConflictLabel: TUniLabel;
    OnConflictComboBox: TUniComboBox;
    FileTTLLabel: TUniLabel;
    FileTTLEdit: TUniEdit;
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

{  TDirUpLinkEditFrame  }

procedure TDirUpLinkEditFrame.DataFromFrame(AData: TJSONObject);
var
  ModeObj, MasterObj, SlaveObj: TJSONObject;

begin
  inherited;

  MasterObj:= TJSONObject.Create;

  MasterObj.AddPair('folder', FolderPathEdit.Text);

  case OnConflictComboBox.ItemIndex of
    0: MasterObj.AddPair('onconflict', 'overwrite');
    1: MasterObj.AddPair('onconflict', 'uuid');
    2: MasterObj.AddPair('onconflict', 'delay');
  end;

  MasterObj.AddPair('file_ttl', TJSONNumber.Create(StrToIntDef(FileTTLEdit.Text, 60)));

  // Для slave создаем аналогичную структуру (может быть пустой или с дефолтными значениями)
  SlaveObj := TJSONObject.Create;

  SlaveObj.AddPair('folder', FolderPathEdit.Text);
  SlaveObj.AddPair('onconflict', 'overwrite');
  SlaveObj.AddPair('file_ttl', TJSONNumber.Create(StrToIntDef(FileTTLEdit.Text, 60)));

  ModeObj := TJSONObject.Create;

  ModeObj.AddPair('master', MasterObj);
  ModeObj.AddPair('slave', SlaveObj);

  AData.AddPair('mode', ModeObj);
end;

procedure TDirUpLinkEditFrame.DataToFrame(AData: TJSONObject);
var
  ModeObj, MasterObj: TJSONObject;

begin
  inherited;

    if Assigned(AData) then
    begin
      ModeObj := AData.GetValue<TJSONObject>('settings');
      if Assigned(ModeObj) then
      begin
        MasterObj := ModeObj.GetValue<TJSONObject>('mode').GetValue<TJSONObject>('master');
        if Assigned(MasterObj) then
        begin
          FolderPathEdit.Text := MasterObj.GetValue<string>('folder', '');
          case IndexStr(MasterObj.GetValue<string>('onconflict', 'overwrite'), ['overwrite', 'uuid', 'delay']) of
            0: OnConflictComboBox.ItemIndex := 0;
            1: OnConflictComboBox.ItemIndex := 1;
            2: OnConflictComboBox.ItemIndex := 2;
          end;
          FileTTLEdit.Text := MasterObj.GetValue<Integer>('file_ttl', 60).ToString;
        end;
      end;
    end;

end;

procedure TDirUpLinkEditFrame.UniFrameCreate(Sender: TObject);
begin
  inherited;

  FileTTLEdit.Text := '60';

end;

function TDirUpLinkEditFrame.Validate: boolean;
begin
  result := inherited;
  begin
    if Trim(FolderPathEdit.Text) = '' then
    begin
      ShowMessage('Введите путь к папке');
      Exit;
    end;
  end;
end;

end.
