unit SourceTypesHttpRequests;

interface

uses
  System.SysUtils, System.JSON,
  EntityUnit, HttpClientUnit, BaseRequests, BaseResponses,
  SourceTypeUnit;

type
  TSourceTypeListResponse = class(TListResponse)
  private
    FSrcTypes: TSourceTypeList;
    function GetSourceTypeList: TSourceTypeList;
  protected
    procedure SetResponse(const Value: string); override;
  public
    constructor Create;
    destructor Destroy; override;
    property SourceTypeList: TSourceTypeList read GetSourceTypeList;
  end;

  TSourceTypeReqList = class(TReqList)
  protected
    class function BodyClassType: TFieldSetClass; override;
  public
    constructor Create; override;
  end;

implementation

{ TSourceTypeListResponse }

constructor TSourceTypeListResponse.Create;
begin
  // Pass a dummy entity list class; we parse into our own field-set list
  inherited Create(TEntityList, 'response', 'srctypes');
  FSrcTypes := TSourceTypeList.Create;
end;

destructor TSourceTypeListResponse.Destroy;
begin
  FSrcTypes.Free;
  inherited;
end;

function TSourceTypeListResponse.GetSourceTypeList: TSourceTypeList;
begin
  Result := FSrcTypes;
end;

procedure TSourceTypeListResponse.SetResponse(const Value: string);
var
  JSONResult: TJSONObject;
  RootObject: TJSONObject;
  TypesValue: TJSONValue;
  ItemsArray: TJSONArray;
begin
  inherited SetResponse(Value);
  FSrcTypes.Clear;

  if Value.Trim.IsEmpty then Exit;

  JSONResult := TJSONObject.ParseJSONValue(Value) as TJSONObject;
  try
    if not Assigned(JSONResult) then Exit;

    RootObject := JSONResult.GetValue('response') as TJSONObject;
    if not Assigned(RootObject) then Exit;

    TypesValue := RootObject.GetValue('srctypes');
    ItemsArray := nil;

    if TypesValue is TJSONArray then
      ItemsArray := TJSONArray(TypesValue)
    else if TypesValue is TJSONObject then
      ItemsArray := TJSONObject(TypesValue).GetValue('items') as TJSONArray;

      if Assigned(ItemsArray) then
        FSrcTypes.ParseList(ItemsArray);
  finally
    JSONResult.Free;
  end;
end;

{ Requests }

class function TSourceTypeReqList.BodyClassType: TFieldSetClass;
begin
  Result := TReqListBody;
end;

constructor TSourceTypeReqList.Create;
begin
  inherited Create;
  SetEndpoint('sources/types/list');
end;

end.
