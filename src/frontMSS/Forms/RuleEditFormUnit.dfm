inherited RuleEditForm: TRuleEditForm
  Caption = #1055#1088#1072#1074#1080#1083#1086' '#1084#1072#1088#1096#1088#1091#1090#1080#1079#1072#1094#1080#1080
  TextHeight = 15
  inherited pnCaption: TUniContainerPanel
    inherited teCaption: TUniEdit
      ExplicitWidth = 724
    end
  end
  inherited pnName: TUniContainerPanel
    inherited teName: TUniEdit
      ExplicitWidth = 724
    end
  end
  inherited pnClient: TUniContainerPanel
    ExplicitWidth = 819
    ExplicitHeight = 414
    ScrollHeight = 504
    ScrollWidth = 819
    object lRuid: TUniLabel
      Left = 40
      Top = 32
      Width = 26
      Height = 13
      Hint = ''
      Caption = 'RUID'
      TabOrder = 1
    end
    object teRuid: TUniEdit
      Left = 120
      Top = 28
      Width = 185
      Hint = ''
      Text = ''
      TabOrder = 2
    end
    object lPosition: TUniLabel
      Left = 40
      Top = 72
      Width = 47
      Height = 13
      Hint = ''
      Caption = #1055#1086#1079#1080#1094#1080#1103
      TabOrder = 3
    end
    object tePosition: TUniEdit
      Left = 120
      Top = 68
      Width = 120
      Hint = ''
      Text = ''
      TabOrder = 4
    end
    object lPriority: TUniLabel
      Left = 40
      Top = 112
      Width = 59
      Height = 13
      Hint = ''
      Caption = #1055#1088#1080#1086#1088#1080#1090#1077#1090
      TabOrder = 5
    end
    object tePriority: TUniEdit
      Left = 120
      Top = 108
      Width = 120
      Hint = ''
      Text = ''
      TabOrder = 6
    end
    object chkDoubles: TUniCheckBox
      Left = 272
      Top = 68
      Width = 170
      Height = 17
      Hint = ''
      Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1076#1091#1073#1083#1080
      TabOrder = 7
    end
    object chkBreakRule: TUniCheckBox
      Left = 272
      Top = 108
      Width = 170
      Height = 17
      Hint = ''
      Caption = #1055#1088#1077#1088#1099#1074#1072#1090#1100' '#1094#1077#1087#1086#1095#1082#1091
      TabOrder = 8
    end
    object lHandlers: TUniLabel
      Left = 40
      Top = 152
      Width = 75
      Height = 13
      Hint = ''
      Caption = #1054#1073#1088#1072#1073#1086#1090#1095#1080#1082#1080
      TabOrder = 9
    end
    object meHandlers: TUniMemo
      Left = 40
      Top = 168
      Width = 240
      Height = 96
      Hint = ''
      Lines.Strings = (
        '')
      TabOrder = 10
    end
    object lChannels: TUniLabel
      Left = 312
      Top = 152
      Width = 39
      Height = 13
      Hint = ''
      Caption = #1050#1072#1085#1072#1083#1099
      TabOrder = 11
    end
    object meChannels: TUniMemo
      Left = 312
      Top = 168
      Width = 360
      Height = 96
      Hint = ''
      Lines.Strings = (
        '')
      TabOrder = 12
    end
    object lIncFilters: TUniLabel
      Left = 40
      Top = 280
      Width = 109
      Height = 13
      Hint = ''
      Caption = #1060#1080#1083#1100#1090#1088#1099' '#1074#1082#1083#1102#1095#1077#1085#1080#1103
      TabOrder = 13
    end
    object btnAddIncFilter: TUniButton
      Left = 160
      Top = 276
      Width = 120
      Height = 25
      Hint = ''
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1092#1080#1083#1100#1090#1088
      TabOrder = 14
      OnClick = btnAddIncFilterClick
    end
    object sbIncFilters: TUniScrollBox
      Left = 40
      Top = 304
      Width = 280
      Height = 200
      Hint = ''
      TabOrder = 15
    end
    object lExcFilters: TUniLabel
      Left = 344
      Top = 280
      Width = 115
      Height = 13
      Hint = ''
      Caption = #1060#1080#1083#1100#1090#1088#1099' '#1080#1089#1082#1083#1102#1095#1077#1085#1080#1103
      TabOrder = 16
    end
    object btnAddExcFilter: TUniButton
      Left = 472
      Top = 276
      Width = 120
      Height = 25
      Hint = ''
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1092#1080#1083#1100#1090#1088
      TabOrder = 17
      OnClick = btnAddExcFilterClick
    end
    object sbExcFilters: TUniScrollBox
      Left = 344
      Top = 304
      Width = 328
      Height = 200
      Hint = ''
      TabOrder = 18
    end
  end
end
