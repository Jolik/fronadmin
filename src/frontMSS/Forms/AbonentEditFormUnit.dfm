inherited AbonentEditForm: TAbonentEditForm
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077'/'#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1072#1073#1086#1085#1077#1085#1090#1072
  ExplicitLeft = 4
  ExplicitTop = 4
  ExplicitWidth = 835
  ExplicitHeight = 557
  TextHeight = 15
  inherited pnBottom: TUniContainerPanel
    ExplicitTop = 443
    ExplicitWidth = 811
    inherited btnOk: TUniButton
      ExplicitLeft = 652
    end
    inherited btnCancel: TUniButton
      ExplicitLeft = 733
    end
  end
  inherited pnCaption: TUniContainerPanel
    ExplicitWidth = 811
    inherited teCaption: TUniEdit
      Left = 84
      Width = 732
      ExplicitLeft = 84
      ExplicitWidth = 724
    end
  end
  inherited pnName: TUniContainerPanel
    ExplicitWidth = 811
    inherited teName: TUniEdit
      Left = 84
      Width = 732
      ExplicitLeft = 84
      ExplicitWidth = 724
    end
  end
  inherited pnClient: TUniContainerPanel
    ExplicitWidth = 811
    ExplicitHeight = 389
    ScrollHeight = 414
    ScrollWidth = 819
    object lAbid: TUniLabel
      Left = 40
      Top = 27
      Width = 25
      Height = 13
      Hint = ''
      Caption = 'AbID'
      TabOrder = 8
    end
    object teAbid: TUniEdit
      Left = 84
      Top = 24
      Width = 732
      Height = 21
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      ExplicitWidth = 724
    end
    object lChannelName: TUniLabel
      Left = 40
      Top = 67
      Width = 22
      Height = 13
      Hint = ''
      Caption = #1048#1084#1103
      TabOrder = 9
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
      ExplicitWidth = 724
    end
    object lChannelValues: TUniLabel
      Left = 40
      Top = 107
      Width = 39
      Height = 13
      Hint = ''
      Caption = #1050#1072#1085#1072#1083#1099
      TabOrder = 10
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
      ExplicitWidth = 724
    end
    object lAttrName: TUniLabel
      Left = 40
      Top = 259
      Width = 22
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
      ExplicitWidth = 724
    end
    object lAttrValues: TUniLabel
      Left = 40
      Top = 299
      Width = 51
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
      ExplicitWidth = 724
      ExplicitHeight = 83
    end
  end
end
