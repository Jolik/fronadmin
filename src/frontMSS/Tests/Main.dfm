object MainForm: TMainForm
  Left = 0
  Top = 0
  ClientHeight = 801
  ClientWidth = 1406
  Caption = 'MainForm'
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  TextHeight = 15
  object btnLinkListTest: TUniButton
    Left = 8
    Top = 24
    Width = 75
    Height = 25
    Hint = ''
    Caption = 'Links.List'
    TabOrder = 0
    OnClick = btnLinkListTestClick
  end
  object btnLinkInfo: TUniButton
    Left = 8
    Top = 72
    Width = 75
    Height = 25
    Hint = ''
    Caption = 'Link.Info'
    TabOrder = 1
    OnClick = btnLinkInfoClick
  end
  object ShowMemo: TUniMemo
    Left = 89
    Top = 24
    Width = 561
    Height = 545
    Hint = ''
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object btnTaskList: TUniButton
    Left = 8
    Top = 128
    Width = 75
    Height = 25
    Hint = ''
    Caption = 'Task.List'
    TabOrder = 3
    OnClick = btnTaskListClick
  end
  object btnTaskInfo: TUniButton
    Left = 8
    Top = 216
    Width = 75
    Height = 25
    Hint = ''
    Caption = 'Task.Info'
    TabOrder = 4
    OnClick = btnTaskInfoClick
  end
  object btnStripTaskNew: TUniButton
    Left = 8
    Top = 176
    Width = 75
    Height = 25
    Hint = ''
    Caption = 'Task.New'
    TabOrder = 5
    OnClick = btnStripTaskNewClick
  end
  object btnStripTaskRemove: TUniButton
    Left = 8
    Top = 296
    Width = 75
    Height = 25
    Hint = ''
    Caption = 'Task.Rem'
    TabOrder = 6
    OnClick = btnStripTaskRemoveClick
  end
  object btnStripTaskUpdate: TUniButton
    Left = 8
    Top = 257
    Width = 75
    Height = 25
    Hint = ''
    Caption = 'Task.Update'
    TabOrder = 7
    OnClick = btnStripTaskUpdateClick
  end
end
