unit S3SettingsUnit;

interface
uses
  System.Generics.Collections, System.JSON, SysUtils,
  FuncUnit,
  LoggingUnit,
  EntityUnit;

type

  // TQueue настройка S3 файловой системы
  TS3Settings = class(TFieldSet)
  private
    FEnabled: boolean;
    FSecretKey: string;
    FAccessKey: string;
    FBucketName: string;
    FEndpoint: string;

  public
    function Assign(ASource: TFieldSet): boolean; override;
    procedure Parse(src: TJSONObject; const APropertyNames: TArray<string> = nil); override;
    procedure Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil); overload; override;

    property AccessKey: string read FAccessKey write FAccessKey;
    property BucketName: string read FBucketName write FBucketName;
    property Enabled: boolean read FEnabled write FEnabled;
    property Endpoint: string read FEndpoint write FEndpoint;
    property SecretKey: string read FSecretKey write FSecretKey;
   end;


implementation

{ TS3Settings }

function TS3Settings.Assign(ASource: TFieldSet): boolean;
begin
  Result := false;
  if not inherited Assign(ASource) then
    exit;
  if not (ASource is TS3Settings) then
    exit;
  var src := ASource as TS3Settings;
  AccessKey := src.AccessKey;
  BucketName := src.BucketName;
  Enabled := src.Enabled;
  Endpoint := src.Endpoint;
  SecretKey := src.SecretKey;
  Result := true;
end;

procedure TS3Settings.Parse(src: TJSONObject; const APropertyNames: TArray<string>);
begin
  AccessKey := GetValueStrDef(src, 'access_key', '');
  BucketName := GetValueStrDef(src, 'bucket_name', '');
  Enabled := GetValueBool(src, 'enabled');
  Endpoint := GetValueStrDef(src, 'endpoint', '');
  SecretKey := GetValueStrDef(src, 'secret_key', '');
end;

procedure TS3Settings.Serialize(dst: TJSONObject; const APropertyNames: TArray<string> = nil);
begin
  dst.AddPair('access_key', AccessKey);
  dst.AddPair('bucket_name', BucketName);
  dst.AddPair('enabled', Enabled);
  dst.AddPair('endpoint', Endpoint);
  dst.AddPair('secret_key', SecretKey);
end;


end.
