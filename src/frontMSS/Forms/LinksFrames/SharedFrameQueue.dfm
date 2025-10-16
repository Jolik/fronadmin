object FrameQueue: TFrameQueue
  Left = 0
  Top = 0
  Width = 270
  Height = 66
  TabOrder = 0
  inline FrameQueueEnable: TFrameBoolInput
    Left = 0
    Top = 30
    Width = 270
    Height = 30
    Align = alTop
    Anchors = [akLeft, akTop, akRight]
    Constraints.MaxHeight = 30
    Constraints.MinHeight = 30
    TabOrder = 0
    Background.Picture.Data = {00}
    ExplicitLeft = 34
    ExplicitTop = 56
    ExplicitWidth = 270
    inherited PanelText: TUniPanel
      Caption = #1042#1082#1083#1102#1095#1080#1090#1100' '#1074#1099#1076#1072#1095#1091
    end
    inherited CheckBox: TUniCheckBox
      Width = 132
      ExplicitWidth = 132
    end
  end
end
