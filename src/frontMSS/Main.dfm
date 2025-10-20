object MainForm: TMainForm
  Left = 0
  Top = 0
  ClientHeight = 722
  ClientWidth = 798
  Caption = 'MainForm'
  BorderStyle = bsNone
  WindowState = wsMaximized
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  Movable = False
  PageMode = True
  TextHeight = 15
  object btnStripTasks: TUniButton
    Left = 48
    Top = 104
    Width = 150
    Height = 25
    Hint = ''
    Caption = 'Strip '#1047#1072#1076#1072#1095#1080
    TabOrder = 0
    OnClick = btnStripTasksClick
  end
  object btnSummTask: TUniButton
    Left = 48
    Top = 152
    Width = 150
    Height = 25
    Hint = ''
    Caption = 'Summary '#1047#1072#1076#1072#1095#1080
    TabOrder = 1
    OnClick = btnSummTaskClick
  end
  object btnMonitoringTasks: TUniButton
    Left = 48
    Top = 200
    Width = 150
    Height = 25
    Hint = ''
    Caption = 'Monitoring '#1047#1072#1076#1072#1095#1080
    TabOrder = 2
    OnClick = btnMonitoringTasksClick
  end
end
