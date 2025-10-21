inherited SummaryTaskEditForm: TSummaryTaskEditForm
  ClientWidth = 1349
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077'/'#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1079#1072#1076#1072#1095#1080'...'
  ExplicitLeft = 4
  ExplicitTop = 4
  ExplicitWidth = 1365
  ExplicitHeight = 557
  TextHeight = 15
  inherited pnBottom: TUniContainerPanel
    Width = 1349
    ExplicitTop = 443
    ExplicitWidth = 1341
    inherited btnOk: TUniButton
      Left = 1190
      ExplicitLeft = 1182
    end
    inherited btnCancel: TUniButton
      Left = 1271
      ExplicitLeft = 1263
    end
  end
  inherited pnCaption: TUniContainerPanel
    Width = 1349
    ExplicitWidth = 1341
    inherited teCaption: TUniEdit
      Left = 84
      Width = 1262
      ExplicitLeft = 84
      ExplicitWidth = 1254
    end
  end
  inherited pnName: TUniContainerPanel
    Width = 1349
    ExplicitWidth = 1341
    inherited teName: TUniEdit
      Left = 84
      Width = 1262
      ExplicitLeft = 84
      ExplicitWidth = 1254
    end
  end
  inherited pnClient: TUniContainerPanel
    Width = 497
    Align = alLeft
    ExplicitWidth = 497
    ExplicitHeight = 389
    ScrollHeight = 414
    ScrollWidth = 497
    object lTid: TUniLabel
      Left = 24
      Top = 16
      Width = 86
      Height = 13
      Hint = ''
      Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
      TabOrder = 9
    end
    object teTid: TUniEdit
      Left = 160
      Top = 12
      Width = 320
      Height = 21
      Hint = ''
      Text = ''
      TabOrder = 0
    end
    object lCompId: TUniLabel
      Left = 24
      Top = 48
      Width = 40
      Height = 13
      Hint = ''
      Caption = 'CompId'
      TabOrder = 11
    end
    object teCompId: TUniEdit
      Left = 160
      Top = 44
      Width = 320
      Height = 21
      Hint = ''
      Text = ''
      TabOrder = 1
    end
    object lDepId: TUniLabel
      Left = 24
      Top = 80
      Width = 31
      Height = 13
      Hint = ''
      Caption = 'DepId'
      TabOrder = 13
    end
    object teDepId: TUniEdit
      Left = 160
      Top = 76
      Width = 320
      Height = 21
      Hint = ''
      Text = ''
      TabOrder = 2
    end
    object lModule: TUniLabel
      Left = 24
      Top = 112
      Width = 40
      Height = 13
      Hint = ''
      Caption = #1052#1086#1076#1091#1083#1100
      TabOrder = 7
    end
    object lDef: TUniLabel
      Left = 24
      Top = 144
      Width = 54
      Height = 13
      Hint = ''
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077
      TabOrder = 8
    end
    object meDef: TUniMemo
      Left = 160
      Top = 140
      Width = 320
      Height = 64
      Hint = ''
      Lines.Strings = (
        '')
      TabOrder = 3
    end
    object cbEnabled: TUniCheckBox
      Left = 160
      Top = 212
      Width = 97
      Height = 21
      Hint = ''
      Caption = #1040#1082#1090#1080#1074#1085#1086
      TabOrder = 4
    end
    object lLatePeriod: TUniLabel
      Left = 24
      Top = 248
      Width = 54
      Height = 13
      Hint = ''
      Caption = 'LatePeriod'
      TabOrder = 10
    end
    object teLatePeriod: TUniEdit
      Left = 160
      Top = 244
      Width = 120
      Height = 21
      Hint = ''
      Text = ''
      TabOrder = 5
    end
    object cbModule: TUniComboBox
      Left = 160
      Top = 108
      Width = 320
      Hint = ''
      Style = csDropDownList
      Text = 'SummaryUnknown'
      Items.Strings = (
        'SummarySynop'
        'SummaryHydra'
        'SummaryCXML'
        'SummarySEBA'
        'SummaryUnknown')
      ItemIndex = 4
      TabOrder = 12
      IconItems = <>
      OnChange = cbModuleChange
    end
  end
  object pnCustomSettings: TUniContainerPanel
    Left = 984
    Top = 54
    Width = 365
    Height = 414
    Hint = ''
    Visible = False
    ParentColor = False
    Align = alRight
    TabOrder = 4
    ExplicitLeft = 976
    ExplicitHeight = 389
  end
  object pnSources: TUniContainerPanel
    Left = 497
    Top = 54
    Width = 487
    Height = 414
    Hint = ''
    ParentColor = False
    Align = alClient
    TabOrder = 5
    ExplicitWidth = 479
    ExplicitHeight = 389
    object lbTaskSources: TUniListBox
      Left = 0
      Top = 76
      Width = 487
      Height = 338
      Hint = ''
      Align = alBottom
      MultiSelect = True
      TabOrder = 1
      ExplicitTop = 51
      ExplicitWidth = 479
    end
    object btnSourcesEdit: TUniButton
      Left = 24
      Top = 16
      Width = 120
      Height = 25
      Hint = ''
      Caption = 'Изменить источники'
      TabOrder = 2
      OnClick = btnSourcesEditClick
    end
  end
end
