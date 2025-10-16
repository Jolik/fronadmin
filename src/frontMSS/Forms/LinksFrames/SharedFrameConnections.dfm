object FrameConnections: TFrameConnections
  Left = 0
  Top = 0
  Width = 365
  Height = 393
  TabOrder = 0
  object UniGroupBox1: TUniGroupBox
    Left = 0
    Top = 0
    Width = 365
    Height = 393
    Hint = ''
    Caption = ' '#1057#1086#1077#1076#1080#1085#1077#1085#1080#1077' '
    Align = alClient
    TabOrder = 0
    object UniGroupBox3: TUniGroupBox
      AlignWithMargins = True
      Left = 12
      Top = 85
      Width = 341
      Height = 84
      Hint = ''
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Caption = ' '#1040#1074#1090#1086#1088#1080#1079#1072#1094#1080#1103' '
      Align = alTop
      TabOrder = 1
    end
    object UniGroupBox2: TUniGroupBox
      AlignWithMargins = True
      Left = 12
      Top = 189
      Width = 341
      Height = 194
      Hint = ''
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Caption = ' TLS '
      Align = alTop
      TabOrder = 2
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
      end
    end
  end
end
