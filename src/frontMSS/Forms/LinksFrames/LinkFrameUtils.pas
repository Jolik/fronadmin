unit LinkFrameUtils;

interface
uses LinkUnit, ParentLinkSettingEditFrameUnit;


  function LinkFrameByType(lt: TLinkType): TParentLinkSettingEditFrameClass;

implementation
uses
  MainModule, uniGUIApplication,
  OpenMCEPSettingEditFrameUnit,
  SocketSpecialSettingEditFrameUnit,
  DirDownSettingEditFrameUnit,
  DirUpSettingEditFrameUnit,
  FTPCliDownLinkSettingEditFrameUnit,
  FTPCliUpLinkSettingEditFrameUnit,
  Pop3CliDownLinkSettingEditFrameUnit,
  SMTPClieUpLinkSettingEditFrameUnit,
  FTPServerDownLinkSettingEditFrameUnit,
  FTPSrvUpLinkSettingEditFrameUnit,
  SMTPSrvDownLinkSettingEditFrameUnit,
  HTTPCliDownLinkSettingEditFrameUnit,
  SebaSGSLinkSettingEditFrameUnit,
  SebaCSDLinkSettingEditFrameUnit;

function LinkFrameByType(lt: TLinkType): TParentLinkSettingEditFrameClass;
begin
  result := nil;
  case lt of
    ltDirDown: result := TDirDownSettingEditFrame;
    ltDirUp: result := TDirUpSettingEditFrame;
    ltFtpClientDown: result := TFtpCliDownLinkSettingEditFrame;
    ltFtpClientUp: result := TFTPCliUpLinkSettingEditFrame;
    ltFtpServerDown: result := TFTPServerDownLinkSettingEditFrame;
    ltFtpServerUp: result := TFTPSrvUpLinkSettingEditFrame;
    ltOpenMCEP: result := TOpenMCEPSettingEditFrame;
    ltPop3ClientDown: result := TPop3CliDownLinkSettingEditFrame;
    ltSmtpCliUp: result := TSMTPClieUpLinkSettingEditFrame;
    ltSmtpSrvDown: result := TSMTPSrvDownLinkSettingEditFrame;
    ltSocketSpecial: result := TSocketSpecialSettingEditFrame;
    ltHttpClientDown: result := THTTPCliDownLinkSettingEditFrame;
    ltSebaSgsClientDown: result := TSebaSGSLinkSettingEditFrame;
    ltSebaUsrCsdClientDown: result := TSebaCSDLinkSettingEditFrame;
    else exit;
  end;
end;


end.
