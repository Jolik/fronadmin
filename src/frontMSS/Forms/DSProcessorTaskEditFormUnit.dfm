inherited DSProcessorTaskEditForm: TDSProcessorTaskEditForm
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077'/'#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1079#1072#1076#1072#1095#1080'...'
  TextHeight = 15
  inherited pnCaption: TUniContainerPanel
    inherited teCaption: TUniEdit
      Left = 86
      Width = 730
      ExplicitLeft = 86
      ExplicitWidth = 730
    end
  end
  inherited pnName: TUniContainerPanel
    inherited teName: TUniEdit
      Left = 86
      Width = 730
      ExplicitLeft = 86
      ExplicitWidth = 730
    end
  end
  inherited pnClient: TUniContainerPanel
    ScrollHeight = 414
    ScrollWidth = 819
    object lModule: TUniLabel
      Left = 40
      Top = 45
      Width = 40
      Height = 13
      Hint = ''
      Caption = #1052#1086#1076#1091#1083#1100
      TabOrder = 1
    end
    object cbModule: TUniComboBox
      Left = 64
      Top = 64
      Width = 121
      Hint = ''
      Style = csDropDownList
      Text = 'Synop'
      Items.Strings = (
        'Synop')
      ItemIndex = 0
      TabOrder = 2
      IconItems = <>
    end
  end
end
