object InterfaceModalForm: TInterfaceModalForm
  Left = 0
  Top = 0
  ClientHeight = 360
  ClientWidth = 500
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077'/'#1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1080#1085#1090#1077#1088#1092#1077#1081#1089#1072
  BorderStyle = bsDialog
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  TextHeight = 15
  object pnlFooter: TUniPanel
    Left = 0
    Top = 304
    Width = 500
    Height = 56
    Hint = ''
    Align = alBottom
    TabOrder = 1
    Caption = ''
    ExplicitTop = 296
    ExplicitWidth = 498
    DesignSize = (
      500
      56)
    object btnClose: TUniButton
      Left = 16
      Top = 12
      Width = 120
      Height = 32
      Hint = #1047#1072#1082#1088#1099#1090#1100' '#1073#1077#1079' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1103
      ShowHint = True
      ParentShowHint = False
      Caption = #1054#1090#1084#1077#1085#1072
      Anchors = [akLeft, akBottom]
      TabOrder = 1
    end
    object btnSave: TUniButton
      Left = 358
      Top = 12
      Width = 120
      Height = 32
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
      ShowHint = True
      ParentShowHint = False
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Anchors = [akRight, akBottom]
      TabOrder = 2
      OnClick = btnSaveClick
      ExplicitLeft = 356
    end
  end
  object pnlBody: TUniPanel
    Left = 0
    Top = 0
    Width = 500
    Height = 304
    Hint = ''
    Align = alClient
    TabOrder = 0
    Caption = ''
    DesignSize = (
      500
      304)
    object lblType: TUniLabel
      Left = 16
      Top = 20
      Width = 19
      Height = 13
      Hint = ''
      Caption = #1058#1080#1087
      TabOrder = 6
    end
    object cbLink: TUniComboBox
      Left = 160
      Top = 16
      Width = 322
      Height = 24
      Hint = #1048#1085#1090#1077#1088#1092#1077#1081#1089' '#1087#1088#1080#1085#1072#1076#1083#1077#1078#1080#1090#1089#1103' '#1074' '#1086#1090#1074#1077#1090#1077'links/list'
      ShowHint = True
      ParentShowHint = False
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      IconItems = <>
      ExplicitWidth = 320
    end
    object lblName: TUniLabel
      Left = 16
      Top = 60
      Width = 25
      Height = 13
      Hint = ''
      Caption = #1048#1084#1103':'
      TabOrder = 7
    end
    object edName: TUniEdit
      Left = 160
      Top = 56
      Width = 322
      Height = 24
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      ExplicitWidth = 320
    end
    object lblLogin: TUniLabel
      Left = 16
      Top = 100
      Width = 36
      Height = 13
      Hint = ''
      Caption = #1051#1086#1075#1080#1085':'
      TabOrder = 8
    end
    object edLogin: TUniEdit
      Left = 160
      Top = 96
      Width = 322
      Height = 24
      Hint = ''
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
      ExplicitWidth = 320
    end
    object lblPass: TUniLabel
      Left = 16
      Top = 140
      Width = 43
      Height = 13
      Hint = ''
      Caption = #1055#1072#1088#1086#1083#1100':'
      TabOrder = 9
    end
    object edPass: TUniEdit
      Left = 160
      Top = 136
      Width = 322
      Height = 24
      Hint = ''
      PasswordChar = '*'
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 4
      ExplicitWidth = 320
    end
    object lblDef: TUniLabel
      Left = 16
      Top = 180
      Width = 57
      Height = 13
      Hint = ''
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      TabOrder = 10
    end
    object mmDef: TUniMemo
      Left = 160
      Top = 176
      Width = 322
      Height = 120
      Hint = ''
      ScrollBars = ssVertical
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 5
    end
  end
end
