object ProfileFrame: TProfileFrame
  Left = 0
  Top = 0
  Width = 325
  Height = 422
  TabOrder = 0
  object UniGroupBox1: TUniGroupBox
    Left = 0
    Top = 60
    Width = 325
    Height = 133
    Hint = ''
    Caption = ' '#1059#1089#1083#1086#1074#1080#1103' '
    Align = alTop
    TabOrder = 0
  end
  object UniSplitter1: TUniSplitter
    Left = 0
    Top = 193
    Width = 325
    Height = 6
    Cursor = crVSplit
    Hint = ''
    Align = alTop
    ParentColor = False
    Color = clBtnFace
  end
  object UniGroupBox2: TUniGroupBox
    Left = 0
    Top = 199
    Width = 325
    Height = 223
    Hint = ''
    Caption = ' '#1044#1077#1081#1089#1090#1074#1080#1103' '
    Align = alClient
    TabOrder = 2
    object FtaGroupBox: TUniGroupBox
      AlignWithMargins = True
      Left = 12
      Top = 25
      Width = 301
      Height = 184
      Hint = ''
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Caption = #1053#1072#1087#1088#1072#1074#1080#1090#1100' '#1074' FTA'
      Align = alTop
      TabOrder = 1
      object CheckBox_fta_XML: TUniCheckBox
        AlignWithMargins = True
        Left = 12
        Top = 156
        Width = 284
        Height = 17
        Hint = ''
        Margins.Left = 10
        Caption = 'fta_XML'
        Align = alTop
        TabOrder = 1
      end
      object CheckBox_fta_JSON: TUniCheckBox
        AlignWithMargins = True
        Left = 12
        Top = 133
        Width = 284
        Height = 17
        Hint = ''
        Margins.Left = 10
        Caption = 'fta_JSON'
        Align = alTop
        TabOrder = 2
      end
      object CheckBox_fta_SIMPLE: TUniCheckBox
        AlignWithMargins = True
        Left = 12
        Top = 110
        Width = 284
        Height = 17
        Hint = ''
        Margins.Left = 10
        Caption = 'fta_SIMPLE'
        Align = alTop
        TabOrder = 3
      end
      object CheckBox_fta_GAO: TUniCheckBox
        AlignWithMargins = True
        Left = 12
        Top = 87
        Width = 284
        Height = 17
        Hint = ''
        Margins.Left = 10
        Caption = 'fta_GAO'
        Align = alTop
        TabOrder = 4
      end
      object CheckBox_fta_TLG: TUniCheckBox
        AlignWithMargins = True
        Left = 12
        Top = 64
        Width = 284
        Height = 17
        Hint = ''
        Margins.Left = 10
        Caption = 'fta_TLG'
        Align = alTop
        TabOrder = 5
      end
      object CheckBox_fta_TLF: TUniCheckBox
        AlignWithMargins = True
        Left = 12
        Top = 41
        Width = 284
        Height = 17
        Hint = ''
        Margins.Left = 10
        Caption = 'fta_TLF'
        Align = alTop
        TabOrder = 6
      end
      object CheckBox_fta_FILE: TUniCheckBox
        AlignWithMargins = True
        Left = 12
        Top = 18
        Width = 284
        Height = 17
        Hint = ''
        Margins.Left = 10
        Caption = 'fta_FILE'
        Align = alTop
        TabOrder = 7
      end
    end
  end
  inline PridFrame: TFrameTextInput
    Left = 0
    Top = 0
    Width = 325
    Height = 30
    Align = alTop
    Anchors = [akLeft, akTop, akRight]
    Constraints.MaxHeight = 30
    Constraints.MinHeight = 30
    TabOrder = 3
    Background.Picture.Data = {00}
    ExplicitWidth = 325
    inherited PanelText: TUniPanel
      Caption = 'ID '#1087#1088#1086#1092#1080#1083#1103
    end
    inherited Edit: TUniEdit
      Width = 154
      ReadOnly = True
      ExplicitWidth = 154
    end
    inherited PanelUnits: TUniPanel
      Left = 299
      Caption = ''
      ExplicitLeft = 299
    end
  end
  inline DescriptionFrame: TFrameTextInput
    Left = 0
    Top = 30
    Width = 325
    Height = 30
    Align = alTop
    Anchors = [akLeft, akTop, akRight]
    Constraints.MaxHeight = 30
    Constraints.MinHeight = 30
    TabOrder = 4
    Background.Picture.Data = {00}
    ExplicitTop = 30
    ExplicitWidth = 325
    inherited PanelText: TUniPanel
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077
    end
    inherited Edit: TUniEdit
      Width = 154
      ExplicitWidth = 154
    end
    inherited PanelUnits: TUniPanel
      Left = 299
      Caption = ''
      ExplicitLeft = 299
    end
  end
end
