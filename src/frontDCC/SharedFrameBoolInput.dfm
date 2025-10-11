inherited FrameBoolInput: TFrameBoolInput
  Width = 236
  Height = 37
  ExplicitWidth = 236
  ExplicitHeight = 37
  object PanelBoolInput: TUniPanel
    Left = 0
    Top = 0
    Width = 236
    Height = 37
    Hint = ''
    Align = alClient
    TabOrder = 0
    BorderStyle = ubsNone
    Caption = ''
    ScrollDirection = sdNone
    object PanelText: TUniPanel
      Left = 1
      Top = 1
      Width = 104
      Height = 35
      Hint = ''
      Align = alLeft
      TabOrder = 1
      BorderStyle = ubsNone
      Caption = 'bool'
      ScrollDirection = sdNone
    end
    object CheckBox: TUniCheckBox
      AlignWithMargins = True
      Left = 115
      Top = 10
      Width = 97
      Height = 17
      Hint = ''
      Margins.Left = 10
      Caption = ''
      TabOrder = 2
    end
  end
end
