inherited SMTPClieUpLinkSettingEditFrame: TSMTPClieUpLinkSettingEditFrame
  Height = 687
  ExplicitHeight = 687
  inherited SettingsPanel: TUniPanel
    Height = 687
    inherited SettingsGroupBox: TUniGroupBox
      Height = 685
      inherited UniPanel3: TUniPanel
        Top = 613
      end
      inherited SettingsParentPanel: TUniPanel
        Height = 598
        ExplicitHeight = 739
        ScrollHeight = 598
        ScrollWidth = 427
        inline FrameConnections1: TFrameConnections
          Left = 0
          Top = 0
          Width = 427
          Height = 425
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          Background.Picture.Data = {00}
          ExplicitTop = -55
          ExplicitWidth = 406
          ExplicitHeight = 425
          inherited UniGroupBox1: TUniGroupBox
            AlignWithMargins = True
            Left = 10
            Top = 10
            Width = 407
            Height = 405
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 10
            Margins.Bottom = 10
            ExplicitLeft = 10
            ExplicitTop = 10
            ExplicitWidth = 407
            ExplicitHeight = 185
            inherited FrameAddr: TFrameTextInput
              Width = 403
              ExplicitWidth = 423
              inherited Edit: TUniEdit
                Width = 232
                ExplicitWidth = 252
              end
              inherited PanelUnits: TUniPanel
                Left = 377
                ExplicitLeft = 397
              end
            end
            inherited FrameTimeout: TFrameTextInput
              Width = 403
              ExplicitWidth = 423
              inherited Edit: TUniEdit
                Width = 232
                ExplicitWidth = 252
              end
              inherited PanelUnits: TUniPanel
                Left = 377
                ExplicitLeft = 397
              end
            end
            inherited UniGroupBox3: TUniGroupBox
              Width = 383
              ExplicitTop = 145
              ExplicitWidth = 403
              inherited FrameLogin: TFrameTextInput
                Width = 379
                ExplicitWidth = 399
                inherited Edit: TUniEdit
                  Width = 208
                  ExplicitWidth = 228
                end
                inherited PanelUnits: TUniPanel
                  Left = 353
                  ExplicitLeft = 373
                end
              end
              inherited FramePassword: TFrameTextInput
                Width = 379
                ExplicitWidth = 399
                inherited Edit: TUniEdit
                  Width = 208
                  ExplicitWidth = 228
                end
                inherited PanelUnits: TUniPanel
                  Left = 353
                  ExplicitLeft = 373
                end
              end
            end
            inherited UniGroupBox2: TUniGroupBox
              Width = 383
              ExplicitTop = 249
              ExplicitWidth = 403
              inherited FrameTLSEnable: TFrameBoolInput
                Width = 379
                ExplicitWidth = 399
                inherited CheckBox: TUniCheckBox
                  Width = 241
                  ExplicitWidth = 261
                end
              end
              inherited UniGroupBox4: TUniGroupBox
                Width = 359
                ExplicitWidth = 379
                inherited FrameCRT: TFrameTextInput
                  Width = 355
                  ExplicitWidth = 375
                  inherited Edit: TUniEdit
                    Width = 184
                    ExplicitWidth = 204
                  end
                  inherited PanelUnits: TUniPanel
                    Left = 329
                    ExplicitLeft = 349
                  end
                end
                inherited FrameCertKey: TFrameTextInput
                  Width = 355
                  ExplicitWidth = 375
                  inherited Edit: TUniEdit
                    Width = 184
                    ExplicitWidth = 204
                  end
                  inherited PanelUnits: TUniPanel
                    Left = 329
                    ExplicitLeft = 349
                  end
                end
                inherited FrameCertCA: TFrameTextInput
                  Width = 355
                  ExplicitWidth = 375
                  inherited Edit: TUniEdit
                    Width = 184
                    ExplicitWidth = 204
                  end
                  inherited PanelUnits: TUniPanel
                    Left = 329
                    ExplicitLeft = 349
                  end
                end
              end
            end
            inherited FrameConnectionKey: TFrameTextInput
              Width = 403
              Visible = False
              Enabled = False
              ExplicitWidth = 423
              inherited PanelText: TUniPanel
                ExplicitLeft = 0
                ExplicitTop = 0
              end
              inherited Edit: TUniEdit
                Width = 232
                ExplicitWidth = 252
              end
              inherited PanelUnits: TUniPanel
                Left = 377
                ExplicitLeft = 397
              end
            end
            inherited FrameReplaceIP: TFrameBoolInput
              Width = 403
              Visible = False
              ExplicitTop = 105
              ExplicitWidth = 423
              inherited PanelText: TUniPanel
                ExplicitTop = 0
              end
              inherited CheckBox: TUniCheckBox
                Width = 265
                ExplicitWidth = 285
              end
            end
          end
        end
        object UniGroupBox1: TUniGroupBox
          AlignWithMargins = True
          Left = 10
          Top = 494
          Width = 407
          Height = 54
          Hint = ''
          Margins.Left = 10
          Margins.Top = 10
          Margins.Right = 10
          Margins.Bottom = 10
          Caption = #1040#1073#1086#1085#1077#1085#1090' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' '
          Align = alTop
          TabOrder = 2
          ExplicitTop = 343
          inline FrameEmail: TFrameTextInput
            Left = 2
            Top = 15
            Width = 403
            Height = 30
            Align = alTop
            Anchors = [akLeft, akTop, akRight]
            Constraints.MaxHeight = 30
            Constraints.MinHeight = 30
            TabOrder = 1
            Background.Picture.Data = {00}
            ExplicitLeft = 2
            ExplicitTop = 15
            ExplicitWidth = 403
            inherited PanelText: TUniPanel
              Caption = 'E-mail '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103
            end
            inherited Edit: TUniEdit
              Width = 232
              ExplicitWidth = 232
            end
            inherited PanelUnits: TUniPanel
              Left = 377
              Caption = ''
              ExplicitLeft = 377
            end
          end
        end
        inline FrameMeteoAttach: TFrameBoolInput
          Left = 0
          Top = 558
          Width = 427
          Height = 30
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          Constraints.MaxHeight = 30
          Constraints.MinHeight = 30
          TabOrder = 3
          Background.Picture.Data = {00}
          ExplicitTop = 21312
          ExplicitWidth = 427
          inherited PanelText: TUniPanel
            Caption = #1055#1088#1080#1082#1088#1077#1087#1083#1103#1090#1100' '#1090#1077#1083#1086
          end
          inherited CheckBox: TUniCheckBox
            Width = 289
            ExplicitWidth = 289
          end
        end
        inline FrameQueue1: TFrameQueue
          Left = 0
          Top = 425
          Width = 427
          Height = 59
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 4
          Background.Picture.Data = {00}
          ExplicitTop = 164
          ExplicitWidth = 406
          inherited FrameQid: TFrameTextInput
            Width = 427
            ExplicitWidth = 406
            inherited Edit: TUniEdit
              Width = 256
              ExplicitWidth = 235
            end
            inherited PanelUnits: TUniPanel
              Left = 401
              ExplicitLeft = 380
            end
          end
          inherited FrameQueueEnable: TFrameBoolInput
            Width = 427
            ExplicitWidth = 406
            inherited CheckBox: TUniCheckBox
              Width = 289
              ExplicitWidth = 268
            end
          end
        end
      end
    end
  end
  inherited ProfilesGroupBox: TUniGroupBox
    Height = 687
    inherited ProfilesPanel: TUniPanel
      Height = 670
      ScrollHeight = 670
      ScrollWidth = 323
    end
  end
  inherited UniSplitter1: TUniSplitter
    Height = 687
  end
end
