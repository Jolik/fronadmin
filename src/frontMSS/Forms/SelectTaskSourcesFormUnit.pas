unit SelectTaskSourcesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniGUIBaseClasses, uniMultiItem, uniListBox,
  uniPanel, uniLabel, uniPageControl,
  TaskSourceUnit, SourceUnit, SourcesBrokerUnit;

type
  TSelectTaskSourcesForm = class(TUniForm)
    lbTaskSources: TUniListBox;
    lbAllSources: TUniListBox;
    pcEntityInfo: TUniPageControl;
    tsTaskInfo: TUniTabSheet;
    cpTaskInfo: TUniContainerPanel;
    cpTaskInfoID: TUniContainerPanel;
    lTaskInfoID: TUniLabel;
    lTaskInfoIDValue: TUniLabel;
    pSeparator1: TUniPanel;
    cpTaskInfoName: TUniContainerPanel;
    lTaskInfoName: TUniLabel;
    lTaskInfoNameValue: TUniLabel;
    pSeparator2: TUniPanel;
    lTaskCaption: TUniLabel;
    cpTaskInfoCreated: TUniContainerPanel;
    lTaskInfoCreated: TUniLabel;
    lTaskInfoCreatedValue: TUniLabel;
    pSeparator3: TUniPanel;
    cpTaskInfoUpdated: TUniContainerPanel;
    lTaskInfoUpdated: TUniLabel;
    lTaskInfoUpdatedValue: TUniLabel;
    pSeparator4: TUniPanel;
    cpTaskInfoModule: TUniContainerPanel;
    lTaskInfoModule: TUniLabel;
    lTaskInfoModuleValue: TUniLabel;
    pSeparator5: TUniPanel;

  private
    ///  брокер для получения всех Источников системы
    AllSourcesBroker: TSourcesBroker;
    //  все источники системы
    AllSourceList: TSourceList;
    ///  список Источников задачи
    FTaskSourceList: TTaskSourceList;
    procedure SetTaskSourceList(const Value: TTaskSourceList);

  public
    ///  список Источников задачи
    property TaskSourceList: TTaskSourceList read FTaskSourceList write SetTaskSourceList;

  end;

function SelectTaskSourcesForm: TSelectTaskSourcesForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function SelectTaskSourcesForm: TSelectTaskSourcesForm;
begin
  Result := TSelectTaskSourcesForm(UniMainModule.GetFormInstance(TSelectTaskSourcesForm));
end;

{ TSelectTaskSourcesForm }

procedure TSelectTaskSourcesForm.SetTaskSourceList(
  const Value: TTaskSourceList);
begin
end;

end.
