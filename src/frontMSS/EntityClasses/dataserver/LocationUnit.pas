unit LocationUnit;

interface

uses
  System.SysUtils,
  System.JSON,
  EntityUnit;

type
  // Entity that represents a location entry returned by /locations endpoints
  TLocation = class(TFieldSet)
  private
    FLocId: string;
    FName: string;
    FParentLocId: string;
    FLocGroup: string;
  public
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property LocId: string read FLocId write FLocId;
    property Name: string read FName write FName;
    property ParentLocId: string read FParentLocId write FParentLocId;
    property LocGroup: string read FLocGroup write FLocGroup;
  end;

  TLocationList = class(TFieldSetList)
  public
    class function ItemClassType: TFieldSetClass; override;
  end;

implementation

uses
  FuncUnit;

{ TLocation }

procedure TLocation.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  FLocId := GetValueStrDef(src, 'locId', '');
  FName := GetValueStrDef(src, 'name', '');
  FParentLocId := GetValueStrDef(src, 'parentLocId', '');
  FLocGroup := GetValueStrDef(src, 'locGroup', '');
end;

procedure TLocation.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  dst.AddPair('locId', FLocId);
  dst.AddPair('name', FName);
  dst.AddPair('parentLocId', FParentLocId);
  dst.AddPair('locGroup', FLocGroup);
end;

{ TLocationList }

class function TLocationList.ItemClassType: TFieldSetClass;
begin
  Result := TLocation;
end;

end.

