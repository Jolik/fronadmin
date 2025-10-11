program FrontDCC;

uses
  Forms,
  ServerModule in 'ServerModule.pas' {UniServerModule: TUniGUIServerModule},
  MainModule in 'MainModule.pas' {UniMainModule: TUniGUIMainModule},
  Main in 'Main.pas' {MainForm: TUniForm},
  ChannelsFormUnit in 'ChannelsFormUnit.pas' {ChannelsForm: TUniForm},
  ChannelEditFormUnit in 'ChannelEditFormUnit.pas' {ChannelEditForm: TUniForm},
  ParentFrameUnit in 'ParentFrameUnit.pas' {ParentFrame: TUniFrame},
  LoggingUnit in 'LoggingUnit.pas',
  DirUpLinkEditFrameUnit in 'DirUpLinkEditFrameUnit.pas' {DirUpLinkEditFrame: TUniFrame},
  DirDownLinkEditFrameUnit in 'DirDownLinkEditFrameUnit.pas' {DirDownLinkEditFrame: TUniFrame},
  SharedFrameConnection in 'SharedFrameConnection.pas' {FrameConnection: TUniFrame},
  SharedFrameTextInput in 'SharedFrameTextInput.pas' {FrameTextInput: TUniFrame},
  SharedFrameIntegerInput in 'SharedFrameIntegerInput.pas' {FrameIntegerInput: TUniFrame},
  SharedFrameBoolInput in 'SharedFrameBoolInput.pas' {FrameBoolInput: TUniFrame},
  Utils in 'Utils.pas',
  FTPSRVDownFrameUnit in 'FTPSRVDownFrameUnit.pas' {FTPSRVDownFrame: TUniFrame},
  SocketSpecialFrameUnit in 'SocketSpecialFrameUnit.pas' {SocketSpecialFrame: TUniFrame},
  SharedFrameCombobox in 'SharedFrameCombobox.pas' {FrameCombobox: TUniFrame};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  TUniServerModule.Create(Application);
  Application.Run;
end.
