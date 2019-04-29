
{*****************************************}
{                                         }
{             FastReport v2.3             }
{          Insert fields dialog           }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_InsertFields;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DB, FR_Classes;

type
  TfrInsertFieldsForm = class(TfrEditorForm)
    FieldsL: TListBox;
    DatasetCB: TComboBox;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    HorzRB: TRadioButton;
    VertRB: TRadioButton;
    Button1: TButton;
    Button2: TButton;
    GroupBox2: TGroupBox;
    HeaderCB: TCheckBox;
    BandCB: TCheckBox;
    procedure DatasetCBChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure GetFields;
  public
    DataSet: TDataSet;
  end;

implementation

uses
  FR_Consts, FR_Utils;

{$R *.DFM}

procedure TfrInsertFieldsForm.FormShow(Sender: TObject);
begin
  DataSet := nil;
  frGetComponents(frDesigner.Report.Owner, TDataSet, DatasetCB.Items, nil);
  if DatasetCB.Items.Count > 0 then
    DatasetCB.ItemIndex := 0;
  GetFields;
end;

procedure TfrInsertFieldsForm.DatasetCBChange(Sender: TObject);
begin
  GetFields;
end;

procedure TfrInsertFieldsForm.GetFields;
begin
  FieldsL.Items.Clear;
  DataSet := frGetDataSet(frDesigner.Report.Owner, DatasetCB.Items[DatasetCB.ItemIndex]);
  if DataSet <> nil then
    frGetFieldNames(DataSet, FieldsL.Items);
end;

end.

