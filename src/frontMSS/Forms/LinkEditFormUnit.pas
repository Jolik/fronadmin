unit LinkEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,  EntityUnit,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniButton,
  uniGUIBaseClasses, uniPanel, ParentLinkSettingEditFrameUnit;

type
  TLinkEditForm = class(TParentEditForm)
    procedure btnOkClick(Sender: TObject);
  private
    FLinkSettingsEditFrame: TParentLinkSettingEditFrame;
    { Private declarations }
  protected
    function Apply: boolean; override;
    procedure SetEntity(AEntity : TEntity); override;
  public

  end;

function LinkEditForm: TLinkEditForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication,
  OpenMCEPSettingEditFrameUnit,
  SocketSpecialSettingEditFrameUnit,
  LinkUnit;

function LinkEditForm: TLinkEditForm;
begin
  Result := TLinkEditForm(UniMainModule.GetFormInstance(TLinkEditForm));
end;

{ TLinkEditForm }

function TLinkEditForm.Apply: boolean;
begin
  result := false;
  if not  FLinkSettingsEditFrame.Apply() then
    exit;
  result := inherited Apply;
end;

procedure TLinkEditForm.btnOkClick(Sender: TObject);
begin
  inherited;
  if not Apply then
    exit;
end;

procedure TLinkEditForm.SetEntity(AEntity: TEntity);
begin
  inherited;
  if not (entity is TLink) then
    exit;
  var link := (entity as TLink);

  case link.linkType of
    //ltDirDown: SettingsFrame := .Create(LinkEditForm);
    //ltDirUp: SettingsFrame := .Create(LinkEditForm);
    //ltFtpClientDown: SettingsFrame := .Create(LinkEditForm);
    //ltFtpClientUp: SettingsFrame := .Create(LinkEditForm);
    //ltFtpServerDown: SettingsFrame := .Create(LinkEditForm);
    //ltFtpServerUp: SettingsFrame := .Create(LinkEditForm);
    ltOpenMCEP: FLinkSettingsEditFrame := TOpenMCEPSettingEditFrame.Create(Self);
    //ltPop3ClientDown: SettingsFrame := .Create(LinkEditForm);
    //ltSmtpCliUp: SettingsFrame := .Create(LinkEditForm);
    //ltSmtpSrvDown: SettingsFrame := .Create(LinkEditForm);
    ltSocketSpecial: FLinkSettingsEditFrame := TSocketSpecialSettingEditFrame.Create(Self);
    //ltHttpClientDown: SettingsFrame := .Create(LinkEditForm);
    //ltSebaSgsClientDown: SettingsFrame := .Create(LinkEditForm);
    //ltSebaUsrCsdClientDown     : SettingsFrame := .Create(LinkEditForm);
    else exit;
  end;

  FLinkSettingsEditFrame.Parent := pnClient;
  FLinkSettingsEditFrame.Link := link;
end;

end.
