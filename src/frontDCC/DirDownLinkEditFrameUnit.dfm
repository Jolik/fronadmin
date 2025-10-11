inherited DirDownLinkEditFrame: TDirDownLinkEditFrame
  OnCreate = UniFrameCreate
  object DirDownPanel: TUniPanel
    Left = 0
    Top = 0
    Width = 640
    Height = 480
    Hint = ''
    Align = alClient
    TabOrder = 0
    Caption = ''
    ExplicitLeft = 16
    ExplicitTop = -3
    object DirPathLabel: TUniLabel
      Left = 56
      Top = 85
      Width = 65
      Height = 13
      Hint = ''
      Caption = 'DirPathLabel'
      TabOrder = 1
    end
    object DirPathEdit: TUniEdit
      Left = 88
      Top = 104
      Width = 121
      Hint = ''
      Text = 'DirPathEdit'
      TabOrder = 2
    end
    object ParseMeteoCheckBox: TUniCheckBox
      Left = 112
      Top = 208
      Width = 97
      Height = 17
      Hint = ''
      Caption = 'ParseMeteoCheckBox'
      TabOrder = 3
    end
  end
  object DirDepthLabel: TUniLabel
    Left = 56
    Top = 149
    Width = 83
    Height = 13
    Hint = ''
    Caption = 'FolderPathLabel'
    TabOrder = 1
  end
  object DirDepthEdit: TUniEdit
    Left = 88
    Top = 168
    Width = 121
    Hint = ''
    Text = 'FolderPathEdit'
    TabOrder = 2
  end
  object DistributionKeyLabel: TUniLabel
    Left = 56
    Top = 237
    Width = 83
    Height = 13
    Hint = ''
    Caption = 'FolderPathLabel'
    TabOrder = 3
  end
  object DistributionKeyEdit: TUniEdit
    Left = 88
    Top = 256
    Width = 121
    Hint = ''
    Text = 'FolderPathEdit'
    TabOrder = 4
  end
  object FilterRegexCheckBox: TUniCheckBox
    Left = 344
    Top = 81
    Width = 97
    Height = 17
    Hint = ''
    Caption = 'FilterRegexCheckBox'
    TabOrder = 5
  end
  object RegexPatternLabel: TUniLabel
    Left = 328
    Top = 121
    Width = 83
    Height = 13
    Hint = ''
    Caption = 'FolderPathLabel'
    TabOrder = 6
  end
  object RegexPatternEdit: TUniEdit
    Left = 360
    Top = 140
    Width = 121
    Hint = ''
    Text = 'FolderPathEdit'
    TabOrder = 7
  end
  object IgnoreTmpCheckBox: TUniCheckBox
    Left = 344
    Top = 200
    Width = 97
    Height = 17
    Hint = ''
    Caption = 'IgnoreTmpCheckBox'
    TabOrder = 8
  end
  object SchedulePauseLabel: TUniLabel
    Left = 328
    Top = 237
    Width = 83
    Height = 13
    Hint = ''
    Caption = 'FolderPathLabel'
    TabOrder = 9
  end
  object SchedulePauseEdit: TUniEdit
    Left = 360
    Top = 256
    Width = 121
    Hint = ''
    Text = 'FolderPathEdit'
    TabOrder = 10
  end
end
