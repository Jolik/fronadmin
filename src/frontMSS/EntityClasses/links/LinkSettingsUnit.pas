unit LinkSettingsUnit;

interface

uses
  System.JSON,
  EntityUnit;

type
  TLinkType = (ltUnknown, ltOpenMCEP, ltSocketSpecial);

type
  ///  базовые настройки settings которые наход€тс€ в поле Data
  TDataSettings = class (TFieldSet)
  public
    // эти требуют существующего правильного экземпл€ра объекта. на ошибки - эксешан
    ///  в массиве const APropertyNames передаютс€ пол€, которые необходимо использовать
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

  end;

type
  ///  базовые настройки settings которые наход€тс€ в поле Data
  TSocketSpecialDataSettings = class (TDataSettings)
  public
    // эти требуют существующего правильного экземпл€ра объекта. на ошибки - эксешан
    ///  в массиве const APropertyNames передаютс€ пол€, которые необходимо использовать
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

  end;

type
  ///  базовые настройки settings которые наход€тс€ в поле Data
  TOpenMCEPDataSettings = class (TDataSettings)
  public
    // эти требуют существующего правильного экземпл€ра объекта. на ошибки - эксешан
    ///  в массиве const APropertyNames передаютс€ пол€, которые необходимо использовать
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

  end;

implementation

{ TDataSettings }

procedure TDataSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

end;

procedure TDataSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

end;

{ TSocketSpecialDataSettings }

procedure TSocketSpecialDataSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

end;

procedure TSocketSpecialDataSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

end;

{ TOpenMCEPDataSettings }

procedure TOpenMCEPDataSettings.Parse(src: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

end;

procedure TOpenMCEPDataSettings.Serialize(dst: TJSONObject;
  const APropertyNames: TArray<string>);
begin
  inherited;

end;

end.
