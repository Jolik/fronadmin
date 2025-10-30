object ParentEditForm: TParentEditForm
  Left = 0
  Top = 0
  ClientHeight = 518
  ClientWidth = 819
  Caption = 'ParentEditForm'
  OnShow = UniFormShow
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  TextHeight = 15
  object pnBottom: TUniContainerPanel
    Left = 0
    Top = 468
    Width = 819
    Height = 50
    Hint = ''
    ParentColor = False
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 460
    ExplicitWidth = 817
    object btnOk: TUniButton
      AlignWithMargins = True
      Left = 660
      Top = 12
      Width = 75
      Height = 26
      Hint = ''
      Margins.Top = 12
      Margins.Bottom = 12
      Caption = #1054#1050
      Align = alRight
      TabOrder = 1
      OnClick = btnOkClick
      ExplicitLeft = 658
    end
    object btnCancel: TUniButton
      AlignWithMargins = True
      Left = 741
      Top = 12
      Width = 75
      Height = 26
      Hint = ''
      Margins.Top = 12
      Margins.Bottom = 12
      Caption = #1054#1090#1084#1077#1085#1072
      Align = alRight
      TabOrder = 2
      OnClick = btnCancelClick
      ExplicitLeft = 739
    end
  end
  object pnCaption: TUniContainerPanel
    Left = 0
    Top = 0
    Width = 819
    Height = 27
    Hint = ''
    ParentColor = False
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 817
    object lCaption: TUniLabel
      AlignWithMargins = True
      Left = 3
      Top = 5
      Width = 46
      Height = 13
      Hint = ''
      Margins.Top = 5
      Margins.Right = 10
      Margins.Bottom = 5
      Caption = #1055#1086#1076#1087#1080#1089#1100
      Align = alLeft
      ParentFont = False
      TabOrder = 1
    end
    object teCaption: TUniEdit
      AlignWithMargins = True
      Left = 84
      Top = 3
      Width = 732
      Height = 21
      Hint = ''
      Text = ''
      Align = alRight
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 2
      ExplicitWidth = 730
    end
  end
  object pnName: TUniContainerPanel
    Left = 0
    Top = 27
    Width = 819
    Height = 27
    Hint = ''
    ParentColor = False
    Align = alTop
    TabOrder = 2
    ExplicitWidth = 817
    object lName: TUniLabel
      AlignWithMargins = True
      Left = 3
      Top = 5
      Width = 24
      Height = 13
      Hint = ''
      Margins.Top = 5
      Margins.Right = 10
      Margins.Bottom = 5
      Caption = #1048#1084#1103
      Align = alLeft
      ParentFont = False
      Font.Style = [fsBold]
      TabOrder = 1
    end
    object teName: TUniEdit
      AlignWithMargins = True
      Left = 84
      Top = 3
      Width = 732
      Height = 21
      Hint = ''
      Text = ''
      Align = alRight
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 2
      ExplicitWidth = 730
    end
  end
  object pnClient: TUniContainerPanel
    Left = 0
    Top = 54
    Width = 819
    Height = 414
    Hint = ''
    ParentColor = False
    Align = alClient
    AutoScroll = True
    TabOrder = 3
    ExplicitWidth = 817
    ExplicitHeight = 406
    ScrollHeight = 414
    ScrollWidth = 819
  end
  object UniTimer1: TUniTimer
    Interval = 1
    Enabled = False
    RunOnce = True
    ClientEvent.Strings = (
      'function(sender)'
      '{'
      ' '
      '}')
    OnTimer = UniTimer1Timer
    Left = 648
    Top = 342
  end
end
