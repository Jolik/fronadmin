object ChannelsForm: TChannelsForm
  Left = 0
  Top = 0
  ClientHeight = 461
  ClientWidth = 884
  Caption = #1050#1072#1085#1072#1083#1099
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  OnCreate = UniFormCreate
  OnDestroy = UniFormDestroy
  TextHeight = 15
  object ToolbarPanel: TUniPanel
    Left = 0
    Top = 0
    Width = 884
    Height = 40
    Hint = ''
    Align = alTop
    TabOrder = 0
    Caption = ''
    DesignSize = (
      884
      40)
    object SearchEdit: TUniEdit
      Left = 10
      Top = 8
      Width = 200
      Hint = ''
      Text = ''
      TabOrder = 1
      EmptyText = #1056#1119#1056#1109#1056#1105#1057#1027#1056#1108' '#1056#1108#1056#176#1056#1029#1056#176#1056#187#1056#1109#1056#1030'...'
    end
    object SearchButton: TUniButton
      Left = 220
      Top = 8
      Width = 70
      Height = 25
      Hint = ''
      Caption = #1053#1072#1081#1090#1080
      TabOrder = 2
      OnClick = SearchButtonClick
    end
    object AddButton: TUniButton
      Left = 300
      Top = 8
      Width = 70
      Height = 25
      Hint = ''
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 3
      OnClick = AddButtonClick
    end
    object EditButton: TUniButton
      Left = 384
      Top = 9
      Width = 70
      Height = 25
      Hint = ''
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      TabOrder = 4
      OnClick = EditButtonClick
    end
    object DeleteButton: TUniButton
      Left = 460
      Top = 8
      Width = 70
      Height = 25
      Hint = ''
      Caption = #1059#1076#1072#1083#1080#1090#1100
      TabOrder = 5
      OnClick = DeleteButtonClick
    end
    object RefreshButton: TUniButton
      Left = 540
      Top = 8
      Width = 70
      Height = 25
      Hint = ''
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      TabOrder = 6
      OnClick = RefreshButtonClick
    end
    object AutoUpdateChannelsList: TUniCheckBox
      Left = 580
      Top = 17
      Width = 118
      Height = 17
      Hint = ''
      Caption = #1040#1074#1090#1086#1086#1073#1085#1086#1074#1083#1077#1085#1080#1077
      Anchors = [akTop, akRight]
      TabOrder = 7
      ExplicitLeft = 582
    end
  end
  object MainPanel: TUniPanel
    Left = 0
    Top = 40
    Width = 884
    Height = 421
    Hint = ''
    Align = alClient
    TabOrder = 1
    Caption = ''
    ExplicitWidth = 886
    object ChannelsPanel: TUniPanel
      Left = 1
      Top = 1
      Width = 582
      Height = 419
      Hint = ''
      Align = alClient
      TabOrder = 0
      Caption = ''
      DesignSize = (
        582
        419)
      object ChannelsLabel: TUniLabel
        Left = 10
        Top = 5
        Width = 39
        Height = 13
        Hint = ''
        Caption = #1050#1072#1085#1072#1083#1099
        TabOrder = 1
      end
      object ChannelsGrid: TUniDBGrid
        Left = 5
        Top = 25
        Width = 572
        Height = 389
        Hint = ''
        DataSource = ChannelsDataSource
        LoadMask.Message = 'Loading data...'
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 2
        OnCellClick = ChannelsGridCellClick
      end
    end
    object InfoPanel: TUniPanel
      Left = 583
      Top = 1
      Width = 300
      Height = 419
      Hint = ''
      Align = alRight
      TabOrder = 1
      Caption = ''
      ExplicitLeft = 585
      DesignSize = (
        300
        419)
      object InfoLabel: TUniLabel
        Left = 10
        Top = 5
        Width = 125
        Height = 13
        Hint = ''
        Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1082#1072#1085#1072#1083#1077':'
        TabOrder = 1
      end
      object InfoMemo: TUniMemo
        Left = 5
        Top = 25
        Width = 290
        Height = 389
        Hint = ''
        Anchors = [akLeft, akTop, akRight, akBottom]
        ReadOnly = True
        TabOrder = 2
      end
    end
  end
  object ChannelsDataSource: TDataSource
    Left = 168
    Top = 112
  end
  object RefreshTimer: TUniTimer
    Enabled = False
    ClientEvent.Strings = (
      'function(sender)'
      '{'
      ' '
      '}')
    OnTimer = RefreshTimerTimer
    Left = 353
    Top = 185
  end
  object ChannelsDataSet: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 440
    Top = 240
  end
end
