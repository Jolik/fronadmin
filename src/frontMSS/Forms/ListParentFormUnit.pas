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
  ParentFormUnit, ParentEditFormUnit, uniLabel, StrUtils;

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
    tsTaskInfo: TUniTabSheet;
    cpTaskInfo: TUniContainerPanel;
    cpTaskInfoID: TUniContainerPanel;
    lTaskInfoID: TUniLabel;
    lTaskInfoIDValue: TUniLabel;
    cpTaskInfoName: TUniContainerPanel;
    lTaskInfoName: TUniLabel;
    lTaskInfoNameValue: TUniLabel;
    lTaskCaption: TUniLabel;
    pSeparator1: TUniPanel;
    pSeparator2: TUniPanel;
    cpTaskInfoCreated: TUniContainerPanel;
    lTaskInfoCreated: TUniLabel;
    lTaskInfoCreatedValue: TUniLabel;
    pSeparator3: TUniPanel;
    cpTaskInfoUpdated: TUniContainerPanel;
    lTaskInfoUpdated: TUniLabel;
    lTaskInfoUpdatedValue: TUniLabel;
    pSeparator4: TUniPanel;
    procedure btnNewClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure dbgEntitySelectionChange(Sender: TObject);
  protected
    FID: string;
    procedure Refresh(const AId: String = ''); override;
    procedure UpdateCallback(ASender: TComponent; AResult: Integer);
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
  //LId : string;

begin
  PrepareEditForm;

  ///  получаем информацию о выбранном элементе в гриде
  ///  !!!  LId :=
  ///  пока берем первый элемент
  FId := FDMemTableEntity.FieldByName('Id').AsString;
  ///  получаем полную информацию о сущности от брокера
  LEntity := Broker.Info(FId);
  ///  устанавлаием сущность в окно редактирования
  EditForm.Entity := LEntity;

  try
    EditForm.ShowModal(UpdateCallback);
  finally
///  удалять нельзя потому что класс переходит под управление форму редактирования
///    LEntity.Free;
  end;
end;

procedure TListParentForm.dbgEntitySelectionChange(Sender: TObject);
var
  LEntity : TEntity;
  LId     : string;
  DT      : string;
begin
  LId := FDMemTableEntity.FieldByName('Id').AsString;
  ///  получаем полную информацию о сущности от брокера
  LEntity := Broker.Info(LId);
  lTaskInfoIDValue.Caption      := LEntity.ID;
  lTaskInfoNameValue.Caption    := LEntity.Name;
  DateTimeToString(DT, 'dd.mm.yyyy HH:nn', LEntity.Created);
  lTaskInfoCreatedValue.Caption := DT;
  DateTimeToString(DT, 'dd.mm.yyyy HH:nn', LEntity.Updated);
  lTaskInfoUpdatedValue.Caption := DT;

  tsTaskInfo.TabVisible := True;
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
   LId := IfThen(FDMemTableEntity.IsEmpty, '', FDMemTableEntity.FieldByName('Id').AsString);

   Refresh(LId);
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

    if Assigned(EntityList) then
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

    if FDMemTableEntity.IsEmpty then
      tsTaskInfo.TabVisible := False
    else
      if AID.IsEmpty then
        FDMemTableEntity.First
      else
        FDMemTableEntity.Locate('Id', AID, []);
  finally
    if Assigned(EntityList) then
      EntityList.Free;
  end;
end;

procedure TListParentForm.UpdateCallback(ASender: TComponent; AResult: Integer);
begin
  inherited;

  if FID = '' then
    FDMemTableEntity.First
  else
    FDMemTableEntity.Locate('Id', FID, []);
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
