object FrameSchedule: TFrameSchedule
  Left = 0
  Top = 0
  Width = 345
  Height = 208
  TabOrder = 0
  object UniGroupBox1: TUniGroupBox
    Left = 0
    Top = 0
    Width = 345
    Height = 208
    Hint = ''
    Caption = ' '#1056#1072#1089#1087#1080#1089#1072#1085#1080#1077' '#1088#1072#1073#1086#1090#1099' '
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 330
    object UniPanel1: TUniPanel
      Left = 2
      Top = 45
      Width = 341
      Height = 161
      Hint = ''
      Align = alTop
      TabOrder = 1
      BorderStyle = ubsNone
      ShowCaption = False
      Caption = 'UniPanel1'
      ExplicitTop = 109
      inline FrameScheduleCron: TFrameTextInput
        Left = 0
        Top = 30
        Width = 341
        Height = 30
        Align = alTop
        Anchors = [akLeft, akTop, akRight]
        Constraints.MaxHeight = 30
        Constraints.MinHeight = 30
        TabOrder = 1
        Background.Picture.Data = {00}
        ExplicitLeft = 76
        ExplicitTop = 176
        ExplicitWidth = 341
        inherited PanelText: TUniPanel
          Caption = 'Cron-'#1089#1090#1088#1086#1082#1072
        end
        inherited Edit: TUniEdit
          Width = 170
          OnChange = FrameScheduleCronEditChange
          ExplicitWidth = 170
        end
        inherited PanelUnits: TUniPanel
          Left = 315
          Caption = ''
          ExplicitLeft = 315
        end
      end
      inline FrameSchedulePeriod: TFrameTextInput
        Left = 0
        Top = 60
        Width = 341
        Height = 30
        Align = alTop
        Anchors = [akLeft, akTop, akRight]
        Constraints.MaxHeight = 30
        Constraints.MinHeight = 30
        TabOrder = 2
        Background.Picture.Data = {00}
        ExplicitLeft = 2
        ExplicitTop = 32767
        ExplicitWidth = 341
        inherited PanelText: TUniPanel
          Caption = #1055#1077#1088#1080#1086#1076' '#1088#1072#1073#1086#1090#1099
        end
        inherited Edit: TUniEdit
          Width = 168
          InputType = 'number'
          OnChange = FrameSchedulePeriodEditChange
          ExplicitLeft = 138
          ExplicitWidth = 168
        end
        inherited PanelUnits: TUniPanel
          Left = 313
          ExplicitLeft = 315
        end
      end
      inline FrameScheduleEnabled: TFrameBoolInput
        Left = 0
        Top = 0
        Width = 341
        Height = 30
        Align = alTop
        Anchors = [akLeft, akTop, akRight]
        Constraints.MaxHeight = 30
        Constraints.MinHeight = 30
        TabOrder = 3
        Background.Picture.Data = {00}
        ExplicitLeft = 1
        ExplicitWidth = 316
        inherited PanelText: TUniPanel
          Caption = #1042#1082#1083#1102#1095#1077#1085
          ExplicitLeft = 16
          ExplicitTop = 16
        end
        inherited CheckBox: TUniCheckBox
          Width = 203
          OnChange = FrameScheduleEnabledCheckBoxChange
        end
      end
      inline FrameScheduleRetry: TFrameTextInput
        Left = 0
        Top = 90
        Width = 341
        Height = 30
        Align = alTop
        Anchors = [akLeft, akTop, akRight]
        Constraints.MaxHeight = 30
        Constraints.MinHeight = 30
        TabOrder = 4
        Background.Picture.Data = {00}
        ExplicitLeft = 49
        ExplicitTop = 120
        inherited PanelText: TUniPanel
          Caption = #1055#1086#1074#1090'. '#1087#1086#1087#1099#1090#1086#1082
          ExplicitLeft = -3
          ExplicitTop = 3
        end
        inherited Edit: TUniEdit
          Width = 170
          InputType = 'number'
          OnChange = FrameScheduleRetryEditChange
        end
        inherited PanelUnits: TUniPanel
          Left = 315
          Caption = #1096#1090
        end
      end
      inline FrameScheduleDelay: TFrameTextInput
        Left = 0
        Top = 120
        Width = 341
        Height = 30
        Align = alTop
        Anchors = [akLeft, akTop, akRight]
        Constraints.MaxHeight = 30
        Constraints.MinHeight = 30
        TabOrder = 5
        Background.Picture.Data = {00}
        ExplicitLeft = 1
        ExplicitTop = 32767
        ExplicitWidth = 316
        inherited PanelText: TUniPanel
          Caption = #1055#1072#1091#1079#1072' '#1087#1077#1088#1077#1076' '#1087#1086#1074#1090'.'
          ExplicitLeft = -3
          ExplicitTop = 3
        end
        inherited Edit: TUniEdit
          Width = 170
          InputType = 'number'
          OnChange = FrameScheduleDelayEditChange
          ExplicitLeft = 132
          ExplicitWidth = 170
        end
        inherited PanelUnits: TUniPanel
          Left = 315
          ExplicitLeft = 290
        end
      end
    end
    object UniPanel3: TUniPanel
      Left = 2
      Top = 15
      Width = 341
      Height = 30
      Hint = ''
      Constraints.MaxHeight = 30
      Constraints.MinHeight = 30
      Align = alTop
      TabOrder = 2
      BorderStyle = ubsNone
      ShowCaption = False
      Caption = 'UniPanel3'
      object btnRemoveJob: TUniBitBtn
        AlignWithMargins = True
        Left = 261
        Top = 3
        Width = 25
        Height = 24
        Hint = #1091#1076#1072#1083#1080#1090#1100' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1077' '#1088#1072#1073#1086#1090#1099
        ShowHint = True
        ParentShowHint = False
        Caption = '-'
        Align = alLeft
        TabOrder = 1
        OnClick = btnRemoveJobClick
        ExplicitLeft = 185
      end
      object btnAddJob: TUniBitBtn
        AlignWithMargins = True
        Left = 230
        Top = 3
        Width = 25
        Height = 24
        Hint = #1076#1086#1073#1072#1074#1080#1090#1100' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1077' '#1088#1072#1073#1086#1090#1099
        ShowHint = True
        ParentShowHint = False
        Caption = '+'
        Align = alLeft
        TabOrder = 2
        OnClick = btnAddJobClick
        ExplicitLeft = 154
      end
      object JobsComboBox: TUniComboBox
        AlignWithMargins = True
        Left = 10
        Top = 3
        Width = 207
        Height = 24
        Hint = ''
        Margins.Left = 10
        Margins.Right = 10
        Style = csOwnerDrawFixed
        Text = ''
        Align = alLeft
        TabOrder = 3
        IconItems = <>
        OnSelect = JobsComboBoxSelect
        ExplicitLeft = 3
      end
    end
  end
end
