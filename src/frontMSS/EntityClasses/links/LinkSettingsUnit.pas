unit LinkSettingsUnit;

interface

uses
  System.JSON,
  EntityUnit;

type
  TLinkType = (ltUnknown, ltOpenMCEP, ltSocketSpecial);

type
  ///  ������� ��������� settings ������� ��������� � ���� Data
  TDataSettings = class (TFieldSet)
  public
    // ��� ������� ������������� ����������� ���������� �������. �� ������ - �������
    ///  � ������� const APropertyNames ���������� ����, ������� ���������� ������������
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

  end;

type
  ///  ������� ��������� settings ������� ��������� � ���� Data
  TSocketSpecialDataSettings = class (TDataSettings)
  public
    // ��� ������� ������������� ����������� ���������� �������. �� ������ - �������
    ///  � ������� const APropertyNames ���������� ����, ������� ���������� ������������
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

  end;

type
  ///  ������� ��������� settings ������� ��������� � ���� Data
  TOpenMCEPDataSettings = class (TDataSettings)
  public
    // ��� ������� ������������� ����������� ���������� �������. �� ������ - �������
    ///  � ������� const APropertyNames ���������� ����, ������� ���������� ������������
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
