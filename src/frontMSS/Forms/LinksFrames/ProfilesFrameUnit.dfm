﻿object ProfilesFrame: TProfilesFrame
  Left = 0
  Top = 0
  Width = 292
  Height = 311
  TabOrder = 0
  object profilePanel: TUniPanel
    AlignWithMargins = True
    Left = 3
    Top = 40
    Width = 286
    Height = 238
    Hint = ''
    Margins.Top = 10
    AutoScroll = True
    Align = alClient
    TabOrder = 0
    BorderStyle = ubsNone
    ShowCaption = False
    Caption = 'profilePanel'
    ScrollHeight = 238
    ScrollWidth = 286
  end
  object UniPanel3: TUniPanel
    Left = 0
    Top = 0
    Width = 292
    Height = 30
    Hint = ''
    Constraints.MaxHeight = 30
    Constraints.MinHeight = 30
    Align = alTop
    TabOrder = 1
    BorderStyle = ubsSingle
    ShowCaption = False
    Caption = 'UniPanel3'
    object btnRemoveProfile: TUniBitBtn
      AlignWithMargins = True
      Left = 264
      Top = 3
      Width = 25
      Height = 24
      Hint = #1091#1076#1072#1083#1080#1090#1100' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1077' '#1088#1072#1073#1086#1090#1099
      ShowHint = True
      ParentShowHint = False
      Caption = '-'
      Align = alRight
      TabOrder = 1
      OnClick = btnRemoveProfileClick
      ExplicitLeft = 261
    end
    object btnAddProfile: TUniBitBtn
      AlignWithMargins = True
      Left = 233
      Top = 3
      Width = 25
      Height = 24
      Hint = #1076#1086#1073#1072#1074#1080#1090#1100' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1077' '#1088#1072#1073#1086#1090#1099
      ShowHint = True
      ParentShowHint = False
      Caption = '+'
      Align = alRight
      TabOrder = 2
      OnClick = btnAddProfileClick
      ExplicitLeft = 230
    end
    object profilesComboBox: TUniComboBox
      AlignWithMargins = True
      Left = 10
      Top = 3
      Width = 210
      Height = 24
      Hint = ''
      Margins.Left = 10
      Margins.Right = 10
      Style = csOwnerDrawFixed
      Text = ''
      Align = alClient
      TabOrder = 3
      IconItems = <>
      OnSelect = profilesComboBoxSelect
      ExplicitWidth = 207
    end
  end
  object UniPanel1: TUniPanel
    Left = 0
    Top = 281
    Width = 292
    Height = 30
    Hint = ''
    Constraints.MaxHeight = 30
    Constraints.MinHeight = 30
    Align = alBottom
    TabOrder = 2
    BorderStyle = ubsNone
    ShowCaption = False
    Caption = 'UniPanel1'
    object BitBtnSaveProfile: TUniBitBtn
      AlignWithMargins = True
      Left = 203
      Top = 3
      Width = 86
      Height = 24
      Hint = ''
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Align = alRight
      TabOrder = 1
      OnClick = BitBtnSaveProfileClick
    end
  end
end
