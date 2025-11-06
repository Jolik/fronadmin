object ContextCreateForm: TContextCreateForm
  Left = 0
  Top = 0
  ClientHeight = 200
  ClientWidth = 420
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077'/'#1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1082#1086#1085#1090#1077#1082#1089#1090#1072
  BorderStyle = bsDialog
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  TextHeight = 15
  object pnlBody: TUniPanel
    Left = 0
    Top = 0
    Width = 420
    Height = 152
    Hint = ''
    Align = alClient
    TabOrder = 0
    Caption = ''
    ExplicitWidth = 418
    ExplicitHeight = 144
    object lblType: TUniLabel
      Left = 16
      Top = 20
      Width = 22
      Height = 13
      Hint = ''
      Caption = #1058#1080#1087':'
      TabOrder = 3
    end
    object cbType: TUniComboBox
      Left = 120
      Top = 16
      Width = 280
      Height = 24
      Hint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1090#1080#1087' '#1082#1086#1085#1090#1077#1082#1089#1090#1072
      ShowHint = True
      ParentShowHint = False
      Style = csDropDownList
      Text = ''
      TabOrder = 1
      IconItems = <>
    end
    object lblIndex: TUniLabel
      Left = 16
      Top = 60
      Width = 41
      Height = 13
      Hint = ''
      Caption = #1048#1085#1076#1077#1082#1089':'
      TabOrder = 4
    end
    object edIndex: TUniEdit
      Left = 120
      Top = 56
      Width = 280
      Height = 24
      Hint = ''
      Text = ''
      TabOrder = 2
    end
  end
  object pnlFooter: TUniPanel
    Left = 0
    Top = 152
    Width = 420
    Height = 48
    Hint = ''
    Align = alBottom
    TabOrder = 1
    Caption = ''
    ExplicitTop = 144
    ExplicitWidth = 418
    object btnClose: TUniButton
      Left = 16
      Top = 8
      Width = 100
      Height = 30
      Hint = ''
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 1
    end
    object btnSave: TUniButton
      Left = 300
      Top = 8
      Width = 100
      Height = 30
      Hint = ''
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 2
      OnClick = btnSaveClick
    end
  end
end
