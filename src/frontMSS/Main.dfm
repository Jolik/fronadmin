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
  object btnAbonents: TUniButton
    Left = 40
    Top = 96
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1040#1073#1086#1085#1077#1085#1090#1099
    TabOrder = 0
  end
  object btnChannel: TUniButton
    Left = 40
    Top = 264
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1050#1072#1085#1072#1083#1099
    TabOrder = 1
    OnClick = btnChannelClick
  end
  object btnStripTasks: TUniButton
    Left = 40
    Top = 344
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1047#1072#1076#1072#1095#1080
    TabOrder = 2
    OnClick = btnStripTasksClick
  end
end
