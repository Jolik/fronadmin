inherited ChannelEditForm: TChannelEditForm
  ClientHeight = 711
  ClientWidth = 882
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077'/'#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1082#1072#1085#1072#1083#1072'...'
  ExplicitWidth = 898
  ExplicitHeight = 750
  TextHeight = 15
  inherited pnBottom: TUniContainerPanel
    Top = 661
    Width = 882
    ExplicitTop = 653
    ExplicitWidth = 880
    inherited btnOk: TUniButton
      Left = 723
      ExplicitLeft = 721
    end
    inherited btnCancel: TUniButton
      Left = 804
      ExplicitLeft = 802
    end
  end
  inherited pnCaption: TUniContainerPanel
    Width = 882
    ExplicitWidth = 880
    inherited teCaption: TUniEdit
      Left = 86
      Width = 793
      ExplicitWidth = 793
    end
  end
  inherited pnName: TUniContainerPanel
    Width = 882
    ExplicitWidth = 880
    inherited teName: TUniEdit
      Left = 86
      Width = 793
      ExplicitWidth = 793
    end
  end
  inherited pnClient: TUniContainerPanel
    Width = 882
    Height = 580
    ExplicitWidth = 880
    ExplicitHeight = 572
    ScrollHeight = 580
    ScrollWidth = 882
    object panelLink: TUniPanel
      Left = 0
      Top = 0
      Width = 882
      Height = 321
      Hint = ''
      Align = alTop
      TabOrder = 1
      ShowCaption = False
      Caption = 'panelLink'
      object scrollBoxLinks: TUniScrollBox
        Left = 1
        Top = 1
        Width = 880
        Height = 319
        Hint = ''
        Align = alClient
        TabOrder = 1
      end
    end
    object UniSplitter1: TUniSplitter
      Left = 0
      Top = 321
      Width = 882
      Height = 6
      Cursor = crVSplit
      Hint = ''
      Align = alTop
      ParentColor = False
      Color = clBtnFace
    end
    object UniPanel2: TUniPanel
      Left = 0
      Top = 327
      Width = 882
      Height = 253
      Hint = ''
      Align = alClient
      TabOrder = 3
      Caption = 'panelQueue'
      object scrollBoxQueue: TUniScrollBox
        Left = 1
        Top = 1
        Width = 880
        Height = 251
        Hint = ''
        Align = alClient
        TabOrder = 1
      end
    end
  end
  inherited pnID: TUniContainerPanel
    Width = 882
    ExplicitWidth = 880
    inherited teID: TUniEdit
      Left = 86
      Width = 793
      ExplicitWidth = 793
    end
  end
end
