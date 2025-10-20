unit SharedFrameSchedule;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  ScheduleSettingsUnit,
  uniGUIClasses, uniGUIFrame, uniGUIBaseClasses, uniPanel, uniGroupBox,
  SharedFrameTextInput, SharedFrameBoolInput, uniButton, uniBitBtn,
  uniMultiItem, uniBasicGrid, uniStringGrid, uniComboBox;

type
  TFrameSchedule = class(TUniFrame)
    UniGroupBox1: TUniGroupBox;
    UniPanel1: TUniPanel;
    FrameScheduleCron: TFrameTextInput;
    FrameSchedulePeriod: TFrameTextInput;
    FrameScheduleEnabled: TFrameBoolInput;
    FrameScheduleRetry: TFrameTextInput;
    FrameScheduleDelay: TFrameTextInput;
    UniPanel3: TUniPanel;
    btnRemoveJob: TUniBitBtn;
    btnAddJob: TUniBitBtn;
    JobsComboBox: TUniComboBox;
    procedure FrameScheduleCronEditChange(Sender: TObject);
    procedure FrameSchedulePeriodEditChange(Sender: TObject);
    procedure FrameScheduleRetryEditChange(Sender: TObject);
    procedure FrameScheduleDelayEditChange(Sender: TObject);
    procedure FrameScheduleEnabledCheckBoxChange(Sender: TObject);
    procedure btnRemoveJobClick(Sender: TObject);
    procedure btnAddJobClick(Sender: TObject);
    procedure JobsComboBoxSelect(Sender: TObject);
  private
    FSettings: TWorkSettings;
    FCurrentJob: TSheduleSettings; // ссылка на один из FSettings.List.Shedules
    procedure DrawSchedule(srs: TSheduleSettings);
    procedure ReadSchedule(dst: TSheduleSettings);
    procedure DrawJobs();
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetData(src: TWorkSettings); virtual;
    procedure GetData(dst: TWorkSettings); virtual;
  end;

implementation

{$R *.dfm}



{ TUniFrame1 }



constructor TFrameSchedule.Create(AOwner: TComponent);
begin
  inherited;
  FSettings := TWorkSettings.Create;
end;

destructor TFrameSchedule.Destroy;
begin
  FSettings.Free;
  inherited;
end;



procedure TFrameSchedule.DrawSchedule(srs: TSheduleSettings);
begin
  if srs = nil then
  begin
    FrameScheduleEnabled.SetData(false);
    FrameScheduleCron.SetData('');
    FrameSchedulePeriod.SetData('');
    FrameScheduleRetry.SetData('');
    FrameScheduleDelay.SetData('');
    exit;
  end;
  FrameScheduleEnabled.SetData(not srs.Disabled);
  FrameScheduleCron.SetData(srs.CronString); // TODO: user friendly cron editor
  FrameSchedulePeriod.SetData(srs.Period);
  FrameScheduleRetry.SetData(srs.RetryCount);
  FrameScheduleDelay.SetData(srs.Delay);
end;



procedure TFrameSchedule.ReadSchedule(dst: TSheduleSettings);
begin
  dst.Disabled := not FrameScheduleEnabled.GetData;
  dst.CronString := FrameScheduleCron.GetDataStr;
  dst.Period  := FrameSchedulePeriod.GetDataInt;
  dst.RetryCount  := FrameScheduleRetry.GetDataInt;
  dst.Delay  := FrameScheduleDelay.GetDataInt;
end;


procedure TFrameSchedule.GetData(dst: TWorkSettings);
begin
  dst.Assign(FSettings);
end;


procedure TFrameSchedule.SetData(src: TWorkSettings);
begin
  FSettings.Assign(src);
  DrawJobs();
end;


function FormatJobStr(index: integer; s: TSheduleSettings): string;
begin
  result := format('%d.   (%s)',[index, s.CronString])
end;

procedure TFrameSchedule.DrawJobs();
begin
  JobsComboBox.Clear;
  for var i := 0 to  FSettings.List.Count-1 do
    JobsComboBox.Items.AddObject(FormatJobStr(i+1, FSettings.List.Shedules[i]), FSettings.List.Shedules[i]);
  if JobsComboBox.Items.Count > 0 then
  begin
    JobsComboBox.ItemIndex := 0;
    JobsComboBoxSelect(self);
  end;
end;


procedure TFrameSchedule.btnRemoveJobClick(Sender: TObject);
begin
  if FCurrentJob = nil then
    exit;
  var q := Format('Удалить расписание "%s"?', [FCurrentJob.CronString]);
  if MessageDlg(q, mtConfirmation, mbYesNo) <> mrYes then
    exit;
  FSettings.List.Remove(FCurrentJob);
  FCurrentJob := nil;
  DrawJobs();
end;

procedure TFrameSchedule.btnAddJobClick(Sender: TObject);
begin
  var schedule := TSheduleSettings.Create;
  schedule.CronString := '* 0 * * * *';
  FSettings.List.Add(schedule);
  DrawJobs();
end;



procedure TFrameSchedule.JobsComboBoxSelect(Sender: TObject);
begin
  FCurrentJob := nil;
  if JobsComboBox.ItemIndex = -1 then
    exit;
  FCurrentJob := JobsComboBox.Items.Objects[JobsComboBox.ItemIndex] as TSheduleSettings;
  DrawSchedule(FCurrentJob);
end;


// очередной баг. один обработчик всем ставить нельзя.
procedure TFrameSchedule.FrameScheduleCronEditChange(Sender: TObject);
begin
  if FCurrentJob = nil then
    exit;
  ReadSchedule(FCurrentJob);
end;
procedure TFrameSchedule.FrameScheduleDelayEditChange(Sender: TObject);
begin
  if FCurrentJob = nil then
    exit;
  ReadSchedule(FCurrentJob);
end;
procedure TFrameSchedule.FrameScheduleEnabledCheckBoxChange(Sender: TObject);
begin
  if FCurrentJob = nil then
    exit;
  ReadSchedule(FCurrentJob);
end;
procedure TFrameSchedule.FrameSchedulePeriodEditChange(Sender: TObject);
begin
  if FCurrentJob = nil then
    exit;
  ReadSchedule(FCurrentJob);
end;
procedure TFrameSchedule.FrameScheduleRetryEditChange(Sender: TObject);
begin
  if FCurrentJob = nil then
    exit;
  ReadSchedule(FCurrentJob);
end;


end.
