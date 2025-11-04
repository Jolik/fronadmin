object FrameQueue: TFrameQueue
  Left = 0
  Top = 0
  Width = 274
  Height = 59
  TabOrder = 0
  inline FrameQid: TFrameTextInput
    Left = 0
    Top = 0
    Width = 274
    Height = 30
    Align = alTop
    Anchors = [akLeft, akTop, akRight]
    Constraints.MaxHeight = 30
    Constraints.MinHeight = 30
    TabOrder = 0
    Background.Picture.Data = {00}
    ExplicitWidth = 274
    inherited PanelText: TUniPanel
      Caption = 'ID '#1086#1095#1077#1088#1077#1076#1080
    end
    inherited Edit: TUniEdit
      Width = 103
      ReadOnly = True
      ExplicitWidth = 103
    end
    inherited PanelUnits: TUniPanel
      Left = 248
      Caption = ''
      ExplicitLeft = 248
    end
  end
  inline FrameQueueEnable: TFrameBoolInput
    Left = 0
    Top = 30
    Width = 274
    Height = 30
    Align = alTop
    Anchors = [akLeft, akTop, akRight]
    Constraints.MaxHeight = 30
    Constraints.MinHeight = 30
    TabOrder = 1
    Background.Picture.Data = {00}
    ExplicitTop = 30
    ExplicitWidth = 274
    inherited PanelText: TUniPanel
      Caption = #1042#1082#1083#1102#1095#1080#1090#1100' '#1074#1099#1076#1072#1095#1091
    end
    inherited CheckBox: TUniCheckBox
      Width = 136
      ExplicitWidth = 136
    end
  end
end
