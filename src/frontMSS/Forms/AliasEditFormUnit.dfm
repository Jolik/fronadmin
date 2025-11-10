inherited AliasEditForm: TAliasEditForm
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077'/'#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1072#1083#1080#1072#1089#1072
  TextHeight = 15
  inherited pnClient: TUniContainerPanel
    ScrollHeight = 414
    ScrollWidth = 819
    object lAlid: TUniLabel
      Left = 40
      Top = 27
      Width = 23
      Height = 13
      Hint = ''
      Caption = 'ALID'
      TabOrder = 6
    end
    object teAlid: TUniEdit
      Left = 84
      Top = 24
      Width = 732
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      ExplicitWidth = 730
    end
    object lChannelName: TUniLabel
      Left = 40
      Top = 67
      Width = 22
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
      ExplicitWidth = 730
    end
    object lChannelValues: TUniLabel
      Left = 40
      Top = 107
      Width = 39
      Height = 13
      Hint = ''
      Caption = #1050#1072#1085#1072#1083#1099
      TabOrder = 5
    end
    object meChannelValues: TUniMemo
      Left = 84
      Top = 124
      Width = 732
      Height = 220
      Hint = ''
      Lines.Strings = (
        '')
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 3
      ExplicitWidth = 730
      ExplicitHeight = 212
    end
  end
end
