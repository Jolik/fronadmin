inherited TaskParentForm: TTaskParentForm
  ClientWidth = 1217
  Caption = #1047#1072#1076#1072#1095#1080
  ExplicitWidth = 1233
  TextHeight = 15
  inherited tbEntity: TUniToolBar
    Width = 1217
    ExplicitWidth = 1217
  end
  inherited dbgEntity: TUniDBGrid
    Width = 817
    Columns = <
      item
        FieldName = 'enabled'
        Title.Caption = ' '
        Width = 34
      end
      item
        FieldName = 'Name'
        Title.Caption = #1048#1084#1103
        Width = 100
      end
      item
        FieldName = 'def'
        Title.Caption = #1054#1087#1080#1089#1072#1085#1080#1077
        Width = 100
      end
      item
        FieldName = 'module'
        Title.Caption = #1052#1086#1076#1091#1083#1100
        Width = 124
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
    Left = 817
    Width = 0
    ExplicitLeft = 817
    ExplicitWidth = 0
  end
  inherited pcEntityInfo: TUniPageControl
    Left = 817
    Width = 400
    ExplicitLeft = 817
    ExplicitWidth = 400
    inherited tsTaskInfo: TUniTabSheet
      ExplicitWidth = 392
      inherited cpTaskInfo: TUniContainerPanel
        Width = 392
        ExplicitWidth = 392
        inherited cpTaskInfoID: TUniContainerPanel
          Width = 377
          ExplicitWidth = 377
          inherited lTaskInfoID: TUniLabel
            Font.Height = -13
          end
          inherited lTaskInfoIDValue: TUniLabel
            Width = 257
            Font.Height = -13
            ExplicitWidth = 257
          end
          inherited pSeparator1: TUniPanel
            Width = 377
            ExplicitWidth = 377
          end
        end
        inherited cpTaskInfoName: TUniContainerPanel
          Width = 377
          ExplicitWidth = 377
          inherited lTaskInfoName: TUniLabel
            Font.Height = -13
          end
          inherited lTaskInfoNameValue: TUniLabel
            Width = 257
            Font.Height = -13
            ExplicitWidth = 257
          end
          inherited pSeparator2: TUniPanel
            Width = 377
            ExplicitWidth = 377
          end
        end
        inherited lTaskCaption: TUniLabel
          Width = 377
          ExplicitWidth = 377
        end
        inherited cpTaskInfoCreated: TUniContainerPanel
          Top = 159
          Width = 377
          ExplicitTop = 159
          ExplicitWidth = 377
          inherited lTaskInfoCreatedValue: TUniLabel
            Width = 257
            ExplicitWidth = 257
          end
          inherited pSeparator3: TUniPanel
            Width = 377
            ExplicitWidth = 377
          end
        end
        inherited cpTaskInfoUpdated: TUniContainerPanel
          Top = 199
          Width = 377
          ExplicitTop = 199
          ExplicitWidth = 377
          inherited lTaskInfoUpdatedValue: TUniLabel
            Width = 257
            ExplicitWidth = 257
          end
          inherited pSeparator4: TUniPanel
            Width = 377
            ExplicitWidth = 377
          end
        end
        object cpTaskInfoModule: TUniContainerPanel
          AlignWithMargins = True
          Left = 10
          Top = 119
          Width = 377
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
            Width = 257
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
            Width = 377
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
    object FDMemTableEntityenabled: TBooleanField [0]
      FieldName = 'enabled'
    end
    object FDMemTableEntitymodule: TStringField [3]
      FieldName = 'module'
    end
  end
end
