object SourceEditForm: TSourceEditForm
  Left = 0
  Top = 0
  ClientHeight = 861
  ClientWidth = 1300
  Caption = #1048#1089#1090#1086#1095#1085#1080#1082
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  TextHeight = 15
  object pnlMain: TUniPanel
    Left = 0
    Top = 0
    Width = 1300
    Height = 819
    Hint = ''
    Align = alClient
    TabOrder = 0
    Caption = ''
    object pnlLeft: TUniScrollBox
      Left = 1
      Top = 1
      Width = 500
      Height = 817
      Hint = ''
      Align = alLeft
      TabOrder = 1
      ScrollHeight = 769
      object gbIdentification: TUniGroupBox
        Left = 0
        Top = 0
        Width = 498
        Height = 214
        Hint = ''
        Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1094#1080#1103
        Align = alTop
        TabOrder = 0
        object lblName: TUniLabel
          Left = 16
          Top = 24
          Width = 81
          Height = 13
          Hint = ''
          Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          TabOrder = 1
        end
        object edtName: TUniEdit
          Left = 180
          Top = 20
          Width = 300
          Hint = ''
          Text = ''
          TabOrder = 2
        end
        object lblSid: TUniLabel
          Left = 16
          Top = 56
          Width = 17
          Height = 13
          Hint = ''
          Caption = 'SID'
          TabOrder = 3
        end
        object edtSid: TUniEdit
          Left = 180
          Top = 52
          Width = 200
          Hint = ''
          Text = ''
          TabOrder = 4
          ReadOnly = True
        end
        object lblPid: TUniLabel
          Left = 16
          Top = 88
          Width = 120
          Height = 13
          Hint = ''
          Caption = #1042#1099#1096#1077#1089#1090#1086#1103#1097#1072#1103' '#1089#1090#1072#1085#1094#1080#1103
          TabOrder = 5
        end
        object edtPid: TUniEdit
          Left = 180
          Top = 84
          Width = 200
          Hint = ''
          Text = ''
          TabOrder = 6
        end
        object btnSelectPid: TUniButton
          Left = 385
          Top = 83
          Width = 30
          Height = 25
          Hint = ''
          Caption = '...'
          TabOrder = 7
        end
        object lblIndex: TUniLabel
          Left = 16
          Top = 120
          Width = 38
          Height = 13
          Hint = ''
          Caption = #1048#1085#1076#1077#1082#1089
          TabOrder = 8
        end
        object edtIndex: TUniEdit
          Left = 180
          Top = 116
          Width = 200
          Hint = ''
          Text = ''
          TabOrder = 9
          OnChange = edtIndexChange
        end
        object lblNumber: TUniLabel
          Left = 16
          Top = 152
          Width = 106
          Height = 13
          Hint = ''
          Caption = #1055#1086#1088#1103#1076#1082#1086#1074#1099#1081' '#1085#1086#1084#1077#1088
          TabOrder = 10
        end
        object edtNumber: TUniEdit
          Left = 180
          Top = 148
          Width = 200
          Hint = ''
          Text = ''
          TabOrder = 11
          OnChange = edtNumberChange
        end
        object lblOrgType: TUniLabel
          Left = 16
          Top = 184
          Width = 93
          Height = 13
          Hint = ''
          Caption = #1058#1080#1087' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1080
          TabOrder = 12
        end
        object cbOrgType: TUniComboBox
          Left = 180
          Top = 180
          Width = 250
          Hint = ''
          Text = ''
          TabOrder = 13
          IconItems = <>
          OnChange = cbOrgTypeChange
        end
      end
      object gbOwner: TUniGroupBox
        Left = 0
        Top = 214
        Width = 498
        Height = 87
        Hint = ''
        Caption = #1042#1083#1072#1076#1077#1083#1077#1094
        Align = alTop
        TabOrder = 1
        object lblUgms: TUniLabel
          Left = 16
          Top = 24
          Width = 28
          Height = 13
          Hint = ''
          Caption = #1059#1043#1052#1057
          TabOrder = 1
        end
        object cbUgms: TUniComboBox
          Left = 180
          Top = 20
          Width = 250
          Hint = ''
          Text = ''
          TabOrder = 2
          IconItems = <>
          OnChange = cbUgmsChange
        end
        object lblCgms: TUniLabel
          Left = 16
          Top = 56
          Width = 30
          Height = 13
          Hint = ''
          Caption = #1062#1043#1052#1057
          TabOrder = 3
        end
        object cbCgms: TUniComboBox
          Left = 180
          Top = 52
          Width = 250
          Hint = ''
          Text = ''
          TabOrder = 4
          IconItems = <>
          OnChange = cbCgmsChange
        end
      end
      object gbTerritory: TUniGroupBox
        Left = 0
        Top = 301
        Width = 498
        Height = 240
        Hint = ''
        Caption = #1058#1077#1088#1088#1080#1090#1086#1088#1080#1103
        Align = alTop
        TabOrder = 2
        object lblCountry: TUniLabel
          Left = 16
          Top = 24
          Width = 38
          Height = 13
          Hint = ''
          Caption = #1057#1090#1088#1072#1085#1072
          TabOrder = 1
        end
        object cbCountry: TUniComboBox
          Left = 180
          Top = 20
          Width = 200
          Hint = ''
          Text = ''
          TabOrder = 2
          IconItems = <>
          OnChange = cbCountryChange
        end
        object lblRegion: TUniLabel
          Left = 16
          Top = 56
          Width = 38
          Height = 13
          Hint = ''
          Caption = #1056#1077#1075#1080#1086#1085
          TabOrder = 3
        end
        object cbRegion: TUniComboBox
          Left = 180
          Top = 52
          Width = 200
          Hint = ''
          Text = ''
          TabOrder = 4
          IconItems = <>
          OnChange = cbRegionChange
        end
        object lblLat: TUniLabel
          Left = 16
          Top = 88
          Width = 43
          Height = 13
          Hint = ''
          Caption = #1064#1080#1088#1086#1090#1072
          TabOrder = 5
        end
        object edtLat: TUniEdit
          Left = 180
          Top = 84
          Width = 100
          Hint = ''
          Text = ''
          TabOrder = 6
        end
        object lblLon: TUniLabel
          Left = 16
          Top = 120
          Width = 44
          Height = 13
          Hint = ''
          Caption = #1044#1086#1083#1075#1086#1090#1072
          TabOrder = 7
        end
        object edtLon: TUniEdit
          Left = 180
          Top = 116
          Width = 100
          Hint = ''
          Text = ''
          TabOrder = 8
        end
        object lblElev: TUniLabel
          Left = 16
          Top = 152
          Width = 55
          Height = 13
          Hint = ''
          Caption = #1042#1099#1089#1086#1090#1072' ('#1084')'
          TabOrder = 9
        end
        object edtElev: TUniEdit
          Left = 180
          Top = 148
          Width = 100
          Hint = ''
          Text = ''
          TabOrder = 10
        end
        object lblTimeShift: TUniLabel
          Left = 16
          Top = 184
          Width = 125
          Height = 13
          Hint = ''
          Caption = #1042#1088#1077#1084#1077#1085#1085#1086#1081' '#1089#1076#1074#1080#1075' ('#1084#1080#1085')'
          TabOrder = 11
        end
        object edtTimeShift: TUniEdit
          Left = 180
          Top = 180
          Width = 100
          Hint = ''
          Text = ''
          TabOrder = 12
        end
        object lblMeteoRange: TUniLabel
          Left = 16
          Top = 216
          Width = 139
          Height = 13
          Hint = ''
          Caption = #1043#1088#1072#1085#1080#1094#1072' '#1084#1077#1090#1077#1086#1089#1091#1090#1086#1082' ('#1084#1080#1085')'
          TabOrder = 13
        end
        object edtMeteoRange: TUniEdit
          Left = 180
          Top = 212
          Width = 100
          Hint = ''
          Text = ''
          TabOrder = 14
        end
      end
      object gbContacts: TUniGroupBox
        Left = 0
        Top = 541
        Width = 498
        Height = 228
        Hint = ''
        Caption = #1050#1086#1085#1090#1072#1082#1090#1099
        Align = alTop
        TabOrder = 3
        object lblOrg: TUniLabel
          Left = 16
          Top = 24
          Width = 72
          Height = 13
          Hint = ''
          Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103
          TabOrder = 1
        end
        object edtOrg: TUniEdit
          Left = 180
          Top = 20
          Width = 300
          Hint = ''
          Text = ''
          TabOrder = 2
        end
        object lblDirector: TUniLabel
          Left = 16
          Top = 56
          Width = 73
          Height = 13
          Hint = ''
          Caption = #1056#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1100
          TabOrder = 3
        end
        object edtDirector: TUniEdit
          Left = 180
          Top = 52
          Width = 300
          Hint = ''
          Text = ''
          TabOrder = 4
        end
        object lblPhone: TUniLabel
          Left = 16
          Top = 88
          Width = 46
          Height = 13
          Hint = ''
          Caption = #1058#1077#1083#1077#1092#1086#1085
          TabOrder = 5
        end
        object edtPhone: TUniEdit
          Left = 180
          Top = 84
          Width = 300
          Hint = ''
          Text = ''
          TabOrder = 6
        end
        object lblEmail: TUniLabel
          Left = 16
          Top = 120
          Width = 27
          Height = 13
          Hint = ''
          Caption = 'Email'
          TabOrder = 7
        end
        object edtEmail: TUniEdit
          Left = 180
          Top = 116
          Width = 300
          Hint = ''
          Text = ''
          TabOrder = 8
        end
        object lblMail: TUniLabel
          Left = 16
          Top = 152
          Width = 88
          Height = 13
          Hint = ''
          Caption = #1055#1086#1095#1090#1086#1074#1099#1081' '#1072#1076#1088#1077#1089
          TabOrder = 9
        end
        object memMail: TUniMemo
          Left = 180
          Top = 148
          Width = 300
          Height = 69
          Hint = ''
          TabOrder = 10
        end
      end
    end
    object splMain: TUniSplitter
      Left = 501
      Top = 1
      Width = 6
      Height = 817
      Hint = ''
      Align = alLeft
      ParentColor = False
      Color = clBtnFace
    end
    object pnlRight: TUniPanel
      Left = 507
      Top = 1
      Width = 792
      Height = 817
      Hint = ''
      Align = alClient
      TabOrder = 3
      Caption = ''
      object gbContexts: TUniGroupBox
        Left = 1
        Top = 1
        Width = 790
        Height = 300
        Hint = ''
        Caption = #1050#1086#1085#1090#1077#1082#1089#1090#1099
        Align = alTop
        TabOrder = 1
        object grdContexts: TUniDBGrid
          Left = 2
          Top = 50
          Width = 786
          Height = 248
          Hint = ''
          DataSource = SourcesContextDS
          ReadOnly = True
          WebOptions.Paged = False
          WebOptions.FetchAll = True
          LoadMask.Message = 'Loading data...'
          Align = alClient
          TabOrder = 1
          OnSelectionChange = grdContextsSelectionChange
          Columns = <
            item
              FieldName = 'typeName'
              Title.Caption = #1058#1080#1087
              Width = 216
              ReadOnly = True
            end
            item
              FieldName = 'index'
              Title.Caption = #1048#1085#1076#1077#1082#1089
              Width = 124
              ReadOnly = True
            end
            item
              FieldName = 'ctxid'
              Title.Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088' '#1082#1086#1085#1090#1077#1082#1089#1090#1072
              Width = 352
              ReadOnly = True
            end>
        end
        object UniPanel1: TUniPanel
          Left = 2
          Top = 15
          Width = 786
          Height = 35
          Hint = ''
          Align = alTop
          TabOrder = 2
          Caption = ''
          object unbtnAddContext: TUniButton
            Left = 6
            Top = 4
            Width = 34
            Height = 25
            Hint = #1057#1086#1079#1076#1072#1090#1100' '#1082#1086#1085#1090#1077#1082#1089#1090
            Caption = '+'
            TabOrder = 1
            OnClick = unbtnAddContextClick
          end
          object unbtnDelContext: TUniButton
            Left = 46
            Top = 4
            Width = 34
            Height = 25
            Hint = #1059#1076#1072#1083#1080#1090#1100' '#1082#1086#1085#1090#1077#1082#1089#1090
            Enabled = False
            Caption = '-'
            TabOrder = 2
            OnClick = unbtnDelContextClick
          end
          object unbtnContextRefresh: TUniButton
            Left = 86
            Top = 4
            Width = 34
            Height = 25
            Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1082#1086#1085#1090#1077#1082#1089#1090#1086#1074
            Caption = #8634
            TabOrder = 3
            OnClick = unbtnContextRefreshClick
          end
        end
      end
      object gbInterfaces: TUniGroupBox
        Left = 1
        Top = 301
        Width = 790
        Height = 515
        Hint = ''
        Caption = #1048#1085#1090#1077#1088#1092#1077#1081#1089#1099
        Align = alClient
        TabOrder = 2
        object grdInterfaces: TUniDBGrid
          Left = 2
          Top = 50
          Width = 786
          Height = 463
          Hint = ''
          DataSource = ContextCredsDS
          ReadOnly = True
          WebOptions.Paged = False
          WebOptions.FetchAll = True
          LoadMask.Message = 'Loading data...'
          ForceFit = True
          Align = alClient
          TabOrder = 1
          OnDblClick = grdInterfacesDblClick
          Columns = <
            item
              FieldName = 'name'
              Title.Caption = ' '#1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
              Width = 175
              ReadOnly = True
            end
            item
              FieldName = 'interface'
              Title.Caption = ' '#1048#1085#1090#1077#1088#1092#1077#1081#1089
              Width = 167
              ReadOnly = True
            end
            item
              FieldName = 'login'
              Title.Caption = #1051#1086#1075#1080#1085
              Width = 124
              ReadOnly = True
            end
            item
              FieldName = 'def'
              Title.Caption = #1054#1087#1080#1089#1072#1085#1080#1077
              Width = 343
              ReadOnly = True
            end>
        end
        object unpnlCredsButtons: TUniPanel
          Left = 2
          Top = 15
          Width = 786
          Height = 35
          Hint = ''
          Align = alTop
          TabOrder = 2
          Caption = ''
          object unbtnAddCred: TUniButton
            Left = 6
            Top = 4
            Width = 34
            Height = 25
            Hint = #1057#1086#1079#1076#1072#1090#1100' '#1088#1077#1082#1074#1080#1079#1080#1090
            Enabled = False
            Caption = '+'
            TabOrder = 1
            OnClick = unbtnAddCredClick
          end
          object unbtnDeleteCred: TUniButton
            Left = 46
            Top = 3
            Width = 34
            Height = 25
            Hint = #1059#1076#1072#1083#1080#1090#1100' '#1088#1077#1082#1074#1080#1079#1080#1090
            Enabled = False
            Caption = '-'
            TabOrder = 2
            OnClick = unbtnDeleteCredClick
          end
          object unbtnCredsRefresh: TUniButton
            Left = 126
            Top = 4
            Width = 34
            Height = 25
            Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1088#1077#1082#1074#1080#1079#1080#1090#1086#1074
            Caption = #8634
            TabOrder = 3
            OnClick = unbtnCredsRefreshClick
          end
          object unbtnEditCred: TUniButton
            Left = 86
            Top = 4
            Width = 34
            Height = 25
            Hint = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1088#1077#1082#1074#1080#1079#1080#1090#1099
            Enabled = False
            Caption = #9998
            TabOrder = 4
            OnClick = unbtnCredsRefreshClick
          end
        end
      end
    end
  end
  object pnlBottom: TUniPanel
    Left = 0
    Top = 819
    Width = 1300
    Height = 42
    Hint = ''
    Align = alBottom
    TabOrder = 1
    Caption = ''
    object btnClose: TUniButton
      Left = 1218
      Top = 8
      Width = 75
      Height = 25
      Hint = ''
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 1
      OnClick = btnCloseClick
    end
    object btnSave: TUniButton
      Left = 1128
      Top = 8
      Width = 84
      Height = 25
      Hint = ''
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 2
      OnClick = btnSaveClick
    end
  end
  object ContextMem: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'typeName'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'index'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'ctxtid'
        DataType = ftString
        Size = 36
      end
      item
        Name = 'ctxid'
        DataType = ftString
        Size = 36
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
    Left = 868
    Top = 54
    object ContextMemsid: TStringField
      FieldName = 'typeName'
      Size = 100
    end
    object ContextMemname: TStringField
      FieldName = 'index'
      Size = 100
    end
    object ContextMemctxtid: TStringField
      FieldName = 'ctxtid'
      Size = 36
    end
    object ContextMemctxid: TStringField
      FieldName = 'ctxid'
      Size = 36
    end
  end
  object SourcesContextDS: TDataSource
    DataSet = ContextMem
    Left = 774
    Top = 60
  end
  object ContextCredsDS: TDataSource
    DataSet = ContextCredsMem
    Left = 702
    Top = 524
  end
  object ContextCredsMem: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'name'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'interface'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'login'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'def'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'ctxid'
        DataType = ftString
        Size = 36
      end
      item
        Name = 'lid'
        DataType = ftString
        Size = 36
      end
      item
        Name = 'crid'
        DataType = ftString
        Size = 36
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
    Left = 772
    Top = 518
    object CredMemName: TStringField
      FieldName = 'name'
      Size = 255
    end
    object CredMemIntf: TStringField
      FieldName = 'interface'
      Size = 255
    end
    object CredMemLogin: TStringField
      FieldName = 'login'
      Size = 255
    end
    object CredMemDef: TStringField
      FieldName = 'def'
      Size = 255
    end
    object ContextCredsMemctxid: TStringField
      FieldName = 'ctxid'
      Size = 36
    end
    object ContextCredsMemlid: TStringField
      FieldName = 'lid'
      Size = 36
    end
    object CredsMemCrID: TStringField
      FieldName = 'crid'
      Size = 36
    end
  end
end
