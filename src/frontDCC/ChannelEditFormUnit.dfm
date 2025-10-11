object ChannelEditForm: TChannelEditForm
  Left = 0
  Top = 0
  ClientHeight = 477
  ClientWidth = 681
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1080' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1072#1085#1080#1077' '#1082#1072#1085#1072#1083#1072
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  TextHeight = 15
  object MainPanel: TUniPanel
    Left = 0
    Top = 0
    Width = 681
    Height = 477
    Hint = ''
    Align = alClient
    TabOrder = 0
    Caption = ''
    ExplicitWidth = 679
    ExplicitHeight = 469
    object PageControl: TUniPageControl
      Left = 1
      Top = 1
      Width = 679
      Height = 425
      Hint = ''
      ActivePage = LinkTab
      Align = alClient
      TabOrder = 1
      ExplicitWidth = 677
      ExplicitHeight = 417
      object BasicTab: TUniTabSheet
        Hint = ''
        Caption = #1054#1089#1085#1086#1074#1085#1099#1077' '#1085#1072#1089#1090#1088#1086#1081#1082#1080
        Layout = 'form'
        LayoutConfig.Padding = '10'
        ExplicitWidth = 669
        ExplicitHeight = 389
        object ChannelNameLabel: TUniLabel
          Left = 10
          Top = 15
          Width = 65
          Height = 13
          Hint = ''
          Caption = #1048#1084#1103' '#1082#1072#1085#1072#1083#1072':'
          TabOrder = 0
        end
        object ChannelNameEdit: TUniEdit
          Left = 120
          Top = 12
          Width = 300
          Hint = ''
          Text = ''
          TabOrder = 1
        end
        object ChannelCaptionLabel: TUniLabel
          Left = 10
          Top = 45
          Width = 94
          Height = 13
          Hint = ''
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1082#1072#1085#1072#1083#1072':'
          TabOrder = 2
        end
        object ChannelCaptionEdit: TUniEdit
          Left = 120
          Top = 42
          Width = 300
          Hint = ''
          Text = ''
          TabOrder = 3
        end
      end
      object QueueTab: TUniTabSheet
        Hint = ''
        Caption = #1054#1095#1077#1088#1077#1076#1100
        Layout = 'form'
        LayoutConfig.Padding = '10'
        ExplicitWidth = 669
        ExplicitHeight = 389
        object AllowPutCheckBox: TUniCheckBox
          Left = 10
          Top = 15
          Width = 300
          Height = 17
          Hint = ''
          Caption = #1042#1082#1083#1102#1095#1080#1090#1100' '#1085#1072#1082#1086#1087#1083#1077#1085#1080#1077' (allow_put)'
          TabOrder = 0
        end
        object DoublesCheckBox: TUniCheckBox
          Left = 10
          Top = 45
          Width = 300
          Height = 17
          Hint = ''
          Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1076#1091#1073#1083#1080' (doubles)'
          TabOrder = 1
        end
        object MaxLimitLabel: TUniLabel
          Left = 10
          Top = 75
          Width = 87
          Height = 13
          Hint = ''
          Caption = #1052#1072#1082#1089'. '#1079#1085#1072#1095#1077#1085#1080#1077':'
          TabOrder = 2
        end
        object MaxLimitEdit: TUniEdit
          Left = 120
          Top = 72
          Width = 100
          Hint = ''
          Text = '1500'
          TabOrder = 3
        end
        object CriticalLimitLabel: TUniLabel
          Left = 10
          Top = 105
          Width = 85
          Height = 13
          Hint = ''
          Caption = #1050#1088#1080#1090'. '#1079#1085#1072#1095#1077#1085#1080#1077':'
          TabOrder = 4
        end
        object CriticalLimitEdit: TUniEdit
          Left = 120
          Top = 102
          Width = 100
          Hint = ''
          Text = '2000'
          TabOrder = 5
        end
      end
      object LinkTab: TUniTabSheet
        Hint = ''
        Caption = #1051#1080#1085#1082
        Layout = 'vbox'
        LayoutConfig.Padding = '10'
        ExplicitWidth = 669
        ExplicitHeight = 389
        object UniPanel1: TUniPanel
          Left = 0
          Top = 0
          Width = 671
          Height = 81
          Hint = ''
          Align = alTop
          TabOrder = 0
          ShowCaption = False
          Caption = ''
          ExplicitWidth = 669
          object DirectionLabel: TUniLabel
            Left = 18
            Top = 17
            Width = 75
            Height = 13
            Hint = ''
            Caption = #1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077':'
            TabOrder = 1
          end
          object DirectionComboBox: TUniComboBox
            Left = 99
            Top = 14
            Width = 200
            Hint = ''
            Style = csDropDownList
            Text = #1042#1093#1086#1076#1103#1097#1080#1081
            Items.Strings = (
              #1042#1093#1086#1076#1103#1097#1080#1081
              #1048#1089#1093#1086#1076#1103#1097#1080#1081
              #1044#1091#1087#1083#1077#1082#1089#1085#1099#1081)
            ItemIndex = 0
            TabOrder = 2
            IconItems = <>
            OnChange = DirectionComboBoxChange
          end
          object TypeLabel: TUniLabel
            Left = 18
            Top = 47
            Width = 22
            Height = 13
            Hint = ''
            Caption = #1058#1080#1087':'
            TabOrder = 3
          end
          object TypeComboBox: TUniComboBox
            Left = 99
            Top = 42
            Width = 300
            Hint = ''
            Text = ''
            TabOrder = 4
            IconItems = <>
            OnChange = TypeComboBoxChange
          end
        end
        object UniScrollBox1: TUniScrollBox
          AlignWithMargins = True
          Left = 3
          Top = 84
          Width = 665
          Height = 310
          Hint = ''
          Align = alClient
          TabOrder = 1
          ExplicitLeft = 0
          ExplicitTop = 81
          ExplicitWidth = 669
          ExplicitHeight = 308
        end
      end
      object UniTabSheet1: TUniTabSheet
        Hint = ''
        Caption = #1056#1077#1082#1074#1080#1079#1080#1090#1099
        ExplicitWidth = 669
        ExplicitHeight = 389
      end
      object UniTabSheet2: TUniTabSheet
        Hint = ''
        Caption = #1055#1088#1086#1092#1080#1083#1080
        ExplicitWidth = 669
        ExplicitHeight = 389
      end
    end
    object ButtonsPanel: TUniPanel
      Left = 1
      Top = 426
      Width = 679
      Height = 50
      Hint = ''
      Margins.Top = 0
      Margins.Bottom = 0
      Constraints.MinHeight = 50
      Align = alBottom
      TabOrder = 2
      Caption = ''
      Layout = 'hbox'
      LayoutAttribs.Align = 'middle'
      LayoutAttribs.Pack = 'end'
      LayoutConfig.Padding = '10'
      ExplicitTop = 418
      ExplicitWidth = 677
      object OkButton: TUniButton
        AlignWithMargins = True
        Left = 515
        Top = 11
        Width = 75
        Height = 28
        Hint = ''
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 10
        Caption = 'OK'
        Align = alRight
        TabOrder = 1
        OnClick = OkButtonClick
        ExplicitLeft = 513
      end
      object CancelButton: TUniButton
        AlignWithMargins = True
        Left = 598
        Top = 11
        Width = 75
        Height = 28
        Hint = ''
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 10
        Caption = #1054#1090#1084#1077#1085#1072
        ModalResult = 2
        Align = alRight
        TabOrder = 2
        ExplicitLeft = 596
      end
    end
  end
end
