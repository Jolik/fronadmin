inherited TaskEditParentForm: TTaskEditParentForm
  ClientWidth = 1349
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077'/'#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1079#1072#1076#1072#1095#1080'...'
  ExplicitWidth = 1365
  TextHeight = 15
  inherited pnBottom: TUniContainerPanel
    Width = 1349
    ExplicitWidth = 1347
    inherited btnOk: TUniButton
      Left = 1190
      ExplicitLeft = 1188
    end
    inherited btnCancel: TUniButton
      Left = 1271
      ExplicitLeft = 1269
    end
  end
  inherited pnCaption: TUniContainerPanel
    Width = 1349
    Visible = False
    ExplicitWidth = 1347
    inherited teCaption: TUniEdit
      Left = 118
      Width = 1228
      Visible = False
      ExplicitLeft = 118
      ExplicitWidth = 1226
    end
  end
  inherited pnName: TUniContainerPanel
    Width = 1349
    Height = 30
    ExplicitWidth = 1347
    ExplicitHeight = 30
    inherited lName: TUniLabel
      Left = 24
      Top = 9
      Align = alNone
      ExplicitLeft = 24
      ExplicitTop = 9
    end
    inherited teName: TUniEdit
      Left = 118
      Top = 5
      Width = 1228
      Height = 20
      Margins.Top = 5
      Margins.Bottom = 5
      ExplicitLeft = 118
      ExplicitTop = 5
      ExplicitWidth = 1226
      ExplicitHeight = 20
    end
  end
  inherited pnClient: TUniContainerPanel
    Top = 57
    Width = 497
    Height = 411
    Align = alLeft
    ExplicitTop = 57
    ExplicitWidth = 497
    ExplicitHeight = 403
    ScrollHeight = 411
    ScrollWidth = 497
    object lTid: TUniLabel
      Left = 24
      Top = 16
      Width = 86
      Height = 13
      Hint = ''
      Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
      TabOrder = 8
    end
    object teTid: TUniEdit
      Left = 160
      Top = 12
      Width = 320
      Height = 21
      Hint = ''
      Text = ''
      TabOrder = 0
    end
    object lCompId: TUniLabel
      Left = 24
      Top = 48
      Width = 40
      Height = 13
      Hint = ''
      Caption = 'CompId'
      TabOrder = 9
    end
    object teCompId: TUniEdit
      Left = 160
      Top = 44
      Width = 320
      Height = 21
      Hint = ''
      Enabled = False
      Text = ''
      TabOrder = 1
    end
    object lDepId: TUniLabel
      Left = 24
      Top = 80
      Width = 31
      Height = 13
      Hint = ''
      Caption = 'DepId'
      TabOrder = 11
    end
    object teDepId: TUniEdit
      Left = 160
      Top = 76
      Width = 320
      Height = 21
      Hint = ''
      Enabled = False
      Text = ''
      TabOrder = 2
    end
    object lModule: TUniLabel
      Left = 24
      Top = 112
      Width = 40
      Height = 13
      Hint = ''
      Caption = #1052#1086#1076#1091#1083#1100
      TabOrder = 6
    end
    object lDef: TUniLabel
      Left = 24
      Top = 144
      Width = 54
      Height = 13
      Hint = ''
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077
      TabOrder = 7
    end
    object meDef: TUniMemo
      Left = 160
      Top = 140
      Width = 320
      Height = 64
      Hint = ''
      Lines.Strings = (
        '')
      TabOrder = 3
    end
    object cbEnabled: TUniCheckBox
      Left = 160
      Top = 212
      Width = 97
      Height = 21
      Hint = ''
      Caption = #1040#1082#1090#1080#1074#1085#1086
      TabOrder = 4
    end
    object cbModule: TUniComboBox
      Left = 160
      Top = 106
      Width = 320
      Hint = ''
      Style = csDropDownList
      Text = 'SummaryUnknown'
      Items.Strings = (
        'SummarySynop'
        'SummaryHydra'
        'SummaryCXML'
        'SummarySEBA'
        'SummaryUnknown')
      ItemIndex = 4
      TabOrder = 10
      IconItems = <>
    end
  end
  object pnCustomSettings: TUniContainerPanel [4]
    Left = 984
    Top = 57
    Width = 365
    Height = 411
    Hint = ''
    Visible = False
    ParentColor = False
    Align = alRight
    TabOrder = 4
    ExplicitLeft = 982
    ExplicitHeight = 403
  end
  object pnSources: TUniContainerPanel [5]
    Left = 497
    Top = 57
    Width = 487
    Height = 411
    Hint = ''
    ParentColor = False
    Align = alClient
    TabOrder = 5
    ExplicitWidth = 485
    ExplicitHeight = 403
    object gridSources: TUniDBGrid
      Left = 0
      Top = 34
      Width = 487
      Height = 377
      Hint = ''
      WebOptions.PageSize = 200
      LoadMask.Message = 'Loading data...'
      Align = alBottom
      TabOrder = 1
      Columns = <
        item
          FieldName = 'enabled'
          Title.Caption = #1042#1082#1083
          Width = 64
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
    object btnSourcesEdit: TUniButton
      Left = 0
      Top = 6
      Width = 120
      Height = 25
      Hint = ''
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1080#1089#1090#1086#1095#1085#1080#1082
      TabOrder = 2
      OnClick = btnSourcesEditClick
    end
    object unbtnSrcDel1: TUniButton
      Left = 126
      Top = 6
      Width = 120
      Height = 25
      Hint = ''
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1080#1089#1090#1086#1095#1085#1080#1082
      TabOrder = 3
      OnClick = unbtnSrcDel1Click
    end
  end
  object SourcesDS: TDataSource
    DataSet = SourcesMem
    Left = 606
    Top = 244
  end
  object SourcesMem: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 668
    Top = 246
    object SourcesMemenabled: TBooleanField
      FieldName = 'enabled'
    end
    object SourcesMemsid: TStringField
      FieldName = 'sid'
    end
    object SourcesMemname: TStringField
      FieldName = 'name'
    end
  end
end
