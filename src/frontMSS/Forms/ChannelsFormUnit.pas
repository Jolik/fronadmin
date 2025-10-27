unit ChannelsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ListParentFormUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniPanel, uniPageControl, uniSplitter, uniBasicGrid,
  uniDBGrid, uniToolBar, uniGUIBaseClasses,
  EntityBrokerUnit, ChannelsBrokerUnit,
  ParentEditFormUnit, uniLabel;

type
  TChannelsForm = class(TListParentForm)
    FDMemTableEntityService: TStringField;
  private
  protected
    ///  функция обновления компоннет на форме
    procedure Refresh(const AId: String = ''); override;

    ///  функция для создания нужного брокера потомком
//    function CreateBroker(): TEntityBroker; override;

    ///  функиця для создания нужной формы редактирвоания
    function CreateEditForm(): TParentEditForm; override;

  public

  end;

function ChannelsForm: TChannelsForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, ChannelEditFormUnit, EntityUnit, ChannelUnit;

function ChannelsForm: TChannelsForm;
begin
  Result := TChannelsForm(UniMainModule.GetFormInstance(TChannelsForm));
end;

{ TChannelsForm }

//function TChannelsForm.CreateBroker: TEntityBroker;
//begin
//  ///  создаем "наш" брокер для Абонентов
//  Result := TChannelsBroker.Create();
//end;

function TChannelsForm.CreateEditForm: TParentEditForm;
begin
  ///  создаем "нашу" форму редактирования для Абонентов
  Result := ChannelEditForm();
end;

procedure TChannelsForm.Refresh(const AId: String = '');
var
  EntityList: TEntityList;
  PageCount: Integer;

begin
//  FDMemTableEntity.Active := True;
//  EntityList := RestBroker.List(PageCount);
//  try
//    FDMemTableEntity.EmptyDataSet;
//
//    if Assigned(EntityList) then
//      for var Entity in EntityList do
//      with Entity as TChannel do
//      begin
//        FDMemTableEntity.Append;
//        FDMemTableEntity.FieldByName('Id').AsString := Id;
//        FDMemTableEntity.FieldByName('Name').AsString := Name;
//        FDMemTableEntity.FieldByName('Service').AsString := Service.SvcID;
//        FDMemTableEntity.FieldByName('Caption').AsString := Entity.Caption;
//        FDMemTableEntity.FieldByName('Created').AsDateTime := Entity.Created;
//        FDMemTableEntity.FieldByName('Updated').AsDateTime := Entity.Updated;
//        FDMemTableEntity.Post;
//      end;
//
//    if FDMemTableEntity.IsEmpty then
//      tsTaskInfo.TabVisible := False
//    else
//      if AID.IsEmpty then
//        FDMemTableEntity.First
//      else
//        FDMemTableEntity.Locate('Id', AID, []);
//  finally
//    if Assigned(EntityList) then
//      EntityList.Free;
//end;


end;

end.
