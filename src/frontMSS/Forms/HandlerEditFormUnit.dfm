inherited HandlerEditForm: THandlerEditForm
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077'/'#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077#32#1086#1073#1088#1072#1073#1086#1090#1095#1080#1082#1072
  TextHeight = 15
  inherited pnCaption: TUniContainerPanel
    inherited teCaption: TUniEdit
      Left = 84
      Width = 732
      ExplicitLeft = 84
    end
  end
  inherited pnName: TUniContainerPanel
    inherited teName: TUniEdit
      Left = 84
      Width = 732
      ExplicitLeft = 84
    end
  end
  inherited pnClient: TUniContainerPanel
    ExplicitTop = 54
    object lHid: TUniLabel
      Left = 40
      Top = 27
      Width = 18
      Height = 13
      Hint = ''
      Caption = 'HID'
      TabOrder = 6
    end
    object teHid: TUniEdit
      Left = 84
      Top = 24
      Width = 732
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
    object lSvcId: TUniLabel
      Left = 40
      Top = 67
      Width = 31
      Height = 13
      Hint = ''
      Caption = 'SvcID'
      TabOrder = 4
    end
    object teSvcId: TUniEdit
      Left = 84
      Top = 64
      Width = 732
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
    end
    object lLid: TUniLabel
      Left = 40
      Top = 107
      Width = 17
      Height = 13
      Hint = ''
      Caption = 'LID'
      TabOrder = 5
    end
    object teLid: TUniEdit
      Left = 84
      Top = 104
      Width = 732
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
    end
  end
end
