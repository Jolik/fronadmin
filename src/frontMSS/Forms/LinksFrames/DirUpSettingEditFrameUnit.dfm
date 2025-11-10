inherited DirUpSettingEditFrame: TDirUpSettingEditFrame
  inherited SettingsPanel: TUniPanel
    inherited SettingsGroupBox: TUniGroupBox
      inherited SettingsParentPanel: TUniPanel
        ScrollHeight = 429
        ScrollWidth = 427
        ScrollY = 59
        object UniGroupBox1: TUniGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 400
          Height = 158
          Hint = ''
          Caption = #1040#1073#1086#1085#1077#1085#1090' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' '
          Align = alTop
          TabOrder = 1
          ExplicitTop = -56
          inline FrameFolder: TFrameTextInput
            Left = 2
            Top = 15
            Width = 396
            Height = 30
            Align = alTop
            Anchors = [akLeft, akTop, akRight]
            Constraints.MaxHeight = 30
            Constraints.MinHeight = 30
            TabOrder = 1
            Background.Picture.Data = {00}
            ExplicitLeft = 64
            ExplicitTop = 32
            inherited PanelText: TUniPanel
              Caption = #1055#1072#1087#1082#1072
            end
            inherited Edit: TUniEdit
              Width = 225
            end
            inherited PanelUnits: TUniPanel
              Left = 370
              Caption = ''
            end
          end
          object UniGroupBox2: TUniGroupBox
            AlignWithMargins = True
            Left = 12
            Top = 55
            Width = 376
            Height = 90
            Hint = ''
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 10
            Margins.Bottom = 10
            Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1089#1077#1073#1099' '
            Align = alTop
            TabOrder = 2
            ExplicitWidth = 397
            inline FrameSebaSortEnabled: TFrameBoolInput
              Left = 2
              Top = 15
              Width = 372
              Height = 30
              Align = alTop
              Anchors = [akLeft, akTop, akRight]
              Constraints.MaxHeight = 30
              Constraints.MinHeight = 30
              TabOrder = 1
              Background.Picture.Data = {00}
              ExplicitLeft = 32
              ExplicitTop = 32
              inherited PanelText: TUniPanel
                Caption = #1042#1082#1083#1102#1095#1080#1090#1100
              end
              inherited CheckBox: TUniCheckBox
                Width = 234
              end
            end
            inline FrameSebasortPathTemplate: TFrameTextInput
              Left = 2
              Top = 45
              Width = 372
              Height = 30
              Align = alTop
              Anchors = [akLeft, akTop, akRight]
              Constraints.MaxHeight = 30
              Constraints.MinHeight = 30
              TabOrder = 2
              Background.Picture.Data = {00}
              ExplicitLeft = 2
              ExplicitTop = 23423
              ExplicitWidth = 393
              inherited PanelText: TUniPanel
                Caption = #1064#1072#1073#1083#1086#1085' '#1087#1091#1090#1080
              end
              inherited Edit: TUniEdit
                Width = 201
                ExplicitWidth = 246
              end
              inherited PanelUnits: TUniPanel
                Left = 346
                Caption = ''
                ExplicitLeft = 391
              end
            end
          end
        end
        inline FrameQueue1: TFrameQueue
          Left = 0
          Top = 164
          Width = 406
          Height = 59
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
          Background.Picture.Data = {00}
          ExplicitTop = 105
          ExplicitWidth = 406
          inherited FrameQid: TFrameTextInput
            Width = 406
            inherited Edit: TUniEdit
              Width = 235
            end
            inherited PanelUnits: TUniPanel
              Left = 380
            end
          end
          inherited FrameQueueEnable: TFrameBoolInput
            Width = 406
            inherited CheckBox: TUniCheckBox
              Width = 268
            end
          end
        end
        inline FrameOnConflict: TFrameCombobox
          Left = 0
          Top = 223
          Width = 406
          Height = 30
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          Constraints.MaxHeight = 30
          Constraints.MinHeight = 30
          TabOrder = 3
          Background.Picture.Data = {00}
          ExplicitTop = 164
          ExplicitWidth = 406
          inherited PanelText: TUniPanel
            Caption = #1053#1072' '#1082#1086#1085#1092#1083#1080#1082#1090' '#1080#1084#1105#1085
          end
          inherited ComboBox: TUniComboBox
            Width = 235
            Items.Strings = (
              #1079#1072#1076#1077#1088#1078#1072#1090#1100
              #1086#1096#1080#1073#1082#1072
              #1087#1077#1088#1077#1080#1084#1077#1085#1086#1074#1072#1090#1100
              #1087#1088#1080#1085#1103#1090#1100
              #1087#1077#1088#1077#1079#1072#1087#1080#1089#1072#1090#1100
              #1087#1077#1088#1077#1079#1072#1087#1080#1089#1072#1090#1100' '#1080#1083#1080' '#1079#1072#1076#1077#1088#1078#1072#1090#1100)
            ExplicitTop = 2
            ExplicitHeight = 26
          end
          inherited PanelUnits: TUniPanel
            Left = 380
          end
        end
        inline FrameS3: TFrameS3
          Left = 0
          Top = 253
          Width = 406
          Height = 176
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 4
          Background.Picture.Data = {00}
          ExplicitTop = 194
          ExplicitWidth = 406
          inherited UniGroupBox1: TUniGroupBox
            Width = 406
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 298
            ExplicitHeight = 176
            inherited FrameS3Enabled: TFrameBoolInput
              Width = 402
              ExplicitLeft = 2
              ExplicitTop = 15
              ExplicitWidth = 294
              inherited CheckBox: TUniCheckBox
                Width = 264
                ExplicitWidth = 156
              end
            end
            inherited FrameS3AccessKey: TFrameTextInput
              Width = 402
              ExplicitLeft = 2
              ExplicitTop = 75
              ExplicitWidth = 294
              inherited Edit: TUniEdit
                Width = 231
                ExplicitWidth = 123
              end
              inherited PanelUnits: TUniPanel
                Left = 376
                ExplicitLeft = 268
              end
            end
            inherited FrameS3Endpoint: TFrameTextInput
              Width = 402
              ExplicitLeft = 2
              ExplicitTop = 45
              inherited Edit: TUniEdit
                Width = 231
              end
              inherited PanelUnits: TUniPanel
                Left = 376
              end
            end
            inherited FrameS3Secret: TFrameTextInput
              Width = 402
              ExplicitTop = 105
              inherited Edit: TUniEdit
                Width = 231
              end
              inherited PanelUnits: TUniPanel
                Left = 376
              end
            end
            inherited FrameS3Bucket: TFrameTextInput
              Width = 402
              ExplicitTop = 135
              inherited Edit: TUniEdit
                Width = 231
              end
              inherited PanelUnits: TUniPanel
                Left = 376
              end
            end
          end
        end
      end
    end
  end
  inherited ProfilesGroupBox: TUniGroupBox
    inherited ProfilesPanel: TUniPanel
      ScrollHeight = 463
      ScrollWidth = 323
    end
  end
end
