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
//  DirDownSettingEditFrameUnit,
//  DirUpSettingEditFrameUnit,
//  FTPCliDownLinkSettingEditFrameUnit,
//  FTPCliUpLinkSettingEditFrameUnit,
//  Pop3CliDownLinkSettingEditFrameUnit,
//  SMTPClieUpLinkSettingEditFrameUnit,
//  FTPServerDownLinkSettingEditFrameUnit,
//  FTPSrvUpLinkSettingEditFrameUnit,
//  SMTPSrvDownLinkSettingEditFrameUnit,
//  HTTPCliDownLinkSettingEditFrameUnit,
//  SebaSGSLinkSettingEditFrameUnit,
//  SebaCSDLinkSettingEditFrameUnit,
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

//  case link.linkType of
//    ltDirDown: FLinkSettingsEditFrame := TDirDownSettingEditFrame.Create(LinkEditForm);
//    ltDirUp: FLinkSettingsEditFrame := TDirUpSettingEditFrame.Create(LinkEditForm);
//    ltFtpClientDown: FLinkSettingsEditFrame := TFtpCliDownLinkSettingEditFrame.Create(LinkEditForm);
//    ltFtpClientUp: FLinkSettingsEditFrame := TFTPCliUpLinkSettingEditFrame.Create(LinkEditForm);
//    ltFtpServerDown: FLinkSettingsEditFrame := TFTPServerDownLinkSettingEditFrame.Create(LinkEditForm);
//    ltFtpServerUp: FLinkSettingsEditFrame := TFTPSrvUpLinkSettingEditFrame.Create(LinkEditForm);
//    ltOpenMCEP: FLinkSettingsEditFrame := TOpenMCEPSettingEditFrame.Create(Self);
//    ltPop3ClientDown: FLinkSettingsEditFrame := TPop3CliDownLinkSettingEditFrame.Create(LinkEditForm);
//    ltSmtpCliUp: FLinkSettingsEditFrame := TSMTPClieUpLinkSettingEditFrame.Create(LinkEditForm);
//    ltSmtpSrvDown: FLinkSettingsEditFrame := TSMTPSrvDownLinkSettingEditFrame.Create(LinkEditForm);
//    ltSocketSpecial: FLinkSettingsEditFrame := TSocketSpecialSettingEditFrame.Create(Self);
//    ltHttpClientDown: FLinkSettingsEditFrame := THTTPCliDownLinkSettingEditFrame.Create(LinkEditForm);
//    ltSebaSgsClientDown: FLinkSettingsEditFrame := TSebaSGSLinkSettingEditFrame.Create(LinkEditForm);
//    ltSebaUsrCsdClientDown: FLinkSettingsEditFrame := TSebaCSDLinkSettingEditFrame.Create(LinkEditForm);
//    else exit;
//  end;

  FLinkSettingsEditFrame.Parent := pnClient;
  FLinkSettingsEditFrame.Link := link;
end;

end.
