inherited StripTasksForm: TStripTasksForm
  Caption = #1047#1072#1076#1072#1095#1080
  TextHeight = 15
  inherited pcEntityInfo: TUniPageControl
    inherited tsTaskInfo: TUniTabSheet
      inherited cpTaskInfo: TUniContainerPanel
        inherited cpTaskInfoCreated: TUniContainerPanel
          Top = 159
          ExplicitLeft = 10
          ExplicitTop = 119
        end
        inherited cpTaskInfoUpdated: TUniContainerPanel
          Top = 199
          ExplicitLeft = 10
          ExplicitTop = 159
        end
        object cpTaskInfoModule: TUniContainerPanel
          AlignWithMargins = True
          Left = 10
          Top = 119
          Width = 355
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
          ExplicitLeft = 14
          ExplicitTop = 131
          object lTaskInfoModule: TUniLabel
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
            Caption = #1052#1086#1076#1091#1083#1100
            Align = alLeft
            ParentFont = False
            Font.Style = [fsBold]
            TabOrder = 1
          end
          object lTaskInfoModuleValue: TUniLabel
            AlignWithMargins = True
            Left = 115
            Top = 7
            Width = 235
            Height = 20
            Hint = ''
            Margins.Left = 5
            Margins.Top = 7
            Margins.Right = 5
            Margins.Bottom = 7
            AutoSize = False
            Caption = 'ID'
            Align = alClient
            ParentFont = False
            TabOrder = 2
          end
          object pSeparator5: TUniPanel
            AlignWithMargins = True
            Left = 0
            Top = 34
            Width = 355
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
  inherited DatasourceEntity: TDataSource
    Left = 270
    Top = 84
  end
  inherited FDMemTableEntity: TFDMemTable
    Left = 428
    Top = 70
  end
end
