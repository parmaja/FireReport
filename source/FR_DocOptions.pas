
{*****************************************}
{                                         }
{             FastReport v2.3             }
{            Document options             }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_DocOptions;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FR_Consts, FR_Classes;

type
  TfrDocOptForm = class(TfrEditorForm)
    GroupBox1: TGroupBox;
    ComB1: TComboBox;
    CB1: TCheckBox;
    GroupBox2: TGroupBox;
    CB2: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    procedure FormActivate(Sender: TObject);
  private
  public
  end;

implementation

{$R *.DFM}

uses
  FR_Printer;

procedure TfrDocOptForm.FormActivate(Sender: TObject);
begin
  ComB1.Items.Assign(Prn.Printers);
  ComB1.ItemIndex := Prn.PrinterIndex;
end;

end.

