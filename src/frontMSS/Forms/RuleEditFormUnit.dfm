inherited RuleEditForm: TRuleEditForm
  ClientHeight = 618
  ClientWidth = 866
  Caption = #1055#1088#1072#1074#1080#1083#1086' '#1084#1072#1088#1096#1088#1091#1090#1080#1079#1072#1094#1080#1080
  ExplicitWidth = 882
  ExplicitHeight = 657
  TextHeight = 15
  inherited pnBottom: TUniContainerPanel
    Top = 568
    Width = 866
    ExplicitTop = 568
    ExplicitWidth = 865
    inherited btnOk: TUniButton
      Left = 707
      ExplicitLeft = 706
    end
    inherited btnCancel: TUniButton
      Left = 788
      ExplicitLeft = 787
    end
  end
  inherited pnCaption: TUniContainerPanel
    Width = 866
    ExplicitWidth = 865
    inherited teCaption: TUniEdit
      Left = 84
      Width = 779
      ExplicitLeft = 84
      ExplicitWidth = 778
    end
  end
  inherited pnName: TUniContainerPanel
    Width = 866
    ExplicitWidth = 865
    inherited teName: TUniEdit
      Left = 84
      Width = 779
      ExplicitLeft = 84
      ExplicitWidth = 778
    end
  end
  inherited pnClient: TUniContainerPanel
    Width = 866
    Height = 514
    ExplicitLeft = -3
    ExplicitTop = 53
    ExplicitWidth = 865
    ExplicitHeight = 514
    ScrollHeight = 514
    ScrollWidth = 866
    object cpTop: TUniContainerPanel
      Left = 0
      Top = 0
      Width = 866
      Height = 110
      Hint = ''
      ParentColor = False
      Align = alTop
      TabOrder = 1
      object lRuid: TUniLabel
        Left = 30
        Top = 18
        Width = 26
        Height = 13
        Hint = ''
        Caption = 'RUID'
        TabOrder = 1
      end
      object lPosition: TUniLabel
        Left = 30
        Top = 48
        Width = 47
        Height = 13
        Hint = ''
        Caption = #1055#1086#1079#1080#1094#1080#1103
        TabOrder = 2
      end
      object lPriority: TUniLabel
        Left = 30
        Top = 78
        Width = 59
        Height = 13
        Hint = ''
        Caption = #1055#1088#1080#1086#1088#1080#1090#1077#1090
        TabOrder = 3
        LayoutConfig.BodyPadding = '0'
      end
      object teRuid: TUniEdit
        Left = 120
        Top = 15
        Width = 185
        Hint = ''
        Text = ''
        TabOrder = 4
      end
      object tePosition: TUniEdit
        Left = 120
        Top = 45
        Width = 120
        Hint = ''
        Text = ''
        TabOrder = 5
      end
      object tePriority: TUniEdit
        Left = 120
        Top = 75
        Width = 120
        Hint = ''
        Text = ''
        TabOrder = 6
      end
      object chkDoubles: TUniCheckBox
        Left = 272
        Top = 47
        Width = 170
        Height = 17
        Hint = ''
        Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1076#1091#1073#1083#1080
        TabOrder = 7
      end
      object chkBreakRule: TUniCheckBox
        Left = 272
        Top = 77
        Width = 170
        Height = 17
        Hint = ''
        Caption = #1055#1088#1077#1088#1099#1074#1072#1090#1100' '#1094#1077#1087#1086#1095#1082#1091
        TabOrder = 8
      end
    end
    object cpMiddle: TUniContainerPanel
      Left = 0
      Top = 110
      Width = 866
      Height = 120
      Hint = ''
      ParentColor = False
      Align = alTop
      TabOrder = 2
      ExplicitTop = 125
      ExplicitWidth = 865
      object cpMiddleLeft: TUniContainerPanel
        Left = 0
        Top = 0
        Width = 430
        Height = 120
        Hint = ''
        ParentColor = False
        Align = alLeft
        TabOrder = 1
        object lHandlers: TUniLabel
          AlignWithMargins = True
          Left = 30
          Top = 3
          Width = 75
          Height = 13
          Hint = ''
          Margins.Left = 30
          Margins.Right = 10
          Caption = #1054#1073#1088#1072#1073#1086#1090#1095#1080#1082#1080
          Align = alTop
          TabOrder = 1
        end
        object meHandlers: TUniMemo
          AlignWithMargins = True
          Left = 30
          Top = 22
          Width = 390
          Height = 88
          Hint = ''
          Margins.Left = 30
          Margins.Right = 10
          Margins.Bottom = 10
          Lines.Strings = (
            '')
          Align = alClient
          TabOrder = 2
          ExplicitLeft = 88
          ExplicitTop = 172
          ExplicitWidth = 340
          ExplicitHeight = 96
        end
      end
      object cpMiddleRight: TUniContainerPanel
        Left = 432
        Top = 0
        Width = 434
        Height = 120
        Hint = ''
        ParentColor = False
        Align = alClient
        TabOrder = 2
        ExplicitLeft = 388
        ExplicitTop = 38
        ExplicitWidth = 477
        ExplicitHeight = 227
        object meChannels: TUniMemo
          AlignWithMargins = True
          Left = 30
          Top = 22
          Width = 394
          Height = 88
          Hint = ''
          Margins.Left = 30
          Margins.Right = 10
          Margins.Bottom = 10
          Lines.Strings = (
            '')
          Align = alClient
          TabOrder = 1
          ExplicitLeft = 38
          ExplicitTop = 54
          ExplicitWidth = 340
          ExplicitHeight = 96
        end
        object lChannels: TUniLabel
          AlignWithMargins = True
          Left = 30
          Top = 3
          Width = 39
          Height = 13
          Hint = ''
          Margins.Left = 30
          Margins.Right = 10
          Caption = #1050#1072#1085#1072#1083#1099
          Align = alTop
          TabOrder = 2
          ExplicitLeft = 38
          ExplicitTop = 29
        end
      end
      object UniSplitter1: TUniSplitter
        Left = 430
        Top = 0
        Width = 2
        Height = 120
        Hint = ''
        MinSize = 200
        Align = alLeft
        ParentColor = False
        Color = clBtnShadow
      end
    end
    object UniSplitter2: TUniSplitter
      Left = 0
      Top = 230
      Width = 866
      Height = 2
      Cursor = crVSplit
      Hint = ''
      MinSize = 200
      Align = alTop
      ParentColor = False
      Color = clBtnShadow
      ExplicitTop = 245
    end
    object cpBottom: TUniContainerPanel
      Left = 0
      Top = 232
      Width = 866
      Height = 282
      Hint = ''
      ParentColor = False
      Align = alClient
      TabOrder = 4
      ExplicitLeft = 238
      ExplicitTop = 266
      ExplicitWidth = 256
      ExplicitHeight = 128
      object cpBottomLeft: TUniContainerPanel
        Left = 0
        Top = 0
        Width = 430
        Height = 282
        Hint = ''
        ParentColor = False
        Align = alLeft
        TabOrder = 1
        ExplicitHeight = 263
        object sbIncFilters: TUniScrollBox
          AlignWithMargins = True
          Left = 30
          Top = 43
          Width = 390
          Height = 236
          Hint = ''
          Margins.Left = 30
          Margins.Right = 10
          Align = alClient
          TabOrder = 1
          ScrollDirection = sdVertical
          ExplicitLeft = 24
          ExplicitTop = 63
          ExplicitWidth = 340
          ExplicitHeight = 200
        end
        object cpBottomLeftTop: TUniContainerPanel
          AlignWithMargins = True
          Left = 0
          Top = 10
          Width = 430
          Height = 30
          Hint = ''
          Margins.Left = 0
          Margins.Top = 10
          Margins.Right = 0
          Margins.Bottom = 0
          ParentColor = False
          Align = alTop
          TabOrder = 2
          ExplicitTop = 0
          object btnAddIncFilter: TUniButton
            AlignWithMargins = True
            Left = 300
            Top = 3
            Width = 120
            Height = 24
            Hint = ''
            Margins.Right = 10
            Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1092#1080#1083#1100#1090#1088
            Align = alRight
            TabOrder = 1
            IconCls = 'add'
            OnClick = btnAddIncFilterClick
            ExplicitLeft = 244
            ExplicitTop = 44
            ExplicitHeight = 25
          end
          object lIncFilters: TUniLabel
            AlignWithMargins = True
            Left = 30
            Top = 7
            Width = 109
            Height = 13
            Hint = ''
            Margins.Left = 30
            Margins.Top = 7
            Caption = #1060#1080#1083#1100#1090#1088#1099' '#1074#1082#1083#1102#1095#1077#1085#1080#1103
            Align = alLeft
            TabOrder = 2
            ExplicitLeft = 24
            ExplicitTop = 26
          end
        end
      end
      object UniSplitter3: TUniSplitter
        Left = 430
        Top = 0
        Width = 2
        Height = 282
        Hint = ''
        MinSize = 200
        Align = alLeft
        ParentColor = False
        Color = clBtnShadow
        ExplicitHeight = 267
      end
      object cpBottomRight: TUniContainerPanel
        Left = 432
        Top = 0
        Width = 434
        Height = 282
        Hint = ''
        ParentColor = False
        Align = alClient
        TabOrder = 3
        ExplicitLeft = 456
        ExplicitTop = 36
        ExplicitWidth = 379
        ExplicitHeight = 217
        object sbExcFilters: TUniScrollBox
          AlignWithMargins = True
          Left = 30
          Top = 43
          Width = 394
          Height = 236
          Hint = ''
          Margins.Left = 30
          Margins.Right = 10
          Align = alClient
          TabOrder = 1
          ScrollDirection = sdVertical
          ExplicitLeft = 51
          ExplicitTop = 49
          ExplicitWidth = 340
          ExplicitHeight = 200
        end
        object cpBottomRightTop: TUniContainerPanel
          AlignWithMargins = True
          Left = 0
          Top = 10
          Width = 434
          Height = 30
          Hint = ''
          Margins.Left = 0
          Margins.Top = 10
          Margins.Right = 0
          Margins.Bottom = 0
          ParentColor = False
          Align = alTop
          TabOrder = 2
          ExplicitLeft = 1
          ExplicitTop = 1
          object lExcFilters: TUniLabel
            AlignWithMargins = True
            Left = 30
            Top = 7
            Width = 115
            Height = 13
            Hint = ''
            Margins.Left = 30
            Margins.Top = 7
            Caption = #1060#1080#1083#1100#1090#1088#1099' '#1080#1089#1082#1083#1102#1095#1077#1085#1080#1103
            Align = alLeft
            TabOrder = 1
            ExplicitLeft = 60
            ExplicitTop = 12
          end
          object btnAddExcFilter: TUniButton
            AlignWithMargins = True
            Left = 304
            Top = 3
            Width = 120
            Height = 24
            Hint = ''
            Margins.Right = 10
            Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1092#1080#1083#1100#1090#1088
            Align = alRight
            TabOrder = 2
            IconCls = 'add'
            OnClick = btnAddExcFilterClick
            ExplicitLeft = 259
            ExplicitTop = 0
            ExplicitHeight = 25
          end
        end
      end
    end
  end
end
