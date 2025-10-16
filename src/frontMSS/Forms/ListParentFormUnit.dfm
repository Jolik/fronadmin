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
      ExplicitTop = 1
    end
  end
  object dbgEntity: TUniDBGrid
    Left = 0
    Top = 29
    Width = 776
    Height = 538
    Hint = ''
    DataSource = DatasourceEntity
    LoadMask.Message = 'Loading data...'
    ForceFit = True
    Align = alClient
    TabOrder = 1
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
    Left = 776
    Top = 29
    Width = 6
    Height = 538
    Hint = ''
    Align = alRight
    ParentColor = False
    Color = clBtnFace
  end
  object pcEntityInfo: TUniPageControl
    Left = 782
    Top = 29
    Width = 378
    Height = 538
    Hint = ''
    Align = alRight
    TabOrder = 3
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
    Left = 296
    Top = 64
    object FDMemTableEntityName: TStringField
      FieldName = 'Name'
      Size = 256
    end
    object FDMemTableEntityCaption: TStringField
      FieldName = 'Caption'
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
