unit ListParentFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms,
  System.Generics.Collections,
  uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniPanel, uniPageControl, uniSplitter, uniBasicGrid,
  uniDBGrid, uniToolBar, uniGUIBaseClasses,
  EntityUnit,   ParentFormUnit, ParentEditFormUnit, uniLabel, StrUtils,
  RestBrokerBaseUnit, BaseRequests, BaseResponses, HttpClientUnit;

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
    FSelectedEntity: TEntity;
    procedure OnAddListItem(item: TEntity);virtual;
    procedure Refresh(const AId: String = ''); override;
    function UpdateCallback(const AID: string; AEntity: TFieldSet):Boolean;
    procedure OnInfoUpdated(AEntity: TEntity);virtual;
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
  PrepareEditForm(true);

  ///  получаем информацию о выбранном элементе в гриде
  ///  !!!  LId :=
  ///  пока берем первый элемент
  FId := FDMemTableEntity.FieldByName('Id').AsString;
  var Req := RestBroker.CreateReqInfo();
  Req.Id := FId;
  var Resp := RestBroker.Info(Req);
  ///  устанавлаием сущность в окно редактирования
  EditForm.Entity := Resp.Entity;
  EditForm.Id := FId;

  try
    EditForm.ShowModalEx(UpdateCallback);
  finally
///  удалять нельзя потому что класс переходит под управление форму редактирования
///    LEntity.Free;
  end;
end;

procedure TListParentForm.dbgEntitySelectionChange(Sender: TObject);
var
  LId     : string;
begin
  FSelectedEntity.Free;
  LId := FDMemTableEntity.FieldByName('Id').AsString;
  if Assigned(RestBroker) then
  begin
    var Resp := RestBroker.Info(RestBroker.CreateReqInfo(LId));
    FSelectedEntity := Resp.Entity as TEntity;
    if not Assigned(FSelectedEntity) then Exit;
    OnInfoUpdated(FSelectedEntity);
  end;
end;

procedure TListParentForm.OnAddListItem(item: TEntity);
begin
  FDMemTableEntity.FieldByName('Id').AsString := item.Id;
  FDMemTableEntity.FieldByName('Name').AsString := item.Name;
  FDMemTableEntity.FieldByName('def').AsString := item.Def;
  FDMemTableEntity.FieldByName('Created').AsDateTime := item.Created;
  FDMemTableEntity.FieldByName('Updated').AsDateTime := item.Updated;
end;

procedure TListParentForm.OnInfoUpdated(AEntity: TEntity);
var
   DT      : string;
begin
  lTaskInfoIDValue.Caption      := AEntity.ID;
  lTaskInfoNameValue.Caption    := AEntity.Name;
  DateTimeToString(DT, 'dd.mm.yyyy HH:nn', AEntity.Created);
  lTaskInfoCreatedValue.Caption := DT;
  DateTimeToString(DT, 'dd.mm.yyyy HH:nn', AEntity.Updated);
  lTaskInfoUpdatedValue.Caption := DT;
  tsTaskInfo.TabVisible := True;
end;

procedure TListParentForm.btnNewClick(Sender: TObject);
var
  LEntity: TEntity;

begin
  PrepareEditForm;

  ///  создаем класс сущности от брокера
  var req := RestBroker.CreateReqNew();
  ///  устанавлаием сущность в окно редактирования
  EditForm.Entity := req.NewBody;

  try
    EditForm.ShowModalEx(NewCallback);
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
  MessageDlg('Удалить задачу?', mtConfirmation, [mbYes, mbNo],
    procedure(Sender: TComponent; Res: Integer)
    begin
      if Res = mrYes then
      begin
        var R := RestBroker.CreateReqRemove();
        if not Assigned(R) then
          R := TReqRemove.Create;
        R.Id := LId;
        var JR := RestBroker.Remove(R);
        JR.Free;
        Refresh();
      end;
    end
  );
end;

procedure TListParentForm.Refresh(const AId: String = '');
var
  EntityList: TEntityList;
  PageCount: Integer;
  Resp: TListResponse;

begin
  FDMemTableEntity.Active := True;
  Resp := nil;
  EntityList := nil;
  if Assigned(RestBroker) then
  begin
    // Сначала пытаемся спросить у брокера фабрикой
    var Req := RestBroker.CreateReqList();
    Resp := RestBroker.List(Req);
    if Assigned(Resp) then
      EntityList := Resp.EntityList
  end;
  try
    FDMemTableEntity.EmptyDataSet;

    if Assigned(EntityList) then
      for var Entity in EntityList do
      begin
        FDMemTableEntity.Append;
        OnAddListItem(Entity);
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
    if Assigned(Resp) then
      Resp.Free
    else if Assigned(EntityList) then
      EntityList.Free;
  end;
end;

function TListParentForm.UpdateCallback(const AID: string; AEntity: TFieldSet):boolean;
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

