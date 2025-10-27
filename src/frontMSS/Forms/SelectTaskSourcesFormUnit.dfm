object SelectTaskSourcesForm: TSelectTaskSourcesForm
  Left = 0
  Top = 0
  ClientHeight = 520
  ClientWidth = 935
  Caption = #1042#1099#1073#1086#1088' '#1080#1089#1090#1086#1095#1085#1080#1082#1086#1074' '#1079#1072#1076#1072#1095#1080
  BorderStyle = bsSingle
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  OnCreate = UniFormCreate
  OnDestroy = UniFormDestroy
  TextHeight = 15
  object lbTaskSources: TUniListBox
    Left = 5
    Top = 5
    Width = 250
    Height = 460
    Hint = ''
    TabOrder = 0
    MultiSelect = True
  end
  object lbAllSources: TUniListBox
    Left = 295
    Top = 5
    Width = 250
    Height = 460
    Hint = ''
    TabOrder = 1
    MultiSelect = True
    OnChange = lbAllSourcesChange
    OnClick = lbAllSourcesClick
  end
  object pcEntityInfo: TUniPageControl
    AlignWithMargins = True
    Left = 552
    Top = 5
    Width = 378
    Height = 460
    Hint = ''
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ActivePage = tsSourceInfo
    TabBarVisible = False
    Align = alRight
    TabOrder = 2
    ExplicitLeft = 699
    ExplicitTop = 0
    ExplicitHeight = 572
    object tsSourceInfo: TUniTabSheet
      Hint = ''
      TabVisible = False
      Caption = 'Task.Info'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 256
      ExplicitHeight = 544
      object cpSourceInfo: TUniContainerPanel
        Left = 0
        Top = 0
        Width = 370
        Height = 432
        Hint = ''
        Margins.Right = 0
        ParentColor = False
        Align = alClient
        ParentAlignmentControl = False
        TabOrder = 0
        Layout = 'table'
        LayoutAttribs.Columns = 2
        ExplicitHeight = 544
        object cpSourceInfoID: TUniContainerPanel
          AlignWithMargins = True
          Left = 10
          Top = 39
          Width = 355
          Height = 40
          Hint = ''
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          ParentColor = False
          Align = alTop
          ParentAlignmentControl = False
          TabOrder = 1
          Layout = 'table'
          LayoutAttribs.Columns = 2
          object lSourceInfoID: TUniLabel
            AlignWithMargins = True
            Left = 5
            Top = 7
            Width = 100
            Height = 20
            Hint = ''
            Margins.Left = 5
            Margins.Top = 7
            Margins.Right = 5
            Margins.Bottom = 7
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'ID'
            Align = alLeft
            ParentFont = False
            Font.Style = [fsBold]
            TabOrder = 1
          end
          object lSourceInfoIDValue: TUniLabel
            AlignWithMargins = True
            Left = 115
            Top = 7
            Width = 235
            Height = 20
            Hint = ''
            Margins.Left = 5
            Margins.Top = 7
            Margins.Right = 5
            Margins.Bottom = 7
            AutoSize = False
            Caption = 'ID'
            Align = alClient
            ParentFont = False
            TabOrder = 2
          end
          object pSeparator1: TUniPanel
            AlignWithMargins = True
            Left = 0
            Top = 34
            Width = 355
            Height = 1
            Hint = ''
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 5
            Align = alBottom
            TabOrder = 3
            Caption = ''
            Color = clHighlight
          end
        end
        object cpSourceInfoName: TUniContainerPanel
          AlignWithMargins = True
          Left = 10
          Top = 79
          Width = 355
          Height = 40
          Hint = ''
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          ParentColor = False
          Align = alTop
          ParentAlignmentControl = False
          TabOrder = 2
          Layout = 'table'
          LayoutAttribs.Columns = 2
          object lSourceInfoName: TUniLabel
            AlignWithMargins = True
            Left = 5
            Top = 7
            Width = 100
            Height = 20
            Hint = ''
            Margins.Left = 5
            Margins.Top = 7
            Margins.Right = 5
            Margins.Bottom = 7
            Alignment = taRightJustify
            AutoSize = False
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            Align = alLeft
            ParentFont = False
            Font.Style = [fsBold]
            TabOrder = 1
          end
          object lSourceInfoNameValue: TUniLabel
            AlignWithMargins = True
            Left = 115
            Top = 7
            Width = 235
            Height = 20
            Hint = ''
            Margins.Left = 5
            Margins.Top = 7
            Margins.Right = 5
            Margins.Bottom = 7
            AutoSize = False
            Caption = 'ID'
            Align = alClient
            ParentFont = False
            TabOrder = 2
          end
          object pSeparator2: TUniPanel
            AlignWithMargins = True
            Left = 0
            Top = 34
            Width = 355
            Height = 1
            Hint = ''
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 5
            Align = alBottom
            TabOrder = 3
            Caption = ''
            Color = clHighlight
          end
        end
        object lSourceCaption: TUniLabel
          AlignWithMargins = True
          Left = 10
          Top = 10
          Width = 355
          Height = 19
          Hint = ''
          Margins.Left = 10
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 10
          AutoSize = False
          Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1048#1089#1090#1086#1095#1085#1080#1082#1077
          Align = alTop
          ParentFont = False
          Font.Color = clGray
          Font.Height = -13
          Font.Style = [fsBold]
          TabOrder = 3
        end
        object cpSourceInfoCreated: TUniContainerPanel
          AlignWithMargins = True
          Left = 10
          Top = 159
          Width = 355
          Height = 40
          Hint = ''
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          ParentColor = False
          Align = alTop
          ParentAlignmentControl = False
          TabOrder = 4
          Layout = 'table'
          LayoutAttribs.Columns = 2
          object lSourceInfoCreated: TUniLabel
            AlignWithMargins = True
            Left = 5
            Top = 7
            Width = 100
            Height = 20
            Hint = ''
            Margins.Left = 5
            Margins.Top = 7
            Margins.Right = 5
            Margins.Bottom = 7
            Alignment = taRightJustify
            AutoSize = False
            Caption = #1057#1086#1079#1076#1072#1085#1072
            Align = alLeft
            ParentFont = False
            Font.Style = [fsBold]
            TabOrder = 1
          end
          object lSourceInfoCreatedValue: TUniLabel
            AlignWithMargins = True
            Left = 115
            Top = 7
            Width = 235
            Height = 20
            Hint = ''
            Margins.Left = 5
            Margins.Top = 7
            Margins.Right = 5
            Margins.Bottom = 7
            AutoSize = False
            Caption = 'ID'
            Align = alClient
            ParentFont = False
            TabOrder = 2
          end
          object pSeparator3: TUniPanel
            AlignWithMargins = True
            Left = 0
            Top = 34
            Width = 355
            Height = 1
            Hint = ''
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 5
            Align = alBottom
            TabOrder = 3
            Caption = ''
            Color = clHighlight
          end
        end
        object cpSourceInfoUpdated: TUniContainerPanel
          AlignWithMargins = True
          Left = 10
          Top = 199
          Width = 355
          Height = 40
          Hint = ''
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          ParentColor = False
          Align = alTop
          ParentAlignmentControl = False
          TabOrder = 5
          Layout = 'table'
          LayoutAttribs.Columns = 2
          object lTaskInfoUpdated: TUniLabel
            AlignWithMargins = True
            Left = 5
            Top = 7
            Width = 100
            Height = 20
            Hint = ''
            Margins.Left = 5
            Margins.Top = 7
            Margins.Right = 5
            Margins.Bottom = 7
            Alignment = taRightJustify
            AutoSize = False
            Caption = #1048#1079#1084#1077#1085#1077#1085#1072
            Align = alLeft
            ParentFont = False
            Font.Style = [fsBold]
            TabOrder = 1
          end
          object lTaskInfoUpdatedValue: TUniLabel
            AlignWithMargins = True
            Left = 115
            Top = 7
            Width = 235
            Height = 20
            Hint = ''
            Margins.Left = 5
            Margins.Top = 7
            Margins.Right = 5
            Margins.Bottom = 7
            AutoSize = False
            Caption = 'ID'
            Align = alClient
            ParentFont = False
            TabOrder = 2
          end
          object pSeparator4: TUniPanel
            AlignWithMargins = True
            Left = 0
            Top = 34
            Width = 355
            Height = 1
            Hint = ''
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 5
            Align = alBottom
            TabOrder = 3
            Caption = ''
            Color = clHighlight
          end
        end
        object cpSourceInfoModule: TUniContainerPanel
          AlignWithMargins = True
          Left = 10
          Top = 119
          Width = 355
          Height = 40
          Hint = ''
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          ParentColor = False
          Align = alTop
          ParentAlignmentControl = False
          TabOrder = 6
          Layout = 'table'
          LayoutAttribs.Columns = 2
          object lSourceInfoModule: TUniLabel
            AlignWithMargins = True
            Left = 5
            Top = 7
            Width = 100
            Height = 20
            Hint = ''
            Margins.Left = 5
            Margins.Top = 7
            Margins.Right = 5
            Margins.Bottom = 7
            Alignment = taRightJustify
            AutoSize = False
            Caption = #1052#1086#1076#1091#1083#1100
            Align = alLeft
            ParentFont = False
            Font.Style = [fsBold]
            TabOrder = 1
          end
          object lSourceInfoModuleValue: TUniLabel
            AlignWithMargins = True
            Left = 115
            Top = 7
            Width = 235
            Height = 20
            Hint = ''
            Margins.Left = 5
            Margins.Top = 7
            Margins.Right = 5
            Margins.Bottom = 7
            AutoSize = False
            Caption = 'ID'
            Align = alClient
            ParentFont = False
            TabOrder = 2
          end
          object pSeparator5: TUniPanel
            AlignWithMargins = True
            Left = 0
            Top = 34
            Width = 355
            Height = 1
            Hint = ''
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 5
            Align = alBottom
            TabOrder = 3
            Caption = ''
            Color = clHighlight
          end
        end
      end
    end
  end
  object pnBottom: TUniContainerPanel
    Left = 0
    Top = 470
    Width = 935
    Height = 50
    Hint = ''
    ParentColor = False
    Align = alBottom
    TabOrder = 3
    ExplicitTop = 572
    ExplicitWidth = 1077
    object btnOk: TUniButton
      AlignWithMargins = True
      Left = 776
      Top = 12
      Width = 75
      Height = 26
      Hint = ''
      Margins.Top = 12
      Margins.Bottom = 12
      Caption = #1054#1050
      Align = alRight
      TabOrder = 1
      OnClick = btnOkClick
      ExplicitLeft = 918
    end
    object btnCancel: TUniButton
      AlignWithMargins = True
      Left = 857
      Top = 12
      Width = 75
      Height = 26
      Hint = ''
      Margins.Top = 12
      Margins.Bottom = 12
      Caption = #1054#1090#1084#1077#1085#1072
      Align = alRight
      TabOrder = 2
      OnClick = btnCancelClick
      ExplicitLeft = 999
    end
  end
  object btnAddSource: TUniButton
    Left = 260
    Top = 5
    Width = 30
    Height = 30
    Hint = ''
    Caption = ''
    TabOrder = 4
    ImageIndex = 0
    IconAlign = iaCenter
    IconCls = 'arrow_left'
    OnClick = btnAddSourceClick
  end
  object btnRemoveSource: TUniButton
    Left = 260
    Top = 40
    Width = 30
    Height = 30
    Hint = ''
    Caption = ''
    TabOrder = 5
    ImageIndex = 1
    IconAlign = iaCenter
    IconCls = 'arrow_right'
    OnClick = btnRemoveSourceClick
  end
end
