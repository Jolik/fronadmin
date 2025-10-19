inherited OpenMCEPSettingEditFrame: TOpenMCEPSettingEditFrame
  Height = 574
  ExplicitHeight = 574
  inherited SettingsPanel: TUniPanel
    Height = 574
    ExplicitHeight = 574
    inherited SettingsGroupBox: TUniGroupBox
      Height = 572
      ExplicitHeight = 572
      inherited UniPanel3: TUniPanel
        Top = 500
        ExplicitTop = 500
      end
      inherited SettingsParentPanel: TUniPanel
        Height = 485
        ExplicitHeight = 485
        ScrollHeight = 485
        ScrollWidth = 427
        inline FrameConnections1: TFrameConnections
          Left = 0
          Top = 30
          Width = 427
          Height = 81
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          Background.Picture.Data = {00}
          ExplicitTop = 30
          ExplicitWidth = 427
          ExplicitHeight = 81
          inherited UniGroupBox1: TUniGroupBox
            Width = 427
            Height = 81
            ExplicitWidth = 427
            ExplicitHeight = 81
            inherited FrameAddr: TFrameTextInput
              Width = 423
              ExplicitWidth = 423
              inherited Edit: TUniEdit
                Width = 252
                ExplicitWidth = 252
              end
              inherited PanelUnits: TUniPanel
                Left = 397
                ExplicitLeft = 397
              end
            end
            inherited FrameTimeout: TFrameTextInput
              Width = 423
              ExplicitWidth = 423
              inherited Edit: TUniEdit
                Width = 252
                ExplicitWidth = 252
              end
              inherited PanelUnits: TUniPanel
                Left = 397
                ExplicitLeft = 397
              end
            end
            inherited UniGroupBox3: TUniGroupBox
              Width = 403
              ExplicitWidth = 403
              inherited FrameLogin: TFrameTextInput
                Width = 399
                ExplicitWidth = 399
                inherited Edit: TUniEdit
                  Width = 228
                  ExplicitWidth = 228
                end
                inherited PanelUnits: TUniPanel
                  Left = 373
                  ExplicitLeft = 373
                end
              end
              inherited FramePassword: TFrameTextInput
                Width = 399
                ExplicitWidth = 399
                inherited Edit: TUniEdit
                  Width = 228
                  ExplicitWidth = 228
                end
                inherited PanelUnits: TUniPanel
                  Left = 373
                  ExplicitLeft = 373
                end
              end
            end
            inherited UniGroupBox2: TUniGroupBox
              Width = 403
              ExplicitWidth = 403
              inherited FrameTLSEnable: TFrameBoolInput
                Width = 399
                ExplicitWidth = 399
                inherited CheckBox: TUniCheckBox
                  Width = 261
                  ExplicitWidth = 261
                end
              end
              inherited UniGroupBox4: TUniGroupBox
                Width = 379
                ExplicitWidth = 379
                inherited FrameCRT: TFrameTextInput
                  Width = 375
                  ExplicitWidth = 375
                  inherited Edit: TUniEdit
                    Width = 204
                    ExplicitWidth = 204
                  end
                  inherited PanelUnits: TUniPanel
                    Left = 349
                    ExplicitLeft = 349
                  end
                end
                inherited FrameCertKey: TFrameTextInput
                  Width = 375
                  ExplicitWidth = 375
                  inherited Edit: TUniEdit
                    Width = 204
                    ExplicitWidth = 204
                  end
                  inherited PanelUnits: TUniPanel
                    Left = 349
                    ExplicitLeft = 349
                  end
                end
                inherited FrameCertCA: TFrameTextInput
                  Width = 375
                  ExplicitWidth = 375
                  inherited Edit: TUniEdit
                    Width = 204
                    ExplicitWidth = 204
                  end
                  inherited PanelUnits: TUniPanel
                    Left = 349
                    ExplicitLeft = 349
                  end
                end
              end
            end
            inherited FrameConnectionKey: TFrameTextInput
              Width = 423
              ExplicitWidth = 423
              inherited Edit: TUniEdit
                Width = 252
                ExplicitWidth = 252
              end
              inherited PanelUnits: TUniPanel
                Left = 397
                ExplicitLeft = 397
              end
            end
          end
        end
        inline FrameQueue1: TFrameQueue
          Left = 0
          Top = 111
          Width = 427
          Height = 59
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
          Background.Picture.Data = {00}
          ExplicitTop = 111
          ExplicitWidth = 427
          inherited FrameQid: TFrameTextInput
            Width = 427
            ExplicitWidth = 427
            inherited Edit: TUniEdit
              Width = 256
              ExplicitWidth = 256
            end
            inherited PanelUnits: TUniPanel
              Left = 401
              ExplicitLeft = 401
            end
          end
          inherited FrameQueueEnable: TFrameBoolInput
            Width = 427
            ExplicitWidth = 427
            inherited CheckBox: TUniCheckBox
              Width = 289
              ExplicitWidth = 289
            end
          end
        end
        inline FrameAType: TFrameCombobox
          Left = 0
          Top = 0
          Width = 427
          Height = 30
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          Constraints.MaxHeight = 30
          Constraints.MinHeight = 30
          TabOrder = 3
          Background.Picture.Data = {00}
          ExplicitWidth = 427
          inherited PanelText: TUniPanel
            Caption = #1058#1080#1087
          end
          inherited ComboBox: TUniComboBox
            Width = 256
            Text = #1089#1077#1088#1074#1077#1088
            Items.Strings = (
              #1089#1077#1088#1074#1077#1088
              #1082#1083#1080#1077#1085#1090)
            ItemIndex = 0
            ExplicitTop = 2
            ExplicitWidth = 256
            ExplicitHeight = 26
          end
          inherited PanelUnits: TUniPanel
            Left = 401
            ExplicitLeft = 401
          end
        end
        inline FrameDir: TFrameTextInput
          Left = 0
          Top = 170
          Width = 427
          Height = 30
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          Constraints.MaxHeight = 30
          Constraints.MinHeight = 30
          TabOrder = 4
          Background.Picture.Data = {00}
          ExplicitTop = 170
          ExplicitWidth = 427
          inherited PanelText: TUniPanel
            Caption = #1055#1072#1087#1082#1072' '#1074#1088#1077#1084'. '#1092#1072#1081#1083#1086#1074
          end
          inherited Edit: TUniEdit
            Width = 256
            ExplicitWidth = 256
          end
          inherited PanelUnits: TUniPanel
            Left = 401
            Caption = ''
            ExplicitLeft = 401
          end
        end
        object UniGroupBox2: TUniGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 203
          Width = 421
          Height = 191
          Hint = ''
          Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '
          Align = alTop
          TabOrder = 5
          inline FramePostponeTimeout: TFrameTextInput
            Left = 2
            Top = 15
            Width = 417
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
              Caption = #1058#1072#1081#1084#1072#1091#1090' '#1086#1090#1083#1086#1078'.'
            end
            inherited Edit: TUniEdit
              Width = 246
              InputType = 'number'
              ExplicitWidth = 246
            end
            inherited PanelUnits: TUniPanel
              Left = 391
              ExplicitLeft = 391
            end
          end
        end
      end
    end
  end
  inherited ProfilesGroupBox: TUniGroupBox
    Height = 574
    ExplicitHeight = 574
  end
  inherited UniSplitter1: TUniSplitter
    Height = 574
    ExplicitHeight = 574
  end
end
