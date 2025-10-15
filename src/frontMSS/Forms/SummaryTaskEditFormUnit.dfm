inherited SummaryTaskEditForm: TSummaryTaskEditForm
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077'/'#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1079#1072#1076#1072#1095#1080'...'
  TextHeight = 15
  inherited pnCaption: TUniContainerPanel
    inherited teCaption: TUniEdit
      Left = 84
      Width = 732
      ExplicitLeft = 84
      ExplicitWidth = 724
    end
  end
  inherited pnName: TUniContainerPanel
    inherited teName: TUniEdit
      Left = 84
      Width = 732
      ExplicitLeft = 84
      ExplicitWidth = 724
    end
  end
  inherited pnClient: TUniContainerPanel
    ExplicitTop = 54
    object lTid: TUniLabel
      Left = 24
      Top = 16
      Width = 80
      Height = 13
      Hint = ''
      Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
      TabOrder = 0
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
      Width = 66
      Height = 13
      Hint = ''
      Caption = 'CompId'
      TabOrder = 1
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
      Width = 55
      Height = 13
      Hint = ''
      Caption = 'DepId'
      TabOrder = 2
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
      Width = 43
      Height = 13
      Hint = ''
      Caption = #1052#1086#1076#1091#1083#1100
      TabOrder = 3
    end
    object teModule: TUniEdit
      Left = 160
      Top = 108
      Width = 320
      Height = 21
      Hint = ''
      Text = ''
      TabOrder = 3
    end
    object lDef: TUniLabel
      Left = 24
      Top = 144
      Width = 55
      Height = 13
      Hint = ''
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077
      TabOrder = 4
    end
    object meDef: TUniMemo
      Left = 160
      Top = 140
      Width = 320
      Height = 64
      Hint = ''
      Lines.Strings = (
        '')
      TabOrder = 4
    end
    object cbEnabled: TUniCheckBox
      Left = 160
      Top = 212
      Width = 97
      Height = 21
      Hint = ''
      Caption = #1040#1082#1090#1080#1074#1085#1086
      TabOrder = 5
    end
    object lLatePeriod: TUniLabel
      Left = 24
      Top = 248
      Width = 62
      Height = 13
      Hint = ''
      Caption = 'LatePeriod'
      TabOrder = 6
    end
    object teLatePeriod: TUniEdit
      Left = 160
      Top = 244
      Width = 120
      Height = 21
      Hint = ''
      Text = ''
      TabOrder = 6
    end
    object lCustomMeteo: TUniLabel
      Left = 24
      Top = 280
      Width = 84
      Height = 13
      Hint = ''
      Caption = 'Custom.Meteo'
      TabOrder = 7
    end
    object cbCustomMeteo: TUniCheckBox
      Left = 160
      Top = 276
      Width = 97
      Height = 21
      Hint = ''
      Caption = #1044#1072
      TabOrder = 7
    end
    object lCustomAnyTime: TUniLabel
      Left = 24
      Top = 312
      Width = 103
      Height = 13
      Hint = ''
      Caption = 'Custom.AnyTime'
      TabOrder = 8
    end
    object teCustomAnyTime: TUniEdit
      Left = 160
      Top = 308
      Width = 120
      Height = 21
      Hint = ''
      Text = ''
      TabOrder = 8
    end
    object lCustomSeparate: TUniLabel
      Left = 24
      Top = 344
      Width = 108
      Height = 13
      Hint = ''
      Caption = 'Custom.Separate'
      TabOrder = 9
    end
    object cbCustomSeparate: TUniCheckBox
      Left = 160
      Top = 340
      Width = 97
      Height = 21
      Hint = ''
      Caption = #1044#1072
      TabOrder = 9
    end
    object lExcludeWeek: TUniLabel
      Left = 24
      Top = 376
      Width = 78
      Height = 13
      Hint = ''
      Caption = 'ExcludeWeek'
      TabOrder = 10
    end
    object teExcludeWeek: TUniEdit
      Left = 160
      Top = 372
      Width = 200
      Height = 21
      Hint = ''
      Text = ''
      TabOrder = 10
    end
  end
end
