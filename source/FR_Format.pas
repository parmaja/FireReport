
{*****************************************}
{                                         }
{             FastReport v2.3             }
{              Format editor              }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_Format;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, FR_Utils, FR_Classes;

type
  TfrFmtForm = class(TfrEditorForm)
    GroupBox2: TGroupBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Panel1: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    SplEdit: TEdit;
    Button1: TButton;
    Button2: TButton;
    Panel2: TPanel;
    Edit1: TEdit;
    Label1: TLabel;
    Edit3: TEdit;
    procedure FormActivate(Sender: TObject);
    procedure ComboBox1Click(Sender: TObject);
    procedure DesEditChange(Sender: TObject);
    procedure SplEditChange(Sender: TObject);
    procedure ComboBox2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure SplEditEnter(Sender: TObject);
    procedure ShowPanel1;
    procedure ShowPanel2;
  private
  public
    Format: Integer;
  end;

implementation

{$R *.DFM}

uses
  FR_Consts;

{$WARNINGS OFF}

procedure TfrFmtForm.FormActivate(Sender: TObject);
begin
  Panel1.Hide;
  Panel2.Hide;
  ComboBox1.Items.Clear;

  ComboBox1.Items.Add('Text');
  ComboBox1.Items.Add('Number');
  ComboBox1.Items.Add('Date');
  ComboBox1.Items.Add('Time');
  ComboBox1.Items.Add('Boolean');


  ComboBox1.ItemIndex := (Format and $0F000000) div $01000000;
  ComboBox1Change(nil);
  ComboBox2.ItemIndex := (Format and $00FF0000) div $00010000;
  ShowPanel2;
  ShowPanel1;
end;

procedure TfrFmtForm.ShowPanel1;
begin
  Panel1.Visible := (ComboBox1.ItemIndex = 1) and (not Panel2.Visible);
  if Panel1.Visible then
  begin
    Edit3.Text := IntToStr((Format and $0000FF00) div $00000100);
    SplEdit.Text := Chr(Format and $000000FF);
  end;
end;

procedure TfrFmtForm.ShowPanel2;
begin
  Panel2.Visible := ComboBox2.ItemIndex = 4;
end;

procedure TfrFmtForm.ComboBox1Change(Sender: TObject);
var
  k: Integer;
begin
  k := ComboBox1.ItemIndex;
  if k > -1 then
  begin
    ComboBox2.Items.Clear;
    case k of
      0:
      begin
        ComboBox2.Items.Add('[None]');
      end;
      1:
      begin
        ComboBox2.Items.Add('1234,5');
        ComboBox2.Items.Add('1234,50');
        ComboBox2.Items.Add('1 234,5');
        ComboBox2.Items.Add('1 234,50');
        ComboBox2.Items.Add('Custom');
      end;
      2:
      begin
        ComboBox2.Items.Add('11.15.98');
        ComboBox2.Items.Add('11.15.1998');
        ComboBox2.Items.Add('15 nov 1998');
        ComboBox2.Items.Add('15 november 1998');
        ComboBox2.Items.Add('Custom');
      end;
      3:
      begin
        ComboBox2.Items.Add('02:43:35');
        ComboBox2.Items.Add('2:43:35');
        ComboBox2.Items.Add('02:43');
        ComboBox2.Items.Add('2:43');
        ComboBox2.Items.Add('Custom');
      end;
      4:
      begin
        ComboBox2.Items.Add('0;1');
        ComboBox2.Items.Add('No;Yes');
        ComboBox2.Items.Add('_;x');
        ComboBox2.Items.Add('False;True');
        ComboBox2.Items.Add('Custom');
      end;
    end;
    ComboBox2.ItemIndex := 0;
    if Sender <> nil then
    begin
      ComboBox2Click(nil);
      ShowPanel1;
      Edit1.Text := '';
    end;
  end;
end;

procedure TfrFmtForm.ComboBox1Click(Sender: TObject);
begin
  Format := (Format and $F0FFFFFF) + ComboBox1.ItemIndex * $01000000;
end;

procedure TfrFmtForm.ComboBox2Click(Sender: TObject);
begin
  Format := (Format and $FF00FFFF) + ComboBox2.ItemIndex * $00010000;
  ShowPanel2;
  ShowPanel1;
end;

procedure TfrFmtForm.DesEditChange(Sender: TObject);
begin
  Format := (Format and $FFFF00FF) + StrToInt(Edit3.Text) * $00000100;
end;

procedure TfrFmtForm.SplEditChange(Sender: TObject);
var
  c: Char;
begin
  c := ',';
  if SplEdit.Text <> '' then c := SplEdit.Text[1];
  Format := (Format and $FFFFFF00) + Ord(c);
end;

procedure TfrFmtForm.SplEditEnter(Sender: TObject);
begin
  SplEdit.SelectAll;
end;
{$WARNINGS ON}

end.
