object InterfaceModalForm: TInterfaceModalForm
  Left = 0
  Top = 0
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077'/'#1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1080#1085#1090#1077#1088#1092#1077#1081#1089#1072
  ClientHeight = 360
  ClientWidth = 500
  BorderStyle = bsDialog
  Position = poScreenCenter
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlFooter: TUniPanel
    Align = alBottom
    Height = 56
    Caption = ''
    TabOrder = 100
    object btnClose: TUniButton
      Left = 16
      Top = 12
      Width = 120
      Height = 32
      Caption = #1054#1090#1084#1077#1085#1072
      Hint = #1047#1072#1082#1088#1099#1090#1100' '#1073#1077#1079' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1103
      ShowHint = True
      Anchors = [akLeft, akBottom]
    end
    object btnSave: TUniButton
      Left = 360
      Top = 12
      Width = 120
      Height = 32
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
      ShowHint = True
      Anchors = [akRight, akBottom]
    end
  end
  object pnlBody: TUniPanel
    Align = alClient
    Caption = ''
    TabOrder = 0
    object lblType: TUniLabel
      Left = 16
      Top = 20
      Caption = #1058#1080#1087
      AutoSize = True
    end
    object cbLink: TUniComboBox
      Left = 160
      Top = 16
      Width = 324
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      Style = csDropDownList
      TabOrder = 1
      Hint = #1048#1085#1090#1077#1088#1092#1077#1081#1089' '#1087#1088#1080#1085#1072#1076#1083#1077#1078#1080#1090#1089#1103' '#1074' '#1086#1090#1074#1077#1090#1077'links/list'
      ShowHint = True
    end
    object lblName: TUniLabel
      Left = 16
      Top = 60
      Caption = #1048#1084#1103':'
      AutoSize = True
    end
    object edName: TUniEdit
      Left = 160
      Top = 56
      Width = 324
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
    end
    object lblLogin: TUniLabel
      Left = 16
      Top = 100
      Caption = #1051#1086#1075#1080#1085':'
      AutoSize = True
    end
    object edLogin: TUniEdit
      Left = 160
      Top = 96
      Width = 324
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
    end
    object lblPass: TUniLabel
      Left = 16
      Top = 140
      Caption = #1055#1072#1088#1086#1083#1100':'
      AutoSize = True
    end
    object edPass: TUniEdit
      Left = 160
      Top = 136
      Width = 324
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      PasswordChar = '*'
      TabOrder = 4
    end
    object lblDef: TUniLabel
      Left = 16
      Top = 180
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      AutoSize = True
    end
    object mmDef: TUniMemo
      Left = 160
      Top = 176
      Width = 324
      Height = 120
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 5
      ScrollBars = ssVertical
    end
  end
end
