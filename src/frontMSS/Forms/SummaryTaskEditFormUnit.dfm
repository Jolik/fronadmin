inherited SummaryTaskEditForm: TSummaryTaskEditForm
  ClientHeight = 689
  ExplicitHeight = 728
  TextHeight = 15
  inherited pnBottom: TUniContainerPanel
    Top = 639
    ExplicitTop = 631
    inherited btnOk: TUniButton
    end
  end
  inherited pnClient: TUniContainerPanel
    Height = 582
    ExplicitHeight = 574
    ScrollHeight = 582
    ScrollWidth = 497
    inherited teTid: TUniEdit
      Left = 171
      Width = 309
      ExplicitLeft = 171
      ExplicitWidth = 309
    end
    inherited teCompId: TUniEdit
      Left = 171
      Width = 309
      ExplicitLeft = 171
      ExplicitWidth = 309
    end
    inherited teDepId: TUniEdit
      Left = 171
      Width = 309
      ExplicitLeft = 171
      ExplicitWidth = 309
    end
    inherited meDef: TUniMemo
      Left = 171
      Width = 309
      ExplicitLeft = 171
      ExplicitWidth = 309
    end
    inherited cbEnabled: TUniCheckBox
      Left = 171
      Top = 210
      ExplicitLeft = 171
      ExplicitTop = 210
    end
    inherited cbModule: TUniComboBox
      Left = 171
      Width = 309
      OnChange = cbModuleChange
      ExplicitLeft = 171
      ExplicitWidth = 309
    end
    object lLatePeriod: TUniLabel
      Left = 18
      Top = 242
      Width = 135
      Height = 13
      Hint = ''
      Caption = #1057#1086#1082#1088#1072#1097#1077#1085#1085#1099#1081' '#1079#1072#1075#1086#1083#1086#1074#1086#1082
      TabOrder = 12
    end
    object ueHeader: TUniEdit
      Left = 168
      Top = 237
      Width = 309
      Height = 21
      Hint = ''
      Text = ''
      TabOrder = 13
    end
    object uspHeaderCorr: TUniSpinEdit
      Left = 171
      Top = 298
      Width = 109
      Hint = ''
      TabOrder = 14
      FieldLabelAlign = laRight
    end
    object UniGroupBox1: TUniGroupBox
      Left = 5
      Top = 357
      Width = 487
      Height = 222
      Hint = ''
      Margins.Left = 0
      Margins.Right = 0
      Caption = #1056#1072#1089#1087#1080#1089#1072#1085#1080#1077
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 15
      ExplicitHeight = 214
      DesignSize = (
        487
        222)
      object undtMonthDays: TUniEdit
        Left = 160
        Top = 17
        Width = 115
        Height = 21
        Hint = ''
        Text = ''
        TabOrder = 1
      end
      object UniLabel5: TUniLabel
        Left = 88
        Top = 22
        Width = 66
        Height = 13
        Hint = ''
        Caption = #1044#1085#1080' '#1084#1077#1089#1103#1094#1072':'
        TabOrder = 2
      end
      object UniLabel6: TUniLabel
        Left = 88
        Top = 49
        Width = 63
        Height = 13
        Hint = ''
        Caption = #1044#1085#1080' '#1085#1077#1076#1077#1083#1080
        TabOrder = 3
      end
      object UniLabel7: TUniLabel
        Left = 77
        Top = 80
        Width = 77
        Height = 13
        Hint = ''
        Caption = #1057#1088#1086#1082#1080' '#1087#1086#1076#1072#1095#1080
        TabOrder = 4
      end
      object UniPanel1: TUniPanel
        Left = 0
        Top = 105
        Width = 475
        Height = 114
        Hint = ''
        Margins.Left = 0
        Margins.Right = 0
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 5
        Caption = ''
        ExplicitHeight = 106
        object unspndtLateEvery: TUniSpinEdit
          Left = 155
          Top = 45
          Width = 120
          Hint = ''
          TabOrder = 1
        end
        object UniLabel8: TUniLabel
          Left = 61
          Top = 47
          Width = 88
          Height = 13
          Hint = ''
          Caption = #1082#1072#1078#1076#1099#1077' X '#1089#1077#1082#1091#1085#1076
          TabOrder = 2
        end
        object UniLabel9: TUniLabel
          Left = 59
          Top = 75
          Width = 90
          Height = 13
          Hint = ''
          Caption = #1082#1072#1078#1076#1099#1077' N '#1084#1080#1085#1091#1090':'
          TabOrder = 3
        end
        object unspndtLatePeriod: TUniSpinEdit
          Left = 155
          Top = 73
          Width = 120
          Hint = ''
          TabOrder = 4
        end
        object unchckbxCheckLate: TUniCheckBox
          Left = 155
          Top = 16
          Width = 230
          Height = 17
          Hint = ''
          Caption = #1055#1088#1086#1074#1077#1088#1103#1090#1100' '#1086#1087#1086#1079#1076#1072#1074#1096#1080#1077' '#1085#1072#1073#1083#1102#1076#1077#1085#1080#1103
          TabOrder = 5
        end
      end
      object unpnlWeekDaysArr: TUniPanel
        Left = 160
        Top = 44
        Width = 177
        Height = 27
        Hint = ''
        TabOrder = 6
        Caption = ''
        object bt2: TUniSpeedButton
          Left = 26
          Top = 1
          Width = 25
          Height = 25
          Hint = ''
          Margins.Left = 5
          CreateOrder = 1
          GroupIndex = 2
          AllowAllUp = True
          Caption = #1042#1058
          Align = alLeft
          ParentColor = False
          TabOrder = 2
        end
        object bt3: TUniSpeedButton
          Left = 51
          Top = 1
          Width = 25
          Height = 25
          Hint = ''
          Margins.Left = 5
          CreateOrder = 2
          GroupIndex = 3
          AllowAllUp = True
          Caption = #1057#1056
          Align = alLeft
          ParentColor = False
          TabOrder = 3
        end
        object bt4: TUniSpeedButton
          Left = 76
          Top = 1
          Width = 25
          Height = 25
          Hint = ''
          Margins.Left = 5
          CreateOrder = 3
          GroupIndex = 4
          AllowAllUp = True
          Caption = #1063#1058
          Align = alLeft
          ParentColor = False
          TabOrder = 4
        end
        object bt5: TUniSpeedButton
          Left = 101
          Top = 1
          Width = 25
          Height = 25
          Hint = ''
          Margins.Left = 5
          CreateOrder = 4
          GroupIndex = 5
          AllowAllUp = True
          Caption = #1055#1058
          Align = alLeft
          ParentColor = False
          TabOrder = 5
        end
        object bt6: TUniSpeedButton
          Left = 126
          Top = 1
          Width = 25
          Height = 25
          Hint = ''
          Margins.Left = 5
          CreateOrder = 5
          GroupIndex = 6
          AllowAllUp = True
          Caption = #1057#1041
          Align = alLeft
          ParentColor = False
          TabOrder = 7
        end
        object bt7: TUniSpeedButton
          Left = 151
          Top = 1
          Width = 25
          Height = 25
          Hint = ''
          Margins.Left = 5
          CreateOrder = 6
          GroupIndex = 7
          AllowAllUp = True
          Caption = #1042#1057
          Align = alLeft
          ParentColor = False
          TabOrder = 6
        end
        object bt1: TUniSpeedButton
          Left = 1
          Top = 1
          Width = 25
          Height = 25
          Hint = ''
          Margins.Left = 5
          GroupIndex = 1
          Caption = #1055#1053
          Align = alLeft
          ParentColor = False
          TabOrder = 1
        end
      end
      object uncmbxTime1: TUniComboBox
        Left = 160
        Top = 77
        Width = 315
        Hint = ''
        Text = ''
        Items.Strings = (
          
            #1050#1072#1078#1076#1099#1081' '#1095#1072#1089'=00:00/+25 01:00/* 02:00/* 03:00/* 04:00/* 05:00/* 06:' +
            '00/* 07:00/* 08:00/* 09:00/* 10:00/* 11:00/* 12:00/* 13:00/* 14:' +
            '00/* 15:00/* 16:00/* 17:00/* 18:00/* 19:00/* 20:00/* 21:00/* 22:' +
            '00/* 23:00/* '
          #1057#1080#1085#1086#1087#1090#1080#1082#1072' '#1086#1089#1085#1086#1074#1085#1072#1103' (0,6,12,18)=00:00/+25 06:00/* 12:00/* 18:00/*'
          
            #1057#1080#1085#1086#1087#1090#1080#1082#1072' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' (3,9,15,21)=03:00/+25 09:00/* 15:00/* 2' +
            '1:00/*'
          
            #1057#1080#1085#1086#1087#1090#1080#1082#1072' '#1091#1095#1072#1097#1077#1085#1085#1072#1103' (0,3,6,9,12,15,18,21)=00:00/+25 03:00/* 06:0' +
            '0/* 09:00/* 12:00/* 15:00/* 18:00/* 21:00/*'
          #1042#1086#1076#1072' (8,20)=08:00/+25 20:00/*'
          
            '10-'#1084#1080#1085#1091#1090#1085#1099#1077'=00:00/+1 00:10/* 00:20/* 00:30/* 00:40/* 00:50/* 01:' +
            '00/* 01:10/* 01:20/* 01:30/* 01:40/* 01:50/*  02:00/* 02:10/* 02' +
            ':20/* 02:30/* 02:40/* 02:50/* 03:00/* 03:10/* 03:20/* 03:30/* 03' +
            ':40/* 03:50/*  04:00/* 04:10/* 04:20/* 04:30/* 04:40/* 04:50/* 0' +
            '5:00/* 05:10/* 05:20/* 05:30/* 05:40/* 05:50/*  06:00/* 06:10/* ' +
            '06:20/* 06:30/* 06:40/* 06:50/* 07:00/* 07:10/* 07:20/* 07:30/* ' +
            '07:40/* 07:50/*  08:00/* 08:10/* 08:20/* 08:30/* 08:40/* 08:50/*' +
            ' 09:00/* 09:10/* 09:20/* 09:30/* 09:40/* 09:50/*  10:00/* 10:10/' +
            '* 10:20/* 10:30/* 10:40/* 10:50/* 11:00/* 11:10/* 11:20/* 11:30/' +
            '* 11:40/* 11:50/*  12:00/* 12:10/* 12:20/* 12:30/* 12:40/* 12:50' +
            '/* 13:00/* 13:10/* 13:20/* 13:30/* 13:40/* 13:50/*  14:00/* 14:1' +
            '0/* 14:20/* 14:30/* 14:40/* 14:50/* 15:00/* 15:10/* 15:20/* 15:3' +
            '0/* 15:40/* 15:50/*  16:00/* 16:10/* 16:20/* 16:30/* 16:40/* 16:' +
            '50/* 17:00/* 17:10/* 17:20/* 17:30/* 17:40/* 17:50/*  18:00/* 18' +
            ':10/* 18:20/* 18:30/* 18:40/* 18:50/* 19:00/* 19:10/* 19:20/* 19' +
            ':30/* 19:40/* 19:50/*  20:00/* 20:10/* 20:20/* 20:30/* 20:40/* 2'
          
            '0:50/* 21:00/* 21:10/* 21:20/* 21:30/* 21:40/* 21:50/*  22:00/* ' +
            '22:10/* 22:20/* 22:30/* 22:40/* 22:50/* 23:00/* 23:10/* 23:20/* ' +
            '23:30/* 23:40/* 23:50/*')
        TabOrder = 7
        IconItems = <>
      end
    end
    object uncmbxTime: TUniComboBox
      Left = 171
      Top = 329
      Width = 109
      Hint = ''
      Text = 'uncmbxTime'
      Items.Strings = (
        #1052#1045#1057#1058#1053#1054#1045
        #1042#1057#1042' (UTC)')
      ItemIndex = 0
      TabOrder = 16
      IconItems = <>
    end
    object ueHeader2: TUniEdit
      Left = 168
      Top = 264
      Width = 309
      Height = 21
      Hint = ''
      Text = ''
      TabOrder = 17
    end
    object UniLabel1: TUniLabel
      Left = 18
      Top = 267
      Width = 144
      Height = 13
      Hint = ''
      Caption = #1057#1086#1082#1088#1072#1097#1077#1085#1085#1099#1081' '#1079#1072#1075#1086#1083#1086#1074#1086#1082' 2'
      TabOrder = 18
    end
    object UniLabel2: TUniLabel
      Left = 18
      Top = 296
      Width = 147
      Height = 45
      Hint = ''
      AutoSize = False
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1074#1088#1077#1084#1077#1085#1080' '#1089#1086#1082#1088#1072#1097#1077#1085#1085#1086#1075#1086' '#1079#1072#1075#1086#1083#1086#1074#1082#1072':'
      TabOrder = 19
    end
    object UniLabel3: TUniLabel
      Left = 18
      Top = 336
      Width = 115
      Height = 13
      Hint = ''
      Caption = #1048#1089#1087#1086#1083#1100#1079#1091#1077#1084#1086#1077' '#1074#1088#1077#1084#1103':'
      TabOrder = 20
    end
  end
  inherited pnCustomSettings: TUniContainerPanel
    Height = 582
    ExplicitHeight = 574
  end
  inherited pnSources: TUniContainerPanel
    Height = 582
    ExplicitHeight = 574
    inherited gridSources: TUniDBGrid
      Height = 548
      Anchors = [akLeft, akTop, akRight, akBottom]
    end
    inherited btnSourcesEdit: TUniButton
      Left = 6
      ExplicitLeft = 6
    end
  end
end
