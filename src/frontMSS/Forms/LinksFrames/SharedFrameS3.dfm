object FrameS3: TFrameS3
  Left = 0
  Top = 0
  Width = 298
  Height = 176
  TabOrder = 0
  object UniGroupBox1: TUniGroupBox
    Left = 0
    Top = 0
    Width = 298
    Height = 176
    Hint = ''
    Caption = ' S3 '#1092#1072#1081#1083#1086#1074#1072#1103' '#1089#1080#1089#1090#1077#1084#1072' '
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 88
    ExplicitTop = 120
    ExplicitWidth = 185
    ExplicitHeight = 105
    inline FrameS3Enabled: TFrameBoolInput
      Left = 2
      Top = 15
      Width = 294
      Height = 30
      Align = alTop
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxHeight = 30
      Constraints.MinHeight = 30
      TabOrder = 1
      Background.Picture.Data = {00}
      ExplicitLeft = 62
      ExplicitTop = 104
      inherited PanelText: TUniPanel
        Caption = #1042#1082#1083#1102#1095#1077#1085#1072
      end
      inherited CheckBox: TUniCheckBox
        Width = 156
      end
    end
    inline FrameS3AccessKey: TFrameTextInput
      Left = 2
      Top = 75
      Width = 294
      Height = 30
      Align = alTop
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxHeight = 30
      Constraints.MinHeight = 30
      TabOrder = 2
      Background.Picture.Data = {00}
      ExplicitLeft = 29
      ExplicitTop = 112
      inherited PanelText: TUniPanel
        Caption = #1051#1086#1075#1080#1085
      end
      inherited Edit: TUniEdit
        Width = 123
      end
      inherited PanelUnits: TUniPanel
        Left = 268
        Caption = ''
      end
    end
    inline FrameS3Endpoint: TFrameTextInput
      Left = 2
      Top = 45
      Width = 294
      Height = 30
      Align = alTop
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxHeight = 30
      Constraints.MinHeight = 30
      TabOrder = 3
      Background.Picture.Data = {00}
      ExplicitLeft = 29
      ExplicitTop = 112
      ExplicitWidth = 294
      inherited PanelText: TUniPanel
        Caption = #1057#1077#1088#1074#1077#1088
      end
      inherited Edit: TUniEdit
        Width = 123
        ExplicitWidth = 123
      end
      inherited PanelUnits: TUniPanel
        Left = 268
        Caption = ''
        ExplicitLeft = 268
      end
    end
    inline FrameS3Secret: TFrameTextInput
      Left = 2
      Top = 105
      Width = 294
      Height = 30
      Align = alTop
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxHeight = 30
      Constraints.MinHeight = 30
      TabOrder = 4
      Background.Picture.Data = {00}
      ExplicitLeft = 2
      ExplicitTop = 32767
      ExplicitWidth = 294
      inherited PanelText: TUniPanel
        Caption = #1055#1072#1088#1086#1083#1100
      end
      inherited Edit: TUniEdit
        Width = 123
        ExplicitWidth = 123
      end
      inherited PanelUnits: TUniPanel
        Left = 268
        Caption = ''
        ExplicitLeft = 268
      end
    end
    inline FrameS3Bucket: TFrameTextInput
      Left = 2
      Top = 135
      Width = 294
      Height = 30
      Align = alTop
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxHeight = 30
      Constraints.MinHeight = 30
      TabOrder = 5
      Background.Picture.Data = {00}
      ExplicitLeft = 2
      ExplicitTop = 3232
      ExplicitWidth = 294
      inherited PanelText: TUniPanel
        Caption = #1050#1086#1085#1090#1077#1081#1085#1077#1088
      end
      inherited Edit: TUniEdit
        Width = 123
        ExplicitWidth = 123
      end
      inherited PanelUnits: TUniPanel
        Left = 268
        Caption = ''
        ExplicitLeft = 268
      end
    end
  end
end
