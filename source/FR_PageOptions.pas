
{*****************************************}
{                                         }
{             FastReport v2.3             }
{              Page options               }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_PageOptions;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, FR_Classes, Buttons;

type
  TfrPgoptForm = class(TfrEditorForm)
    Button1: TButton;
    Button2: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    GroupBox2: TGroupBox;
    imgLandScape: TImage;
    imgPortrait: TImage;
    RB1: TRadioButton;
    RB2: TRadioButton;
    GroupBox1: TGroupBox;
    CB1: TCheckBox;
    GroupBox3: TGroupBox;
    SizesCbo: TComboBox;
    E1: TEdit;
    E2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    GroupBox4: TGroupBox;
    CB5: TCheckBox;
    E3: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    E4: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    E5: TEdit;
    E6: TEdit;
    GroupBox5: TGroupBox;
    Label7: TLabel;
    E7: TEdit;
    Label8: TLabel;
    Edit1: TEdit;
    Panel8: TPanel;
    SB1: TSpeedButton;
    SB2: TSpeedButton;
    procedure RB1Click(Sender: TObject);
    procedure RB2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SizesCboClick(Sender: TObject);
    procedure CB5Click(Sender: TObject);
    procedure SB1Click(Sender: TObject);
    procedure SB2Click(Sender: TObject);
  private
  public
  end;

implementation

{$R *.DFM}

uses
  FR_Printer, FR_Consts, FR_Utils;

procedure TfrPgoptForm.RB1Click(Sender: TObject);
begin
  ImgPortrait.Show;
  ImgLandscape.Hide;
end;

procedure TfrPgoptForm.RB2Click(Sender: TObject);
begin
  ImgLandscape.Show;
  ImgPortrait.Hide;
end;

procedure TfrPgoptForm.FormActivate(Sender: TObject);
begin
  if RB1.Checked then RB1Click(nil) else RB2Click(nil);
  SizesCboClick(nil); CB5Click(nil);
  SizesCbo.Perform(CB_SETDROPPEDWIDTH, 200, 0);
end;

procedure TfrPgoptForm.SizesCboClick(Sender: TObject);
begin
  frEnableControls([Label1, Label2, E1, E2],
    Prn.PaperSizes[SizesCbo.ItemIndex] = $100);
end;

procedure TfrPgoptForm.CB5Click(Sender: TObject);
begin
  frEnableControls([Label3, Label4, Label5, Label6, E3, E4, E5, E6],
    not CB5.Checked);
end;

procedure TfrPgoptForm.SB1Click(Sender: TObject);
var
  i: Integer;
begin
  i := StrToInt(Edit1.Text);
  Inc(i);
  Edit1.Text := IntToStr(i);
end;

procedure TfrPgoptForm.SB2Click(Sender: TObject);
var
  i: Integer;
begin
  i := StrToInt(Edit1.Text);
  Dec(i);
  if i < 0 then i := 0;
  Edit1.Text := IntToStr(i);
end;

end.

