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
  LinkFrameUtils,
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
  var frameClass := LinkFrameByType(link.linkType);
  if frameClass = nil then
    exit;
  FLinkSettingsEditFrame := frameClass.Create(LinkEditForm);
  FLinkSettingsEditFrame.Parent := pnClient;
  FLinkSettingsEditFrame.Link := link;
end;

end.
