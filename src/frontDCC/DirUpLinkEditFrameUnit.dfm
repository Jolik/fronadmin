inherited DirUpLinkEditFrame: TDirUpLinkEditFrame
  OnCreate = UniFrameCreate
  object DirUpPanel: TUniPanel
    Left = 0
    Top = 0
    Width = 640
    Height = 480
    Hint = ''
    Align = alClient
    TabOrder = 0
    Caption = ''
    object FolderPathEdit: TUniEdit
      Left = 88
      Top = 104
      Width = 121
      Hint = ''
      Text = 'FolderPathEdit'
      TabOrder = 1
    end
    object FolderPathLabel: TUniLabel
      Left = 56
      Top = 85
      Width = 83
      Height = 13
      Hint = ''
      Caption = 'FolderPathLabel'
      TabOrder = 2
    end
    object OnConflictLabel: TUniLabel
      Left = 56
      Top = 152
      Width = 83
      Height = 13
      Hint = ''
      Caption = 'OnConflictLabel'
      TabOrder = 3
    end
    object OnConflictComboBox: TUniComboBox
      Left = 88
      Top = 184
      Width = 145
      Hint = ''
      Text = 'OnConflictComboBox'
      TabOrder = 4
      IconItems = <>
    end
  end
  object FileTTLLabel: TUniLabel
    Left = 56
    Top = 245
    Width = 83
    Height = 13
    Hint = ''
    Caption = 'FolderPathLabel'
    TabOrder = 1
  end
  object FileTTLEdit: TUniEdit
    Left = 88
    Top = 264
    Width = 121
    Hint = ''
    Text = 'FolderPathEdit'
    TabOrder = 2
  end
end
