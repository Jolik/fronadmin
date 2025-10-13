unit DataServerAPIUnit;

interface

uses
  BaseApiUnit;

type
  // класс для апи датасервера
  TDataServerApi = class(TBaseAPI)
  public
    constructor Create(ABaseUrl: string); override;

    // GET sources/list
    function GetSourcesList(APagesize, APage: Integer): string;

    // POST sources/list
    function PostSourcesList(APagesize, APage: Integer; ABody: string): string;
  end;


implementation

{ TDataServerApi }

constructor TDataServerApi.Create(ABaseUrl: string);
begin
  inherited;
  FApiVer := 2;
end;

function TDataServerApi.GetSourcesList(APagesize, APage: Integer): string;
var
  mURI: string;
begin
  mURI := 'sources/list';

  if APagesize > 0 then appendURI(mURI, ['pagesize', APagesize]);
  if APage > 0 then appendURI(mURI, ['page', APage]);

  Result := ExecGet(mURI);
end;

function TDataServerApi.PostSourcesList(APagesize, APage: Integer; ABody: string): string;
var
  mURI: string;
begin
  mURI := 'sources/list';

  if APagesize > 0 then appendURI(mURI, ['pagesize', APagesize]);
  if APage > 0 then appendURI(mURI, ['page', APage]);

  Result := ExecPost(mURI, ABody);
end;

end.
