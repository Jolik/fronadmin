unit QueueSettingsUnit;


interface
uses
  System.Generics.Collections, System.JSON, SysUtils,
  FuncUnit,
  LoggingUnit,
  EntityUnit;

type

  // TQueue настройка очереди специфична€ дл€ линка
  TQueueSettings = class(TFieldSet)
  private
    FID: string;
    FDisabled: boolean;

  public
    ///  устанавливаем пол€ с другого объекта
    function Assign(ASource: TFieldSet): boolean; override;

    // эти требуют существующего правильного экземпл€ра объекта. на ошибки - эксешан
    ///  в массиве const APropertyNames передаютс€ пол€, которые необходимо использовать
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property ID: string read FID write FID;
    property Disabled: boolean read FDisabled write FDisabled;
   end;




implementation

{ TQueue }

function TQueueSettings.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;
  if not inherited Assign(ASource) then
    exit;
  if not (ASource is TQueueSettings) then
    exit;
  var src := ASource as TQueueSettings;
  ID := src.ID;
  Disabled := src.Disabled;
  Result := true;
end;

procedure TQueueSettings.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  ID := GetValueStrDef(src, 'qid', '');
  Disabled := GetValueBool(src, 'disabled');
end;

procedure TQueueSettings.Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil);
begin
  dst.AddPair('qid', ID);
  dst.AddPair('disabled', Disabled);
end;


end.
