unit AliasEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ParentEditFormUnit, uniEdit, uniLabel, uniButton,
  uniGUIBaseClasses, uniPanel, uniMemo,
  LoggingUnit,
  EntityUnit, AliasUnit, uniTimer;

type
  TAliasEditForm = class(TParentEditForm)
    lAlid: TUniLabel;
    teAlid: TUniEdit;
    lChannelName: TUniLabel;
    teChannelName: TUniEdit;
    lChannelValues: TUniLabel;
    meChannelValues: TUniMemo;
  private
    function Apply: Boolean; override;
    function DoCheck: Boolean; override;
    function GetAlias: TAlias;
  protected
    ///
    procedure SetEntity(AEntity: TFieldSet); override;
  public
    ///    FEntity     ""
    property RouterAlias: TAlias read GetAlias;
  end;

function AliasEditForm: TAliasEditForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, ConstsUnit,
  StringUnit, System.Generics.Collections;

function AliasEditForm: TAliasEditForm;
begin
  Result := TAliasEditForm(UniMainModule.GetFormInstance(TAliasEditForm));
end;

{ TAliasEditForm }

function TAliasEditForm.Apply: Boolean;
var
  LAlias: TAlias;
  Channels: TNamedStringListsObject;
  ChannelList: TNamedStringList;
  Value: string;
begin
  Result := inherited Apply();

  if not Result then
    Exit;

  LAlias := GetAlias;
  if not Assigned(LAlias) then
  begin
    Result := False;
    Exit;
  end;

  LAlias.Alid := teAlid.Text;

  Channels := LAlias.Channels;
  if Assigned(Channels) then
  begin
    Channels.Clear;

    ChannelList := TNamedStringList.Create;
    try
      ChannelList.Name := Trim(teChannelName.Text);
      ChannelList.Values.ClearStrings;

      for var Index := 0 to meChannelValues.Lines.Count - 1 do
      begin
        Value := Trim(meChannelValues.Lines[Index]);
        if Value <> '' then
          ChannelList.Values.AddString(Value);
      end;

      if ChannelList.Name <> '' then
        Channels.Add(ChannelList)
      else
        ChannelList.Free;
    except
      ChannelList.Free;
      raise;
    end;
  end;

  Result := True;
end;

function TAliasEditForm.DoCheck: Boolean;
begin
  Result := inherited DoCheck();

  if not Result then
    Exit;

  if teAlid.Text = '' then
  begin
    MessageDlg(Format(rsWarningValueNotSetInField, [lAlid.Caption]), TMsgDlgType.mtWarning, [mbOK], nil);
    Exit(False);
  end;

  Result := True;
end;

function TAliasEditForm.GetAlias: TAlias;
begin
  Result := nil;

  if not (FEntity is TAlias) then
  begin
    Log('TAliasEditForm.GetAlias error in FEntity type', lrtError);
    Exit;
  end;

  Result := FEntity as TAlias;
end;

procedure TAliasEditForm.SetEntity(AEntity: TFieldSet);
var
  LAlias: TAlias;
  Channels: TNamedStringListsObject;
  ChannelList: TNamedStringList;
begin
  ///        -   !
  if not (AEntity is TAlias) then
  begin
    Log('TAliasEditForm.SetEntity error in AEntity type', lrtError);
    Exit;
  end;

  try
    inherited SetEntity(AEntity);

    LAlias := GetAlias;
    if not Assigned(LAlias) then
      Exit;

    teAlid.Text := LAlias.Alid;

(*!!!!    Channels := LAlias.Channels;
    if Assigned(Channels) and (Channels.Count > 0) then
    begin
      ChannelList := Channels[0];
      if Assigned(ChannelList) then
      begin
        teChannelName.Text := ChannelList.Name;

        meChannelValues.Lines.BeginUpdate;
        try
          meChannelValues.Lines.Clear;
          for var Value in ChannelList.Values.ToStringArray do
            meChannelValues.Lines.Add(Value);
        finally
          meChannelValues.Lines.EndUpdate;
        end;
      end;
    end
    else
    begin
      teChannelName.Text := '';
      meChannelValues.Lines.Clear;
    end; *)

  except
    Log('TAliasEditForm.SetEntity error', lrtError);
  end;
end;

end.

