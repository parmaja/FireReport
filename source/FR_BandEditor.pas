
{*****************************************}
{                                         }
{             FastReport v2.3             }
{     Select Band datasource dialog       }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_BandEditor;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, FR_Classes;

type
  TfrBandEditorForm = class(TfrObjEditorForm)
    Button1: TButton;
    Button2: TButton;
    GB1: TGroupBox;
    Label2: TLabel;
    CB1: TComboBox;
    Edit1: TEdit;
    procedure CB1Click(Sender: TObject);
  private
    procedure FillCombo;
  public
    procedure ShowEditor(t: TfrView); override;
  end;

implementation

{$R *.DFM}

uses FR_Dataset, FR_Consts, FR_Utils;

procedure TfrBandEditorForm.ShowEditor(t: TfrView);
var
  i: Integer;
  s: String;
begin
  FillCombo;
  s := (t as TfrBandView).DataSet;
  if (s <> '') and (s[1] in ['1'..'9']) then
  begin
    i := 1;
    Edit1.Text := s;
  end
  else
  begin
    i := CB1.Items.IndexOf(s);
    if i = -1 then
      i := CB1.Items.IndexOf('[None]');
  end;
  CB1.ItemIndex := i;
  CB1Click(nil);
  if ShowModal = mrOk then
  begin
    frDesigner.BeforeChange;
    if CB1.ItemIndex = 1 then
      (t as TfrBandView).DataSet := Edit1.Text else
      (t as TfrBandView).DataSet := CB1.Items[CB1.ItemIndex];
  end;
end;

procedure TfrBandEditorForm.FillCombo;
begin
  frGetComponents(frDesigner.Report.Owner, TfrDataset, CB1.Items, nil, frDesigner.Report.WholeDatasources);
  CB1.Items.Insert(0, 'Virtual Dataset');
  CB1.Items.Insert(0, '[None]');
end;

procedure TfrBandEditorForm.CB1Click(Sender: TObject);
begin
  frEnableControls([Label2, Edit1], CB1.ItemIndex = 1);
end;

end.

