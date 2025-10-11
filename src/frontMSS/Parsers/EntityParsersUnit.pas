unit EntityParsersUnit;

{
  ����������� json-TLink � ��������
}

interface

uses
  SysUtils, EntityUnit, System.Generics.Collections,
  LoggingUnit,
  LinkSocketSpecialUnit, System.JSON, FuncUnit, DateUtils,
  ConnectionUnit, LinkUnit, QueueUnit, ScheduleUnit;

type
  // TEntityParser ������ ���� entity (id name � ��)
  TEntityParser = class(TObject)
  protected
    procedure RaiseInvalidObjects(o: TObject); overload;
    procedure RaiseInvalidObjects(o1, o2: TObject); overload;

    ///  ������� ������ ������� ��� ���� ��� ��������������
    function GetIdKey: string; virtual;

  public
    // ��� ������� ������������� ����������� ���������� �������. �� ������ - �������
    procedure Parse(src: TJSONValue; dst: TEntity); overload; virtual;
    procedure Serialize(src: TEntity; dst: TJSONValue); overload; virtual;

    // ��� ���� ������� ������ � � ������ ������ ������ nil � ������� � ������
    function Parse(src: TJSONValue): TEntity; overload; virtual;
    function Serialize(src: TEntity): TJSONValue; overload; virtual;
  end;

  // ������ ������� ��������� �����������
  TEntityListParser = class(TObject)
  protected
  public
    // ��� ������� ������������� ����������� ���������� ������. �� ������ - �������
    procedure ParseList(src: TJSONValue; dst: TEntityList); overload; virtual; abstract;
    procedure SerializeList(src: TEntityList; dst: TJSONValue); overload; virtual; abstract;

    // ��� ���� ������� ������ � � ������ ������ ������ nil � ������� � ������
    function ParseList(src: TJSONValue): TEntityList; overload; virtual; abstract;
    function SerializeList(src: TEntityList): TJSONValue; overload; virtual; abstract;

  end;


implementation

{ TEntityParser }

procedure TEntityParser.RaiseInvalidObjects(o1, o2: TObject);
begin
  raise exception.CreateFmt('invalid objects input: %s %s', [ClassNameSafe(o1), ClassNameSafe(o2)]);
end;

procedure TEntityParser.RaiseInvalidObjects(o: TObject);
begin
  raise exception.CreateFmt('invalid object type: %s', [ClassNameSafe(o)]);
end;


function TEntityParser.GetIdKey: string;
begin
  ///  �� ��������� ���������� id
  Result := 'id';
end;

function TEntityParser.Parse(src: TJSONValue): TEntity;
begin
  Result := TEntity.Create;
  try
    Parse(src, Result);
  except on e:exception do
    begin
      Log('TEntityParser.Parse '+ e.Message, lrtError);
      FreeAndNil(Result);
    end;
  end;
end;

procedure TEntityParser.Parse(src: TJSONValue; dst: TEntity);
begin
  dst.Id := GetValueStrDef(src, GetIdKey, '');
  dst.Name := GetValueStrDef(src, 'name', '');
  dst.Caption := GetValueStrDef(src, 'caption', '');
  dst.CompId := GetValueStrDef(src, 'compid', '');
  dst.DepId := GetValueStrDef(src, 'depid', '');
  dst.Def := GetValueStrDef(src, 'def', '');
  dst.Enabled := GetValueBool(src, 'enabled');
  dst.Created := UnixToDateTime(GetValueIntDef(src, 'created', 0));
  dst.Updated := UnixToDateTime(GetValueIntDef(src, 'updated', 0))
end;

function TEntityParser.Serialize(src: TEntity): TJSONValue;
begin
  result := TJSONObject.Create;
  try
    Serialize(src, result);
  except on e:exception do
    begin
      Log('TEntityParser.Serialize '+ e.Message, lrtError);
      FreeAndNil(result);
    end;
  end;
end;

procedure TEntityParser.Serialize(src: TEntity; dst: TJSONValue);
begin
  var d := (dst as TJSONObject);
  d.AddPair('lid', src.Id);
  d.AddPair('name', src.Name);
  d.AddPair('caption', src.Caption);
  d.AddPair('created', DateTimeToUnix(src.Created));
  d.AddPair('updated', DateTimeToUnix(src.Updated));
end;



end.
