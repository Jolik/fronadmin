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
    inherited cbModule: TUniComboBox
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
    object lbTaskSources: TUniListBox
      Left = 0
      Top = 44
      Width = 487
      Height = 370
      Hint = ''
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 1
      MultiSelect = True
    end
    object btnSourcesEdit: TUniButton
      Left = 10
      Top = 10
      Width = 150
      Height = 25
      Hint = ''
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1080#1089#1090#1086#1095#1085#1080#1082#1080
      TabOrder = 2
      OnClick = btnSourcesEditClick
    end
  end
end
