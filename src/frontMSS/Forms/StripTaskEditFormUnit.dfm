inherited StripTaskEditForm: TStripTaskEditForm
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
    object teModule: TUniEdit
      Left = 64
      Top = 64
      Width = 121
      Hint = ''
      Text = 'teModule'
      TabOrder = 1
    end
    object lModule: TUniLabel
      Left = 40
      Top = 45
      Width = 40
      Height = 13
      Hint = ''
      Caption = #1052#1086#1076#1091#1083#1100
      TabOrder = 2
    end
  end
end
