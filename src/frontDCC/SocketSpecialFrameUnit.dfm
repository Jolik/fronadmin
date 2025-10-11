inherited SocketSpecialFrame: TSocketSpecialFrame
  Width = 581
  Height = 893
  ExplicitWidth = 581
  ExplicitHeight = 893
  inline FrameConnection1: TFrameConnection
    Left = 0
    Top = 0
    Width = 581
    Height = 129
    Margins.Left = 10
    Margins.Top = 20
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alTop
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Background.Picture.Data = {00}
    ExplicitWidth = 581
    ExplicitHeight = 129
    inherited UniGroupBox1: TUniGroupBox
      Left = 10
      Top = 20
      Width = 561
      Height = 99
      Margins.Left = 10
      Margins.Top = 20
      Margins.Right = 10
      Margins.Bottom = 10
      ExplicitLeft = 10
      ExplicitTop = 20
      ExplicitWidth = 561
      ExplicitHeight = 99
      inherited FrameAddr: TFrameTextInput
        Width = 557
        ExplicitWidth = 557
        inherited PanelTextInput: TUniPanel
          Width = 557
          ExplicitWidth = 557
          inherited Edit: TUniEdit
            Width = 433
            ExplicitWidth = 433
          end
        end
      end
      inherited FrameTimeout: TFrameIntegerInput
        Width = 557
        ExplicitWidth = 557
        inherited PanelIntegerInput: TUniPanel
          Width = 557
          ExplicitWidth = 557
          inherited Edit: TUniEdit
            Width = 433
            ExplicitWidth = 433
          end
        end
      end
      inherited UniGroupBox2: TUniGroupBox
        Width = 537
        Height = 0
        Visible = False
        ExplicitWidth = 537
        ExplicitHeight = 0
        inherited UniGroupBox3: TUniGroupBox
          Width = 513
          ExplicitWidth = 513
          inherited FrameEnableTLS: TFrameBoolInput
            Width = 509
            ExplicitWidth = 509
            inherited PanelBoolInput: TUniPanel
              Width = 509
              ExplicitWidth = 509
            end
          end
          inherited UniGroupBox5: TUniGroupBox
            Width = 489
            ExplicitWidth = 489
            inherited FrameCertCrt: TFrameTextInput
              Width = 485
              ExplicitWidth = 485
              inherited PanelTextInput: TUniPanel
                Width = 485
                ExplicitWidth = 485
                inherited Edit: TUniEdit
                  Width = 361
                  ExplicitWidth = 361
                end
              end
            end
            inherited FrameCertKey: TFrameTextInput
              Width = 485
              ExplicitWidth = 485
              inherited PanelTextInput: TUniPanel
                Width = 485
                ExplicitWidth = 485
                inherited Edit: TUniEdit
                  Width = 361
                  ExplicitWidth = 361
                end
              end
            end
            inherited FrameCertCA: TFrameTextInput
              Width = 485
              ExplicitWidth = 485
              inherited PanelTextInput: TUniPanel
                Width = 485
                ExplicitWidth = 485
                inherited Edit: TUniEdit
                  Width = 361
                  ExplicitWidth = 361
                end
              end
            end
          end
        end
        inherited UniGroupBox4: TUniGroupBox
          Width = 513
          ExplicitWidth = 513
          inherited FrameLogin: TFrameTextInput
            Width = 509
            ExplicitWidth = 509
            inherited PanelTextInput: TUniPanel
              Width = 509
              ExplicitWidth = 509
              inherited Edit: TUniEdit
                Width = 385
                ExplicitWidth = 385
              end
            end
          end
          inherited FramePass: TFrameTextInput
            Width = 509
            ExplicitWidth = 509
            inherited PanelTextInput: TUniPanel
              Width = 509
              ExplicitWidth = 509
              inherited Edit: TUniEdit
                Width = 385
                ExplicitWidth = 385
              end
            end
          end
        end
      end
    end
  end
  object UniGroupBox1: TUniGroupBox
    AlignWithMargins = True
    Left = 10
    Top = 149
    Width = 561
    Height = 580
    Hint = ''
    Margins.Left = 10
    Margins.Top = 20
    Margins.Right = 10
    Margins.Bottom = 10
    Caption = ' '#1055#1088#1086#1095#1080#1077' '
    Align = alTop
    TabOrder = 1
    inline FrameProtVer: TFrameCombobox
      Left = 2
      Top = 57
      Width = 557
      Height = 42
      Align = alTop
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      Background.Picture.Data = {00}
      ExplicitLeft = 2
      ExplicitTop = 57
      ExplicitWidth = 557
      inherited PanelIntegerInput: TUniPanel
        Width = 557
        ExplicitWidth = 557
        ExplicitHeight = 42
        inherited PanelText: TUniPanel
          Caption = #1055#1088#1086#1090#1086#1082#1086#1083
          ExplicitHeight = 42
        end
        inherited ComboBox: TUniComboBox
          Width = 433
          Items.Strings = (
            '1'
            '2G')
          OnChange = FrameCombobox1ComboBoxChange
          ExplicitLeft = 114
          ExplicitTop = 6
          ExplicitWidth = 433
          ExplicitHeight = 30
        end
      end
    end
    inline FrameKeyInput: TFrameTextInput
      Left = 2
      Top = 99
      Width = 557
      Height = 37
      Align = alTop
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      Background.Picture.Data = {00}
      ExplicitLeft = 2
      ExplicitTop = 99
      ExplicitWidth = 557
      inherited PanelTextInput: TUniPanel
        Width = 557
        ExplicitWidth = 557
        inherited Edit: TUniEdit
          Width = 433
          ExplicitWidth = 433
        end
        inherited PanelText: TUniPanel
          Caption = #1050#1083#1102#1095
        end
      end
    end
    inline FrameCliSrv: TFrameCombobox
      Left = 2
      Top = 15
      Width = 557
      Height = 42
      Align = alTop
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
      Background.Picture.Data = {00}
      ExplicitLeft = 2
      ExplicitTop = 15
      ExplicitWidth = 557
      inherited PanelIntegerInput: TUniPanel
        Width = 557
        ExplicitWidth = 557
        ExplicitHeight = 42
        inherited PanelText: TUniPanel
          Caption = ' '#1058#1080#1087' '
          ExplicitHeight = 42
        end
        inherited ComboBox: TUniComboBox
          Width = 433
          Items.Strings = (
            #1082#1083#1080#1077#1085#1090
            #1089#1077#1088#1074#1077#1088)
          ExplicitLeft = 114
          ExplicitTop = 6
          ExplicitWidth = 433
          ExplicitHeight = 30
        end
      end
    end
    object UniGroupBox2: TUniGroupBox
      AlignWithMargins = True
      Left = 12
      Top = 156
      Width = 537
      Height = 405
      Hint = ''
      Margins.Left = 10
      Margins.Top = 20
      Margins.Right = 10
      Margins.Bottom = 10
      Caption = ' '#1056#1072#1089#1096#1080#1088#1077#1085#1085#1099#1077' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '
      Align = alTop
      TabOrder = 4
      inline FrameaAckCount: TFrameIntegerInput
        Left = 2
        Top = 15
        Width = 533
        Height = 37
        Align = alTop
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
        Background.Picture.Data = {00}
        ExplicitLeft = 2
        ExplicitTop = 15
        ExplicitWidth = 533
        inherited PanelIntegerInput: TUniPanel
          Width = 533
          ExplicitWidth = 533
          inherited Edit: TUniEdit
            Left = 114
            Top = 3
            Width = 409
            Height = 31
            ExplicitLeft = 114
            ExplicitTop = 3
            ExplicitWidth = 409
            ExplicitHeight = 31
          end
          inherited PanelText: TUniPanel
            Left = 0
            Top = 0
            Height = 37
            Hint = 
              'ack_count '#1089#1082#1086#1083#1100#1082#1086' '#1084#1072#1082#1089#1080#1084#1091#1084' '#1089#1086#1086#1073#1097#1077#1085#1080#1081' '#1087#1077#1088#1077#1076#1072#1074#1072#1090#1100' '#1073#1077#1079' '#1087#1086#1083#1091#1095#1077#1085#1080#1103' '#1087#1086 +
              #1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1103'. default=30'
            ShowHint = True
            ParentShowHint = False
            Caption = #1054#1082#1085#1086' '#1087#1086#1076#1090#1074'.'
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitHeight = 37
          end
        end
      end
      inline FrameAckTimeout: TFrameIntegerInput
        Left = 2
        Top = 52
        Width = 533
        Height = 37
        Align = alTop
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 2
        Background.Picture.Data = {00}
        ExplicitLeft = 2
        ExplicitTop = 52
        ExplicitWidth = 533
        inherited PanelIntegerInput: TUniPanel
          Width = 533
          ExplicitWidth = 533
          inherited Edit: TUniEdit
            Left = 114
            Top = 3
            Width = 409
            Height = 31
            ExplicitLeft = 114
            ExplicitTop = 3
            ExplicitWidth = 409
            ExplicitHeight = 31
          end
          inherited PanelText: TUniPanel
            Left = 0
            Top = 0
            Height = 37
            Hint = 
              'ack_timeout '#1090#1072#1081#1084#1072#1091#1090' '#1087#1086#1083#1091#1095#1077#1085#1080#1103' '#1087#1086#1076#1074#1077#1088#1078#1076#1072#1102#1097#1077#1075#1086' '#1087#1072#1082#1077#1090#1072', '#1089#1077#1082'. defaul' +
              't=30'
            ShowHint = True
            ParentShowHint = False
            Caption = #1058#1072#1081#1084#1072#1091#1090' '#1087#1086#1076#1090#1074'.'
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitHeight = 37
          end
        end
      end
      object UniPanel1: TUniPanel
        Left = 2
        Top = 358
        Width = 533
        Height = 37
        Hint = ''
        Align = alTop
        TabOrder = 3
        BorderStyle = ubsNone
        ShowCaption = False
        Caption = 'UniPanel1'
        object UniBitBtn1: TUniBitBtn
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 91
          Height = 31
          Hint = #1091#1090#1089#1072#1085#1086#1074#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1103' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
          Margins.Right = 10
          ShowHint = True
          ParentShowHint = False
          Caption = #1089#1073#1088#1086#1089
          Align = alLeft
          TabOrder = 1
          OnClick = UniBitBtn1Click
        end
      end
      inline FrameTriggerSize: TFrameIntegerInput
        Left = 2
        Top = 89
        Width = 533
        Height = 37
        Align = alTop
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 4
        Background.Picture.Data = {00}
        ExplicitLeft = 2
        ExplicitTop = 89
        ExplicitWidth = 533
        inherited PanelIntegerInput: TUniPanel
          Width = 533
          ExplicitWidth = 533
          inherited Edit: TUniEdit
            Left = 114
            Top = 3
            Width = 409
            Height = 31
            ExplicitLeft = 114
            ExplicitTop = 3
            ExplicitWidth = 409
            ExplicitHeight = 31
          end
          inherited PanelText: TUniPanel
            Left = 0
            Top = 0
            Height = 37
            Hint = 
              'input_trigger_size '#1074#1099#1079#1099#1074#1072#1090#1100' '#1086#1090#1087#1088#1072#1074#1082#1091' '#1089#1086#1086#1073#1097#1077#1085#1080#1081' '#1080#1079' '#1074#1093#1086#1076#1103#1097#1077#1075#1086' '#1073#1091#1092#1077 +
              #1088#1072' '#1074' '#1103#1076#1088#1086' '#1077#1089#1083#1080' '#1074#1086' '#1074#1093#1086#1076#1103#1097#1077#1084' '#1073#1091#1092#1077#1088#1077' '#1085#1072#1073#1088#1072#1083#1086#1089#1100' '#1089#1090#1086#1083#1100#1082#1086' '#1073#1072#1081#1090'. defaul' +
              't=1000'
            ShowHint = True
            ParentShowHint = False
            Caption = #1058#1088#1080#1075#1075#1077#1088', '#1073#1072#1081#1090
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitHeight = 37
          end
        end
      end
      inline FrameTriggerTime: TFrameIntegerInput
        Left = 2
        Top = 126
        Width = 533
        Height = 37
        Align = alTop
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 5
        Background.Picture.Data = {00}
        ExplicitLeft = 2
        ExplicitTop = 126
        ExplicitWidth = 533
        inherited PanelIntegerInput: TUniPanel
          Width = 533
          ExplicitWidth = 533
          inherited Edit: TUniEdit
            Left = 114
            Top = 3
            Width = 409
            Height = 31
            ExplicitLeft = 114
            ExplicitTop = 3
            ExplicitWidth = 409
            ExplicitHeight = 31
          end
          inherited PanelText: TUniPanel
            Left = 0
            Top = 0
            Height = 37
            Hint = 
              'input_trigger_time '#1074#1099#1079#1099#1074#1072#1090#1100' '#1086#1090#1087#1088#1072#1074#1082#1091' '#1089#1086#1086#1073#1097#1077#1085#1080#1081' '#1080#1079' '#1074#1093#1086#1076#1103#1097#1077#1075#1086' '#1073#1091#1092#1077 +
              #1088#1072' '#1074' '#1103#1076#1088#1086' '#1077#1089#1083#1080' '#1074#1086' '#1074#1093#1086#1076#1103#1097#1077#1084' '#1073#1091#1092#1077#1088#1077' '#1089#1086#1086#1073#1097#1077#1085#1080#1103' '#1093#1088#1072#1085#1103#1090#1089#1103' '#1073#1086#1083#1100#1096#1077' '#1095#1077#1084' ' +
              #1101#1090#1086' '#1082#1086#1083'-'#1074#1086' '#1089#1077#1082'. default=2 '
            ShowHint = True
            ParentShowHint = False
            Caption = #1058#1088#1080#1075#1075#1077#1088', '#1089#1077#1082
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitHeight = 37
          end
        end
      end
      inline FrameBufferSize: TFrameIntegerInput
        Left = 2
        Top = 242
        Width = 533
        Height = 37
        Align = alTop
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 6
        Background.Picture.Data = {00}
        ExplicitLeft = 2
        ExplicitTop = 242
        ExplicitWidth = 533
        inherited PanelIntegerInput: TUniPanel
          Width = 533
          ExplicitWidth = 533
          inherited Edit: TUniEdit
            Left = 114
            Top = 3
            Width = 409
            Height = 31
            ExplicitLeft = 114
            ExplicitTop = 3
            ExplicitWidth = 409
            ExplicitHeight = 31
          end
          inherited PanelText: TUniPanel
            Left = 0
            Top = 0
            Height = 37
            Hint = 
              'max_input_buf_size '#1084#1072#1082#1089#1080#1084#1072#1083#1100#1085#1099#1081' '#1088#1072#1079#1084#1077#1088' '#1074#1093#1086#1076#1103#1097#1077#1075#1086' '#1073#1091#1092#1077#1088#1072'. '#1090#1086#1083#1100#1082#1086' ' +
              #1076#1083#1103' '#1088#1077#1078#1080#1084#1072' ConfirmationMode=normal '#1077#1089#1083#1080' '#1074#1086' '#1074#1093#1086#1076#1103#1097#1077#1084' '#1073#1091#1092#1077#1088#1077' '#1087#1088#1077#1074#1099 +
              #1077#1096#1085#1086' '#1101#1090#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1073#1072#1081#1090' - '#1074#1093#1086#1076#1103#1096#1080#1077' '#1089#1086#1086#1073#1097#1077#1085#1080#1103' '#1086#1090#1073#1088#1072#1089#1099#1074#1072#1102#1090#1089#1103'. defau' +
              'lt=1000000'
            ShowHint = True
            ParentShowHint = False
            Caption = #1041#1091#1092#1077#1088', '#1073#1072#1081#1090
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitHeight = 37
          end
        end
      end
      inline FrameConfirmMode: TFrameCombobox
        Left = 2
        Top = 200
        Width = 533
        Height = 42
        Align = alTop
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 7
        Background.Picture.Data = {00}
        ExplicitLeft = 2
        ExplicitTop = 200
        ExplicitWidth = 533
        inherited PanelIntegerInput: TUniPanel
          Width = 533
          ExplicitWidth = 533
          ExplicitHeight = 42
          inherited PanelText: TUniPanel
            Hint = 
              'confirmation_mode '#1087#1088#1072#1074#1080#1083#1086' '#1087#1086' '#1082#1086#1090#1086#1088#1086#1084#1091' '#1088#1072#1073#1086#1090#1072#1077#1090' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' '#1087#1086#1083 +
              #1091#1095#1077#1085#1080#1103' '#1089#1086#1086#1073#1097#1077#1085#1080#1081':'#13#10'* strong - '#1089#1072#1084#1099#1081' '#1085#1072#1076#1105#1078#1085#1099#1081', '#1089#1072#1084#1099#1081' '#1084#1077#1076#1083#1077#1085#1085#1099#1081'. '#1074 +
              #1093#1086#1076#1103#1097#1077#1077' '#1089#1086#1086#1073#1097#1077#1085#1080#1077' '#1087#1086#1089#1090#1091#1087#1072#1077#1090' '#1074#1086' '#1074#1093#1086#1076#1103#1097#1080#1081' '#1073#1091#1092#1077#1088', '#1095#1077#1088#1077#1079' '#1082#1072#1082#1086#1077'-'#1090#1086' '#1074#1088 +
              #1077#1084#1103'(InputTriggerTime) '#1086#1090#1087#1088#1072#1074#1083#1103#1077#1090#1089#1103' '#1074' '#1103#1076#1088#1086', '#1103#1076#1088#1086' '#1074#1086#1079#1074#1088#1072#1097#1072#1077#1090' '#1087#1086#1083#1086#1078 +
              #1080#1090#1077#1083#1100#1085#1099#1081' '#1086#1090#1074#1077#1090', '#1087#1086#1089#1083#1077' '#1095#1077#1075#1086#13#10#1076#1088#1091#1075#1086#1081' '#1089#1090#1086#1088#1086#1085#1077' '#1086#1090#1089#1099#1083#1072#1077#1090#1089#1103' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077 +
              #1085#1080#1077' '#1087#1086#1083#1091#1095#1077#1085#1080#1103'.'#13#10'* normal -  '#1074#1093#1086#1076#1103#1097#1077#1077' '#1089#1086#1086#1073#1097#1077#1085#1080#1077' '#1087#1086#1084#1077#1097#1072#1077#1090#1089#1103' '#1074#1086' '#1074#1093#1086 +
              #1076#1103#1097#1080#1081' '#1073#1091#1092#1077#1088' '#1077#1089#1083#1080' '#1074' '#1085#1105#1084' '#1077#1089#1090#1100' '#1084#1077#1089#1090#1086'(MaxInputBufSize) '#1080#13#10#1086#1090#1087#1088#1072#1074#1083#1103#1077#1090 +
              #1089#1103' '#1087#1086#1076#1074#1077#1088#1078#1076#1077#1085#1080#1077'. '#1080#1085#1072#1095#1077' '#1086#1090#1073#1088#1072#1089#1099#1074#1072#1077#1090#1089#1103'.'#13#10'* light  - '#1087#1086#1076#1074#1077#1088#1078#1076#1077#1085#1080#1077' '#1087 +
              #1086#1083#1091#1095#1077#1085#1080#1103' '#1089#1086#1086#1073#1097#1077#1085#1080#1103' '#1086#1090#1087#1088#1072#1074#1083#1103#1077#1090#1089#1103' '#1089#1088#1072#1079#1091' '#1087#1088#1080' '#1087#1086#1083#1091#1095#1077#1085#1080#1080'  '#13#10'default =' +
              ' normal  '
            ShowHint = True
            ParentShowHint = False
            Caption = #1056#1077#1078#1080#1084' '#1087#1086#1076#1090#1074'.'
            ExplicitHeight = 42
          end
          inherited ComboBox: TUniComboBox
            Width = 409
            Items.Strings = (
              #1089#1083#1072#1073#1099#1081
              #1086#1073#1099#1095#1085#1099#1081
              #1089#1080#1083#1100#1085#1099#1081)
            ExplicitLeft = 114
            ExplicitTop = 6
            ExplicitWidth = 409
            ExplicitHeight = 30
          end
        end
      end
      inline FrameTriggerCount: TFrameIntegerInput
        Left = 2
        Top = 163
        Width = 533
        Height = 37
        Align = alTop
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 8
        Background.Picture.Data = {00}
        ExplicitLeft = 2
        ExplicitTop = 163
        ExplicitWidth = 533
        inherited PanelIntegerInput: TUniPanel
          Width = 533
          ExplicitWidth = 533
          inherited Edit: TUniEdit
            Left = 114
            Top = 3
            Width = 409
            Height = 31
            ExplicitLeft = 114
            ExplicitTop = 3
            ExplicitWidth = 409
            ExplicitHeight = 31
          end
          inherited PanelText: TUniPanel
            Left = 0
            Top = 0
            Height = 37
            Hint = 
              'input_trigger_count '#1074#1099#1079#1099#1074#1072#1090#1100' '#1086#1090#1087#1088#1072#1074#1082#1091' '#1089#1086#1086#1073#1097#1077#1085#1080#1081' '#1080#1079' '#1074#1093#1086#1076#1103#1097#1077#1075#1086' '#1073#1091#1092 +
              #1077#1088#1072' '#1074' '#1103#1076#1088#1086' '#1077#1089#1083#1080' '#1074#1086' '#1074#1093#1086#1076#1103#1097#1077#1084' '#1073#1091#1092#1077#1088#1077' '#1085#1072#1073#1088#1072#1083#1086#1089#1100' '#1089#1090#1086#1083#1100#1082#1086' '#1089#1086#1086#1073#1097#1077#1085#1080#1081'. ' +
              'default=30'
            ShowHint = True
            ParentShowHint = False
            Caption = #1058#1088#1080#1075#1075#1077#1088', '#1096#1090
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitHeight = 37
          end
        end
      end
      inline FrameCompability: TFrameCombobox
        Left = 2
        Top = 279
        Width = 533
        Height = 42
        Align = alTop
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 9
        Background.Picture.Data = {00}
        ExplicitLeft = 2
        ExplicitTop = 279
        ExplicitWidth = 533
        inherited PanelIntegerInput: TUniPanel
          Width = 533
          ExplicitWidth = 533
          ExplicitHeight = 42
          inherited PanelText: TUniPanel
            Hint = 
              'compatibility  '#1089#1086#1074#1084#1077#1089#1090#1080#1084#1086#1089#1090#1100' '#1089' '#1091#1076#1072#1083#1105#1085#1085#1086#1081' '#1089#1090#1086#1088#1086#1085#1086#1081'. '#1074#1089#1077' '#1088#1077#1072#1083#1080#1079#1086#1074#1072 +
              #1083#1080' '#1087#1088#1086#1090#1086#1082#1086#1083' ss2g '#1087#1086'-'#1088#1072#1079#1085#1086#1084#1091'. '#1074#1099#1073#1088#1072#1090#1100' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077' '#1089' '#1082#1086#1090#1086#1088#1099#1084' '#1091#1089#1090#1072#1085#1072 +
              #1074#1083#1080#1074#1072#1077#1090#1089#1103' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1077
            ShowHint = True
            ParentShowHint = False
            Caption = #1057#1086#1074#1084#1077#1089#1090#1080#1084#1086#1089#1090#1100
            ExplicitHeight = 42
          end
          inherited ComboBox: TUniComboBox
            Width = 409
            Items.Strings = (
              'mitra'
              'unimas'
              'sriv ')
            ExplicitLeft = 114
            ExplicitTop = 6
            ExplicitWidth = 409
            ExplicitHeight = 30
          end
        end
      end
      inline FrameKeepAlive: TFrameBoolInput
        Left = 2
        Top = 321
        Width = 533
        Height = 37
        Align = alTop
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 10
        Background.Picture.Data = {00}
        ExplicitLeft = 2
        ExplicitTop = 321
        ExplicitWidth = 533
        inherited PanelBoolInput: TUniPanel
          Width = 533
          ExplicitWidth = 533
          inherited PanelText: TUniPanel
            Left = 0
            Top = 0
            Height = 37
            Hint = 
              'keep_alive  '#1074#1082#1083#1102#1095#1080#1090#1100' '#1087#1077#1088#1080#1086#1076#1080#1095#1077#1089#1082#1091#1102' '#1086#1090#1087#1088#1072#1074#1082#1091' '#1087#1072#1082#1077#1090#1086#1074' RR. '#1087#1088#1080' '#1086#1090#1082#1083 +
              #1102#1095#1077#1085#1080#1080' '#1082#1072#1085#1072#1083' '#1084#1086#1078#1077#1090' '#1087#1086#1074#1080#1089#1072#1090#1100' '#1073#1077#1089#1082#1086#1085#1077#1095#1085#1086' '#1083#1080#1073#1086' '#1087#1077#1088#1080#1086#1076#1080#1095#1077#1089#1082#1080' '#1088#1072#1079#1088#1099#1074#1072 +
              #1090#1100' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1077'. '#1074#1099#1082#1083#1102#1095#1072#1090#1100' '#1085#1077' '#1088#1077#1082#1086#1084#1077#1085#1076#1091#1077#1090#1089#1103
            ShowHint = True
            ParentShowHint = False
            Caption = 'RR '#1087#1072#1082#1077#1090#1099
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitHeight = 37
          end
        end
      end
    end
  end
end
