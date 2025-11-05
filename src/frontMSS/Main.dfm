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
  OnCreate = UniFormCreate
  OnDestroy = UniFormDestroy
  TextHeight = 15
  object btnAliases: TUniButton
    Left = 40
    Top = 120
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1040#1083#1080#1072#1089#1099
    TabOrder = 5
    OnClick = btnAliasesClick
  end
  object btnChannel: TUniButton
    Left = 40
    Top = 264
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1050#1072#1085#1072#1083#1099
    TabOrder = 0
    OnClick = btnChannelClick
  end
  object btnStripTasks: TUniButton
    Left = 40
    Top = 344
    Width = 75
    Height = 25
    Hint = ''
    Caption = 'Strip '#1047#1072#1076#1072#1095#1080
    TabOrder = 1
    OnClick = btnStripTasksClick
  end
  object btnLinks: TUniButton
    Left = 40
    Top = 160
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1051#1080#1085#1082#1080
    TabOrder = 2
    OnClick = btnLinksClick
  end
  object btnQueues: TUniButton
    Left = 40
    Top = 233
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1054#1095#1077#1088#1077#1076#1080
    TabOrder = 15
    OnClick = btnQueuesClick
  end
  object btnSummTask: TUniButton
    Left = 40
    Top = 383
    Width = 75
    Height = 25
    Hint = ''
    Caption = 'Summary '#1047#1072#1076#1072#1095#1080
    TabOrder = 3
    OnClick = btnSummTaskClick
  end
  object btnRouterSources: TUniButton
    Left = 40
    Top = 304
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1048#1089#1090#1086#1095#1085#1080#1082#1080
    TabOrder = 4
    OnClick = btnRouterSourcesClick
  end
  object btnAbonents: TUniButton
    Left = 40
    Top = 80
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1040#1073#1086#1085#1077#1085#1090#1099
    TabOrder = 6
    OnClick = btnAliasesClick
  end
  object btnDSProcessorTasks: TUniButton
    Left = 40
    Top = 464
    Width = 75
    Height = 25
    Hint = ''
    Caption = 'DSProc '#1047#1072#1076#1072#1095#1080
    TabOrder = 7
    OnClick = btnDSProcessorTasksClick
  end
  object btnRules: TUniButton
    Left = 40
    Top = 504
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1055#1088#1072#1074#1080#1083#1072
    TabOrder = 8
    OnClick = btnRulesClick
  end
  object UniButton1: TUniButton
    Left = 40
    Top = 423
    Width = 75
    Height = 25
    Hint = ''
    Caption = 'Monitoring '#1047#1072#1076#1072#1095#1080
    TabOrder = 9
    OnClick = UniButton1Click
  end
  object cbCurDept: TUniComboBox
    Left = 304
    Top = 44
    Width = 145
    Hint = ''
    Style = csDropDownList
    Text = ''
    TabOrder = 10
    IconItems = <>
  end
  object UniLabel1: TUniLabel
    Left = 227
    Top = 47
    Width = 71
    Height = 13
    Hint = ''
    Caption = #1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090
    TabOrder = 11
  end
  object cbCurComp: TUniComboBox
    Left = 304
    Top = 19
    Width = 145
    Hint = ''
    Text = ''
    TabOrder = 12
    IconItems = <>
    OnChange = cbCurCompChange
  end
  object UniLabel2: TUniLabel
    Left = 227
    Top = 25
    Width = 54
    Height = 13
    Hint = ''
    Caption = #1050#1086#1084#1087#1072#1085#1080#1103
    TabOrder = 13
  end
  object btnHandlers: TUniButton
    Left = 40
    Top = 200
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1054#1073#1088#1072#1073#1086#1090#1095#1080#1082#1080
    TabOrder = 14
    OnClick = btnHandlersClick
  end
  object unbtnSources: TUniButton
    Left = 40
    Top = 544
    Width = 75
    Height = 25
    Hint = ''
    Caption = #1048#1089#1090#1086#1095#1085#1080#1082#1080
    TabOrder = 16
    OnClick = unbtnSourcesClick
  end
end
