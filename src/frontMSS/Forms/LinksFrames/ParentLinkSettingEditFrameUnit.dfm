object ParentLinkSettingEditFrame: TParentLinkSettingEditFrame
  Left = 0
  Top = 0
  Width = 853
  Height = 430
  TabOrder = 0
  object SettingsPanel: TUniPanel
    Left = 0
    Top = 0
    Width = 433
    Height = 430
    Hint = ''
    Constraints.MinWidth = 20
    Align = alLeft
    TabOrder = 0
    ShowCaption = False
    Caption = 'SettingsPanel'
    object SettingsGroupBox: TUniGroupBox
      Left = 1
      Top = 1
      Width = 431
      Height = 428
      Hint = ''
      Caption = ' '#1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1083#1080#1085#1082#1072' '
      Align = alClient
      TabOrder = 1
      object UniPanel3: TUniPanel
        Left = 2
        Top = 356
        Width = 427
        Height = 70
        Hint = ''
        Align = alBottom
        TabOrder = 1
        BorderStyle = ubsNone
        ShowCaption = False
        Caption = 'UniPanel3'
        inline ActiveTimeoutFrame: TFrameTextInput
          Left = 0
          Top = 0
          Width = 427
          Height = 30
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          Constraints.MaxHeight = 30
          Constraints.MinHeight = 30
          TabOrder = 1
          Background.Picture.Data = {00}
          ExplicitWidth = 427
          inherited PanelText: TUniPanel
            Caption = #1058#1072#1081#1084#1072#1091#1090' '#1072#1082#1090#1080#1074#1085#1086#1089#1090#1080
          end
          inherited Edit: TUniEdit
            Width = 256
            Text = 'number'
            InputType = 'number'
            ExplicitWidth = 256
          end
          inherited PanelUnits: TUniPanel
            Left = 401
            ExplicitLeft = 401
          end
        end
        inline DumpFrame: TFrameBoolInput
          Left = 0
          Top = 30
          Width = 427
          Height = 30
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          Constraints.MaxHeight = 30
          Constraints.MinHeight = 30
          TabOrder = 2
          Background.Picture.Data = {00}
          ExplicitTop = 30
          ExplicitWidth = 427
          inherited PanelText: TUniPanel
            Caption = #1054#1090#1083#1072#1076#1082#1072
          end
          inherited CheckBox: TUniCheckBox
            Width = 289
            ExplicitWidth = 289
          end
        end
      end
      object SettingsParentPanel: TUniPanel
        Left = 2
        Top = 15
        Width = 427
        Height = 341
        Hint = ''
        AutoScroll = True
        Align = alClient
        TabOrder = 2
        BorderStyle = ubsNone
        ShowCaption = False
        Caption = 'SettingsParentPanel'
        ScrollHeight = 341
        ScrollWidth = 427
      end
    end
  end
  object ProfilesGroupBox: TUniGroupBox
    Left = 439
    Top = 0
    Width = 414
    Height = 430
    Hint = ''
    Caption = ' '#1055#1088#1086#1092#1080#1083#1080' '#1083#1080#1085#1082#1072
    Align = alClient
    TabOrder = 1
    object ProfilesPanel: TUniPanel
      Left = 2
      Top = 15
      Width = 410
      Height = 413
      Hint = ''
      AutoScroll = True
      Align = alClient
      TabOrder = 1
      BorderStyle = ubsNone
      ShowCaption = False
      Caption = 'ProfilesPanel'
      ScrollHeight = 413
      ScrollWidth = 410
    end
  end
  object UniSplitter1: TUniSplitter
    Left = 433
    Top = 0
    Width = 6
    Height = 430
    Hint = ''
    Align = alLeft
    ParentColor = False
    Color = clBtnFace
  end
end
