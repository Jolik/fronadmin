inherited SMTPSrvDownLinkSettingEditFrame: TSMTPSrvDownLinkSettingEditFrame
  inherited SettingsPanel: TUniPanel
    inherited SettingsGroupBox: TUniGroupBox
      inherited SettingsParentPanel: TUniPanel
        ScrollHeight = 391
        ScrollWidth = 427
        inline FrameConnections1: TFrameConnections
          Left = 0
          Top = 0
          Width = 427
          Height = 105
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          Background.Picture.Data = {00}
          ExplicitTop = 8
          ExplicitWidth = 427
          ExplicitHeight = 105
          inherited UniGroupBox1: TUniGroupBox
            AlignWithMargins = True
            Left = 10
            Top = 10
            Width = 407
            Height = 85
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
