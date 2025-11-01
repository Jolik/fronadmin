unit LocationHttpRequests;

interface

uses
  System.SysUtils,
  EntityUnit,
  HttpClientUnit,
  BaseRequests,
  BaseResponses,
  LocationUnit;

type
  // Response wrapper for /locations/list
  TLocationListResponse = class(TFieldSetListResponse)
  private
    function GetLocationList: TLocationList;
  public
    constructor Create; override;
    property LocationList: TLocationList read GetLocationList;
  end;

  // GET /locations/list
  TLocationReqList = class(TReqList)
  private
    FParentLocId: string;
    procedure SetParentLocId(const Value: string);
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;

    property ParentLocId: string read FParentLocId write SetParentLocId;
  end;

implementation

{ TLocationListResponse }

constructor TLocationListResponse.Create;
begin
  inherited Create(TLocationList, 'response', 'locations');
end;

function TLocationListResponse.GetLocationList: TLocationList;
begin
  Result := FieldSetList as TLocationList;
end;

{ TLocationReqList }

class function TLocationReqList.BodyClassType: TFieldSetClass;
begin
  Result := inherited;
end;

constructor TLocationReqList.Create;
begin
  inherited Create;
  Method := mGET;
  SetEndpoint('locations/list');
end;

procedure TLocationReqList.SetParentLocId(const Value: string);
begin
  FParentLocId := Value.Trim;
  if FParentLocId.IsEmpty then
    Params.Remove('parent')
  else
    Params.AddOrSetValue('parent', FParentLocId);
end;

end.

