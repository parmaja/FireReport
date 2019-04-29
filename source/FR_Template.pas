
{*****************************************}
{                                         }
{             FastReport v2.3             }
{            New Template form            }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_Template;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, FR_Consts, FR_Classes;

type
  TfrTemplNewForm = class(TfrEditorForm)
    GroupBox2: TGroupBox;
    Panel1: TPanel;
    Image: TImage;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    OpenDialog: TOpenDialog;
    Memo: TMemo;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
  public
  end;

implementation

{$R *.DFM}

procedure TfrTemplNewForm.Button1Click(Sender: TObject);
begin
  OpenDialog.Filter := 'Bitmap file' + ' (*.bmp)|*.bmp';
  with OpenDialog do
  if Execute then
    Image.Picture.LoadFromFile(FileName);
end;

procedure TfrTemplNewForm.FormActivate(Sender: TObject);
begin
  Memo.Lines.Clear;
  Image.Picture.Assign(nil);
  Memo.SetFocus;
end;

end.

