object QueueFrame: TQueueFrame
  Left = 0
  Top = 0
  Width = 519
  Height = 395
  TabOrder = 0
  object UniGroupBox1: TUniGroupBox
    Left = 0
    Top = 0
    Width = 519
    Height = 395
    Hint = ''
    Caption = ' '#1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1086#1095#1077#1088#1077#1076#1080' '
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 640
    ExplicitHeight = 480
    inline FrameQID: TFrameTextInput
      Left = 2
      Top = 45
      Width = 515
      Height = 30
      Align = alTop
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxHeight = 30
      Constraints.MinHeight = 30
      TabOrder = 1
      Background.Picture.Data = {00}
      ExplicitLeft = 256
      ExplicitTop = 208
      inherited PanelText: TUniPanel
        Caption = 'ID'
      end
      inherited Edit: TUniEdit
        Width = 344
      end
      inherited PanelUnits: TUniPanel
        Left = 489
        Caption = ''
      end
    end
    inline FrameCaption: TFrameTextInput
      Left = 2
      Top = 15
      Width = 515
      Height = 30
      Align = alTop
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxHeight = 30
      Constraints.MinHeight = 30
      TabOrder = 2
      Background.Picture.Data = {00}
      ExplicitLeft = 256
      ExplicitTop = 208
      ExplicitWidth = 636
      inherited PanelText: TUniPanel
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
      end
      inherited Edit: TUniEdit
        Width = 344
        ExplicitWidth = 465
      end
      inherited PanelUnits: TUniPanel
        Left = 489
        Caption = ''
        ExplicitLeft = 610
      end
    end
    inline FrameDoubles: TFrameBoolInput
      Left = 2
      Top = 105
      Width = 515
      Height = 30
      Align = alTop
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxHeight = 30
      Constraints.MinHeight = 30
      TabOrder = 3
      Background.Picture.Data = {00}
      ExplicitLeft = 184
      ExplicitTop = 200
      inherited PanelText: TUniPanel
        Caption = #1044#1091#1073#1083#1080#1082#1072#1090#1099
      end
      inherited CheckBox: TUniCheckBox
        Width = 377
      end
    end
    inline FrameAllowPut: TFrameBoolInput
      Left = 2
      Top = 75
      Width = 515
      Height = 30
      Align = alTop
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxHeight = 30
      Constraints.MinHeight = 30
      TabOrder = 4
      Background.Picture.Data = {00}
      ExplicitLeft = 184
      ExplicitTop = 200
      ExplicitWidth = 636
      inherited PanelText: TUniPanel
        Caption = #1042#1099#1076#1072#1095#1072
      end
      inherited CheckBox: TUniCheckBox
        Width = 377
        ExplicitWidth = 498
      end
    end
    object UniGroupBox2: TUniGroupBox
      AlignWithMargins = True
      Left = 7
      Top = 140
      Width = 505
      Height = 248
      Hint = ''
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = ' '#1060#1080#1083#1100#1090#1088#1099' '
      Align = alClient
      TabOrder = 5
      ExplicitLeft = 2
      ExplicitTop = 135
      ExplicitWidth = 636
      ExplicitHeight = 242
      object UniPanel2: TUniPanel
        Left = 2
        Top = 15
        Width = 501
        Height = 231
        Hint = ''
        Align = alClient
        TabOrder = 1
        ShowCaption = False
        Caption = 'UniPanel2'
        ExplicitLeft = 4
        ExplicitTop = 17
        ExplicitWidth = 622
        object UniSplitter2: TUniSplitter
          Left = 249
          Top = 1
          Width = 6
          Height = 229
          Hint = ''
          Align = alLeft
          ParentColor = False
          Color = clBtnFace
          ExplicitLeft = 169
        end
        object PanelConditions: TUniPanel
          Left = 255
          Top = 1
          Width = 245
          Height = 229
          Hint = ''
          Align = alClient
          TabOrder = 2
          BorderStyle = ubsNone
          ShowCaption = False
          Caption = 'PanelConditions'
          ExplicitTop = 3
          object panelFilterType: TUniPanel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 239
            Height = 30
            Hint = ''
            Visible = False
            Constraints.MaxHeight = 30
            Constraints.MinHeight = 30
            Align = alTop
            TabOrder = 1
            BorderStyle = ubsNone
            Alignment = taLeftJustify
            ShowCaption = False
            Caption = #1090#1080#1087' '#1092#1080#1083#1100#1090#1088#1072
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 245
            object comboFilterType: TUniComboBox
              AlignWithMargins = True
              Left = 92
              Top = 3
              Width = 144
              Height = 24
              Hint = ''
              Style = csOwnerDrawFixed
              Text = ''
              Items.Strings = (
                #1074#1082#1083#1102#1095#1072#1102#1097#1080#1081
                #1080#1089#1082#1083#1102#1095#1072#1102#1097#1080#1081)
              Align = alClient
              TabOrder = 1
              IconItems = <>
              OnChange = comboFilterTypeChange
              ExplicitLeft = 80
              ExplicitTop = 0
              ExplicitWidth = 159
              ExplicitHeight = 30
            end
            object UniPanel7: TUniPanel
              Left = 0
              Top = 0
              Width = 89
              Height = 30
              Hint = ''
              Align = alLeft
              TabOrder = 2
              BorderStyle = ubsNone
              Caption = #1090#1080#1087' '#1092#1080#1083#1100#1090#1088#1072
            end
          end
        end
        object UniPanel3: TUniPanel
          Left = 1
          Top = 1
          Width = 248
          Height = 229
          Hint = ''
          Align = alLeft
          TabOrder = 3
          BorderStyle = ubsNone
          ShowCaption = False
          Caption = 'UniPanel3'
          object RuleTreeView: TUniTreeView
            Left = 0
            Top = 25
            Width = 248
            Height = 204
            Hint = ''
            Items.FontData = {0100000000}
            Align = alClient
            TabOrder = 1
            Color = clWindow
            UseCheckBox = True
            OnChange = RuleTreeViewChange
            ExplicitWidth = 168
          end
          object UniPanel4: TUniPanel
            Left = 0
            Top = 0
            Width = 248
            Height = 25
            Hint = ''
            Align = alTop
            TabOrder = 2
            BorderStyle = ubsFrameLowered
            ShowCaption = False
            Caption = 'UniPanel4'
            ExplicitWidth = 168
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
  end
end
