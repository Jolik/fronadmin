inherited SummaryTaskEditForm: TSummaryTaskEditForm
  ExplicitLeft = 2
  TextHeight = 15
  inherited pnCaption: TUniContainerPanel
    inherited teCaption: TUniEdit
      Left = 84
      Width = 1262
      ExplicitLeft = 84
      ExplicitWidth = 1262
    end
  end
  inherited pnName: TUniContainerPanel
    inherited teName: TUniEdit
      Left = 84
      Width = 1262
      ExplicitLeft = 84
      ExplicitWidth = 1262
    end
  end
  inherited pnClient: TUniContainerPanel
    ScrollHeight = 414
    ScrollWidth = 497
    inherited cbModule: TUniComboBox
      OnChange = cbModuleChange
    end
  end
end
