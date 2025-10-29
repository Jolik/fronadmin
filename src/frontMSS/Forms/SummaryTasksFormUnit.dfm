inherited SummaryTasksForm: TSummaryTasksForm
  TextHeight = 15
  inherited dbgEntity: TUniDBGrid
    Columns = <
      item
        FieldName = 'Name'
        Title.Caption = #1048#1084#1103
        Width = 100
      end
      item
        FieldName = 'Caption'
        Title.Caption = #1055#1086#1076#1087#1080#1089#1100
        Width = 100
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
  inherited pcEntityInfo: TUniPageControl
    inherited tsTaskInfo: TUniTabSheet
      ExplicitTop = 24
      inherited cpTaskInfo: TUniContainerPanel
        object UniContainerPanel1: TUniContainerPanel
          AlignWithMargins = True
          Left = 10
          Top = 239
          Width = 377
          Height = 258
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
          object UniPanel1: TUniPanel
            AlignWithMargins = True
            Left = 0
            Top = 252
            Width = 377
            Height = 1
            Hint = ''
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 5
            Align = alBottom
            TabOrder = 1
            Caption = ''
            Color = clHighlight
          end
          object lbSettings: TUniListBox
            Left = 0
            Top = 0
            Width = 377
            Height = 252
            Hint = ''
            Align = alClient
            TabOrder = 2
          end
        end
      end
    end
  end
  inherited FDMemTableEntity: TFDMemTable
    inherited FDMemTableEntityId: TStringField [4]
    end
    inherited FDMemTableEntityCreated: TDateTimeField [5]
    end
    inherited FDMemTableEntityUpdated: TDateTimeField [6]
    end
  end
end
