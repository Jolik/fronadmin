object QueueConditionFrame: TQueueConditionFrame
  Left = 0
  Top = 0
  Width = 187
  Height = 161
  TabOrder = 0
  object GroupBoxCondition: TUniGroupBox
    Left = 0
    Top = 0
    Width = 187
    Height = 161
    Hint = ''
    Caption = ' '#1059#1089#1083#1086#1074#1080#1077' '
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 8
    ExplicitTop = 8
    ExplicitWidth = 178
    ExplicitHeight = 136
    object UniPanel3: TUniPanel
      Left = 2
      Top = 75
      Width = 183
      Height = 30
      Hint = ''
      Constraints.MaxHeight = 30
      Constraints.MinHeight = 30
      Align = alTop
      TabOrder = 1
      BorderStyle = ubsNone
      ShowCaption = False
      Caption = 'UniPanel3'
      ExplicitWidth = 174
      object UniPanel4: TUniPanel
        Left = 0
        Top = 0
        Width = 40
        Height = 30
        Hint = ''
        Align = alLeft
        TabOrder = 1
        BorderStyle = ubsNone
        Caption = #1090#1077#1082#1089#1090
      end
      object EditRuleText: TUniEdit
        AlignWithMargins = True
        Left = 43
        Top = 3
        Width = 137
        Height = 24
        Hint = ''
        Text = ''
        Align = alClient
        TabOrder = 2
        ExplicitWidth = 128
      end
    end
    object UniPanel7: TUniPanel
      Left = 2
      Top = 45
      Width = 183
      Height = 30
      Hint = ''
      Constraints.MaxHeight = 30
      Constraints.MinHeight = 30
      Align = alTop
      TabOrder = 2
      BorderStyle = ubsNone
      ShowCaption = False
      Caption = 'UniPanel3'
      ExplicitWidth = 174
      object UniPanel8: TUniPanel
        Left = 0
        Top = 0
        Width = 40
        Height = 30
        Hint = #1090#1080#1087' '#1089#1088#1072#1074#1085#1077#1085#1080#1103' '#1087#1086#1083#1103' '#1089' '#1090#1077#1082#1089#1090#1086#1084
        ShowHint = True
        ParentShowHint = False
        Align = alLeft
        TabOrder = 1
        BorderStyle = ubsNone
        Caption = #1090#1080#1087
      end
      object ComboBoxRuleType: TUniComboBox
        AlignWithMargins = True
        Left = 43
        Top = 3
        Width = 137
        Height = 24
        Hint = ''
        Style = csOwnerDrawFixed
        Text = ''
        Items.Strings = (
          #1088#1077#1075#1091#1083#1103#1088#1085#1086#1077
          #1084#1072#1089#1082#1072)
        Align = alClient
        TabOrder = 2
        IconItems = <>
        ExplicitWidth = 128
      end
    end
    object UniPanel1: TUniPanel
      Left = 2
      Top = 105
      Width = 183
      Height = 30
      Hint = ''
      Constraints.MaxHeight = 30
      Constraints.MinHeight = 30
      Align = alTop
      TabOrder = 3
      BorderStyle = ubsNone
      ShowCaption = False
      Caption = 'UniPanel3'
      ExplicitWidth = 174
      object btnOK: TUniBitBtn
        AlignWithMargins = True
        Left = 113
        Top = 3
        Width = 67
        Height = 24
        Hint = ''
        Caption = 'ok'
        Align = alRight
        TabOrder = 1
        OnClick = btnOKClick
        ExplicitLeft = 104
      end
    end
    object UniPanel2: TUniPanel
      Left = 2
      Top = 15
      Width = 183
      Height = 30
      Hint = ''
      Constraints.MaxHeight = 30
      Constraints.MinHeight = 30
      Align = alTop
      TabOrder = 4
      BorderStyle = ubsNone
      ShowCaption = False
      Caption = 'UniPanel3'
      ExplicitTop = 0
      object UniPanel5: TUniPanel
        Left = 0
        Top = 0
        Width = 40
        Height = 30
        Hint = ''
        Align = alLeft
        TabOrder = 1
        BorderStyle = ubsNone
        Caption = #1087#1086#1083#1077
      end
      object editField: TUniEdit
        AlignWithMargins = True
        Left = 43
        Top = 3
        Width = 137
        Height = 24
        Hint = ''
        Text = ''
        Align = alClient
        TabOrder = 2
      end
    end
  end
end
