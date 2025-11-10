object ProfileFrame: TProfileFrame
  Left = 0
  Top = 0
  Width = 358
  Height = 521
  TabOrder = 0
  object UniGroupBox1: TUniGroupBox
    Left = 0
    Top = 60
    Width = 358
    Height = 239
    Hint = ''
    Caption = ' '#1055#1088#1072#1074#1080#1083#1086' '
    Align = alTop
    TabOrder = 0
    object UniPanel1: TUniPanel
      Left = 2
      Top = 22
      Width = 354
      Height = 66
      Hint = ''
      Align = alTop
      TabOrder = 1
      BorderStyle = ubsNone
      ShowCaption = False
      Caption = 'UniPanel1'
      ExplicitTop = 15
      inline FrameRuleEnabled: TFrameBoolInput
        Left = 0
        Top = 0
        Width = 354
        Height = 30
        Align = alTop
        Anchors = [akLeft, akTop, akRight]
        Constraints.MaxHeight = 30
        Constraints.MinHeight = 30
        TabOrder = 1
        Background.Picture.Data = {00}
        ExplicitWidth = 354
        inherited PanelText: TUniPanel
          Caption = #1042#1082#1083#1102#1095#1077#1085#1086
        end
        inherited CheckBox: TUniCheckBox
          Width = 216
          OnChange = FrameRuleEnabledCheckBoxChange
          ExplicitWidth = 216
        end
      end
      inline FrameRulePosition: TFrameTextInput
        Left = 0
        Top = 30
        Width = 354
        Height = 30
        Align = alTop
        Anchors = [akLeft, akTop, akRight]
        Constraints.MaxHeight = 30
        Constraints.MinHeight = 30
        TabOrder = 2
        Background.Picture.Data = {00}
        ExplicitTop = 30
        ExplicitWidth = 354
        inherited PanelText: TUniPanel
          Caption = #1055#1086#1079#1080#1094#1080#1103
        end
        inherited Edit: TUniEdit
          Width = 183
          InputType = 'number'
          OnChange = FrameRulePositionEditChange
          ExplicitWidth = 183
        end
        inherited PanelUnits: TUniPanel
          Left = 328
          Caption = ''
          ExplicitLeft = 328
        end
      end
    end
    object UniPanel2: TUniPanel
      Left = 2
      Top = 88
      Width = 354
      Height = 149
      Hint = ''
      Align = alClient
      TabOrder = 2
      ShowCaption = False
      Caption = 'UniPanel2'
      object UniSplitter2: TUniSplitter
        Left = 169
        Top = 1
        Width = 6
        Height = 147
        Hint = ''
        Align = alLeft
        ParentColor = False
        Color = clBtnFace
        ExplicitHeight = 154
      end
      object PanelConditions: TUniPanel
        Left = 175
        Top = 1
        Width = 178
        Height = 147
        Hint = ''
        Align = alClient
        TabOrder = 2
        BorderStyle = ubsNone
        ShowCaption = False
        Caption = 'PanelConditions'
        ExplicitHeight = 154
      end
      object UniPanel3: TUniPanel
        Left = 1
        Top = 1
        Width = 168
        Height = 147
        Hint = ''
        Align = alLeft
        TabOrder = 3
        BorderStyle = ubsNone
        ShowCaption = False
        Caption = 'UniPanel3'
        object RuleTreeView: TUniTreeView
          Left = 0
          Top = 25
          Width = 168
          Height = 122
          Hint = ''
          Items.FontData = {0100000000}
          Align = alClient
          TabOrder = 1
          Color = clWindow
          UseCheckBox = True
          OnChange = RuleTreeViewChange
        end
        object UniPanel4: TUniPanel
          Left = 0
          Top = 0
          Width = 168
          Height = 25
          Hint = ''
          Align = alTop
          TabOrder = 2
          BorderStyle = ubsFrameLowered
          ShowCaption = False
          Caption = 'UniPanel4'
          object UniPanel5: TUniPanel
            AlignWithMargins = True
            Left = 2
            Top = 2
            Width = 25
            Height = 21
            Hint = ''
            Margins.Left = 0
            Margins.Top = 0
            Margins.Bottom = 0
            Align = alLeft
            TabOrder = 1
            BorderStyle = ubsNone
            ShowCaption = False
            Caption = 'UniPanel5'
            object btnAddRules: TUniBitBtn
              Left = 0
              Top = 0
              Width = 25
              Height = 21
              Hint = ''
              Margins.Left = 0
              Margins.Top = 0
              Margins.Bottom = 0
              ShowHint = True
              ParentShowHint = False
              Caption = '+'
              Align = alClient
              TabOrder = 1
              OnClick = btnAddRulesClick
            end
          end
          object UniPanel6: TUniPanel
            AlignWithMargins = True
            Left = 30
            Top = 2
            Width = 25
            Height = 21
            Hint = ''
            Margins.Left = 0
            Margins.Top = 0
            Margins.Bottom = 0
            Align = alLeft
            TabOrder = 2
            BorderStyle = ubsNone
            ShowCaption = False
            Caption = 'UniPanel5'
            object btnRemoveRules: TUniBitBtn
              Left = 0
              Top = 0
              Width = 25
              Height = 21
              Hint = ''
              Margins.Left = 0
              Margins.Top = 0
              Margins.Bottom = 0
              ShowHint = True
              ParentShowHint = False
              Caption = '-'
              Align = alClient
              TabOrder = 1
              OnClick = btnRemoveRulesClick
            end
          end
        end
      end
    end
  end
  object UniSplitter1: TUniSplitter
    Left = 0
    Top = 299
    Width = 358
    Height = 6
    Cursor = crVSplit
    Hint = ''
    Align = alTop
    ParentColor = False
    Color = clBtnFace
  end
  object UniGroupBox2: TUniGroupBox
    Left = 0
    Top = 305
    Width = 358
    Height = 216
    Hint = ''
    Caption = ' '#1044#1077#1081#1089#1090#1074#1080#1103' '
    Align = alClient
    TabOrder = 2
    object FtaGroupBox: TUniGroupBox
      AlignWithMargins = True
      Left = 12
      Top = 25
      Width = 334
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
        Width = 317
        Height = 17
        Hint = ''
        Margins.Left = 10
        Caption = 'fta_XML'
        Align = alTop
        TabOrder = 1
        OnChange = CheckBox_fta_XMLChange
      end
      object CheckBox_fta_JSON: TUniCheckBox
        AlignWithMargins = True
        Left = 12
        Top = 133
        Width = 317
        Height = 17
        Hint = ''
        Margins.Left = 10
        Caption = 'fta_JSON'
        Align = alTop
        TabOrder = 2
        OnChange = CheckBox_fta_JSONChange
      end
      object CheckBox_fta_SIMPLE: TUniCheckBox
        AlignWithMargins = True
        Left = 12
        Top = 110
        Width = 317
        Height = 17
        Hint = ''
        Margins.Left = 10
        Caption = 'fta_SIMPLE'
        Align = alTop
        TabOrder = 3
        OnChange = CheckBox_fta_SIMPLEChange
      end
      object CheckBox_fta_GAO: TUniCheckBox
        AlignWithMargins = True
        Left = 12
        Top = 87
        Width = 317
        Height = 17
        Hint = ''
        Margins.Left = 10
        Caption = 'fta_GAO'
        Align = alTop
        TabOrder = 4
        OnChange = CheckBox_fta_GAOChange
      end
      object CheckBox_fta_TLG: TUniCheckBox
        AlignWithMargins = True
        Left = 12
        Top = 64
        Width = 317
        Height = 17
        Hint = ''
        Margins.Left = 10
        Caption = 'fta_TLG'
        Align = alTop
        TabOrder = 5
        OnChange = CheckBox_fta_TLGChange
      end
      object CheckBox_fta_TLF: TUniCheckBox
        AlignWithMargins = True
        Left = 12
        Top = 41
        Width = 317
        Height = 17
        Hint = ''
        Margins.Left = 10
        Caption = 'fta_TLF'
        Align = alTop
        TabOrder = 6
        OnChange = CheckBox_fta_TLFChange
      end
      object CheckBox_fta_FILE: TUniCheckBox
        AlignWithMargins = True
        Left = 12
        Top = 18
        Width = 317
        Height = 17
        Hint = ''
        Margins.Left = 10
        Caption = 'fta_FILE'
        Align = alTop
        TabOrder = 7
        OnChange = CheckBox_fta_FILEChange
      end
    end
  end
  inline PridFrame: TFrameTextInput
    Left = 0
    Top = 0
    Width = 358
    Height = 30
    Align = alTop
    Anchors = [akLeft, akTop, akRight]
    Constraints.MaxHeight = 30
    Constraints.MinHeight = 30
    TabOrder = 3
    Background.Picture.Data = {00}
    ExplicitWidth = 358
    inherited PanelText: TUniPanel
      Caption = 'ID '#1087#1088#1086#1092#1080#1083#1103
    end
    inherited Edit: TUniEdit
      Width = 187
      ReadOnly = True
      ExplicitWidth = 187
    end
    inherited PanelUnits: TUniPanel
      Left = 332
      Caption = ''
      ExplicitLeft = 332
    end
  end
  inline DescriptionFrame: TFrameTextInput
    Left = 0
    Top = 30
    Width = 358
    Height = 30
    Align = alTop
    Anchors = [akLeft, akTop, akRight]
    Constraints.MaxHeight = 30
    Constraints.MinHeight = 30
    TabOrder = 4
    Background.Picture.Data = {00}
    ExplicitTop = 30
    ExplicitWidth = 358
    inherited PanelText: TUniPanel
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077
    end
    inherited Edit: TUniEdit
      Width = 187
      OnChange = DescriptionFrameEditChange
      ExplicitWidth = 187
    end
    inherited PanelUnits: TUniPanel
      Left = 332
      Caption = ''
      ExplicitLeft = 332
    end
  end
end
