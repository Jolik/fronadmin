inherited FTPCliUpLinkSettingEditFrame: TFTPCliUpLinkSettingEditFrame
  Height = 487
  ExplicitHeight = 487
  inherited SettingsPanel: TUniPanel
    Height = 487
    ExplicitHeight = 563
    inherited SettingsGroupBox: TUniGroupBox
      Height = 485
      ExplicitHeight = 561
      inherited UniPanel3: TUniPanel
        Top = 413
        ExplicitTop = 489
      end
      inherited SettingsParentPanel: TUniPanel
        Height = 398
        ExplicitHeight = 474
        ScrollHeight = 398
        ScrollWidth = 427
        inline FrameConnections1: TFrameConnections
          Left = 0
          Top = 0
          Width = 427
          Height = 233
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          Background.Picture.Data = {00}
          ExplicitWidth = 427
          ExplicitHeight = 233
          inherited UniGroupBox1: TUniGroupBox
            AlignWithMargins = True
            Left = 10
            Top = 10
            Width = 407
            Height = 213
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 10
            Margins.Bottom = 10
            ExplicitLeft = 10
            ExplicitTop = 10
            ExplicitWidth = 407
            ExplicitHeight = 245
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
              Visible = False
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
        inline FrameQueue1: TFrameQueue
          Left = 0
          Top = 233
          Width = 427
          Height = 59
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
          Background.Picture.Data = {00}
          ExplicitLeft = 132
          ExplicitTop = 394
          inherited FrameQid: TFrameTextInput
            Width = 427
            inherited Edit: TUniEdit
              Width = 256
            end
            inherited PanelUnits: TUniPanel
              Left = 401
            end
          end
          inherited FrameQueueEnable: TFrameBoolInput
            Width = 427
            inherited CheckBox: TUniCheckBox
              Width = 289
            end
          end
        end
        object UniGroupBox1: TUniGroupBox
          AlignWithMargins = True
          Left = 10
          Top = 302
          Width = 407
          Height = 54
          Hint = ''
          Margins.Left = 10
          Margins.Top = 10
          Margins.Right = 10
          Margins.Bottom = 10
          Caption = #1040#1073#1086#1085#1077#1085#1090' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' '
          Align = alTop
          TabOrder = 3
          ExplicitTop = 343
          inline FrameFolder: TFrameTextInput
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
            ExplicitWidth = 417
            inherited PanelText: TUniPanel
              Caption = #1055#1072#1087#1082#1072
            end
            inherited Edit: TUniEdit
              Width = 232
              ExplicitWidth = 246
            end
            inherited PanelUnits: TUniPanel
              Left = 377
              Caption = ''
              ExplicitLeft = 391
            end
          end
        end
      end
    end
  end
  inherited ProfilesGroupBox: TUniGroupBox
    Height = 487
    ExplicitHeight = 563
    inherited ProfilesPanel: TUniPanel
      Height = 470
      ExplicitHeight = 546
      ScrollHeight = 470
      ScrollWidth = 323
    end
  end
  inherited UniSplitter1: TUniSplitter
    Height = 487
    ExplicitHeight = 563
  end
end
