inherited StripTasksForm: TStripTasksForm
  ExplicitLeft = 3
  ExplicitTop = 3
  ExplicitWidth = 1233
  ExplicitHeight = 606
  TextHeight = 15
  inherited tbEntity: TUniToolBar
    ExplicitWidth = 1215
  end
  inherited dbgEntity: TUniDBGrid
    OnSelectionChange = nil
  end
  inherited splSplitter: TUniSplitter
    ExplicitLeft = 815
    ExplicitHeight = 530
  end
  inherited pcEntityInfo: TUniPageControl
    ExplicitLeft = 815
    ExplicitHeight = 530
    inherited tsTaskInfo: TUniTabSheet
      ExplicitTop = 24
      ExplicitHeight = 502
      inherited cpTaskInfo: TUniContainerPanel
        ExplicitHeight = 502
        inherited cpTaskInfoModule: TUniContainerPanel
          ExplicitWidth = 377
          inherited lTaskInfoModuleValue: TUniLabel
            ExplicitWidth = 257
          end
          inherited pSeparator5: TUniPanel
            ExplicitWidth = 377
          end
        end
      end
    end
  end
end
