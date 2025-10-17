unit TaskTypesUnit;

interface

uses
  System.JSON,
  System.Generics.Collections,
  FuncUnit,
  EntityUnit;

type
  /// <summary>Task type of the summary service.</summary>
  TTaskTypes = class(TFieldSet)
  private
    FName: string;
    FCaption: string;
  public
    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;

    property Name: string read FName write FName;
    property Caption: string read FCaption write FCaption;
  end;

  /// <summary>List of task types for the summary service.</summary>
  TTaskTypesList = class(TFieldSetList)
  private
    function GetTaskType(Index: Integer): TTaskTypes;
    procedure SetTaskType(Index: Integer; const Value: TTaskTypes);
  protected
    class function ItemClassType: TFieldSetClass; override;
  public
    property Items[Index: Integer]: TTaskTypes read GetTaskType write SetTaskType; default;
  end;

implementation

const
  NameKey = 'name';
  CaptionKey = 'caption';

{ TTaskTypes }

function TTaskTypes.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;

  if not Assigned(ASource) then
    Exit;

  if not inherited Assign(ASource) then
    Exit;

  if not (ASource is TTaskTypes) then
    Exit;

  var src := TTaskTypes(ASource);

  Name := src.Name;
  Caption := src.Caption;

  Result := true;
end;

procedure TTaskTypes.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(src) then
  begin
    Name := '';
    Caption := '';
    Exit;
  end;

  Name := GetValueStrDef(src, NameKey, '');
  Caption := GetValueStrDef(src, CaptionKey, '');
end;

procedure TTaskTypes.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  if not Assigned(dst) then
    Exit;

  dst.AddPair(NameKey, Name);
  dst.AddPair(CaptionKey, Caption);
end;

{ TTaskTypesList }

function TTaskTypesList.GetTaskType(Index: Integer): TTaskTypes;
begin
  Result := nil;

  if (Index < 0) or (Index >= Count) then
    Exit;

  if Items[Index] is TTaskTypes then
    Result := TTaskTypes(Items[Index]);
end;

class function TTaskTypesList.ItemClassType: TFieldSetClass;
begin
  Result := TTaskTypes;
end;

procedure TTaskTypesList.SetTaskType(Index: Integer; const Value: TTaskTypes);
begin
  if (Index < 0) or (Index >= Count) then
    Exit;

  if not Assigned(Value) then
    Exit;

  if not (Value is TTaskTypes) then
    Exit;

  if Assigned(Items[Index]) then
    Items[Index].Free;

  Items[Index] := Value;
end;

end.

