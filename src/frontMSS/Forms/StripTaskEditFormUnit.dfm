inherited StripTaskEditForm: TStripTaskEditForm
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077'/'#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1079#1072#1076#1072#1095#1080'...'
  ExplicitLeft = -98
  TextHeight = 15
  inherited pnBottom: TUniContainerPanel
    ExplicitTop = 460
    ExplicitWidth = 817
    inherited btnOk: TUniButton
      ExplicitLeft = 658
    end
    inherited btnCancel: TUniButton
      ExplicitLeft = 739
    end
  end
  inherited pnCaption: TUniContainerPanel
    ExplicitWidth = 817
    inherited teCaption: TUniEdit
      Left = 86
      Width = 730
      ExplicitLeft = 86
      ExplicitWidth = 728
    end
  end
  inherited pnName: TUniContainerPanel
    ExplicitWidth = 817
    inherited teName: TUniEdit
      Left = 86
      Width = 730
      ExplicitLeft = 86
      ExplicitWidth = 728
    end
  end
  inherited pnClient: TUniContainerPanel
    ExplicitWidth = 817
    ExplicitHeight = 406
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
      Text = 'StripUnknown'
      Items.Strings = (
        'StripSynop'
        'StripHydra'
        'StripXML'
        'StripUnknown')
      ItemIndex = 3
      TabOrder = 2
      IconItems = <>
    end
  end
end
