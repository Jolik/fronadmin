inherited LinkEditForm: TLinkEditForm
  ClientHeight = 809
  ClientWidth = 986
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077'/'#1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1083#1080#1085#1082#1086#1074'..'
  ExplicitLeft = 3
  ExplicitTop = 3
  ExplicitWidth = 1002
  ExplicitHeight = 848
  TextHeight = 15
  inherited pnBottom: TUniContainerPanel
    Top = 759
    Width = 986
    ExplicitTop = 551
    ExplicitWidth = 984
    inherited btnOk: TUniButton
      Left = 825
      Align = alNone
      ExplicitLeft = 825
    end
    inherited btnCancel: TUniButton
      Left = 908
      ExplicitLeft = 906
    end
  end
  inherited pnCaption: TUniContainerPanel
    Width = 986
    Visible = False
    ExplicitWidth = 984
    inherited teCaption: TUniEdit
      Left = 102
      Width = 881
      ExplicitLeft = 102
      ExplicitWidth = 879
    end
  end
  inherited pnName: TUniContainerPanel
    Width = 986
    ExplicitWidth = 984
    inherited teName: TUniEdit
      Left = 102
      Width = 881
      ExplicitLeft = 102
      ExplicitWidth = 879
    end
  end
  inherited pnClient: TUniContainerPanel
    Top = 108
    Width = 986
    Height = 651
    ExplicitTop = 108
    ExplicitWidth = 984
    ExplicitHeight = 443
    ScrollHeight = 651
    ScrollWidth = 986
  end
  object pnID: TUniContainerPanel [4]
    Left = 0
    Top = 0
    Width = 986
    Height = 128
    Hint = ''
    ParentColor = False
    TabOrder = 4
    object teID: TUniEdit
      Left = 102
      Top = 0
      Width = 881
      Hint = ''
      Text = ''
      TabOrder = 1
    end
  end
  object UniContainerPanel1: TUniContainerPanel [5]
    Left = 0
    Top = 54
    Width = 986
    Height = 27
    Hint = ''
    ParentColor = False
    Align = alTop
    TabOrder = 5
    ExplicitWidth = 984
    object UniLabel2: TUniLabel
      AlignWithMargins = True
      Left = 3
      Top = 5
      Width = 19
      Height = 13
      Hint = ''
      Margins.Top = 5
      Margins.Right = 10
      Margins.Bottom = 5
      Caption = #1058#1080#1087
      Align = alLeft
      ParentFont = False
      Font.Style = [fsBold]
      TabOrder = 1
    end
    object comboLinkType: TUniComboBox
      AlignWithMargins = True
      Left = 102
      Top = 3
      Width = 881
      Height = 21
      Hint = ''
      Style = csOwnerDrawFixed
      Text = ''
      Align = alRight
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 2
      IconItems = <>
      OnChange = comboLinkTypeChange
      ExplicitWidth = 879
    end
  end
  object UniContainerPanel3: TUniContainerPanel [6]
    Left = 0
    Top = 81
    Width = 986
    Height = 27
    Hint = ''
    ParentColor = False
    Align = alTop
    TabOrder = 6
    ExplicitWidth = 984
    object UniLabel4: TUniLabel
      AlignWithMargins = True
      Left = 3
      Top = 32
      Width = 19
      Height = 13
      Hint = ''
      Margins.Top = 5
      Margins.Right = 10
      Margins.Bottom = 5
      Caption = #1058#1080#1087
      Align = alLeft
      ParentFont = False
      Font.Style = [fsBold]
      TabOrder = 1
    end
    object UniComboBox2: TUniComboBox
      AlignWithMargins = True
      Left = 102
      Top = 30
      Width = 881
      Height = 0
      Hint = ''
      Style = csOwnerDrawFixed
      Text = ''
      Align = alRight
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 2
      IconItems = <>
      OnChange = comboLinkTypeChange
      ExplicitWidth = 879
    end
    object directionPanel: TUniContainerPanel
      Left = 0
      Top = 0
      Width = 986
      Height = 27
      Hint = ''
      ParentColor = False
      Align = alTop
      TabOrder = 3
      ExplicitWidth = 984
      object UniLabel5: TUniLabel
        AlignWithMargins = True
        Left = 3
        Top = 5
        Width = 73
        Height = 13
        Hint = ''
        Margins.Top = 5
        Margins.Right = 10
        Margins.Bottom = 5
        Caption = #1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
        Align = alLeft
        ParentFont = False
        Font.Style = [fsBold]
        TabOrder = 1
      end
      object ComboBoxDirection: TUniComboBox
        AlignWithMargins = True
        Left = 102
        Top = 3
        Width = 881
        Height = 21
        Hint = ''
        Style = csOwnerDrawFixed
        Text = 'download'
        Items.Strings = (
          'download'
          'upload'
          'duplex')
        ItemIndex = 0
        Align = alRight
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 2
        IconItems = <>
        ExplicitWidth = 879
      end
    end
  end
end
