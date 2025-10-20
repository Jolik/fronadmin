inherited SummaryTaskEditForm: TSummaryTaskEditForm
  ClientWidth = 1349
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077'/'#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1079#1072#1076#1072#1095#1080'...'
  ExplicitWidth = 1365
  TextHeight = 15
  inherited pnBottom: TUniContainerPanel
    Width = 1349
    ExplicitWidth = 1349
    inherited btnOk: TUniButton
      Left = 1190
      ExplicitLeft = 1190
    end
    inherited btnCancel: TUniButton
      Left = 1271
      ExplicitLeft = 1271
    end
  end
  inherited pnCaption: TUniContainerPanel
    Width = 1349
    ExplicitWidth = 1349
    inherited teCaption: TUniEdit
      Left = 84
      Width = 1262
      ExplicitLeft = 84
      ExplicitWidth = 1262
    end
  end
  inherited pnName: TUniContainerPanel
    Width = 1349
    ExplicitWidth = 1349
    inherited teName: TUniEdit
      Left = 84
      Width = 1262
      ExplicitLeft = 84
      ExplicitWidth = 1262
    end
  end
  inherited pnClient: TUniContainerPanel
    Width = 497
    Align = alLeft
    ExplicitWidth = 497
    ScrollHeight = 414
    ScrollWidth = 497
    object lTid: TUniLabel
      Left = 24
      Top = 16
      Width = 86
      Height = 13
      Hint = ''
      Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
      TabOrder = 11
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
      TabOrder = 12
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
      TabOrder = 14
    end
    object lDef: TUniLabel
      Left = 24
      Top = 144
      Width = 54
      Height = 13
      Hint = ''
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077
      TabOrder = 15
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
      TabOrder = 16
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
    object lCustomMeteo: TUniLabel
      Left = 24
      Top = 280
      Width = 75
      Height = 13
      Hint = ''
      Caption = 'Custom.Meteo'
      TabOrder = 17
    end
    object cbCustomMeteo: TUniCheckBox
      Left = 160
      Top = 276
      Width = 97
      Height = 21
      Hint = ''
      Caption = #1044#1072
      TabOrder = 6
    end
    object lCustomAnyTime: TUniLabel
      Left = 24
      Top = 312
      Width = 84
      Height = 13
      Hint = ''
      Caption = 'Custom.AnyTime'
      TabOrder = 18
    end
    object teCustomAnyTime: TUniEdit
      Left = 160
      Top = 308
      Width = 120
      Height = 21
      Hint = ''
      Text = ''
      TabOrder = 7
    end
    object lCustomSeparate: TUniLabel
      Left = 24
      Top = 344
      Width = 87
      Height = 13
      Hint = ''
      Caption = 'Custom.Separate'
      TabOrder = 19
    end
    object cbCustomSeparate: TUniCheckBox
      Left = 160
      Top = 340
      Width = 97
      Height = 21
      Hint = ''
      Caption = #1044#1072
      TabOrder = 8
    end
    object lExcludeWeek: TUniLabel
      Left = 24
      Top = 376
      Width = 68
      Height = 13
      Hint = ''
      Caption = 'ExcludeWeek'
      TabOrder = 20
    end
    object teExcludeWeek: TUniEdit
      Left = 160
      Top = 372
      Width = 200
      Height = 21
      Hint = ''
      Text = ''
      TabOrder = 9
    end
    object cbModule: TUniComboBox
      Left = 160
      Top = 108
      Width = 320
      Hint = ''
      Style = csDropDownList
      Text = 'SummarySynop'
      Items.Strings = (
        'SummarySynop'
        'SummaryHydra'
        'SummaryCXML'
        'SummarySEBA')
      ItemIndex = 0
      TabOrder = 21
      IconItems = <>
    end
  end
  object pnCustomSettings: TUniContainerPanel
    Left = 984
    Top = 54
    Width = 365
    Height = 414
    Hint = ''
    ParentColor = False
    Align = alRight
    TabOrder = 4
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
  end
end
