unit SummaryTasksHttpRequests;

interface

uses
  BaseRequests,
  APIConst;

type
  // Базовый запрос для Summary Tasks: задаёт базовый путь на сервис Summary
  TSummaryTasksRequest = class(TBaseServiceRequest)
  public
    constructor Create; override;
  end;

implementation

{ TSummaryTasksRequest }

constructor TSummaryTasksRequest.Create;
begin
  inherited Create;
  BasePath := constURLSummaryBasePath;
  URL := BasePath;
end;

end.

