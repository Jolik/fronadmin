inherited SocketSpecialSettingEditFrame: TSocketSpecialSettingEditFrame
  Width = 683
  Height = 657
  ExplicitWidth = 683
  ExplicitHeight = 657
  inherited SettingsPanel: TUniPanel
    Width = 345
    Height = 657
    ExplicitWidth = 345
    ExplicitHeight = 657
    inherited SettingsGroupBox: TUniGroupBox
      Width = 343
      Height = 655
      ExplicitHeight = 655
      inherited UniPanel3: TUniPanel
        Top = 583
        Width = 339
        ExplicitTop = 579
        inherited ActivTimeoutFrame: TFrameTextInput
          Width = 339
          inherited Edit: TUniEdit
            Width = 168
          end
          inherited PanelUnits: TUniPanel
            Left = 313
          end
        end
        inherited DumpFrame: TFrameBoolInput
          Width = 339
          inherited CheckBox: TUniCheckBox
            Width = 201
          end
        end
      end
      inherited SettingsParentPanel: TUniPanel
        Width = 339
        Height = 568
        ExplicitHeight = 564
        ScrollHeight = 568
        ScrollWidth = 339
        inline FrameConnections1: TFrameConnections
          AlignWithMargins = True
          Left = 3
          Top = 63
          Width = 333
          Height = 82
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          Background.Picture.Data = {00}
          ExplicitLeft = 3
          ExplicitTop = 63
          ExplicitWidth = 421
          ExplicitHeight = 82
          inherited UniGroupBox1: TUniGroupBox
            Width = 333
            Height = 82
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 10
            Margins.Bottom = 10
            ExplicitWidth = 421
            ExplicitHeight = 82
            inherited FrameAddr: TFrameTextInput
              Width = 329
              ExplicitWidth = 417
              inherited Edit: TUniEdit
                Width = 158
                ExplicitWidth = 246
              end
              inherited PanelUnits: TUniPanel
                Left = 303
                ExplicitLeft = 391
              end
            end
            inherited FrameTimeout: TFrameTextInput
              Width = 329
              ExplicitWidth = 417
              inherited Edit: TUniEdit
                Width = 158
                ExplicitWidth = 246
              end
              inherited PanelUnits: TUniPanel
                Left = 303
                ExplicitLeft = 391
              end
            end
            inherited UniGroupBox3: TUniGroupBox
              Width = 309
              ExplicitWidth = 397
              inherited FrameLogin: TFrameTextInput
                Width = 305
                ExplicitWidth = 393
                inherited Edit: TUniEdit
                  Width = 134
                  ExplicitWidth = 222
                end
                inherited PanelUnits: TUniPanel
                  Left = 279
                  ExplicitLeft = 367
                end
              end
              inherited FramePassword: TFrameTextInput
                Width = 305
                ExplicitWidth = 393
                inherited Edit: TUniEdit
                  Width = 134
                  ExplicitWidth = 222
                end
                inherited PanelUnits: TUniPanel
                  Left = 279
                  ExplicitLeft = 367
                end
              end
            end
            inherited UniGroupBox2: TUniGroupBox
              Width = 309
              ExplicitWidth = 397
              inherited FrameTLSEnable: TFrameBoolInput
                Width = 305
                ExplicitWidth = 393
                inherited CheckBox: TUniCheckBox
                  Width = 167
                  ExplicitWidth = 255
                end
              end
              inherited UniGroupBox4: TUniGroupBox
                Width = 285
                ExplicitWidth = 373
                inherited FrameCRT: TFrameTextInput
                  Width = 281
                  ExplicitWidth = 369
                  inherited Edit: TUniEdit
                    Width = 110
                    ExplicitWidth = 198
                  end
                  inherited PanelUnits: TUniPanel
                    Left = 255
                    ExplicitLeft = 343
                  end
                end
                inherited FrameCertKey: TFrameTextInput
                  Width = 281
                  ExplicitWidth = 369
                  inherited Edit: TUniEdit
                    Width = 110
                    ExplicitWidth = 198
                  end
                  inherited PanelUnits: TUniPanel
                    Left = 255
                    ExplicitLeft = 343
                  end
                end
                inherited FrameCertCA: TFrameTextInput
                  Width = 281
                  ExplicitWidth = 369
                  inherited Edit: TUniEdit
                    Width = 110
                    ExplicitWidth = 198
                  end
                  inherited PanelUnits: TUniPanel
                    Left = 255
                    ExplicitLeft = 343
                  end
                end
              end
            end
          end
        end
        inline FrameQueue1: TFrameQueue
          Left = 0
          Top = 178
          Width = 339
          Height = 66
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
          Background.Picture.Data = {00}
          ExplicitTop = 178
          ExplicitWidth = 427
          inherited FrameQid: TFrameTextInput
            Width = 339
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 427
            inherited Edit: TUniEdit
              Width = 168
              ExplicitWidth = 256
            end
            inherited PanelUnits: TUniPanel
              Left = 313
              ExplicitLeft = 401
            end
          end
          inherited FrameQueueEnable: TFrameBoolInput
            Width = 339
            ExplicitLeft = 0
            ExplicitTop = 30
            ExplicitWidth = 427
            inherited CheckBox: TUniCheckBox
              Width = 201
              ExplicitWidth = 289
            end
          end
        end
        inline FrameAType: TFrameCombobox
          Left = 0
          Top = 0
          Width = 339
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
            Width = 168
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
            Left = 313
            ExplicitLeft = 401
          end
        end
        inline FrameProtocolVer: TFrameCombobox
          Left = 0
          Top = 30
          Width = 339
          Height = 30
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          Constraints.MaxHeight = 30
          Constraints.MinHeight = 30
          TabOrder = 4
          Background.Picture.Data = {00}
          ExplicitTop = 30
          ExplicitWidth = 427
          inherited PanelText: TUniPanel
            Caption = #1055#1088#1086#1090#1086#1082#1086#1083
          end
          inherited ComboBox: TUniComboBox
            Width = 168
            Text = '1'
            Items.Strings = (
              '1'
              '2G')
            ItemIndex = 0
            ExplicitTop = 2
            ExplicitWidth = 256
            ExplicitHeight = 26
          end
          inherited PanelUnits: TUniPanel
            Left = 313
            ExplicitLeft = 401
          end
        end
        inline FrameConnKey: TFrameTextInput
          Left = 0
          Top = 148
          Width = 339
          Height = 30
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          Constraints.MaxHeight = 30
          Constraints.MinHeight = 30
          TabOrder = 5
          Background.Picture.Data = {00}
          ExplicitTop = 148
          ExplicitWidth = 427
          inherited PanelText: TUniPanel
            Caption = #1050#1083#1102#1095' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1103
          end
          inherited Edit: TUniEdit
            Width = 168
            ExplicitWidth = 256
          end
          inherited PanelUnits: TUniPanel
            Left = 313
            Caption = ''
            ExplicitLeft = 401
          end
        end
        object UniGroupBox1: TUniGroupBox
          Left = 0
          Top = 244
          Width = 339
          Height = 293
          Hint = ''
          Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '
          Align = alTop
          TabOrder = 6
          ExplicitWidth = 427
          inline FrameAckCount: TFrameTextInput
            Left = 2
            Top = 15
            Width = 335
            Height = 30
            Align = alTop
            Anchors = [akLeft, akTop, akRight]
            Constraints.MaxHeight = 30
            Constraints.MinHeight = 30
            TabOrder = 1
            Background.Picture.Data = {00}
            ExplicitLeft = 2
            ExplicitTop = 15
            ExplicitWidth = 423
            inherited PanelText: TUniPanel
              Caption = #1054#1082#1085#1086' '#1087#1086#1076#1090#1074'.'
            end
            inherited Edit: TUniEdit
              Width = 164
              InputType = 'number'
              ExplicitWidth = 252
            end
            inherited PanelUnits: TUniPanel
              Left = 309
              Caption = #1096#1090'.'
              ExplicitLeft = 397
            end
          end
          inline FrameAckTimeout: TFrameTextInput
            Left = 2
            Top = 45
            Width = 335
            Height = 30
            Align = alTop
            Anchors = [akLeft, akTop, akRight]
            Constraints.MaxHeight = 30
            Constraints.MinHeight = 30
            TabOrder = 2
            Background.Picture.Data = {00}
            ExplicitLeft = 2
            ExplicitTop = 45
            ExplicitWidth = 423
            inherited PanelText: TUniPanel
              Caption = #1058#1072#1081#1084#1072#1091#1090' '#1087#1086#1076#1090#1074'.'
            end
            inherited Edit: TUniEdit
              Width = 164
              InputType = 'number'
              ExplicitWidth = 252
            end
            inherited PanelUnits: TUniPanel
              Left = 309
              ExplicitLeft = 397
            end
          end
          inline FrameTriggerByte: TFrameTextInput
            Left = 2
            Top = 75
            Width = 335
            Height = 30
            Align = alTop
            Anchors = [akLeft, akTop, akRight]
            Constraints.MaxHeight = 30
            Constraints.MinHeight = 30
            TabOrder = 3
            Background.Picture.Data = {00}
            ExplicitLeft = 2
            ExplicitTop = 75
            ExplicitWidth = 423
            inherited PanelText: TUniPanel
              Caption = #1058#1088#1080#1075#1075#1077#1088', '#1073#1072#1081#1090
            end
            inherited Edit: TUniEdit
              Width = 164
              InputType = 'number'
              ExplicitWidth = 252
            end
            inherited PanelUnits: TUniPanel
              Left = 309
              Caption = #1073#1072#1081#1090
              ExplicitLeft = 397
            end
          end
          inline FrameTriggerCount: TFrameTextInput
            Left = 2
            Top = 105
            Width = 335
            Height = 30
            Align = alTop
            Anchors = [akLeft, akTop, akRight]
            Constraints.MaxHeight = 30
            Constraints.MinHeight = 30
            TabOrder = 4
            Background.Picture.Data = {00}
            ExplicitLeft = 2
            ExplicitTop = 105
            ExplicitWidth = 423
            inherited PanelText: TUniPanel
              Caption = #1058#1088#1080#1075#1075#1077#1088', '#1096#1090
            end
            inherited Edit: TUniEdit
              Width = 164
              Text = 'number'
              InputType = 'number'
              ExplicitWidth = 252
            end
            inherited PanelUnits: TUniPanel
              Left = 309
              Caption = #1096#1090
              ExplicitLeft = 397
            end
          end
          inline FrameTriggerSec: TFrameTextInput
            Left = 2
            Top = 135
            Width = 335
            Height = 30
            Align = alTop
            Anchors = [akLeft, akTop, akRight]
            Constraints.MaxHeight = 30
            Constraints.MinHeight = 30
            TabOrder = 7
            Background.Picture.Data = {00}
            ExplicitLeft = 2
            ExplicitTop = 135
            ExplicitWidth = 423
            inherited PanelText: TUniPanel
              Caption = #1058#1088#1080#1075#1075#1077#1088', '#1089#1077#1082
            end
            inherited Edit: TUniEdit
              Width = 164
              Text = 'number'
              InputType = 'number'
              ExplicitWidth = 252
            end
            inherited PanelUnits: TUniPanel
              Left = 309
              ExplicitLeft = 397
            end
          end
          inline FrameConfirm: TFrameCombobox
            Left = 2
            Top = 165
            Width = 335
            Height = 30
            Align = alTop
            Anchors = [akLeft, akTop, akRight]
            Constraints.MaxHeight = 30
            Constraints.MinHeight = 30
            TabOrder = 5
            Background.Picture.Data = {00}
            ExplicitLeft = 2
            ExplicitTop = 165
            ExplicitWidth = 423
            inherited PanelText: TUniPanel
              Caption = #1056#1077#1078#1080#1084' '#1087#1086#1076#1090#1074'.'
            end
            inherited ComboBox: TUniComboBox
              Width = 164
              Items.Strings = (
                #1089#1083#1072#1073#1099#1081
                #1086#1073#1099#1095#1085#1099#1081
                #1089#1080#1083#1100#1085#1099#1081)
              ExplicitTop = 2
              ExplicitWidth = 252
              ExplicitHeight = 26
            end
            inherited PanelUnits: TUniPanel
              Left = 309
              ExplicitLeft = 397
            end
          end
          inline FrameBufferSize: TFrameTextInput
            Left = 2
            Top = 195
            Width = 335
            Height = 30
            Align = alTop
            Anchors = [akLeft, akTop, akRight]
            Constraints.MaxHeight = 30
            Constraints.MinHeight = 30
            TabOrder = 6
            Background.Picture.Data = {00}
            ExplicitLeft = 2
            ExplicitTop = 195
            ExplicitWidth = 423
            inherited PanelText: TUniPanel
              Caption = #1041#1091#1092#1077#1088
            end
            inherited Edit: TUniEdit
              Width = 164
              Text = 'number'
              InputType = 'number'
              ExplicitWidth = 252
            end
            inherited PanelUnits: TUniPanel
              Left = 309
              Caption = #1073#1072#1081#1090
              ExplicitLeft = 397
            end
          end
          inline FrameCompatibility: TFrameCombobox
            Left = 2
            Top = 225
            Width = 335
            Height = 30
            Align = alTop
            Anchors = [akLeft, akTop, akRight]
            Constraints.MaxHeight = 30
            Constraints.MinHeight = 30
            TabOrder = 8
            Background.Picture.Data = {00}
            ExplicitLeft = 2
            ExplicitTop = 225
            ExplicitWidth = 423
            inherited PanelText: TUniPanel
              Caption = #1057#1086#1074#1084#1077#1089#1090#1080#1084#1086#1089#1090#1100
            end
            inherited ComboBox: TUniComboBox
              Width = 164
              Items.Strings = (
                'mitra'
                'unimas'
                'sriv')
              ExplicitTop = 2
              ExplicitWidth = 252
              ExplicitHeight = 26
            end
            inherited PanelUnits: TUniPanel
              Left = 309
              ExplicitLeft = 397
            end
          end
          inline FrameRR: TFrameBoolInput
            Left = 2
            Top = 255
            Width = 335
            Height = 30
            Align = alTop
            Anchors = [akLeft, akTop, akRight]
            Constraints.MaxHeight = 30
            Constraints.MinHeight = 30
            TabOrder = 9
            Background.Picture.Data = {00}
            ExplicitLeft = 2
            ExplicitTop = 255
            ExplicitWidth = 423
            inherited PanelText: TUniPanel
              Caption = 'RR '#1087#1072#1082#1077#1090#1099
            end
            inherited CheckBox: TUniCheckBox
              Width = 197
              ExplicitWidth = 285
            end
          end
        end
      end
    end
  end
  inherited ProfilesGroupBox: TUniGroupBox
    Left = 351
    Width = 332
    Height = 657
    ExplicitHeight = 693
  end
  inherited UniSplitter1: TUniSplitter
    Left = 345
    Height = 657
    ExplicitHeight = 693
  end
end
