inherited FTPSRVDownFrame: TFTPSRVDownFrame
  Width = 551
  Height = 448
  ExplicitWidth = 551
  ExplicitHeight = 448
  inline FrameConnection1: TFrameConnection
    Left = 0
    Top = 0
    Width = 551
    Height = 129
    Margins.Left = 10
    Margins.Top = 20
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alTop
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Background.Picture.Data = {00}
    ExplicitWidth = 551
    ExplicitHeight = 129
    inherited UniGroupBox1: TUniGroupBox
      Left = 10
      Top = 20
      Width = 531
      Height = 99
      Margins.Left = 10
      Margins.Top = 20
      Margins.Right = 10
      Margins.Bottom = 10
      ExplicitWidth = 549
      ExplicitHeight = 95
      inherited FrameAddr: TFrameTextInput
        Width = 527
        ExplicitWidth = 545
        inherited PanelTextInput: TUniPanel
          Width = 527
          ExplicitWidth = 545
          inherited Edit: TUniEdit
            Width = 403
            ExplicitWidth = 421
          end
          inherited PanelText: TUniPanel
            ExplicitLeft = -3
            ExplicitTop = -3
          end
        end
      end
      inherited FrameTimeout: TFrameIntegerInput
        Width = 527
        ExplicitWidth = 545
        inherited PanelIntegerInput: TUniPanel
          Width = 527
          ExplicitWidth = 545
          inherited Edit: TUniEdit
            Width = 403
            ExplicitWidth = 421
          end
        end
      end
      inherited UniGroupBox2: TUniGroupBox
        Width = 507
        Height = 0
        Visible = False
        ExplicitWidth = 525
        ExplicitHeight = 0
        inherited UniGroupBox3: TUniGroupBox
          Width = 483
          Height = 214
          ExplicitWidth = 501
          ExplicitHeight = 214
          inherited FrameEnableTLS: TFrameBoolInput
            Width = 479
            ExplicitWidth = 497
            inherited PanelBoolInput: TUniPanel
              Width = 479
              ExplicitWidth = 497
            end
          end
          inherited UniGroupBox5: TUniGroupBox
            Width = 459
            Height = 130
            ExplicitWidth = 477
            ExplicitHeight = 130
            inherited FrameCertCrt: TFrameTextInput
              Width = 455
              ExplicitWidth = 473
              inherited PanelTextInput: TUniPanel
                Width = 455
                ExplicitWidth = 473
                inherited Edit: TUniEdit
                  Width = 331
                  ExplicitWidth = 349
                end
              end
            end
            inherited FrameCertKey: TFrameTextInput
              Width = 455
              ExplicitWidth = 473
              inherited PanelTextInput: TUniPanel
                Width = 455
                ExplicitWidth = 473
                inherited Edit: TUniEdit
                  Width = 331
                  ExplicitWidth = 349
                end
              end
            end
            inherited FrameCertCA: TFrameTextInput
              Width = 455
              ExplicitWidth = 473
              inherited PanelTextInput: TUniPanel
                Width = 455
                ExplicitWidth = 473
                inherited Edit: TUniEdit
                  Width = 331
                  ExplicitWidth = 349
                end
              end
            end
          end
        end
        inherited UniGroupBox4: TUniGroupBox
          Width = 483
          ExplicitWidth = 501
          inherited FrameLogin: TFrameTextInput
            Width = 479
            ExplicitWidth = 497
            inherited PanelTextInput: TUniPanel
              Width = 479
              ExplicitWidth = 497
              inherited Edit: TUniEdit
                Width = 355
                ExplicitWidth = 373
              end
            end
          end
          inherited FramePass: TFrameTextInput
            Width = 479
            ExplicitWidth = 497
            inherited PanelTextInput: TUniPanel
              Width = 479
              ExplicitWidth = 497
              inherited Edit: TUniEdit
                Width = 355
                ExplicitWidth = 373
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
    Width = 531
    Height = 96
    Hint = ''
    Margins.Left = 10
    Margins.Top = 20
    Margins.Right = 10
    Margins.Bottom = 10
    Caption = ' '#1055#1088#1086#1095#1077#1077' '
    Align = alTop
    TabOrder = 1
    ExplicitLeft = 0
    ExplicitTop = 97
    ExplicitWidth = 551
    inline FrameDataPorts: TFrameTextInput
      Left = 2
      Top = 15
      Width = 527
      Height = 37
      Align = alTop
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      Background.Picture.Data = {00}
      ExplicitLeft = 2
      ExplicitTop = 15
      ExplicitWidth = 547
      inherited PanelTextInput: TUniPanel
        Width = 527
        ExplicitWidth = 547
        inherited Edit: TUniEdit
          Width = 403
          ExplicitWidth = 423
        end
        inherited PanelText: TUniPanel
          Hint = 
            #1076#1080#1072#1087#1072#1079#1086#1085' tcp '#1087#1086#1088#1090#1086#1074' '#1076#1083#1103' '#1082#1072#1085#1072#1083#1086#1074' '#1087#1077#1088#1077#1076#1072#1095#1080' '#1076#1072#1085#1085#1099#1093'. '#1087#1088#1080#1084#1077#1088': "2000-3' +
            '000"'
          ShowHint = True
          ParentShowHint = False
          Caption = #1055#1086#1088#1090#1099' '#1076#1072#1085#1085#1099#1093
        end
      end
    end
    inline FrameExternalIP: TFrameTextInput
      Left = 2
      Top = 52
      Width = 527
      Height = 37
      Align = alTop
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      Background.Picture.Data = {00}
      ExplicitLeft = 2
      ExplicitTop = 52
      ExplicitWidth = 547
      inherited PanelTextInput: TUniPanel
        Width = 527
        ExplicitWidth = 547
        inherited Edit: TUniEdit
          Width = 403
          ExplicitWidth = 423
        end
        inherited PanelText: TUniPanel
          Hint = 
            ' '#1074#1085#1077#1096#1085#1080#1081' IP '#1072#1076#1088#1077#1089' '#1089#1077#1088#1074#1077#1088#1072'. '#1090#1088#1077#1073#1091#1077#1090#1089#1103' '#1077#1089#1083#1080' '#1089#1077#1088#1074#1077#1088' '#1086#1090#1082#1088#1099#1090' '#1074' '#1083#1086#1082#1072#1083#1100 +
            #1085#1086#1081' '#1089#1077#1090#1080' '#1080' '#1087#1088#1086#1082#1080#1085#1091#1090' '#1087#1086#1088#1090' '#1085#1072#1088#1091#1078#1091'.'#1089#1077#1088#1074#1077#1088' '#1073#1091#1076#1077#1090' '#1087#1077#1088#1077#1076#1072#1074#1072#1090#1100' '#1082#1083#1080#1077#1085#1090#1091' ' +
            #1101#1090#1086#1090' ip '#1072#1076#1088#1077#1089' '#1074#1084#1077#1089#1090#1086' '#1074#1085#1091#1090#1088#1080#1089#1077#1090#1077#1074#1086#1075#1086'.'#1085#1077#1082#1086#1090#1086#1088#1099#1077' '#1082#1083#1080#1077#1085#1090#1099' ('#1085#1072#1087#1088#1080#1084#1077#1088' ' +
            'filezilla) '#1101#1090#1086#1075#1086' '#1085#1077' '#1090#1088#1077#1073#1091#1102#1090', '#1089#1072#1084#1080' '#1091#1084#1077#1102#1090' '#1087#1086#1076#1084#1077#1085#1103#1090#1100' '#1072#1076#1088#1077#1089' '#1085#1072' '#1074#1085#1077#1096#1085 +
            #1080#1081'.'
          ShowHint = True
          ParentShowHint = False
          Caption = #1042#1085#1077#1096#1085#1080#1081' IP'
        end
      end
    end
  end
end
