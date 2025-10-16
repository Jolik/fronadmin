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
  object btnAliases: TUniButton
    Left = 40
    Top = 152
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1040#1083#1080#1072#1089#1099
    TabOrder = 6
    OnClick = btnAliasesClick
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
    Caption = 'Strip '#1047#1072#1076#1072#1095#1080
    TabOrder = 2
    OnClick = btnStripTasksClick
  end
  object btnLinks: TUniButton
    Left = 40
    Top = 208
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1051#1080#1085#1082#1080
    TabOrder = 3
    OnClick = btnLinksClick
  end
  object btnSummTask: TUniButton
    Left = 40
    Top = 392
    Width = 75
    Height = 25
    Hint = ''
    Caption = 'Summary '#1047#1072#1076#1072#1095#1080
    TabOrder = 4
    OnClick = btnSummTaskClick
  end
  object btnRouterSources: TUniButton
    Left = 40
    Top = 304
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1048#1089#1090#1086#1095#1085#1080#1082#1080
    TabOrder = 5
    OnClick = btnRouterSourcesClick
  end
end
