inherited Pop3CliDownLinkSettingEditFrame: TPop3CliDownLinkSettingEditFrame
  Height = 798
  ExplicitHeight = 798
  inherited SettingsPanel: TUniPanel
    Height = 798
    inherited SettingsGroupBox: TUniGroupBox
      Height = 796
      inherited UniPanel3: TUniPanel
        Top = 724
      end
      inherited SettingsParentPanel: TUniPanel
        Height = 709
        ScrollHeight = 709
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
          ExplicitWidth = 427
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
        inline FrameSchedule1: TFrameSchedule
          AlignWithMargins = True
          Left = 10
          Top = 435
          Width = 407
          Height = 208
          Margins.Left = 10
          Margins.Top = 10
          Margins.Right = 10
          Margins.Bottom = 10
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
          Background.Picture.Data = {00}
          ExplicitLeft = 10
          ExplicitTop = 397
          ExplicitWidth = 407
          inherited UniGroupBox1: TUniGroupBox
            Width = 407
            ExplicitWidth = 386
            ExplicitHeight = 208
            inherited UniPanel1: TUniPanel
              Width = 403
              ExplicitTop = 45
              ExplicitWidth = 382
              inherited FrameScheduleCron: TFrameTextInput
                Width = 403
                ExplicitLeft = 0
                ExplicitTop = 30
                ExplicitWidth = 382
                inherited Edit: TUniEdit
                  Width = 232
                  ExplicitWidth = 211
                end
                inherited PanelUnits: TUniPanel
                  Left = 377
                  ExplicitLeft = 356
                end
              end
              inherited FrameSchedulePeriod: TFrameTextInput
                Width = 403
                ExplicitLeft = 0
                ExplicitTop = 60
                ExplicitWidth = 382
                inherited Edit: TUniEdit
                  Width = 232
                  ExplicitLeft = 135
                  ExplicitWidth = 211
                end
                inherited PanelUnits: TUniPanel
                  Left = 377
                  ExplicitLeft = 356
                end
              end
              inherited FrameScheduleEnabled: TFrameBoolInput
                Width = 403
                ExplicitLeft = 0
                ExplicitWidth = 382
                inherited PanelText: TUniPanel
                  ExplicitLeft = 0
                  ExplicitTop = 0
                end
                inherited CheckBox: TUniCheckBox
                  Width = 265
                  ExplicitWidth = 244
                end
              end
              inherited FrameScheduleRetry: TFrameTextInput
                Width = 403
                ExplicitLeft = 0
                ExplicitTop = 90
                ExplicitWidth = 382
                inherited PanelText: TUniPanel
                  ExplicitLeft = 0
                  ExplicitTop = 0
                end
                inherited Edit: TUniEdit
                  Width = 232
                  ExplicitWidth = 211
                end
                inherited PanelUnits: TUniPanel
                  Left = 377
                  ExplicitLeft = 356
                end
              end
              inherited FrameScheduleDelay: TFrameTextInput
                Width = 403
                ExplicitLeft = 0
                ExplicitTop = 120
                ExplicitWidth = 382
                inherited PanelText: TUniPanel
                  ExplicitLeft = 0
                  ExplicitTop = 0
                end
                inherited Edit: TUniEdit
                  Width = 232
                  ExplicitLeft = 135
                  ExplicitWidth = 211
                end
                inherited PanelUnits: TUniPanel
                  Left = 377
                  ExplicitLeft = 356
                end
              end
            end
            inherited UniPanel3: TUniPanel
              Width = 403
              ExplicitWidth = 382
              inherited btnRemoveJob: TUniBitBtn
                ExplicitLeft = 261
              end
              inherited btnAddJob: TUniBitBtn
                ExplicitLeft = 230
              end
              inherited JobsComboBox: TUniComboBox
                ExplicitLeft = 10
              end
            end
          end
        end
        inline FrameDelete: TFrameBoolInput
          Left = 0
          Top = 653
          Width = 427
          Height = 30
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          Constraints.MaxHeight = 30
          Constraints.MinHeight = 30
          TabOrder = 3
          Background.Picture.Data = {00}
          ExplicitTop = 32323
          ExplicitWidth = 427
          inherited PanelText: TUniPanel
            Caption = #1059#1076#1072#1083#1103#1090#1100' '#1087#1080#1089#1100#1084#1072
          end
          inherited CheckBox: TUniCheckBox
            Width = 289
            ExplicitWidth = 285
          end
        end
      end
    end
  end
  inherited ProfilesGroupBox: TUniGroupBox
    Height = 798
    inherited ProfilesPanel: TUniPanel
      Height = 781
      ScrollHeight = 781
      ScrollWidth = 323
    end
  end
  inherited UniSplitter1: TUniSplitter
    Height = 798
  end
end
