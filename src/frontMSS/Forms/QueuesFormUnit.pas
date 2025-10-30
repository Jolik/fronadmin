unit QueuesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ListParentFormUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniPanel, uniPageControl, uniSplitter, uniBasicGrid,
  uniDBGrid, uniToolBar, uniGUIBaseClasses,
  ParentEditFormUnit, EntityUnit,   RestEntityBrokerUnit ,
  RestBrokerBaseUnit, QueuesRestBrokerUnit, uniLabel;

type
  TQueuesForm = class(TListParentForm)
    UniContainerPanel1: TUniContainerPanel;
    UID: TUniLabel;
    lQueuesUIDValue: TUniLabel;
    UniPanel1: TUniPanel;
    cpAllowPut: TUniContainerPanel;
    lAllowPut: TUniLabel;
    lAllowPutValue: TUniLabel;
    UniPanel2: TUniPanel;
    cpDoubles: TUniContainerPanel;
    lDoubles: TUniLabel;
    lDoublesValue: TUniLabel;
    UniPanel3: TUniPanel;
    // Extra blocks from DFM
    cpCmpid: TUniContainerPanel;
    lCmpidValue: TUniLabel;
    cpCounters: TUniContainerPanel;
    lCountersValue: TUniLabel;
    cpLimits: TUniContainerPanel;
    lLimitsValue: TUniLabel;
  protected
    procedure Refresh(const AId: String = ''); override;
    function CreateEditForm(): TParentEditForm; override;
    function CreateRestBroker(): TRestEntityBroker; override;
    procedure OnInfoUpdated(AEntity: TEntity); override;
  end;

function QueuesForm: TQueuesForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, QueueEditFormUnit, QueueUnit;

function QueuesForm: TQueuesForm;
begin
  Result := TQueuesForm(UniMainModule.GetFormInstance(TQueuesForm));
end;

{ TQueuesForm }

function TQueuesForm.CreateEditForm: TParentEditForm;
begin
  Result := QueueEditForm();
end;

procedure TQueuesForm.Refresh(const AId: String = '');
begin
  inherited Refresh(AId);
end;

function TQueuesForm.CreateRestBroker: TRestEntityBroker;
begin
  Result := TQueuesRestBroker.Create(UniMainModule.XTicket);
end;

procedure TQueuesForm.OnInfoUpdated(AEntity: TEntity);
var
  Q: TQueue;
  countersText: string;
  limitsText: string;
begin
  inherited OnInfoUpdated(AEntity);
  if not (AEntity is TQueue) then Exit;

  Q := TQueue(AEntity);
  // for Name show Caption
  lTaskInfoNameValue.Caption := Q.Caption;
  lAllowPutValue.Caption := BoolToStr(Q.AllowPut, True);
  lDoublesValue.Caption := BoolToStr(Q.Doubles, True);
  lQueuesUIDValue.Caption := Q.Uid;

  // cmpid block
  if Assigned(lCmpidValue) then
  begin
    lCmpidValue.Caption := Q.Cmpid;
    if Assigned(cpCmpid) then
      cpCmpid.Visible := not Q.Cmpid.IsEmpty;
  end;

  // counters summary block
  countersText := '';
  if not Q.CountersColor.IsEmpty then
    countersText := 'color=' + Q.CountersColor + '; ';
  countersText := countersText + Format('held=%d; prio1=%d; prio2=%d; prio3=%d; prio4=%d; total=%d',
    [Q.CountersHeld, Q.CountersPrio1, Q.CountersPrio2, Q.CountersPrio3, Q.CountersPrio4, Q.CountersTotal]);
  if Assigned(lCountersValue) then
  begin
    lCountersValue.Caption := countersText;
    if Assigned(cpCounters) then
      cpCounters.Visible := (Q.CountersHeld <> 0) or (Q.CountersPrio1 <> 0) or (Q.CountersPrio2 <> 0) or
                            (Q.CountersPrio3 <> 0) or (Q.CountersPrio4 <> 0) or (Q.CountersTotal <> 0) or
                            (not Q.CountersColor.IsEmpty);
  end;

  // limits summary block
  limitsText := Format('critical=%d; max=%d', [Q.LimitCritical, Q.LimitMax]);
  if Assigned(lLimitsValue) then
  begin
    lLimitsValue.Caption := limitsText;
    if Assigned(cpLimits) then
      cpLimits.Visible := (Q.LimitCritical <> 0) or (Q.LimitMax <> 0);
  end;
end;

end.
