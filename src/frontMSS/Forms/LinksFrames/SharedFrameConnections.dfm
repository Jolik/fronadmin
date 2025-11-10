object FrameConnections: TFrameConnections
  Left = 0
  Top = 0
  Width = 365
  Height = 459
  TabOrder = 0
  object UniGroupBox1: TUniGroupBox
    Left = 0
    Top = 0
    Width = 365
    Height = 459
    Hint = ''
    Caption = ' '#1057#1086#1077#1076#1080#1085#1077#1085#1080#1077' '
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 433
    inline FrameAddr: TFrameTextInput
      Left = 2
      Top = 15
      Width = 361
      Height = 30
      Align = alTop
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxHeight = 30
      Constraints.MinHeight = 30
      TabOrder = 1
      Background.Picture.Data = {00}
      ExplicitLeft = 2
      ExplicitTop = 15
      ExplicitWidth = 361
      inherited PanelText: TUniPanel
        Caption = #1040#1076#1088#1077#1089
      end
      inherited Edit: TUniEdit
        Width = 190
        ExplicitWidth = 190
      end
      inherited PanelUnits: TUniPanel
        Left = 335
        Caption = ''
        ExplicitLeft = 335
      end
    end
    inline FrameTimeout: TFrameTextInput
      Left = 2
      Top = 45
      Width = 361
      Height = 30
      Align = alTop
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxHeight = 30
      Constraints.MinHeight = 30
      TabOrder = 2
      Background.Picture.Data = {00}
      ExplicitLeft = 2
      ExplicitTop = 45
      ExplicitWidth = 361
      inherited PanelText: TUniPanel
        Caption = #1058#1072#1081#1084#1072#1091#1090
      end
      inherited Edit: TUniEdit
        Width = 190
        InputType = 'number'
        ExplicitWidth = 190
      end
      inherited PanelUnits: TUniPanel
        Left = 335
        ExplicitLeft = 335
      end
    end
    object UniGroupBox3: TUniGroupBox
      AlignWithMargins = True
      Left = 12
      Top = 145
      Width = 341
      Height = 84
      Hint = ''
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Caption = ' '#1040#1074#1090#1086#1088#1080#1079#1072#1094#1080#1103' '
      Align = alTop
      TabOrder = 3
      ExplicitTop = 115
      inline FrameLogin: TFrameTextInput
        Left = 2
        Top = 15
        Width = 337
        Height = 30
        Align = alTop
        Anchors = [akLeft, akTop, akRight]
        Constraints.MaxHeight = 30
        Constraints.MinHeight = 30
        TabOrder = 1
        Background.Picture.Data = {00}
        ExplicitLeft = 2
        ExplicitTop = 15
        ExplicitWidth = 337
        inherited PanelText: TUniPanel
          Caption = #1051#1086#1075#1080#1085
        end
        inherited Edit: TUniEdit
          Width = 166
          ExplicitWidth = 166
        end
        inherited PanelUnits: TUniPanel
          Left = 311
          Caption = ''
          ExplicitLeft = 311
        end
      end
      inline FramePassword: TFrameTextInput
        Left = 2
        Top = 45
        Width = 337
        Height = 30
        Align = alTop
        Anchors = [akLeft, akTop, akRight]
        Constraints.MaxHeight = 30
        Constraints.MinHeight = 30
        TabOrder = 2
        Background.Picture.Data = {00}
        ExplicitLeft = 2
        ExplicitTop = 45
        ExplicitWidth = 337
        inherited PanelText: TUniPanel
          Caption = #1055#1072#1088#1086#1083#1100
        end
        inherited Edit: TUniEdit
          Width = 166
          ExplicitWidth = 166
        end
        inherited PanelUnits: TUniPanel
          Left = 311
          Caption = ''
          ExplicitLeft = 311
        end
      end
    end
    object UniGroupBox2: TUniGroupBox
      AlignWithMargins = True
      Left = 12
      Top = 249
      Width = 341
      Height = 194
      Hint = ''
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Caption = ' TLS '
      Align = alTop
      TabOrder = 4
      ExplicitTop = 219
      inline FrameTLSEnable: TFrameBoolInput
        Left = 2
        Top = 15
        Width = 337
        Height = 30
        Align = alTop
        Anchors = [akLeft, akTop, akRight]
        Constraints.MaxHeight = 30
        Constraints.MinHeight = 30
        TabOrder = 1
        Background.Picture.Data = {00}
        ExplicitLeft = 2
        ExplicitTop = 15
        ExplicitWidth = 337
        inherited PanelText: TUniPanel
          Caption = #1042#1082#1083#1102#1095#1080#1090#1100
        end
        inherited CheckBox: TUniCheckBox
          Width = 199
          ExplicitWidth = 199
        end
      end
      object UniGroupBox4: TUniGroupBox
        AlignWithMargins = True
        Left = 12
        Top = 55
        Width = 317
        Height = 122
        Hint = ''
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Caption = ' '#1057#1077#1088#1090#1080#1092#1080#1082#1072#1090#1099' '
        Align = alTop
        TabOrder = 2
        inline FrameCRT: TFrameTextInput
          Left = 2
          Top = 15
          Width = 313
          Height = 30
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          Constraints.MaxHeight = 30
          Constraints.MinHeight = 30
          TabOrder = 1
          Background.Picture.Data = {00}
          ExplicitLeft = 2
          ExplicitTop = 15
          ExplicitWidth = 313
          inherited PanelText: TUniPanel
            Caption = 'CRT'
          end
          inherited Edit: TUniEdit
            Width = 142
            ExplicitWidth = 142
          end
          inherited PanelUnits: TUniPanel
            Left = 287
            Caption = ''
            ExplicitLeft = 287
          end
        end
        inline FrameCertKey: TFrameTextInput
          Left = 2
          Top = 45
          Width = 313
          Height = 30
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          Constraints.MaxHeight = 30
          Constraints.MinHeight = 30
          TabOrder = 2
          Background.Picture.Data = {00}
          ExplicitLeft = 2
          ExplicitTop = 45
          ExplicitWidth = 313
          inherited PanelText: TUniPanel
            Caption = 'Key'
          end
          inherited Edit: TUniEdit
            Width = 142
            ExplicitWidth = 142
          end
          inherited PanelUnits: TUniPanel
            Left = 287
            Caption = ''
            ExplicitLeft = 287
          end
        end
        inline FrameCertCA: TFrameTextInput
          Left = 2
          Top = 75
          Width = 313
          Height = 30
          Align = alTop
          Anchors = [akLeft, akTop, akRight]
          Constraints.MaxHeight = 30
          Constraints.MinHeight = 30
          TabOrder = 3
          Background.Picture.Data = {00}
          ExplicitLeft = 2
          ExplicitTop = 75
          ExplicitWidth = 313
          inherited PanelText: TUniPanel
            Caption = 'CA'
          end
          inherited Edit: TUniEdit
            Width = 142
            ExplicitWidth = 142
          end
          inherited PanelUnits: TUniPanel
            Left = 287
            Caption = ''
            ExplicitLeft = 287
          end
        end
      end
    end
    inline FrameConnectionKey: TFrameTextInput
      Left = 2
      Top = 75
      Width = 361
      Height = 30
      Align = alTop
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxHeight = 30
      Constraints.MinHeight = 30
      TabOrder = 5
      Background.Picture.Data = {00}
      ExplicitLeft = 2
      ExplicitTop = 75
      ExplicitWidth = 361
      inherited PanelText: TUniPanel
        Caption = #1050#1083#1102#1095' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1103
        ExplicitLeft = -3
        ExplicitTop = -3
      end
      inherited Edit: TUniEdit
        Width = 190
        ExplicitWidth = 190
      end
      inherited PanelUnits: TUniPanel
        Left = 335
        Caption = ''
        ExplicitLeft = 335
      end
    end
    inline FrameReplaceIP: TFrameBoolInput
      Left = 2
      Top = 105
      Width = 361
      Height = 30
      Align = alTop
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxHeight = 30
      Constraints.MinHeight = 30
      TabOrder = 6
      Background.Picture.Data = {00}
      ExplicitLeft = 2
      ExplicitTop = 110
      ExplicitWidth = 361
      inherited PanelText: TUniPanel
        Caption = #1055#1086#1076#1084#1077#1085#1103#1090#1100' IP'
        ExplicitTop = 100
      end
      inherited CheckBox: TUniCheckBox
        Width = 223
        ExplicitWidth = 199
      end
    end
  end
end
