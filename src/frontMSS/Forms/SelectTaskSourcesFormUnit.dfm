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
  object pcEntityInfo: TUniPageControl
    AlignWithMargins = True
    Left = 552
    Top = 30
    Width = 378
    Height = 485
    Hint = ''
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ActivePage = tsSourceInfo
    TabBarVisible = False
    Align = alRight
    TabOrder = 0
    ExplicitLeft = 550
    ExplicitHeight = 477
    object tsSourceInfo: TUniTabSheet
      Hint = ''
      TabVisible = False
      Caption = 'Task.Info'
      ExplicitHeight = 449
      object cpSourceInfo: TUniContainerPanel
        Left = 0
        Top = 39
        Width = 370
        Height = 418
        Hint = ''
        Margins.Right = 0
        ParentColor = False
        Align = alClient
        ParentAlignmentControl = False
        TabOrder = 0
        Layout = 'table'
        LayoutAttribs.Columns = 2
        ExplicitHeight = 410
        object uncntnrpnUpdate: TUniContainerPanel
          AlignWithMargins = True
          Left = 10
          Top = 200
          Width = 355
          Height = 40
          Hint = ''
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          CreateOrder = 2
          ParentColor = False
          Align = alTop
          ParentAlignmentControl = False
          TabOrder = 6
          Layout = 'table'
          LayoutAttribs.Columns = 2
          object unlblUpdate: TUniLabel
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
            Caption = #1054#1073#1085#1086#1074#1083#1077#1085#1072
            Align = alLeft
            ParentFont = False
            Font.Style = [fsBold]
            TabOrder = 1
          end
          object unlblUpdatedVal: TUniLabel
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
          object unpnl2: TUniPanel
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
        object cpSourceInfoCreated: TUniContainerPanel
          AlignWithMargins = True
          Left = 10
          Top = 160
          Width = 355
          Height = 40
          Hint = ''
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          CreateOrder = 2
          ParentColor = False
          Align = alTop
          ParentAlignmentControl = False
          TabOrder = 7
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
            object lSourceInfoID: TUniLabel
              AlignWithMargins = True
              Left = 6
              Top = 8
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
              Left = 116
              Top = 8
              Width = 233
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
          end
        end
        object cpSourceInfoID: TUniContainerPanel
          AlignWithMargins = True
          Left = 10
          Top = 0
          Width = 355
          Height = 40
          Hint = ''
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          CreateOrder = 2
          ParentColor = False
          Align = alTop
          ParentAlignmentControl = False
          TabOrder = 1
          Layout = 'table'
          LayoutAttribs.Columns = 2
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
            TabOrder = 1
            Caption = ''
            Color = clHighlight
          end
        end
        object uncntnrpnSourceInfoRegion: TUniContainerPanel
          AlignWithMargins = True
          Left = 10
          Top = 80
          Width = 355
          Height = 40
          Hint = ''
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          CreateOrder = 3
          ParentColor = False
          Align = alTop
          ParentAlignmentControl = False
          TabOrder = 5
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
            Caption = #1048#1085#1076#1077#1082#1089
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
        object cpSourceInfoName: TUniContainerPanel
          AlignWithMargins = True
          Left = 10
          Top = 120
          Width = 355
          Height = 40
          Hint = ''
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          CreateOrder = 4
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
            Caption = #1056#1077#1075#1080#1086#1085
            Align = alLeft
            ParentFont = False
            Font.Style = [fsBold]
            TabOrder = 1
          end
          object unlblregion: TUniLabel
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
        object uncntnrpnSourceInfoCoords: TUniGroupBox
          AlignWithMargins = True
          Left = 10
          Top = 240
          Width = 355
          Height = 60
          Hint = ''
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Caption = #1050#1086#1086#1088#1076#1080#1085#1072#1090#1099
          Align = alTop
          ParentColor = False
          Layout = 'table'
          LayoutAttribs.Columns = 2
          TabOrder = 3
          DesignSize = (
            355
            60)
          object unlbllat: TUniLabel
            AlignWithMargins = True
            Left = 115
            Top = 14
            Width = 235
            Height = 26
            Hint = ''
            Margins.Left = 5
            Margins.Top = 7
            Margins.Right = 5
            Margins.Bottom = 7
            AutoSize = False
            Caption = 'lat'
            Anchors = [akLeft]
            ParentFont = False
            TabOrder = 1
          end
          object unlbllon: TUniLabel
            AlignWithMargins = True
            Left = 115
            Top = 33
            Width = 235
            Height = 18
            Hint = ''
            Margins.Left = 5
            Margins.Top = 7
            Margins.Right = 5
            Margins.Bottom = 7
            AutoSize = False
            Caption = 'lon'
            Anchors = [akLeft]
            ParentFont = False
            TabOrder = 2
          end
          object unlbllat1: TUniLabel
            Left = 48
            Top = 14
            Width = 43
            Height = 13
            Hint = ''
            Caption = #1064#1080#1088#1086#1090#1072
            TabOrder = 3
          end
          object unlblon: TUniLabel
            Left = 48
            Top = 33
            Width = 44
            Height = 13
            Hint = ''
            Caption = #1044#1086#1083#1075#1086#1090#1072
            TabOrder = 4
          end
        end
        object uncntnrpnSourceInfoName: TUniContainerPanel
          AlignWithMargins = True
          Left = 10
          Top = 40
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
          object unlbl1: TUniLabel
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
          object unlblSourceInfoNameValue: TUniLabel
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
          object unpnl1: TUniPanel
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
        object pnBottom: TUniContainerPanel
          Left = 0
          Top = 368
          Width = 370
          Height = 50
          Hint = ''
          ParentColor = False
          Align = alBottom
          TabOrder = 8
          ExplicitTop = 462
          ExplicitWidth = 933
          object btnOk: TUniButton
            AlignWithMargins = True
            Left = 211
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
          end
          object btnCancel: TUniButton
            AlignWithMargins = True
            Left = 292
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
          end
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
        TabOrder = 1
      end
    end
  end
  object gridSources: TUniDBGrid
    Left = 0
    Top = 25
    Width = 547
    Height = 495
    Hint = ''
    DataSource = dsSourcesDS
    WebOptions.PageSize = 200
    LoadMask.Message = 'Loading data...'
    Align = alClient
    TabOrder = 1
    OnSelectionChange = gridSourcesSelectionChange
    Columns = <
      item
        FieldName = 'selected'
        Title.Caption = #1042#1082#1083
        Width = 34
      end
      item
        FieldName = 'sid'
        Title.Caption = ' '#1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
        Width = 145
        ReadOnly = True
      end
      item
        FieldName = 'name'
        Title.Caption = ' '#1053#1072#1079#1074#1072#1085#1080#1077
        Width = 237
        ReadOnly = True
      end>
  end
  object unpnlFilter: TUniPanel
    Left = 0
    Top = 0
    Width = 935
    Height = 25
    Hint = ''
    Align = alTop
    TabOrder = 2
    Caption = 'unpnlFilter'
    ExplicitWidth = 933
    object undtSourceFilter: TUniEdit
      Left = 42
      Top = 1
      Width = 215
      Hint = ''
      Text = ''
      TabOrder = 1
      OnChange = undtSourceFilterChange
    end
    object unlblFilter: TUniLabel
      Left = 0
      Top = 5
      Width = 38
      Height = 13
      Hint = ''
      Caption = #1060#1080#1083#1100#1090#1088
      TabOrder = 2
    end
  end
  object dsSourcesDS: TDataSource
    DataSet = SourcesMem
    Left = 230
    Top = 300
  end
  object SourcesMem: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'selected'
        DataType = ftBoolean
      end
      item
        Name = 'sid'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'name'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'enabled'
        DataType = ftBoolean
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 300
    Top = 302
    object SourcesMemselected: TBooleanField
      FieldName = 'selected'
    end
    object SourcesMemsid: TStringField
      FieldName = 'sid'
    end
    object SourcesMemname: TStringField
      FieldName = 'name'
    end
    object SourcesMemenabled: TBooleanField
      FieldName = 'enabled'
    end
  end
  object FilterDebounceTimer: TUniTimer
    Interval = 400
    Enabled = False
    ClientEvent.Strings = (
      'function(sender)'
      '{'
      ' '
      '}')
    OnTimer = FilterDebounceTimerTimer
    Left = 392
    Top = 296
  end
end
