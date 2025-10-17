object FrameBoolInput: TFrameBoolInput
  Left = 0
  Top = 0
  Width = 236
  Height = 30
  Constraints.MaxHeight = 30
  Constraints.MinHeight = 30
  TabOrder = 0
  object PanelText: TUniPanel
    Left = 0
    Top = 0
    Width = 125
    Height = 30
    Hint = ''
    Constraints.MaxWidth = 125
    Constraints.MinWidth = 125
    Align = alLeft
    TabOrder = 0
    BorderStyle = ubsNone
    Caption = 'bool'
    ScrollDirection = sdNone
  end
  object CheckBox: TUniCheckBox
    AlignWithMargins = True
    Left = 135
    Top = 3
    Width = 98
    Height = 24
    Hint = ''
    Margins.Left = 10
    Caption = ''
    Align = alClient
    TabOrder = 1
  end
end
