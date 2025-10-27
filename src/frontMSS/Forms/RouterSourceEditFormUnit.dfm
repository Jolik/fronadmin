inherited RouterSourceEditForm: TRouterSourceEditForm
  Caption = #1048#1089#1090#1086#1095#1085#1080#1082' '#1084#1072#1088#1096#1088#1091#1090#1080#1079#1072#1090#1086#1088#1072
  ExplicitWidth = 835
  ExplicitHeight = 557
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
      Left = 84
      Width = 732
      ExplicitLeft = 84
      ExplicitWidth = 730
    end
  end
  inherited pnName: TUniContainerPanel
    ExplicitWidth = 817
    inherited teName: TUniEdit
      Left = 84
      Width = 732
      ExplicitLeft = 84
      ExplicitWidth = 730
    end
  end
  inherited pnClient: TUniContainerPanel
    ExplicitWidth = 817
    ExplicitHeight = 406
    ScrollHeight = 414
    ScrollWidth = 819
    object lWho: TUniLabel
      Left = 40
      Top = 32
      Width = 38
      Height = 13
      Hint = ''
      Caption = #1048#1085#1076#1077#1082#1089
      TabOrder = 1
    end
    object teWho: TUniEdit
      Left = 96
      Top = 28
      Width = 185
      Hint = ''
      Text = ''
      TabOrder = 2
    end
    object lSvcId: TUniLabel
      Left = 40
      Top = 72
      Width = 26
      Height = 13
      Hint = ''
      Caption = 'SvcId'
      TabOrder = 3
    end
    object teSvcId: TUniEdit
      Left = 96
      Top = 68
      Width = 185
      Hint = ''
      Text = ''
      TabOrder = 4
    end
    object lLid: TUniLabel
      Left = 40
      Top = 112
      Width = 15
      Height = 13
      Hint = ''
      Caption = 'Lid'
      TabOrder = 5
    end
    object teLid: TUniEdit
      Left = 96
      Top = 108
      Width = 185
      Hint = ''
      Text = ''
      TabOrder = 6
    end
  end
end
