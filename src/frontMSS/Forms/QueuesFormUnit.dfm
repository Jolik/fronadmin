inherited QueuesForm: TQueuesForm
  Caption = #1054#1095#1077#1088#1077#1076#1080
  ExplicitWidth = 1176
  ExplicitHeight = 606
  TextHeight = 15
  inherited tbEntity: TUniToolBar
    ExplicitWidth = 1158
  end
  inherited dbgEntity: TUniDBGrid
    Columns = <
      item
        FieldName = 'Caption'
        Title.Caption = #1055#1086#1076#1087#1080#1089#1100
        Width = 160
      end
      item
        FieldName = 'Created'
        Title.Caption = #1057#1086#1079#1076#1072#1085
        Width = 112
      end
      item
        FieldName = 'Updated'
        Title.Caption = #1048#1079#1084#1077#1085#1077#1085
        Width = 112
      end>
  end
  inherited splSplitter: TUniSplitter
    ExplicitLeft = 772
    ExplicitHeight = 530
  end
  inherited pcEntityInfo: TUniPageControl
    ExplicitLeft = 778
    ExplicitHeight = 530
    inherited tsTaskInfo: TUniTabSheet
      ExplicitLeft = 4
      ExplicitTop = 24
      ExplicitWidth = 372
      ExplicitHeight = 502
      inherited cpTaskInfo: TUniContainerPanel
        ExplicitHeight = 502
        inherited cpTaskInfoID: TUniContainerPanel
          ExplicitWidth = 357
          inherited lTaskInfoIDValue: TUniLabel
            Caption = ''
            ExplicitWidth = 237
          end
          inherited pSeparator1: TUniPanel
            ExplicitWidth = 357
          end
        end
        inherited cpTaskInfoName: TUniContainerPanel
          ExplicitWidth = 357
          inherited lTaskInfoNameValue: TUniLabel
            Caption = ''
            ExplicitWidth = 237
          end
          inherited pSeparator2: TUniPanel
            ExplicitWidth = 357
          end
        end
        inherited lTaskCaption: TUniLabel
          ExplicitWidth = 357
        end
        inherited cpTaskInfoCreated: TUniContainerPanel
          ExplicitWidth = 357
          inherited lTaskInfoCreatedValue: TUniLabel
            Caption = ''
            ExplicitWidth = 237
          end
          inherited pSeparator3: TUniPanel
            ExplicitWidth = 357
          end
        end
        inherited cpTaskInfoUpdated: TUniContainerPanel
          ExplicitWidth = 357
          inherited lTaskInfoUpdatedValue: TUniLabel
            Caption = ''
            ExplicitWidth = 237
          end
          inherited pSeparator4: TUniPanel
            ExplicitWidth = 357
          end
        end
        object UniContainerPanel1: TUniContainerPanel
          AlignWithMargins = True
          Left = 10
          Top = 199
          Width = 357
          Height = 40
          Hint = ''
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          ParentColor = False
          Align = alTop
          ParentAlignmentControl = False
          TabOrder = 6
          Layout = 'table'
          LayoutAttribs.Columns = 2
          object UID: TUniLabel
            AlignWithMargins = True
            Left = 5
            Top = 7
            Width = 100
            Height = 20
            Hint = ''
            Margins.Left = 5
            Margins.Top = 7
            Margins.Right = 5
            Margins.Bottom = 7
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'uid'
            Align = alLeft
            ParentFont = False
            Font.Style = [fsBold]
            TabOrder = 1
          end
          object lQueuesUIDValue: TUniLabel
            AlignWithMargins = True
            Left = 115
            Top = 7
            Width = 237
            Height = 20
            Hint = ''
            Margins.Left = 5
            Margins.Top = 7
            Margins.Right = 5
            Margins.Bottom = 7
            AutoSize = False
            Caption = ''
            Align = alClient
            ParentFont = False
            TabOrder = 2
          end
          object UniPanel1: TUniPanel
            AlignWithMargins = True
            Left = 0
            Top = 34
            Width = 357
            Height = 1
            Hint = ''
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 5
            Align = alBottom
            TabOrder = 3
            Caption = ''
            Color = clHighlight
          end
        end
        object cpAllowPut: TUniContainerPanel
          AlignWithMargins = True
          Left = 10
          Top = 239
          Width = 357
          Height = 40
          Hint = ''
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          ParentColor = False
          Align = alTop
          ParentAlignmentControl = False
          TabOrder = 7
          Layout = 'table'
          LayoutAttribs.Columns = 2
          object lAllowPut: TUniLabel
            AlignWithMargins = True
            Left = 5
            Top = 7
            Width = 100
            Height = 20
            Hint = ''
            Margins.Left = 5
            Margins.Top = 7
            Margins.Right = 5
            Margins.Bottom = 7
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'allow_put'
            Align = alLeft
            ParentFont = False
            Font.Style = [fsBold]
            TabOrder = 1
          end
          object lAllowPutValue: TUniLabel
            AlignWithMargins = True
            Left = 115
            Top = 7
            Width = 237
            Height = 20
            Hint = ''
            Margins.Left = 5
            Margins.Top = 7
            Margins.Right = 5
            Margins.Bottom = 7
            AutoSize = False
            Caption = ''
            Align = alClient
            ParentFont = False
            TabOrder = 2
          end
          object UniPanel2: TUniPanel
            AlignWithMargins = True
            Left = 0
            Top = 34
            Width = 357
            Height = 1
            Hint = ''
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 5
            Align = alBottom
            TabOrder = 3
            Caption = ''
            Color = clHighlight
          end
        end
        object cpDoubles: TUniContainerPanel
          AlignWithMargins = True
          Left = 10
          Top = 279
          Width = 357
          Height = 40
          Hint = ''
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          ParentColor = False
          Align = alTop
          ParentAlignmentControl = False
          TabOrder = 8
          Layout = 'table'
          LayoutAttribs.Columns = 2
          object lDoubles: TUniLabel
            AlignWithMargins = True
            Left = 5
            Top = 7
            Width = 100
            Height = 20
            Hint = ''
            Margins.Left = 5
            Margins.Top = 7
            Margins.Right = 5
            Margins.Bottom = 7
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'doubles'
            Align = alLeft
            ParentFont = False
            Font.Style = [fsBold]
            TabOrder = 1
          end
          object lDoublesValue: TUniLabel
            AlignWithMargins = True
            Left = 115
            Top = 7
            Width = 237
            Height = 20
            Hint = ''
            Margins.Left = 5
            Margins.Top = 7
            Margins.Right = 5
            Margins.Bottom = 7
            AutoSize = False
            Caption = ''
            Align = alClient
            ParentFont = False
            TabOrder = 2
          end
          object UniPanel3: TUniPanel
            AlignWithMargins = True
            Left = 0
            Top = 34
            Width = 357
            Height = 1
            Hint = ''
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 5
            Align = alBottom
            TabOrder = 3
            Caption = ''
            Color = clHighlight
          end
        end
        object cpCmpid: TUniContainerPanel
          AlignWithMargins = True
          Left = 10
          Top = 319
          Width = 357
          Height = 40
          Hint = ''
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          ParentColor = False
          Align = alTop
          ParentAlignmentControl = False
          TabOrder = 9
          Layout = 'table'
          LayoutAttribs.Columns = 2
          object lCmpid: TUniLabel
            AlignWithMargins = True
            Left = 5
            Top = 7
            Width = 100
            Height = 20
            Hint = ''
            Margins.Left = 5
            Margins.Top = 7
            Margins.Right = 5
            Margins.Bottom = 7
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'cmpid'
            Align = alLeft
            ParentFont = False
            Font.Style = [fsBold]
            TabOrder = 1
          end
          object lCmpidValue: TUniLabel
            AlignWithMargins = True
            Left = 115
            Top = 7
            Width = 237
            Height = 20
            Hint = ''
            Margins.Left = 5
            Margins.Top = 7
            Margins.Right = 5
            Margins.Bottom = 7
            AutoSize = False
            Caption = ''
            Align = alClient
            ParentFont = False
            TabOrder = 2
          end
          object UniPanel4: TUniPanel
            AlignWithMargins = True
            Left = 0
            Top = 34
            Width = 357
            Height = 1
            Hint = ''
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 5
            Align = alBottom
            TabOrder = 3
            Caption = ''
            Color = clHighlight
          end
        end
        object cpCounters: TUniContainerPanel
          AlignWithMargins = True
          Left = 10
          Top = 359
          Width = 357
          Height = 40
          Hint = ''
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          ParentColor = False
          Align = alTop
          ParentAlignmentControl = False
          TabOrder = 10
          Layout = 'table'
          LayoutAttribs.Columns = 2
          object lCounters: TUniLabel
            AlignWithMargins = True
            Left = 5
            Top = 7
            Width = 100
            Height = 20
            Hint = ''
            Margins.Left = 5
            Margins.Top = 7
            Margins.Right = 5
            Margins.Bottom = 7
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'counters'
            Align = alLeft
            ParentFont = False
            Font.Style = [fsBold]
            TabOrder = 1
          end
          object lCountersValue: TUniLabel
            AlignWithMargins = True
            Left = 115
            Top = 7
            Width = 237
            Height = 20
            Hint = ''
            Margins.Left = 5
            Margins.Top = 7
            Margins.Right = 5
            Margins.Bottom = 7
            AutoSize = False
            Caption = ''
            Align = alClient
            ParentFont = False
            TabOrder = 2
          end
          object UniPanel5: TUniPanel
            AlignWithMargins = True
            Left = 0
            Top = 34
            Width = 357
            Height = 1
            Hint = ''
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 5
            Align = alBottom
            TabOrder = 3
            Caption = ''
            Color = clHighlight
          end
        end
        object cpLimits: TUniContainerPanel
          AlignWithMargins = True
          Left = 10
          Top = 399
          Width = 357
          Height = 40
          Hint = ''
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          ParentColor = False
          Align = alTop
          ParentAlignmentControl = False
          TabOrder = 11
          Layout = 'table'
          LayoutAttribs.Columns = 2
          object lLimits: TUniLabel
            AlignWithMargins = True
            Left = 5
            Top = 7
            Width = 100
            Height = 20
            Hint = ''
            Margins.Left = 5
            Margins.Top = 7
            Margins.Right = 5
            Margins.Bottom = 7
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'limits'
            Align = alLeft
            ParentFont = False
            Font.Style = [fsBold]
            TabOrder = 1
          end
          object lLimitsValue: TUniLabel
            AlignWithMargins = True
            Left = 115
            Top = 7
            Width = 237
            Height = 20
            Hint = ''
            Margins.Left = 5
            Margins.Top = 7
            Margins.Right = 5
            Margins.Bottom = 7
            AutoSize = False
            Caption = ''
            Align = alClient
            ParentFont = False
            TabOrder = 2
          end
          object UniPanel6: TUniPanel
            AlignWithMargins = True
            Left = 0
            Top = 34
            Width = 357
            Height = 1
            Hint = ''
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 5
            Align = alBottom
            TabOrder = 3
            Caption = ''
            Color = clHighlight
          end
        end
      end
    end
  end
end
