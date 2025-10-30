unit TaskSourceUnit;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  EntityUnit;

type
  // TTaskSource .
  TTaskSource = class(TFieldSet)
  private
    FSid: string;
    FName: string;
    FEnabled: Boolean;
  public
    function Assign(ASource: TFieldSet): boolean;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    property Sid: string read FSid write FSid;
    property Name: string read FName write FName;
    property Enabled: Boolean read FEnabled write FEnabled;

  end;

type
  TTaskSourceList = class(TFieldSetList)
  class function ItemClassType: TFieldSetClass; override;
  end;

implementation

uses
  System.SysUtils,
  FuncUnit;

const
  SidKey = 'sid';
  NameKey = 'name';
  EnabledKey = 'enabled';

{ TTaskSource }

function TTaskSource.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;
  if not (ASource is TTaskSource) then exit;
  var src := ASource as TTaskSource;
  sid:= src.sid;
  name:= src.Name;
  Enabled:= src.Enabled;

  Result := true;
end;

procedure TTaskSource.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  sid := GetValueStrDef(src, SidKey, '');
  name := GetValueStrDef(src, NameKey, '');
  Enabled:= GetValueBool(src, EnabledKey);
end;

procedure TTaskSource.Serialize(dst: TJSONObject; const APropertyNames: TArray<string>);
begin
  dst.AddPair(SidKey, sid);
  dst.AddPair(NameKey, name);
  dst.AddPair(EnabledKey, Enabled);
end;

{ TTaskSourceList }

class function TTaskSourceList.ItemClassType: TFieldSetClass;
begin
  Result := TTaskSource;
end;

end.
