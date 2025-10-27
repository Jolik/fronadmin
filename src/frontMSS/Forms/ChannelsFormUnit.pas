unit ChannelsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, ListParentFormUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uniPanel, uniPageControl, uniSplitter, uniBasicGrid,
  uniDBGrid, uniToolBar, uniGUIBaseClasses,
  EntityBrokerUnit,
  ParentEditFormUnit, uniLabel,
  RestBrokerBaseUnit, ChannelsRestBrokerUnit;

type
  TChannelsForm = class(TListParentForm)
  protected
    procedure Refresh(const AId: String = ''); override;
    function CreateEditForm(): TParentEditForm; override;
    function CreateRestBroker(): TRestBrokerBase; override;
  end;

function ChannelsForm: TChannelsForm;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, ChannelEditFormUnit, EntityUnit, ChannelUnit;

function ChannelsForm: TChannelsForm;
begin
  Result := TChannelsForm(UniMainModule.GetFormInstance(TChannelsForm));
end;

{ TChannelsForm }

function TChannelsForm.CreateEditForm: TParentEditForm;
begin
  Result := ChannelEditForm();
end;

procedure TChannelsForm.Refresh(const AId: String = '');
begin
  inherited Refresh(AId);
end;

function TChannelsForm.CreateRestBroker: TRestBrokerBase;
begin
  Result := TChannelsRestBroker.Create(UniMainModule.XTicket);
end;

end.
