inherited FrameIntegerInput: TFrameIntegerInput
  Width = 263
  Height = 37
  ExplicitWidth = 263
  ExplicitHeight = 37
  object PanelIntegerInput: TUniPanel
    Left = 0
    Top = 0
    Width = 263
    Height = 37
    Hint = ''
    ParentRTL = False
    Align = alClient
    TabOrder = 0
    BorderStyle = ubsNone
    Caption = ''
    ScrollDirection = sdNone
    Draggable.Enabled = True
    object Edit: TUniEdit
      AlignWithMargins = True
      Left = 115
      Top = 4
      Width = 137
      Height = 29
      Hint = ''
      Margins.Left = 10
      Margins.Right = 10
      Text = ''
      Align = alClient
      TabOrder = 1
      InputType = 'number'
    end
    object PanelText: TUniPanel
      Left = 1
      Top = 1
      Width = 104
      Height = 35
      Hint = ''
      Align = alLeft
      TabOrder = 2
      BorderStyle = ubsNone
      Caption = 'int'
      ScrollDirection = sdNone
    end
  end
end
