object FrameTextInput: TFrameTextInput
  Left = 0
  Top = 0
  Width = 269
  Height = 37
  TabOrder = 0
  object PanelTextInput: TUniPanel
    Left = 0
    Top = 0
    Width = 269
    Height = 37
    Hint = ''
    Align = alClient
    TabOrder = 0
    BorderStyle = ubsNone
    Caption = ''
    ScrollDirection = sdNone
    object Edit: TUniEdit
      AlignWithMargins = True
      Left = 114
      Top = 3
      Width = 145
      Height = 31
      Hint = ''
      Margins.Left = 10
      Margins.Right = 10
      Text = ''
      Align = alClient
      TabOrder = 1
    end
    object PanelText: TUniPanel
      Left = 0
      Top = 0
      Width = 104
      Height = 37
      Hint = ''
      Align = alLeft
      TabOrder = 2
      BorderStyle = ubsNone
      Caption = 'text'
      ScrollDirection = sdNone
    end
  end
end
