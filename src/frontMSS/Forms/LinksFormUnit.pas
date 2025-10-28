unit LinksFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ListParentFormUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniPageControl, uniSplitter, uniBasicGrid, uniDBGrid,
  uniToolBar, uniGUIBaseClasses,
  EntityBrokerUnit, ParentEditFormUnit, LinksBrokerUnit, uniPanel, uniLabel;

type
  TLinksForm = class(TListParentForm)
  private
  public
    ///  функция обновления компоннет на форме
    procedure Refresh(const AId: String = ''); override;

    ///  функция для создания нужного брокера потомком
    function CreateBroker(): TEntityBroker; override;

    ///  функиця для создания нужной формы редактирвоания
    function CreateEditForm(): TParentEditForm; override;

  end;

function LinksForm: TLinksForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, ChannelEditFormUnit, LinkEditFormUnit;

function LinksForm: TLinksForm;
begin
  Result := TLinksForm(UniMainModule.GetFormInstance(TLinksForm));
end;

{ TLinksForm }

function TLinksForm.CreateBroker: TEntityBroker;
begin
  ///  создаем "наш" брокер для Абонентов
  Result := TLinksBroker.Create();
end;

function TLinksForm.CreateEditForm: TParentEditForm;
begin
  ///  создаем "нашу" форму редактирования для Абонентов
  Result := LinkEditForm();
end;

procedure TLinksForm.Refresh(const AId: String = '');
begin
  inherited Refresh(AId)
end;

end.
