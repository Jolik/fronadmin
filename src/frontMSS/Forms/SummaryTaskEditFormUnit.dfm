inherited SummaryTaskEditForm: TSummaryTaskEditForm
  TextHeight = 15
  inherited pnCaption: TUniContainerPanel
    inherited teCaption: TUniEdit
      Left = 104
      Width = 1242
      ExplicitLeft = 104
      ExplicitWidth = 1240
    end
  end
  inherited pnName: TUniContainerPanel
    inherited teName: TUniEdit
      Left = 104
      Width = 1242
      ExplicitLeft = 104
      ExplicitWidth = 1240
    end
  end
  inherited pnClient: TUniContainerPanel
    ScrollHeight = 414
    ScrollWidth = 497
    inherited cbModule: TUniComboBox
      OnChange = cbModuleChange
    end
    object lLatePeriod: TUniLabel
      Left = 24
      Top = 248
      Width = 54
      Height = 13
      Hint = ''
      Caption = 'LatePeriod'
      TabOrder = 12
    end
    object teLatePeriod: TUniEdit
      Left = 160
      Top = 244
      Width = 120
      Height = 21
      Hint = ''
      Text = ''
      TabOrder = 13
    end
  end
  inherited pnSources: TUniContainerPanel
    inherited btnSourcesEdit: TUniButton
      Left = 6
      ExplicitLeft = 6
    end
  end
end
