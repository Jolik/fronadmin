inherited DSProcessorTaskEditForm: TDSProcessorTaskEditForm
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077'/'#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' DSProcessor'
  TextHeight = 15
  inherited pnBottom: TUniContainerPanel
    ExplicitTop = 468
    ExplicitWidth = 819
    inherited btnOk: TUniButton
      ExplicitLeft = 660
    end
    inherited btnCancel: TUniButton
      ExplicitLeft = 741
    end
  end
  inherited pnCaption: TUniContainerPanel
    ExplicitWidth = 819
    inherited teCaption: TUniEdit
      Left = 78
      Width = 738
      ExplicitLeft = 78
      ExplicitWidth = 738
    end
  end
  inherited pnName: TUniContainerPanel
    ExplicitWidth = 819
    inherited teName: TUniEdit
      Left = 78
      Width = 738
      ExplicitLeft = 78
      ExplicitWidth = 738
    end
  end
  inherited pnClient: TUniContainerPanel
    ExplicitWidth = 819
    ExplicitHeight = 414
    object lTid: TUniLabel
      Left = 16
      Top = 16
      Width = 15
      Height = 13
      Hint = ''
      Caption = 'Tid'
      TabOrder = 1
    end
    object teTid: TUniEdit
      Left = 16
      Top = 35
      Width = 200
      Hint = ''
      Text = ''
      TabOrder = 2
    end
    object lCompId: TUniLabel
      Left = 240
      Top = 16
      Width = 36
      Height = 13
      Hint = ''
      Caption = 'CompId'
      TabOrder = 3
    end
    object teCompId: TUniEdit
      Left = 240
      Top = 35
      Width = 200
      Hint = ''
      Text = ''
      TabOrder = 4
    end
    object lDepId: TUniLabel
      Left = 464
      Top = 16
      Width = 32
      Height = 13
      Hint = ''
      Caption = 'DepId'
      TabOrder = 5
    end
    object teDepId: TUniEdit
      Left = 464
      Top = 35
      Width = 200
      Hint = ''
      Text = ''
      TabOrder = 6
    end
    object lModule: TUniLabel
      Left = 16
      Top = 75
      Width = 41
      Height = 13
      Hint = ''
      Caption = #1052#1086#1076#1091#1083#1100
      TabOrder = 7
    end
    object cbModule: TUniComboBox
      Left = 16
      Top = 94
      Width = 200
      Hint = ''
      Style = csDropDown
      Text = ''
      Items.Strings = ()
      TabOrder = 8
      IconItems = <>
    end
    object cbEnabled: TUniCheckBox
      Left = 240
      Top = 96
      Width = 97
      Height = 17
      Hint = ''
      Caption = #1042#1082#1083#1102#1095#1077#1085#1086
      TabOrder = 9
    end
    object lDef: TUniLabel
      Left = 16
      Top = 134
      Width = 52
      Height = 13
      Hint = ''
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077
      TabOrder = 10
    end
    object meDef: TUniMemo
      Left = 16
      Top = 153
      Width = 648
      Height = 120
      Hint = ''
      ScrollBars = ssVertical
      TabOrder = 11
    end
    object pnSources: TUniContainerPanel
      Left = 0
      Top = 294
      Width = 819
      Height = 120
      Hint = ''
      ParentColor = False
      Align = alBottom
      TabOrder = 12
      object lSources: TUniLabel
        Left = 16
        Top = 8
        Width = 67
        Height = 13
        Hint = ''
        Caption = #1048#1089#1090#1086#1095#1085#1080#1082#1080
        TabOrder = 1
      end
      object lbTaskSources: TUniListBox
        Left = 0
        Top = 32
        Width = 819
        Height = 88
        Hint = ''
        Align = alClient
        MultiSelect = True
        TabOrder = 2
      end
    end
  end
end
