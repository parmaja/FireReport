
{*****************************************}
{                                         }
{             FastReport v2.3             }
{             Template viewer             }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_NewReport;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, FR_Consts, FR_Classes;

type
  TfrTemplForm = class(TfrEditorForm)
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    Image1: TImage;
    Button1: TButton;
    Button2: TButton;
    LB1: TListBox;
    procedure FormActivate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure LB1DblClick(Sender: TObject);
  private
  public
    Path: String;
    TemplName: String;
  end;

implementation

uses
  FR_Design;

{$R *.DFM}

procedure TfrTemplForm.FormActivate(Sender: TObject);
var
  SearchRec: TSearchRec;
  r: Word;
begin
  if frTemplateDir = '' then
    Path := '' else
    Path := frTemplateDir + '\';
  LB1.Items.Clear;
  R := FindFirst(Path + '*.frt', faAnyFile, SearchRec);
  while R = 0 do
  begin
    if (SearchRec.Attr and faDirectory) = 0 then
      LB1.Items.Add(ChangeFileExt(SearchRec.Name, ''));
    R := FindNext(SearchRec);
  end;
  FindClose(SearchRec);
  Memo1.Lines.Clear;
  Image1.Picture.Bitmap.Assign(nil);
  Button1.Enabled := False;
end;

procedure TfrTemplForm.ListBox1Click(Sender: TObject);
begin
  Button1.Enabled := LB1.ItemIndex <> -1;
  if Button1.Enabled then
  begin
    frDesigner.Report.LoadTemplate(Path + LB1.Items[LB1.ItemIndex] + '.frt',
      Memo1.Lines, Image1.Picture.Bitmap,False);
  end;
end;

procedure TfrTemplForm.LB1DblClick(Sender: TObject);
begin
  if Button1.Enabled then ModalResult := mrOk;
end;

procedure TfrTemplForm.FormDeactivate(Sender: TObject);
begin
  if ModalResult = mrOk then
    TemplName := Path + LB1.Items[LB1.ItemIndex] + '.frt';
end;

end.

