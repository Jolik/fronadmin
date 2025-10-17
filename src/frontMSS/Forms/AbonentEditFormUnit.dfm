inherited AbonentEditForm: TAbonentEditForm
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077'/'#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1072#1073#1086#1085#1077#1085#1090#1072
  TextHeight = 15
  inherited pnCaption: TUniContainerPanel
    inherited teCaption: TUniEdit
      Left = 84
      Width = 732
      ExplicitLeft = 84
      ExplicitWidth = 732
    end
  end
  inherited pnName: TUniContainerPanel
    inherited teName: TUniEdit
      Left = 84
      Width = 732
      ExplicitLeft = 84
      ExplicitWidth = 732
    end
  end
  inherited pnClient: TUniContainerPanel
    ExplicitTop = 54
    object lAid: TUniLabel
      Left = 40
      Top = 27
      Width = 20
      Height = 13
      Hint = ''
      Caption = 'AID'
      TabOrder = 3
    end
    object teAid: TUniEdit
      Left = 84
      Top = 24
      Width = 732
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
    object lChannelName: TUniLabel
      Left = 40
      Top = 67
      Width = 31
      Height = 13
      Hint = ''
      Caption = #1048#1084#1103
      TabOrder = 4
    end
    object teChannelName: TUniEdit
      Left = 84
      Top = 64
      Width = 732
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
    end
    object lChannelValues: TUniLabel
      Left = 40
      Top = 107
      Width = 54
      Height = 13
      Hint = ''
      Caption = #1050#1072#1085#1072#1083#1099
      TabOrder = 5
    end
    object meChannelValues: TUniMemo
      Left = 84
      Top = 124
      Width = 732
      Height = 120
      Hint = ''
      Lines.Strings = (
        '')
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
    end
    object lAttrName: TUniLabel
      Left = 40
      Top = 259
      Width = 31
      Height = 13
      Hint = ''
      Caption = #1048#1084#1103
      TabOrder = 6
    end
    object teAttrName: TUniEdit
      Left = 84
      Top = 256
      Width = 732
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 4
    end
    object lAttrValues: TUniLabel
      Left = 40
      Top = 299
      Width = 72
      Height = 13
      Hint = ''
      Caption = #1040#1090#1088#1080#1073#1091#1090#1099
      TabOrder = 7
    end
    object meAttrValues: TUniMemo
      Left = 84
      Top = 316
      Width = 732
      Height = 108
      Hint = ''
      Lines.Strings = (
        '')
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 5
    end
  end
end
