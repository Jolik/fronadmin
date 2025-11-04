inherited ChannelEditForm: TChannelEditForm
  ClientHeight = 546
  ClientWidth = 882
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077'/'#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1082#1072#1085#1072#1083#1072'...'
  ExplicitWidth = 898
  ExplicitHeight = 585
  TextHeight = 15
  inherited pnBottom: TUniContainerPanel
    Top = 496
    Width = 882
    ExplicitTop = 496
    ExplicitWidth = 882
    inherited btnOk: TUniButton
      Left = 723
      ExplicitLeft = 723
    end
    inherited btnCancel: TUniButton
      Left = 804
      ExplicitLeft = 804
    end
  end
  inherited pnCaption: TUniContainerPanel
    Width = 882
    ExplicitWidth = 882
    inherited teCaption: TUniEdit
      Left = 90
      Width = 789
      ExplicitLeft = 90
      ExplicitWidth = 789
    end
  end
  inherited pnName: TUniContainerPanel
    Width = 882
    ExplicitWidth = 882
    inherited teName: TUniEdit
      Left = 90
      Width = 789
      ExplicitLeft = 90
      ExplicitWidth = 789
    end
  end
  inherited pnClient: TUniContainerPanel
    Width = 882
    Height = 415
    ExplicitWidth = 882
    ExplicitHeight = 415
    ScrollHeight = 415
    ScrollWidth = 882
    object panelLink: TUniPanel
      Left = 0
      Top = 0
      Width = 882
      Height = 193
      Hint = ''
      Align = alTop
      TabOrder = 1
      ShowCaption = False
      Caption = 'panelLink'
      object scrollBoxLinks: TUniScrollBox
        Left = 1
        Top = 1
        Width = 880
        Height = 191
        Hint = ''
        Align = alClient
        TabOrder = 1
      end
    end
    object UniSplitter1: TUniSplitter
      Left = 0
      Top = 193
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
      Top = 199
      Width = 882
      Height = 216
      Hint = ''
      Align = alClient
      TabOrder = 3
      Caption = 'panelQueue'
      object scrollBoxQueue: TUniScrollBox
        Left = 1
        Top = 1
        Width = 880
        Height = 214
        Hint = ''
        Align = alClient
        TabOrder = 1
      end
    end
  end
  inherited pnID: TUniContainerPanel
    Width = 882
    ExplicitWidth = 882
    inherited teID: TUniEdit
      Left = 90
      Width = 789
      ExplicitLeft = 90
      ExplicitWidth = 789
    end
  end
end
