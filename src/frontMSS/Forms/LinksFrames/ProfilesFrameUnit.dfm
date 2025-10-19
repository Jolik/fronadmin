object ProfilesFrame: TProfilesFrame
  Left = 0
  Top = 0
  Width = 350
  Height = 402
  TabOrder = 0
  object UniPanel2: TUniPanel
    Left = 0
    Top = 0
    Width = 350
    Height = 96
    Hint = ''
    Align = alTop
    TabOrder = 0
    BorderStyle = ubsSingle
    ShowCaption = False
    Caption = 'UniPanel2'
    object listboxProfiles: TUniListBox
      Left = 0
      Top = 0
      Width = 312
      Height = 96
      Hint = ''
      Align = alClient
      TabOrder = 1
      OnChange = listboxProfilesChange
    end
    object UniPanel3: TUniPanel
      Left = 312
      Top = 0
      Width = 38
      Height = 96
      Hint = ''
      Align = alRight
      TabOrder = 2
      BorderStyle = ubsNone
      ShowCaption = False
      Caption = 'UniPanel3'
      object btnRemoveProfile: TUniBitBtn
        AlignWithMargins = True
        Left = 3
        Top = 42
        Width = 32
        Height = 33
        Hint = ''
        Caption = '-'
        Align = alTop
        TabOrder = 1
        OnClick = btnRemoveProfileClick
      end
      object btnAddProfile: TUniBitBtn
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 32
        Height = 33
        Hint = ''
        Caption = '+'
        Align = alTop
        TabOrder = 2
      end
    end
  end
  object profilePanel: TUniPanel
    Left = 0
    Top = 96
    Width = 350
    Height = 306
    Hint = ''
    Align = alClient
    TabOrder = 1
    BorderStyle = ubsNone
    ShowCaption = False
    Caption = 'profilePanel'
  end
end
