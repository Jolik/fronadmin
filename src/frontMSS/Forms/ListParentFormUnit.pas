unit ListParentFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms,
  System.Generics.Collections,
  uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, FireDAC.Stan. Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniPanel, uniPageControl, uniSplitter, uniBasicGrid,
  uniDBGrid, uniToolBar, uniGUIBaseClasses,
  EntityUnit, EntityBrokerUnit,
  ParentFormUnit, ParentEditFormUnit;

type
  ///  базовая форма с таблицей-списком
  TListParentForm = class(TParentForm)
    tbEntity: TUniToolBar;
    btnNew: TUniToolButton;
    btnUpdate: TUniToolButton;
    btnRemove: TUniToolButton;
    btnRefresh: TUniToolButton;
    dbgEntity: TUniDBGrid;
    splSplitter: TUniSplitter;
    pcEntityInfo: TUniPageControl;
    DatasourceEntity: TDataSource;
    FDMemTableEntity: TFDMemTable;
    FDMemTableEntityName: TStringField;
    FDMemTableEntityCaption: TStringField;
    FDMemTableEntityCreated: TDateTimeField;
    FDMemTableEntityUpdated: TDateTimeField;
    FDMemTableEntityId: TStringField;
    procedure btnNewClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
  protected
    procedure Refresh(const AId: String = ''); override;

  end;

function ListParentForm: TListParentForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

{  TListParentForm  }

procedure TListParentForm.btnUpdateClick(Sender: TObject);
var
  LEntity: TEntity;
  LId : string;

begin
  PrepareEditForm;

  ///  получаем информацию о выбранном элементе в гриде
  ///  !!!  LId :=
  ///  пока берем первый элемент
  LId := FDMemTableEntity.FieldByName('Id').AsString;
  ///  получаем полную информацию о сущности от брокера
  LEntity := Broker.Info(LId);
  ///  устанавлаием сущность в окно редактирования
  EditForm.Entity := LEntity;

  try
    EditForm.ShowModal(UpdateCallback);
  finally
///  удалять нельзя потому что класс переходит под управление форму редактирования
///    LEntity.Free;
  end;
end;

procedure TListParentForm.btnNewClick(Sender: TObject);
var
  LEntity: TEntity;

begin
  PrepareEditForm;

  ///  создаем класс сущности от брокера
  LEntity := Broker.CreateNew();
  ///  устанавлаием сущность в окно редактирования
  EditForm.Entity := LEntity;

  try
    EditForm.ShowModal(NewCallback);
  finally
///  удалять нельзя потому что класс переходит под управление форму редактирования
///    LEntity.Free;
  end;
end;

procedure TListParentForm.btnRefreshClick(Sender: TObject);
var
  LId : string;

begin
  ///  получаем информацию о выбранном элементе в гриде
  ///  !!!  LId :=
///  Refresh(LId);
   Refresh();
end;

procedure TListParentForm.btnRemoveClick(Sender: TObject);
var
  LId : string;

begin
  ///  получаем информацию о выбранном элементе в гриде
  ///  !!!  LId :=
  ///  пока берем первый элемент
  LId := FDMemTableEntity.FieldByName('Id').AsString;
  ///  получаем полную информацию о сущности от брокера
  if MessageDlg('Удалить задачу?', mtConfirmation, mbYesNo) = mrYes then
  begin
    Broker.Remove(LId);

    Refresh();
  end;
end;

procedure TListParentForm.Refresh(const AId: String = '');
var
  EntityList: TEntityList;
  PageCount: Integer;

begin
  FDMemTableEntity.Active := True;
  EntityList := Broker.List(PageCount);
  try
    FDMemTableEntity.EmptyDataSet;
    for var Entity in EntityList do
    begin
      FDMemTableEntity.Append;
      FDMemTableEntity.FieldByName('Id').AsString := Entity.Id;
      FDMemTableEntity.FieldByName('Name').AsString := Entity.Name;
      FDMemTableEntity.FieldByName('Caption').AsString := Entity.Caption;
      FDMemTableEntity.FieldByName('Created').AsDateTime := Entity.Created;
      FDMemTableEntity.FieldByName('Updated').AsDateTime := Entity.Updated;
      FDMemTableEntity.Post;
    end;
    if AID.IsEmpty then
      FDMemTableEntity.First
    else
      FDMemTableEntity.Locate('Id', AID, []);
  finally
    EntityList.Free;
  end;
end;

procedure TListParentForm.UniFormCreate(Sender: TObject);
begin
  inherited;

  Refresh();
end;

function ListParentForm: TListParentForm;
begin
  Result := TListParentForm(UniMainModule.GetFormInstance(TListParentForm));
  Result.EditForm.Hide;
end;

end.
