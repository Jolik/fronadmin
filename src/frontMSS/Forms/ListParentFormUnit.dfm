inherited ListParentForm: TListParentForm
  Caption = 'ListParentForm'
  TextHeight = 15
  object tbEntity: TUniToolBar
    Left = 0
    Top = 0
    Width = 1160
    Height = 29
    Hint = ''
    TabOrder = 0
    ParentColor = False
    Color = clBtnFace
    object btnNew: TUniToolButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Hint = ''
      Caption = 'btnNew'
      TabOrder = 1
      IconCls = 'add'
      OnClick = btnNewClick
    end
    object btnUpdate: TUniToolButton
      AlignWithMargins = True
      Left = 32
      Top = 3
      Hint = ''
      Caption = 'btnUpdate'
      TabOrder = 3
      IconCls = 'settings'
      OnClick = btnUpdateClick
    end
    object btnRemove: TUniToolButton
      AlignWithMargins = True
      Left = 61
      Top = 3
      Hint = ''
      Caption = 'btnRemove'
      TabOrder = 2
      IconCls = 'delete'
      OnClick = btnRemoveClick
    end
    object btnRefresh: TUniToolButton
      AlignWithMargins = True
      Left = 90
      Top = 3
      Hint = ''
      Caption = 'btnRefresh'
      TabOrder = 4
      IconCls = 'refresh'
      OnClick = btnRefreshClick
    end
  end
  object dbgEntity: TUniDBGrid
    Left = 0
    Top = 29
    Width = 774
    Height = 538
    Hint = ''
    DataSource = DatasourceEntity
    LoadMask.Message = 'Loading data...'
    ForceFit = True
    Align = alClient
    TabOrder = 1
    OnSelectionChange = dbgEntitySelectionChange
    Columns = <
      item
        FieldName = 'Name'
        Title.Caption = #1048#1084#1103
        Width = 100
      end
      item
        FieldName = 'Caption'
        Title.Caption = #1055#1086#1076#1087#1080#1089#1100
        Width = 100
      end
      item
        FieldName = 'Created'
        Title.Caption = #1057#1086#1079#1076#1072#1085
        Width = 112
      end
      item
        FieldName = 'Updated'
        Title.Caption = #1048#1079#1084#1077#1085#1077#1085
        Width = 112
      end>
  end
  object splSplitter: TUniSplitter
    Left = 774
    Top = 29
    Width = 6
    Height = 538
    Hint = ''
    Align = alRight
    ParentColor = False
    Color = clBtnFace
  end
  object pcEntityInfo: TUniPageControl
    Left = 780
    Top = 29
    Width = 380
    Height = 538
    Hint = ''
    ActivePage = tsTaskInfo
    TabBarVisible = False
    Align = alRight
    TabOrder = 3
    object tsTaskInfo: TUniTabSheet
      Hint = ''
      TabVisible = False
      Caption = 'Task.Info'
      object cpTaskInfo: TUniContainerPanel
        Left = 0
        Top = 0
        Width = 372
        Height = 510
        Hint = ''
        Margins.Right = 0
        ParentColor = False
        Align = alClient
        ParentAlignmentControl = False
        TabOrder = 0
        Layout = 'table'
        LayoutAttribs.Columns = 2
        object cpTaskInfoID: TUniContainerPanel
          AlignWithMargins = True
          Left = 10
          Top = 39
          Width = 357
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
          object lTaskInfoID: TUniLabel
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
          object lTaskInfoIDValue: TUniLabel
            AlignWithMargins = True
            Left = 115
            Top = 7
            Width = 237
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
            Width = 357
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
        object cpTaskInfoName: TUniContainerPanel
          AlignWithMargins = True
          Left = 10
          Top = 79
          Width = 357
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
          object lTaskInfoName: TUniLabel
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
          object lTaskInfoNameValue: TUniLabel
            AlignWithMargins = True
            Left = 115
            Top = 7
            Width = 237
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
            Width = 357
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
        object lTaskCaption: TUniLabel
          AlignWithMargins = True
          Left = 10
          Top = 10
          Width = 357
          Height = 19
          Hint = ''
          Margins.Left = 10
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 10
          AutoSize = False
          Caption = #1044#1077#1090#1072#1083#1080' '#1079#1072#1076#1072#1095#1080
          Align = alTop
          ParentFont = False
          Font.Color = clGray
          Font.Height = -13
          Font.Style = [fsBold]
          TabOrder = 3
        end
        object cpTaskInfoCreated: TUniContainerPanel
          AlignWithMargins = True
          Left = 10
          Top = 119
          Width = 357
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
          object lTaskInfoCreated: TUniLabel
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
          object lTaskInfoCreatedValue: TUniLabel
            AlignWithMargins = True
            Left = 115
            Top = 7
            Width = 237
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
            Width = 357
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
        object cpTaskInfoUpdated: TUniContainerPanel
          AlignWithMargins = True
          Left = 10
          Top = 159
          Width = 357
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
            Width = 237
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
            Width = 357
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
  object DatasourceEntity: TDataSource
    DataSet = FDMemTableEntity
    Left = 272
    Top = 64
  end
  object FDMemTableEntity: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 384
    Top = 64
    object FDMemTableEntityName: TStringField
      FieldName = 'Name'
      Size = 256
    end
    object FDMemTableEntityCaption: TStringField
      FieldName = 'def'
      Size = 256
    end
    object FDMemTableEntityCreated: TDateTimeField
      FieldName = 'Created'
    end
    object FDMemTableEntityUpdated: TDateTimeField
      FieldName = 'Updated'
    end
    object FDMemTableEntityId: TStringField
      FieldName = 'Id'
      Size = 50
    end
  end
end
