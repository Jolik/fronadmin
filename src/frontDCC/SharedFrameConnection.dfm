inherited FrameConnection: TFrameConnection
  Width = 406
  Height = 519
  Margins.Left = 10
  Margins.Top = 20
  Margins.Right = 10
  Margins.Bottom = 10
  ExplicitWidth = 406
  ExplicitHeight = 519
  object UniGroupBox1: TUniGroupBox
    AlignWithMargins = True
    Left = 1
    Top = 1
    Width = 404
    Height = 517
    Hint = ''
    Margins.Left = 1
    Margins.Top = 1
    Margins.Right = 1
    Margins.Bottom = 1
    Caption = '  '#1057#1086#1077#1076#1080#1085#1077#1085#1080#1077' '
    Align = alClient
    TabOrder = 0
    inline FrameAddr: TFrameTextInput
      Left = 2
      Top = 15
      Width = 400
      Height = 37
      Align = alTop
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      Background.Picture.Data = {00}
      ExplicitLeft = 2
      ExplicitTop = 15
      ExplicitWidth = 400
      inherited PanelTextInput: TUniPanel
        Width = 400
        ExplicitWidth = 400
        inherited Edit: TUniEdit
          Left = 114
          Top = 3
          Width = 276
          Height = 31
          ExplicitLeft = 114
          ExplicitTop = 3
          ExplicitWidth = 276
          ExplicitHeight = 31
        end
        inherited PanelText: TUniPanel
          Left = 0
          Top = 0
          Height = 37
          Hint = 
            #1072#1076#1088#1077#1089' '#1080' '#1087#1086#1088#1090'. '#1076#1083#1103' '#1082#1083#1080#1077#1085#1090#1072' '#1092#1086#1088#1084#1072#1090' "127.0.0.1:3000". '#1076#1083#1103' '#1089#1077#1088#1074#1077#1088#1072' '#1084 +
            #1086#1078#1085#1086' '#1090#1086#1083#1100#1082#1086' '#1087#1086#1088#1090': ":3000"'
          ShowHint = True
          ParentShowHint = False
          Caption = #1040#1076#1088#1077#1089
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitHeight = 37
        end
      end
    end
    inline FrameTimeout: TFrameIntegerInput
      Left = 2
      Top = 52
      Width = 400
      Height = 37
      Align = alTop
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      Background.Picture.Data = {00}
      ExplicitLeft = 2
      ExplicitTop = 52
      ExplicitWidth = 400
      inherited PanelIntegerInput: TUniPanel
        Width = 400
        ExplicitWidth = 400
        inherited Edit: TUniEdit
          Left = 114
          Top = 3
          Width = 276
          Height = 31
          ExplicitLeft = 114
          ExplicitTop = 3
          ExplicitWidth = 276
          ExplicitHeight = 31
        end
        inherited PanelText: TUniPanel
          Left = 0
          Top = 0
          Height = 37
          Hint = #1090#1072#1081#1084#1072#1091#1090' tcp '#1079#1072#1087#1080#1089#1080'/'#1087#1086#1083#1091#1095#1077#1085#1080#1103' '#1086#1090#1074#1077#1090#1072' '#1086#1090' '#1089#1077#1088#1074#1077#1088#1072', '#1089#1077#1082'. def = 10'
          ShowHint = True
          ParentShowHint = False
          Caption = #1058#1072#1081#1084#1072#1091#1090', '#1089#1077#1082
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitHeight = 37
        end
      end
    end
    object UniGroupBox2: TUniGroupBox
      AlignWithMargins = True
      Left = 12
      Top = 109
      Width = 380
      Height = 396
      Hint = ''
      Margins.Left = 10
      Margins.Top = 20
      Margins.Right = 10
      Margins.Bottom = 10
      Caption = ' '#1041#1077#1079#1086#1087#1072#1089#1085#1086#1089#1090#1100' '
      Align = alClient
      TabOrder = 3
      object UniGroupBox3: TUniGroupBox
        AlignWithMargins = True
        Left = 12
        Top = 151
        Width = 356
        Height = 233
        Hint = ''
        Margins.Left = 10
        Margins.Top = 20
        Margins.Right = 10
        Margins.Bottom = 10
        Caption = ' TLS '
        Align = alTop
        TabOrder = 1
        inline FrameEnableTLS: TFrameBoolInput
          Left = 2
          Top = 15
          Width = 352
          Height = 37
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          Background.Picture.Data = {00}
          ExplicitLeft = 2
          ExplicitTop = 15
          ExplicitWidth = 352
          inherited PanelBoolInput: TUniPanel
            Width = 352
            ExplicitWidth = 352
            inherited PanelText: TUniPanel
              Left = 0
              Top = 0
              Height = 37
              Caption = #1042#1082#1083#1102#1095#1080#1090#1100
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitHeight = 37
            end
            inherited CheckBox: TUniCheckBox
              Width = 243
              ExplicitWidth = 243
            end
          end
        end
        object UniGroupBox5: TUniGroupBox
          AlignWithMargins = True
          Left = 12
          Top = 72
          Width = 332
          Height = 145
          Hint = ''
          Margins.Left = 10
          Margins.Top = 20
          Margins.Right = 10
          Margins.Bottom = 10
          Caption = ' '#1057#1077#1088#1090#1080#1092#1080#1082#1072#1090#1099' '
          Align = alTop
          TabOrder = 2
          inline FrameCertCrt: TFrameTextInput
            Left = 2
            Top = 15
            Width = 328
            Height = 37
            Align = alTop
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 1
            Background.Picture.Data = {00}
            ExplicitLeft = 2
            ExplicitTop = 15
            ExplicitWidth = 328
            inherited PanelTextInput: TUniPanel
              Width = 328
              ExplicitWidth = 328
              inherited Edit: TUniEdit
                Left = 114
                Top = 3
                Width = 204
                Height = 31
                ExplicitLeft = 114
                ExplicitTop = 3
                ExplicitWidth = 204
                ExplicitHeight = 31
              end
              inherited PanelText: TUniPanel
                Left = 0
                Top = 0
                Height = 37
                Caption = 'crt'
                ExplicitLeft = 0
                ExplicitTop = 0
                ExplicitHeight = 37
              end
            end
          end
          inline FrameCertKey: TFrameTextInput
            Left = 2
            Top = 52
            Width = 328
            Height = 37
            Align = alTop
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 2
            Background.Picture.Data = {00}
            ExplicitLeft = 2
            ExplicitTop = 52
            ExplicitWidth = 328
            inherited PanelTextInput: TUniPanel
              Width = 328
              ExplicitWidth = 328
              inherited Edit: TUniEdit
                Left = 114
                Top = 3
                Width = 204
                Height = 31
                ExplicitLeft = 114
                ExplicitTop = 3
                ExplicitWidth = 204
                ExplicitHeight = 31
              end
              inherited PanelText: TUniPanel
                Left = 0
                Top = 0
                Height = 37
                Caption = 'key'
                ExplicitLeft = 0
                ExplicitTop = 0
                ExplicitHeight = 37
              end
            end
          end
          inline FrameCertCA: TFrameTextInput
            Left = 2
            Top = 89
            Width = 328
            Height = 37
            Align = alTop
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 3
            Background.Picture.Data = {00}
            ExplicitLeft = 2
            ExplicitTop = 89
            ExplicitWidth = 328
            inherited PanelTextInput: TUniPanel
              Width = 328
              ExplicitWidth = 328
              inherited Edit: TUniEdit
                Left = 114
                Top = 3
                Width = 204
                Height = 31
                ExplicitLeft = 114
                ExplicitTop = 3
                ExplicitWidth = 204
                ExplicitHeight = 31
              end
              inherited PanelText: TUniPanel
                Left = 0
                Top = 0
                Height = 37
                Caption = 'ca'
                ExplicitLeft = 0
                ExplicitTop = 0
                ExplicitHeight = 37
              end
            end
          end
        end
      end
      object UniGroupBox4: TUniGroupBox
        AlignWithMargins = True
        Left = 12
        Top = 25
        Width = 356
        Height = 96
        Hint = ''
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Caption = ' '#1040#1074#1090#1086#1088#1080#1079#1072#1094#1080#1103' '
        Align = alTop
        TabOrder = 2
        inline FrameLogin: TFrameTextInput
          Left = 2
          Top = 15
          Width = 352
          Height = 37
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          Background.Picture.Data = {00}
          ExplicitLeft = 2
          ExplicitTop = 15
          ExplicitWidth = 352
          inherited PanelTextInput: TUniPanel
            Width = 352
            ExplicitWidth = 352
            inherited Edit: TUniEdit
              Left = 114
              Top = 3
              Width = 228
              Height = 31
              ExplicitLeft = 114
              ExplicitTop = 3
              ExplicitWidth = 228
              ExplicitHeight = 31
            end
            inherited PanelText: TUniPanel
              Left = 0
              Top = 0
              Height = 37
              Caption = #1051#1086#1075#1080#1085
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitHeight = 37
            end
          end
        end
        inline FramePass: TFrameTextInput
          Left = 2
          Top = 52
          Width = 352
          Height = 37
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
          Background.Picture.Data = {00}
          ExplicitLeft = 2
          ExplicitTop = 52
          ExplicitWidth = 352
          inherited PanelTextInput: TUniPanel
            Width = 352
            ExplicitWidth = 352
            inherited Edit: TUniEdit
              Left = 114
              Top = 3
              Width = 228
              Height = 31
              ExplicitLeft = 114
              ExplicitTop = 3
              ExplicitWidth = 228
              ExplicitHeight = 31
            end
            inherited PanelText: TUniPanel
              Left = 0
              Top = 0
              Height = 37
              Caption = #1055#1072#1088#1086#1083#1100
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitHeight = 37
            end
          end
        end
      end
    end
  end
end
