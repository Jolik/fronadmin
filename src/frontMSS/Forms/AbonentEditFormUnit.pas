unit AbonentEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniButton,
  uniGUIBaseClasses, uniPanel, uniMemo,
  LoggingUnit,
  EntityUnit, AbonentUnit, StringUnit, uniTimer;

type
  TAbonentEditForm = class(TParentEditForm)
    lAbid: TUniLabel;
    teAbid: TUniEdit;
    lChannelName: TUniLabel;
    teChannelName: TUniEdit;
    lChannelValues: TUniLabel;
    meChannelValues: TUniMemo;
    lAttrName: TUniLabel;
    teAttrName: TUniEdit;
    lAttrValues: TUniLabel;
    meAttrValues: TUniMemo;
  private
    function Apply: Boolean; override;
    function DoCheck: Boolean; override;
    function GetAbonent: TAbonent;
  protected
    procedure SetEntity(AEntity: TFieldSet); override;
  public
    property Abonent: TAbonent read GetAbonent;
  end;

function AbonentEditForm: TAbonentEditForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, ConstsUnit;

function AbonentEditForm: TAbonentEditForm;
begin
  Result := TAbonentEditForm(UniMainModule.GetFormInstance(TAbonentEditForm));
end;

{ TAbonentEditForm }

function TAbonentEditForm.Apply: Boolean;
var
  LAbonent: TAbonent;
  Channels: TFieldSetStringList;
  Attr: TFieldSetStringList;
  Value: string;
  ChannelName: string;
  AttrName: string;
begin
  Result := inherited Apply();

  if not Result then
    Exit;

  LAbonent := GetAbonent;
  if not Assigned(LAbonent) then
    Exit(False);

  LAbonent.Abid := teAbid.Text;

  Channels := LAbonent.Channels;
  if Assigned(Channels) then
  begin
    ChannelName := Trim(teChannelName.Text);
(*!!!    if ChannelName = '' then
      ChannelName := ChannelsKey;
    Channels.Name := ChannelName;
    Channels.Values.Clear;

    for var Index := 0 to meChannelValues.Lines.Count - 1 do
    begin
      Value := Trim(meChannelValues.Lines[Index]);
      if Value <> '' then
        Channels.Values.Add(Value);
    end;
  end;

  Attr := LAbonent.Attr;
  if Assigned(Attr) then
  begin
    AttrName := Trim(teAttrName.Text);
    if AttrName = '' then
      AttrName := AttrKey;
    Attr.Name := AttrName;
    Attr.Values.Clear;

    for var Index := 0 to meAttrValues.Lines.Count - 1 do
    begin
      Value := Trim(meAttrValues.Lines[Index]);
      if Value <> '' then
        Attr.Values.Add(Value);
    end; *)
  end;

  Result := True;
end;

function TAbonentEditForm.DoCheck: Boolean;
begin
  Result := inherited DoCheck();

  if not Result then
    Exit;

  if teAbid.Text = '' then
  begin
    MessageDlg(Format(rsWarningValueNotSetInField, [lAbid.Caption]), TMsgDlgType.mtWarning, [mbOK], nil);
    Exit(False);
  end;

  Result := True;
end;

function TAbonentEditForm.GetAbonent: TAbonent;
begin
  Result := nil;

  if not (FEntity is TAbonent) then
  begin
    Log('TAbonentEditForm.GetAbonent error in FEntity type', lrtError);
    Exit;
  end;

  Result := FEntity as TAbonent;
end;

procedure TAbonentEditForm.SetEntity(AEntity: TFieldSet);
var
  LAbonent: TAbonent;
  Channels: TFieldSetStringList;
  Attr: TFieldSetStringList;
  Value: string;
begin
  if not (AEntity is TAbonent) then
  begin
    Log('TAbonentEditForm.SetEntity error in AEntity type', lrtError);
    Exit;
  end;

  try
    inherited SetEntity(AEntity);

    LAbonent := GetAbonent;
    if not Assigned(LAbonent) then
      Exit;

    teAbid.Text := LAbonent.Abid;

    Channels := LAbonent.Channels;
    meChannelValues.Lines.BeginUpdate;
(*!!!    try
      meChannelValues.Lines.Clear;
      if Assigned(Channels) then
      begin
        teChannelName.Text := Channels.Name;
        for Value in Channels.Values do
          meChannelValues.Lines.Add(Value);
      end
      else
      begin
        teChannelName.Text := '';
      end;
    finally
      meChannelValues.Lines.EndUpdate;
    end;

    Attr := LAbonent.Attr;
    meAttrValues.Lines.BeginUpdate;
    try
      meAttrValues.Lines.Clear;
      if Assigned(Attr) then
      begin
        teAttrName.Text := Attr.Name;
        for Value in Attr.Values do
          meAttrValues.Lines.Add(Value);
      end
      else
      begin
        teAttrName.Text := '';
      end;
    finally
      meAttrValues.Lines.EndUpdate;
    end; *)

  except
    Log('TAbonentEditForm.SetEntity error', lrtError);
  end;
end;

end.

