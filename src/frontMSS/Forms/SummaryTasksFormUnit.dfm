inherited SummaryTasksForm: TSummaryTasksForm
  TextHeight = 15
  inherited pcEntityInfo: TUniPageControl
    inherited tsTaskInfo: TUniTabSheet
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
