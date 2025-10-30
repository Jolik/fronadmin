inherited ChannelsForm: TChannelsForm
  Caption = #1050#1072#1085#1072#1083#1099
  TextHeight = 15
  inherited tbEntity: TUniToolBar
    inherited btnNew: TUniToolButton
      OnClick = nil
    end
    inherited btnUpdate: TUniToolButton
      OnClick = nil
    end
  end
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
      end
      item
        FieldName = 'Service'
        Title.Caption = #1057#1077#1088#1074#1080#1089
        Width = 124
      end>
  end
  inherited FDMemTableEntity: TFDMemTable
    Left = 368
    object FDMemTableEntityService: TStringField
      FieldName = 'Service'
    end
  end
end
