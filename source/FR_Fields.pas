{*****************************************}
{                                         }
{             FastReport v2.3             }
{               Fields list               }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_Fields;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FR_Utils, FR_Classes;

type
  TfrFieldsForm = class(TfrEditorForm)
    ValCombo: TComboBox;
    ValList: TListBox;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure ValComboClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure ValListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ValListDblClick(Sender: TObject);
  private
    { Private declarations }
    procedure FillValCombo;
  public
    DBField: String;
  end;

implementation

{$R *.DFM}

uses
  FR_Consts, DB;

var
  LastDB: String;

procedure TfrFieldsForm.ValListDblClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrFieldsForm.ValListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Return then ModalResult := mrOk;
end;

procedure TfrFieldsForm.FillValCombo;
var
  s: TStringList;
begin
  s := TStringList.Create;             
  frGetComponents(frDesigner.Report.Owner, TDataSet, s, nil, frDesigner.Report.WholeDatasources);
  s.Sort;
  ValCombo.Items.Assign(s);
  s.Free;
end;

procedure TfrFieldsForm.ValComboClick(Sender: TObject);
var
  DataSet: TDataSet;
begin
  ValList.Items.Clear;
  DataSet := frGetDataSet(frDesigner.Report.Owner, ValCombo.Items[ValCombo.ItemIndex]);
  if DataSet <> nil then
  try
    frGetFieldNames(DataSet, ValList.Items);
  except
  end;
end;

procedure TfrFieldsForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Escape then
    ModalResult := mrCancel;
end;

procedure TfrFieldsForm.FormActivate(Sender: TObject);
begin
  FillValCombo;
  if ValCombo.Items.IndexOf(LastDB) <> -1 then
    ValCombo.ItemIndex := ValCombo.Items.IndexOf(LastDB) else
    ValCombo.ItemIndex := 0;
  ValComboClick(nil);
end;

procedure TfrFieldsForm.FormDeactivate(Sender: TObject);
begin
  LastDB := ValCombo.Items[ValCombo.ItemIndex];
  if ValList.ItemIndex <> -1 then
    DBField := {LastDB + '.'}'"' + ValList.Items[ValList.ItemIndex] + '"';
end;

end.
