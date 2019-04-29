
{*****************************************}
{                                         }
{             FastReport v2.3             }
{              Search dialog              }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_Search;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FR_Consts;

type
  TfrPreviewSearchForm = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    OkBtn: TButton;
    CancelBtn: TButton;
    GroupBox1: TGroupBox;
    CB1: TCheckBox;
    GroupBox2: TGroupBox;
    RB1: TRadioButton;
    RB2: TRadioButton;
    procedure FormActivate(Sender: TObject);
  private
  public
  end;

implementation

{$R *.DFM}

procedure TfrPreviewSearchForm.FormActivate(Sender: TObject);
begin
  Edit1.SetFocus;
  Edit1.SelectAll;
end;

end.

